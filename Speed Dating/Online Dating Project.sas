libname rhr "I:\";

proc contents data= speeddating;
run;

data rhr.dating;
set speeddating;

*1a;
if AgeM LE 23 THEN AgeGroupM="Younger";
else if AgeM ge 24 and AgeM le 29 then AgeGroupM="Average";
else if AgeM ge 30 then AgeGroupM="Older";
if AgeM=. then AgeGroupM=" ";

IF AgeF LE 23 THEN AgeGroupF="Younger";
else if AgeF ge 24 and AgeF le 29 then AgeGroupF="Average";
else if AgeF ge 30 then AgeGroupF="Older";
if AgeF=. then AgeGroupF=" ";

*1b - Ambitious varibles;
IF AmbitiousM=1 or AmbitiousM=2 THEN Ambitious5M=1;
ELSE IF AmbitiousM=3 or AmbitiousM=4 THEN Ambitious5M=2;
ELSE IF AmbitiousM=5 or AmbitiousM=6 THEN Ambitious5M=3;
ELSE IF AmbitiousM=7 or AmbitiousM=8 THEN Ambitious5M=4;
ELSE IF AmbitiousM=9 or AmbitiousM=10 THEN Ambitious5M=5;
IF AmbitiousM=. THEN Ambitious5M=.;

IF AmbitiousF=1 OR AmbitiousF=2 THEN Ambitious5F=1;
ELSE IF AmbitiousF=3 OR AmbitiousF=4 THEN Ambitious5F=2;
ELSE IF AmbitiousF=5 OR AmbitiousF=6 THEN Ambitious5F=3;
ELSE IF AmbitiousF=7 OR AmbitiousF=8 THEN Ambitious5F=4;
ELSE IF AmbitiousF=9 OR AmbitiousF=10 THEN Ambitious5F=5;
IF AmbitiousF=. THEN Ambitious5F=.;

*1b - Attractive varibles;
IF AttractiveM=1 or AttractiveM=2 THEN Attractive5M=1;
ELSE IF AttractiveM=3 or AttractiveM=4 THEN Attractive5M=2;
ELSE IF AttractiveM=5 or AttractiveM=6 THEN Attractive5M=3;
ELSE IF AttractiveM=7 or AttractiveM=8 THEN Attractive5M=4;
ELSE IF AttractiveM=9 or AttractiveM=10 THEN Attractive5M=5;
IF AttractiveM=. THEN Attractive5M=.;

IF AttractiveF=1 OR AttractiveF=2 THEN Attractive5F=1;
ELSE IF AttractiveF=3 OR AttractiveF=4 THEN Attractive5F=2;
ELSE IF AttractiveF=5 OR AttractiveF=6 THEN Attractive5F=3;
ELSE IF AttractiveF=7 OR AttractiveF=8 THEN Attractive5F=4;
ELSE IF AttractiveF=9 OR AttractiveF=10 THEN Attractive5F=5;
IF AttractiveF=. THEN Attractive5F=.;

run;

proc sort data = rhr.dating out = ascend_dating;
by ageM ageF ;
RUN;

Proc freq data = ascend_dating ORDER = DATA;
run;

proc contents data = rhr.dating;
run;
*2;
Proc freq data = rhr.dating;
tables DecisionM*DecisionF / nocol nopercent norow expected chisq measures;
run;

*question 3&4;
data ques_3M;
set rhr.dating (KEEP=DecisionM AgeGroupM AgeM);
rename AgeGroupM = AgeGroup ;
rename AgeM = Age ;
Sex = "Male  ";
if DecisionM = 1 THEN Decision = "yes";
else Decision = "no";
run;

data ques_3F;
set rhr.dating (KEEP=DecisionF AgeGroupF AgeF);
rename AgeGroupF = AgeGroup ;
rename AgeF = Age ;
Sex = "Female";
if DecisionF = 1 THEN Decision = "yes";
else Decision = "no";
run;

data quest_3_merge;
set ques_3M (drop = DecisionM) ques_3F (drop = DecisionF);
run;

proc sort data = quest_3_merge;
by Age ;
run;

proc freq data=quest_3_merge order=data;
 tables AgeGroup*Sex*Decision / chisq expected cmh measures;
run;


*5;
data ques_5M;
set rhr.dating (KEEP=RaceM AgeGroupM AgeM);
rename AgeGroupM = AgeGroup ;
rename RaceM = Race ;
rename AgeM = Age ;
Sex = "Male  ";
run;

data ques_5F;
set rhr.dating (KEEP=RaceF AgeGroupF AgeF);
rename AgeGroupF = AgeGroup ;
rename RaceF = Race ;
rename AgeF = Age ;
Sex = "Female";
run;

data quest_5_merge;
set ques_5M ques_5F;
run;

proc sort data = quest_5_merge;
by Age ;
run;

proc freq data=quest_5_merge order=data;
 tables Sex*AgeGroup*Race  / scores = modridit chisq expected cmh;
run;

*q6  ;
data ques_6M;
set rhr.dating (KEEP=AgeGroupM Attractive5M AgeM);
rename AgeGroupM = AgeGroup ;
rename Attractive5M = Attractive5;
rename AgeM = Age;
Sex = "Male  ";
run;

data ques_6F;
set rhr.dating (KEEP=AgeGroupF Attractive5F AgeF);
rename AgeGroupF = AgeGroup ;
rename Attractive5F = Attractive5;
rename AgeF = Age;
Sex = "Female";
run;

data quest_6_merge;
set ques_6M ques_6F;
run;

proc sort data = quest_5_merge out= quest_5_merge;
by Age ;
run;

proc freq data=quest_6_merge order=data;
 tables Sex*AgeGroup*Attractive5  / scores = modridit chisq expected cmh nocol nopercent;
run;


*7;
data ques_7;
set ascend_dating;
if DecisionM = 1 and DecisionF= 1 then match="Yes";
else match = 'No';

if RaceM= 'Caucasian' and RaceF='Caucasian' then same_race= 'Yes';
else if RaceM='Black' and RaceF='Black' then same_race="Yes";
else if RaceM='Asian' and RaceF='Asian' then same_race="Yes" ;
else if RaceM='Latino'and RaceF='Latino' then same_race="Yes";
else same_race="No";
run; 

proc freq data=ques_7 order=data;
Tables match*same_race / nopercent nocol norow chisq expected;
run;




*SECTION THREE -- LOGISTIC REGRESSION ;

*Q8;
proc logistic data=ascend_dating order=data;
class AgeGroupM (ref='Younger' )/ PARAM=REFERENCE; 
model DecisionM (event ='1') = AgeGroupM / SCALE=NONE AGGREGATE;
ODDSRATIO DecisionM;
ODDSRATIO AgeGroupM;
run;


*Question 9;
proc logistic data=rhr.dating order=data;
class AgeGroupF (ref='Younger' )/ PARAM=REFERENCE; 
model DecisionF (event ='1') = AgeGroupF / SCALE=NONE AGGREGATE;
ODDSRATIO DecisionF;
ODDSRATIO AgeGroupF;
run;

*8a - PREDICTED VALUES;
proc freq DATA = rhr.dating;
tables AgeGroupM*DecisionM / noPercent noRow noCol NOCUM out= rhr.ques_8;
run;

DATA QUES_8_1;
INPUT AgeGroupM $ DecisionM COUNT;
DATALINES;
Average 0 78
Average 1 87
Older 0 30
Older 1 18
Younger 0 19
Younger 1 36
;
run;

PROC LOGISTIC DATA = QUES_8_1;
class AgeGroupM (ref='Younger' )/ PARAM=REFERENCE;
FREQ COUNT;
MODEL DecisionM (event = '1')= AgeGroupM ;
OUTPUT OUT=PREDICTED PRED=PROBABILTY;
RUN;

proc print data=PREDICTED;
run;

*9a - PREDICTED VALUES;
proc freq DATA = rhr.dating;
tables AgeGroupF*DecisionF / noPercent noRow noCol NOCUM out= ques_9;
run;

DATA QUES_9_1;
INPUT AgeGroupF $ DecisionF COUNT;
DATALINES;
Average 0 90
Average 1 66
Older 0 14
Older 1 28
Younger 0 41
Younger 1 32
;
run;

PROC LOGISTIC DATA = QUES_9_1;
class AgeGroupF (ref='Younger' )/ PARAM=REFERENCE;
FREQ COUNT;
MODEL DecisionF (event = '1')= AgeGroupF ;
OUTPUT OUT=PREDICTED_9 PRED=PROBABILTY;
RUN;

proc print data=PREDICTED_9;
run;

*10;

proc logistic data=quest_3_merge order=data;
class AgeGroup (ref='Younger') Sex (ref='Female') Decision (ref='yes')/ PARAM=REFERENCE; 
model Decision = AgeGroup|sex / SCALE=NONE AGGREGATE;
run;

*11;
PROC LOGISTIC DATA = ascend_dating order=data;
class RaceF/ PARAM=REFERENCE;
MODEL DecisionM (event = '1')= attractivem intelligentm/SCALE=NONE AGGREGATE influence iplots;
RUN;

*12;
PROC LOGISTIC DATA = ascend_dating order=data;
class RaceM/ PARAM=REFERENCE;
MODEL DecisionM (event = '1')= funf sharedinterestsf /SCALE=NONE AGGREGATE influence iplots;
RUN;
