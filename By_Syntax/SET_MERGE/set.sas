/* Combine both datasets into all_sales. */

data sales_a;
    input id name $ amount;
    datalines;
1 Alice 100
2 Bob   200
3 John 500
4 Mary 100
5 David 200
;
run;

data sales_b;
    input id name $ region $ amount;
    datalines;
3 Carol East  300
4 David West  400
5 Sarah West 500
6 Mike East 200
;
run;

data all_sales;
	set sales_a sales_b;
run;


/* 	Combine both datasets, but create a variable called employee_type:
	"Employee" for records from employees
	"Contractor" for records from contractors
*/

data employees;
    input id name $ department $;
    datalines;
1 John IT
2 Mary HR
3 Peter FINANCE
;
run;

data contractors;
    input id name $ department $;
    datalines;
101 Mike IT
102 Susan HR
;
run;


data all_staff;
    set employees(in=emp)
        contractors(in=con);

    if emp then employee_type = "Employee";
    else if con then employee_type = "Contractor";
run;


/* Create a dataset containing only customers that appear in both datasets. */

data sales;
    input id amount;
    datalines;
1 100
2 200
3 300
4 400
5 500
;
run;


data sales_subset;
    set sales(firstobs=3 obs=5);
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
