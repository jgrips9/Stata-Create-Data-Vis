***CCSS Workshop 3/4
***Lead by Gabrielle Sorresso (gns36@cornell.edu)

*run code individually. 

*install texresults2 (only need to run once)
*ssc install texresults2

*set your working directory - which is where your text file will automatically export to 
*cd "path to folder"

*load in stata system data set 
sysuse auto, clear

********************************************************************************
*************************** OLS Introduction Example ***************************
********************************************************************************

*lets run an OLS regression of price on mpg and weight 
reg price mpg weight 

*Now lets use texresults2 to export our results

*we can export the coefficients for both our variables using the coef option 
*I have opted to call my text file CCSSresults.txt
 
*Note my naming convention here - I use the variable name, then the result type, then a letter (a, b, c, d to denote the model number). This is my first model therefore I use the letter a  
texresults2 using "OLS_Log.txt", texmacro(mpgcoefa) coef(mpg) replace 
*above I use replace instead of append because it is the first time I am referencing my text file in this stata do-file 
texresults2 using "OLS_Log.txt", texmacro(weightcoefa) coef(weight) append


*now lets also use the se option to export our standard errors 
texresults2 using "OLS_Log.txt", texmacro(mpgpvaluea) pvalue(mpg) append  
texresults2 using "OLS_Log.txt", texmacro(weightpvaluea) pvalue(weight) append

*finally lets use our result command to export a scalar saved by stata after our estimation command 
*I will export the number of observations 
*I can see what else is saved by typing help reg and scrolling to the bottom of the help file in stata 

texresults2 using "OLS_Log.txt", texmacro(obsa) result(e(N)) round(0) append
*here I cam also opting to round to zero decimal places 

 
*This is a helpful command to see your results 
cat "OLS_Log.txt"


********************************************************************************
************************** Logit Introduction Example **************************
********************************************************************************

*now lets run a logit model predicting the probability of a car being forgien given its mpg and weight 
logit foreign mpg weight  

*lets export the same results as above (coefficient, standard error, and observations)
texresults2 using "OLS_Log.txt", texmacro(mpgcoefb) coef(mpg) round(3) append 
texresults2 using "OLS_Log.txt", texmacro(weightcoefb) coef(weight) round(3) append

texresults2 using "OLS_Log.txt", texmacro(mpgpvalueb) pvaluez(mpg) round(3) append  
texresults2 using "OLS_Log.txt", texmacro(weightpvalueb) pvaluez(weight) round(3) append

texresults2 using "OLS_Log.txt", texmacro(obsb) result(e(N)) round(0) append

*view results 
cat "OLS_Log.txt"

***********************Lets now go to overleaf 


********************************************************************************
*************************Extra: Summary Stats Example **************************
********************************************************************************

*summarize price variable 
sum price 
*save the mean in a new text file
texresults2 using "summary_tex.txt", texmacro(pricemean) result(r(mean)) replace
*export the max and min 
texresults2 using "summary_tex.txt", texmacro(pricemin) result(r(min)) append
texresults2 using "summary_tex.txt", texmacro(pricemax) result(r(max)) append

*view results 
cat "summary_tex.txt"

*****Loop for summary stats 
*instead of running the above code each time for each variable you can create a loop 

*trick to (re)start a new text file before looping
texresults2 using "summary_tex.txt", texmacro(start) result(0) replace

foreach var in price foreign weight mpg {
	
	sum `var'
	texresults2 using "summary_tex.txt", texmacro(`var'mean) result(r(mean)) append
	texresults2 using "summary_tex.txt", texmacro(`var'min) result(r(min)) append
	texresults2 using "summary_tex.txt", texmacro(`var'max) result(r(max)) append
	
} 

*view results 
cat "summary_tex.txt"

********************************************************************************
************************Extra: Regression Loop Example *************************
********************************************************************************

*long OLS regression
reg price mpg weight headroom trunk length turn displacement


*****Loop for variables 

*trick to (re)start a new text file before looping
texresults2 using "LongOLS.txt", texmacro(start) result(0) replace

foreach var in mpg weight headroom trunk length turn displacement {
	
	texresults2 using "LongOLS.txt", texmacro(`var'coefc) coef(`var') append
	texresults2 using "LongOLS.txt", texmacro(`var'pvaluec) pvalue(`var') append
	texresults2 using "LongOLS.txt", texmacro(`var'tstatc) tstat(`var') append
	
} 

*view results 
cat "LongOLS.txt"


