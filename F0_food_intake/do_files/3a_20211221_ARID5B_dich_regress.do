set more off
clear
cd "/Users/marde358/Desktop/Projects/Novo_screen"

** Examine the effect of mutations in arid5b adjusted for tank, batch (in residuals) and tod (all larvae are 8dpf)
use "DATA/food_intake/200_ARID5B/ARID5B_for_analysis.dta", clear
* 8 dpf

foreach outcome in intlength intIntestine_area {

preserve
regress `outcome' i.arid5b_dich i.batch i.tank tod
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace)
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace
restore
}

foreach outcome in intdorsal_area intlateral_area {

preserve
regress `outcome' i.arid5b_dich length i.batch i.tank tod
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace)
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace
restore
}

/*
foreach outcome in intldl inttg inttc intgluc {

preserve
regress `outcome' i.arid5b_dich pos_bio i.batch_bio i.tank tod
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace)
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace
restore
}
*/

foreach outcome in Food_fluo_cat Food_fluo_cat_all {

preserve
* can't accomplish convergence when adjusting for f_batch and tod, so only adjusting for the latter
mlogit `outcome' i.arid5b_dich i.batch i.tank tod, rrr baseoutcome(2)
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace)
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`outcome'_est", replace
restore
}

* now append
clear
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/arid5b_dich_batch.dta", replace emptyok 

foreach file in intlength_est intdorsal_area_est intlateral_area_est ///
/*intldl_est inttg_est inttc_est intgluc_est*/ ///
intIntestine_area_est Food_fluo_cat_est Food_fluo_cat_all_est {

use "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/`file'", clear
gen model="`file'"
append using "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/arid5b_dich_batch.dta"
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/arid5b_dich_batch.dta", replace
}
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_batch/arid5b_dich_batch.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
replace t = z if t == .
drop dof z
egen id=concat(parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)
order trait model parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 t N p) (beta_batch SE_batch LCI_batch UCI_batch t_batch N_batch P_batch)

sort trait model order
drop id order

bysort trait parm eq model: gen N=_n
keep if N==1
drop N
* removes one "_cons" that we do not keep anyway

save "RESULTS/food_intake/200_ARID5B/fixed_effects_f0_arid5b_dich_batch.dta", replace
export excel using "RESULTS/food_intake/200_ARID5B/fixed_effects_f0_arid5b_dich_batch.xls", replace firstrow(variables)





******************************





** Examine the effect of mutations in arid5b additionally adjusted for size
use "DATA/food_intake/200_ARID5B/ARID5B_for_analysis.dta", clear
set more off

foreach outcome in intIntestine_area {

preserve
regress `outcome' i.arid5b_dich length dorsal_area i.batch i.tank tod
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`outcome'_est", replace)
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`outcome'_est", replace
restore
}

/*
foreach outcome in intldl inttg inttc intgluc {

preserve
regress `outcome' i.arid5b_dich length dorsal_area pos_bio i.batch_bio i.tank tod
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`outcome'_est", replace)
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`outcome'_est", replace
restore
}
*/

* now append
clear
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/arid5b_dich_size.dta", replace emptyok 

foreach file in /*intldl_est inttg_est inttc_est intgluc_est*/ ///
intIntestine_area_est {

use "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/`file'", clear
gen model="`file'"
append using "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/arid5b_dich_size.dta"
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/arid5b_dich_size.dta", replace
}
use "RESULTS/food_intake/200_ARID5B/arid5b_dich_size/arid5b_dich_size.dta", clear
drop if strpos(parm,"b.")
drop if strpos(parm,"o.")
drop dof
egen id=concat(parm) if parm=="_cons"
replace id=parm if id==""
sort model, stable
by model: gen order=_n

gen trait = substr(model,1,length(model)-4)
order trait model parm estimate stderr min95 max95 p N
rename (estimate stderr min95 max95 N p t) (beta_size SE_size LCI_size UCI_size N_size P_size t_size)

sort trait model order
drop id order

bysort trait parm model: gen N=_n
keep if N==1
drop N

gen eq = ""

save "RESULTS/food_intake/200_ARID5B/fixed_effects_f0_arid5b_dich_size.dta", replace
export excel using "RESULTS/food_intake/200_ARID5B/fixed_effects_f0_arid5b_dich_size.xls", replace firstrow(variables)





******************************




** Merge results files with summary statistics
use "RESULTS/food_intake/200_ARID5B/fixed_effects_f0_arid5b_dich_batch.dta", clear
merge 1:1 trait model eq parm using "RESULTS/food_intake/200_ARID5B/fixed_effects_f0_arid5b_dich_size.dta"
drop _merge

drop if strpos(parm,"batch")
drop if strpos(parm,"tank")

gen order = .
replace order = 1 if strpos(parm,"1.arid5b_dich")
replace order = 5 if strpos(parm,"length")
replace order = 6 if strpos(parm,"dorsal")
replace order = 7 if strpos(parm,"Intestine_area")
replace order = 9 if strpos(parm,"1.age")
replace order = 10 if strpos(parm,"tod")
replace order = 11 if strpos(parm,"f_batch")
replace order = 12 if strpos(parm,"_cons")

gen trait_order = .
replace trait_order = 1 if strpos(trait,"Food_fluo_cat")
replace trait_order = 2 if strpos(trait,"Food_fluo_cat_all")
replace trait_order = 3 if strpos(trait,"Intestine_area")

replace trait_order = 4 if strpos(trait,"intldl")
replace trait_order = 5 if strpos(trait,"inttg")
replace trait_order = 6 if strpos(trait,"inttc")
replace trait_order = 7 if strpos(trait,"intgluc")

replace trait_order = 8 if strpos(trait,"length")
replace trait_order = 9 if strpos(trait,"dorsal")
replace trait_order = 10 if strpos(trait,"lateral")

replace parm = "intercept" if parm == "_cons"
replace parm = "body length (in SD)" if parm == "intlength"
replace parm = "length-normalised dorsal body surface area (in SD)" if parm == "intdorsal_area"
replace parm = "time of imaging (per h effect)" if parm == "tod"

* make some changes to prevent work on results table

foreach var in beta_batch SE_batch LCI_batch UCI_batch t_batch P_batch N_batch beta_size SE_size LCI_size UCI_size t_size P_size N_size {
replace `var´' = . if parm == "intercept"
}

foreach var in trait model parm {
replace `var´' = "" if parm == "intercept"
}

drop if eq != "" & parm == ""

gen l=""

sort trait_order model order parm eq
drop order trait_order

format beta_batch SE_batch LCI_batch UCI_batch t_batch      beta_size SE_size LCI_size UCI_size t_size %6.3f
format P_batch P_size %12.2e
drop if model == "random" & parm == ""
drop model

order trait parm eq beta_batch SE_batch LCI_batch UCI_batch t_batch P_batch N_batch l     beta_size SE_size LCI_size UCI_size t_size P_size N_size

replace parm = "arid5b_dich" if parm == "1.arid5b_dich"

replace trait = substr(trait,4,.) if inlist(trait,"intIntestine_area","intlength","intdorsal_area","intlateral_area")
rename eq category
drop if parm == "time of imaging (per h effect)"

outsheet using "RESULTS/food_intake/200_ARID5B/arid5b_dich_results.txt", noquote replace
save "RESULTS/food_intake/200_ARID5B/arid5b_dich_results.dta", replace
outsheet using "/Users/marde358/Desktop/Projects/Novo_screen/OUTPUT/sumstats/Food_intake/arid5b_dich_results.txt", noquote replace

