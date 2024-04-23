set more off
cd "/Users/marde358/Desktop/Projects/Obesity"


** Examine the effect of OB pop2 genes adjusted for tod only
use "DATA/Obesity_POP2/OB_POP2_for_analysis_sensitivity.dta", clear

tab irs2b_homo
* n=27
tab sh2b1_homo
* n=100
tab sim1b_homo
* n=527 (31 WT

rename (irs2b_homo sh2b1_homo sim1b_homo) (xirs2b_homo xsh2b1_homo xsim1b_homo)

local r "i.xirs2b_homo bdnf_D irs1_D irs2a_D         sh2b1_D sim1a_D sim1b_D"
local s "i.xsh2b1_homo bdnf_D irs1_D irs2a_D irs2b_D         sim1a_D sim1b_D"
local t "i.xsim1b_homo bdnf_D irs1_D irs2a_D irs2b_D sh2b1_D sim1a_D"

foreach loc in "`r'" "`s'" "`t'" {

local gene = substr("`loc'",3,11)

foreach outcome in bld {

preserve
nbreg `outcome' `loc' tod i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_un_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_un_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_un_sensitivity/`gene'_`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' `loc' tod i.batch 
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_un_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_un_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_un_sensitivity/`gene'_`outcome'_est", replace
restore
}
}

* now append
clear
save "RESULTS/exposure_pop2_homo_un_sensitivity/exposure_pop2_homo_un_sensitivity.dta", replace emptyok 

foreach file in xirs2b_homo_bld_est xirs2b_homo_bodyfat_est ///
xsh2b1_homo_bld_est xsh2b1_homo_bodyfat_est ///
xsim1b_homo_bld_est xsim1b_homo_bodyfat_est {
use "RESULTS/exposure_pop2_homo_un_sensitivity/`file'", clear
gen model="`file'"
append using "RESULTS/exposure_pop2_homo_un_sensitivity/exposure_pop2_homo_un_sensitivity.dta"
save "RESULTS/exposure_pop2_homo_un_sensitivity/exposure_pop2_homo_un_sensitivity.dta", replace
}

use "RESULTS/exposure_pop2_homo_un_sensitivity/exposure_pop2_homo_un_sensitivity.dta", clear
keep if strpos(parm,"_homo") | inlist(parm,"_cons")
drop if eq == "lnalpha"
gen t = z
drop z eq
drop if strpos(parm,"o.")
drop if strpos(parm,"b.")
gen trait = substr(model,13,length(model))
replace trait = substr(trait,1,length(trait)-4)

order trait parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_un SE_un LCI_un UCI_un t_un N_un P_un)
drop model

bysort trait parm: gen N=_n
keep if N==1
drop N

save "RESULTS/fixed_effects_ob_pop2_homo_un_sensitivity.dta", replace
export excel using "RESULTS/fixed_effects_ob_pop2_homo_un_sensitivity.xls", replace firstrow(variables)





******************************





** Examine the effect of OB pop2 genes adjusted for tod and batch
use "DATA/Obesity_POP2/OB_POP2_for_analysis_sensitivity.dta", clear

tab irs2b_homo
* n=27
tab sh2b1_homo
* n=100
tab sim1b_homo
* n=527 (31 WT

rename (irs2b_homo sh2b1_homo sim1b_homo) (xirs2b_homo xsh2b1_homo xsim1b_homo)

local r "i.xirs2b_homo bdnf_D irs1_D irs2a_D         sh2b1_D sim1a_D sim1b_D"
local s "i.xsh2b1_homo bdnf_D irs1_D irs2a_D irs2b_D         sim1a_D sim1b_D"
local t "i.xsim1b_homo bdnf_D irs1_D irs2a_D irs2b_D sh2b1_D sim1a_D"

foreach loc in "`r'" "`s'" "`t'" {

local gene = substr("`loc'",3,11)

foreach outcome in intlength intdorsal_area intlateral_area ///
intLiverArea intNrofSpots ///
intNrLipids intLiverRefinedArea intLipidArea intAverageLipidsIntensity ///
intN_beta_cells intbeta_cell_volume intmean_mean_insexpr ///
intNrCells intVolume intCellVolume_Av intCellVolume_Stdev intCellInt_Av intCellInt_Stdev intIV intISA intIED intIPAL1 intIPAL2 intIPAL3 ///
inttg inttc intgluc intldl {

preserve
regress `outcome' `loc' tod i.batch i.tank
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", replace
restore
}

foreach outcome in bld {

preserve
nbreg `outcome' `loc' tod i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' `loc' tod i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_batch_sensitivity/`gene'_`outcome'_est", replace
restore
}
}

* now append
clear
save "RESULTS/exposure_pop2_homo_batch_sensitivity/exposure_pop2_homo_batch_sensitivity.dta", replace emptyok 

foreach file in xirs2b_homo_intlength_est xirs2b_homo_intdorsal_area_est xirs2b_homo_intlateral_area_est ///
xirs2b_homo_intLiverArea_est xirs2b_homo_intNrofSpots_est ///
xirs2b_homo_intNrLipids_est xirs2b_homo_intLiverRefinedArea_est xirs2b_homo_intLipidArea_est xirs2b_homo_intAverageLipidsIntensity_est ///
xirs2b_homo_intN_beta_cells_est xirs2b_homo_intbeta_cell_volume_est xirs2b_homo_intmean_mean_insexpr_est ///
xirs2b_homo_inttg_est xirs2b_homo_inttc_est xirs2b_homo_intgluc_est xirs2b_homo_intldl_est ///
xirs2b_homo_intNrCells_est xirs2b_homo_intVolume_est xirs2b_homo_intCellVolume_Av_est xirs2b_homo_intCellVolume_Stdev_est xirs2b_homo_intCellInt_Av_est xirs2b_homo_intCellInt_Stdev_est xirs2b_homo_intIV_est xirs2b_homo_intISA_est xirs2b_homo_intIED_est xirs2b_homo_intIPAL1_est xirs2b_homo_intIPAL2_est xirs2b_homo_intIPAL3_est ///
xirs2b_homo_bld_est xirs2b_homo_bodyfat_est ///
xsh2b1_homo_intlength_est xsh2b1_homo_intdorsal_area_est xsh2b1_homo_intlateral_area_est ///
xsh2b1_homo_intLiverArea_est xsh2b1_homo_intNrofSpots_est ///
xsh2b1_homo_intNrLipids_est xsh2b1_homo_intLiverRefinedArea_est xsh2b1_homo_intLipidArea_est xsh2b1_homo_intAverageLipidsIntensity_est ///
xsh2b1_homo_intN_beta_cells_est xsh2b1_homo_intbeta_cell_volume_est xsh2b1_homo_intmean_mean_insexpr_est ///
xsh2b1_homo_inttg_est xsh2b1_homo_inttc_est xsh2b1_homo_intgluc_est xsh2b1_homo_intldl_est ///
xsh2b1_homo_intNrCells_est xsh2b1_homo_intVolume_est xsh2b1_homo_intCellVolume_Av_est xsh2b1_homo_intCellVolume_Stdev_est xsh2b1_homo_intCellInt_Av_est xsh2b1_homo_intCellInt_Stdev_est xsh2b1_homo_intIV_est xsh2b1_homo_intISA_est xsh2b1_homo_intIED_est xsh2b1_homo_intIPAL1_est xsh2b1_homo_intIPAL2_est xsh2b1_homo_intIPAL3_est ///
xsh2b1_homo_bld_est xsh2b1_homo_bodyfat_est ///
xsim1b_homo_intlength_est xsim1b_homo_intdorsal_area_est xsim1b_homo_intlateral_area_est ///
xsim1b_homo_intLiverArea_est xsim1b_homo_intNrofSpots_est ///
xsim1b_homo_intNrLipids_est xsim1b_homo_intLiverRefinedArea_est xsim1b_homo_intLipidArea_est xsim1b_homo_intAverageLipidsIntensity_est ///
xsim1b_homo_intN_beta_cells_est xsim1b_homo_intbeta_cell_volume_est xsim1b_homo_intmean_mean_insexpr_est ///
xsim1b_homo_inttg_est xsim1b_homo_inttc_est xsim1b_homo_intgluc_est xsim1b_homo_intldl_est ///
xsim1b_homo_intNrCells_est xsim1b_homo_intVolume_est xsim1b_homo_intCellVolume_Av_est xsim1b_homo_intCellVolume_Stdev_est xsim1b_homo_intCellInt_Av_est xsim1b_homo_intCellInt_Stdev_est xsim1b_homo_intIV_est xsim1b_homo_intISA_est xsim1b_homo_intIED_est xsim1b_homo_intIPAL1_est xsim1b_homo_intIPAL2_est xsim1b_homo_intIPAL3_est ///
xsim1b_homo_bld_est xsim1b_homo_bodyfat_est {
use "RESULTS/exposure_pop2_homo_batch_sensitivity/`file'", clear
gen model="`file'"
append using "RESULTS/exposure_pop2_homo_batch_sensitivity/exposure_pop2_homo_batch_sensitivity.dta"
save "RESULTS/exposure_pop2_homo_batch_sensitivity/exposure_pop2_homo_batch_sensitivity.dta", replace
}

use "RESULTS/exposure_pop2_homo_batch_sensitivity/exposure_pop2_homo_batch_sensitivity.dta", clear
keep if strpos(parm,"_homo") | inlist(parm,"_cons")
drop if eq == "lnalpha"
replace t = z if z == .
drop dof z eq
drop if strpos(parm,"o.")
drop if strpos(parm,"b.")
gen trait = substr(model,13,length(model))
replace trait = substr(trait,1,length(trait)-4)

order trait parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_batch SE_batch LCI_batch UCI_batch t_batch N_batch P_batch)
drop model

bysort trait parm: gen N=_n
keep if N==1
drop N

save "RESULTS/fixed_effects_ob_pop2_homo_batch_sensitivity.dta", replace
export excel using "RESULTS/fixed_effects_ob_pop2_homo_batch_sensitivity.xls", replace firstrow(variables)





******************************





** Examine the effect of OB pop2 genes adjusted for tod and size
use "DATA/Obesity_pop2/OB_pop2_for_analysis_sensitivity.dta", clear
set more off

rename (irs2b_homo sh2b1_homo sim1b_homo) (xirs2b_homo xsh2b1_homo xsim1b_homo)

local r "i.xirs2b_homo bdnf_D irs1_D irs2a_D         sh2b1_D sim1a_D sim1b_D"
local s "i.xsh2b1_homo bdnf_D irs1_D irs2a_D irs2b_D         sim1a_D sim1b_D"
local t "i.xsim1b_homo bdnf_D irs1_D irs2a_D irs2b_D sh2b1_D sim1a_D"

foreach loc in "`r'" "`s'" "`t'" {

local gene = substr("`loc'",3,11)

foreach outcome in intLiverArea intNrofSpots ///
intNrLipids intLiverRefinedArea intLipidArea intAverageLipidsIntensity ///
intN_beta_cells intbeta_cell_volume intmean_mean_insexpr ///
intNrCells intVolume intCellVolume_Av intCellVolume_Stdev intCellInt_Av intCellInt_Stdev intIV intISA intIED intIPAL1 intIPAL2 intIPAL3 {

preserve
regress `outcome' `loc' tod length dorsal_area i.batch i.tank
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", replace
restore
}

foreach outcome in bld {

preserve
nbreg `outcome' `loc' tod length dorsal_area i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' `loc' tod length dorsal_area i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", replace)
use "RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop2_homo_size_sensitivity/`gene'_`outcome'_est", replace
restore
}
}

* now append
clear
save "RESULTS/exposure_pop2_homo_size_sensitivity/exposure_pop2_homo_size_sensitivity.dta", replace emptyok 


foreach file in xirs2b_homo_intLiverArea_est xirs2b_homo_intNrofSpots_est ///
xirs2b_homo_intNrLipids_est xirs2b_homo_intLiverRefinedArea_est xirs2b_homo_intLipidArea_est xirs2b_homo_intAverageLipidsIntensity_est ///
xirs2b_homo_intN_beta_cells_est xirs2b_homo_intbeta_cell_volume_est xirs2b_homo_intmean_mean_insexpr_est ///
xirs2b_homo_intNrCells_est xirs2b_homo_intVolume_est xirs2b_homo_intCellVolume_Av_est xirs2b_homo_intCellVolume_Stdev_est xirs2b_homo_intCellInt_Av_est xirs2b_homo_intCellInt_Stdev_est xirs2b_homo_intIV_est xirs2b_homo_intISA_est xirs2b_homo_intIED_est xirs2b_homo_intIPAL1_est xirs2b_homo_intIPAL2_est xirs2b_homo_intIPAL3_est ///
xirs2b_homo_bld_est xirs2b_homo_bodyfat_est ///
xsh2b1_homo_intLiverArea_est xsh2b1_homo_intNrofSpots_est ///
xsh2b1_homo_intNrLipids_est xsh2b1_homo_intLiverRefinedArea_est xsh2b1_homo_intLipidArea_est xsh2b1_homo_intAverageLipidsIntensity_est ///
xsh2b1_homo_intN_beta_cells_est xsh2b1_homo_intbeta_cell_volume_est xsh2b1_homo_intmean_mean_insexpr_est ///
xsh2b1_homo_intNrCells_est xsh2b1_homo_intVolume_est xsh2b1_homo_intCellVolume_Av_est xsh2b1_homo_intCellVolume_Stdev_est xsh2b1_homo_intCellInt_Av_est xsh2b1_homo_intCellInt_Stdev_est xsh2b1_homo_intIV_est xsh2b1_homo_intISA_est xsh2b1_homo_intIED_est xsh2b1_homo_intIPAL1_est xsh2b1_homo_intIPAL2_est xsh2b1_homo_intIPAL3_est ///
xsh2b1_homo_bld_est xsh2b1_homo_bodyfat_est ///
xsim1b_homo_intLiverArea_est xsim1b_homo_intNrofSpots_est ///
xsim1b_homo_intNrLipids_est xsim1b_homo_intLiverRefinedArea_est xsim1b_homo_intLipidArea_est xsim1b_homo_intAverageLipidsIntensity_est ///
xsim1b_homo_intN_beta_cells_est xsim1b_homo_intbeta_cell_volume_est xsim1b_homo_intmean_mean_insexpr_est ///
xsim1b_homo_intNrCells_est xsim1b_homo_intVolume_est xsim1b_homo_intCellVolume_Av_est xsim1b_homo_intCellVolume_Stdev_est xsim1b_homo_intCellInt_Av_est xsim1b_homo_intCellInt_Stdev_est xsim1b_homo_intIV_est xsim1b_homo_intISA_est xsim1b_homo_intIED_est xsim1b_homo_intIPAL1_est xsim1b_homo_intIPAL2_est xsim1b_homo_intIPAL3_est ///
xsim1b_homo_bld_est xsim1b_homo_bodyfat_est {
use "RESULTS/exposure_pop2_homo_size_sensitivity/`file'", clear
gen model="`file'"
append using "RESULTS/exposure_pop2_homo_size_sensitivity/exposure_pop2_homo_size_sensitivity.dta"
save "RESULTS/exposure_pop2_homo_size_sensitivity/exposure_pop2_homo_size_sensitivity.dta", replace
}

use "RESULTS/exposure_pop2_homo_size_sensitivity/exposure_pop2_homo_size_sensitivity.dta", clear
keep if strpos(parm,"_homo") | inlist(parm,"_cons")
drop if eq == "lnalpha"
replace t = z if t == .
drop dof z eq
drop if strpos(parm,"o.")
drop if strpos(parm,"b.")
gen trait = substr(model,13,length(model))
replace trait = substr(trait,1,length(trait)-4)

order trait parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_size SE_size LCI_size UCI_size t_size N_size P_size)
drop model

bysort trait parm: gen N=_n
keep if N==1
drop N

save "RESULTS/fixed_effects_ob_pop2_homo_size_sensitivity.dta", replace
export excel using "RESULTS/fixed_effects_ob_pop2_homo_size_sensitivity.xls", replace firstrow(variables)






******************************




** Merge results files with summary statistics
set more off
use "RESULTS/fixed_effects_ob_pop2_homo_un_sensitivity.dta", clear
merge 1:1 trait parm using "RESULTS/fixed_effects_ob_pop2_homo_batch_sensitivity.dta"
drop _merge
merge 1:1 trait parm using "RESULTS/fixed_effects_ob_pop2_homo_size_sensitivity.dta"
drop _merge

gen order = .
replace order = 1 if strpos(parm,"xirs2b_homo")
replace order = 2 if strpos(parm,"xsh2b1_homo")
replace order = 3 if strpos(parm,"xsim1b_homo")
replace order = 7 if strpos(parm,"_cons")

gen trait_order = .
replace trait_order = 1 if strpos(trait,"length")
replace trait_order = 2 if strpos(trait,"dorsal")
replace trait_order = 3 if strpos(trait,"lateral")

replace trait_order = 7 if strpos(trait,"intldl")
replace trait_order = 8 if strpos(trait,"inttg")
replace trait_order = 10 if strpos(trait,"inttc")
replace trait_order = 12 if strpos(trait,"intgluc")

replace trait_order = 15 if strpos(trait,"bodyfat")
replace trait_order = 16 if strpos(trait,"LiverArea")
replace trait_order = 17 if strpos(trait,"LiverRefinedArea")
replace trait_order = 18 if strpos(trait,"NrofSpots")
replace trait_order = 19 if strpos(trait,"NrLipids")
replace trait_order = 20 if strpos(trait,"LipidArea")
replace trait_order = 21 if strpos(trait,"AverageLipidsIntensity")

replace trait_order = 22 if strpos(trait,"bld")

replace trait_order = 25 if strpos(trait,"N_beta_cells")
replace trait_order = 26 if strpos(trait,"NrCells")

replace trait_order = 31 if strpos(trait,"beta_cell_volume")
replace trait_order = 32 if strpos(trait,"Volume")
replace trait_order = 33 if strpos(trait,"CellVolume_Av")
replace trait_order = 34 if strpos(trait,"CellVolume_Stdev")

replace trait_order = 41 if strpos(trait,"mean_mean_insexpr")
replace trait_order = 42 if strpos(trait,"CellInt_Av")
replace trait_order = 43 if strpos(trait,"CellInt_Stdev")

replace trait_order = 50 if strpos(trait,"IED")
replace trait_order = 51 if strpos(trait,"IPAL1")
replace trait_order = 52 if strpos(trait,"IPAL2")
replace trait_order = 53 if strpos(trait,"IPAL3")
replace trait_order = 54 if strpos(trait,"ISA")
replace trait_order = 55 if strpos(trait,"IV")

* make some changes to prevent work on results table
drop if inlist(parm,"tod")
drop if strpos(parm,"batch")

foreach var in beta_un SE_un LCI_un UCI_un P_un N_un t_un      beta_batch SE_batch LCI_batch UCI_batch P_batch N_batch t_batch     beta_size SE_size LCI_size UCI_size P_size N_size t_size {
replace `var´' = . if parm == "_cons"
}

foreach var in trait parm {
replace `var´' = "" if parm == "_cons"
}

gen l=""
gen m=""

sort trait_order order parm
drop order trait_order

format beta_un SE_un LCI_un UCI_un t_un       beta_batch SE_batch LCI_batch UCI_batch t_batch      beta_size SE_size LCI_size UCI_size t_size %6.3f
format P_un P_batch P_size %12.2e

order trait parm beta_un SE_un LCI_un UCI_un P_un N_un t_un l     beta_batch SE_batch LCI_batch UCI_batch P_batch N_batch t_batch m    beta_size SE_size LCI_size UCI_size P_size N_size t_size

replace parm = "irs2b_homo" if strpos(parm,"1.xirs2b_homo")
replace parm = "sh2b1_homo" if strpos(parm,"1.xsh2b1_homo")
replace parm = "sim1b_homo" if strpos(parm,"1.xsim1b_homo")
   
keep trait parm beta_un SE_un LCI_un UCI_un P_un N_un t_un l     beta_batch SE_batch LCI_batch UCI_batch P_batch N_batch t_batch m    beta_size SE_size LCI_size UCI_size P_size N_size t_size

outsheet using "RESULTS/OB2_sensitivity/obesity_pop2_homo_linear_results_sensitivity.txt", noquote replace


