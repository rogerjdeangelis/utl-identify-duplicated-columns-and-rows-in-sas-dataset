%let pgm=utl-identify-duplicated-columns-and-rows-in-sas-dataset;

Identify duplicated columns and rows in sas dataset

This is a not a general solution. The fastest method uses the R packagedigest) and hashes.

github
https://tinyurl.com/byttakzf
https://github.com/rogerjdeangelis/utl-identify-duplicated-columns-and-rows-in-sas-dataset

StackOverflow
https://tinyurl.com/4pva22cp
https://stackoverflow.com/questions/75723165/how-to-select-only-these-rows-where-values-in-all-column-all-the-same-in-sas-ent

related repo
https://tinyurl.com/bp9em59w
https://github.com/rogerjdeangelis/utl_remove_identical_duplicated_columns

related
StackOverflow
https://tinyurl.com/ybn2u5dn
https://stackoverflow.com/questions/51686794/remove-identical-columns-while-keeping-one-from-each-group



/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have ;
 input (x1-x5) ($);
cards4;
1 1 1 1 1
1 1 1 1 1
1 1 1 1 1
1 X 1 X 1
1 X 1 X 1
;;;;
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Up to 40 obs from last table SD1.HAVE total obs=5 07APR2023:14:31:47                                                  */
/*                                                                                                                        */
/*  Obs    X1    X2    X3    X4    X5                                                                                     */
/*                                                                                                                        */
/*   1     1     1     1     1     1                                                                                      */
/*   2     1     1     1     1     1   Row 2 is duplicate rof row 1                                                       */
/*   3     1     1     1     1     1   Row 3 is duplicate rof row 1                                                       */
/*   4     1     X     1     X     1                                                                                      */
/*   5     1     X     1     X     1   Row 5 is duplicate rof row 4                                                       */
/*                                                                                                                        */
/*                                                                                                                        */
/*  Obs    X1    X2    X3 Dup of X1  X4 Dup of X2   X5 Dup of X1                                                          */
/*                                                                                                                        */
/*   1     1     1     1             1              1                                                                     */
/*   2     1     1     1             1              1                                                                     */
/*   3     1     1     1             1              1                                                                     */
/*   4     1     X     1             X              1                                                                     */
/*   5     1     X     1             X              1                                                                     */
/*                                                                                                                        */
/* Up to 40 obs from last table WORK.WANT total obs=6 07APR2023:15:57:07                                                  */
/*                                                                                                                        */
/* Obs    COL_ROW         SOURCE                                                                                         */
/*                                                                                                                        */
/*  1        3        Duplicate Column                                                                                    */
/*  2        4        Duplicate Column                                                                                    */
/*  3        5        Duplicate Column                                                                                    */
/*  4        2        Duplicate Row                                                                                       */
/*  5        3        Duplicate Row                                                                                       */
/*  6        5        Duplicate Row                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utlfkil(d:/xpt/want.xpt);

proc datasets lib=work nolist nodetails;
  delete want;
run;quit;

%utl_submit_r64('

library(haven);
library(SASxport);
library(data.table);

have<-read_sas("d:/sd1/have.sas7bdat");

dupcol <- duplicated(as.list(have));
colnums<-colnames(have[dupcol]);
rownums<-colnames(have[duplicated(have)]);

duprows<-as.data.frame(substring(rownums, 2, 2)) ;
dupcols<-as.data.frame(substring(colnums, 2, 2)) ;

write.xport(dupcols, duprows,file="d:/xpt/want.xpt");
');

libname xpt xport "d:/xpt/want.xpt";
data want;

  set xpt.dupcols xpt.duprows indsname=inds open=defer;
  source=inds;

  if source="XPT.DUPCOLS" then source='Duplicate Column';
  else source='Duplicate Row   ';

  col_row=SUBSTRIN;

run;quit;
libname xpt clear;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Up to 40 obs from WANT total obs=6 07APR2023:16:02:42                                                                  */
/*                                                                                                                        */
/* Obs    COL_ROW         SOURCE                                                                                          */
/*                                                                                                                        */
/*  1        3        Duplicate Column                                                                                    */
/*  2        4        Duplicate Column                                                                                    */
/*  3        5        Duplicate Column                                                                                    */
/*                                                                                                                        */
/*  4        2        Duplicate Row                                                                                       */
/*  5        3        Duplicate Row                                                                                       */
/*  6        5        Duplicate Row                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/


