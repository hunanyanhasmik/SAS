/* You have an Employee Master file (Name/Department) and a Payroll file (Salary/Bonus).  */
/* Create a single dataset for the accountant containing all information. */


data employee_master;
  length EMP_ID $3 NAME $20 DEPT $10;
  infile datalines dsd;
  input EMP_ID $ NAME $ DEPT $;
datalines;
001,Alice,IT
002,Bob,HR
003,Charlie,Finance
;
run;

data payroll;
  length EMP_ID $3 SALARY 8 BONUS 8;
  infile datalines dsd;
  input EMP_ID $ SALARY BONUS;
datalines;
001,75000,5000
002,68000,3000
003,82000,7000
;
run;


proc sort data=employee_master; by emp_id; run;
proc sort data=payroll; by emp_id; run;

data hr_report;
  merge employee_master(in=a) payroll(in=b);
  by emp_id;
  
  if a and b; 
  TOTAL_COMP = salary + bonus;
run;


/* You have separate datasets for January and February sales. You need one chronological file sorted by Date within each Store. */


data jan_sales;
  length STORE $2 SALE_DATE 8 AMOUNT 8;
  format SALE_DATE date9.;
  infile datalines dsd;
  input STORE $ SALE_DATE :date9. AMOUNT;
datalines;
A,05JAN2024,100
B,10JAN2024,150
C,15JAN2024,200
D,20JAN2024,175
;
run;

data feb_sales;
  length STORE $2 SALE_DATE 8 AMOUNT 8;
  format sale_date date9.;
  infile datalines dsd;
  input STORE $ SALE_DATE :date9. AMOUNT;
datalines;
A,05FEB2024,125
B,10FEB2024,275
C,15FEB2024,350
D,20FEB2024,400
;
run;

proc sort data=jan_sales; by store sale_date; run;
proc sort data=feb_sales; by store sale_date; run;

data all_sales;
	set jan_sales feb_sales;
	by store sale_date;
run;

/* You have a roster of all students and a separate list of students who paid fees. */
/* You need a final roster with a flag (PAID_FLAG) indicating who has paid. */


data roster;
  length STUDENT_ID $3 NAME $20;
  infile datalines dsd;
  input STUDENT_ID $ NAME $;
datalines;
S01,Emma
S02,Liam
S03,Noah
S04,Olivia
;
run;

data fee_payers;
  length STUDENT_ID $3;
  infile datalines dsd;
  input STUDENT_ID $;
datalines;
S01
S03
;
run;


proc sort data=roster; by student_id; run;
proc sort data=fee_payers; by student_id; run;

data attendance_report;
	merge roster(in=a) fee_payers(in=b);
	by student_id;
	
	if a;
	PAID_FLAG = b;
run;


/* There are 2 datasets in 2 different sheets.   */
/* For each employee, get the average salary. */
/* If the employee has more than 5 years’ experience, multiply the average salary by 2,  */
/* otherwise, multiply the average salary by 1.5. Keep the new salaries in a new column. */


proc import datafile="/home/u64453174/github/sheet1.xlsx"
    out=sheet1
    dbms=xlsx
    replace;
    getnames=yes;
run;

proc import datafile="/home/u64453174/github/sheet2.xlsx"
    out=sheet2
    dbms=xlsx
    replace;
    getnames=yes;
run;

/* Standardizing variables in sheets */

data sheet1;
    length Department $20 Position $30;
    set sheet1;

    Department = strip(Department);
    Position = strip(Position);
run;

data sheet2;
    length Department $20 Position $30;
    set sheet2;

    Department = strip(Department);
    Position = strip(Position);
run;


proc sort data=sheet1;
    by Department Position;
run;

proc sort data=sheet2;
    by Department Position;
run;


data employee_salaries;
    merge sheet1(in=a)
          sheet2(in=b);

    by Department Position;

    if a;

    if Experience > 5 then
        TotalSalary = AvgSalary * 2;
    else
        TotalSalary = AvgSalary * 1.5;
run;

proc print data=employee_salaries noobs;
    var EmpID Department Position Experience AvgSalary TotalSalary;
    title "Employee Salaries";
run;
