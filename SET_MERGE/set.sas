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
