#![allow(dead_code)]
#![allow(unused_variables)]
#![feature(path_file_prefix)]

use std::{
    error::Error,
    fs::{read_dir, File, OpenOptions},
    io::{BufRead, BufReader, Write},
    path::Path,
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
    pub dimensions: String,
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
        .open("../src/ccpp.chpl")?;
    test_file.write_all(b"module ccpp {\n")?;
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
            println!("{}", name);
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
                    Some(l) if !l.trim().is_empty() => l
                        .trim_matches(|c: char| c.is_whitespace() || c == '[' || c == ']')
                        .to_string(),
                    _ => break,
                };
                let standard_name = match iter.next() {
                    Some(standard_name) => {
                        let parts = standard_name
                            .split("=")
                            .map(|s| s.trim())
                            .collect::<Vec<_>>();
                        parts[1].to_string()
                    }
                    None => return Err("Missing standard_name in argument properties".into()),
                };
                let long_name = match iter.next() {
                    Some(long_name) => {
                        let parts = long_name.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        parts[1].to_string()
                    }
                    None => return Err("Missing long_name in argument properties".into()),
                };
                let units = match iter.next() {
                    Some(units) => {
                        let parts = units.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        parts[1].to_string()
                    }
                    None => return Err("Missing units in argument properties".into()),
                };
                let dimensions = match iter.next() {
                    Some(dimensions) => {
                        let parts = dimensions.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        parts[1].to_string()
                    }
                    None => return Err("Missing dimensions in argument properties".into()),
                };
                let r#type = match iter.next() {
                    Some(r#type) => {
                        let parts = r#type.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        parts[1].to_string()
                    }
                    None => return Err("Missing type in argument properties".into()),
                };
                let kind = match iter.peeking_next(|s| s.contains("kind =")) {
                    Some(kind) => {
                        let parts = kind.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        Some(parts[1].to_string())
                    }
                    None => None,
                };
                let active = match iter.peeking_next(|s| s.contains("active")) {
                    Some(kind) => {
                        let parts = kind.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        Some(parts[1].to_string())
                    }
                    None => None,
                };
                let intent = match iter.peeking_next(|s| s.contains("intent")) {
                    Some(intent) => {
                        let parts = intent.split("=").map(|s| s.trim()).collect::<Vec<_>>();
                        Some(parts[1].to_string())
                    }
                    None => None,
                };
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
                args.push((line, arg));
            }
            println!("{}", file_name);

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
        }
    }

    Ok(())
}

fn write_function(function: Function, file: &mut File) -> Result<(), Box<dyn Error>> {
    let mut func_str = String::from("pragma \"generate signature\" extern proc ");
    let func_name = format!("__{}_MOD_{}", function.module, function.name);
    func_str.push_str(&func_name);
    func_str.push('(');

    let mut args = Vec::new();
    for arg in function.args {
        let mut arg_str = match arg.1.intent {
            Some(s) if s.eq("out") => "out ".to_string(),
            _ => "ref ".to_string(),
        };
        arg_str.push_str(match arg.0.as_str() {
            "var" => "_var",
            "iter" => "_iter",
            e => e 
        });
        arg_str.push_str(": ");
        arg_str.push_str(match arg.1.r#type.as_str() {
            "character" => "c_string",
            "integer" => "int",
            "real" => "real",
            "logical" => "bool",
            e => return Err(format!("Unknown type: {}", e).into()),
        });
        args.push(arg_str);
    };

    func_str.push_str(&args.join(", "));
    func_str.push_str(");\n");
    println!("{}", func_str);

    file.write_all(&func_str.as_bytes())?;
    Ok(())
}
