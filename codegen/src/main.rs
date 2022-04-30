#![allow(dead_code)]
#![allow(unused_variables)]
#![feature(path_file_prefix)]

use std::{
    error::Error,
    fs::{read_dir, File, OpenOptions},
    io::{BufRead, BufReader, Write},
    path::Path, collections::HashMap,
};

use itertools::PeekingNext;

#[derive(Debug)]
struct Table {
    pub name: String,
    pub r#type: String,
}

#[derive(Debug)]
struct Function {
    pub module: String,
    pub name: String,
    pub r#type: String,
    pub args: Vec<(String, Argument)>,
}

#[derive(Debug)]
struct Argument {
    pub standard_name: String,
    pub long_name: String,
    pub units: String,
    pub dimensions: Vec<String>,
    pub r#type: String,
    pub kind: Option<String>,
    pub active: Option<String>,
    pub intent: Option<String>,
}

fn main() -> Result<(), Box<dyn Error>> {
    let paths = read_dir("../ccpp-physics/physics")?
        .map(|l| l)
        .collect::<Result<Vec<_>, _>>()?;
    let mut test_file = OpenOptions::new()
        .write(true)
        .truncate(true)
        .open("../src/functions.chpl")?;
    test_file.write_all(b"module functions {\nuse types;\nuse SysCTypes;\nuse SysBasic;\nuse CPtr;\n")?;
    for entry in paths {
        let path = entry.path();
        if let Some(extension) = path.extension() {
            if extension == "meta" {
                read_file(path.as_path(),  &mut test_file)?;
            }
        }
    }
    test_file.write_all(b"}")?;
    Ok(())
}

fn read_file(path: &Path, write_file: &mut File) -> Result<(), Box<dyn Error>> {
    let file_name = path.file_prefix().unwrap().to_str().unwrap().to_string();
    let file = File::open(path)?;
    let lines = BufReader::new(file)
        .lines()
        .map(|l| l.map(|l| l.trim().to_string()))
        .collect::<Result<Vec<_>, _>>()?;

    let mut iter = lines.iter();
    let mut module_name = None;
    loop {
        let line = match iter.next() {
            Some(l) => l,
            None => break,
        };

        if line == "[ccpp-table-properties]" {
            let name = match iter.next() {
                Some(name) => {
                    let parts = name.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                    parts[1].to_string()
                }
                None => return Err("Missing name in table properties".into()),
            };
            let r#type = match iter.next() {
                Some(name) => {
                    let parts = name.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                    parts[1].to_string()
                }
                None => return Err("Missing type in table properties".into()),
            };
            let _deps = iter.next().unwrap();
            module_name = Some(name);
        }

        if line == "[ccpp-arg-table]" {
            let name = match iter.next() {
                Some(name) => {
                    let parts = name.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                    parts[1].to_string()
                }
                None => return Err("Missing name in table properties".into()),
            };
            let r#type = match iter.next() {
                Some(name) => {
                    let parts = name.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                    parts[1].to_string()
                }
                None => return Err("Missing type in table properties".into()),
            };
            let mut args = Vec::new();

            loop {
                let line = match iter.next() {
                    Some(l) if l.contains("[") && l.contains("]") => l
                        .trim_matches(|c: char| c.is_whitespace() || c == '[' || c == ']')
                        .to_string(),
                    _ => break,
                };

                let mut parts = HashMap::new();
                loop {
                    match iter.peeking_next(|s| s.contains("=")) {
                        Some(l) => {
                            let p = l
                                .split("=")
                                .map(|s| s.trim())
                                .collect::<Vec<_>>();
                            parts.insert(p[0], p[1]);
                        },
                        _ => break
                    }
                }

                let arg = extract_args(parts)?;
                
                args.push((line, arg));
            }
            println!("{}", name);

            let function = Function {
                module: module_name.clone().unwrap(),
                name,
                r#type,
                args,
            };
            // println!("{:?}", function);
            if let Err(err) = write_function(function, write_file) {
                println!("{}", err);
            }
            print!("\n");
        }
    }

    Ok(())
}

fn extract_args(parts: HashMap<&str, &str>) -> Result<Argument, Box<dyn Error>> {
    let standard_name = parts.get("standard_name").unwrap().to_string();
    let long_name = parts.get("long_name").unwrap().to_string();
    let units = parts.get("units").unwrap().to_string();
    let dimensions = {
        let dims = parts.get("dimensions").unwrap();
        let dim_parts = dims.trim_matches(|c| c == '(' || c == ')');
        dim_parts.split(",").filter(|s| !s.is_empty()).map(|s| s.to_string()).collect()
    };
    let r#type = parts.get("type").unwrap().to_string();
    let kind = parts.get("kind").map(|s| s.to_string());
    let active = parts.get("active").map(|s| s.to_string());
    let intent = parts.get("intent").map(|s| s.to_string());

    let arg = Argument {
        standard_name,
        long_name,
        units,
        dimensions,
        r#type,
        kind,
        active,
        intent,
    };

    Ok(arg)
}

fn write_function(function: Function, file: &mut File) -> Result<(), Box<dyn Error>> {
    let mut func_str = String::from("pragma \"generate signature\" extern proc ");
    let func_name = format!("__{}_MOD_{}", function.module, function.name);
    func_str.push_str(&func_name);
    func_str.push('(');

    let mut args = Vec::new();
    for arg in function.args {
        let dimensions = arg.1.dimensions;
        let arg_type = match arg.1.r#type.as_str() {
            "character" => "c_string",
            "integer" => {
                if dimensions.is_empty() {
                    "int"
                } else {
                    "c_int"
                }
            },
            "real" => {
                if dimensions.is_empty() {
                    "real"
                } else {
                    "c_double"
                }
            },
            "logical" => "bool",
            "topflw_type" => "topflw_type",
            "sfcflw_type" => "sfcflw_type",
            e => return Err(format!("Unknown type: {}", e).into()),
        };
        let actual_type = if dimensions.is_empty() {
            arg_type.to_string()
        } else {
            format!("c_ptr({})", arg_type)
        };

        let mut arg_str = match arg.1.intent {
            Some(s) if s.eq("out") => "out ".to_string(),
            _ => {
                if actual_type.contains("c_ptr") {
                    "".to_string()
                } else {
                    "ref ".to_string()
                }
            },
        };
        arg_str.push_str(match arg.0.as_str() {
            "var" => "_var",
            "iter" => "_iter",
            e => e 
        });
        arg_str.push_str(": ");

        
        arg_str.push_str(&actual_type);
        args.push(arg_str);
    };

    func_str.push_str(&args.join(", "));
    func_str.push_str(");\n");

    file.write_all(&func_str.as_bytes())?;
    Ok(())
}
