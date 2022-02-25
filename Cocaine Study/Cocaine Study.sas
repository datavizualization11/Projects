

libname sasd 'E:\data\sasdata';
run;

data finalcoke;
set sasd.finalcoke;
run;


proc contents data=finalcoke;
run;


proc univariate data=finalcoke;
var educate;
run;

proc univariate data=finalcoke_m3;
class tx_cond;
var med_sub;
run;

PROC MEANS data = finalcoke_m3;
class tx_cond;
var med_sub;
RUN;


PROC SORT DATA = finalcoke_m6 OUT = Sorted_m6 ;
   BY tx_cond;
RUN ;

proc rank data = Sorted_m6 descending out=temp (where=(weight_r <= 4));
by tx_cond;
var med_sub;
ranks weight_r;
run;

proc gchart data=temp;
vbar tx_cond / type=mean sumvar=med_sub;
run;


PROC MEANS data = finalcoke_m3;
class gender job ;
var med_sub;
RUN;


proc freq data=finalcoke;
tables race;
run;

proc freq data=finalcoke;
tables month;
run;


DATA finalcoke_m3;
  SET finalcoke;
  IF (month = 3);
RUN;


DATA finalcoke_m6;
  SET finalcoke;
  IF (month = 6);
RUN;

proc glm data = finalcoke_m6;
 class tx_cond gender race job mar_stat;
 model med_sub = tx_cond  /ss3;
run;


proc univariate data=finalcoke;
var age;
run;

proc glm data = finalcoke_m3;
 class tx_cond gender race job mar_stat;
 model med_sub = tx_cond age job DAYSUSED educate gender race mar_stat gender*job daysused*educate*age /ss3;
run;


proc glm data = finalcoke_m6;
 class tx_cond gender race job mar_stat;
 model med_sub = tx_cond age job DAYSUSED educate gender race mar_stat gender*job daysused*educate*age /ss3;
run;

proc glm data = finalcoke_m6;
 class tx_cond;
 model med_sub = tx_cond age DAYSUSED educate /ss3;
run;


/* end */

