sysuse auto, clear
*to pull from data folder. Use the code below.
*use "../Data/Auto.dta", clear

*help putpdf
putpdf begin



// Create a paragraph
putpdf paragraph, halign(center)
putpdf text ("putpdf Report"), bold

putpdf paragraph
putpdf text ("Using this command I can add normal text, and formatted text to a paragraph.  Such as ")
putpdf text ("italicized text, "), italic
putpdf text ("underlined text and even "), underline
putpdf text (", sub/super script")
putpdf text ("2 "), script(sub)

*new paragraph. Generate some statistics and include in report. 
putpdf paragraph
qui sum mpg
local avg: display %4.2f `r(mean)'
local Count: display %4.2f `r(N)'
local sd: display %4.2f `r(sd)'
local sum : display %4.2f `r(sum)'
putpdf text ("I am turning my attention to a system Stata dataset called auto. Can be loaded into any version of Stata using the command sysuse auto. I will use this dataset to generate a basic report generating some summary statistics, creating a graph and displaying results from a regression equation. ")
putpdf text ("Using this command you can easily add Stata results to your pdf. Displaying the Average miles per gallon: ")
*Display the results in a nicer formatting method. 
putpdf text ("`avg'"), bold
putpdf text (" And the standard deviation of ")
putpdf text ("`sd' "), bold
putpdf text ("from a sample of ") 
putpdf text ("`Count'"), bold 
putpdf text (" cars in this dataset. ")
putpdf text ("In the next paragraph I will include a histogram of the miles per gallon(mpg) variable.")

// Embed a graph
histogram mpg
*Must save graph first before able to export. 
graph export hist_mpg.png, replace
putpdf paragraph, halign(center)
putpdf image hist_mpg.png

// Embed Stata output
putpdf paragraph
putpdf text ("Looking at the distribution of miles per gallon(mpg) in the graph above. It appears that the data is slightly skewed to the right. ")
putpdf text ("In my following paragraph I will embed regression output into my report. Predicting ")
putpdf text ("miles per gallon(mpg) from the weight and length of a car"), bold
*Insert regression equation into report. 
regress mpg weight length
putpdf table mytable = etable

putpdf paragraph
putpdf text ("Based on the above regression results. For every 1000 pound increase in a vehicle's weight, 3.8 miles per gallon decrease. Furthermore every 100 in. increase in car length results in about a 7.8 miles per gallon decrease. "), italic
putpdf text ("In short, the larger the car, the less miles per gallon based on this sample dataset. ")

// Embed Stata dataset
putpdf paragraph
putpdf text ("Using this final data themed paragraph to show some basic summary statistics. Looking at the miles per gallon(mpg) split by our grouping variable of domestic and foreign cars. Then performing a t-test to compare the miles per gallon(mpg) between foreign and domestic vehicles")
*Create a table split by a grouping variable. 
statsby Count=r(N) Average=r(mean) Max=r(max) Min=r(min), by(foreign): summarize mpg
rename foreign Type
putpdf table tbl1 = data("Type Count Average Max Min"), varnames  ///
        border(start, nil) border(insideV, nil) border(end, nil)

*Perform ttest, analyze the results. 
putpdf paragraph
sysuse auto, clear
ttest mpg, by(foreign)
local avg1: display %4.2f `r(mu_1)'
local avg2: display %4.2f `r(mu_2)'
local pval: display %4.2f `r(p_l)'
putpdf text ("After computing a ttest to compare mpg between foreign and domestic vehicles. Domestic vehicles have an average mpg of  ")
putpdf text ("`avg1'"), bold 
putpdf text (" Whereas the average mpg of foreign vehicles is ")
putpdf text ("`avg2'"), bold 
putpdf text (". Resulting in a p-value of close to")
putpdf text ("`pval'. "), bold
putpdf paragraph
putpdf text ("Based on the results, I reject the null hypothesis that mpg is equal for domestic and foreign vehicles. Based on this dataset, it appears foreign vehicles have a higher average miles per gallon than domestic vehicles."), bold

putpdf paragraph
putpdf text ("Thank you for reading my report. Try out the putpdf command to create a report with embedded results all in 1 application.")
		
putpdf save "../Output/Tables/Putpdf Basic Report.pdf", replace