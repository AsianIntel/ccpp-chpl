use UnitTest;
use ccpp;
use types;
use SysCTypes;
use SysBasic;
use CPtr;

proc test_rrtmg_lw_run(test: borrowed Test) throws {
    var plyr = c_ptrTo([c_ptrTo([100494.85830592]), c_ptrTo([96238.42333803]), c_ptrTo([87140.18579651]), c_ptrTo([74163.46938902]), c_ptrTo([58682.25935487]), c_ptrTo([42335.74081556]), c_ptrTo([26854.79178391]), c_ptrTo([13878.9330821]), c_ptrTo([4784.33781523]), c_ptrTo([713.72872734])]);
    var plvl = c_ptrTo([c_ptrTo([1.01320000e+05]), c_ptrTo([9.96713267e+04]), c_ptrTo([9.28344350e+04]), c_ptrTo([8.15332091e+04]), c_ptrTo([6.69642132e+04]), c_ptrTo([5.06700000e+04]), c_ptrTo([3.43757868e+04]), c_ptrTo([1.98067909e+04]), c_ptrTo([8.50556502e+03]), c_ptrTo([1.66867333e+03]), c_ptrTo([2.00000000e+01])]);
    var tlyr = c_ptrTo([c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0]), c_ptrTo([290.0])]);
    var tlvl = c_ptrTo([c_ptrTo([300.0])]);
    var qlyr: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var olyr = c_ptrTo([c_ptrTo([3.12648299e-08]), c_ptrTo([3.23842800e-08]), c_ptrTo([3.51768051e-08]), c_ptrTo([4.10927472e-08]), c_ptrTo([5.27173869e-08]), c_ptrTo([7.99511414e-08]), c_ptrTo([1.52035464e-07]), c_ptrTo([4.87074654e-07]), c_ptrTo([2.75213104e-06]), c_ptrTo([3.59990595e-06])]);
    var gasvmr_co2: [1..10] c_ptr(c_double) = c_ptrTo([0.00033]);
    var gasvmr_n2o: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var gasvmr_ch4: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var gasvmr_o2: [1..10] c_ptr(c_double) = c_ptrTo([0.21]);
    var gasvmr_co: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var gasvmr_cfc11: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var gasvmr_cfc12: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var gasvmr_cfc22: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var gasvmr_ccl4: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var icseed: c_ptr(c_int);

    var aeraod_0: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var aeraod: [1..16] c_ptr(c_ptr(c_double)) = c_ptrTo([c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0]), c_ptrTo([0.0])]);

    var aerssa_0: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var aerssa: [1..16] c_ptr(c_ptr(c_double)) = c_ptrTo(aerssa_0);

    var sfemis: [1..16] real = 1.0;
    var sfgtmp: [1..16] real = 1.0;

    var delpin: plvl.type;
    for i in 1..9 do {
        delpin[i-1] = c_ptrTo([plvl[i].deref() - plvl[i-1].deref()]);
    }

    var dzlyr: plvl.type;
    for i in 0..9 do {
        dzlyr[i] = c_ptrTo([delpin[i].deref() / (287.0 * 9.80665)]);
    }

    var de_lgth: [1..10] real = 0.0;

    var alpha_0: [1..10] real = 0.0;
    var alpha: [1..16] c_ptr(c_double) = c_ptrTo(alpha_0);

    var npts = 1;
    var nlay = 10;
    var nlp1 = 9;
    var lprnt = true;
    var cld_cf: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var lslwr = true;
    var hlwc: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);

    var topflx_0 = new topflw_type(0.0, 0.0);
    var topflx: [1..10] topflw_type = topflx_0;

    var sfcflx_0 = new sfcflw_type(0.0, 0.0, 0.0, 0.0);
    var sfcflx: [1..10] sfcflw_type = sfcflx_0;
    
    var cldtau: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var hlw0: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);

    var hlwb: [1..16, 1..10, 1..1] real = 0.0;
    var flxprf: [1..10, 1..9] real = 0.0;

    var cld_lwp: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_ref_liq: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_iwp: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_ref_ice: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_rwp: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_ref_rain: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_swp: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var cld_ref_snow: [1..10] c_ptr(c_double) = c_ptrTo([0.0]);
    var errflg: int = 0;
    var errmsg = "".c_str();

    __rrtmg_lw_MOD_rrtmg_lw_run(
        plyr, 
        plvl,
        tlyr,
        tlvl,
        c_ptrTo(qlyr),
        olyr,
        c_ptrTo(gasvmr_co2), 
        c_ptrTo(gasvmr_n2o),
        c_ptrTo(gasvmr_ch4), 
        c_ptrTo(gasvmr_o2), 
        c_ptrTo(gasvmr_co), 
        c_ptrTo(gasvmr_cfc11),
        c_ptrTo(gasvmr_cfc12), 
        c_ptrTo(gasvmr_cfc22), 
        c_ptrTo(gasvmr_ccl4),
        icseed,
        c_ptrTo(aeraod),
        c_ptrTo(aerssa),
        c_ptrTo(sfemis),
        c_ptrTo(sfgtmp),
        dzlyr,
        delpin,
        c_ptrTo(de_lgth),
        c_ptrTo(alpha),
        npts, 
        nlay, 
        nlp1, 
        lprnt, 
        c_ptrTo(cld_cf), 
        lslwr,
        c_ptrTo(hlwc),
        c_ptrTo(topflx),
        c_ptrTo(sfcflx),
        c_ptrTo(cldtau),
        c_ptrTo(hlw0),
        c_ptrTo(cld_lwp), 
        c_ptrTo(cld_ref_liq), 
        c_ptrTo(cld_iwp), 
        c_ptrTo(cld_ref_ice),
        c_ptrTo(cld_rwp),
        c_ptrTo(cld_ref_rain), 
        c_ptrTo(cld_swp), 
        c_ptrTo(cld_ref_snow),
        errmsg, errflg
    );

    test.assertEqual(0, 0);
}

UnitTest.main();