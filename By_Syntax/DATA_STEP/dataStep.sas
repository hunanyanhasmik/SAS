/* 
	Create a dataset of footballers.
	Define appropriate lengths for all character variables.
	Read the data using the INPUT statement.
	Ensure that player names containing spaces are read correctly.
	Ensure that nationalities containing spaces or special characters are read correctly.
	Store the values exactly as they appear in the raw data.
	Display the dataset using PROC PRINT.
*/


data footballers;
    length Rank $2 Player $20 Nationality $25 Goals $12 Status $10;
    input Rank Player & Nationality & Goals & Status;
    
datalines;
1      Cristiano Ronaldo      Portugal                 900+          Active
2      Lionel Messi           Argentina                850+          Active
3      Pelé                   Brazil                   ~757          Retired
4      Romário                Brazil                   ~745          Retired
5      Ferenc Puskás          Hungary                  ~704          Retired
6      Josef Bican            Austria/Czechoslovakia   ~800–950*     Retired
7      Robert Lewandowski     Poland                   700+          Active
8      Gerd Müller            Germany                  ~735          Retired
9      Eusébio                Portugal                 ~575–600      Retired
10     Luis Suárez            Uruguay                  ~590+         Active
11     Karim Benzema          France                   ~520+         Active
12     Zlatan Ibrahimović     Sweden                   ~560          Retired
13     Hugo Sánchez           Mexico                   ~507          Retired
14     Alfredo Di Stéfano     Argentina/Spain          ~500+         `Retired
15     Zico                   Brazil                   ~500+         Retired
;
run;


proc print data=footballers noobs; 
run;



/*

	Create a dataset of patients.
	
	ID Name Age Sex
	101 John 17 M
	102 Alice 23 F
	103 Mark 66 M
	104 Emma 45 F
	105 David 12 M
	
	Create a new variable AgeGroup.
	Rules:
	
	Age <18 → Child
	18–64 → Adult
	≥65 → Senior
 */

data patients;
  	length Name $20 Sex $1 AgeGroup $10;
 	input ID Name $ Age Sex $;
    
    if missing(Age) then AgeGroup = "Unknown";
    else if Age < 18 then AgeGroup = "Child";
    else if Age < 65 then AgeGroup = "Adult";
    else AgeGroup = "Senior";
    
datalines;
101 John 17 M
102 Alice 23 F
103 Mark 66 M
104 Emma 45 F
105 David 12 M
106 Jill . F
;
run;


proc print data=patients noobs; 
	var ID Name Age Sex AgeGroup;
run;




/* 
	1.	Create a dataset of employees.
	
	2.	Create Bonus. 
			Salary ≥ 70000 → 5000
			Salary ≥ 60000 → 3000
			Otherwise → 1000
	
	3. Keep only employees from the IT department.
	
	4.	Create a DepartmentCode.
			HR → 1
			IT → 2
			Sales → 3
		
	5.1	Sort by Department and Salary (descending). 
    5.2 Keep only employees older than 30.
	5.3 Create an AgeGroup.
	5.4 Create a GenderDescription.
*/


/* 1. */

data employees;
    input ID Name $ Department $ Age Salary Gender $ City $;
datalines;
101 John HR 25 45000 M Boston 
102 Anna IT 34 68000 F Chicago
103 Mike Sales 29 52000 M Boston
104 Sara IT 41 79000 F Dallas
105 David HR 37 61000 M Chicago
106 Emma Sales 24 47000 F Boston
107 Chris IT 31 72000 M Dallas
108 Linda HR 45 83000 F Chicago
109 James Sales 39 65000 M Boston
110 Olivia IT 27 56000 F Dallas
;
run;


/* 2. */

data bonus;
	set employees;
    if Salary >= 70000 then Bonus=5000;
    else if Salary >= 60000 then Bonus=3000;
    else Bonus=1000;
run;


/* 3. */


data it_staff;
	set employees;
	where Department = "IT";
run;


/* 4. */

data dept_code;
    set employees;
    
    select(Department);
	    when("HR")	DepartmentCode = 1;
	    when("IT")	DepartmentCode = 2;
	    when("Sales")	DepartmentCode = 3;
	    otherwise DepartmentCode=.;
	end;
run;


/* 5.1 */

proc sort data=employees out=sorted_emp;
	by Department descending Salary;
run;

data final;
    set sorted_emp;
    
    if Age > 30;                               	/* 5.2 */            
    
    if Age < 40 then AgeGroup="Adult";        	/* 5.3 */   
    else AgeGroup="Senior";
    
     select (Gender);						 	/* 5.4 */ 
        when ("M") GenderDescription="Male";
        when ("F") GenderDescription="Female";
        otherwise GenderDescription="Unknown";
    end;
run;    
    
    
    
    
    
    
    
    
    
