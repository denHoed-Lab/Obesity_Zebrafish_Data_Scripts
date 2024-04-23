set more off
clear
cd "/Users/eugma242/Documents/Documents/Projects/Obesity POP/Overfeeding/Food_experiment_analysis/220422/combined/"

** Examine the effect of overfeeding (regardless of diet) adjusted for tank (in residuals) and tod and age
use "DATA/food_experiment_for_analysis.dta", clear

/*
Legend condition:
A = overfeeding old
B = normal old
C = normal new
D = overfeeding new
*/

gen overfeeding = 0
replace overfeeding = 1 if condition == "A"
replace overfeeding = 1 if condition == "D"
tab overfeeding condition, missing

gen diet = 0
replace diet = 1 if condition == "A"
replace diet = 1 if condition == "B"
tab diet condition, missing
*tab overfeeding bodyfat
*tab overfeeding pectoral
*tab overfeeding abdominal
*tab overfeeding opercular
*tab overfeeding cardiac
*tab overfeeding numberadipocytes


foreach outcome in intlength ///
intNrLipids intLiverRefinedArea ///
intNrCells intVolume intCellVolume_Av intCellVolume_Stdev intCellInt_Av intCellInt_Stdev intIV intISA intIED intIPAL1 intIPAL2 intIPAL3 intAreaEye {

preserve
regress `outcome' i.overfeeding tod i.batch i.tank i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_batch/`outcome'_est", replace)
use "RESULTS/overfeeding_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_batch/`outcome'_est", replace
restore
}

foreach outcome in intdorsal_area intlateral_area {

preserve
regress `outcome' i.overfeeding tod i.batch i.tank length i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_batch/`outcome'_est", replace)
use "RESULTS/overfeeding_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_batch/`outcome'_est", replace
restore
}

foreach outcome in intldl inttg inttc intgluc {

preserve
regress `outcome' i.overfeeding tod i.batch i.tank pos_bio i.batch_bio i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_batch/`outcome'_est", replace)
use "RESULTS/overfeeding_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_batch/`outcome'_est", replace
restore
}

foreach outcome in bld {

preserve
nbreg `outcome' i.overfeeding tod i.batch 
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_batch/`outcome'_est", replace)
use "RESULTS/overfeeding_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_batch/`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' i.overfeeding tod i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_batch/`outcome'_est", replace)
use "RESULTS/overfeeding_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_batch/`outcome'_est", replace
restore
}

foreach outcome in numberadipocytes {

preserve
nbreg `outcome' i.overfeeding tod i.batch
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_batch/`outcome'_est", replace)
use "RESULTS/overfeeding_batch/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_batch/`outcome'_est", replace
restore
}

* now append
clear
save "RESULTS/overfeeding_batch/3xoverfeeding_batch.dta", replace emptyok 

foreach file in intlength_est intdorsal_area_est intlateral_area_est ///
intldl_est inttg_est inttc_est intgluc_est ///
intNrLipids_est intLiverRefinedArea_est ///
intNrCells_est intVolume_est intCellVolume_Av_est intCellVolume_Stdev_est intCellInt_Av_est intCellInt_Stdev_est intIV_est intISA_est intIED_est intIPAL1_est intIPAL2_est intIPAL3_est intAreaEye_est ///
bodyfat_est bld_est numberadipocytes_est {

use "RESULTS/overfeeding_batch/`file'", clear
gen model="`file'"
append using "RESULTS/overfeeding_batch/3xoverfeeding_batch.dta"
save "RESULTS/overfeeding_batch/3xoverfeeding_batch.dta", replace
}
use "RESULTS/overfeeding_batch/3xoverfeeding_batch.dta", clear
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
drop id order
drop if strpos(parm,"batch")
drop if strpos(parm,"tank")
save "RESULTS/fixed_effects_3xoverfeeding_batch.dta", replace
export excel using "RESULTS/fixed_effects_3xoverfeeding_batch.xls", replace firstrow(variables)





******************************




** Examine the effect of overfeeding (regardless of diet) additioanlly adjusted for size 
use "DATA/food_experiment_for_analysis.dta", clear

/*
Legend condition:
A = overfeeding old
B = normal old
C = normal new
D = overfeeding new
*/

gen overfeeding = 0
replace overfeeding = 1 if condition == "A"
replace overfeeding = 1 if condition == "D"
tab overfeeding condition, missing

gen diet = 0
replace diet = 1 if condition == "A"
replace diet = 1 if condition == "B"
tab diet condition, missing

foreach outcome in intldl inttg inttc intgluc {

preserve
regress `outcome' i.overfeeding tod length dorsal_area pos_bio i.batch_bio i.batch i.tank i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_size/`outcome'_est", replace)
use "RESULTS/overfeeding_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_size/`outcome'_est", replace
restore
}

foreach outcome in intNrLipids intLiverRefinedArea ///
intNrCells intVolume intCellVolume_Av intCellVolume_Stdev intCellInt_Av intCellInt_Stdev intIV intISA intIED intIPAL1 intIPAL2 intIPAL3 intAreaEye {

preserve
regress `outcome' i.overfeeding tod length dorsal_area i.batch i.tank i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_size/`outcome'_est", replace)
use "RESULTS/overfeeding_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_size/`outcome'_est", replace
restore
}

foreach outcome in bld {

preserve
nbreg `outcome' i.overfeeding tod length dorsal_area i.batch i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_size/`outcome'_est", replace)
use "RESULTS/overfeeding_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_size/`outcome'_est", replace
restore
}

foreach outcome in bodyfat {

preserve
logit `outcome' i.overfeeding tod length dorsal_area i.batch i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_size/`outcome'_est", replace)
use "RESULTS/overfeeding_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_size/`outcome'_est", replace
restore
}

foreach outcome in numberadipocytes {

preserve
nbreg `outcome' i.overfeeding tod length dorsal_area i.batch i.diet
parmest, format(estimate %8.6f min95 max95 %8.6f p %8.1e) saving ("RESULTS/overfeeding_size/`outcome'_est", replace)
use "RESULTS/overfeeding_size/`outcome'_est", clear
gen N=e(N)
save "RESULTS/overfeeding_size/`outcome'_est", replace
restore
}

* now append
clear
save "RESULTS/overfeeding_size/3xoverfeeding_size.dta", replace emptyok 

foreach file in intldl_est inttg_est inttc_est intgluc_est ///
intNrLipids_est intLiverRefinedArea_est ///
intNrCells_est intVolume_est intCellVolume_Av_est intCellVolume_Stdev_est intCellInt_Av_est intCellInt_Stdev_est intIV_est intISA_est intIED_est intIPAL1_est intIPAL2_est intIPAL3_est intAreaEye_est ///
bodyfat_est bld_est numberadipocytes_est {

use "RESULTS/overfeeding_size/`file'", clear
gen model="`file'"
append using "RESULTS/overfeeding_size/3xoverfeeding_size.dta"
save "RESULTS/overfeeding_size/3xoverfeeding_size.dta", replace
}
use "RESULTS/overfeeding_size/3xoverfeeding_size.dta", clear
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
drop id order
drop if strpos(parm,"batch")
drop if strpos(parm,"tank")
save "RESULTS/fixed_effects_3xoverfeeding_size.dta", replace
export excel using "RESULTS/fixed_3xeffects_overfeeding_size.xls", replace firstrow(variables)





******************************




** Merge results files with summary statistics
use "RESULTS/fixed_effects_3xoverfeeding_batch.dta", clear
merge 1:1 trait model parm using "RESULTS/fixed_effects_3xoverfeeding_size.dta"
drop _merge

gen order = .
replace order = 1 if strpos(parm,"1.overfeeding")
replace order = 7 if strpos(parm,"length")
replace order = 8 if strpos(parm,"dorsal")
replace order = 9 if strpos(parm,"1.age")
replace order = 10 if strpos(parm,"tod")
replace order = 11 if strpos(parm,"batch")
replace order = 12 if strpos(parm,"_cons")

gen trait_order = .
replace trait_order = 1 if strpos(trait,"length")
replace trait_order = 2 if strpos(trait,"dorsal")
replace trait_order = 3 if strpos(trait,"lateral")

replace trait_order = 6 if strpos(trait,"intldl")
replace trait_order = 9 if strpos(trait,"inttg")
replace trait_order = 11 if strpos(trait,"inttc")
replace trait_order = 12 if strpos(trait,"intgluc")

replace trait_order = 15 if strpos(trait,"LiverArea")
replace trait_order = 16 if strpos(trait,"intLiverRefinedArea")
replace trait_order = 17 if strpos(trait,"NrofSpots")
replace trait_order = 20 if strpos(trait,"intNrLipids")
replace trait_order = 21 if strpos(trait,"bodyfat")
replace trait_order = 22 if strpos(trait,"bld")

replace trait_order = 25 if strpos(trait,"N_beta_cells")
replace trait_order = 26 if strpos(trait,"NrCells")

replace trait_order = 32 if strpos(trait,"Volume")
replace trait_order = 33 if strpos(trait,"CellVolume_Av")
replace trait_order = 34 if strpos(trait,"CellVolume_Stdev")

replace trait_order = 42 if strpos(trait,"CellInt_Av")
replace trait_order = 43 if strpos(trait,"CellInt_Stdev")

replace trait_order = 50 if strpos(trait,"IED")
replace trait_order = 51 if strpos(trait,"IPAL1")
replace trait_order = 52 if strpos(trait,"IPAL2")
replace trait_order = 53 if strpos(trait,"IPAL3")
replace trait_order = 54 if strpos(trait,"ISA")
replace trait_order = 55 if strpos(trait,"IV")
replace trait_order = 56 if strpos(trait,"AreaEye")
replace trait_order = 57 if strpos(trait,"numberadipocytes")


replace parm = "intercept" if parm == "_cons"
replace parm = "body length (in SD)" if parm == "intlength"
replace parm = "length-normalised dorsal body surface area (in SD)" if parm == "intdorsal_area"

* make some changes to prevent work on results table

foreach var in beta_batch SE_batch LCI_batch UCI_batch t_batch P_batch N_batch beta_size SE_size LCI_size UCI_size t_size P_size N_size {
replace `var´' = . if parm == "intercept"
}

foreach var in trait model parm {
replace `var´' = "" if parm == "intercept"
}

gen l=""

sort trait_order model order parm
drop order trait_order

format beta_batch SE_batch LCI_batch UCI_batch t_batch      beta_size SE_size LCI_size UCI_size t_size %6.3f
format P_batch P_size %12.2e
drop if model == "random" & parm == ""
drop model eq

order trait parm beta_batch SE_batch LCI_batch UCI_batch t_batch P_batch N_batch l     beta_size SE_size LCI_size UCI_size t_size P_size N_size

replace parm = "overfeeding" if parm == "1.overfeeding"

outsheet using "RESULTS/3xoverfeeding_RegardlessOfDied_results.txt", noquote replace


