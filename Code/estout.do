*eststo packages. Install the estout package. 
*Specific packages created to export results nicely. Install using command below 
ssc install estout, replace

*create regression table
sysuse auto, clear
*use "../Data/Auto.dta", clear

*create regression equation
reg mpg foreign
*Store recently generated results into m1. 
est sto m1
reg mpg foreign weight
*new regression equation, store into m2
est sto m2
reg mpg foreign weight displacement gear_ratio
est sto m3

reg mpg weight length
est save "../Output/Tables/reg4.ster", replace

esttab m1 m2 m3

*Add some more formatting to this table. So it looks nicer.  
****************

esttab m1 m2 m3 using "../Output/Tables/multiple regression.rtf", label nonumber title("Models of MPG") mtitle("Car Type" "Weight, Car Type" "Weight, Car Type, Displacement, Gear") p star(+ 0.1 * 0.05 ** 0.01) replace

*clear and bring back saved regression results. 
clear all
est use "../Output/Tables/reg4.ster"
regress
est sto q1
esttab q1 using "../Output/Tables/single regression.rtf", p star(+ 0.1 * 0.05 ** 0.01) replace mtitle("MPG x Weight x Length")

*Summary tables. Make this look nicer as well.  
**************
sysuse auto, clear
estpost sum price foreign mpg, d

esttab using "../Output/Tables/SummaryStats.rtf", modelwidth(10 20) cell((mean(label(Mean)) sd(par label(Standard Deviation)))) label nomtitle nonumber replace

*Adding more statistics. 
*esttab using "../Output/table.rtf", modelwidth(10 20) cell((mean(label(Mean)) sd(par label(Standard Deviation)) min(label(Minimum)) max(label(Maximum)) p25(label(FirstQuartile)))) label nomtitle nonumber replace

*Erase file for cleanup
cap erase "../Output/Tables/reg4.ster"

