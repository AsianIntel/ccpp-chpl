cmake_minimum_required(VERSION 3.7)
project("ccpp" LANGUAGES "Fortran")
add_compile_options(-fdefault-real-8 -fdefault-double-8 -ffree-line-length-none -fno-range-check -cpp -g3 -fcheck=all -fbacktrace)
include_directories("/usr/include")
add_definitions(-DNEMS_GSM -Duse_netCDF -DINTERNAL_FILE_NML -DCCPP)
file(GLOB CCPP_SRC CONFIGURE_DEPENDS 
    "ccpp-physics/physics/*.F" 
    "ccpp-physics/physics/*.f" 
    "ccpp-physics/physics/*.F90" 
    "ccpp-physics/physics/*.f90" 
    "ccpp-physics/physics/rte-rrtmgp/rrtmgp/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/rrtmgp/kernels-openacc/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/rrtmgp/kernels/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/rte/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/rte/kernels-openacc/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/rte/kernels/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/extensions/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/extensions/cloud_optics/*.F90"
    "ccpp-physics/physics/rte-rrtmgp/extensions/solar_variability/*.F90"
    "src/wrap.F90"
)
list(FILTER CCPP_SRC EXCLUDE REGEX ".*GFS.*\\.F90")
list(FILTER CCPP_SRC EXCLUDE REGEX ".*gfs.*\\.F")
add_library(ccpp ${CCPP_SRC})