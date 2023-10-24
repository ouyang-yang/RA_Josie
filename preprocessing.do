/*
This do file:
[data cleaning + setting variables]
1. Combining China's economic data. This data is provided by Louis, so we don't have them before.
2. Defining some new variables.
3. Labelling variables.
4. Dropping some variables that will not be used in analysis.
*/

clear all
cd "C:\Users\mayda\Python practice\RA_Josie" 
use All.dta, clear // "All.dta" already combine 3 dataset (FB survey, Prolific survey, and Wenjuanxing survey.) 
drop _merge
merge m:1 序号 using "China (variable data loaded)"

drop completesurvey Age DecisionMajority Female SurveyDemocracy OtherGender NorthAmerica China Taiwan HongMacao AuthorityTreatment TreatmentA TreatmentB TreatmentC TreatmentD SES Student Elite Married SkilledAuthority SkilledAuthority_alt Math AM Descendant Descendant_TreatmentA Descendant_TreatmentB Location_Rural Location_City Education US Trust SelfContribution SelfContribution_C OthersContribution OthersContribution_C PoliticalReason _merge HighEducation VeryHighEducation VeryHighMath HighMath StronglyDemocracy StronglyLeader StronglyMajority StronglyPrefer_Survey StronglyAuthority StronglyPrefer_DecisionMajority EffectiveSample Veryrich AboveUniversity Urban UrbanToRural Rural RuralToUrban BigCity Beijing StronglyPrefer Northeast Southeast Middlewest Southwest West FatherEducation MotherEducation SocialMobility PoliticalView GovernmentPolicy Freedom SkilledAuthority_zero FB_analysis Prolific China_survey

* Data from FB (emigres from Greater China living in North America) #1107
gen fromFB = 0 if Q30 !="不知道"
replace fromFB = 1 if Q30 != "" & Q30 !="不知道" // num(Q30=="不知道")=40

* Data from Prolific (US participants) #491
gen fromProlific = 0 if q24 !="Don’t know or prefer not to answer"
replace fromProlific = 1 if q24 != "" & q24 !="Don’t know or prefer not to answer" // num(q24=="不知道")=9

* Data from Wenjuanxing (mainland China participants) #489
gen fromWenjuanxing = 0
replace fromWenjuanxing = 1 if 序号 != ""

* Skilled Authority(Q22)
gen SkilledAuthority = 0 if Q22 == "0 = 完全沒想過" & fromFB == 1 
replace SkilledAuthority = 1 if Q22 == "1 = 非常不可能" & fromFB == 1
replace SkilledAuthority = 2 if Q22 == "2" & fromFB == 1
replace SkilledAuthority = 3 if Q22 == "3" & fromFB == 1
replace SkilledAuthority = 4 if Q22 == "4" & fromFB == 1
replace SkilledAuthority = 5 if Q22 == "5 = 非常有可能" & fromFB == 1
replace SkilledAuthority = 0 if 请回想您先前关于小组的答案该由当权者或多数者决定的选择当您 == "0 = 完全没想过" & fromWenjuanxing == 1
replace SkilledAuthority = 1 if 请回想您先前关于小组的答案该由当权者或多数者决定的选择当您 == "1 = 非常不可能" & fromWenjuanxing == 1
replace SkilledAuthority = 2 if 请回想您先前关于小组的答案该由当权者或多数者决定的选择当您 == "2" & fromWenjuanxing == 1
replace SkilledAuthority = 3 if 请回想您先前关于小组的答案该由当权者或多数者决定的选择当您 == "3" & fromWenjuanxing == 1
replace SkilledAuthority = 4 if 请回想您先前关于小组的答案该由当权者或多数者决定的选择当您 == "4" & fromWenjuanxing == 1
replace SkilledAuthority = 5 if 请回想您先前关于小组的答案该由当权者或多数者决定的选择当您 == "5 = 非常有可能" & fromWenjuanxing == 1
replace SkilledAuthority = 0 if Q22 == "0 = Did not think about it at all" & fromProlific == 1
replace SkilledAuthority = 1 if Q22 == "1 = Very unlikely" & fromProlific == 1
replace SkilledAuthority = 2 if Q22 == "2" & fromProlific == 1
replace SkilledAuthority = 3 if Q22 == "3" & fromProlific == 1
replace SkilledAuthority = 4 if Q22 == "4" & fromProlific == 1
replace SkilledAuthority = 5 if Q22 == "5 = Very likely" & fromProlific == 1
label var SkilledAuthority "Skilled Authority"

* Skilled Authority - Alternative 1
gen SkilledAuthorityAlt1 = SkilledAuthority
replace SkilledAuthorityAlt1 = . if SkilledAuthority == 0
label var SkilledAuthorityAlt1 "Skilled Authority - Alternative 1"

* Skilled Authority - Alternative 2
gen SkilledAuthorityAlt2 = SkilledAuthority
replace SkilledAuthorityAlt2 = 3 if SkilledAuthority == 0
label var SkilledAuthorityAlt2 "Skilled Authority - Alternative 2"

* Preference for Democracy (Q30)(q24)
gen PreferDemo = 0 if fromFB == 1 | fromProlific == 1
replace PreferDemo=1 if Q30=="1 = 強烈偏好強大且不受限制的領導人" & fromFB == 1
replace PreferDemo=2 if Q30=="2" & fromFB == 1
replace PreferDemo=3 if Q30=="3" & fromFB == 1
replace PreferDemo=4 if Q30=="4" & fromFB == 1
replace PreferDemo=5 if Q30=="5 = 強烈偏好民主制度" & fromFB == 1
replace PreferDemo=1 if q24=="1 = strongly prefer a strong unconstrained leader" & fromProlific == 1
replace PreferDemo=2 if q24=="2" & fromProlific == 1
replace PreferDemo=3 if q24=="3" & fromProlific == 1
replace PreferDemo=4 if q24=="4" & fromProlific == 1
replace PreferDemo=5 if q24=="5 = strongly prefer a democratic political system" & fromProlific == 1
label var PreferDemo "Preference for Democracy"

* Majority Method (Q18)
gen MajMethod = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace MajMethod = 1 if (Q18=="(v) 強烈傾向由當權者選擇" & fromFB == 1) | (现在请您在以下的步骤中做选择 == "(v) 强烈倾向由当权者选择" & fromWenjuanxing == 1) | (q16=="(v) strongly prefer choice by the authority" & fromProlific == 1)
replace MajMethod = 2 if (Q18=="(iv) 傾向由當權者選擇" & fromFB == 1) | (现在请您在以下的步骤中做选择 == "(iv) 倾向由当权者选择" & fromWenjuanxing == 1) | (q16==" (iv) prefer choice by the authority" & fromProlific == 1)
replace MajMethod = 3 if (Q18=="(iii) 沒有偏好" & fromFB == 1) | (现在请您在以下的步骤中做选择 == "(iii) 没有偏好" & fromWenjuanxing == 1) | (q16==" (iii) no preference" & fromProlific == 1)
replace MajMethod = 4 if (Q18=="(ii) 傾向多數決" & fromFB == 1) | (现在请您在以下的步骤中做选择 == "(ii) 倾向多数决"& fromWenjuanxing == 1) | (q16 ==" (ii) prefer majority rule" & fromProlific == 1)
replace MajMethod = 5 if (Q18=="(i) 強烈傾向多數決" & fromFB == 1) | (现在请您在以下的步骤中做选择 == "(i) 强烈倾向多数决"& fromWenjuanxing == 1) | (q16=="(i) strongly prefer majority rule" & fromProlific == 1)

* Moderation
gen moderate = 1 if MajMethod == 2 | MajMethod == 4
replace moderate = 0 if moderate == .

* Majority Method - Alternative 1
gen MajMethodAlt1 = MajMethod
replace MajMethodAlt1 = . if MajMethod == 2 | MajMethod == 4
label var MajMethodAlt1 "Majority Method - Alternative 1"

* Majority Method - Alternative 2
gen MajMethodAlt2 = 1 if MajMethod==1 | MajMethod==2
replace MajMethodAlt2 = 2 if MajMethod==3
replace MajMethodAlt2 = 3 if MajMethod==4 | MajMethod==5
label var MajMethodAlt2 "Majority Method - Alternative 2"

* Authority Treatment
gen authTr = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace authTr = 1 if tr_math_considered == 1 & fromFB == 1
replace authTr = 1 if U == "注意："
replace authTr = 1 if timing_t6a_1_clickcount != "" & fromProlific == 1
label var authTr "Authority Treatment"

* Gender (Q2)(FE)
gen Gender = 0 if fromFB == 1 
replace Gender = 1 if Q2=="女性" & fromFB == 1 

* Country of Birth (Q4)(FE)
gen CountryBirth = 1 if Q4=="中國（不包含臺灣、香港或澳門）"  & fromFB == 1 
replace CountryBirth = 2 if (Q4=="加拿大"|Q4=="美國")  & fromFB == 1 
replace CountryBirth = 3 if (Q4=="澳門" | Q4=="香港")  & fromFB == 1 
replace CountryBirth = 4 if Q4=="臺灣" & fromFB == 1 

* Mother's Country (Q6)(FE)
gen MotherCountry = 1 if Q6=="中國（不包含臺灣、香港或澳門）" & fromFB == 1 
replace MotherCountry = 2 if (Q6=="加拿大" | Q6=="美國") & fromFB == 1 
replace MotherCountry = 3 if (Q6=="澳門" | Q6=="香港") & fromFB == 1 
replace MotherCountry = 4 if Q6=="臺灣" & fromFB == 1 
replace MotherCountry = 5 if Q6=="其它" & fromFB == 1 

* Father's birth country (Q7)
gen FatherCountry = 1 if Q7=="中國（不包含臺灣、香港或澳門）" & fromFB == 1
replace FatherCountry = 2 if (Q7=="加拿大" | Q7=="美國")  & fromFB == 1
replace FatherCountry = 3 if (Q7=="澳門" | Q7=="香港")  & fromFB == 1
replace FatherCountry = 4 if Q7=="臺灣" & fromFB == 1
replace FatherCountry = 5 if Q7=="其它" & fromFB == 1

* Father's Educational Attainment (Q10ai)(q8)
gen FEdu = 0 if fromFB == 1 | fromProlific == 1
replace FEdu = 1 if (Q10ai == "他中學畢業" | ///
                         Q10ai == "他接受過一些高等教育" | ///
                         Q10ai == "他大學畢業或擁有同等高等學歷" | ///
                         Q10ai == "他研究所畢業（例如：碩士、博士等）") & fromFB == 1
replace FEdu = 1 if (q8 == "Completed secondary school" | ///
                         q8 == "Some post-secondary education (example: now in college)" | ///
                         q8 == "Completed BA or similar post-secondary degree" | ///
                         q8 == "Completed post-graduate degree (law, medicine, masters, Ph.D., etc.)") & fromProlific == 1					 
replace FEdu = . if q8 == "Don’t know or prefer not to answer"
label var FEdu "Father's Educational Attainment"

* Mother's Educational Attainment (Q10bi)(q9)
gen MEdu = 0 if fromFB == 1 | fromProlific == 1
replace MEdu = 1 if (Q10bi == "她中學畢業" | ///
                         Q10bi == "她接受過一些高等教育" | ///
                         Q10bi == "她大學畢業或擁有同等高等學歷" | ///
                         Q10bi == "她研究所畢業（例如：碩士、博士等）") & fromFB == 1
replace MEdu = 1 if (q9 == "Completed secondary school" | ///
                         q9 == "Some post-secondary education (example: now in college)" | ///
                         q9 == "Completed BA or similar post-secondary degree" | ///
                         q9 == "Completed post-graduate degree (law, medicine, masters, Ph.D., etc.)") & fromProlific == 1					 
replace MEdu = . if q9 == "Don’t know or prefer not to answer"
label var MEdu "Mother's Educational Attainment"

* Father’s Urban Origin (Q24a)
gen FUrban = 0 if fromFB==1
replace FUrban = 1 if Q24a == "城市" & fromFB==1
label var FUrban "Father’s Urban Origin"

* Mother’s Urban Origin (Q23a)
gen MUrban = 0 if fromFB==1
replace MUrban = 1 if Q23a == "城市" & fromFB==1
label var MUrban "Mother’s Urban Origin"

gen age = real(Q1) if fromFB == 1
replace age = real(您今年几岁) if fromWenjuanxing == 1
replace age = real(q1) if fromProlific == 1
label var age "Age"

* Gender
gen gender = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace gender = 1 if (Q2=="女性" | 您认为自己是=="女性" | q37=="a woman") & (fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1)
label var gender "Gender"

* Married
gen married = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace married = 1 if (Q13=="已婚" | 您的婚姻状态为何=="已婚" | q12=="married") & (fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1)
replace married = . if q12=="prefer not to answer"
label var married "Married"

* High SES
gen highSES = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace highSES = 1 if (Q5=="家庭總收入超過 135,000 美元。通常有至少一名家庭成員完成大學學業，或者接受了研究所教育；家裡通常擁有房屋，並能享受假期和旅行；家裡擁有數輛汽車。" | ///
请问在您的家庭中平均一年每人可支配所得总收入扣除税收后再除=="平均每人可支配所得超过40000元" | ///
q4=="Combined household earnings above $135,000.") & (fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1)
replace highSES=. if q4=="Don’t know or prefer not to answer"
label var highSES "High SES"

* Low SES
gen lowSES = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace lowSES = 1 if Q5=="家庭總收入低於 27,000 美元。家中成年人的教育程度通常為中學（含）以下。租用房屋，家中沒有汽車。" & fromFB == 1
replace lowSES = 1 if Q5=="家庭總收入介於 27,000 美元和 45,000 美元之間。家中成年人的教育程度通常為高中（含）以下。租用房屋，家中沒有汽車或擁有一台汽車。" & fromFB == 1
replace lowSES = 1 if 请问在您的家庭中平均一年每人可支配所得总收入扣除税收后再除=="平均每人可支配所得低于7400元" & fromWenjuanxing == 1
replace lowSES = 1 if q4=="Combined household earnings between $27,000 and $45,000." & fromProlific == 1
replace lowSES = 1 if q4=="Combined household earnings below $27,000." & fromProlific == 1
replace lowSES = . if q4=="Don’t know or prefer not to answer"
label var lowSES "Low SES"


* High Educational Attainment (Q11 您的最高学历是 q10)
gen highEdu = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace highEdu = 1 if (Q11 == "中學畢業" | ///
                         Q11 == "部分高等教育（例如：正就讀大學）" | ///
                         Q11 == "大學畢業或同等高等學歷" | ///
						 Q11 == "目前就讀研究所或進行專業研究" | ///
                         Q11 == "研究所畢業（碩士、博士等）") & fromFB == 1
replace highEdu = 1 if (您的最高学历是 == "高中毕业" | ///
                         您的最高学历是 == "部分高等教育（例如：正就读大学）" | ///
                         您的最高学历是 == "大学毕业或同等高等学历" | ///
						 您的最高学历是 == "目前就读研究所或进行专业研究" | ///
                         您的最高学历是 == "研究所毕业（硕士、博士等）") & fromWenjuanxing == 1
replace highEdu = 1 if (q10 == "Completed secondary school" | ///
                         q10 == "Some post-secondary education (example: now in college)" | ///
                         q10 == "Completed BA or similar post-secondary degree" | ///
                         q10 == "Completed post-graduate degree (law, medicine, masters, Ph.D., etc.)") & fromProlific == 1
				
label var highEdu "Completed High School or More"


* Completed BA or More
gen BA = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace BA = 1 if (Q11 == "大學畢業或同等高等學歷" | Q11 == "目前就讀研究所或進行專業研究" | Q11 == "研究所畢業（碩士、博士等）") & fromFB == 1
replace BA = 1 if (您的最高学历是 == "大学毕业或同等高等学历" | 您的最高学历是 == "目前就读研究所或进行专业研究" | 您的最高学历是 == "研究所毕业（硕士、博士等）") & fromWenjuanxing == 1
replace BA = 1 if (q10 == "Completed BA or similar post-secondary degree" | q10 == "Completed post-graduate degree (law, medicine, masters, Ph.D., etc.)") & fromProlific == 1
label var BA "Completed BA or More"


* Current University Student
gen currentUni = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace currentUni = 1 if (Q8a=="是" | 您现在是大学或学院学生吗=="是" | q7a=="Yes") & (fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1)

* Number of Children
gen children = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace children = real(Q14) if fromFB == 1
replace children = real(您有几个孩子) if fromWenjuanxing == 1
replace children = real(q13) if fromProlific == 1
label var children "Number of Children"

* Migrated Within China During Childhood(Migrated Within China During Childhood)
gen MigrChina = 0 if fromWenjuanxing == 1
replace MigrChina = 1 if 请问您主要在农村还是城市长大=="我出生在农村地区，但是在我成长的过程中，我与家人搬到了城市地区"
replace MigrChina = 1 if 请问您主要在农村还是城市长大=="我出生在城市地区，但是在我成长的过程中，我与家人搬到了农村地区"

* Time Duration (sec)
gen time = 0 if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace time = real(Durationinseconds) if fromFB == 1
replace time = real(durationinseconds) if fromProlific == 1

* Math Ability (Q16)
gen math = 0  if fromFB == 1 | fromWenjuanxing == 1 | fromProlific == 1
replace math = 1 if (Q16=="1 = 程度最低" & fromFB == 1)
replace math = 2 if (Q16=="2" & fromFB == 1)
replace math = 3 if (Q16=="3" & fromFB == 1)
replace math = 4 if (Q16=="4" & fromFB == 1)
replace math = 5 if (Q16=="5 = 程度最高" & fromFB == 1)

* Self-reported Trust
gen trust = 0 if fromFB == 1| fromWenjuanxing == 1 | fromProlific == 1
replace trust = 1 if (Q26=="1 = 與人相處須謹慎提防" & fromFB == 1) | ///
                     (一般来说您是否认为大多数的人是可以信任的或者您认为与人相处时=="1 = 与人相处须谨慎为上" & fromWenjuanxing == 1) | ///
					 (q20=="1 = You can’t be too careful"  & fromProlific == 1)
replace trust = 2 if (Q26=="2" & fromFB == 1) | ///
                     (一般来说您是否认为大多数的人是可以信任的或者您认为与人相处时=="2" & fromWenjuanxing == 1) | ///
					 (q20 == "2" & fromProlific == 1)
replace trust = 3 if (Q26=="3" & fromFB == 1) | ///
                     (一般来说您是否认为大多数的人是可以信任的或者您认为与人相处时=="3" & fromWenjuanxing == 1) | ///
					 (q20 == "3" & fromProlific == 1)
replace trust = 4 if (Q26=="4" & fromFB == 1) | ///
                     (一般来说您是否认为大多数的人是可以信任的或者您认为与人相处时=="4" & fromWenjuanxing == 1) | ///
					 (q20 == "4" & fromProlific == 1)
replace trust = 5 if (Q26=="5 = 大多數人是可以信任的" & fromFB == 1) | ///
                     (一般来说您是否认为大多数的人是可以信任的或者您认为与人相处时=="5 = 大多数人是可以信任的" & fromWenjuanxing == 1) | ///
					 (q20 == "5 = Most people can be trusted" & fromProlific == 1)
replace trust = . if q20 == "Prefer not to answer" & fromProlific == 1	
label var trust "Self-Reported Trust"			 
					 
* Self-reported Ideology
gen ideology = 0 if fromFB == 1| fromProlific == 1
replace ideology = 1 if (Q27=="1 = 非常自由" & fromFB == 1) | ///
					 (q21 =="1 = Very liberal" & fromProlific == 1)
replace ideology = 2 if (Q27=="2 = 自由" & fromFB == 1) | ///
					 (q21 == "2" & fromProlific == 1)
replace ideology = 3 if (Q27=="3 = 既不自由也不保守" & fromFB == 1) | ///
					 (q21 == "3" & fromProlific == 1)
replace ideology = 4 if (Q27=="4 = 保守" & fromFB == 1) | ///
					 (q21 == "4" & fromProlific == 1)
replace ideology = 5 if (Q27=="5 = 非常保守" & fromFB == 1) | ///
					 (q21 == "5 = Very conservative" & fromProlific == 1)
replace ideology = . if q21 == "Prefer not to answer"
label var ideology "Self-Reported Ideology"


* Negative CCP Narrative
gen negativeCCP = 0 if fromFB==1
replace negativeCCP = 1 if Q15a != "" & fromFB==1

* Positive CCP Narrative
gen positiveCCP = 0 if fromFB==1
replace positiveCCP = 1 if Q15b != "" & fromFB==1

* Neutral Narrative
gen neutralN = 0 if fromFB==1
replace neutralN = 1 if Q15c != "" & fromFB==1

* China
gen China = 0 if fromFB==1
replace China = 1 if CountryBirth == 1 | (CountryBirth == 2 & MotherCountry == 1) | (CountryBirth == 2 & FatherCountry == 1)

* Hong Kong
gen HongMacao = 0 if fromFB==1
replace HongMacao = 1 if CountryBirth == 3 | (CountryBirth == 2 & MotherCountry == 3) | (CountryBirth == 2 & FatherCountry == 3)

* Taiwan 
gen Taiwan = 0 if fromFB==1
replace Taiwan = 1 if CountryBirth == 4 | (CountryBirth == 2 & MotherCountry == 4) | (CountryBirth == 2 & FatherCountry == 4)

* Democratizing Leader
gen DLeader = 0 if fromFB==1
replace DLeader = 1 if Q37=="我強烈偏好改革派的做法。"
replace DLeader = 2 if Q37=="我稍微偏好改革派的做法。"
replace DLeader = 3 if Q37=="我在兩者之間沒有偏好，或者鑑於現有資訊，我傾向不表達我的偏好。"
replace DLeader = 4 if Q37=="我稍微偏好穩定派候選人的做法。"
replace DLeader = 5 if Q37=="我強烈偏好穩定派候選人的做法。"
label var DLeader "Prefers Democratizing Leader"

* Second Generation (born in N. Am.)
gen SecondGen = 0 if fromFB==1
replace SecondGen = 1 if CountryBirth == 2

* Migration: Political Freedom
gen mPolitical = 0 if fromFB==1 & CountryBirth!= 2
replace mPolitical = 1 if Q25_22 != "" & fromFB==1

* Urban Background
gen UrbanBackground = 0 if fromWenjuanxing==1
replace UrbanBackground = 1 if 请问您主要在农村还是城市长大 == "主要在城市地区"

* Electoral College Undemocratic
gen EleCoUndemo = 0 if fromProlific == 1
replace EleCoUndemo = 1 if q30 == "5 = Strongly disagree that the Electoral College system is inconsistent with democracy" & fromProlific == 1
replace EleCoUndemo = 2 if q30 == " 4  = (disagree, but not very strongly)" & fromProlific == 1
replace EleCoUndemo = 3 if q30 == " 3  = (neither agree nor disagree) " & fromProlific == 1
replace EleCoUndemo = 4 if q30 == " 2  = (agree, but not very strongly)" & fromProlific == 1
replace EleCoUndemo = 5 if q30 == " 1 = Strongly agree that the Electoral College system is inconsistent with democracy" & fromProlific == 1
replace EleCoUndemo = . if q30 == " I don’t know, I have no opinion or I prefer not to answer"
// 欸不是那個空格也太$%#XX了吧...
label var EleCoUndemo "Electoral College Undemocratic"

* Region of Birth
encode q3, gen (state_of_birth) 

gen RBirth=. 

replace RBirth = 1 if state_of_birth==1| state_of_birth==3| state_of_birth==7| state_of_birth==8| state_of_birth==9| state_of_birth==10| state_of_birth==17| state_of_birth==18| state_of_birth==24| state_of_birth==33| state_of_birth==35| state_of_birth==39| state_of_birth==40| state_of_birth==41| state_of_birth==39| state_of_birth==43| state_of_birth==39| state_of_birth==45| state_of_birth==20

replace RBirth = 2 if state_of_birth==37| state_of_birth==32| state_of_birth==30| state_of_birth==29| state_of_birth==19| state_of_birth==21| state_of_birth==38

replace RBirth = 3 if state_of_birth==2| state_of_birth==4| state_of_birth==5| state_of_birth==12| state_of_birth==11| state_of_birth==26| state_of_birth==28|state_of_birth==26| state_of_birth==31|state_of_birth==36| state_of_birth==42| state_of_birth==44| state_of_birth==47

replace RBirth = 4 if RBirth == .

* Father's Continent of Birth
gen FCont=1 if fromProlific == 1
replace FCont=2 if q6=="Argentina"|q6=="Brazil"|q6=="Colombia"|q6=="Bolivia"|q6=="Costa Rica"|q6=="Cuba"|q6=="Dominican Republic"|q6=="Guatemala"|q6=="Haiti"|q6=="Jamaica"|q6=="Panama"|q6=="Mexico"|q6=="Canada" & fromProlific == 1 
replace FCont=3 if q6=="Belgium"|q6=="Bulgaria"|q6=="Germany"|q6=="Ireland"|q6=="Italy"|q6=="Montenegro"|q6=="Poland"|q6=="Romania"|q6=="Ukraine"|q6=="United Kingdom" & fromProlific == 1
replace FCont=4 if q6=="Iran"|q6=="Iraq"|q6=="Israel"|q6=="Pakistan"|q6=="Senegal" & fromProlific == 1
replace FCont=5 if q6=="Vietnam"|q6=="Thailand"|q6=="Taiwan"|q6=="Philippines"|q6=="South Korea"|q6=="Laos"|q6=="India"|q6=="China" & fromProlific == 1
label var FCont "Father's Continent of Birth"

* Freedom of Speech
gen FreeSpeech=. if fromProlific == 1
replace FreeSpeech = 1 if q23=="1 = They are not very important or they need to be qualified" & fromProlific == 1
replace FreeSpeech = 2 if q23=="2" & fromProlific == 1
replace FreeSpeech = 3 if q23=="3" & fromProlific == 1
replace FreeSpeech = 4 if q23=="4" & fromProlific == 1
replace FreeSpeech = 5 if q23=="5 = They are extremely important and they should be largely unconditional" & fromProlific == 1
label var FreeSpeech "Freedom of Speech"

* China's economic variables
label var GDP_growth_92_19_mo "Province GDP Growth(Average 92-19)"
label var M_GDP_92_19_mo "Province Imports/GDP(Average 92-19)"
label var X_GDP_92_19_mo "Province Exports/GDP(Average 92-19)"
label var FDI_GDP_92_19 "Province FDI/GDP(Average 92-19)"



save theData.dta, replace 


