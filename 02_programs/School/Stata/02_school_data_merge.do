clear all

*set the paths
gl data_dir ${clone}/01_GEPD_raw_data/
gl processed_dir ${clone}/03_GEPD_processed_data/


*save some useful locals
local preamble_info_individual school_code 
local preamble_info_school school_code 
local not school_code
local not1 interview__id

***************
***************
* Append files from various questionnaires
***************
***************
/*
gl dir_v7 "${data_dir}\\School\\School Survey - Version 7 - without 10 Revisited Schools\\"
gl dir_v8 "${data_dir}\\School\\School Survey - Version 8 - without 10 Revisited Schools\\"

* get the list of files
local files_v7: dir "${dir_v7}" files "*.dta"

di `files_v7'
* loop through the files and append into a single file saved in dir_saved
gl dir_saved "${data_dir}\\School\\"

foreach file of local files_v7 {
	di "`file'"
	use "${dir_v7}`file'", clear
	append using "${dir_v8}`file'", force
	save "${dir_saved}`file'", replace
}
*/

***************
***************
* School File
***************
***************

********
*read in the raw school file
********
frame create school
frame change school

use "${data_dir}\\School\\EPDashboard2_update.dta" 


********************************************************************************
* Comment_AR: Dropping problematic observations as a result of modules check developed:
* drop if school_code_preload == "408140059" & m2saq1 == 18 
* replace m2saq1 =. if school_code_preload == "408140059" & m2saq1 == 18 


* Duplicates:
* roster:
drop if interview__id =="b31c48fa50e14081a96416719b5e8d79"  // 408150002

* school information:
drop if interview__id == "c4692717cfd649c5b77b54e72cbccfb3" // 408140059

* teacher obervation:
drop if interview__id == "5b1191226cb2465fa8a56482650ad949" // 414040291 (Teacher Waqar Rasheed dropped) 

order school_code_preload modules__1 modules__2 modules__3 modules__4 modules__5 modules__6 modules__7 modules__8
br interview__id school_code_preload modules__1 modules__2 modules__3 modules__4 modules__5 modules__6 modules__7 modules__8 m1* m8* m4* m6* s1* s2* if school_code_preload == "414040291"



* Drop duplicate observations in m4 and s1* and s2* For 414040291:
foreach var in m4saq1 m4saq1_number m4scq1_infr m4scq2_infr m4scq3_infr m4scq4_inpt m4scq4n_girls m4scq5_inpt m4scq6_inpt m4scq7_inpt m4scq8_inpt m4scq9_inpt m4scq10_inpt m4scq11_inpt m4scq12_inpt m4scq13_girls m4scq14_see m4scq14_sound m4scq14_walk m4scq14_comms m4scq14_learn m4scq14_behav m4scq15_lang s1_0_1_1 s1_0_1_2 s1_0_2_1 s1_0_2_2 s1_0_3_1 s1_0_3_2 s1_a1 s1_a1_1 s1_a1_2 s1_a1_3 s1_a1_4a s1_a1_4b s1_a2 s1_a2_1 s1_a2_2 s1_a2_3 s1_b3 s1_b3_1 s1_b3_2 s1_b3_3 s1_b3_4 s1_b4 s1_b4_1 s1_b4_2 s1_b4_3 s1_b5 s1_b5_1 s1_b5_2 s1_b6 s1_b6_1 s1_b6_2 s1_b6_3 s1_c7 s1_c7_1 s1_c7_2 s1_c7_3 s1_c8 s1_c8_1 s1_c8_2 s1_c8_3 s1_c9 s1_c9_1 s1_c9_2 s1_c9_3 s2_0_1_1 s2_0_1_2 s2_0_2_1 s2_0_2_2 s2_0_3_1 s2_0_3_2 s2_a1 s2_a1_1 s2_a1_2 s2_a1_3 s2_a1_4a s2_a1_4b s2_a2 s2_a2_1 s2_a2_2 s2_a2_3 s2_b3 s2_b3_1 s2_b3_2 s2_b3_3 s2_b3_4 s2_b4 s2_b4_1 s2_b4_2 s2_b4_3 s2_b5 s2_b5_1 s2_b5_2 s2_b6 s2_b6_1 s2_b6_2 s2_b6_3 s2_c7 s2_c7_1 s2_c7_2 s2_c7_3 s2_c8 s2_c8_1 s2_c8_2 s2_c8_3 s2_c9 s2_c9_1 s2_c9_2 s2_c9_3  {
    // Check if the variable is numeric or string using ds
    ds `var', has(type numeric)
    if _rc == 0 { // If ds finds the variable is numeric
        replace `var' = . if interview__id == "5b1191226cb2465fa8a56482650ad949" 
    }
    else { // Otherwise, assume it is string
        replace `var' = "" if interview__id == "5b1191226cb2465fa8a56482650ad949"
    }
}



*replace m4* =. if m4 ==1 & interview__id == "5b1191226cb2465fa8a56482650ad949"
*drop if m4 ==1 & interview__id == "62d1a271b98b489189a6962369d4c96b"

replace modules__4 = 0 if interview__id == "5b1191226cb2465fa8a56482650ad949"
 



* Drop replicated module 8 filled by the enumerator:655a68c2c63848318f6941824aeb72f7655a68c2c63848318f6941824aeb72f7
* Module 8 duplciated and wrongly filled in interview_id "40e6440bd3b3408c9bdd95dac36f0183":

foreach var in m8_bilingual_class m8_bilingual_school m8_teacher_code m8_teacher_name m8s1q1__0 m8s1q1__1 m8s1q1__10 m8s1q1__11 m8s1q1__12 m8s1q1__13 m8s1q1__14 m8s1q1__15 m8s1q1__16 m8s1q1__17 m8s1q1__18 m8s1q1__19 m8s1q1__2 m8s1q1__20 m8s1q1__21 m8s1q1__22 m8s1q1__23 m8s1q1__24 m8s1q1__25 m8s1q1__26 m8s1q1__27 m8s1q1__28 m8s1q1__29 m8s1q1__3 m8s1q1__30 m8s1q1__31 m8s1q1__32 m8s1q1__33 m8s1q1__34 m8s1q1__35 m8s1q1__36 m8s1q1__37 m8s1q1__38 m8s1q1__39 m8s1q1__4 m8s1q1__40 m8s1q1__41 m8s1q1__42 m8s1q1__43 m8s1q1__44 m8s1q1__45 m8s1q1__46 m8s1q1__47 m8s1q1__48 m8s1q1__49 m8s1q1__5 m8s1q1__6 m8s1q1__7 m8s1q1__8 m8s1q1__9 {
    // Check if the variable is numeric or string using ds
    ds `var', has(type numeric)
    if _rc == 0 { // If ds finds the variable is numeric
        replace `var' = . if interview__id == "40e6440bd3b3408c9bdd95dac36f0183" 
    }
    else { // Otherwise, assume it is string
        replace `var' = "" if interview__id == "40e6440bd3b3408c9bdd95dac36f0183"
    }
}


* Wrong teacher__id entered. change from the Firm.
 replace m4saq1_number = 15 if  school_code_preload == "415050313" // wrong teacher__id entered

********************************************************************************



********
*read in the school weights
********

frame create weights
frame change weights
import delimited "${data_dir}\\Sampling\\${weights_file_name}"

* rename school code
rename ${school_code_name} school_code 
clonevar  urban_rural = location

* Comment_AR: adjust tehsil variable in the sample file. Confirm correct sample file from Brian.

ren taluka tehsil

keep school_code ${strata} ${other_info} strata_prob ipw urban_rural

gen strata=" "

foreach var in $strata {
	replace strata=strata + `var' + " - "
}

destring ipw, replace force
* duplicates drop school_code, force


******
* Merge the weights
*******
frame change school

gen school_code=school_code_preload

*Comment_AR:
replace school_code = m1s0q2_emis if school_info_correct ==0

destring school_code, force replace

frlink m:1 school_code, frame(weights)
frget ${strata} ${other_info} urban_rural strata_prob ipw strata, from(weights)

*create weight variable that is standardized
gen school_weight=1/strata_prob // school level weight

*fourth grade student level weight
egen g4_stud_count = mean(m4scq4_inpt), by(school_code)


*create collapsed school file as a temp
frame copy school school_collapse_temp
frame change school_collapse_temp

order school_code
sort school_code


********************************************************************************
* Comment_AR: Please note that m2saq1 is asked in the teacher roster (i.e. module 1). The module_1 dummy is 0 for the row which says m2saq1 = 18

/*
* Dropping problematic observation:
ta modules__1 if school_code == 408140059 & m2saq1 == 18 
drop if school_code == 408140059 & m2saq1 == 18 
*/


* Adjust value label names that are too long 

la copy fillout_teacher_questionnaire fillout_teacher_q
la val fillout_teacher_questionnaire fillout_teacher_q
la drop fillout_teacher_questionnaire
clonevar fillout_teacher_q = fillout_teacher_questionnaire
la val fillout_teacher_q fillout_teacher_q
drop fillout_teacher_questionnaire


la copy fillout_teacher_content fillout_teacher_con
la val fillout_teacher_content fillout_teacher_con
la drop fillout_teacher_content
clonevar fillout_teacher_con = fillout_teacher_content
la val fillout_teacher_q fillout_teacher_con
drop fillout_teacher_content

********************************************************************************

* collapse to school level
ds, has(type numeric)
local numvars "`r(varlist)'"
local numvars : list numvars - not

ds, has(type string)
local stringvars "`r(varlist)'"
local stringvars : list stringvars- not

* Store variable labels:

 foreach v of var * {
	local l`v' : variable label `v'
       if `"`l`v''"' == "" {
 	local l`v' "`v'"
 	}
 }

 
* Comment_AR: Adding this code for value labels: However you have to carefully select variables which remain consistent after the collapse:

 * Store value labels: 
 // This is the list of variables for which we want to save the value labels.

 
// test

label dir 
return list

local list_of_valuelables = r(names)  // specify labels you want to keep
* local list_of_valuelables =  "m7saq7 m7saq10 teacher_obs_gender"

// save the label values
label save using "${clone}/02_programs/School/Stata/labels.do", replace
// note the names of the label values for each variable that has a label value attached to it: need the variable name - value label correspodence
   local list_of_vars_w_valuelables
 * foreach var of varlist m7saq10 teacher_obs_gender m7saq7 {
   
   foreach var of varlist * {
   
   local templocal : value label `var'
   if ("`templocal'" != "") {
      local varlabel_`var' : value label `var'
      di "`var': `varlabel_`var''"
      local list_of_vars_w_valuelables "`list_of_vars_w_valuelables' `var'"
   }
}
di "`list_of_vars_w_valuelables'"



* Collapse School data: 
collapse (max) `numvars' (firstnm) `stringvars', by(school_code)

 foreach v of var * {
	label var `v' `"`l`v''"'
 }

 
// redefine the label values in collapsed file
do "${clone}/02_programs/School/Stata/labels.do"
// reattach the label values
foreach var of local list_of_vars_w_valuelables {
   cap label values `var' `varlabel_`var''
}
 
 
***************
***************
* Teacher File
***************
***************

frame create teachers
frame change teachers
********
* Addtional Cleaning may be required here to link the various modules
* We are assuming the teacher level modules (Teacher roster, Questionnaire, Pedagogy, and Content Knowledge have already been linked here)
* See Merge_Teacher_Modules code folder for help in this task if needed
********

********************************************************************************
preserve

use "${data_dir}\\School\\Sindh_teacher_level_test.dta", clear 

isid interview__key TEACHERS__id

tempfile teacher
save `teacher', replace

use"${data_dir}\\School\\questionnaire_roster_manual.dta" , clear

* rename *_manual* **
* gen TEACHERS__id=m3sb_tnumber

unique interview__key TEACHERS__id // not unique 


tempfile manual
save `manual', replace

merge 1:1 interview__key TEACHERS__id using `teacher'

tab _merge
drop _merge 

tempfile Sindh_teacher_level_test
save `Sindh_teacher_level_test', replace

restore 

********************************************************************************
* use "${data_dir}\\School\\Sindh_teacher_level_test.dta"

use `Sindh_teacher_level_test', clear



* Rename all variables to lower case:
ren *, lower 

clonevar teachers_id = teachers__id

fre m2saq3
fre in_pedagogy


* Comment_AR: Commented out as gender variable is already correctly formatted. 
* recode m2saq3 1=2 0=1


foreach var in $other_info {
	cap drop `var'
}
cap drop $strata


frlink m:1 interview__key, frame(school)


frget school_code ${strata} $other_info urban_rural strata school_weight numEligible numEligible4th, from(school)



*get number of 4th grade teachers for weights
egen g4_teacher_count=sum(m3saq2__4), by(school_code)
egen g1_teacher_count=sum(m3saq2__1), by(school_code)

order school_code
sort school_code

*weights
*teacher absense weights
*get number of teachers checked for absense
egen teacher_abs_count=count(m2sbq6_efft), by(school_code)
gen teacher_abs_weight=numEligible/teacher_abs_count
replace teacher_abs_weight=1 if missing(teacher_abs_weight) //fix issues where no g1 teachers listed. Can happen in very small schools


*teacher questionnaire weights
*get number of teachers checked for absense
egen teacher_quest_count=count(m3s0q1), by(school_code)
gen teacher_questionnaire_weight=numEligible4th/teacher_quest_count
replace teacher_questionnaire_weight=1 if missing(teacher_questionnaire_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher content knowledge weights
*get number of teachers checked for absense
egen teacher_content_count=count(m3s0q1), by(school_code)
gen teacher_content_weight=numEligible4th/teacher_content_count
replace teacher_content_weight=1 if missing(teacher_content_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher pedagogy weights
gen teacher_pedagogy_weight=numEligible4th/1 // one teacher selected
replace teacher_pedagogy_weight=1 if missing(teacher_pedagogy_weight) //fix issues where no g1 teachers listed. Can happen in very small schools


* Comment_AR: Don't know why this step is happening in the code. Take out the drop
* drop if missing(school_weight)

fre in_pedagogy
unique school_code if in_pedagogy ==1

* Comment_AR: Confirmed with Firm:
replace school_code = 408140059 if school_code ==. 

/*
* drop if interview__id == "c4692717cfd649c5b77b54e72cbccfb3"
*teacher questionnaire weights
*get number of teachers (at school) who completed the questionnaire
egen teacher_quest_count=count(m3s0q1) if m3s0q1 == 1, by(school_code) // participated in the questionnaire

*make sure we have this on on the school level
bysort school_code: egen max_teacher_quest_count = max(teacher_quest_count)
replace max_teacher_quest_count = 0 if max_teacher_quest_count == .
replace teacher_quest_count = max_teacher_quest_count

egen teacher_selected =count(m3s0q1), by(school_code) // selected for the questionnaire (in the ideal world this should be selected for both, but given the issues in CAR with the manual entry of the  questionnaire, we need to adjust this one for the assessment)

*recreate numEligible4th for the cases when it is empty
egen eligible = rowmax(m2saq7__1 m2saq7__2 m2saq7__3 m2saq7__4 m2saq7__5 m2saq7__6 m2saq7__7)
replace eligible = 0 if m2saq8__97 == 1 
replace eligible = 0 if !inlist(teacher_available, 1, 90) & !missing(teacher_available)
replace eligible = 0  if m2saq6 == 2
replace eligible = 0 if m2saq5 == 4

bysort school_code: egen numEligible4th_manual = sum(eligible)

gen teacher_questionnaire_weight=(numEligible4th_manual/teacher_selected)*(teacher_selected/teacher_quest_count)

replace teacher_questionnaire_weight=1 if missing(teacher_questionnaire_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher content knowledge weights
*recreate numEligible4th for the cases when it is empty (just do it once again given the adjustments that were made for the questionnaire)
drop eligible numEligible4th_manual

egen eligible = rowmax(m2saq7__1 m2saq7__2 m2saq7__3 m2saq7__4 m2saq7__5 m2saq7__6 m2saq7__7)
replace eligible = 0 if m2saq8__97 == 1 
replace eligible = 0 if !inlist(teacher_available, 1, 90) & !missing(teacher_available)
replace eligible = 0  if m2saq6 == 2
replace eligible = 0 if m2saq5 == 4

replace eligible = 1 if eligible != 1 & typetest != . // to include the teachers that were never supposed to be assessed but were assessed regardless

bysort school_code: egen numEligible4th_manual = sum(eligible)

*since we do not have a consent variable, what we want to do here is to assume that the consent variable from the questionnaire applies to this one as well, excluding the cases where the teachers were not eligible but that submitted the questionnaire regardless
egen teacher_content_count=count(typetest), by(school_code) // participated in the test

bysort school_code: egen max_teacher_content_count = max(teacher_content_count)
replace max_teacher_content_count = 0 if max_teacher_content_count == .
replace teacher_content_count = max_teacher_content_count

*construct selected teachers 
egen teacher_selected_content =count(m3s0q1), by(school_code) // selected for the questionnaire 

replace teacher_selected_content = teacher_content_count if teacher_selected_content == 0 & teacher_content_count != 0

gen teacher_content_weight=(numEligible4th_manual/teacher_selected_content)*(teacher_selected_content/teacher_content_count)

replace teacher_content_weight=1 if missing(teacher_content_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

*teacher pedagogy weights
*reconstuct eligibility again. for the number of eligible teachers, I use the number of 4th grade teachers that teach either math or language. For now, part-time and volunteer teachers are a part of the calculation

drop eligible numEligible4th_manual

egen eligible = rowmax(m2saq7__4)
replace eligible = 0 if m2saq8__97 == 1 // teaching other subjects
*replace eligible = 0 if !inlist(teacher_available, 1, 90) & !missing(teacher_available)
*replace eligible = 0  if m2saq6 == 2
*replace eligible = 0 if m2saq5 == 4
replace eligible = 1 if eligible == 0 & s1_0_1_1 != .

bysort school_code: egen numEligible4th_manual = sum(eligible)

*confirm that there is only one teacher per school that was observed
gen observed = 1 if  s1_0_1_1 != .
bysort school_code: egen total_observed = sum(observed)

*correct for the cases where the observed teacher is the one 
gen teacher_pedagogy_weight=numEligible4th_manual/1 // one teacher selected
replace teacher_pedagogy_weight=1 if missing(teacher_pedagogy_weight) //fix issues where no g1 teachers listed. Can happen in very small schools

isid school_code teachers__id

gen teacher_pedagogy_weight_old=numEligible4th/1 // one teacher selected
replace teacher_pedagogy_weight_old=1 if missing(teacher_pedagogy_weight_old) //fix issues where no g1 teachers listed. Can happen in very small schools
*/
//Check that manual roster info is added:
* br school_code m3* if school_code == 406031103


**TEACH: VARS: CODE REMOVED:
********************************************************************************
save "${processed_dir}\\School\\Confidential\\Merged\\teachers.dta" , replace
********************************************************************************

********
* Add some useful info back onto school frame for weighting
********

*collapse to school level
frame copy teachers teachers_school
frame change teachers_school

collapse g1_teacher_count g4_teacher_count, by(school_code)

frame change school
frlink m:1 school_code, frame(teachers_school)

frget g1_teacher_count g4_teacher_count, from(teachers_school)

***************
***************
* 1st Grade File
***************
***************

frame create first_grade
frame change first_grade
use "${data_dir}\\School\\ecd_assessment.dta" 

frlink m:1 interview__key interview__id, frame(school)
frget school_code ${strata} $other_info urban_rural strata school_weight m6_class_count g1_teacher_count, from(school)

order school_code
sort school_code

*weights
gen g1_class_weight=g1_teacher_count/1, // weight is the number of 1st grade streams divided by number selected (1)
replace g1_class_weight=1 if g1_class_weight<1 //fix issues where no g1 teachers listed. Can happen in very small schools

bysort school_code: gen g1_assess_count=_N
gen g1_student_weight_temp=m6_class_count/g1_assess_count // 3 students selected from the class

gen g1_stud_weight=g1_class_weight*g1_student_weight_temp

save "${processed_dir}\\School\\Confidential\\Merged\\first_grade_assessment.dta" , replace

***************
***************
* 4th Grade File
***************
***************

frame create fourth_grade
frame change fourth_grade
use "${data_dir}\\School\\fourth_grade_assessment.dta" 

frlink m:1 interview__key interview__id, frame(school)

* frlink m:1 interview__key, frame(school)

frget school_code ${strata}  $other_info urban_rural strata school_weight m4scq4_inpt g4_teacher_count g4_stud_count, from(school)

order school_code
sort school_code


*weights
gen g4_class_weight=g4_teacher_count/1, // weight is the number of 4tg grade streams divided by number selected (1)
replace g4_class_weight=1 if g4_class_weight<1 //fix issues where no g4 teachers listed. Can happen in very small schools

bysort school_code: gen g4_assess_count=_N

gen g4_student_weight_temp=g4_stud_count/g4_assess_count // max of 25 students selected from the class

gen g4_stud_weight=g4_class_weight*g4_student_weight_temp





*******************************************************************************
*Format school code:
format school_code %12.0f

* Comment_AR: Mannual change in school_code: 
* replace school_code = 407030180 in 2396
* replace school_code = 407030180 in 2397

* Drop duplicate observations in assessment data:

* isid school_code fourth_grade_assessment__id

duplicates tag school_code fourth_grade_assessment__id, gen(x)
list school_code if x ==1 

drop if interview__id == "587406646cbe4f7f8b2ae9fade70c555"

isid school_code fourth_grade_assessment__id


*******************************************************************************


save "${processed_dir}\\School\\Confidential\\Merged\\fourth_grade_assessment.dta" , replace


***************
***************
* Collapse school data file to be unique at school_code level
***************
***************

frame change school


*******
* collapse to school level
*******

*drop some unneeded info
drop enumerators*

order school_code
sort school_code

********************************************************************************
* Comment_AR:

* Adjust value label names that are too long 

la copy fillout_teacher_questionnaire fillout_teacher_q
la val fillout_teacher_questionnaire fillout_teacher_q
la drop fillout_teacher_questionnaire
clonevar fillout_teacher_q = fillout_teacher_questionnaire
la val fillout_teacher_q fillout_teacher_q
drop fillout_teacher_questionnaire


la copy fillout_teacher_content fillout_teacher_con
la val fillout_teacher_content fillout_teacher_con
la drop fillout_teacher_content
clonevar fillout_teacher_con = fillout_teacher_content
la val fillout_teacher_con fillout_teacher_con
drop fillout_teacher_content

********************************************************************************


* collapse to school level
ds, has(type numeric)
local numvars "`r(varlist)'"
local numvars : list numvars - not

ds, has(type string)
local stringvars "`r(varlist)'"
local stringvars : list stringvars- not

tempfile school_file_bc
save `school_file_bc', replace


* Store variable labels:

 foreach v of var * {
	local l`v' : variable label `v'
       if `"`l`v''"' == "" {
 	local l`v' "`v'"
 	}
 }

 
 * Store value labels: 
 
label dir 
return list


local list_of_valuelables = r(names)  // specify labels you want to keep
* local list_of_valuelables =  "m7saq7 m7saq10 teacher_obs_gender"

// save the label values in labels.do file to be executed after the collapse:
label save using "${clone}/02_programs/School/Stata/labels.do", replace
// note the names of the label values for each variable that has a label value attached to it: need the variable name - value label correspodence
   local list_of_vars_w_valuelables
 * foreach var of varlist m7saq10 teacher_obs_gender m7saq7 {
   
   foreach var of varlist * {
   
   local templocal : value label `var'
   if ("`templocal'" != "") {
      local varlabel_`var' : value label `var'
      di "`var': `varlabel_`var''"
      local list_of_vars_w_valuelables "`list_of_vars_w_valuelables' `var'"
   }
}
di "`list_of_vars_w_valuelables'"




********************************************************************************
* Collapse: 
 
*drop labels and then reattach
label drop _all
collapse (mean) `numvars' (firstnm) `stringvars', by(school_code)

********************************************************************************

/*
* Making the Format for variables consistent before the collapse: IMPORTANT before the collapse: 
format fillout_teacher_con %9.0fc
format m1sbq3_infr %9.0fc
*/

* Comment_AR: After the collpase above the variable type percision changes from byte to double 

// Round variables to convert them from a new variable with byte precision

local lab_issue "fillout_teacher_con m1s0q3_infr m1scq13_imon__4 m1scq12_imon__2 m1scq12_imon__1 m1scq7_imon m1scq6_imon__2 m1scq6_imon__1 m1scq4_imon__3 m1sbq10_infr m1sbq8_infr m1sbq5_infr m1s0q3_infr m1s0q2_infr m1sbq3_infr"

foreach var of local lab_issue {	
replace `var' = round(`var')
}

* Redefine var labels:  
  foreach v of var * {
	label var `v' `"`l`v''"'
 }
 
// Run labels.do to redefine the label values in collapsed file
do "${clone}/02_programs/School/Stata/labels.do"
// reattach the label values
foreach var of local list_of_vars_w_valuelables {
   cap label values `var' `varlabel_`var''
}


/*
* 0 issue:
fre m1s0q3_infr
fre m1scq13_imon__4 
fre m1scq12_imon__2 
fre m1scq12_imon__1 
fre m1scq7_imon
fre m1scq6_imon__2
fre m1scq6_imon__1 
fre m1scq4_imon__3 
fre m1sbq10_infr 
fre m1sbq8_infr
fre m1sbq5_infr
fre m1s0q3_infr 
fre m1s0q2_infr

* 2 issue: 
fre m1sbq3_infr
*/

* Comment_AR: School files labels are holding up till here // placeholder
 
 
 
 
* Firm confirmed this change:

isid school_code 


list m6_teacher_code if school_code == 406030334
replace m6_teacher_code = 7 if school_code == 406030334


 
save "${processed_dir}\\School\\Confidential\\Merged\\school.dta" , replace