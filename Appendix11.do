// Appendix A.11
clear all // 得到一個全新的環境
cd "C:\Users\mayda\Python practice\RA_Josie" //一定要cd
use "practice.dta" // import data

* Majority Method
gen majority = 1 if (Q18=="(v) 強烈傾向由當權者選擇" | 现在请您在以下的步骤中做选择 == "(v) 强烈倾向由当权者选择" | q16=="(v) strongly prefer choice by the authority")

replace majority = 2 if (Q18=="(iv) 傾向由當權者選擇" | 现在请您在以下的步骤中做选择 == "(iv) 倾向由当权者选择" | q16==" (iv) prefer choice by the authority") 

replace majority = 3 if (Q18=="(iii) 沒有偏好" | 现在请您在以下的步骤中做选择 == "(iii) 没有偏好" | q16==" (iii) no preference")

replace majority = 4 if (Q18=="(ii) 傾向多數決" | 现在请您在以下的步骤中做选择 == "(ii) 倾向多数决" | q16 ==" (ii) prefer majority rule")

replace majority = 5 if (Q18=="(i) 強烈傾向多數決" | 现在请您在以下的步骤中做选择 == "(i) 强烈倾向多数决" | q16=="(i) strongly prefer majority rule")

* Preference for Democracy (Q30)
gen prefer_demo = 0 if Q30 != "" & Q30 !="不知道"
replace prefer_demo=1 if Q30=="1 = 強烈偏好強大且不受限制的領導人"
replace prefer_demo=2 if Q30=="2"
replace prefer_demo=3 if Q30=="3"
replace prefer_demo=4 if Q30=="4"
replace prefer_demo=5 if Q30=="5 = 強烈偏好民主制度"

tabulate Q30 if Q30 == "不知道"

* Preference for Democracy (q24)
gen prefer_demo_q = 0 if q24 != "" & q24 !="Don’t know or prefer not to answer"
replace prefer_demo_q=1 if q24=="1"
replace prefer_demo_q=2 if q24=="2"
replace prefer_demo_q=3 if q24=="3"
replace prefer_demo_q=4 if q24=="4"
replace prefer_demo_q=5 if q24=="5 = strongly prefer a democratic political system"

tabulate q24 if q24 == "Don’t know or prefer not to answer"

* Political
gen political = 1 if (Q25_22 == "1" | Q25_22 == "2" | Q25_22 == "3" )
replace political = 0 if (Q25_22 != "1" & Q25_22 != "2" & Q25_22 != "3" & Q1 != "")

* Birth
gen e_China = 1 if (Q4 =="中國（不包含臺灣、香港或澳門）")
gen e_HKT = 1 if (Q4 =="香港" | Q4 =="臺灣" | Q4 =="澳門" | ((Q4 =="美國" | Q4 =="加拿大") & (Q6=="澳門" | Q6=="香港" | Q6=="臺灣") & (Q7=="澳門" | Q7=="香港" | Q7=="臺灣")))


gen e_China_pol = 1 if (political == 1 & e_China == 1)
gen e_China_nonpol = 1 if (political == 0 & e_China == 1)

// Calculate means and confidence intervals for major
gen majority_us = majority if q16 != "" & q24 !="Don’t know or prefer not to answer"
gen majority_pol = majority if e_China_pol == 1 & Q30 !="不知道"
gen majority_hkt = majority if e_HKT == 1 & Q30 !="不知道"
gen majority_ch = majority if 现在请您在以下的步骤中做选择 != ""
gen majority_nonpol = majority if e_China_nonpol == 1 & Q30 !="不知道"

ttest majority_us == majority_pol, unpaired
scalar p1 = r(p)
ttest majority_pol == majority_hkt, unpaired
scalar p2 = r(p)
ttest majority_hkt == majority_ch, unpaired
scalar p3 = r(p)
ttest majority_ch == majority_nonpol, unpaired
scalar p4 = r(p)

gen category = .
replace category = 1 if !missing(majority_us)
replace category = 2 if !missing(majority_pol)
replace category = 3 if !missing(majority_hkt)
replace category = 4 if !missing(majority_ch)
replace category = 5 if !missing(majority_nonpol)
statsby mean_majority=r(mean) upper=r(ub) lower=r(lb), level(90) by(category) clear : ci mean majority
format mean_majority %9.3g
  
	   
//Mean of Majority Method
twoway (bar mean_majority category if category==1, color(black) barwidth(0.9)) ///
       (bar mean_majority category if category==2, color(gray) barwidth(0.9)) ///
       (bar mean_majority category if category==3, color(ebblue) barwidth(0.9)) ///
       (bar mean_majority category if category==4, color(midgreen) barwidth(0.9)) ///
	   (bar mean_majority category if category==5, color(magenta) barwidth(0.9)) ///	
       (rcap lower upper category, color(gray)) ///
       (scatter mean_majority category, msymbol(none) mlabel(mean_majority) mlabposition(6) mlabcolor(white) mlabsize(vsmall)), ///
       legend(symplacement(southeast) nostack rows(7) position(4) label(1 "US Representative") label(2 "Emigres from Mainland China - Political") label(3 "Emigres from HK/Taiwan") label(4 "Mainland China") label(5 "Emigres from Mainland China - Political") label(6 "") label(7 "")) note({`=string(p1,"%5.4f")'} {`=string(p2,"%5.4f")'} {`=string(p3,"%5.4f")'} {`=string(p4,"%5.4f")'}, position(6) size(tiny)) ytitle("Mean of Majority Method") xtitle("") subtitle("")

