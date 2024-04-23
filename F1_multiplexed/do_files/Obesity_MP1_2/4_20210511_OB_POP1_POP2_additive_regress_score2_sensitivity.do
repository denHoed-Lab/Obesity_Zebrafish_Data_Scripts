set more off
cd "/Users/marde358/Desktop/Projects/Obesity"


** Examine the effect of OB POP1 genes adjusted for tod only
use "DATA/Obesity_POP1_2_JOINED/OB_POP1_2_for_analysis_sensitivity.dta", clear

foreach outcome in bld {

preserve
nbreg `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod i.experiment i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod i.experiment i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`outcome'_est", replace
restore
}


* now append
clear
save "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/exposure_pop1_2_add_score2_un_sensitivity.dta", replace emptyok 

foreach file in bld_est bodyfat_est {

use "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/`file'", clear
gen model="`file'"
append using "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/exposure_pop1_2_add_score2_un_sensitivity.dta"
save "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/exposure_pop1_2_add_score2_un_sensitivity.dta", replace
}
use "RESULTS/exposure_pop1_2_add_score2_un_sensitivity/exposure_pop1_2_add_score2_un_sensitivity.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
drop if eq == "lnalpha"
gen t = z
drop z
egen id=concat(eq parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)
order trait model parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_un SE_un LCI_un UCI_un t_un N_un P_un)
sort trait model order
drop id order eq
save "RESULTS/fixed_effects_ob_pop1_2_add_score2_un_sensitivity.dta", replace
export excel using "RESULTS/fixed_effects_ob_pop1_2_add_score2_un_sensitivity.xls", replace firstrow(variables)





******************************





** Examine the effect of OB POP1 genes adjusted for tod and batch+tank
use "DATA/Obesity_POP1_2_JOINED/OB_POP1_2_for_analysis_sensitivity.dta", clear

foreach outcome in intlength intdorsal_area intlateral_area ///
intLiverArea intNrofSpots ///
intNrLipids intLiverRefinedArea intLipidArea intAverageLipidsIntensity ///
intNrCells intVolume intCellVolume_Av intCellVolume_Stdev intCellInt_Av intCellInt_Stdev intIV intISA intIED intIPAL1 intIPAL2 intIPAL3 ///
inttg inttc intgluc intldl {

preserve
regress `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod i.experiment i.batch i.tank
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", replace
restore
}

foreach outcome in bld {

preserve
nbreg `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod i.experiment i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod i.experiment i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`outcome'_est", replace
restore
}


* now append
clear
save "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/exposure_pop1_2_add_score2_batch_sensitivity.dta", replace emptyok 

foreach file in intlength_est intdorsal_area_est intlateral_area_est ///
intLiverArea_est intNrofSpots_est ///
intNrLipids_est intLiverRefinedArea_est intLipidArea_est intAverageLipidsIntensity_est ///
intNrCells_est intVolume_est intCellVolume_Av_est intCellVolume_Stdev_est intCellInt_Av_est intCellInt_Stdev_est intIV_est intISA_est intIED_est intIPAL1_est intIPAL2_est intIPAL3_est ///
inttg_est inttc_est intgluc_est intldl_est ///
bld_est bodyfat_est {

use "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/`file'", clear
gen model="`file'"
append using "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/exposure_pop1_2_add_score2_batch_sensitivity.dta"
save "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/exposure_pop1_2_add_score2_batch_sensitivity.dta", replace
}
use "RESULTS/exposure_pop1_2_add_score2_batch_sensitivity/exposure_pop1_2_add_score2_batch_sensitivity.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
drop if eq == "lnalpha"
replace t = z if t == .
drop dof z
egen id=concat(eq parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)
order trait model parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_batch SE_batch LCI_batch UCI_batch t_batch N_batch P_batch)
sort trait model order
drop id order eq
save "RESULTS/fixed_effects_ob_pop1_2_add_score2_batch_sensitivity.dta", replace
export excel using "RESULTS/fixed_effects_ob_pop1_2_add_score2_batch_sensitivity.xls", replace firstrow(variables)





******************************





** Examine the effect of OB POP1 genes additionally adjusted for size
use "DATA/Obesity_POP1_2_JOINED/OB_POP1_2_for_analysis_sensitivity.dta", clear
set more off

foreach outcome in intLiverArea intNrofSpots ///
intNrLipids intLiverRefinedArea intLipidArea intAverageLipidsIntensity ///
intNrCells intVolume intCellVolume_Av intCellVolume_Stdev intCellInt_Av intCellInt_Stdev intIV intISA intIED intIPAL1 intIPAL2 intIPAL3 {

preserve
regress `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod length dorsal_area i.experiment i.batch i.tank
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", replace
restore
}

foreach outcome in bld {

preserve
nbreg `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod length dorsal_area i.experiment i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", replace
restore
}


foreach outcome in bodyfat {

preserve
logit `outcome' score2 arid5b_D lepr_D mc4r_D negr1_D pcsk1_D pomca_D pomcb_D sec16b_D tod i.batch length dorsal_area i.experiment i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", replace)
use "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", clear
gen N=e(N)
save "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`outcome'_est", replace
restore
}

* now append
clear
save "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/exposure_pop1_2_add_score2_size_sensitivity.dta", replace emptyok 

foreach file in intLiverArea_est intNrofSpots_est ///
intNrLipids_est intLiverRefinedArea_est intLipidArea_est intAverageLipidsIntensity_est ///
intNrCells_est intVolume_est intCellVolume_Av_est intCellVolume_Stdev_est intCellInt_Av_est intCellInt_Stdev_est intIV_est intISA_est intIED_est intIPAL1_est intIPAL2_est intIPAL3_est ///
bld_est bodyfat_est {

use "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/`file'", clear
gen model="`file'"
append using "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/exposure_pop1_2_add_score2_size_sensitivity.dta"
save "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/exposure_pop1_2_add_score2_size_sensitivity.dta", replace
}
use "RESULTS/exposure_pop1_2_add_score2_size_sensitivity/exposure_pop1_2_add_score2_size_sensitivity.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
drop if eq == "lnalpha"
replace t = z if t == .
drop dof z
egen id=concat(eq parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)
order trait model parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_size SE_size LCI_size UCI_size t_size N_size P_size)
sort trait model order
drop id order eq
save "RESULTS/fixed_effects_ob_pop1_2_add_score2_size_sensitivity.dta", replace
export excel using "RESULTS/fixed_effects_ob_pop1_2_add_score2_size_sensitivity.xls", replace firstrow(variables)





******************************




** Merge results files with summary statistics
use "RESULTS/fixed_effects_ob_pop1_2_add_score2_un_sensitivity.dta", clear
merge 1:1 trait model parm using "RESULTS/fixed_effects_ob_pop1_2_add_score2_batch_sensitivity.dta"
drop _merge
merge 1:1 trait model parm using "RESULTS/fixed_effects_ob_pop1_2_add_score2_size_sensitivity.dta"
drop _merge

gen order = .
replace order = 1 if strpos(parm,"score2")

replace order = 10 if strpos(parm,"length")
replace order = 11 if strpos(parm,"dorsal")
replace order = 12 if strpos(parm,"tod")
replace order = 13 if strpos(parm,"batch")
replace order = 14 if strpos(parm,"_cons")


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


replace parm = "intercept" if parm == "_cons"
replace parm = "body length (in SD)" if parm == "intlength"
replace parm = "length-normalised dorsal body surface area (in SD)" if parm == "intdorsal_area"

* make some changes to prevent work on results table
drop if inlist(parm,"tod")
drop if strpos(parm,"batch")

foreach var in beta_un SE_un LCI_un UCI_un P_un N_un t_un       beta_batch SE_batch LCI_batch UCI_batch P_batch N_batch t_batch     beta_size SE_size LCI_size UCI_size P_size N_size t_size {
replace `var´' = . if parm == "intercept"
}

foreach var in trait model parm {
replace `var´' = "" if parm == "intercept"
}

gen l=""
gen m=""

sort trait_order model order parm
drop order trait_order

format beta_un SE_un LCI_un UCI_un t_un     beta_batch SE_batch LCI_batch UCI_batch t_batch      beta_size SE_size LCI_size UCI_size t_size %6.3f
format P_un P_batch P_size %12.2e
drop if model == "random" & parm == ""
drop model

order trait parm beta_un SE_un LCI_un UCI_un P_un N_un t_un l      beta_batch SE_batch LCI_batch UCI_batch P_batch N_batch t_batch m     beta_size SE_size LCI_size UCI_size P_size N_size t_size
outsheet using "RESULTS/OB1_2_sensitivity/obesity_pop1_2_add_score2_linear_results_sensitivity.txt", noquote replace


