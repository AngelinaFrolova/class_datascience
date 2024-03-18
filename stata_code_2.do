clear
clear mata
clear matrix
set more off, perm
set mem 1000m
set matsize 1000

foreach path in  "C:\Users\quent\Dropbox\PhD\auction" "C:\Users\qgallea\Dropbox\PhD\auction"{
    capture cd "`path'"
    if _rc == 0 macro def path `path'
} /* foreach path */

gl path_results = "$path/result/02_japan"


*        PROJECT: auctions

*       FIRST VERSION  05.03.2024
*       THIS VERSION   11.03.2024

*       AUTHOR              QG
*       LAST REVISOR        QG

*       Log of revisions:

***************************************************************************************************
****                              PLAN OF THE PROCEDURE                                        ****
****___________________________________________________________________________________________****
****                                                                                           ****
****     A. ************************************************************************

* install package
* ssc install synth
* cap ado uninstall synth_runner //in-case already installed
* net install synth_runner, from(https://raw.github.com/bquistorff/synth_runner/master/) replace

use "$path\data\master_asia_solar_0.dta", replace

keep if year>=2009

**drop Korea as auction was also implemented
drop if iso3==“KOR”

**keep USA and DEU as counterfactuals
keep if iso3 == "USA" | iso3 == "DEU"

xtset id year
xtdes

global controls=" gdp_log pop capacity_fossil_log"

**OLS 2SLS with fossil fuels as IV
        est clear
        qui: reghdfe capacity_pv auction_solar  $controls, noabsorb cluster(id)
            quietly sum  capacity_pv  if e(sample)==1
            estadd local y_mean_round = string(r(mean), "%9.3f")
            estadd local controls "Yes", replace
            estadd local FE_i "No"
            estadd local FE_t "No"
        eststo
        qui: reghdfe capacity_pv auction_solar  $controls, absorb(id) cluster(id)
            quietly sum  capacity_pv  if e(sample)==1
            estadd local y_mean_round = string(r(mean), "%9.3f")
            estadd local controls "Yes", replace
            estadd local FE_i "Yes"
            estadd local FE_t "No"
        eststo
        qui: reghdfe capacity_pv auction_solar  $controls, absorb(id year) cluster(id)
            quietly sum  capacity_pv  if e(sample)==1
            estadd local y_mean_round = string(r(mean), "%9.3f")
            estadd local controls "Yes", replace
            estadd local FE_i "Yes"
            estadd local FE_t "Yes"
        eststo
            qui: reghdfe capacity_pv_share auction_solar  $controls, noabsorb cluster(id)
            quietly sum  capacity_pv  if e(sample)==1
            estadd local y_mean_round = string(r(mean), "%9.3f")
            estadd local controls "Yes", replace
            estadd local FE_i "No"
            estadd local FE_t "No"
        eststo
        qui: reghdfe capacity_pv_share auction_solar  $controls, absorb(id) cluster(id)
            quietly sum  capacity_pv  if e(sample)==1
            estadd local y_mean_round = string(r(mean), "%9.3f")
            estadd local controls "Yes", replace
            estadd local FE_i "Yes"
            estadd local FE_t "No"
        eststo
        qui: reghdfe capacity_pv_share auction_solar  $controls,  absorb(id year) cluster(id)
            quietly sum  capacity_pv  if e(sample)==1
            estadd local y_mean_round = string(r(mean), "%9.3f")
            estadd local controls "Yes", replace
            estadd local FE_i "Yes"
            estadd local FE_t "Yes"
        eststo
        esttab ,  ///
             title("OLS")        ///
            replace br se  label star(* 0.10 ** 0.05 *** 0.01) obslast varwidth(20) compress longtable wrap     ///
            scalars("y_mean_round Mean dep var" "controls Controls" "FE_t FE year" "FE_i FE cell")  nomtitle    ///
            mgroups("Level" "Share", pattern(1 0 0 1  0 0)) ///
            b(%9.3f) se(%9.3f) r2  note("Error clustered at the country level." )
        esttab  using "$path_results/reg_ols_solar.tex", ///
             title("OLS")        ///
            replace br se  label star(* 0.10 ** 0.05 *** 0.01) obslast varwidth(20) compress longtable wrap     ///
            scalars("y_mean_round Mean dep var" "controls Controls" "FE_t FE year" "FE_i FE cell" "fstat F-stat" "IV IV")  nomtitle    ///
            mgroups("Level" "Share", pattern(1 0 0 1  0 0)) ///
            b(%9.3f) se(%9.3f) r2  note("Error clustered at the country level." )
            


**SCM
    ** Not matching FIT
        ** synth_runner capacity_pv
        preserve
        summarize id if iso3 == “JPN”, meanonly
        local id_tr = r(mean)
        
        synth_runner capacity_pv capacity_pv(2010) capacity_pv(2011) capacity_pv(2012) capacity_pv(2013) capacity_pv(2014) capacity_pv(2015) capacity_pv(2016), trunit(`id_tr') trperiod(2017) gen_vars
        
        single_treatment_graphs, trlinediff(0)
        
        effect_graphs , trlinediff(0)
        pval_graphs
        
                *weights
                synth capacity_pv capacity_pv(2010) capacity_pv(2011) capacity_pv(2012) capacity_pv(2013) capacity_pv(2014) capacity_pv(2015) capacity_pv(2016), trunit(`id_tr') trperiod(2017)  ///
                keep("$path/result/02_japan/scm_japan.dta") replace fig
                **check weights
                 *ESP 11.5%, GBR 21.4%, NLD 67.1%
                 *tab iso3 if id==4
        restore
        
        ** synth_runner capacity_pv_log
        preserve
        summarize id if iso3 == “JPN”, meanonly
        local id_tr = r(mean)
        
        synth_runner capacity_pv_share capacity_pv_share(2010) capacity_pv_share(2011) capacity_pv_share(2012) capacity_pv_share(2013) capacity_pv_share(2014) capacity_pv_share(2015) capacity_pv_share(2016), trunit(`id_tr') trperiod(2017) gen_vars
        
        single_treatment_graphs, trlinediff(0)
        
        effect_graphs , trlinediff(0)
        
        pval_graphs
        restore

        
    ** Matching FIT (initial value)
        ** synth_runner capacity_pv
        
        preserve
        
            **remplace Camboia as no data on FIT but actually it is zero
            replace fit_solar=0 if iso3=="KHM"
            replace fit_wind=0 if iso3=="KHM"
        
        summarize id if iso3 == “JPN”, meanonly
        local id_tr = r(mean)
        
        synth_runner capacity_pv capacity_pv(2010) capacity_pv(2011) capacity_pv(2012) capacity_pv(2013) capacity_pv(2014) capacity_pv(2015) capacity_pv(2016) fit_solar(2010)  fit_wind(2010) , trunit(`id_tr') trperiod(2017) gen_vars
        
        single_treatment_graphs, trlinediff(0)
        
        effect_graphs , trlinediff(0)
        pval_graphs
        restore
        
        ** synth_runner capacity_pv_log
        preserve
        
            **remplace Camboia as no data on FIT but actually it is zero
            replace fit_solar=0 if iso3=="KHM"
            replace fit_wind=0 if iso3=="KHM"
        
        summarize id if iso3 == “JPN”, meanonly
        local id_tr = r(mean)
        
        synth_runner capacity_pv_share capacity_pv_share(2010) capacity_pv_share(2011) capacity_pv_share(2012) capacity_pv_share(2013) capacity_pv_share(2014) capacity_pv_share(2015) capacity_pv_share(2016) fit_solar(2010) , trunit(`id_tr') trperiod(2017) gen_vars
        
        single_treatment_graphs, trlinediff(0)
        
        effect_graphs , trlinediff(0)
        
        pval_graphs
        restore
        
        
** Matching FIT (average value pre)
        ** synth_runner capacity_pv
        preserve
        
            **remplace Camboia as no data on FIT but actually it is zero
            replace fit_solar=0 if iso3=="KHM"
            replace fit_wind=0 if iso3=="KHM"
        
        summarize id if iso3 == “JPN”, meanonly
        local id_tr = r(mean)
        
        synth_runner capacity_pv capacity_pv(2010) capacity_pv(2011) capacity_pv(2012) capacity_pv(2013) capacity_pv(2014) capacity_pv(2015) capacity_pv(2016) fit_solar(2010(1)2016)  fit_wind(2010(1)2016) , trunit(`id_tr') trperiod(2017) gen_vars
        
        single_treatment_graphs, trlinediff(0)
        
        effect_graphs , trlinediff(0)
        pval_graphs
        

        restore
        
        ** synth_runner capacity_pv_log
        preserve
        
            **remplace Camboia as no data on FIT but actually it is zero
            replace fit_solar=0 if iso3=="KHM"
            replace fit_wind=0 if iso3=="KHM"
        
        summarize id if iso3 == “JPN”, meanonly
        local id_tr = r(mean)
        
        synth_runner capacity_pv_share capacity_pv_share(2010) capacity_pv_share(2011) capacity_pv_share(2012) capacity_pv_share(2013) capacity_pv_share(2014) capacity_pv_share(2015) capacity_pv_share(2016) fit_solar(2010(1)2016)  fit_wind(2010(1)2016) , trunit(`id_tr') trperiod(2017) gen_vars
        
        single_treatment_graphs, trlinediff(0)
        
        effect_graphs , trlinediff(0)
        
        pval_graphs
        restore
/*





    *save id code of treated in a local var.
    summarize id if iso3 == “JPN”, meanonly
    local id_tr = r(mean)
    
    synth capacity_pv capacity_pv(2010) capacity_pv(2011) capacity_pv(2012) capacity_pv(2013) capacity_pv(2014) capacity_pv(2015) capacity_pv(2016), trunit(`id_tr') trperiod(2017)  ///
    keep("$path/result/02_japan/scm_japan.dta") replace fig
    
    *synth capacity_pv  capacity_pv(2010(1)2016)  $controls , trunit(`id_tr') trperiod(2017) fig
    *synth capacity_pv capacity_pv(2010(1)2016) , trunit(`id_tr') trperiod(2017) fig
        
    **weights: ESP 11.5%, GBR 21.4%, NLD 67.1%
        
    ** plot
    use    "$path/result/02_japan/scm_japan.dta", clear
    keep _Y_treated _Y_synthetic _time
    drop if _time==.
    rename _time year
    rename _Y_treated  treat
    rename _Y_synthetic counterfact
    gen gap2017=treat-counterfact
    sort year

    twoway (line gap2017 year,lp(solid)lw(vthin) lcolor(black)), yline(0, lpattern(shortdash) lcolor(black)) xline(2017, lpattern(shortdash) lcolor(black)) xtitle("",si(medsmall)) xlabel(#10)  ytitle("Gap in solar power installed capacity", size(medsmall)) legend(off)

    
    ** Inference 1 placebo test
    use "$path\data\master_asia_solar_0.dta", replace

    keep if year>=2010
    **drop Korea as auction was also implemented
    drop if iso3=="KOR"
    
    xtset id year
    xtdes
    
    local statelist="1 2 3 4 5 6 8 9 10 11 12 13 14"
    foreach i of local statelist {
        synth   capacity_pv capacity_pv(2010) capacity_pv(2011) capacity_pv(2012) capacity_pv(2013) capacity_pv(2014) capacity_pv(2015) capacity_pv(2016), trunit(`i') trperiod(2017) keep("$path/result/02_japan/scm_korea_placebo_`i'.dta") replace
        matrix ctry`i' = e(RMSPE)
    }
    
    foreach i of local statelist {
        matrix rownames ctry`i'=`i'
        matlist ctry`i', names(rows)
    }
    
    
    local statelist="1 2 3 4 5 6 8 9 10 11 12 13 14"
    foreach i of local statelist {
        use "$path/result/02_japan/scm_japan_placebo_`i'.dta" ,clear
        keep _Y_treated _Y_synthetic _time
        drop if _time==.
        rename _time year
        rename _Y_treated  treat`i'
        rename _Y_synthetic counterfact`i'
        gen gap`i'=treat`i'-counterfact`i'
        sort year
        save "$path/result/02_japan/synth/synth_gap_lvl`i'", replace
    }
use "$path/result/02_japan/synth/synth_gap_lvl9.dta", clear
sort year
save "$path/result/02_japan/synth/placebo_lvl9.dta", replace

foreach i of local statelist {
        merge year using "$path/result/02_japan/synth/synth_gap_lvl`i'"
        drop _merge
        sort year
        }
    save "$path/result/02_japan/synth/placebo_lvl.dta", replace
    
    ** Inference 2: Estimate the pre- and post-RMSPE and calculate the ratio of the
    *  post-pre RMSPE   
    local statelist="1 2 3 4 5 6 8 9 10 11 12 13 14"
    foreach i of local statelist {

    use "$path/result/02_japan/synth/synth_gap_lvl`i'", clear
    gen gap3=gap`i'*gap`i'
    egen postmean=mean(gap3) if year>2016
    egen premean=mean(gap3) if year<=2016
    gen rmspe=sqrt(premean) if year<=2016
    replace rmspe=sqrt(postmean) if year>2016
    gen ratio=rmspe/rmspe[_n-1] if 2017
    gen rmspe_post=sqrt(postmean) if year>2016
    gen rmspe_pre=rmspe[_n-1] if 2017
    mkmat rmspe_pre rmspe_post ratio if 2017, matrix (state`i')   
    }
