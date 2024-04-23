set more off
clear
cd "/Users/endmu284/Desktop/Projects/Novo_screen"



foreach x in "MC4R" "POMCA" "NEGR1" "IRS1" "IRS2" {

	
** Examine the effect of mutations in each gene adjusted for tank, batch and tod
** Not adjusting for age because it is all 11 dpf. Batch is only relevant for MC4R and NEGR1, the rest were imaged in a single day.
use "DATA/bodyfat_bygene/`x'/`x'_for_analysis.dta", clear

gen x="`x'"
*egen y=ends(x) , punct(_) tail trim
*levelsof y, local(y) clean
gen z=lower("`x'")
levelsof z, local(z) clean

foreach outcome in intlength  {

preserve
regress `outcome' i.`z'_dich tod i.tank i.batch 
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", replace)
use "RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", replace
restore
}


foreach outcome in intdorsal_area intlateral_area {

preserve
regress `outcome' i.`z'_dich tod i.tank i.batch length 
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", replace)
use "RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", replace
restore
}

*Bodyfat dichotomous variable

foreach outcome in bodyfat {

preserve
logistic `outcome' i.`z'_dich tod i.tank i.batch
parmest, eform format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", replace)
use "RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/bodyfat/`x'/`z'_dich_batch/`outcome'_est", replace
restore
}


** Examine the 2x2 tables of genotype vs bodyfat with Chi2 
use "DATA/bodyfat_bygene/`x'/`x'_for_analysis.dta", clear
tab `z'_dich bodyfat, chi2

* now append
clear

save "RESULTS/bodyfat/`x'/`z'_dich_batch/`z'_dich_batch.dta", replace emptyok 

foreach file in intlength_est intdorsal_area_est intlateral_area_est bodyfat_est  {

use "RESULTS/bodyfat/`x'/`z'_dich_batch/`file'", clear
gen model="`file'"
capture rename t z 

append using "RESULTS/bodyfat/`x'/`z'_dich_batch/`z'_dich_batch.dta"
save "RESULTS/bodyfat/`x'/`z'_dich_batch/`z'_dich_batch.dta", replace
}
use "RESULTS/bodyfat/`x'/`z'_dich_batch/`z'_dich_batch.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
drop dof
egen id=concat(parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)

order trait model parm estimate stderr min95 max95 t p N
rename (estimate stderr min95 max95 N p z) (beta_batch SE_batch LCI_batch UCI_batch N_batch P_batch z_batch)
sort trait model order
drop id order
save "RESULTS/bodyfat/`x'/fixed_effects_f0_`z'_dich_batch.dta", replace
export excel using "RESULTS/bodyfat/`x'/fixed_effects_f0_`z'_dich_batch.xls", replace firstrow(variables)





******************************


/*

set more off
clear
cd "/Users/endmu284/Desktop/Projects/Novo_screen"




** Examine the effect of mutations additionally adjusted for size


foreach x in "MC4R" "POMCA" "NEGR1" "IRS1" "IRS2" {

	
** Examine the effect of mutations in each gene adjusted for tank, batch and tod
** Not adjusting for age because it is all 11 dpf. Batch is only relevant for MC4R and NEGR1, the rest were imaged in a single day. However, i did not include batch bio but only the batch generated globally (across all experiments combined). I could adjust for vast maybe? If they were imaged on vast 1 or 2 but I don't think that should affect these results
use "DATA/bodyfat_bygene/`x'/`x'_for_analysis.dta", clear

gen x="`x'"
*egen y=ends(x) , punct(_) tail trim
*levelsof y, local(y) clean
gen z=lower("`x'")
levelsof z, local(z) clean



foreach outcome in bodyfat {

preserve
logistic `outcome' i.`z'_dich tod i.tank i.batch intlength
parmest, eform format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/bodyfat/`x'/`z'_dich_size/`outcome'_est", replace)
use "RESULTS/bodyfat/`x'/`z'_dich_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/bodyfat/`x'/`z'_dich_size/`outcome'_est", replace
restore
}

* now append
clear

save "RESULTS/bodyfat/`x'/`z'_dich_size/`z'_dich_size.dta", replace emptyok 

foreach file in  bodyfat_est  {

use "RESULTS/bodyfat/`x'/`z'_dich_size/`file'", clear
gen model="`file'"
*capture rename t z 

append using "RESULTS/bodyfat/`x'/`z'_dich_size/`z'_dich_size.dta"
save "RESULTS/bodyfat/`x'/`z'_dich_size/`z'_dich_size.dta", replace
}
use "RESULTS/bodyfat/`x'/`z'_dich_size/`z'_dich_size.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
*drop dof
egen id=concat(parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)

order trait model parm estimate stderr min95 max95 t p N
rename (estimate stderr min95 max95 N p z) (beta_batch SE_batch LCI_batch UCI_batch N_batch P_batch z_batch)
sort trait model order
drop id order
save "RESULTS/bodyfat/`x'/fixed_effects_f0_`z'_dich_size.dta", replace
export excel using "RESULTS/bodyfat/`x'/fixed_effects_f0_`z'_dich_size.xls", replace firstrow(variables)
}
*/



******************************




** Merge results files with summary statistics
use "RESULTS/bodyfat/`x'/fixed_effects_f0_`z'_dich_batch.dta", clear
*erge 1:1 trait model parm using "RESULTS/liver/ins_lfabp10a/`x'/fixed_effects_f0_`y'_dich_size.dta"
*rop _merge

gen order = .
replace order = 1 if strpos(parm,"1.`z'_dich")
replace order = 2 if strpos(parm,"batch")
*replace order = 3 if strpos(parm,"tank")
replace order = 4 if strpos(parm,"tod2")
replace order = 5 if strpos(parm,"length")
replace order = 6 if strpos(parm,"dorsal_area")
replace order = 7 if strpos(parm,"_cons")

gen trait_order = .

replace trait_order = 1 if strpos(trait,"bodyfat")
replace trait_order = 2 if strpos(trait,"intlength")
replace trait_order = 3 if strpos(trait,"intdorsal")
replace trait_order = 4 if strpos(trait,"intlateral")

replace parm = "intercept" if parm == "_cons"
replace parm = "body length (in SD)" if parm == "intlength"
replace parm = "length-normalised dorsal body surface area (in SD)" if parm == "intdorsal_area"
*replace parm = "10 dpf vs. 9 dpf" if parm == "10.age"
*replace parm = "11 dpf vs. 9 dpf" if parm == "11.age"
replace parm = "time of imaging (per h effect)" if parm == "tod"

* make some changes to prevent work on results table

foreach var in beta_batch SE_batch LCI_batch UCI_batch z_batch P_batch N_batch   {
replace `var´' = . if parm == "intercept"
}

foreach var in trait model parm {
replace `var´' = "" if parm == "intercept"
}

gen l=""

sort trait_order model order parm
drop order trait_order

format beta_batch SE_batch LCI_batch UCI_batch z_batch    %6.3f
format P_batch  %12.2e
drop if model == "random" & parm == ""
drop model

order trait parm beta_batch SE_batch LCI_batch UCI_batch z_batch P_batch N_batch l     
replace parm = "`z'_dich" if parm == "1.`z'_dich"
*drop if strpos(parm,".batch")
*drop if strpos(parm,".tank")
drop eq
drop l
* save sumstats 
outsheet using "RESULTS/bodyfat/`x'/`z'_dich_results.txt", noquote replace
outsheet using "/Users/endmu284/Desktop/Projects/Novo_screen/OUTPUT/sumstats/bodyfat/sibling_controls/`z'_siblings_results.txt", noquote replace


foreach x in "MC4R" "POMCA" "NEGR1" "IRS1" "IRS2" {


** Examine the 2x2 tables of genotype vs bodyfat with Chi2 
use "DATA/bodyfat_bygene/`x'/`x'_for_analysis.dta", clear
tab `z'_dich bodyfat, chi2

}
