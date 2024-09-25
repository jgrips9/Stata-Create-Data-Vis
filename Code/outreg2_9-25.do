ssc install outreg2
sysuse auto,clear
*use "../Data/Auto.dta", clear

regress mpg foreign weight headroom trunk length turn displacement
*create regression equations and store them. 
est store Full

regress mpg foreign weight headroom
est store Restricted1

regress mpg foreign weight
est store Restricted2

*help outreg2
*Export results using outreg command. 
outreg2 [Full Restricted1 Restricted2] using "all3_models.doc", replace

    *outreg2 will take the stored estimates as wildcards (*). Try this:

outreg2 [*] using "all_models_stored.doc", replace

outreg2 foreign weight [*] using "allmodels_extended.doc",  replace side

*creating a similar result, but using tex output. 
outreg2 [Full Restricted1 Restricted2] using "all3_models_tex.tex", replace tex

*included in a loop
sysuse auto,clear
cap erase "Split_regression_loop.doc"
cap erase "Split_regression_loop.txt"
    forval num=1/5 {
        regress mpg weight headroom if rep78==`num'
		outreg2 using "Split_regression_loop.doc", ctitle (rep`num')
    }
	
	*delete extra .txt files for cleanup. 
cap erase "Split_regression_loop.txt"
cap erase "all3_models.txt"
cap erase "all_models_stored.txt"
cap erase "allmodels_extended.txt"
cap erase "all3_models_tex.txt"