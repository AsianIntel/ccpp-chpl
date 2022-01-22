# Code Generation
This folder contains the code required to parse the meta files which can be found in the `ccpp-physics` library. The code is written in Rust (mostly only because I am comfortable with it). 

## Process
One thing to notice is the `.meta` files are similar to the structure to a `.toml` file. The code generation process consists of the following steps:
1. The `[ccpp-table-properties]` table contains the information about the fortran module. Extract the name out of it.
2. The `[ccpp-arg-table]` table contains the information about the fortran function. Extract the name out of it.
3. The next tables contain the information about each of the individual arguments of the function of whose name was extracted in the previous step.
The header of the table (the `[xxxxxx]` part) is the name of the argument that needs to used in the function defintion in the Chapel file. The `standard_name`, `long_name` and `units` fields describe the functionality of the argument. The `dimensions`, `type`, `intent` fields are needed to declare the type of the argument in Chapel.

**Note**: The implementation is done using a naive approach. A sophisticated process will be written for it in the future, ideally using `serde`.
