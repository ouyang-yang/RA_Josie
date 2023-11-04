****************************************
*** Table 1 ***
/*
In this table, I manually delete the decimals of Observations and do some typesetting using overleaf.
In overleaf, I use the packages: amssymb, adjustbox, booktabs, and changepage.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1 //1107 observations

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

//standardize the 3 variables
local Standard "PreferDemo MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

eststo reg4b_1: reg PreferDemo MajMethod ,r
est restore reg4b_1
estadd ysumm

eststo reg4b_2: reghdfe PreferDemo MajMethod, absorb(gender CountryBirth) vce(r)
est restore reg4b_2
estadd ysumm
estadd local gender "$\checkmark$":reg4b_2
estadd local CountryBirth "$\checkmark$":reg4b_2

eststo reg4b_3: reghdfe PreferDemo MajMethod, absorb(gender CountryBirth MotherCountry FatherCountry) vce(r)
est restore reg4b_3
estadd ysumm
estadd local gender "$\checkmark$":reg4b_3
estadd local CountryBirth "$\checkmark$":reg4b_3
estadd local MotherCountry "$\checkmark$":reg4b_3
estadd local FatherCountry "$\checkmark$":reg4b_3

eststo reg4b_4: reghdfe PreferDemo MajMethod, absorb(gender CountryBirth MotherCountry FatherCountry ${ParentsEducation}) vce(r)
est restore reg4b_4
estadd ysumm
estadd local gender "$\checkmark$":reg4b_4
estadd local CountryBirth "$\checkmark$":reg4b_4
estadd local MotherCountry "$\checkmark$":reg4b_4
estadd local FatherCountry "$\checkmark$":reg4b_4
estadd local ParentsEducation "$\checkmark$":reg4b_4


eststo reg4b_5: reghdfe PreferDemo MajMethod, absorb(gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore reg4b_5
estadd ysumm		
estadd local gender "$\checkmark$":reg4b_5
estadd local CountryBirth "$\checkmark$":reg4b_5
estadd local MotherCountry "$\checkmark$":reg4b_5
estadd local FatherCountry "$\checkmark$":reg4b_5
estadd local ParentsEducation "$\checkmark$":reg4b_5
estadd local ParentsUrban "$\checkmark$":reg4b_5

label var MajMethod "Majority Method"
estfe reg4b_1 reg4b_2 reg4b_3 reg4b_4 reg4b_5
esttab reg4b_1 reg4b_2 reg4b_3 reg4b_4 reg4b_5 using Table1.tex, ///
	   replace label /// 
	   keep(MajMethod) nomtitle compress collabels(none) ///
	   nostar nonotes b(3) se(3) ///
	   stats(N r2 gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban, labels("Observations" "R-squared" "Gender"  "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment" "Parents' Urban Controls") ) ///
	   mgroups("Preference for Democracy", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   postfoot( /// // "postfoot" is the command to add footnotes.
       \hline\hline ///
       \end{tabular} ///
	   \begin{adjustwidth}{-1cm}{-1cm} /// 
	   \begin{scriptsize} ///
       Each column reports standardized coefficient(s) from a single OLS regression of the dependent variable described in the column heading on the variable(s) described in the row heading(s). An observation is an émigré from Greater China living in North America who was recruited via Facebook targeted ads to complete an online survey (see Section I.B and online Appendix B.1 for further details about the data collection). Preference for Democracy corresponds to the strength with which participants report preferring democracy as a system of government over a system in which the authority is unconstrained, on a 1 to 5 scale. Majority Method is the preference over a method to assign a decision for a group in the incentivized task, with one corresponding to a strong preference for a decision by an authority designated by the experimenter, and 5 corresponding to a strong preference for majority rule. Gender is an indicator that equals one if the respondent reports identifying as a female, 0 otherwise. Country of Birth FE, Mother Country FE, and Father Country FE correspond to fixed effects for the respondent's, her mother's, and her fathers countries of birth, respectively. Parents' Educational Attainment corresponds to indicators for whether each parent completed high school or more. Parents' Urban Controls corresponds to indicators for whether each parent came from an urban background. Robust standard errors are in parenthesis. ///
       \end{scriptsize} \end{adjustwidth})


*** Table 2 ***
/*
In this table, I manually delete the decimals of Observations and do some typesetting using overleaf.
In overleaf, I use the packages: amssymb, adjustbox, booktabs, and changepage.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1 //1107 observations

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

//standardize the 3 variables
local Standard "SkilledAuthority PreferDemo MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var') if Q30 != "不知道"
	replace `var'=std_`var' 
	drop std_`var'
}

**Panel A**

eststo regA_1: reg MajMethod SkilledAuthority, r
est restore regA_1
estadd ysumm

eststo regA_2: reghdfe MajMethod SkilledAuthority, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regA_2
estadd ysumm		
estadd local Gender "$\checkmark$":regA_2
estadd local CountryBirth "$\checkmark$":regA_2
estadd local MotherCountry "$\checkmark$":regA_2
estadd local FatherCountry "$\checkmark$":regA_2
estadd local ParentsEducation "$\checkmark$":regA_2
estadd local ParentsUrban "$\checkmark$":regA_2

eststo regA_3: reg PreferDemo SkilledAuthority ,r
est restore regA_3
estadd ysumm

eststo regA_4: reghdfe PreferDemo SkilledAuthority, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regA_4
estadd ysumm		
estadd local Gender "$\checkmark$":regA_4
estadd local CountryBirth "$\checkmark$":regA_4
estadd local MotherCountry "$\checkmark$":regA_4
estadd local FatherCountry "$\checkmark$":regA_4
estadd local ParentsEducation "$\checkmark$":regA_4
estadd local ParentsUrban "$\checkmark$":regA_4

eststo regA_5: reg SkilledAuthority SkilledAuthority ,r
est restore regA_5
estadd ysumm

eststo regA_6: reghdfe SkilledAuthority SkilledAuthority, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regA_6
estadd ysumm		
estadd local Gender "$\checkmark$":regA_6
estadd local CountryBirth "$\checkmark$":regA_6
estadd local MotherCountry "$\checkmark$":regA_6
estadd local FatherCountry "$\checkmark$":regA_6
estadd local ParentsEducation "$\checkmark$":regA_6
estadd local ParentsUrban "$\checkmark$":regA_6

esttab regA_1 regA_2 regA_3 regA_4 regA_5 regA_6 using Table2.tex, ///
prehead("\begin{table} \begin{adjustbox}{width=\columnwidth,center}{\begin{tabular}{l*{6}{c}} \hline \hline") /// 
posthead("\hline \\ \textbf{\underline {Panel A}}&&&&&&&") ///
fragment  ///
mgroups("Majority Method" "Preference for Democracy" "Skilled Authority", pattern(1 0 1 0 1 0) ) ///
stats(r2, labels("R-squared")) ///
nostar nonotes b(3) se(3) replace label nomtitle  ///
keep(SkilledAuthority) nomtitle compress collabels(none)
eststo clear

** Panel B **
eststo regB_1: reg MajMethod authTr ,r
est restore regB_1
estadd ysumm

eststo regB_2: reghdfe MajMethod authTr, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regB_2
estadd ysumm		
estadd local Gender "$\checkmark$":regB_2
estadd local CountryBirth "$\checkmark$":regB_2
estadd local MotherCountry "$\checkmark$":regB_2
estadd local FatherCountry "$\checkmark$":regB_2
estadd local ParentsEducation "$\checkmark$":regB_2
estadd local ParentsUrban "$\checkmark$":regB_2

eststo regB_3: reg PreferDemo authTr ,r
est restore regB_3
estadd ysumm

eststo regB_4: reghdfe PreferDemo authTr, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regB_4
estadd ysumm		
estadd local Gender "$\checkmark$":regB_4
estadd local CountryBirth "$\checkmark$":regB_4
estadd local MotherCountry "$\checkmark$":regB_4
estadd local FatherCountry "$\checkmark$":regB_4
estadd local ParentsEducation "$\checkmark$":regB_4
estadd local ParentsUrban "$\checkmark$":regB_4

eststo regB_5: reg SkilledAuthority authTr ,r
est restore regB_5
estadd ysumm

eststo regB_6: reghdfe SkilledAuthority authTr, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regB_6
estadd ysumm		
estadd local Gender "$\checkmark$":regB_6
estadd local CountryBirth "$\checkmark$":regB_6
estadd local MotherCountry "$\checkmark$":regB_6
estadd local FatherCountry "$\checkmark$":regB_6
estadd local ParentsEducation "$\checkmark$":regB_6
estadd local ParentsUrban "$\checkmark$":regB_6

esttab regB_1 regB_2 regB_3 regB_4 regB_5 regB_6 using Table2.tex, ///
posthead("\hline \\ \textbf{\underline {Panel B}}&&&&&&&") ///
fragment ///
stats(r2, labels("R-squared")) ///
nostar nonotes b(3) se(3) append label nomtitle nonumbers ///
keep(authTr) nomtitle compress collabels(none)

eststo clear


*Panel C
reg SkilledAuthority authTr, r
predict SkilledAuthResid, resid
label var SkilledAuthResid "Skilled Authority Residual"

eststo regC_1: reg MajMethod SkilledAuthResid ,r
est restore regC_1
estadd ysumm

eststo regC_2: reghdfe MajMethod SkilledAuthResid, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regC_2
estadd ysumm		
estadd local Gender "$\checkmark$":regC_2
estadd local CountryBirth "$\checkmark$":regC_2
estadd local MotherCountry "$\checkmark$":regC_2
estadd local FatherCountry "$\checkmark$":regC_2
estadd local ParentsEducation "$\checkmark$":regC_2
estadd local ParentsUrban "$\checkmark$":regC_2

eststo regC_3: reg PreferDemo SkilledAuthResid ,r
est restore regC_3
estadd ysumm

eststo regC_4: reghdfe PreferDemo SkilledAuthResid, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regC_4
estadd ysumm		
estadd local Gender "$\checkmark$":regC_4
estadd local CountryBirth "$\checkmark$":regC_4
estadd local MotherCountry "$\checkmark$":regC_4
estadd local FatherCountry "$\checkmark$":regC_4
estadd local ParentsEducation "$\checkmark$":regC_4
estadd local ParentsUrban "$\checkmark$":regC_4

eststo regC_5: reg SkilledAuthority SkilledAuthority ,r
est restore regC_5
estadd ysumm

eststo regC_6: reghdfe SkilledAuthority SkilledAuthority, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore regC_6
estadd ysumm		
estadd local Gender "$\checkmark$":regC_6
estadd local CountryBirth "$\checkmark$":regC_6
estadd local MotherCountry "$\checkmark$":regC_6
estadd local FatherCountry "$\checkmark$":regC_6
estadd local ParentsEducation "$\checkmark$":regC_6
estadd local ParentsUrban "$\checkmark$":regC_6


esttab regC_1 regC_2 regC_3 regC_4 regC_5 regC_6 using Table2.tex, ///
posthead("\hline \\ \textbf{\underline {Panel C}}&&&&&&&") ///
fragment ///
stats(r2 N Gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban, labels("R-squared" "Observations" "Gender" "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment" "Parents' Urban Controls") ) ///
nostar nonotes b(3) se(3) append label nomtitle nonumbers ///
keep(SkilledAuthResid) nomtitle compress collabels(none) ///
prefoot("\hline") ///
postfoot( ///
       \hline\hline ///
       \end{tabular}} ///
	   \end{adjustbox} ///
	   \begin{adjustwidth}{-1cm}{-1cm}  ///
	   \begin{scriptsize} ///
      Each panel-column reports results from a single OLS regression of the dependent variable described in the column heading on the variable(s) described in the row heading(s). An observation is an émigré from Greater China living in North America (see Section I.B and online Appendix B.1 for further details about the data collection). Preference for Democracy corresponds to the strength with which participants report preferring democracy as a system of government over a system in which the authority is unconstrained, on a 1-5 scale. Majority Method is the preference over a method to assign a decision for a group in the incentivized task, with one corresponding to a strong preference for a decision by an authority designated by the experimenter, and 5 corresponding to a strong preference for majority rule. Authority Treatment is an indicator that equals 1 if, before the decision task, the respondent was shown a prompt suggesting that a skilled participant could be selected as an authority in the decision task. Skilled Authority is a participant's reported belief in the likelihood that the authority in the task would be skilled, on a 0-5 scale. Skilled Authority Residual is the residual of regression in Panel B, Column 5. Gender is an indicator that equals one if the respondent reports identifying as a female, 0 otherwise. Country of Birth FE, Mother's Country FE, and Father's Country FE correspond to fixed effects for the respondent's, her mother's, and her father’s countries of birth, respectively. Parents' Educational Attainment corresponds to indicators for whether each parent completed secondary education or more. Parents' Urban Controls corresponds to indicators for whether each parent came from an urban background. Robust standard errors are in parenthesis. /// 
	  \end{scriptsize} \end{adjustwidth} \end{table}) 
*____________________________________________________________________*

*** Figure 1 ***
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromFB == 1 //1107 observations

local Standard "MajMethod PreferDemo DLeader ideology age married gender highEdu FEdu MEdu highSES lowSES"
foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

local independent "DLeader ideology age married gender highEdu FEdu MEdu highSES lowSES"

foreach var of local independent{
	reg PreferDemo `var',r
	estimates store D_`var'
}

foreach var of local independent{
	reg MajMethod `var',r
	estimates store MM_`var'
}

label var DLeader "Prefers Democratizing Leader"

set scheme plotplainblind
coefplot (D_DLeader D_ideology D_age D_married D_gender D_highEdu D_FEdu D_MEdu D_highSES D_lowSES, label(Preference for Democracy) pstyle(p3) )  ///
 (MM_DLeader MM_ideology MM_age MM_married MM_gender MM_highEdu MM_FEdu MM_MEdu MM_highSES MM_lowSES, label(Preference for Majority Method)  pstyle(p4)) ///
 , drop(_cons) xline(0) msymbol(S)  ///
 ylabel(,labsize(vsmall)) legend(size(vsmall)) aspectratio(1.5 ,placement(east))
*____________________________________________________________________*

*** Figure 2 ***
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromFB == 1 | fromWenjuanxing | fromProlific == 1  //1107 + 489 + 491 observations

gen Category=1 if fromProlific==1
replace Category=2 if fromFB==1 & mPolitical==1 & China==1
replace Category=3 if fromFB==1 & (Taiwan==1 | HongMacao==1)
replace Category=4 if fromWenjuanxing==1
replace Category=5 if fromFB==1 & mPolitical==0 & China==1

//label
label define Category_label 1 "US Representative" 2 "Emigres from Mainland China - Political" 3 "Emigres from HK/Taiwan" 4 "Mainland China" 5 "Emigres from Mainland China - Non Political"
label value Category Category_label

set scheme plotplainblind
catplot MajMethod, over(Category, label(labsize(2)) relabel(2 "Emigres from Mainland China - Political" 5 "Emigres from Mainland China - Non Political")) stack asyvars percent(Category) blabel(bar, size(1) position(center) format(%4.1f)) legend(label(1 "Strongly prefer choice by authority") label(2 "Prefer choice by authority") label(3 "No preference") label(4 "Prefer choice by majority") label(5 "Strongly prefer choice by majority") rows(5) size(vsmall)) ytitle("Percentage", size(small)) l1title("") 
*____________________________________________________________________*

*** Table 3:re***
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromWenjuanxing == 1 //489 observations

//standardize the variables
local Standard "MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var' 
}

label var age "Age"
label var gender "Gender"
label var married "Married"
label var highSES " High SES"
label var highEdu "High Educational Attainment"
label var currentUni "Current University Student"

*Panel A
eststo regA_1: reg MajMethod age, r
est restore regA_1

eststo regA_2:reg MajMethod gender, r
est restore regA_2

eststo regA_3:reg MajMethod married, r
est restore regA_3

eststo regA_4:reg MajMethod highSES, r
est restore regA_4

eststo regA_5:reg MajMethod highEdu, r
est restore regA_5

eststo regA_6:reg MajMethod currentUni, r
est restore regA_6

esttab regA_1 regA_2 regA_3 regA_4 regA_5 regA_6 using Table3RE.tex, ///
prehead("\begin{table} \scalebox{0.85}{ \begin{tabular}{l*{6}{c}} \hline \hline") ///
posthead("\hline \\ \textbf{\underline {Panel A: Individual Characteristics}}&&&&&&& \\ & \multicolumn{6}{c}{Dependent Variable: Majority Method} \\ \cmidrule(lr){2-7} \\") ///
fragment ///
stats(r2, labels("R-squared")) ///
nostar nonotes b(3) se(3) replace label nomtitle   ///
nomtitle compress collabels(none) nodepvars noconstant ///

eststo clear

** Panel B **
label var UrbanBackground "Urban Background"
label var MigrChina "Migrated from Rural to Urban within China During Childhood"

eststo regB_1: reg MajMethod UrbanBackground, cluster(mo_province)
est restore regB_1
eststo regB_2: reg MajMethod MigrChina, cluster(mo_province)
est restore regB_2
eststo regB_3: reg MajMethod GDP_growth_92_19_mo, cluster(mo_province)
est restore regB_3
eststo regB_4: reg MajMethod M_GDP_92_19_mo, cluster(mo_province)
est restore regB_4
eststo regB_5: reg MajMethod X_GDP_92_19_mo, cluster(mo_province)
est restore regB_5
eststo regB_6: reg MajMethod FDI_GDP_92_19, cluster(mo_province)
est restore regB_6

esttab regB_1 regB_2 regB_3 regB_4 regB_5 regB_6 using Table3RE.tex, ///
posthead("\hline \\ \textbf{\underline {Panel B: Economic Experiences}}&&&&&&& \\ & \multicolumn{6}{c}{Dependent Variable: Majority Method} \\ \cmidrule(lr){2-7} \\") ///
fragment ///
stats(N r2, labels("Observations" "R-squared") ) ///
notes b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) append label nomtitle ///
compress collabels(none) nodepvars ///
prefoot("\hline") ///
postfoot( ///
       \hline\hline ///
       \end{tabular}} ///
	   \begin{adjustwidth}{-1cm}{-1cm}  ///
	   \begin{scriptsize} ///
      Each panel-column reports results from a single OLS regression of Majority Method on the variable described in the row heading. Individual-level data comes from information shared by survey respondents in mainland China who were recruited with the assistance of the online platform Wenjuanxing (see Section I.B and online Appendix B.1 for further details about the data collection), whereas province-level data comes from China's National Bureau of Statistics and the UNDP National Human Development Report. Majority Method is the preference over a method to assign a decision for a group in the incentivized task, with 1 corresponding to a strong preference for a decision by an authority designated by the experimenter, and 5 corresponding to a strong preference for majority rule. Province-level information is linked to a respondent based on her reported province of origin. Online Appendix A.1 provides further details about the definition and the scale of each variable in the row heading. Panel A presents robust standard errors in parentheses, while Panel B presents robust standard errors clustered at the province of origin of the respondent. /// 
	  \end{scriptsize} \end{adjustwidth} \end{table})
*____________________________________________________________________*

*** A2 Summary Statistics *** 
/*
Initially, Appendix A.2 is divided into three tex file: A2_A.tex, A2_B.tex, A2_C.tex 
And then I combine them using overleaf.
In overleaf, I use the packages: amssymb, adjustbox, and multirow.

*/
** Panel A: Emigres Greater China living in North America**
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromFB==1

global Table_A "age authTr China BA highEdu currentUni DLeader FEdu FUrban Gender highSES HongMacao lowSES married MajMethod mPolitical MEdu MUrban children negativeCCP neutralN positiveCCP PreferDemo SecondGen ideology SkilledAuthority Taiwan"

mat summary=J(27,5,.)

	tokenize ${Table_A}
	forvalues j=1(1)27{

		sum ``j''
		matrix summary [`j',1]= r(N)
		matrix summary [`j',2]= r(mean)
		matrix summary [`j',3]= r(sd) 
		matrix summary [`j',4]= r(min) 
		matrix summary [`j',5]= r(max)  
	}

matlist summary

frmttable using "A2_A.tex", tex fragment replace /// 
		statmat(summary) /// 
		ctitles("", "Obs", "Mean", "Std", "Min", "Max")	///
		rtitles("Age"\ "Authority Treatment"\ "China"\ "Completed BA or More"\ "Completed High School or More"\ "Currently University Student"\ "Democratizing Leader"\ "Father’s Educational Attainment"\ "Father's Urban Origin"\ "Gender"\ "High SES"\ "Hong Kong"\ "Low SES"\ "Married"\ "Majority Method"\ "Migration: Political Freedom"\ "Mother’s Educational Attainment"\ "Mother's Urban Origin"\ "Number of Children"\ "Negative CCP Narrative"\ "Neutral Narrative"\ "Positive CCP Narrative"\ "Preference for Democracy"\ "Second Generation (born in N. Am.)"\ "Self-reported Ideology"\ "Skilled Authority"\ "Taiwan" )  ///
		sdec(0, 2, 2, 2, 2)
		
** Panel B: Participants in US Representative Survey **		
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromProlific==1

global Table_B "age authTr BA highEdu currentUni EleCoUndemo FEdu gender highSES lowSES married MajMethod MEdu children PreferDemo ideology"

mat summary2=J(16,5,.)

	tokenize ${Table_B}
	forvalues j=1(1)16{

		sum ``j'' 
		matrix summary2 [`j',1]= r(N)
		matrix summary2 [`j',2]= r(mean)
		matrix summary2 [`j',3]= r(sd)
		matrix summary2 [`j',4]= r(min)
		matrix summary2 [`j',5]= r(max) 
	}
	
matlist summary2

frmttable using "A2_B.tex", tex fragment replace			/// 
		statmat(summary2) ///										///
		ctitles("", "Obs", "Mean", "Std", "Min", "Max")															///
		rtitles("Age"\ "Authority Treatment"\ "Completed BA or More"\ "Completed High School or More"\ "Currently University Student"\ "Electoral College Undemocratic"\ "Father’s Educational Attainment"\ "Gender"\ "High SES"\ "Low SES"\ "Married"\ "Majority Method"\ "Mother’s Educational Attainment"\ "Number of Children"\ "Preference for Democracy"\ "Self-reported Ideology") ///
		sdec(0, 2, 2, 2, 2)
	
** Panel C: Participants in Mainland China **		
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromWenjuanxing==1

global Table_C "age authTr BA highEdu currentUni gender highSES lowSES married MajMethod MigrChina children UrbanBackground"

mat summary3=J(13,5,.)

	tokenize ${Table_C}
	forvalues j=1(1)13{

		sum ``j'' 
		matrix summary3 [`j',1]= r(N)
		matrix summary3 [`j',2]= r(mean)
		matrix summary3 [`j',3]= r(sd)
		matrix summary3 [`j',4]= r(min)
		matrix summary3 [`j',5]= r(max) 
	}
	
matlist summary3

frmttable using "A2_C.tex", tex fragment replace /// 
		statmat(summary3) ///
		ctitles("", "Obs", "Mean", "Std", "Min", "Max")	///
		rtitles("Age"\ "Authority Treatment"\ "Completed BA or More"\ "Completed High School or More"\ "Currently University Student"\ "Gender"\ "High SES"\ "Low SES"\ "Married"\ "Majority Method"\ "Migrated Within China During Childhood"\ "Number of Children"\ "Urban Background") ///
		sdec(0, 2, 2, 2, 2)
*____________________________________________________________________*

*** A4 ***
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1

tw (kdensity PreferDemo, color(dkgreen) bwidth(1))	///
   (kdensity MajMethod, color(dkorange) lp("--") bwidth(1)),	///
 graphregion(fcolor(white)) plotregion(lcolor(black)) ///
   ylabel(,nogrid) ///
   xti("Preference in response") yti("Percentage",height(10) width(3)) ///
   legend(position(6) order(1 "Preference for Democracy" 2 "Preference for Majority Method") size(vsmall) symysize(4) symxsize(4) lstyle(solid) lcolor(black))
*____________________________________________________________________*

*** A5.1 ***
/*
In overleaf, I use the packages: amssymb and adjustbox.
In addition, I manually delete the decimals of observations.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromProlific==1

local Standard "MajMethod PreferDemo"
foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

label var MajMethod "Majority Method"

eststo reg4c_1: reg PreferDemo MajMethod, r 
est restore reg4c_1
estadd ysumm		

eststo reg4c_2: reg PreferDemo MajMethod gender, r
est restore reg4c_2
estadd ysumm	
estadd local gender "$\checkmark$":reg4c_2

eststo reg4c_3: reghdfe PreferDemo MajMethod,absorb(gender RBirth) vce(r)
est restore reg4c_3
estadd ysumm
estadd local gender "$\checkmark$":reg4c_3		
estadd local RBirth "$\checkmark$":reg4c_3

eststo reg4c_4: reghdfe PreferDemo MajMethod ,absorb(gender RBirth FCont) vce(r)
est restore reg4c_4
estadd ysumm
estadd local gender "$\checkmark$":reg4c_4		
estadd local RBirth "$\checkmark$":reg4c_4
estadd local FCont "$\checkmark$":reg4c_4

estfe reg4c_1 reg4c_2 reg4c_3 reg4c_4
esttab reg4c_1 reg4c_2 reg4c_3 reg4c_4 using "A5_1.tex", ///
	   replace label ///
	   keep(MajMethod) nomtitle compress collabels(none) nostar ///
	   stats(N r2 gender RBirth FCont, labels("Observations" "R-squared" "Gender" "Region of Birth FE" "Father's Continent of Birth FE") ) ///		
	   b(3) se(3) ///
	   mgroups("Preference for Democracy", pattern(1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   postfoot( ///
       \hline\hline ///
       \end{tabular} ///
	   \begin{adjustwidth}{-1cm}{-1cm}  ///
	   \begin{scriptsize} ///
       The table shows that behavior in the decision task robustly predicts preference for democracy for a representative sample of the US. Each column reports standardized coefficient from a single OLS regression of the dependent variable described in the column heading on the variable(s) described in the row heading(s). An observation is a respondent in the US who was recruited via Prolific to ensure a representative sample from the country (see Section I.B and online Appendix B.1 for further details about the data collection). Preference for Democracy corresponds to the strength with which participants report preferring democracy as a system of government over a system in which the authority is unconstrained, on a 1 to 5 scale. Majority Method is the preference over a method to assign a decision for a group in the incentivized task, with one corresponding to a strong preference for a decision by an authority designated by the experimenter, and 5 corresponding to a strong preference for majority rule. Gender is an indicator that equals one if the respondent reports identifying as a female, 0 otherwise. Region of Birth FE corresponds to fixed effects for whether the respondent was born in the Northeast, Atlantic Region, South, Mid-West, or West in the US. Father's Continent of Birth FE corresponds to fixed effects for whether the father was born in the US, in the Americas outside the US, Africa and the Middle East, Europe, or Asia. Robust standard errors are in parenthesis. ///
       \end{scriptsize} \end{adjustwidth})	
	   
*** A5.2 ***
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromProlific==1

local Standard "MajMethod PreferDemo ideology EleCoUndemo FreeSpeech age married gender highEdu FEdu MEdu highSES lowSES"
foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

local independent "ideology EleCoUndemo FreeSpeech age  married gender highEdu FEdu MEdu highSES lowSES"

foreach var of local independent{
	reg PreferDemo `var',r
	estimates store D_`var'
}

foreach var of local independent{
	reg MajMethod `var',r
	estimates store MM_`var'
}

set scheme plotplainblind
coefplot (D_ideology D_EleCoUndemo D_FreeSpeech D_age D_married D_gender D_highEdu D_FEdu D_MEdu D_highSES D_lowSES, label(Preference for Democracy) pstyle(p3) )  ///
 (MM_ideology MM_EleCoUndemo MM_FreeSpeech MM_age MM_married MM_gender MM_highEdu MM_FEdu MM_MEdu MM_highSES MM_lowSES, label(Preference for Majority Method)  pstyle(p4)) ///
 , drop(_cons) xline(0) msymbol(S)  ///
 ylabel(,labsize(vsmall)) legend(size(vsmall)) aspectratio(1.7 ,placement(east))
*____________________________________________________________________*
	   
*** A6 ***
/*
In overleaf, I use the packages: amssymb, booktabs, changepage and adjustbox.
In addition, I manually delete the decimals of observations and add a \hline.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

local Standard "MajMethod SkilledAuthorityAlt1 SkilledAuthorityAlt2"
foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

eststo reg4a_1: reg MajMethod SkilledAuthorityAlt1, vce(robust) 
est restore reg4a_1
estadd ysumm

eststo reg4a_2: reghdfe MajMethod SkilledAuthorityAlt1, absorb(Gender ${ParentsUrban} CountryBirth MotherCountry FatherCountry ${ParentsEducation}) vce(r) //(dropped 1 singleton observations)
est restore reg4a_2
estadd ysumm
estadd local Gender "$\checkmark$": reg4a_2
estadd local CountryBirth "$\checkmark$": reg4a_2
estadd local MotherCountry "$\checkmark$": reg4a_2
estadd local FatherCountry "$\checkmark$": reg4a_2
estadd local ParentsEducation "$\checkmark$": reg4a_2
estadd local ParentsUrban "$\checkmark$": reg4a_2

eststo reg4a_3: reg MajMethod SkilledAuthorityAlt2, vce(robust) 
est restore reg4a_3
estadd ysumm

eststo reg4a_4: reghdfe MajMethod SkilledAuthorityAlt2, absorb(Gender ${ParentsUrban} CountryBirth MotherCountry FatherCountry ${ParentsEducation}) vce(r)
est restore reg4a_4
estadd ysumm
estadd local Gender "$\checkmark$": reg4a_4
estadd local ParentsUrban "$\checkmark$": reg4a_4
estadd local CountryBirth "$\checkmark$": reg4a_4
estadd local MotherCountry "$\checkmark$": reg4a_4
estadd local FatherCountry "$\checkmark$": reg4a_4
estadd local ParentsEducation "$\checkmark$": reg4a_4

estfe reg4a_*
esttab reg4a_* using "A6.tex", ///
	   replace label ///
	   keep(SkilledAuthorityAlt1 SkilledAuthorityAlt2) nomtitle compress collabels(none) nostar ///
	   stats(N r2 Gender ParentsUrban CountryBirth MotherCountry FatherCountry ParentsEducation, labels("Observations" "R-squared" "Gender" "Parents' Urban Controls" "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment")) ///		
	   b(3) se(3) ///
	   mgroups("Majority Method", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   postfoot( ///
       \hline\hline ///
       \end{tabular} ///
	   \begin{adjustwidth}{-1cm}{-1cm}  ///
	   \begin{scriptsize} ///
       The table shows that the association between behavior in the decision task and beliefs about the competence of the authority is robust to different definitions of the latter.Each column reports standardized coefficient from a single OLS regression of the dependent variable described in the column heading on the variable(s) described in the row heading(s). An observation is an émigré from Greater China living in North America who was recruited via Facebook targeted ads to complete an online survey (see Section I.B and online Appendix B.1 for further details about the data collection). Majority Method is the preference over a method to assign a decision for a group in the incentivized task, with one corresponding to a strong preference for a decision by an authority designated by the experimenter, and 5 corresponding to a strong preference for majority rule.  Skilled Authority -Alternative 1 and Skilled Authority - Alternative 2 are based on a participant's reported belief in the likelihood that the authority in the task would be skilled, on a 0-5 scale; Alternative 1 defines 0 as a missing, whereas Alternative 2 inputs a value of 3 to respondents who selected a 0. Gender is an indicator that equals one if the respondent reports identifying as a female, 0 otherwise. Country of Birth FE, Mother Country FE, and Father Country FE correspond to fixed effects for the respondent's, her mother's, and her fathers countries of birth, respectively. Parents' Educational Attainment corresponds to indicators for whether each parent completed high school or more. Parents' Urban Controls corresponds to indicators for whether each parent came from an urban background. Robust standard errors are in parenthesis. ///
       \end{scriptsize} \end{adjustwidth})
*____________________________________________________________________*
	   
*** A7 ***
/*
In overleaf, I use the packages: amssymb, booktabs, changepage and adjustbox.
In addition, I manually delete the decimals of observations and add a \hline.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

label var negativeCCP "Negative CCP Narrative"
label var positiveCCP "Positive CCP Narrative"
label var neutralN "Neutral Narrative"

local Standard "MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

eststo reg5a_1: reg MajMethod negativeCCP positiveCCP, vce(robust)
est restore reg5a_1
estadd ysumm

eststo reg5a_2: reg MajMethod negativeCCP positiveCCP neutralN , vce(robust)
est restore reg5a_2
estadd ysumm

eststo reg5a_3: reghdfe MajMethod negativeCCP positiveCCP, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)  
est restore reg5a_3
estadd ysumm
estadd local Gender "$\checkmark$": reg5a_3
estadd local CountryBirth "$\checkmark$": reg5a_3
estadd local MotherCountry "$\checkmark$": reg5a_3
estadd local FatherCountry "$\checkmark$": reg5a_3
estadd local ParentsEducation "$\checkmark$": reg5a_3
estadd local ParentsUrban "$\checkmark$": reg5a_3

eststo reg5a_4: reghdfe MajMethod negativeCCP positiveCCP neutralN, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r) 
est restore reg5a_4
estadd ysumm
estadd local Gender "$\checkmark$": reg5a_4
estadd local CountryBirth "$\checkmark$": reg5a_4
estadd local MotherCountry "$\checkmark$": reg5a_4
estadd local FatherCountry "$\checkmark$": reg5a_4
estadd local ParentsEducation "$\checkmark$": reg5a_4
estadd local ParentsUrban "$\checkmark$": reg5a_4

estfe reg5a_*
esttab reg5a_* using "A7.tex", ///
	   replace label ///
	   keep(negativeCCP positiveCCP neutralN) nomtitle compress collabels(none) ///
	   stats(N r2 Gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban, labels("Observations" "R-squared" "Gender" "Parents' Urban Controls" "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment") ) ///		
	   b(3) se(3) ///
	   mgroups("Preference for Majority Method", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   postfoot( ///
       \hline\hline ///
       \end{tabular} ///
	   \begin{adjustwidth}{-1cm}{-1cm}   ///
	   \begin{scriptsize} ///
       The table shows that exposing participants to different narratives about the policies of the Chinese Communist Party has an insignificant and economically small effect on behavior in the task.  Each column reports the coefficients from a single OLS regression of the dependent variable described in the column heading on the variable described in the row heading. An observation is an émigré from Greater China living in North America who was recruited via Facebook targeted ads to complete an online survey (see Section I.B and online Appendix B.1 for further details about the data collection). Majority Method is the preference over a method to assign a decision for a group in the incentivized task, with one corresponding to a strong preference for a decision by an authority designated by the experimenter, and 5 corresponding to a strong preference for majority rule.  Positive CCP Narrative, Negative CCP Narrative, and Neutral Narrative are indicators that equal 1 if, before participating in the decision task, the respondent was shown a message containing a narrative that casts a positive, negative, or neutral light on the CCP (see Appendix A.1 for more information about these indicators). Gender is an indicator that equals one if the respondent reports identifying as a female, 0 otherwise. Country of Birth FE, Mother Country FE, and Father Country FE correspond to fixed effects for the respondent's, her mother's, and her fathers countries of birth, respectively. Parents' Educational Attainment corresponds to indicators for whether each parent completed high school or more. Parents' Urban Controls corresponds to indicators for whether each parent came from an urban background. Robust standard errors are in parenthesis. ///
       \end{scriptsize} \end{adjustwidth})
*____________________________________________________________________*

*** A8 ***
/*
In overleaf, I use the packages: amssymb, booktabs, changepage and adjustbox.
In addition, I manually delete the decimals of observations and add a \hline.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

local Standard "MajMethod MajMethodAlt1 MajMethodAlt2 PreferDemo"

foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

eststo reg4a_1: reg PreferDemo MajMethodAlt1, vce(robust) 
est restore reg4a_1
estadd ysumm

eststo reg4a_2: reghdfe PreferDemo MajMethodAlt1, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)  //(dropped 2 singleton observations)
est restore reg4a_2
estadd ysumm
estadd local Gender "$\checkmark$":reg4a_2
estadd local CountryBirth "$\checkmark$":reg4a_2
estadd local MotherCountry "$\checkmark$":reg4a_2
estadd local FatherCountry "$\checkmark$":reg4a_2
estadd local ParentsEducation "$\checkmark$":reg4a_2
estadd local ParentsUrban "$\checkmark$":reg4a_2

eststo reg4a_3: reg PreferDemo MajMethodAlt2, vce(robust) 
est restore reg4a_3
estadd ysumm


eststo reg4a_4: reghdfe PreferDemo MajMethodAlt2, absorb(Gender CountryBirth MotherCountry FatherCountry ${ParentsEducation} ${ParentsUrban}) vce(r)
est restore reg4a_4
estadd ysumm
estadd local Gender "$\checkmark$":reg4a_4
estadd local CountryBirth "$\checkmark$":reg4a_4
estadd local MotherCountry "$\checkmark$":reg4a_4
estadd local FatherCountry "$\checkmark$":reg4a_4
estadd local ParentsEducation "$\checkmark$":reg4a_4
estadd local ParentsUrban "$\checkmark$":reg4a_4

estfe reg4a_*
esttab reg4a_* using "A8.tex", ///
	   replace label ///
	   keep(MajMethodAlt1 MajMethodAlt2) nomtitle compress collabels(none) nostar ///
	   stats(N r2 Gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban, labels("Observations" "R-squared" "Gender" "Parents' Urban Controls" "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment")) ///		
	   b(3) se(3) ///
	   mgroups("Preference for Democracy", pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   postfoot( ///
       \hline\hline ///
       \end{tabular} ///
	   \begin{adjustwidth}{-1cm}{-1cm}  ///
	   \begin{scriptsize} ///
       Each column reports coefficients from a single OLS regression of the dependent variable described in the column heading on the variable(s) described in the row heading(s). An observation is an émigré from Greater China living in North America who was recruited via Facebook targeted ads to complete an online survey (see Section I.B and online Appendix B.1 for further details about the data collection). Preference for Democracy corresponds to the strength with which participants report preferring democracy as a system of government over a system in which the authority is unconstrained, on a 1 to 5 scale. Majority Method - Alternative 1 and Majority Method - Alternative 2 are based on a participant's preference over a method to assign a decision for a group in the incentivized task. Alternative 1 defines "Prefer Authority Rule" and "Prefer Majority Rule" as a missing (i.e., it only examines participants who strongly preferred either rule or those who were indifferent). Alternative 2 holds a value of 1 when the participant strongly preferred or preferred an authority rule in the decision task, a value of 2 when she was indifferent, and a value of 3 when she preferred or strongly preferred majority rule. Gender is an indicator that equals one if the respondent reports identifying as a female, 0 otherwise. Country of Birth FE, Mother Country FE, and Father Country FE correspond to fixed effects for the respondent's, her mother's, and her fathers countries of birth, respectively. Parents' Educational Attainment corresponds to indicators for whether each parent completed high school or more. Parents' Urban Controls corresponds to indicators for whether each parent came from an urban background. Robust standard errors are in parenthesis. ///
       \end{scriptsize} \end{adjustwidth})
*____________________________________________________________________*

*** A9 ***
/*
In this graph, I manually do something.
1. add a label (`3') to the y-axis
2. adjust the position and size of the note(p-value)
3. hide the key and label of the lower and upper bound
4. adjust the fill-intensity of bar from 80% to 100%
5. add a horizontal reference line (value=3)
6. adjust the margin of the plot region
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1

gen Category=1 if MajMethod==1
replace Category=2 if MajMethod==2
replace Category=3 if MajMethod==3
replace Category=4 if MajMethod==4
replace Category=5 if MajMethod==5

preserve
keep if Category==1 | Category==2
ttest PreferDemo, by(Category) unpaired
scalar p1 = r(p)
restore

preserve
keep if Category==2 | Category==3
ttest PreferDemo, by(Category)
scalar p2 = r(p)
restore

preserve
keep if Category==3 | Category==4
ttest PreferDemo, by(Category)
scalar p3 = r(p)
restore

preserve
keep if Category==4 | Category==5
ttest PreferDemo, by(Category)
scalar p4 = r(p)
restore

statsby PreferDemo=r(mean) upper=r(ub) lower=r(lb), level(90) by(Category) clear : ci mean PreferDemo
format PreferDemo %9.3g

set scheme plotplainblind
twoway (bar PreferDemo Category if Category==1, barwidth(0.9)) ///
       (bar PreferDemo Category if Category==2, barwidth(0.9)) ///
       (bar PreferDemo Category if Category==3, barwidth(0.9)) ///
       (bar PreferDemo Category if Category==4, barwidth(0.9)) ///
	   (bar PreferDemo Category if Category==5, barwidth(0.9)) ///	
       (rcap lower upper Category, color(gray)) ///
       (scatter PreferDemo Category, msymbol(none) mlabel(PreferDemo) mlabposition(6) mlabcolor(white) mlabsize(vsmall)), ///
	   legend(symplacement(southeast) nostack rows(7) position(4) label(1 "Strongly Prefer Authority Method") label(2 "Prefer Authority Method") label(3 "Indifferent") label(4 "Prefer Majority Method") label(5 "Strongly Prefer Majority Method") label(6 "") label(7 "")) ///
	   ytitle("Average Reported Preference for Democracy") xtitle("") subtitle("") ///
	   note({`=string(p1,"%5.4f")'} {`=string(p2,"%5.4f")'} {`=string(p3,"%5.4f")'} {`=string(p4,"%5.4f")'}, position(6) size(tiny)) ///
	   yscale(range(3 4.2)) ylabel(, angle(horizontal)) xlabel(none)  
*____________________________________________________________________*
	   
*** A10 ***
/*
In overleaf, I use the packages: amssymb, booktabs, changepage and adjustbox.
In addition, I manually add the values in the last row "Number of Observation", including `prefer_count', `indiff_count', and `e(N)'
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1

global Table_A10 "age gender highSES married children highEdu BA FEdu MEdu time math trust ideology"

mat balance1=J(13,5,.)
	tokenize ${Table_A10}
	forvalues j=1(1)13{

		ttest ``j'', by(moderate) 
		matrix balance1 [`j',1]= r(mu_2) // Moderate
		matrix balance1 [`j',2]= r(mu_1) // Not moderate
		reg ``j'' moderate, r
		matrix balance1 [`j',3]= _b[moderate]
		matrix balance1 [`j',4]= _se[moderate]
		matrix balance1 [`j',5]= e(N) 
	}
	
matlist balance1

egen prefer_count = total(moderate) if moderate == 1 // 564
egen indiff_count = total(moderate) if moderate == 0 // 543

frmttable using "Appendix10.tex", tex fragment replace			/// 
		statmat(balance1) ///
		ctitles("", "Prefer", "Strongly Prefer or Indifferent", "OLS coefficient", "SE", "Obs.") ///
		rtitles("Age"\ "Female" \"High SES"\ "Married" \"Number of Children"\ "Completed High School or More." \"Completed BA or More"\ "Father's Educational Attainment" \"Mother's Educational Attainment"\ "Time Duration (sec)"\ "Math Ability (1 to 5)" \ "Self-reported Trust" \ "Self-reported Ideology" \ "Number of Observation") ///
		hlines(11{0}11) sdec(2, 2, 2, 2, 0)
*____________________________________________________________________*	
	
*** A11 ***
/*
In this graph, I manually do something.
1. adjust the margin of the plot region
2. adjust the position and size of the note(p-value)
3. hide the key and label of the lower and upper bound
4. adjust the fill-intensity of bar from 80% to 100%
5. add a horizontal reference line (value=3)
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

//
gen Category=1 if fromProlific==1
replace Category=2 if fromFB==1 & mPolitical==1 & China==1
replace Category=3 if fromFB==1 & (Taiwan==1 | HongMacao==1)
replace Category=4 if fromWenjuanxing==1
replace Category=5 if fromFB==1 & mPolitical==0 & China==1

//ttest: To see the p-value between each two groups.
preserve
keep if Category==1 | Category==2
ttest MajMethod, by(Category) unpaired
scalar p1 = r(p)
restore

preserve
keep if Category==2 | Category==3
ttest MajMethod, by(Category)
scalar p2 = r(p)
restore

preserve
keep if Category==3 | Category==4
ttest MajMethod, by(Category)
scalar p3 = r(p)
restore

preserve
keep if Category==4 | Category==5
ttest MajMethod, by(Category)
scalar p4 = r(p)
restore

statsby MajMethod=r(mean) upper=r(ub) lower=r(lb), level(90) by(Category) clear : ci mean MajMethod
format MajMethod %9.3g

//plot
set scheme plotplainblind
twoway (bar MajMethod Category if Category==1, barwidth(0.9)) ///
       (bar MajMethod Category if Category==2, barwidth(0.9)) ///
       (bar MajMethod Category if Category==3, barwidth(0.9)) ///
       (bar MajMethod Category if Category==4, barwidth(0.9)) ///
	   (bar MajMethod Category if Category==5, barwidth(0.9)) ///	
       (rcap lower upper Category, color(gray)) ///
       (scatter MajMethod Category, msymbol(none) mlabel(MajMethod) mlabposition(6) mlabcolor(white) mlabsize(vsmall)), ///
	   legend(symplacement(southeast) nostack rows(7) position(4) label(1 "US Representative") label(2 "Emigres from Mainland China - Political") label(3 "Emigres from HK/Taiwan") label(4 "Mainland China") label(5 "Emigres from Mainland China - Non Political") label(6 "") label(7 "")) ///
	   ytitle("Mean of Majority Method") xtitle("") subtitle("") ///
	   note({`=string(p1,"%5.4f")'} {`=string(p2,"%5.4f")'} {`=string(p3,"%5.4f")'} {`=string(p4,"%5.4f")'}, position(6) size(vsmall)) ///
	   yscale(range(3.4 4.4)) ylabel(, angle(horizontal)) xlabel(none) 
	   
*** Table 2:re ***
/*
In this table, I manually delete the decimals of Observations and do some typesetting using overleaf.
In overleaf, I do several things:
	1. I use the packages: amssymb, adjustbox and booktabs.
	2. I manually turn "Standard errors in parentheses" into "Robust standard errors in parentheses". Since I do use robust r2: vce(r).
	3. I manually adjust the placement of Constant.
	4. I manually add a "[1em]" above `Constant' and a "[1em]" below `Constant.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1 //1107 observations

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

//standardize the 2 variables
local Standard "SkilledAuthority MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var') if Q30 != "不知道"
	replace `var'=std_`var' 
	drop std_`var'
}
gen skAuth_math = SkilledAuthority * math
gen skAuth_BA = SkilledAuthority * BA
gen skAuth_highEdu = SkilledAuthority * highEdu

**Panel A**

eststo regA_1: reghdfe MajMethod math gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore regA_1
estadd ysumm
estadd local gender "$\checkmark$":regA_1
estadd local CountryBirth "$\checkmark$":regA_1
estadd local MotherCountry "$\checkmark$":regA_1
estadd local FatherCountry "$\checkmark$":regA_1
estadd local ParentsEducation "$\checkmark$":regA_1
estadd local ParentsUrban "$\checkmark$":regA_1

eststo regA_2: reghdfe MajMethod BA gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore regA_2
estadd ysumm		
estadd local gender "$\checkmark$":regA_2
estadd local CountryBirth "$\checkmark$":regA_2
estadd local MotherCountry "$\checkmark$":regA_2
estadd local FatherCountry "$\checkmark$":regA_2
estadd local ParentsEducation "$\checkmark$":regA_2
estadd local ParentsUrban "$\checkmark$":regA_2

eststo regA_3: reghdfe MajMethod highEdu gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore regA_3
estadd ysumm
estadd local gender "$\checkmark$":regA_3
estadd local CountryBirth "$\checkmark$":regA_3
estadd local MotherCountry "$\checkmark$":regA_3
estadd local FatherCountry "$\checkmark$":regA_3
estadd local ParentsEducation "$\checkmark$":regA_3
estadd local ParentsUrban "$\checkmark$":regA_3

eststo regA_4: reghdfe MajMethod math skAuth_math SkilledAuthority gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore regA_4
estadd ysumm		
estadd local gender "$\checkmark$":regA_4
estadd local CountryBirth "$\checkmark$":regA_4
estadd local MotherCountry "$\checkmark$":regA_4
estadd local FatherCountry "$\checkmark$":regA_4
estadd local ParentsEducation "$\checkmark$":regA_4
estadd local ParentsUrban "$\checkmark$":regA_4


eststo regA_5: reghdfe MajMethod BA skAuth_BA SkilledAuthority gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore regA_5
estadd ysumm		
estadd local gender "$\checkmark$":regA_5
estadd local CountryBirth "$\checkmark$":regA_5
estadd local MotherCountry "$\checkmark$":regA_5
estadd local FatherCountry "$\checkmark$":regA_5
estadd local ParentsEducation "$\checkmark$":regA_5
estadd local ParentsUrban "$\checkmark$":regA_5

eststo regA_6: reghdfe MajMethod highEdu skAuth_highEdu SkilledAuthority gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore regA_6
estadd ysumm		
estadd local gender "$\checkmark$":regA_6
estadd local CountryBirth "$\checkmark$":regA_6
estadd local MotherCountry "$\checkmark$":regA_6
estadd local FatherCountry "$\checkmark$":regA_6
estadd local ParentsEducation "$\checkmark$":regA_6
estadd local ParentsUrban "$\checkmark$":regA_6

label var MajMethod "Majority Method"
label var skAuth_math "Skilled Authority x Math Ability"
label var skAuth_BA "Skilled Authority x Completed BA or More"
label var skAuth_highEdu "Skilled Authority x Completed High School or More"

estfe regA_1 regA_2 regA_3 regA_4 regA_5 regA_6
esttab regA_1 regA_2 regA_3 regA_4 regA_5 regA_6 using Table2RE.tex, ///
	   replace label ///
	   keep(_cons math BA skAuth_math skAuth_BA highEdu skAuth_highEdu SkilledAuthority) nomtitle compress collabels(none) ///
	   notes  b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) ///
	   stats(gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban N r2, labels("Gender"  "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment" "Parents' Urban Controls" "Observations" "R-squared" ) ) ///
	   order(math BA skAuth_math skAuth_BA highEdu skAuth_highEdu SkilledAuthority Gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban _cons) ///
	   mgroups("Majority Method", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
	   
*** Table 1:re ***
/*
In this table, I manually delete the decimals of Observations and do some typesetting using overleaf.
In overleaf, I do several things:
	1. I use the packages: amssymb, adjustbox and booktabs.
	2. I manually turn "Standard errors in parentheses" into "Robust standard errors in parentheses". Since I do use robust r2: vce(r).
	3. I manually adjust the placement of Constant.
	4. I manually add a "[1em]" above `Constant' and a "[1em]" below `Constant.
*/
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"
keep if fromFB==1 //1107 observations

global ParentsUrban "FUrban MUrban"
global ParentsEducation "FEdu MEdu" 

//standardize the 2 variables
local Standard "PreferDemo MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var'
}

eststo reg4b_1: reghdfe PreferDemo MajMethod gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore reg4b_1
estadd ysumm
estadd local gender "$\checkmark$":reg4b_1
estadd local CountryBirth "$\checkmark$":reg4b_1
estadd local MotherCountry "$\checkmark$":reg4b_1
estadd local FatherCountry "$\checkmark$":reg4b_1
estadd local ParentsEducation "$\checkmark$":reg4b_1
estadd local ParentsUrban "$\checkmark$":reg4b_1

eststo reg4b_2: reghdfe PreferDemo MajMethod math gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
estadd ysumm
estadd local gender "$\checkmark$":reg4b_2
estadd local CountryBirth "$\checkmark$":reg4b_2
estadd local MotherCountry "$\checkmark$":reg4b_2
estadd local FatherCountry "$\checkmark$":reg4b_2
estadd local ParentsEducation "$\checkmark$":reg4b_2
estadd local ParentsUrban "$\checkmark$":reg4b_2

eststo reg4b_3: reghdfe PreferDemo MajMethod BA gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore reg4b_3
estadd ysumm
estadd local gender "$\checkmark$":reg4b_3
estadd local CountryBirth "$\checkmark$":reg4b_3
estadd local MotherCountry "$\checkmark$":reg4b_3
estadd local FatherCountry "$\checkmark$":reg4b_3
estadd local ParentsEducation "$\checkmark$":reg4b_3
estadd local ParentsUrban "$\checkmark$":reg4b_3

eststo reg4b_4: reghdfe PreferDemo MajMethod highEdu gender ${ParentsEducation} ${ParentsUrban}, absorb(CountryBirth MotherCountry FatherCountry) vce(r)
est restore reg4b_4
estadd ysumm
estadd local gender "$\checkmark$":reg4b_4
estadd local CountryBirth "$\checkmark$":reg4b_4
estadd local MotherCountry "$\checkmark$":reg4b_4
estadd local FatherCountry "$\checkmark$":reg4b_4
estadd local ParentsEducation "$\checkmark$":reg4b_4
estadd local ParentsUrban "$\checkmark$":reg4b_4

label var MajMethod "Majority Method"
estfe reg4b_1 reg4b_2 reg4b_3 reg4b_4
esttab reg4b_1 reg4b_2 reg4b_3 reg4b_4 using Table1RE.tex, ///
	   replace label /// 
	   keep(MajMethod math BA highEdu _cons) nomtitle compress collabels(none) ///
	   notes b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) ///
	   stats(gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban N r2, labels("Gender"  "Country of Birth FE" "Mother's Country FE" "Father's Country FE" "Parents' Educational Attainment" "Parents' Urban Controls" "Observations" "R-squared" )) ///
	   order(MajMethod math BA highEdu Gender CountryBirth MotherCountry FatherCountry ParentsEducation ParentsUrban _cons) ///
	   mgroups("Preference for Democracy", pattern(1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
	   
	   
*** Table 3:re***
clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use theData.dta, clear // "theData.dta"

keep if fromWenjuanxing == 1 //489 observations

//standardize the variables
local Standard "MajMethod"

foreach var of local Standard{
	egen std_`var'=std(`var')
	replace `var'=std_`var' 
}


** Panel B **
label var UrbanBackground "Urban Background"
label var MigrChina "Migrated from Rural to Urban within China During Childhood"

eststo regB_1: reg MajMethod UrbanBackground, cluster(mo_province)
est restore regB_1
eststo regB_2: reg MajMethod MigrChina, cluster(mo_province)
est restore regB_2
eststo regB_3: reg MajMethod GDP_growth_92_19_mo, cluster(mo_province)
est restore regB_3
eststo regB_4: reg MajMethod M_GDP_92_19_mo, cluster(mo_province)
est restore regB_4
eststo regB_5: reg MajMethod X_GDP_92_19_mo, cluster(mo_province)
est restore regB_5
eststo regB_6: reg MajMethod FDI_GDP_92_19, cluster(mo_province)
est restore regB_6

esttab regB_1 regB_2 regB_3 regB_4 regB_5 regB_6 using Table3ver2.tex, ///
posthead("\hline \\ \textbf{\underline {Panel B: Economic Experiences}}&&&&&&& \\ & \multicolumn{6}{c}{Dependent Variable: Majority Method} \\ \cmidrule(lr){2-7} \\") ///
replace label nomtitle compress collabels(none) ///
notes b(3) se(3) star(* 0.1 ** 0.05 *** 0.01) ///
stats(N r2, labels("Observations" "R-squared"))

