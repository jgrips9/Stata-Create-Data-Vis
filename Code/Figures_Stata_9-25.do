*install packages*Through 
ssc install schemepack, replace
ssc install colrspace, replace
ssc install palettes, replace
ssc install labutil, replace

* Correlation Coef with CI (Nick Cox - corrci) (type in command window: search pr0041_4)
net describe pr0041_4, from(http://www.stata-journal.com/software/sj21-3)
*net install pr0041_4 
 
ssc install violinplot, replace
ssc install dstat, replace
ssc install moremata, replace
 
 *bar plot. side by side
 *stacked bar
 *import sample dataset
import delimited "https://raw.githubusercontent.com/tidyverse/ggplot2/master/data-raw/mpg.csv", clear
 
 *Make the number of bars less. 
keep if manufacturer == "audi" | manufacturer == "chevrolet" | manufacturer == "dodge" | manufacturer == "ford" | manufacturer == "volkswagen" | manufacturer == "toyota"
 
 *side by side barplot frequency by group
graph bar (count), over(class) over(manufacturer) asyvars /// ///
      legend(order(7 "SUV" 6 "Subcompact" 5 "Pickup" 4 "Minivan" 3 "Midsize" 2 "Compact" 1 "2 Seater")) ///
      title("{bf}Histogram on Categorical Variable", pos(11) size(2.75)) ///
      subtitle("Manufacturer across Vehicle Classes", pos(11) size(2))
graph export "side_byside_bar.pdf", replace	

 *side by side barplot percentage by group
graph bar (count), over(class) over(manufacturer) asyvars percentage /// ///
      legend(order(7 "SUV" 6 "Subcompact" 5 "Pickup" 4 "Minivan" 3 "Midsize" 2 "Compact" 1 "2 Seater")) ///
      title("{bf}Histogram on Categorical Variable", pos(11) size(2.75)) ///
      subtitle("Manufacturer across Vehicle Classes", pos(11) size(2))
graph export "side_byside_bar_full.pdf", replace

 
graph bar (count),  over(class) over(manufacturer, label(alternate labsize(2))) asyvars stack ///
      scheme(white_w3d) ///
      legend(order(7 "SUV" 6 "Subcompact" 5 "Pickup" 4 "Minivan" 3 "Midsize" 2 "Compact" 1 "2 Seater") rowgap(0.25) size(2)) ///
      title("{bf}Histogram on Categorical Variable", pos(11) size(2.75)) ///
      subtitle("Manufacturer across Vehicle Classes", pos(11) size(2)) 
graph export "stacked_bar.pdf", replace	

*stacked barplot by percentage of group. 
graph bar,  over(class) over(manufacturer, label(alternate labsize(2))) asyvars stack percentage ///
      scheme(white_w3d) ///
      legend(order(7 "SUV" 6 "Subcompact" 5 "Pickup" 4 "Minivan" 3 "Midsize" 2 "Compact" 1 "2 Seater") rowgap(0.25) size(2)) ///
      title("{bf}Histogram on Categorical Variable", pos(11) size(2.75)) ///
      subtitle("Manufacturer across Vehicle Classes", pos(11) size(2)) 
graph export "stacked_bar_full.pdf", replace	


*Violin Plot
 * This plot contains box and distribution
 *Uses package ssc violinplot
 *width of graph is the frequency of that value. 
violinplot cty,  over(class) vertical scheme(white_w3d) ///
      ytitle("City Mileage", size(2.25)) ///
      title("{bf}Box Plot", pos(11) size(2.75)) ///
      b1title(" " "Class of vehicle", size(2.5)) ///
      subtitle("City Mileage grouped by class of vehicle", pos(11) size(2))
      
 
 *ssc install violinplot, replace
 
 * To make a version without box we can use this:
 *Shows a little bit easier of the frequency 
violinplot cty,  over(class) vertical scheme(white_w3d) nobox nomedian noline nowhiskers ///
      ytitle("City Mileage", size(2.25)) ///
      title("{bf}Box Plot (Density Only)", pos(11) size(2.75)) ///
      b1title(" " "Class of vehicle", size(2.5)) ///
      subtitle("City Mileage grouped by class of vehicle", pos(11) size(2))
	  
	  graph export "violin_plot.pdf", replace	
	  

*Density plot. Needs to all be run in a row. 
levelsof cyl, local(cylinders)
 foreach cylinder of local cylinders {
  
  quietly summarize cty
  *Local macro is a command. That is why it works below. Shows density for all levels of cylinder. 
  local kden "`kden' (kdensity cty if cyl == `cylinder', range(`r(min)' `r(max)') recast(area) fcolor(%70) lwidth(*0.25))"
    
 }
 
 twoway `kden',  scheme(white_w3d) ///
     legend(subtitle("Cylinders", size(2)) label(1 "4") label(2 "5") label(3 "6") label(4 "8")) ///
     title("{bf}Density Plot", pos(11) size(2.75)) ///
     subtitle("City Mileage over number of cylinders", pos(11) size(2)) 
	 
graph export "density_plot.pdf", replace


*Other figures. 
*Bubble scatterplot split by manufacturer, weighted by hwy mileage
import delimited "https://raw.githubusercontent.com/tidyverse/ggplot2/master/data-raw/mpg.csv", clear
  
keep if inlist(manufacturer, "audi", "ford", "honda", "hyundai")
  
recode hwy  (15 16 17 18 19 = 1) (20 21 22 23 24 = 4) (25 26 27 28 29 = 8) ///
     (30 31 32 33 34 = 16) (35 36 = 32), gen(weight)

levelsof manufacturer, local(options)
local wordcount : word count `options'
  
local i = 1
foreach option of local options {
   
   colorpalette tableau, n(`wordcount') nograph
   
   *Local macro of command for scatter plot. 
   local  scatter `scatter' scatter cty displ [fw = weight] if manufacturer == "`option'", ///
     mcolor("`r(p`i')'%60") mlwidth(0) jitter(10) ||
     
	 *local macro of command for line plot. For specific manufacturer. 
   local  line `line' lfit cty displ if manufacturer == "`option'", lcolor("`r(p`i')'") ||
   
   local ++i
  }
  
  twoway  `scatter' `line', ///
    title("{bf}Bubble Chart", pos(11) size(2.75)) ///
    subtitle("Displacement vs City mileage", pos(11) size(2.5)) ///
    ytitle("City Mileage", size(2)) ///
    legend(order(3 "Honda" 4 "Hyundai" 1 "Audi" 2 "Ford" ) size(2)) ///
    scheme(white_tableau)
	
	graph export "scatter_Bubble.pdf", replace
	
	

	*Correlation matrix
	 sysuse auto, clear 
  
* local macro of variables. 
  local var_corr price mpg trunk weight length turn foreign
  local countn : word count `var_corr'
  
  * Use correlation command
  quietly correlate `var_corr'
  *store results into matrix. 
  matrix C = r(C)
  local rnames : rownames C
  
  * Now to generate a dataset from the Correlation Matrix
  clear
   
   * For no diagonal and total count
   local tot_rows : display `countn' * `countn'
   set obs `tot_rows'
   
   *Create empty variables. 
   generate corrname1 = ""
   generate corrname2 = ""
   generate y = .
   generate x = .
   generate corr = .
   generate abs_corr = .
   
   local row = 1
   local y = 1
   local rowname = 2
    
	*Loop through variables. 
   foreach name of local var_corr {
    forvalues i = `rowname'/`countn' { 
     local a : word `i' of `var_corr'
     replace corrname1 = "`name'" in `row'
     replace corrname2 = "`a'" in `row'
     replace y = `y' in `row'
     replace x = `i' in `row'
     replace corr = round(C[`i',`y'], .01) in `row'
     replace abs_corr = abs(C[`i',`y']) in `row'
     
     local ++row
     
    }
    
    local rowname = `rowname' + 1
    local y = `y' + 1
   
   }
   
  drop if missing(corrname1)
  replace abs_corr = 0.1 if abs_corr < 0.1 & abs_corr > 0.04
  
  colorpalette HCL pinkgreen, n(10) nograph intensity(0.65)
  *colorpalette CET CBD1, n(10) nograph //Color Blind Friendly option
  generate colorname = ""
  local col = 1
  forvalues colrange = -1(0.2)0.8 {
   replace colorname = "`r(p`col')'" if corr >= `colrange' & corr < `=`colrange' + 0.2'
   replace colorname = "`r(p10)'" if corr == 1
   local ++col
  } 
  
  
  * Plotting
  * Saving the plotting code in a local 
  forvalues i = 1/`=_N' {
  
   local slist "`slist' (scatteri `=y[`i']' `=x[`i']' "`: display %3.2f corr[`i']'", mlabposition(0) msize(`=abs_corr[`i']*15') mcolor("`=colorname[`i']'"))"
  
  }
  
  
  * Gather Y axis labels
  labmask y, val(corrname1)
  labmask x, val(corrname2)
  
  levelsof y, local(yl)
  foreach l of local yl {
   local ylab "`ylab' `l'  `" "`:lab (y) `l''" "'" 
   
  } 

  * Gather X Axis labels
  levelsof x, local(xl)
  foreach l of local xl {
   local xlab "`xlab' `l'  `" "`:lab (x) `l''" "'" 
   
  }  
  
  * Plot all the above saved lolcas
  twoway `slist', title("Correlogram of Auto Dataset Cars", size(3) pos(11)) ///
    note("Dataset Used: Sysuse Auto", size(2) margin(t=5)) ///
    xlabel(`xlab', labsize(2.5)) ylabel(`ylab', labsize(2.5)) ///
    xscale(range(1.75 )) yscale(range(0.75 )) ///
    ytitle("") xtitle("") ///
    legend(off) ///
    aspect(1) ///
    scheme(white_tableau)
	graph export "correlation Diagram.pdf", replace