// Table 1
clear all // 得到一個全新的環境
cd "C:\Users\mayda\Python practice\RA_Josie" //一定要cd
use "practice.dta" // import data


* Preference for Democracy (Y)
gen prefer_demo = 0 if Q30 != "" & Q30 !="不知道"
replace prefer_demo=1 if Q30=="1 = 強烈偏好強大且不受限制的領導人"
replace prefer_demo=2 if Q30=="2"
replace prefer_demo=3 if Q30=="3"
replace prefer_demo=4 if Q30=="4"
replace prefer_demo=5 if Q30=="5 = 強烈偏好民主制度"

egen prefer_demo_std = std(prefer_demo) 

* Majority Method
gen majority = 0 if Q18 != ""
replace majority = 1 if Q18=="(v) 強烈傾向由當權者選擇"
replace majority = 2 if Q18=="(iv) 傾向由當權者選擇"
replace majority = 3 if Q18=="(iii) 沒有偏好"
replace majority = 4 if Q18=="(ii) 傾向多數決"
replace majority = 5 if Q18=="(i) 強烈傾向多數決"

egen majority_std = std(majority) if Q30 != "不知道"

reghdfe prefer_demo_std majority_std 
est store m1

* Gender
gen gender = 0 if Q2 != ""  & Q30 != "不知道"
replace gender = 1 if Q2=="女性"  & Q30 != "不知道"


* Birth country
gen country_of_birth = 1 if Q4=="中國（不包含臺灣、香港或澳門）"  & Q30 != "不知道"
replace country_of_birth = 2 if Q4=="加拿大" | Q4=="美國"  & Q30 != "不知道"
replace country_of_birth = 3 if Q4=="澳門" | Q4=="香港"  & Q30 != "不知道"
replace country_of_birth = 4 if Q4=="臺灣"  & Q30 != "不知道"

reghdfe prefer_demo_std majority_std, absorb(gender country_of_birth) 
est store m2

* Mother's birth country
gen new_mother_country = 1 if Q6=="中國（不包含臺灣、香港或澳門）"  & Q30 != "不知道"
replace new_mother_country = 2 if Q6=="加拿大" | Q6=="美國"  & Q30 != "不知道"
replace new_mother_country = 3 if Q6=="澳門" | Q6=="香港"  & Q30 != "不知道"
replace new_mother_country = 4 if Q6=="臺灣"   & Q30 != "不知道"
replace new_mother_country = 5 if Q6=="其它"  & Q30 != "不知道"


* Father's birth country
gen new_father_country = 1 if Q7=="中國（不包含臺灣、香港或澳門）"  & Q30 != "不知道"
replace new_father_country = 2 if Q7=="加拿大" | Q7=="美國"  & Q30 != "不知道"
replace new_father_country = 3 if Q7=="澳門" | Q7=="香港"  & Q30 != "不知道"
replace new_father_country = 4 if Q7=="臺灣"  & Q30 != "不知道"
replace new_father_country = 5 if Q7=="其它"  & Q30 != "不知道"

reghdfe prefer_demo_std majority_std, absorb(gender country_of_birth new_mother_country new_father_country)
est store m3


* Parents’ Educational Attainment
* Create a dummy variable for parents' education (high school or higher)
* Q10ai: father's education
* Q10bi: mather's education
gen parents_education = (Q10ai == "他中學畢業" | ///
                         Q10ai == "他接受過一些高等教育" | ///
                         Q10ai == "他大學畢業或擁有同等高等學歷" | ///
                         Q10ai == "他研究所畢業（例如：碩士、博士等）") & ///
                        (Q10bi == "她中學畢業" | ///
                         Q10bi == "她接受過一些高等教育" | ///
                         Q10bi == "她大學畢業或擁有同等高等學歷" | ///
                         Q10bi == "她研究所畢業（例如：碩士、博士等）") & Q30 != "不知道"

* Convert to 0/1 dummy
replace parents_education = 1 if parents_education & Q30 != "不知道"
replace parents_education = 0 if !parents_education & Q30 != "不知道"

reghdfe prefer_demo_std majority_std, absorb(gender country_of_birth new_mother_country new_father_country parents_education)
est store m4



* Parents’ Urban Controls
* Q24a: Father’s Urban Origin
* Q23a: Mather’s Urban Origin
gen parents_urban = (Q24a == "城市") & (Q23a == "城市") & Q30 != "不知道"

* Convert to 0/1 dummy
replace parents_urban = 1 if parents_urban
replace parents_urban = 0 if !parents_urban

reghdfe prefer_demo_std majority_std, absorb(gender country_of_birth new_mother_country new_father_country parents_education parents_urban)
est store m5

reghdfe prefer_demo_std majority_std, vce(robust)
outreg2 using table1.tex, replace stats(coef se) bdec(3) sdec(3) ctitle(" ")  noaster nocons tex nolabel

reghdfe prefer_demo_std majority_std, vce(robust) absorb(gender country_of_birth) 
outreg2 using table1.tex, append stats(coef se) bdec(3) sdec(3) addtext(Gender, Yes, Country of Birth FE, Yes) ctitle(" ")noaster nocons tex nolabel

reghdfe prefer_demo_std majority_std, vce(robust) absorb(gender country_of_birth new_mother_country new_father_country)
outreg2 using table1.tex, append stats(coef se) bdec(3) sdec(3) addtext(Gender, Yes, Country of Birth FE, Yes, Mother's Country FE, Yes, Father's Country FE, Yes) ctitle(" ") noaster nocons tex nolabel

reghdfe prefer_demo_std majority_std, vce(robust) absorb(gender country_of_birth new_mother_country new_father_country parents_education)
outreg2 using table1.tex, append stats(coef se) bdec(3) sdec(3) addtext(Gender, Yes, Country of Birth FE, Yes, Mother's Country FE, Yes, Father's Country FE, Yes, Parents' Educational Attainment, Yes) ctitle(" ") noaster nocons tex nolabel

reghdfe prefer_demo_std majority_std, vce(robust) absorb(gender country_of_birth new_mother_country new_father_country parents_education parents_urban)
outreg2 using table1.tex, append stats(coef se) bdec(3) sdec(3) addtext(Gender, Yes, Country of Birth FE, Yes, Mother's Country FE, Yes, Father's Country FE, Yes, Parents' Educational Attainment, Yes, Parents' Urban Controls, Yes) ctitle(" ") noaster nocons tex nolabel
