module wrap
    use rrtmg_lw
    use machine
    use module_radlw_parameters
    implicit none
    public
    integer, parameter :: errlen = 128
    contains

    subroutine rrtmg_lw_run_wrap                                           &
        &     ( plyr,plvl,tlyr,tlvl,qlyr,olyr,gasvmr_co2, gasvmr_n2o,      &   !  ---  inputs
        &       gasvmr_ch4, gasvmr_o2, gasvmr_co, gasvmr_cfc11,            &
        &       gasvmr_cfc12, gasvmr_cfc22, gasvmr_ccl4,                   &
        &       icseed,aeraod,aerssa,sfemis,sfgtmp,                        &
        &       dzlyr,delpin,de_lgth,alpha,                                &
        &       npts, nlay, nlp1, lprnt, cld_cf, lslwr,                    &
        &       hlwc,topflx,sfcflx,cldtau,                                 &   !  ---  outputs
        &       HLW0,HLWB,FLXPRF,                                          &   !  ---  optional
        &       cld_lwp, cld_ref_liq, cld_iwp, cld_ref_ice,                &
        &       cld_rwp,cld_ref_rain, cld_swp, cld_ref_snow,               &
        &       cld_od, errmsg, errflg                                     &
        &     ) bind(C, name = "rrtmg_run_wrap")
        use iso_c_binding

        integer(c_int), intent(in) :: npts, nlay, nlp1
        integer(c_int), intent(in) :: icseed(npts)
        logical, intent(in) :: lprnt, lslwr

        real (c_double), dimension(npts, nlay), intent(in) :: plyr, tlyr, qlyr, olyr, delpin, dzlyr, & 
        &       gasvmr_co2, gasvmr_n2o, gasvmr_ch4, gasvmr_o2, gasvmr_co, gasvmr_cfc11, gasvmr_cfc12, &
        &       gasvmr_cfc22, gasvmr_ccl4, cld_cf, alpha

        real (c_double), dimension(npts, nlp1), intent(in) :: plvl, tlvl

        real (c_double), dimension(npts, nlay),intent(in),optional::       &
        &       cld_lwp, cld_ref_liq,  cld_iwp, cld_ref_ice,               &
        &       cld_rwp, cld_ref_rain, cld_swp, cld_ref_snow,              &
        &       cld_od

        real (c_double), dimension(npts), intent(in) :: sfemis, sfgtmp, de_lgth

        real (c_double), dimension(npts, nlay, nbands),intent(in) :: aeraod, aerssa

        real (c_double), dimension(npts, nlay), intent(inout) :: hlwc, cldtau

        type (topflw_type), dimension(npts), intent(inout) :: topflx
        type (sfcflw_type), dimension(npts), intent(inout) :: sfcflx

        character, dimension(errlen), intent(out) :: errmsg
        integer(c_int), intent(out) :: errflg
        character(len=errlen) :: fortran_errmsg
        integer :: i

        real (c_double), dimension(npts, nlay, nbands), optional, intent(inout) :: hlwb
        real (c_double), dimension(npts, nlay), optional, intent(inout) :: hlw0

        type (proflw_type), dimension(npts, nlp1), optional, intent(inout) :: flxprf

        call rrtmg_lw_run &     
        & ( plyr,plvl,tlyr,tlvl,qlyr,olyr,gasvmr_co2, gasvmr_n2o,      &   !  ---  inputs
        &       gasvmr_ch4, gasvmr_o2, gasvmr_co, gasvmr_cfc11,            &
        &       gasvmr_cfc12, gasvmr_cfc22, gasvmr_ccl4,                   &
        &       icseed,aeraod,aerssa,sfemis,sfgtmp,                        &
        &       dzlyr,delpin,de_lgth,alpha,                                &
        &       npts, nlay, nlp1, lprnt, cld_cf, lslwr,                    &
        &       hlwc,topflx,sfcflx,cldtau,                                 &   !  ---  outputs
        &       HLW0,HLWB,FLXPRF,                                          &   !  ---  optional
        &       cld_lwp, cld_ref_liq, cld_iwp, cld_ref_ice,                &
        &       cld_rwp,cld_ref_rain, cld_swp, cld_ref_snow,               &
        &       cld_od, fortran_errmsg, errflg                                     &
        &     )

        fortran_errmsg = trim(fortran_errmsg)
        do i = 1, errlen
            errmsg(i) = fortran_errmsg(i:i)
        enddo

    end subroutine rrtmg_lw_run_wrap

    subroutine rrtmg_lw_run_trial &
        &     ( plyr,plvl,tlyr,tlvl,qlyr,olyr,gasvmr_co2, gasvmr_n2o,      &   !  ---  inputs
        &       gasvmr_ch4, gasvmr_o2, gasvmr_co, gasvmr_cfc11,            &
        &       gasvmr_cfc12, gasvmr_cfc22, gasvmr_ccl4,                   &
        &       icseed,aeraod,aerssa,sfemis,sfgtmp,                        &
        &       dzlyr,delpin,de_lgth,alpha,                                &
        &       npts, nlay, nlp1, lprnt, cld_cf, lslwr,                    &
        &       hlwc,topflx,sfcflx,cldtau,                                 &   !  ---  outputs
        &       HLW0,HLWB,FLXPRF,                                          &   !  ---  optional
        &       cld_lwp, cld_ref_liq, cld_iwp, cld_ref_ice,                &
        &       cld_rwp,cld_ref_rain, cld_swp, cld_ref_snow,               &
        &       cld_od, errmsg, errflg                                     &
        &     )
        integer, intent(in) :: npts, nlay, nlp1
        integer, intent(in) :: icseed(npts)

        logical,  intent(in) :: lprnt

        real (kind=kind_phys), dimension(:,:), intent(in) :: plvl,        &
        &       tlvl
        real (kind=kind_phys), dimension(:,:), intent(in) :: plyr,        &
        &       tlyr, qlyr, olyr, dzlyr, delpin

        real (kind=kind_phys),dimension(:,:),intent(in)::gasvmr_co2,      &
        &     gasvmr_n2o, gasvmr_ch4, gasvmr_o2, gasvmr_co, gasvmr_cfc11,  &
        &     gasvmr_cfc12, gasvmr_cfc22, gasvmr_ccl4

        real (kind=kind_phys), dimension(:,:),intent(in):: cld_cf
        real (kind=kind_phys), dimension(:,:),intent(in),optional::       &
        &       cld_lwp, cld_ref_liq,  cld_iwp, cld_ref_ice,               &
        &       cld_rwp, cld_ref_rain, cld_swp, cld_ref_snow,              &
        &       cld_od

        real (kind=kind_phys), dimension(:), intent(in) :: sfemis,        &
        &       sfgtmp, de_lgth
        real (kind=kind_phys), dimension(npts,nlay), intent(in) :: alpha

        real (kind=kind_phys), dimension(:,:,:),intent(in)::              &
        &       aeraod, aerssa

    !  ---  outputs:
        real (kind=kind_phys), dimension(:,:), intent(inout) :: hlwc
        real (kind=kind_phys), dimension(:,:), intent(inout) ::           &
        &       cldtau

        type (topflw_type),    dimension(:), intent(inout) :: topflx
        type (sfcflw_type),    dimension(:), intent(inout) :: sfcflx

        character(len=*), intent(out) :: errmsg
        integer,          intent(out) :: errflg

    !! ---  optional outputs:
        real (kind=kind_phys), dimension(:,:,:),optional,                 &
        &       intent(inout) :: hlwb
        real (kind=kind_phys), dimension(:,:),       optional,            &
        &       intent(inout) :: hlw0
        type (proflw_type),    dimension(:,:),       optional,            &
        &       intent(inout) :: flxprf
        logical, intent(in) :: lslwr

        real (kind=kind_phys), dimension(0:nlp1) :: cldfrc
        real (kind=kind_phys), dimension(0:nlay) :: totuflux, totdflux,   &
     &       totuclfl, totdclfl, tz

        real (kind=kind_phys), dimension(nlay)   :: htr, htrcl

        real (kind=kind_phys), dimension(nlay)   :: pavel, tavel, delp,   &
        &       clwp, ciwp, relw, reiw, cda1, cda2, cda3, cda4,            &
        &       coldry, colbrd, h2ovmr, o3vmr, fac00, fac01, fac10, fac11, &
        &       selffac, selffrac, forfac, forfrac, minorfrac, scaleminor, &
        &       scaleminorn2, temcol, dz

        real (kind=kind_phys), dimension(nbands,0:nlay) :: pklev, pklay

        real (kind=kind_phys), dimension(nlay,nbands) :: htrb
        real (kind=kind_phys), dimension(nbands,nlay) :: taucld, tauaer
        real (kind=kind_phys), dimension(nbands,npts,nlay) :: taucld3
        real (kind=kind_phys), dimension(ngptlw,nlay) :: fracs, tautot
        real (kind=kind_phys), dimension(nlay,ngptlw) :: fracs_r
        real(kind=kind_phys), dimension(ngptlw,nlay) :: cldfmc
        real (kind=kind_phys), dimension(nbands) :: semiss, secdiff

        !  ---  column amount of absorbing gases:
        !       (:,m) m = 1-h2o, 2-co2, 3-o3, 4-n2o, 5-ch4, 6-o2, 7-co
        real (kind=kind_phys) :: colamt(nlay,maxgas)

        !  ---  column cfc cross-section amounts:
        !       (:,m) m = 1-ccl4, 2-cfc11, 3-cfc12, 4-cfc22
        real (kind=kind_phys) :: wx(nlay,maxxsec)
        
        !  ---  reference ratios of binary species parameter in lower atmosphere:
        !       (:,m,:) m = 1-h2o/co2, 2-h2o/o3, 3-h2o/n2o, 4-h2o/ch4, 5-n2o/co2, 6-o3/co2
        real (kind=kind_phys) :: rfrate(nlay,nrates,2)

        real (kind=kind_phys) :: tem0, tem1, tem2, pwvcm, summol, stemp,  &
    &                         delgth
        real (kind=kind_phys), dimension(nlay) :: alph

        integer, dimension(npts) :: ipseed
        integer, dimension(nlay) :: jp, jt, jt1, indself, indfor, indminor
        integer                  :: laytrop, iplon, i, j, k, k1
        integer                  :: ig
        integer                  :: inflglw, iceflglw, liqflglw
        logical :: lcf1
        integer :: istart              ! beginning band of calculation
        integer :: iend                ! ending band of calculation
        integer :: iout                ! output option flag (inactive)

        errmsg = ''
        errflg = 0    
        
        inflglw = 2
        iceflglw = 3
        liqflglw = 1
        istart = 1
        iend = 16
        iout = 0

        if (.not. lslwr) return
        

    end subroutine rrtmg_lw_run_trial
end module wrap