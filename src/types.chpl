module types {
    require "types.h";

    pragma "generate signature"
    extern record topflw_type {
        var upfxc: real;
        var upfx0: real;
    }

    pragma "generate signature"
    extern record sfcflw_type {
        var upfxc: real;
        var upfx0: real;
        var dnfxc: real;
        var dnfx0: real;
    }
}