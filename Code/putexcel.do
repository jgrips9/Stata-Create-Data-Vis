sysuse auto, clear
*to pull from data folder. Use the code below.
*use "../Data/Auto.dta", clear

*variable list macro
local vlist price mpg trunk weight length turn displacement headroom
*Excel cells organization macro.
local exnum = 2

*help putexcel
putexcel set "../Output/Tables/Descriptive Stats_excel.xlsx", sheet(res) replace
putexcel (A1) = ("OBS") (B1) = ("Mean") (C1) = ("standard Error") (D1) = ("Lower Bound") (E1) = ("Upper Bound") (F1) = ("Confidence Level")

foreach var of varlist `vlist' {
*perform cimean of variables in order of macro: price mpg trunk weight length turn displacement headroom
ci means `var'
*Place variable name in own row, bolded text.
putexcel (A`exnum') = "`var'", bold
*Increase organize macro to go to next row in excel.
local exnum = `exnum' + 1
*Place measures of ci mean into excel
putexcel (A`exnum') = rscalars, colwise
*2 new rows when switching to new variable.
local exnum = `exnum' + 2
}
putexcel save