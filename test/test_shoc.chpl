use UnitTest;
use ccpp;

proc test_shoc(test: borrowed Test) throws {
    var errflg: int = 0;
    var errmsg = "".c_str();
    var do_shoc = true;
    __shoc_MOD_shoc_init(do_shoc, errmsg, errflg);

    test.assertEqual(errflg, 0);
}

UnitTest.main();