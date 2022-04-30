module ccpp {
use types;
use SysCTypes;
use SysBasic;
use CPtr;

pragma "generate signature" extern proc __wrap_MOD_rrtmg_lw_run_wrap(plyr: c_ptr(c_double), plvl: c_ptr(c_double), tlyr: c_ptr(c_double), tlvl: c_ptr(c_double), qlyr: c_ptr(c_double), olyr: c_ptr(c_double), gasvmr_co2: c_ptr(c_double), gasvmr_n2o: c_ptr(c_double), gasvmr_ch4: c_ptr(c_double), gasvmr_o2: c_ptr(c_double), gasvmr_co: c_ptr(c_double), gasvmr_cfc11: c_ptr(c_double), gasvmr_cfc12: c_ptr(c_double), gasvmr_cfc22: c_ptr(c_double), gasvmr_ccl4: c_ptr(c_double), icseed: c_ptr(c_int), aeraod: c_ptr(c_double), aerssa: c_ptr(c_double), sfemis: c_ptr(c_double), sfgtmp: c_ptr(c_double), dzlyr: c_ptr(c_double), delpin: c_ptr(c_double), de_lgth: c_ptr(c_double), alpha: c_ptr(c_double), ref npts: int, ref nlay: int, ref nlp1: int, ref lprnt: bool, cld_cf: c_ptr(c_double), ref lslwr: bool, hlwc: c_ptr(c_double), topflx: c_ptr(topflw_type), sfcflx: c_ptr(sfcflw_type), cldtau: c_ptr(c_double), hlw0: c_ptr(c_double), hlwb: c_ptr(c_double), flxprf: c_ptr(c_double), cld_lwp: c_ptr(c_double), cld_ref_liq: c_ptr(c_double), cld_iwp: c_ptr(c_double), cld_ref_ice: c_ptr(c_double), cld_rwp: c_ptr(c_double), cld_ref_rain: c_ptr(c_double), cld_swp: c_ptr(c_double), cld_ref_snow: c_ptr(c_double), cld_od: c_ptr(c_double), errmsg: c_string, ref errflg: int);

var plyr: [0..0] [0..9] real = [[100494.85830592, 96238.42333803, 087140.18579651, 74163.46938902, 58682.25935487, 42335.74081556, 26854.79178391, 13878.9330821, 4784.33781523, 713.72872734]];
var plvl: [0..0] [0..10] real = [[1.01320000e+05, 9.96713267e+04, 9.28344350e+04, 8.15332091e+04, 6.69642132e+04, 5.06700000e+04, 3.43757868e+04, 1.98067909e+04, 8.50556502e+03, 1.66867333e+03, 2.00000000e+01]];
var tlyr: [0..0] [0..9] real = [[290.0, 290.0, 290.0, 290.0, 290.0, 290.0, 290.0, 290.0, 290.0, 290.0]]; 
var tlvl: [0..0] [0..10] real = [[300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0, 300.0]];
var qlyr: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var olyr: [0..0] [0..9] real = [[3.12648299e-08, 3.23842800e-08, 3.51768051e-08, 4.10927472e-08, 5.27173869e-08, 7.99511414e-08, 1.52035464e-07, 4.87074654e-07, 2.75213104e-06, 3.59990595e-06]];
var gasvmr_co2: [0..0] [0..9] real = [[0.00033, 0.00033, 0.00033, 0.00033, 0.00033, 0.00033, 0.00033, 0.00033, 0.00033, 0.00033]];
var gasvmr_n2o: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var gasvmr_ch4: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var gasvmr_o2: [0..0] [0..9] real = [[0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21]];
var gasvmr_co: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var gasvmr_cfc11: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var gasvmr_cfc12: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var gasvmr_cfc22: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var gasvmr_ccl4: [0..0] [0..9] real = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];
var icseed: [0..0] int(32) = 0;
var aeraod: [0..0] [0..9] [0..15] real = [[[0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21], [0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21, 0.21]]];
var aerssa: [0..0] [0..9] [0..15] real;

var sfemis: [0..15] real = 1.0;
var sfgtmp: [0..15] real = 1.0;

var delpin: [0..0] [0..9] real;
for i in 1..10 do {
    delpin[0][i-1] = plvl[0][i] - plvl[0][i-1];
}

var dzlyr: [0..0] [0..9] real;
for i in 0..9 do {
    dzlyr[0][i] = delpin[0][i] / (287.0 * 9.80665);
}

var de_lgth: [0..9] real = 0.0;

var alpha: [0..15] [0..9] real;

var npts = 1;
var nlay = 10;
var nlp1 = 11;
var lprnt = true;
var cld_cf: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var lslwr = true;
var hlwc: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];

var topflx_0 = new topflw_type(0.0, 0.0);
var topflx: [0..9] topflw_type = topflx_0;

var sfcflx_0 = new sfcflw_type(0.0, 0.0, 0.0, 0.0);
var sfcflx: [0..9] sfcflw_type = sfcflx_0;

var cldtau: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var hlw0: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var hlwb: [0..15] [0..9] [0..0] real;
var flxprf: [0..10] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];

var cld_lwp: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_ref_liq: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_iwp: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_ref_ice: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_rwp: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_ref_rain: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_swp: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_ref_snow: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var cld_od: [0..9] [0..0] real = [[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]];
var errflg: int = 0;
var errmsg = "e".c_str();
writeln(cld_ref_snow);

__wrap_MOD_rrtmg_lw_run_wrap(
    c_ptrTo(plyr[0][0]), 
    c_ptrTo(plvl[0][0]),
    c_ptrTo(tlyr[0][0]),
    c_ptrTo(tlvl[0][0]),
    c_ptrTo(qlyr[0][0]),
    c_ptrTo(olyr[0][0]),
    c_ptrTo(gasvmr_co2[0][0]), 
    c_ptrTo(gasvmr_n2o[0][0]),
    c_ptrTo(gasvmr_ch4[0][0]), 
    c_ptrTo(gasvmr_o2[0][0]), 
    c_ptrTo(gasvmr_co[0][0]), 
    c_ptrTo(gasvmr_cfc11[0][0]),
    c_ptrTo(gasvmr_cfc12[0][0]), 
    c_ptrTo(gasvmr_cfc22[0][0]), 
    c_ptrTo(gasvmr_ccl4[0][0]),
    c_ptrTo(icseed[0]),
    c_ptrTo(aeraod[0][0][0]),
    c_ptrTo(aerssa[0][0][0]),
    c_ptrTo(sfemis[0]),
    c_ptrTo(sfgtmp[0]),
    c_ptrTo(dzlyr[0][0]),
    c_ptrTo(delpin[0][0]),
    c_ptrTo(de_lgth[0]),
    c_ptrTo(alpha[0][0]),
    npts, 
    nlay, 
    nlp1, 
    lprnt, 
    c_ptrTo(cld_cf[0][0]), 
    lslwr,
    c_ptrTo(hlwc[0][0]),
    c_ptrTo(topflx[0]),
    c_ptrTo(sfcflx[0]),
    c_ptrTo(cldtau[0][0]),
    c_ptrTo(hlw0[0][0]),
    c_ptrTo(hlwb[0][0][0]),
    c_ptrTo(flxprf[0][0]),
    c_ptrTo(cld_lwp[0][0]), 
    c_ptrTo(cld_ref_liq[0][0]), 
    c_ptrTo(cld_iwp[0][0]), 
    c_ptrTo(cld_ref_ice[0][0]),
    c_ptrTo(cld_rwp[0][0]),
    c_ptrTo(cld_ref_rain[0][0]), 
    c_ptrTo(cld_swp[0][0]), 
    c_ptrTo(cld_ref_snow[0][0]),
    c_ptrTo(cld_od[0][0]),
    errmsg, errflg
);
writeln(topflx);
writeln(errflg);
writeln(errmsg: string);

}