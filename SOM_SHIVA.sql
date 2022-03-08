SELECT*
FROM EMPLOYEEX;
SELECT*
FROM DEPARTMENT;
SELECT*
FROM SALARY_GRADE;

---* SUBSTR by DEFAULT  : SUBSTR(S,1,LENGTH_OF_STRING_BYDEFAULT)
---* REPLACE by DEFAULT : REPLACE(S,',', SPACE_IN_QUOTE_BYDEFAULT)
---* ALWAYS to Remember Commands
SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP_PART';
SELECT *
FROM v$version;
SELECT *
FROM v$session;
SELECT *
FROM v$option;
SELECT *
FROM v$thread;
ALTER
SYSTEM KILL SESSION 'SID,SERIAL#'
SELECT SYS.dbms_metadata.get_ddl('TABLE', 'EMP_PART')
FROM dual;
ALTER TABLE PRINCE.emp_fake
    MODIFY SEX INVISIBLE; ---* AS not possible WITH SYS ( may be with a HACk )

===* ROWID === archietecture === * === * === * === * === *
0 0 0 0 0 0  ---- F F F ------- B B B B B B -------- R R R
 |_________|       |___|         |_________|          |___|
      |              |                |                 |
      |              |                |                 |
[ object ID ]   [ Datafile ]    [ Block Number ]   [ Row Number ]
[  4- bytes ]   [ 1.5 bytes ]   [ 2.5 - bytes  ]   [ 2  - bytes ]  = 10 bytes

˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
PURGE TABLE A;
DESC USER_RECYCLEBIN;
FLASHBACK
TABLE A TO BEFORE DROP;

--* FETCH
SELECT*
FROM emp_part
    FETCH FIRST 4 ROWS ONLY;

--* OFFSET A
SELECT*
FROM employees
ORDER BY employee_id DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

---* OFFSET B
SELECT *
FROM employees OFFSET (SELECT COUNT(*) FROM employees) - 3 ROW FETCH FIRST 3 ROW ONLY;


--* NOTE : AND operator returns value FROM single ROW
===*  AND  --> 1 AND 1 = 1   | 1 AND 0 = 0

--*    BUT OR operator CAN return values FROM Multiple ROW
===*  OR   --> 1 OR 1    |

--* COUNT(*) = ALl Columns || COUNT(1) = first_colum

--* WITH clause fails with Join Alias so,
-- one need to define multiple columns in the SELECT query of WITH clause.
WITH CTE AS (
    SELECT*
    FROM employeex A,
         department B
    WHERE A.dep_id = B.dep_id
      AND B.dep_location = 'PERTH'
) ----* with clause will throw error if column not defined
     ---* WHY ?.. because of alias A,B
SELECT *
FROM CTE
WHERE (SELECT MAX(hire_date) FROM CTE) <
      (SELECT MAX(hire_date)
       FROM employeex
       WHERE salary BETWEEN (SELECT min_sal FROM salary_grade WHERE grade = 2)
                 AND (SELECT max_sal FROM salary_grade WHERE grade = 2)
      )
  AND salary = (SELECT MAX(salary) FROM CTE);


--* Comparing (multiple values)Function
-- only possible with HAVING clause.
--* AS Functions won't work with WHERE clause


---* ORDER BY [ With / without GROUP BY ]
---* here Order BY works in this condition When GROUP BY is not present.
--* we can Write anything in ORDER BY
SELECT emp_name
FROM employeex
ORDER BY emp_id;

---* It will throw you an ERROR as only works with the column mentioned in front group by
SELECT emp_name
FROM employeex
GROUP BY dep_id
ORDER BY emp_name;


---* Fix
SELECT dep_id
FROM employeex
GROUP BY dep_id, emp_id
ORDER BY emp_id;

----*Having column name With GROUP BY
---* Column name won't work without aggregate FUNCTION
SELECT MAX(salary)
FROM employeex
GROUP BY dep_id
HAVING salary > 1000;

---* FIX
SELECT MAX(salary)
FROM employeex
GROUP BY salary
HAVING salary > 1000;


----* SWITCH/CASE right SYNTAX
select sum(total), typ_veh, typ_ser, sp_amt
from ser_det_table
where 'Y' = (SELECT type_veh,
                    case ---* Returns too many value
                        when typ_veh = 'TWO WHEELER'
                            then 'Y'
                        else 'FW'
                        end
             FROM ser_det_table) --------*    To fix the error  >> was returning multiple columns
group by typ_veh, typ_ser, sp_amt, total, comm
having total < 200
order by comm;


--* FIX : SWITCH /CASE
select sum(total), typ_veh, typ_ser, sp_amt
from ser_det_table
where 'Y' = (case
                 when typ_veh = 'TWO WHEELER'
                     then 'Y'
                 else 'FW'
    end ----* remove FROM here as SWITCH inside SELECT works with COMMON FROM
    ) --------*    To fix the error  >> was returning multiple columns
group by typ_veh, typ_ser, sp_amt, total, comm
having total < 200
order by comm;

--* [ "" ] vs [ AS ]
"" -->Global    = use column name with ""
AS --> Global    = use column name with out ""
--* eg
SELECT "hello"
FROM (
         SELECT dep_id "hello"
         FROM employeex);

--*
SELECT hello
FROM (
         SELECT dep_id AS hello
         FROM employeex);

--/end/-------* Set of rules *-----------* By Oracle *-------------------


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
QUOTE
OPERATORS     " "                     | ORACLE - ENGINE |
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
<| Single vs Double quotes [ Numbers ,Characters ,Symbols ] RULES |>
----* double quotes are used to assign a column name
""--* ALL ALPHABLETS(#CAPS)         [ A ]    = ( NO Quotes will be displayed in the column )
SELECT 1 "A"
FROM dual;
SELECT 1 "A"
FROM dual;---* Works even with space!

SELECT 1 "a"
FROM dual;
---* quotes will not be displayed w/o space.
---*( And value should be number )*--

SELECT '1' "a"
FROM dual;
--*quotes wil be displayed.
--*(as value is string)*--


""--* ALL SPECIAL characters    [ Å ]         = ( NO Quotes will be displayed in the column )
""--* ALL Mathematical chars    [ °, ∏ ]      = ( NO Quotes will be displayed in the column )



""--* all Symbols comes            [@,#,$]     = ( Quotes will be displayed in the column )
""--* ALL special symbols          [ , » ]    = ( Quotes will be displayed in the column )
""--* ALL numbers                              = ( Quotes will be displayed in the column )
""--* ALL right-side symbols       [ ,<,{,: ]  = ( Quotes will be displayed in the column )
-----------------------------------------*X*------------------------------------------------------

--*"" eg.1  [Double quotes with characters]
SELECT 1 "A"
FROM dual;

--*"" eg.1  [Double quotes with symbols]
SELECT 1 "Å"
FROM dual;

--*"" eg.1  [Double quotes with Mathematical Char ]
SELECT 1"∏" ,'2' "°"
FROM dual;

---* w/o space
SELECT 1 ":"
FROM dual;
--------------------------/ no ""  quotes will be displayed in the column /------------------------

----* Then when quotes will be displayed ...?
--here °°°°°°°°∏∏∏∏∏∏

--*"" eg.1  [Double quotes with Special symbols ]
SELECT 1 "@"
FROM dual;

--*"" eg.1  [Double quotes with symbols ]
SELECT 1 ""
FROM dual;

--*"" eg.1  [Double quotes with number ]
SELECT 1"1" ,1
FROM dual;

--*"" eg.1  [Double quotes with Left side Symbols.]
SELECT 1 "/"
FROM dual;

--*\ this symbol make all next line in red colour.
--SELECT 1"\" FROM dual; -> this make all next line in red color (try to run it).
--------------------------/ "" quotes will be displayed in the column /------------------------
---------------------------/ E N D - OF "" /---------------------------------------------------

--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
ORACLE
- ENGINE
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
<| Single vs Double quotes [ Numbers ,Characters ,Symbols ] RULES |>
----* Single quotes are used to assign a column value [ "'value'"]
''--* ALL characters            [ A ]         = insert value with characters + Column name [ "'A'" ]
SELECT 'A'
FROM dual;

''--* ALL SPECIAL characters    [ Å ]         = insert value with characters + Column name [ "'Å'" ]
SELECT 'Å'
FROM dual;

''--* ALL Mathematical chars    [ °, ∏ ]      = insert value with characters + Column name [ "'∏'" ]
SELECT '∏'
FROM dual;
-------------_* same till Now..

===* Multiplication of Double quotes inside single Quotes
--»»  1 " -> 2"" i.e, 2 both sides || Total 4
SELECT '"A"'
FROM dual;
--> returns COLUMN name as [ "'""A""'" ]

--»»  4 """" -> 8"""""""" i.e, 8 left sides  AND  4 Right side  || Total 12 + "''"
SELECT '""""$"'
FROM dual;
--> returns column name as   [ "'""""""""$""""'" ]
-----------* same with very character and number

===* HOW to remove "' '"  in column
SELECT 'A' "A"
FROM dual;
SELECT 1 "AÅ"
FROM dual;

---# only works with CAPITAL ( Alplabets + special Alphabets ).
SELECT 'A' "VALUE"
FROM dual; --> column w/o quotes.
SELECT '$' "value"
FROM dual;
--> column with quotes.

--* mixture of both will result in column with quotes.
SELECT '%' "AÅa"
FROM dual;
SELECT 'X' "AÅ∏"
FROM dual;


---* not works with case of (Means display double Quotes in column.)
numbers
symbols
 left_side symbols
 Special symbols
 Mathematical symbols

SELECT '1' "1"
FROM dual;
SELECT '1' "!"
FROM dual;
SELECT 1 "∏"
FROM dual;
SELECT '' "]["
FROM dual;
SELECT 9 "", '' "»"
FROM dual;
----------------------* except CAPITAL ( Alphabets + special Alphabets)  all comes under limitation.

===* Column names with spaces.
SELECT '1 '
FROM dual; ---> due to space [ "' '" ]--> Double quotes cancels out.
SELECT ' 1 '
FROM dual; ---> similar to it.

####
Special CASE remove Quotes from number column name.
SELECT 1, '1 '
FROM dual;
--- with the help of space in the last string single quotes
--> All previous columns Quotes will be removed.
SELECT 1, 1, '! '
FROM dual;

--> But in case if we assign a column after seven after giving the single space
SELECT 1, 1, '1 ' "1"
FROM dual;

SELECT 1 "'1 '"
FROM dual; --> will display the same column name.
SELECT 1 "AÅ"
FROM dual;


-----------------------------------------*X*-------------------------------------------------------------------------------------------

--* '' eg:1
SELECT ''
FROM dual; -----*                                          = "''"

SELECT '1'
FROM dual; -----* displays '"1"' as column name (STRING)   = "''"
SELECT 'A'
FROM dual;
SELECT '1' "1"
FROM dual;
SELECT 'A' "A"
FROM dual; -----* Quotes cancel's Out each other. (STRING) =

SELECT 1
FROM dual; ----* this time only double quotes displays, (NUMBER) = ""
SELECT ' "1" '
FROM dual;

SELECT '"1"'
FROM dual; --- 1 => 2 both sides
SELECT '""1""'
FROM dual; --- 2 => 4 both sides
SELECT '""""1""""'
FROM dual; --- 4 => 8 both sides
SELECT '"""""1"""'
FROM dual; --- 5 => 10 left side  AND  3 => 6 right side

SELECt 1, ' 1', '1'
FROM dual; ---* with spaces all "" gets canceled. of all columns
SELECt 1, '1', '1'
FROM dual;
SELECt 1, '1', '1'
FROM dual;

SELECT '1' AS 1
FROM dual; --*error
SELECT '1' "A"
FROM dual;
SELECT '1' "1"
FROM dual;
SELECT '1' "~1'"
FROM dual;


SELECT 1, '1 ', 1 "1"
FROM dual;
SELECT 1 "1"
FROM dual;
SELECT 1, '1 ', 1 "1"
FROM dual;

SELECT 1, 1, '1 ' "1"
FROM dual;
SELECT 1, 1, '1 ' "1", ' 1'
FROM dual;


--/end/-------* Quote - Operator *-----------* By Oracle *-------------------


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-<[REGEXP]-< EASY : TO : CODE - 2 0 0 >-
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
|
|__REGEXP_LIKE
|__REGEXP_COUNT
|__REGEXP_INSTR
|__REGEXP_SUBSTR
|__REGEXP_REPLACE

^ beginning of string

\d single digit
+ one or more occurrences of preceding

\D nondigit character
+ one or more occurrences

$
end
of string


--/end/-------* REGEXP *-----------* By Oracle *-------------------

=== * MASTER LEVEL QUERIES * === * === * === * === * ===
1---* count dep where no emp work.
SELECT B.dep_id, COUNT(A.emp_id)
FROM employeex A
         RIGHT OUTER JOIN department B ON A.dep_id = B.dep_id
GROUP BY B.dep_id
HAVING COUNT(A.emp_id) = 0;

SELECT B.dep_id, COUNT(A.emp_id)
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id --> RIGHT OUTER JOIN is necessary
GROUP BY B.dep_id
HAVING COUNT(salary) = 0; --> inside count we can use anything from first table

2---* count no. of manager
--*method :1
SELECT COUNT(emp_id)
FROM employeex
WHERE emp_id = ANY
      (SELECT manager_id FROM employeex);

--* method :2
SELECT COUNT(DISTINCT B.emp_id)
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id;

--*method :3
--*Count of null is zero
SELECT COUNT(DISTINCT B.emp_name)
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id(+);


3---* max avg sal except president
--xxxxxx-< NESTED group function >-
SELECT MAX(AVG(salary))
FROM employeex
WHERE job_name != 'PRESIDENT'
GROUP BY job_name;


4---**emp having salary greater than their manager (Failed..)
--* method1
SELECT B.*
FROM employeex A,
     employeex B
WHERE A.emp_id = B.manager_id
  AND A.salary < B.salary;

--* method2
SELECT *
FROM employeex A,
     (SELECT *
      FROM employeex
      WHERE emp_id = ANY
            (SELECT manager_id FROM employeex)) B
WHERE A.emp_id = B.manager_id --* senior managers
  AND A.salary < B.salary;

5---** Most important question.
--< null + value = null >-
--< calculate emp's whose net sal >= emp sal. >-

--*method :1
SELECT emp_name, salary, commission
FROM employeex
WHERE salary <= ANY (SELECT salary + NVL(commission, 0) FROM employeex);

--* method :1 alternative
SELECT *
FROM employeex
WHERE NVL(salary + commission, salary) >= ANY (SELECT salary FROM employeex);


--* Error
SELECT emp_name, salary, commission
FROM employeex
     --< throws an error >- as -< multiple values in column >----------
WHERE (SELECT salary + NVL(commission, 0) FROM employeex)
          >= ANY (SELECT salary FROM employeex);

--                                                                    |
--                                                                    |
--> Fix :
--<----------------------------------------------|
SELECT emp_name, salary, commission
FROM employeex
     --< Fix >- as -< pass only single value >-------
WHERE (SELECT MAX(salary + NVL(commission, 0)) FROM employeex)
          >= ANY
      (SELECT salary FROM employeex);

--*method :2
--SELECT emp_name,salary,commission ---- Not working as null +value =null
--FROM employeex A                  ---- o/p only 4 records as all other records are null
--WHERE salary+commission >= ANY ( SELECT salary FROM employeex );

SELECT emp_name, salary, commission
FROM employeex --xx --* here comparing with max value only
WHERE (SELECT MAX(salary + commission) FROM employeex) >=
          ANY (SELECT salary FROM employeex);

6--* highest paid employees >-< Works under employee 'KAYLING'
SELECT *
FROM employeex
WHERE salary = ALL
      (SELECT MAX(salary)
       FROM employeex
       WHERE manager_id = ANY (SELECT emp_id
                               FROM employeex
                               WHERE emp_name = 'KAYLING'));


7--*** highest paid emp who joined before recently joined emp of grade 2
--* -< works at PERTH >-
--* WITH clause won't work with "JOINS" when columns name not defined properly inside WITH
-- -<Fix>- Column must be defined in SELECT of WITH CLAUSE

--*master method : with joins sub query
SELECT *
FROM employeex
WHERE salary =
      (SELECT MAX(salary)
       FROM employeex A,
            department B,
            salary_grade C
       WHERE A.dep_id = B.dep_id
         AND salary BETWEEN min_sal AND max_sal
         AND dep_location = 'PERTH'
         AND hire_date < (SELECT MAX(hire_date)
                          FROM employeex
                          WHERE salary BETWEEN C.min_sal
                                    AND C.max_sal))

-- same method /but lengthy approach.
    WITH CTE AS (
    SELECT*
    FROM employeex A,
         department B

WHERE A.dep_id = B.dep_id
AND B.dep_location = 'PERTH'
)
----* with clause will throw error if column not defined
---* WHY ?.. because of alias A,B
SELECT emp_id, emp_name, job_name, manager_id, hire_date, salary
FROM CTE
WHERE (SELECT MAX(hire_date) FROM CTE) <
      (SELECT MAX(hire_date)
       FROM employeex
       WHERE salary BETWEEN (SELECT min_sal FROM salary_grade WHERE grade = 2)
                 AND (SELECT max_sal FROM salary_grade WHERE grade = 2)
      )
  AND salary = (SELECT MAX(salary) FROM CTE);


--* Master method : with sub_query
SELECT *
FROM employeex
WHERE salary = (
    SELECt MAX(salary)
    FROM employeex
    WHERE hire_date < (SELECT MAX(hire_date)
                       FROM employeex
                       WHERE salary BETWEEN (SELECT min_sal FROM salary_grade WHERE grade = 2)
                                 AND (SELECT max_sal FROM salary_grade WHERE grade = 2)
    )
      AND dep_id = (SELECT dep_id FROM department WHERE dep_location = 'PERTH')
);

8--* Recently hired emp of dep_id =3001
--* master_method
SELECT *
FROM employeex A
WHERE hire_date = (SELECT MAX(hire_date)
                   FROM employeex
                   WHERE dep_id = A.dep_id --* equi_join
                     AND A.dep_id = 3001);

--* master+ method
SELECT *
FROM employeex A
WHERE hire_date = (SELECT MAX(hire_date)
                   FROM employeex
                   WHERE dep_id = A.dep_id
                     AND dep_id = 3001); --* equi_join


9--* rem-une-ration (sal+commission) of Marketing department and salesman.
--* master method :
SELECT A.*, (A.salary + A.commission) AS remuneration
FROM employeex A
WHERE dep_id = ANY (SELECT dep_id
                    FROM department
                    WHERE dep_name = 'MARKETING'
                      AND dep_id = A.dep_id)
  AND job_name = 'SALESMAN';

--* Comparison method :
SELECT *
FROM employeex A
WHERE salary + commission = ANY (SELECT salary + commission
                                 FROM employeex A,
                                      department B
                                 WHERE B.dep_name = 'MARKETING'
                                   AND A.job_name = 'SALESMAN'
                                   AND B.dep_id = A.dep_id);


10--* find emp of dep SYDNEY or PERTH
--grade same as TUCKER
--OR experience more than SANDRINE
--* NOTE : AND operator returns value FROM single ROW
--*    BUT OR operator CAN return values FROM Multiple ROW

--* method :1 sub-query : method
SELECT *
FROM employeex
WHERE salary = ANY (SELECT salary
                    FROM employeex
                    WHERE salary BETWEEN (SELECT min_sal
                                          FROM salary_grade
                                          WHERE min_sal <= (SELECT salary
                                                            FROM employeex
                                                            WHERE emp_name = 'TUCKER')
                                            AND max_sal >= (SELECT salary
                                                            FROM employeex
                                                            WHERE emp_name = 'TUCKER')
                    )
                              AND (SELECT max_sal
                                   FROM salary_grade
                                   WHERE min_sal <= (SELECT salary
                                                     FROM employeex
                                                     WHERE emp_name = 'TUCKER')
                                     AND max_sal >= (SELECT salary
                                                     FROM employeex
                                                     WHERE emp_name = 'TUCKER'))
)
    AND dep_id = ANY (SELECT dep_id
                      FROM department
                      WHERE dep_location IN ('PERTH', 'SYDNEY'))
   OR hire_date < (SELECT hire_date FROM employeex WHERE emp_name = 'SANDRINE')


--* Joins method
SELECT *
FROM employeex A,
     department B,
     salary_grade C
WHERE A.dep_id = B.dep_id
    AND salary BETWEEN min_sal AND max_sal
    AND dep_location IN ('PERTH', 'SYDNEY')
    AND grade = (SELECT grade
                 FROM salary_grade
                 WHERE min_sal <= (SELECT salary
                                   FROM employeex
                                   WHERE emp_name = 'TUCKER')
                   AND max_sal >= (SELECT salary
                                   FROM employeex
                                   WHERE emp_name = 'TUCKER')
    )
   OR hire_date < (SELECT hire_date FROM employeex WHERE emp_name = 'SANDRINE')


--* ERROR with AND / OR operator ....?
SELECT *
FROM employeex A,
     salary_grade B,
     department C
WHERE A.dep_id = C.dep_id
    AND dep_location = 'PERTH'
   OR dep_location = 'SYDNEY' ----* not working WHY ?
    AND salary BETWEEN min_sal AND max_sal --- working because of this WHY...?
    AND grade = (SELECT grade
                 FROM salary_grade
                 WHERE min_sal <= (SELECT salary FROM employeex WHERE emp_name = 'TUCKER')
                   AND max_sal >= (SELECT salary FROM employeex WHERE emp_name = 'TUCKER')
    )
   OR SYSDATE - hire_date > (SELECT SYSDATE - hire_date FROM employeex WHERE emp_name = 'SANDRINE');


11--* emp having grade > MARKER
---* Joins method
SELECT *
FROM employeex A,
     salary_grade B
WHERE salary BETWEEN min_sal AND max_sal
  AND grade > (SELECT grade
               FROM salary_grade
               WHERE min_sal <= (SELECT salary
                                 FROM employeex
                                 WHERE emp_name = 'MARKER')
                 AND max_sal >= (SELECT salary
                                 FROM EMPLOYEEX
                                 WHERE emp_name = 'MARKER')
);


--* subquery Method
SELECT *
FROM employeex
WHERE salary >
      (SELECT MAX(salary)
       FROM employeex
       WHERE salary BETWEEN (SELECT min_sal
                             FROM salary_grade
                             WHERE min_sal <= (SELECT salary
                                               FROM employeex
                                               WHERE emp_name = 'MARKER')
                               AND max_sal >= (SELECT salary
                                               FROM employeex
                                               WHERE emp_name = 'MARKER')
       )
                 AND (SELECT max_sal
                      FROM salary_grade
                      WHERE min_sal <= (SELECT salary
                                        FROM employeex
                                        WHERE emp_name = 'MARKER')
                        AND max_sal >= (SELECT salary
                                        FROM employeex
                                        WHERE emp_name = 'MARKER'))
      );

--* mini method :
SELECT *
FROM employeex
WHERE salary > (SELECT salary
                FROM employeex
                WHERE emp_name = 'MARKER');


12--* emp working in same dep where KAYLING works
--* joins method
SELECT emp_id, emp_name, dep_location, salary, dep_name
FROM employeex A,
     department B
WHERE A.dep_id = B.dep_id
  AND A.dep_id = (SELECT dep_id
                  FROM employeex
                  WHERE emp_name = 'KAYLING')
  AND emp_name <> 'KAYLING';


--* sub-query method:
SELECT *
FROM employeex
WHERE dep_id = (SELECT dep_id
                FROM employeex
                WHERE emp_name = 'KAYLING')
  AND emp_name <> 'KAYLING';


13--* managers Senior to KAYLING and Junior to SANDRINE -< FAILED >- because of emp instead of manager
--<  very important >- question
--< Very complex as well >-

SELECT DISTINCT B.*
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
  ---* WHY ? compared with emp_hire_date and not with managers hire_date.
  --* we are comparing with every employee
  --* as we can't compare manager with itself
  --* thats why at the top We are using B.* filter
  AND A.hire_date < (SELECT B.hire_date
                     FROM employeex
                     WHERE emp_name = 'KAYLING')
  AND A.hire_date > (SELECT hire_date
                     FROM employeex
                     WHERE emp_name = 'SANDRINE')

  AND B.manager_id is NOT NULL;
--* Manager of Manager


--* master method : with sub-query
SELECT *
FROM employeex X --* why comparing from inside ?..
--* because we have to return those managers who are senior to KAYLING
--* and junior to sandrine
WHERE emp_id = ANY (SELECT manager_id
                    FROM employeex
                    WHERE X.emp_id = manager_id
                      AND (SELECT hire_date FROM employeex WHERE emp_name = 'KAYLING')
                        > hire_date
                      AND (SELECT hire_date FROM employeex WHERE emp_name = 'SANDRINE')
                        < hire_date
    --AND manager_id IS NOT NULL; --*why not working inside
    --* because its not returning null value
    --* and hire_date OF KAYLING  is not equal to anybody else's hire_date
)
  AND manager_id IS NOT NULL; ----* emp should be manager and NOT BOSS!.


14--* emp of dep 1001 and sal>ADELYN
SELECT*
FROM employeex
WHERE dep_id = 1001
  AND salary > (SELECT salary FROM employeex WHERE emp_name = 'ADELYN');


15--* emp whose job_name same as ADELYN or sal> WADE -< Failed >- because of AND instead OF OR ...
SELECT *
FROM employeex
WHERE job_name = (SELECT job_name
                  FROM employeex
                  WHERE emp_name = 'ADELYN')
   OR salary > (SELECT salary
                FROM employeex
                WHERE emp_name = 'WADE');

16--* emp of grade 2 OR 3 AND dep_location ='PERTH'
--* Joins method
SELECT *
FROM employeex A,
     department B,
     salary_grade C
WHERE A.dep_id = B.dep_id
  AND dep_location = 'PERTH'
  AND salary BETWEEN min_sal AND max_sal
  AND grade IN (2, 3);


--* sub query method
SELECT *
FROM employeex A
WHERE dep_id = (SELECT dep_id
                FROM department
                WHERE dep_location = 'PERTH'
                  AND A.dep_id = dep_id)
  AND salary BETWEEN (SELECT min_sal
                      FROM salary_grade
                      WHERE grade = 2)
    AND (SELECT max_sal FROM salary_grade WHERE grade = 3);


17--* 5th highest department SUM(salary)
----* under development
SELECT department_id,
       DENSE_RANK() OVER (ORDER BY sum_sal DESC) A
FROM employees A,
     (SELECT SUM(salary) AS sum_sal
      FROM employees
      GROUP BY department_id) B;


--* ultra method :
WITH CTE AS
         (SELECT department_id, SUM(salary) AS X
          FROM employees
          GROUP BY department_id
          ORDER BY X DESC)
SELECT department_id, X
FROM CTE E1
WHERE 5 = (SELECT COUNT(X)
           FROM CTE E2
           WHERE E1.X <= E2.X);


---* Master Method
SELECT*
FROM (
         WITH CTE AS (
             SELECT department_id, SUM(salary) sum_sal
             FROM employees A
             GROUP BY department_id
             ORDER BY sum_sal DESC)
         SELECT *
         FROM CTE
         WHERE ROWNUM <= 5
         ORDER BY CTE.sum_sal)
WHERE ROWNUM = 1;


18--* Unique Dep of the employees
SELECT *
FROM department
WHERE dep_id = ANY (SELECT dep_id FROM employeex);

--* RIGHT join // all dep
SELECT DISTINCT B.*
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id;

--*LEFT join // only working dep
SELECT DISTINCT B.*
FROM employeex A,
     department B
WHERE A.dep_id = B.dep_id(+);


19--* dep whose avg_sal < avg of all dep.
----* confusing.. -< FAILED >-
--* only possible with HAVING clause.
--* AS Functions won't work with WHERE clause

WITH CTE AS
         (
             SELECT FLOOR(AVG(salary)) AS avg_x, B.dep_id
             FROM employeex A,
                  department B
             WHERE A.dep_id(+) = B.dep_id
             GROUP BY B.dep_id
         )
SELECT avg_x, dep_id
FROM CTE
WHERE avg_x < (SELECT AVG(salary)
               FROM employeex);

--*another method:
SELECT dep_id, avg(salary)
FROM employeex
GROUP BY dep_id
HAVING AVG(salary) < (SELECT AVG(salary) FROM employeex);


20--* emp who earns commission and 2nd highest remuneration
--*method :1                                                 --xxx---------double quotes for ALIAS else not work
SELECT dep_id, emp_name, emp_id, salary, (salary + commission) "NET SAL"
FROM employeex E1
WHERE (2 - 1) = (SELECT COUNT(DISTINCT salary + commission)
                 FROM employeex E2
                 WHERE E2.salary + E2.commission > E1.salary + E1.commission)
  AND commission is NOT NULL;
----* in N-1 ==> E2 >E1
-----....Why working with null values (because of no '>=' or '<=')?
---* comparison of null with itself is null

--*method :2
SELECT emp_id, emp_name, dep_id, salary, (salary + commission)
FROM employeex E1
WHERE 2 = (SELECT COUNT(DISTINCT salary + commission)
           FROM EMPLOYEEX E2
           WHERE E1.salary + E1.commission <= E2.salary + E2.commission)
  AND commission IS NOT NULL;
-----xxxxxxxxxxxxxxxxxxx----- Not going to work w/o this
-----* in Nth ==> E1 < E2

--*method :3
WITH CTE AS
         (
             SELECT A.*, DENSE_RANK() OVER ( ORDER BY salary + commission DESC ) AS RN
             FROM employeex A
             WHERE commission IS NOT NULL)
SELECt *
FROM CTE
WHERE RN = 2;


21:--* 1st highest remuneration as well as commission
--*method :1
SELECT *
FROM employeex E1
WHERE 1 = (SELECT COUNT(DISTINCT salary + commission)
           FROM employeex E2
           WHERE E1.salary + E1.commission <= E2.salary + E2.commission)
  AND commission IS NOT NULL;

--*method :1X
SELECT*
FROM employeex E1
WHERE 0 = (SELECT COUNT(DISTINCT salary + commission)
           FROM employeex E2
           WHERE E1.salary + E1.commission < E2.salary + E2.commission)
  AND commission IS NOT NULL;


--*method :2
SELECT emp_id, emp_name, salary, (salary + commission) "Net"
FROM employeex
WHERE salary + commission = (SELECT MAX(salary + commission) FROM employeex);

--*method :3
WITH CTE AS
         (SELECT A.*, DENSE_RANK() OVER (ORDER BY salary + commission DESC) AS RN
          FROM employeex A
          WHERE COMMISSION is NOT NULL)
SELECT *
FROM CTE
WHERE RN = 1;

--* simplest method :
SELECT *
FROM employeex
WHERE (salary + commission, commission) =
      (SELECT MAX(salary + commission), MAX(Commission)
       FROM employeex
       WHERE commission is NOT NULL);


22--* Display the order 1,2,3,1a,2a,3a
-- AS 1,1a,2,2a,3,3a
WITH CTE AS (
    SELECT A.*,
           ROW_NUMBER() OVER (ORDER BY A.val)   AS RN,
           ROW_NUMBER() OVER (ORDER BY ROWNUM ) AS RN1
    FROM A_emp A)
SELECT B.val, A.val
FROM CTE A
         INNER JOIN CTE B ON A.RN = B.RN1;


---*alternative sol^n
WITH CTE AS (
    SELECT A.*,
           ROW_NUMBER() OVER (ORDER BY ROWNUM ) AS RN, ROW_NUMBER() OVER (ORDER BY A.val)   AS RN1
    FROM A_emp A)
SELECT A.val, B.val
FROM CTE B,
     CTE A
WHERE B.RN1 = A.RN;

---*More alternative Sol^n
WITH CTE AS
         (SELECT val, ROW_NUMBER() OVER (ORDER BY ROWNUM) AS RN
          FROM A_EMP),
     CTE1 AS
         (SELECT val, ROW_NUMBER() OVER (ORDER BY val) AS RN
          FROM A_EMP)
SELECT CTE.val, CTE1.val
FROM CTE,
     CTE1
WHERE CTE.RN = CTE1.RN;


--* with dense_rank()
WITH CTE AS
         (SELECT val, DENSE_RANK() OVER (ORDER BY ROWNUM) AS RN
          FROM A_EMP),
     CTE1 AS
         (SELECT val, DENSE_RANK() OVER (ORDER BY val) AS RN
          FROM A_EMP)
SELECT CTE.val, CTE1.val
FROM CTE,
     CTE1
WHERE CTE.RN = CTE1.RN;


----* w/o Windows Or Aggrigate function:
SELECT B.val, A.val
FROM (SELECT (CASE
                  WHEN R <> ROWNUM THEN ROWNUM
                  ELSE R
    END) R1,
             val
      FROM (
               SELECT ROWNUM R, val
               FROM A_emp
               ORDER BY val)) A
         FULL OUTER JOIN
         (SELECT ROWNUM R, val FROM A_emp) B
         ON A.R1 = B.R;


23--* manager_id IN ASC || department_id IN DESC
WITH CTE AS (
    SELECT Employee_id, first_name, ROW_NUMBER() OVER ( ORDER BY employee_id) AS RN
    FROM (SELECT *
          FROM employees A
          WHERE employee_id = ANY (SELECT manager_id
                                   FROM employees
                                   WHERE A.employee_id = manager_id))
),
     CTE1 AS
         (SELECT DISTINCT department_id, DENSE_RANK() OVER (ORDER BY department_id DESC) RN
          FROM employees)
SELECT A.employee_id, A.first_name, B.Department_id
FROM CTE A,
     CTE1 B
WHERE A.RN = B.RN;


24--** emp who receive sal> avg of their (dep)
--most important question
--*method :1 with clause ,auto comparison with department.
WITH CTE AS (
    SELECT emp_name,
           emp_id,
           salary,
           dep_id,
           AVG(salary) OVER (PARTITION BY dep_id) AS avg_x
    FROM employeex
)
SELECT *
FROM CTE
WHERE salary > avg_x;


--*method :2
SELECT *
FROM employeex A
WHERE salary > (SELECT AVG(salary)
                FROM employeex
                WHERE A.dep_id = dep_id) ----** Working as filter of grouping
ORDER BY dep_id;

--**method :3 Beautiful  method  -< Practice req. >-
SELECT *
FROM employeex,
     (SELECT AVG(salary) X, dep_id Y
      FROM employeex
      GROUP BY dep_id)
WHERE Y = dep_id
  AND salary > X;
--* alias plays really important role.
--* FROM employeex ,( avg(sal) X ,dep_id Y  )
--* we can directly call X and Y in SELECT query.


--*same method with alias explanation
SELECT *
FROM employeex A,
     (SELECT AVG(dep_id) X, dep_id Y
      FROM employeex
      GROUP BY dep_id) B
WHERE B.Y = A.dep_id
  AND A.salary > B.X;


25--*emp with Max hire_date / department.
--*method :1 multiple column
SELECT *
FROM employeex A
WHERE (hire_date, dep_id) = (SELECT MAX(hire_date), dep_id
                             FROM employeeX
                             WHERE A.dep_id = dep_id
                             GROUP BY dep_id);


26--* max(sal) per designation
SELECT *
FROM employeex A
WHERE (salary, job_name) = (SELECT MAX(salary), job_name
                            FROM employeex
                            WHERE A.job_name = job_name
                            GROUP BY job_name);

---* Error : WHY ony 5 records ?
SELECt job_name, MAX(salary)
FROM employeex
GROUP BY job_name;
--* ANSWER : having similar records with salary 3100
--* Fix:
SELECt *
FROM employeex
WHERE salary = ANY (SELECT MAX(salary)
                    FROM employeex
                    GROUP BY job_name);


27--* min(sal) per designation in ASC
SELECT *
FROM employeex A
WHERE (salary, job_name) = (SELECT MIN(salary), job_name
                            FROM employeex
                            WHERE A.job_name = job_name
                            GROUP BY job_name);


28--** list of emp of manager 'JONAS' and JONAS's manager
--< important question>- -< representation part >-
---* method 1 : with presentation -< Practice req. >-
SELECT A.emp_name,
       B.emp_name                                                      "MANAGER OF emp",
       (SELECT emp_name FROM employeex WHERE emp_id = B.manager_id) AS "JONAS's MANAGER"
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
  AND B.emp_name = 'JONAS';

---* method 1X : with presentation -< Practice req. >-
SELECT A.emp_name,
       B.emp_name AS "Manager of Emp",
       C.emp_name AS "Manager of JONAS"
FROM employeex A,
     employeex B,
     employeex C
WHERE A.manager_id = B.emp_id
  AND B.emp_name = 'JONAS'
  AND B.manager_id = C.emp_id;


29--*FROM TABLE A , Add 2 where no=0 AND 3 WHERE no=1
SELECT DECODE(AC, 0, AC + 2, 1, AC + 3, AC), AC
FROM A;


30--* dep_id where No emp's WORKING USING SWITCH /CASE
----* WHY this code is not working ?.....
SELECT D1.count, E1.*
FROM employeex E1,
     (SELECT D.dep_id, COUNT(E.emp_id) "count"
      FROM employeex E,
           department D
      WHERE D.dep_id = E.dep_id(+)
      GROUP BY D.dep_id) D1
WHERE E1.dep_id(+) = D1.dep_id
  AND E1.emp_id IN (CASE
                        WHEN count > 0 THEN E1.emp_id
                        ELSE null
    END);

--* ANSWER "count" --> replace it with [ AS count ]
SELECT D1.*, E1.*
FROM employeex E1,
     (SELECT D.dep_id, COUNT(E.emp_id) AS count
      FROM employeex E,
          department D
      WHERE D.dep_id = E.dep_id(+)
      GROUP BY D.dep_id) D1
WHERE D1.dep_id = E1.dep_id(+)
  AND D1.dep_id = (CASE
                       WHEN D1.count = 0 THEN D1.dep_id
                       ELSE null
    END);

---* OR use "count"
SELECT D1."count", E1.*
FROM employeex E1,
     (SELECT D.dep_id, COUNT(E.emp_id) "count"
      FROM employeex E,
           department D
      WHERE D.dep_id = E.dep_id(+)
      GROUP BY D.dep_id) D1
WHERE E1.dep_id(+) = D1.dep_id
  AND E1.emp_id IN (CASE
                        WHEN "count" > 0 THEN E1.emp_id
                        ELSE null
    END);


31--*manager sal < thier emp
--* method :1
--*< most important question >*-
SELECT B.*
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
  AND A.salary > B.salary;

--* method :2
SELECT B.*
FROM employeex A,
     (SELECT *
      FROM employeex
      WHERE emp_id
                = ANY (SELECT manager_id FROM employeex)) B

WHERE A.manager_id = B.emp_id
  AND A.salary > B.salary;


--* master method
SELECT *
FROM employeex A
WHERE salary < ANY (SELECT salary
                    FROM employeex
                    WHERE A.emp_id = manager_id);


---* Why not working in opposite way ?
---* as not comparing with his own employees
SELECT *
FROM employeex A --* employees
WHERE salary > (SELECT salary
                FROM employeex --* managers
                WHERE A.manager_id = emp_id);
---* FRANK and SCARLET are employees Of JONAS and all are managers
--* it becomes employees having higher salary than their manager.
--* and those employees are managers as well.


32--* managers having maximum employees
--*method :1
SELECT B.emp_name, COUNT(A.emp_id)
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
GROUP BY B.emp_name
HAVING COUNT(A.emp_id) = (SELECT MAX(COUNT(A.emp_id))
                          FROM employeex A,
                               employeex B
                          WHERE A.manager_id = B.emp_id
                          GROUP BY B.emp_name);
--*method :2
WITH CTE AS
         (SELECT B.emp_name, COUNT(A.emp_name) AS counter
          FROM employeex A,
               employeex B
          WHERE A.manager_id = B.emp_id
          GROUP BY B.emp_name)
SELECT emp_name, counter
FROM CTE
WHERE counter = (SELECT MAX(counter) FROM CTE);

----* WITH clause error :
WITH CTE AS ----xxxxx---Not accepted by WITH clause
         (SELECT B.emp_name, COUNT(A.emp_name) AS "counter"
          FROM employeex A,
               employeex B
          WHERE A.manager_id = B.emp_id
          GROUP BY B.emp_name)

SELECT emp_name, counter
FROM CTE
WHERE counter = (SELECT MAX(counter) FROM CTE);
--*NOTE :always use alias w/o quotes with --> WITH clause


--* Ultimate Method:
SELECT B.emp_name, COUNT(A.emp_id)
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
GROUP BY B.emp_name
HAVING COUNT(A.emp_id) = (SELECT MAX(count(A.emp_id))
                          FROM employeex
                          GROUP BY manager_id);


33--* dep where > avg(COUNT (emp) ) works.Return department name
SELECT dep_name
FROM department A,
     employeex B
WHERE A.dep_id = B.dep_id
GROUP BY dep_name
HAVING COUNT(emp_id) >
       (SELECT AVG(COUNT(emp_id))
        FROM employeex
        GROUP BY dep_id);

--* alter native method :
SELECT dep_name
FROM department D,
     (SELECT emp_id, dep_id FROM employeex) A
WHERE D.dep_id = A.dep_id
GROUP BY dep_name
HAVING COUNT(A.emp_id) > (SELECT AVG(COUNT(A.emp_id))
                          FROM employeex
                          GROUP BY dep_id);


34--*same hire date  --< Tricky >-
--*method: 1
SELECT *
FROM employeex A
WHERE hire_date = (SELECT hire_date
                   FROM employeex
                   GROUP BY hire_date
                   HAVING COUNT(*) > 1);


--*method:2 master method
SELECT *
FROM employeex A
WHERE hire_date = ANY (SELECT hire_date
                       FROM employeex
                       WHERE A.emp_id <> emp_id);


35--* department having max emp.
SELECT*
FROM department
WHERE dep_id IN
      (
          SELECT dep_id
          FROM employeex
          GROUP BY dep_id
          HAVING COUNT(emp_id) = (SELECT MAX(COUNT(emp_id))
                                  FROM employeex
                                  GROUP BY dep_id));


--* comparison Method
SELECT dep_name, dep_id, dep_location
FROM department A
GROUP BY dep_name, dep_id, dep_location
HAVING dep_name = (SELECT dep_name
                   FROM employeex
                   WHERE A.dep_id = dep_id
                   GROUP BY dep_id
                   HAVING COUNT(emp_id) = (SELECT MAX(COUNT(emp_id))
                                           FROM employeex
                                           GROUP BY dep_id));


36--*no of employees = character in dep_name
--* method :1
--* master method          ---*xxxxx*---- This COUNT( * ) is counting all rows in the table after jon
SELECT D.dep_id, D.dep_name, COUNT(*)
FROM department D,
     employeex E
WHERE D.dep_id = E.dep_id
GROUP BY D.dep_id, D.dep_name
HAVING COUNT(*) = LENGTH(D.dep_name);

---------------------------COUNT( * )--------------------------
---* COUNT(*) explanation
SELECT COUNT(*)
FROM employeex;
--O/P : 14     -->i.e, ROWS

SELECT COUNT(*)
FROM employeex E,
     department D;
--O/P : 56     -->i.e, ROWS

SELECT D.dep_id, COUNT(*)
FROM employeex E,
     department D
WHERE E.dep_id = D.dep_id
GROUP BY D.dep_id;
--O/P : 14     -->i.e, ROWS

---* it wil display only 3 Rows
SELECT D.dep_name, D.dep_id
FROM employeex E,
     department D
WHERE D.dep_id = E.dep_id
GROUP BY D.dep_id, D.dep_name;

---* But in background there are 14 Rows WHY ?.. because od alias
SELECT D.dep_name, D.dep_id, COUNT(*)
FROM employeex E,
     department D
WHERE D.dep_id = E.dep_id
GROUP BY D.dep_id, D.dep_name;
---*here count is representing all rows Doesn't matter if u use D.dep_id inside it
--* it will still shows 14 count in the group OF 3
SELECT D.dep_name, D.dep_id, COUNT(D.dep_id)
FROM employeex E,
     department D
WHERE D.dep_id = E.dep_id
GROUP BY D.dep_id, D.dep_name;


---------------------------COUNT( * )--------------------------

--*method :2 master method : X
SELECT *
FROM department D
WHERE LENGTH(dep_name) = (SELECT COUNT(D.dep_id)
                          FROM employeex
                          WHERE dep_id = D.dep_id);
-----------------------------------------*equi join
--------------*       working here as GROUP BY
--------------------------/ Equi Join /-----------------------------
SELECT *
FROM department A,
     employeex B
WHERE A.dep_id = B.dep_id
  AND B.salary = (SELECT MAX(salary)
                  FROM employeex
                  WHERE B.dep_id = dep_id);

---------------------------/ Vs /---------------------------------

SELECT *
FROM department A,
     employeex B
WHERE A.dep_id = B.dep_id
  AND B.salary = ANY (SELECT MAX(salary)
                      FROM employeex
                      GROUP BY dep_id);

--------------------/ G R O U P - B Y /----------------------------

--*method :2 master method : Y
SELECT dep_name
FROM department
WHERE LENGTH(dep_name) = ANY (SELECT COUNT(emp_id)
                              FROM employeex
                              GROUP BY dep_id);

------*( A.Manager(salary)<B.Manager(salary) )*-----
SELECT *
FROM employeey A,
     employeey B
WHERE A.manager_id = B.manager_id;

|--MGR_ID--|--Salary--|A|
   66928   | 1350.000 |  --* it will compare all lower salaries WITH highest
   66928   | 1600.000 |  --*1350<1600 (true)= 1350 (MADDEN) = display
   66928   | 1050.000 |  --*1050<1600 (true)= 1050 (JULIUS) = display
   66928   | 1350.000 |  --*1600<1600 (false)
   66928   | 1600.000 |  --*1350<1350 (false)
   66928   | 1050.000 |  --*1050<1050 (false)
----------------------|
   67858   | 1200.000 |  --*1200<1200 (false)
----------------------|
   66928   | 1350.000 | --*1350<1600 (true)= 1350 (MADDEN) = display
   66928   | 1600.000 | --*1050<1600 (true)= 1050 (JULIUS) = display
   66928   | 1050.000 | --* rest will be false like above.
----------------------|
   67832   | 1400.000 | --*1400<1400 (false)
-----------------------


----* important Question
SELECT *
FROM employeey A
WHERE salary < ANY (SELECT salary
                    FROM employeey
                    WHERE manager_id = A.manager_id);

------*( A.dep_id(salary)<B.dep_id(salary) )*-----
SELECT *
FROM employeey A,
     employeey B
WHERE A.dep_id = B.dep_id;

|--DEP_ID--|--Salary--|A|
   3001    | 1350.000 |  --* it will compare all lower salaries WITH highest
   3001    | 1600.000 |  --*1350<1600 (true)= 1350 (MADDEN) = display
   3001    | 1050.000 |  --*1050<1600 (true)= 1050 (JULIUS) = display
   3001    | 1350.000 |  --*1600<1600 (false)
   3001    | 1600.000 |  --*1350<1350 (false)
   3001    | 1050.000 |  --*1050<1050 (false)
----------------------|
   2001    | 12000.000 |  --*1200<1200 (false)
----------------------|
   3001    | 1350.000 | --*1350<1600 (true)= 1350 (MADDEN) = display
   3001    | 1600.000 | --*1050<1600 (true)= 1050 (JULIUS) = display
   3001    | 1050.000 | --* rest will be false like above.
----------------------|
   1001    | 1400.000 | --*1400<1400 (false)
-----------------------
----* important Question
SELECT *
FROM employeey A
WHERE salary < ANY (SELECT salary
                    FROM employeey
                    WHERE dep_id = A.dep_id);
-----* ( E N D ) *-------------------------------------*

--*method :3 ultimate method
WITH CTE AS
         (SELECT dep_name, LENGTH(dep_name) X, COUNT(emp_id) Y
          FROM department A,
               employeex B
          WHERE A.dep_id = B.dep_id
          GROUP BY dep_name)
SELECT dep_name
FROM CTE
WHERE X = Y;

37--* remuneration VS emp salary using SUM. -<FAILED>-
-- Return employee name, salary, and commission.
-- question unable to understand.
SELECT emp_name,
       salary,
       commission,
       (SELECT SUM(salary + NVL(commission, 0)) FROM employeex) "NET"
FROM employeex A
WHERE (SELECT SUM(salary + NVL(commission, 0)) FROM employeex)
          > ANY (SELECT salary
                 FROM employeex
                 WHERE A.emp_id = emp_id);


38--* mangers WHO are not working Under 'PRESIDENT'
SELECT B.*
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
  AND B.manager_id <> (SELECT emp_id
                       FROM employeex
                       WHERE job_name = 'PRESIDENT');

39--* 5 lowest paid workers.
--< Very important >--
--* method :1
SELECT*
FROM employeex E1
WHERE 4 >= (SELECT COUNT(DISTINCT salary)
            FROM employeex E2
            WHERE E1.salary >= E2.salary);

--* method :2  --- more accurate method
SELECT*
FROM employeex E1
WHERE 4 > (SELECT COUNT(DISTINCT salary)
           FROM employeex E2
           WHERE E1.salary > E2.salary);

--* method :3
WITH CTE AS (
    SELECT A.*, DENSE_RANK() OVER (ORDER BY salary ASC) AS RN
    FROM employeex A
)
SELECT*
FROM CTE
WHERE RN < 5;

--* method :4 master method
SELECT *
FROM employeex A
WHERE 5 > (SELECT COUNT(*)
           FROM employeex
           WHERE A.salary > salary);


40--*compute dep_wise AVG(salary)
-- Return employee name, average salary,
-- department ID as "Current Salary".
--* method :1
WITH CTE AS
         (SELECT AVG(salary) AS avg_sal, dep_id
          FROM employeex
          GROUP BY dep_id)
SELECT emp_name, avg_sal, CTE.dep_id "Current Salary"
FROM CTE,
     employeex B
WHERE CTE.dep_id = B.dep_id;


--method :2
SELECT emp_name, AVG(salary) OVER (PARTITION BY dep_id) AS RN, dep_id "Current Salary"
FROM employeex;

--master method: 3
SELECT A.emp_name,
       X.avgsal,
       A.dep_id "Current Salary"
FROM employeex A,
     (SELECT AVG(salary) AS avgsal, dep_id
      FROM employeex
      GROUP BY dep_id) X
WHERE A.dep_id = X.dep_id;


41--** emp having sal< his manager || but emp>sal of any other manager.
--< very important question >--
SELECT *
FROM employeex A,
     employeex B
WHERE A.manager_id = B.emp_id
  AND A.salary < B.salary
  AND A.salary > ANY (SELECT salary
                      FROM employeex
                      WHERE emp_id = ANY (SELECT manager_id FROM employeex));


--* master method :
SELECT DISTINCT X.emp_id,   ----*connected with A.emp_id
                X.emp_name, ----*connected with A.emp_name
                X.salary    ----*connected with A.salary
FROM (SELECT A.emp_id,
             A.emp_name,
             A.salary
      FROM employeex A,
           employeex B
      WHERE A.manager_id = B.emp_id
        AND A.salary < B.salary) X,
     (SELECT *
      FROM employeex
      WHERE emp_id = ANY (SELECT manager_id FROM employeex)) Y
WHERE X.salary > Y.salary;
-----xxxx--- X.salary is connected with A.salary

--* master method :
SELECT *
FROM employeex A
WHERE salary < ANY (SELECT salary
                    FROM employeex
                    WHERE A.manager_id = emp_id)
  AND salary > ANY (SELECT salary
                    FROM employeex
                    WHERE emp_id = ANY (SELECT manager_id FROM employeex));


42--* Managers sal > AVG(emp_sal)
SELECT DISTINCT X.emp_id,
                X.emp_name,
                X.salary ---manager's data
FROM (SELECT B.emp_id,
             B.emp_name,
             B.salary
      FROM employeex A,
           employeex B
      WHERE A.manager_id = B.emp_id) X, -- X =Managers
     (SELECT AVG(salary) AS avg_sal, manager_id
      FROM employeex
      GROUP BY manager_id) Y            ---* avg(emp_sal ) /managers
WHERE X.salary > Y.avg_sal
  AND X.emp_id = Y.manager_id;

--* master method
SELECT *
FROM employeex A
WHERE emp_id = ANY (SELECT manager_id FROM employeex)
  AND salary > (SELECT AVG(salary)
                FROM employeex
                WHERE A.emp_id = manager_id);

43--* emp_sal >= AVG(MAX & MIN )
SELECT *
FROM employeex
WHERE salary >= (SELECT AVG(MAX(salary) + MIN(salary))
                 FROM employeex
                 GROUP BY salary);

--* another method
SELECT *
FROM employeex
WHERE salary >=
      (SELECT (max(salary) + min(salary)) / 2
       FROM employeex);

44--* emp who receive highest sal /dep
SELECT *
FROM employeex A
WHERE salary = (SELECT MAX(salary)
                FROM employeex
                WHERE A.dep_id = dep_id);

45--* managers.Return employee name, job name, department name, and location
--* master method
SELECT DISTINCT B.emp_name, B.job_name, dep_name, dep_location
FROM employeex A,
     employeex B,
     department C
WHERE A.manager_id = B.emp_id
  AND B.dep_id = C.dep_id;

--* another method
SELECT emp_name, job_name, dep_name, dep_location
FROM employeex A,
     department B
WHERE A.dep_id = B.dep_id
  AND emp_id = ANY (SELECT manager_id FROM employeex);


46--* emp not working in 'MARKETING' dep.
SELECT *
FROM employeex
WHERE dep_id != (SELECT dep_id
                 FROM department
                 WHERE dep_name = 'MARKETING');


47--* emp whose manager is JONAS.
SELECT *
FROM employeex
WHERE manager_id = (SELECT emp_id
                    FROM employeex
                    WHERE emp_name = 'JONAS');


48--* dep WHERE max no of emp works.
-- Return department ID, department name, location and number of employees
SELECT dep_id,
       dep_name,
       dep_location,
       (SELECT MAX(COUNT(emp_id))
        FROM employeex
        WHERE dep_id = Y.dep_id
        GROUP BY dep_id) AS count
FROM department Y
WHERE Y.dep_id = (SELECT dep_id
    FROM employeex
    GROUP BY dep_id
    HAVING COUNT (emp_id) = (SELECT MAX (COUNT (emp_id))
    FROM employeex
    GROUP BY dep_id)
    );

--*master method
SELECT B.dep_id,
       COUNT(*)
FROM employeex A,
     department B
WHERE A.dep_id = B.dep_id
GROUP BY B.dep_id
HAVING COUNT(*) = (SELECT MAX(mycount)
                   FROM (SELECT COUNT(*) AS mycount
                         FROM employeex
                         GROUP BY dep_id));

50--* emp od dep=1001 salary>avg(sal) of dep 2001
SELECT *
FROM employeex
WHERE dep_id = 1001
  AND salary > (SELECT AVG(salary)
                FROM employeex
                WHERE dep_id = 2001);

51--* Total sal of emp of grade =3.
SELECT A.*,
       (SELECT SUM(salary)
        FROM employeex
        WHERE salary BETWEEN B.min_sal AND B.max_sal) "Total"
FROM employeex A,
     salary_grade B
WHERE salary BETWEEN min_sal AND MAX_SAL
  AND grade = 3;

--* another method
SELECT SUM(salary)
FROM employeex
WHERE emp_id = ANY (SELECT emp_id
                    FROM employeex A,
                         salary_grade B
                    WHERE salary BETWEEN min_sal AND max_sal
                      AND grade = 3);

51--* total salary of job_name ='MANAGER'
SELECT SUM(salary)
FROM employeex
WHERE job_name = 'MANAGER';


52--*most senior emp of grade=4 /5 works under 'KAYLING'.
--* master method
SELECT *
FROM employeex A,
     salary_grade B
WHERE salary BETWEEN min_sal AND max_sal
  AND grade IN (4, 5)
  AND hire_date = (SELECT MIN(hire_date)
                   FROM employeex
                   WHERE manager_id = (SELECT emp_id
                                       FROM employeex
                                       WHERE emp_name = 'KAYLING'));

--* ultimate method
SELECT*
FROM employeex
WHERE hire_date = (SELECT MIN(hire_date)
                   FROM employeex A,
                        salary_grade B
                   WHERE salary BETWEEN min_sal AND max_sal
                     AND grade = ANY (4, 5)
)
  AND manager_id = (SELECT emp_id
                    FROM employeex
                    WHERE emp_name = 'KAYLING');

53--*emp's who joined in 1991
-- WHERE job_name=job_name of most senior person of 1991
SELECT *
FROM employeex
WHERE job_name = (SELECT job_name
                  FROM employeex
                  WHERE hire_date = (SELECT MIN(hire_date)
                                     FROM employeex
                                     WHERE TO_CHAR(hire_date, 'YYYY') = 1991)
);

54--* Senior emp of year 1991
SELECT*
FROM employeex
WHERE hire_date = (SELECT MIN(hire_date)
                   FROM employeex
                   WHERE TO_CHAR(hire_date, 'YYYY') = 1991);


55--* emp of grade 3->5
-- location 'SYDNEY'
--job_name <> 'PRESIDENT'
--emp_sal> MAX(sal) of 'PERTH' where no SALESMAN & MANAGER
-- Works under KAYLING -< means SALESMAN and MANAGER having no manager_id of KAYLING

SELECT *
FROM employeex A,
     department B,
     salary_grade C
WHERE salary BETWEEN min_sal AND max_sal
  AND grade = ANY (3, 4, 5)
  AND A.dep_id = B.dep_id
  AND dep_location = 'SYDNEY'
  AND job_name <> 'PRESIDENT'
  AND salary > (SELECT MAX(salary)
                FROM employeex A,
                     department B
                WHERE A.dep_id = B.dep_id
                  AND dep_location = 'PERTH'
                  AND manager_id
    != (SELECT emp_id
    FROM employeex
    WHERE emp_name = 'KAYLING')
  AND job_name = ANY ('SALESMAN'
    , 'MANAGER')
    );

--* master method
SELECT *
FROM employeex
WHERE dep_id = (SELECT dep_id
                FROM department
                WHERE dep_location = 'SYDNEY')
  AND salary = ANY (SELECT salary
                    FROM employeex A,
                         salary_grade B
                    WHERE salary BETWEEN min_sal AND max_sal
                      AND grade IN (3, 4, 5)
)
  AND job_name != 'PRESIDENT'
  AND salary > (SELECT MAX(salary)
                FROM employeex
                WHERE job_name IN ('MANAGER', 'SALESMAN')
                  AND dep_id = (SELECT dep_id
                                FROM department
                                WHERE dep_location = 'PERTH'
                )
                  AND manager_id != (SELECT emp_id
                                     FROM employeex
                                     WHERE emp_name = 'KAYLING')
);

--* w/o Join method
--* only subquery method
SELECT *
FROM employeex A
WHERE emp_id = ANY (SELECT emp_id
                    FROM employeex
                    WHERE salary BETWEEN (SELECT min_sal FROM salary_grade WHERE grade = 3)
                              AND (SELECT max_sal FROM salary_grade WHERE grade = 5)
)
  AND dep_id = (SELECT dep_id
                FROM department
                WHERE dep_location = 'SYDNEY')
  AND job_name <> 'PRESIDENT'
  AND salary > (SELECT MAX(salary)
                FROM employeex
                WHERE dep_id = (SELECT dep_id
                                FROM department
                                WHERE dep_location = 'PERTH')
                  AND job_name IN ('SALESMAN', 'MANAGER')
                  AND manager_id
    != (SELECT emp_id
    FROM employeex
    WHERE emp_name = 'KAYLING'));


56--* emp senior to recently hired emp works under KAYLING
SELECT *
FROM employeex
WHERE hire_date < (SELECT MAX(hire_date)
                   FROM employeex
                   WHERE manager_id = (SELECT emp_id
                                       FROM employeex
                                       WHERE emp_name = 'KAYLING'));


---* +1 Senior to recently hired emp Of KAYLING
WITH CTE AS
         (SELECT *
          FROM employeex
          WHERE hire_date < (SELECT MAX(hire_date)
                             FROM employeex
                             WHERE manager_id = (SELECT emp_id
                                                 FROM employeex
                                                 WHERE emp_name = 'KAYLING'))
         )
SELECT *
FROM CTE
WHERE hire_date = (SELECT MAX(hire_date) FROM CTE);


57--* emp of grade #3 Who joined recently
-- And dep_location PERTH
SELECT *
FROM employeex
WHERE hire_date = (SELECT MAX(hire_date)
                   FROM employeex A,
                        salary_grade B
                   WHERE salary BETWEEN min_sal AND max_sal
                     AND grade = 3)
  AND dep_id = (SELECT dep_id
                FROM department
                WHERE dep_location = 'PERTH');

--* master method
SELECT*
FROM employeex
WHERE hire_date = (SELECT MAX(hire_date)
                   FROM employeex
                   WHERE salary BETWEEN (SELECT min_sal FROM salary_grade WHERE grade = 3)
                             AND (SELECT max_sal FROM salary_grade WHERE grade = 3))

  AND dep_id = (SELECT dep_id
                FROM department
                WHERE dep_location = 'PERTH');


58--* Highest Paid emp of dep_name ='MARKETING'
SELECT *
FROM employeex
WHERE salary = (SELECT MAX(salary)
                FROM employeex
                WHERE dep_id = (SELECT dep_id
                                FROM department
                                WHERE dep_name = 'MARKETING')
);

59--* Highest paid emp
SELECT*
FROM employeex
WHERE salary = (SELECT MAX(salary) FROM employeex);


60--*( job_name of dep_id =1001 ) NOT IN ( job_name OF dep_id=2001 )
SELECT job_name
FROM employeex
WHERE dep_id = 1001
  AND job_name
    NOT IN (SELECT job_name
            FROM employeex
            WHERE dep_id = 2001);


61--*emp with same job_name AS'SANDRINE' OR 'ADELYN'
SELECT*
FROM employeex
WHERE job_name = (SELECT job_name
                  FROM employeex
                  WHERE emp_name = 'SANDRINE')
   OR job_name = (SELECT job_name
                  FROM employeex
                  WHERE emp_name = 'ADELYN');

--* master method
SELECT *
FROM employeex
WHERE job_name = ANY (SELECT job_name
                      FROM employeex
                      WHERE emp_name IN ('SANDRINE', 'ADELYN'))
    62
--*emp of grade 3 & 4
-- Dep_name= 'FINANCE' OR 'AUDIT'
--salary > ADELYN
SELECT *
FROM employeex
WHERE salary BETWEEN (SELECT min_sal FROM salary_grade WHERE grade = 3)
          AND (SELECT max_sal FROM salary_grade WHERE grade = 4);
AND dep_id = ANY (SELECT dep_id FROM department
              WHERE dep_name IN ('FINANCE','AUDIT'))
AND salary> (SELECT salary FROM employeex
              WHERE emp_name='ADELYN')
AND SYSDATE-hire_date > (SELECT SYSDATE-hire_date FROM employeex
                          WHERE emp_name='FRANK');


--* master method
SELECT*
FROM employeex A,
     department B,
     salary_grade C
WHERE A.dep_id = B.dep_id
  AND salary BETWEEN min_sal AND max_sal --* display all 14 records
  AND grade IN (3, 4)                    ---* filter OUT 'KAYLING'
  AND dep_name IN ('FINANCE', 'AUDIT')
  AND salary > (SELECT salary
                FROM employeex
                WHERE emp_name = 'ADELYN')
  AND SYSDATE - hire_date > (SELECT SYSDATE - hire_date
                             FROM employeex
                             WHERE emp_name = 'FRANK');


63--*emp senior TO BLAZE and dep_location ='PERTH' Or 'BRISBANE'
SELECT *
FROM employeex
WHERE hire_date < (SELECT hire_date
                   FROM employeex
                   WHERE emp_name = 'BLAZE')
  AND dep_id = ANY (SELECT dep_id
                    FROM department
                    WHERE dep_location IN ('PERTH', 'BRISBANE'));

--* another_method
SELECT *
FROM employeex A,
     department B
WHERE A.dep_id = B.dep_id
  AND dep_location IN ('PERTH', 'BRISBANE')
  AND hire_date < (SELECT hire_date
                   FROM employeex
                   WHERE emp_name = 'BLAZE');


64--*emp whose salary > than total remuneration of job_name='SALESMAN'
--total remuneration is MAX(salary+commission)
SELECT *
FROM employeex
WHERE salary > ANY (SELECT MAX(salary + NVL(commission, 0))
                    FROM employeex
                    WHERE job_name = 'SALESMAN');

SELECT *
FROM employeex
WHERE salary > (SELECT MAX(salary + commission)
                FROM employeex
                WHERE job_name = 'SALESMAN');


65--*emp having same job_name AS'MARKER'
--OR salary is More Than ADELYN
SELECT *
FROM employeex
WHERE job_name = (SELECT job_name
                  FROM employeex
                  WHERE emp_name = 'MARKER')
   OR salary > (SELECT salary
                FROM employeex
                WHERE emp_name = 'ADELYN');


66--*emp Having salary ='FRANK' Or 'SANDRINE'
SELECT *
FROM employeex A
WHERE salary IN (SELECT salary
                 FROM employeex
                 WHERE emp_name IN ('FRANK', 'SANDRINE')
                   AND A.emp_id <> emp_id);

67--*emp of dep_id =2001 having same job_name of dep_1001
SELECT *
FROM employeex
WHERE dep_id = 2001
  AND job_name = ANY (SELECT job_name
                      FROM employeex
                      WHERE dep_id = 1001)

--* another method
SELECT *
FROM employeex A,
     department B
WHERE A.dep_id = B.dep_id
  AND A.dep_id = 2001
  AND A.job_name IN (SELECT job_name
                     FROM employeex
                     WHERE dep_id = 1001);


68--*EVEN/ODD rows
SELECT *
FROM employees
WHERE (ROWID, 0)
          = ANY (SELECT ROWID, MOD(employee_id, 2) FROM employees);


69--* dep_id,all emp_names in 14 ROWS
SELECT department_id, LISTAGG(first_name, ' , ') WITHIN GROUP (ORDER BY department_id) AS "Emp's", FLOOR(AVG(salary))
FROM employees
GROUP BY department_id;


70--* Date in words.
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) || ' Years ' ||
       TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, hire_date), 12)) || ' Months ' ||
       TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, hire_date) * 30, 30)) || ' Days ' AS exp
FROM employees
WHERE ROWNUM = 1;

71--* What is the o/p of the following Code.?
SELECT INSTR('MISSISSIPPI', 'ISSI', 1, 2)
FROM dual;

ANS
: 5
--* because next ISSI present at position 5
SELECT INSTR('MISSISSIPPI', 'ISSI', -1, 2)
FROM dual;
ANS
: 5 --* because

72--* Count no of SAT /SUN From a month
--* DY = SAT / SUN
--* DAY = SATURDAY /SUNDAY
--* D = 1->7
SELECT TO_CHAR(SYSDATE, 'MON') AS Month, COUNT(cal) AS SAT_SUN_count
FROM (
    SELECT TO_CHAR(LEVEL - 1 + TRUNC(SYSDATE, 'Mon'), 'DY') AS cal
    FROM dual
    CONNECT BY LEVEL <= ROUND(LAST_DAY(SYSDATE) - TRUNC(SYSDATE, 'Mon')) + 1)
WHERE cal IN ('SAT', 'SUN');


--* With clause Method: [ sat/ sun divided]
WITH CTE AS
         (SELECT TO_CHAR((LEVEL - 1) + TRUNC(SYSDATE, 'Month'), 'DY') AS cal
          FROM dual
CONNECT BY LEVEL <= TRUNC(LAST_DAY(SYSDATE) - TRUNC(SYSDATE)) + 1
    )
SELECT cal, COUNT(cal)
FROM CTE
WHERE cal IN ('SAT', 'SUN')
GROUP BY cal;


73--* Count the number of SAT /SUN FROM a Year
WITH CTE AS (
    SELECT TO_CHAR(LEVEL - 1 + TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'MONTH') AS months,
           TO_CHAR(LEVEL - 1 + TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'DY')    AS days
    FROM dual
    CONNECT BY LEVEL <= TRUNC(TO_DATE('1991-10-01', 'YYYY-MM-DD'), 'YYYY')
        - TRUNC(TO_DATE('1990-10-10', 'YYYY-MM-DD'), 'YYYY')
)
SELECT months, COUNT(days) AS SAT_SUN_count
FROM CTE
WHERE DAYS IN ('SAT', 'SUN')
GROUP BY Months
ORDER BY (CASE
              WHEN Months = 'JANUARY  ' THEN 1
              WHEN Months = 'FEBRUARY ' THEN 2
              WHEN Months = 'MARCH    ' THEN 3
              WHEN Months = 'APRIL    ' THEN 4
              WHEN Months = 'MAY      ' THEN 5
              WHEN Months = 'JUNE     ' THEN 6
              WHEN Months = 'JULY     ' THEN 7
              WHEN Months = 'AUGUST   ' THEN 8
              WHEN Months = 'SEPTEMBER' THEN 9
              WHEN Months = 'OCTOBER  ' THEN 10
              WHEN Months = 'NOVEMBER ' THEN 11
              WHEN Months = 'DECEMBER ' THEN 12
              ELSE null
    END);

--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-<[DELTA 200]-< d e l t a - 2 0 0 >-
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
74--* Count number of Sat Sun FROM 2 given dates.
--* LEVEL keyword Plays a major role here.
SELECT (CASE
            WHEN Months = 'YEAR ' THEN '60 YEARS TOTAL'
            ELSE Months
    END
           ) AS months,
       sat_sun_count
FROM (
         SELECT years, months, sat_sun_count, SUM(sat_sun_COUNT) OVER (ORDER BY years) AS RN
         FROM (
                  SELECT years,
                         (CASE
                              WHEN Months IS NULL THEN 'YEAR ' || years
                              ELSE Months
                             END) AS Months,
                         SAT_SUN_COUNT
                  FROM (
                           WITH CTE AS (
                               SELECT TO_CHAR(LEVEL - 1 + TRUNC(TO_DATE('1990-11-22', 'YYYY-MM-DD'), 'YYYY'),
                                              'YYYY')  AS Years,
                                      TO_CHAR(LEVEL - 1 + TRUNC(TO_DATE('1990-11-12', 'YYYY-MM-DD'), 'YYYY'),
                                              'Month') AS Months,
                                      TO_CHAR(LEVEL - 1 + TRUNC(TO_DATE('1990-11-12', 'YYYY-MM-DD'), 'YYYY'),
                                              'DY')    AS Days
                               FROM dual ---* with trunc over here u can get the sat-sun count for dec
                           CONNECT BY LEVEL <= LAST_DAY(TO_DATE('2050-12-12'
                                    , 'YYYY-MM-DD'))
                               - TRUNC(TO_DATE('1990-11-22'
                                    , 'YYYY-MM-DD')
                                    , 'YYYY')
                       ) SELECT years, Months, COUNT(days) AS SAT_SUN_COUNT
                  FROM CTE
                  WHERE days IN ('SAT', 'SUN')
                  GROUP BY ROLLUP (Years, Months)
                  ORDER BY years,
                      (CASE
                      WHEN Months = 'January  ' THEN 1
                      WHEN Months = 'February ' THEN 2
                      WHEN Months = 'March    ' THEN 3
                      WHEN Months = 'April    ' THEN 4
                      WHEN Months = 'May      ' THEN 5
                      WHEN Months = 'June     ' THEN 6
                      WHEN Months = 'July     ' THEN 7
                      WHEN Months = 'August   ' THEN 8
                      WHEN Months = 'September' THEN 9
                      WHEN Months = 'October  ' THEN 10
                      WHEN Months = 'November ' THEN 11
                      WHEN Months = 'December ' THEN 12
                      ELSE null
                      END))) );


---* Master Method:
SELECT (CASE
            WHEN Months = 'TOTAL_SAT_SUN_CNT OF ' THEN 'TOTAL ' || FLOOR((TO_DATE('2050-12-01',
                                                                                  'YYYY-MM-DD') TO_DATE('1990-12-01', 'YYYY-MM-DD')) /
                                                                         365) ||
                                                       ' YEARS'
            ELSE months
    END) AS months,
       cnt
FROM (
         SELECT (CASE
                     WHEN Months IS Null THEN 'TOTAL_SAT_SUN_CNT OF ' || years
                     ELSE months
             END) AS Months,
                cnt
         FROM (
                  SELECT years, months, COUNT(days) cnt
                  FROM (
                           SELECT TO_CHAR(LEVEL - 1 + TRUNC(TO_DATE('1990-10-12', 'YYYY-MM-DD'), 'YYYY'), 'YYYY') Years,
                                  TO_CHAR(LEVEL - 1 + TRUNC(TO_DATE('1990-10-12', 'YYYY-MM-DD'), 'YYYY'),
                                          'MONTH')                                                                Months,
                                  TO_CHAR(LEVEL - 1 + TRUNC(TO_DATE('1990-10-12', 'YYYY-MM-DD'), 'YYYY'), 'DY')   days
                           FROM dual CONNECT BY LEVEL <=
                                      (LAST_DAY(TO_DATE('2050-12-30', 'YYYY-MM-DD')) TRUNC(TO_DATE('1990-10-12', 'YYYY-MM-DD'), 'YYYY')))
                  WHERE days IN ('SAT', 'SUN')
                  GROUP BY ROLLUP (years, months)
                  ORDER BY years,
                           (CASE
                                WHEN MONTHS = 'JANUARY  ' THEN 1
                                WHEN MONTHS = 'FEBRUARY ' THEN 2
                                WHEN MONTHS = 'MARCH    ' THEN 3
                                WHEN MONTHS = 'APRIL    ' THEN 4
                                WHEN MONTHS = 'MAY      ' THEN 5
                                WHEN MONTHS = 'JUNE     ' THEN 6
                                WHEN MONTHS = 'JULY     ' THEN 7
                                WHEN MONTHS = 'AUGUST   ' THEN 8
                                WHEN MONTHS = 'SEPTEMBER' THEN 9
                                WHEN MONTHS = 'OCTOBER  ' THEN 10
                                WHEN MONTHS = 'NOVEMBER ' THEN 11
                                WHEN MONTHS = 'DECEMBER ' THEN 12
                               END)
              ));


75--* Display calender Of current Month
SELECT DAYS, LISTAGG(TO_CHAR(MONTH_DATES), ' ') WITHIN GROUP (ORDER BY MONTH_DATES) AS THIS_MONTH
FROM (
    SELECT TO_CHAR(LEVEL - 1 + TRUNC(SYSDATE, 'MON'), 'DAY') AS DAYS, LEVEL AS MONTH_DATES
    FROM dual
    CONNECT BY LEVEL <= LAST_DAY(SYSDATE)
    - TRUNC(SYSDATE, 'MON') + 1)
GROUP BY DAYS;

--* Master method
SELECT DAYS, LISTAGG(TO_CHAR(MONTH_DATES, 'DD'), ' ') WITHIN GROUP (ORDER BY MONTH_DATES) AS DATES
FROM (
    SELECT MONTH_DATES, TO_CHAR(MONTH_DATES, 'DAY') AS DAYS
    FROM (
    SELECT ADD_MONTHS(LAST_DAY(SYSDATE), -1) + LEVEL AS MONTH_DATES
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE), 'DD'))
    )
GROUP BY DAYS;

---* Another Method :
SELECT DISTINCT Days, LISTAGG(L, ' ') WITHIN GROUP (ORDER BY L) OVER ( PARTITION BY days ) AS Calender
FROM (
    SELECT TO_CHAR(LEVEL - 1 + TRUNC(SYSDATE, 'MONTH'), 'DAY') AS days, Level L
    FROM dual
    CONNECT BY LEVEL <= ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), 1) - 1 - TRUNC(SYSDATE, 'MONTH') + 1)


--* Date into Words. *--
SELECT TO_CHAR(SYSDATE, 'YEAR MONTH DAY')
FROM dual;
SELECT TO_CHAR(TO_DATE(emp_id, 'J'), 'JSP')
FROM employeex;
--* Date in Words *--


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >-DIAGRAMS-<
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
76_A--* PRINT string in the rows OF characters / Triangle
--*DIAGRAMS
## PRACTICE_EVERYDAY
--* BASICS STEPs PAttern [ - ve CUT left ]
WITH CTE AS (SELECT 'WITCHER3' S FROM dual)
SELECT SUBSTR(S, LEVEL)                        A1,
       SUBSTR(S, LEVEL, LENGTH(S))             A2,
       SUBSTR(S, LEVEL, LENGTH(S) + 1 - LEVEL) A3,
       SUBSTR(S, 1, LENGTH(S) + 1 - LEVEL)     A4,
       RPAD(S, LENGTH(S) + 1 - LEVEL)          A5
FROM CTE CONNECT BY LEVEL <= LENGTH(S);


--* BASICS STEPs PAttern [ - ve CUT RIGHT ]
WITH CTE AS (SELECT 'WITCHER3' S FROM dual)
SELECT RPAD(' ', LEVEL) || SUBSTR(S, LEVEL)                        A1,
       RPAD(' ', LEVEL) || SUBSTR(S, LEVEL, LENGTH(S))             A2,
       RPAD(' ', LEVEL) || SUBSTR(S, 1, LENGTH(S) + 1 - LEVEL)     A3,
       RPAD(' ', LEVEL) || SUBSTR(S, LEVEL, LENGTH(S) + 1 - LEVEL) A4,
       RPAD(' ', LEVEL) || RPAD(S, LENGTH(S) + 1 - LEVEL)          A5
FROM CTE CONNECT BY LEVEL <= LENGTH(S);


--* BASICS STEPs PAttern [ - ve CUT left DESC]
WITH CTE AS (SELECT 'WITCHER3' S FROM dual)
SELECT RPAD(S, LEVEL, S)                       A1,
       SUBSTR(S, 1, LEVEL)                     A2,
       SUBSTR(S, -LEVEL, LEVEL)                A3,
       SUBSTR(S, LENGTH(S) + 1 - LEVEL, LEVEL) A4
FROM CTE CONNECT BY LEVEL <= LENGTH(S);


--* BASICS STEPs PAttern [ - ve CUT Right DESC ]
WITH CTE AS (SELECT 'WITCHER3' S FROM dual)
SELECT RPAD(' ', LENGTH(S) + 1 - LEVEL) || SUBSTR(S, 1, LEVEL)                     A1,
       RPAD(' ', LENGTH(S) + 1 - LEVEL) || SUBSTR(S, -LEVEL, LEVEL)                A2,
       RPAD(' ', LENGTH(S) + 1 - LEVEL) || SUBSTR(S, LENGTH(S) + 1 - LEVEL, LEVEL) A3,
       RPAD(' ', LENGTH(S) + 1 - LEVEL) || RPAD(S, LEVEL)                          A4
FROM CTE CONNECT BY LEVEL <= LENGTH(S);


--*6 Triks to Form Diamond
SELECT SUBSTR(S, LEVEL, 1)                                          A,
       SUBSTR(S, LEVEL * -1, 1)                                     B,
       SUBSTR(S, LEVEL)                                             C,
       RPAD(' ', LENGTH(S) + 1 - LEVEL, ' ') || SUBSTR(S, 1, LEVEL) D,
       SUBSTR(S, 1, LEVEL)                                          E,
       RPAD(' ', LEVEL, ' ') || SUBSTR(S, LEVEL)                    F,
       RPAD(' ', LEVEL, ' ') || SUBSTR(S, 1, LENGTH(S))             X,
       SUBSTR(S, LEVEL, LEVEL)                                      Y,
       RPAD(' ', LENGTH(S) + 1 - LEVEL, ' ') || SUBSTR(S, LEVEL)    Z
FROM dual,
     (SELECT 'WITCHER3' S FROM dual) CONNECT BY LEVEL <= LENGTH(s);

--* Print the Diamond
SELECT SUBSTR(S, LEVEL)                                            A1,
       RPAD(' ', LEVEL) || SUBSTR(S, LEVEL, LENGTH(S) + 1 - LEVEL) A2
FROM dual,
     (SELECT '***************' AS S FROM dual) CONNECT BY LEVEL <= LENGTH(S)
UNION ALL
SELECT SUBSTR(S, LENGTH(S) + 1 - LEVEL, LEVEL)                      A1,
       RPAD(' ', LENGTH(S) + 1 - LEVEL) || SUBSTR(S, -LEVEL, LEVEL) A2
FROM dual,
     (SELECT '***************' S FROM dual) CONNECT BY LEVEL <= LENGTH(S);

--*Print Psychedelic / Kite pattern
SELECT SUBSTR(S, LEVEL, LENGTH(S) + 1 - LEVEL) || RPAD(' ', LEVEL) || SUBSTR(S, 1, LEVEL) AS A1
FROM dual,
     (SELECT 'ÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔ' S FROM dual) CONNECT BY LEVEL <= LENGTH(S)
UNION ALL
SELECT RPAD(' ', LEVEL) || RPAD(S, LENGTH(S) + 1 - LEVEL) || RPAD(' ', LENGTH(S) + 1 - LEVEL) ||
       SUBSTR(S, -LEVEL, LEVEL) AS A1
FROM dual,
     (SELECT 'ÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔ' S FROM dual) CONNECT BY LEVEL <= LENGTH(S);


--*Display Pyramid
SELECT RPAD(' ', LENGTH(S) + 1 - LEVEL) || SUBSTR(S, 1, LEVEL) || SUBSTR(S, -LEVEL, LEVEL) A1
FROM dual,
     (SELECT 'ÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔ' S FROM dual) CONNECT BY LEVEL <= LENGTH(S)
UNION ALL
SELECT RPAD(' ', LEVEL) || SUBSTR(S, 1, LENGTH(S) + 1 - LEVEL) || RPAD(S, LENGTH(S) + 1 - LEVEL)
FROM dual,
     (SELECT 'ÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔÔ' S FROM dual) CONNECT BY LEVEL <= LENGTH(S);

--*Print V
SELECT RPAD(' ', LEVEL) || '*' || RPAD(' ', 5 + 1 - LEVEL) || RPAD(' ', 5 + 1 - LEVEL) || '*' AS A
FROM dual CONNECT BY LEVEL <= 6;


--* Print X
SELECT RPAD(' ', LEVEL) || '*' || RPAD(' ', 5 + 1 - LEVEL) || RPAD(' ', 5 + 1 - LEVEL) || '*' AS A
FROM dual CONNECT BY LEVEL <= 6
UNION ALL
SELECT RPAD(' ', 5 + 1 - LEVEL) || '*' || RPAD(' ', LEVEL) || RPAD(' ', LEVEL) || '*' AS A
FROM dual CONNECT BY LEVEL <= 6;


--* Print Aero Train.
SELECT RPAD('*', ABS(10 - MOD(LEVEL, 10)), '*') || RPAD(' ', MOD(LEVEL, 10), ' ') ||
       RPAD(' ', MOD(LEVEL, 10), ' ') || RPAD('*', 10 - MOD(LEVEL, 10), '*') AS A
FROM dual CONNECT BY LEVEl <= 100;


---*Display number after Decimal.
WITH CTE AS (
    SELECT 122.1099 A
    FROM dual) ----*  As it returning max value than 5
SELECT SUBSTR(A, INSTR(A, '.'), LENGTH(A) - LENGTH(INSTR(A, '.')))
FROM CTE;


--* Using ROW_NUMBER
SELECT  L,rn,RPAD('* ',rn *3,'* ')||RPAD('*    ',L*2,'* ')
FROM (
         SELECT LEVEL L,ROW_NUMBER() OVER( ORDER BY null )As rn FROM dual
         CONNECT BY LEVEL <=10
         ORDER BY L DESC );


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >-
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
76_A--** Reverse a String w/o Using REVERSE()
--*Step 1
SELECT SUBSTR(S, ROWNUM, 1)
FROM dual,
     (SELECT 'WITCHER3' AS S FROM dual) CONNECT BY LEVEL <= LENGTH(S);

--*-- OR
WITH CTE AS (SELECT 'WITCHER' D FROM dual)
SELECT D
FROM CTE CONNECT BY LEVEL <= LENGTH(D);


--*Step 2 : Extract the character FROM the String
SELECT SUBSTR(S, ROWNUM * -1, 1)
FROM dual,
     (SELECT 'WITCHER3' S FROm dual) CONNECT BY LEVEL <= LENGTH(S);

--*-- OR
WITH CTE AS (SELECT 'WITCHER3' D FROM dual)
SELECT SUBSTR(D, LEVEL), SUBSTR(D, LEVEL, 1), LEVEL
FROM CTE CONNECT BY LEVEL <= LENGTH(D);

--* STEP 3
WITH CTE AS (SELECT 'WITCHER3' D FROM dual)
SELECT LISTAGG(S) WITHIN GROUP (ORDER BY L),
       LISTAGG(S) WITHIN
GROUP (ORDER BY L DESC)
FROM (
    SELECT SUBSTR(D, LEVEL, 1) S, LEVEL L
    FROM CTE
    CONNECT BY LEVEL <= LENGTH (D));

--*W/o With CLAUSE
SELECT LISTAGG(S) WITHIN GROUP (ORDER BY L),
       LISTAGG(S) WITHIN
GROUP (ORDER BY L DESC)
FROM (SELECT SUBSTR(D, LEVEL, 1) S, LEVEL L
    FROM dual,
    (SELECT 'WITCHER3' D FROM dual)
    CONNECT BY LEVEL <= LENGTH (D));


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >-
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
77--* Display Count of Group of repeating Values.
--* AAAA B AA CCCC AAAA ---> then A=3 ,B=1 ,C=1
SELECT *
FROM T;
SELECT cd, COUNT(*)
FROM T
GROUP BY cd
ORDER BY cd;


SELECT dt,
       cd,
       ROW_NUMBER() OVER (ORDER BY dt)                                                   AS X, ROW_NUMBER() OVER (PARTITION BY cd ORDER BY dt)                                   AS Y, ROW_NUMBER() OVER (ORDER BY dt) - ROW_NUMBER() OVER (PARTITION BY cd ORDER BY dt) AS Z
FROM T;

--* next Step
SELECT DISTINCT cd,
                ROW_NUMBER() OVER (ORDER BY dt)                                                   AS X, ROW_NUMBER() OVER (PARTITION BY cd ORDER BY dt)                                   AS Y, ROW_NUMBER() OVER (ORDER BY dt) - ROW_NUMBER() OVER (PARTITION BY cd ORDER BY dt) AS Z
FROM T;


--* Final Step :
SELECT cd, COUNT(cd)
FROM (SELECT DISTINCT cd,
                      ROW_NUMBER() OVER (ORDER BY dt)
                          - ROW_NUMBER() OVER (PARTITION BY cd ORDER BY dt) AS RN
      FROM T)
GROUP BY cd
ORDER BY cd;


--* next Level output :
SELECT cd, COUNT(cd), rx
FROM (SELECT DISTINCT cd,
                      ROW_NUMBER() OVER (ORDER BY dt)
                          - ROW_NUMBER() OVER (PARTITION BY cd ORDER BY dt) AS RN, COUNT(*) OVER (PARTITION BY cd)                       AS RX
      FROM T)
GROUP BY cd, rx
ORDER BY cd;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
78--* dep_id_avg /  avg(salary)1^ / min(sum(salary)) / dep_id_sum
--* MASTER 4 avg sal FOR [DELTA 200]
SELECT sal
FROM (SELECT AVG(salary) AS sal
      FROM employees
      GROUP BY department_id) E1
WHERE 4 = (SELECT COUNT(*)
           FROM (SELECT AVG(salary) AS sal
                 FROM employees
                 GROUP BY department_id) E2
           WHERE E1.sal >= E2.sal);
---*avg salary +1 greater than min(sum(salary)


WITH CTE AS (
    SELECT AVG(salary) AS avg_x
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) =
           (SELECT MIN(AVG(salary)) AS avg_x
            FROM employees
            GROUP BY department_id
            HAVING AVG(salary) > (SELECT MIN(SUM(salary))
                                  FROM employees
                                  GROUP BY department_id))
)
SELECT (SELECT department_id
        FROM employees
        GROUP BY department_id
        HAVING AVG(salary) = CTE.avg_x) AS dep_id_avg,
       CTE.avg_x,
       (SELECT MIN(SUM(salary))
        FROM employees
        GROUP BY department_id)         AS sum_x,
       (SELECT department_id
        FROM employees
        GROUP BY department_id
        HAVING SUM(salary) = (SELECT MIN(SUM(salary))
                              FROM employees
                              GROUP BY department_id)
       )                                AS dep_id_sum
FROM CTE;

---* master method / multipe CTE's
WITH CTE AS
         (
             SELECT AVG(A.salary) AS avg_x, A.department_id
             FROM employees A,
                  employees B
             WHERE A.manager_id = B.employee_id(+)
             GROUP BY A.department_id
             HAVING AVG(A.salary) > (SELECT MIN(SUM(salary))
                                     FROM employees
                                     GROUP BY department_id)
         ),
     CTE1 AS
         (SELECT SUM(salary) AS sum_x, department_id
          FROM employees
          GROUP BY department_id
          HAVING SUM(salary) = (SELECT MIN(SUM(salary))
                                FROM employees
                                GROUP BY department_id)
         )
SELECT CTE1.department_id, CTE1.sum_x, CTE.avg_x, CTE.department_id
FROM CTE,
     CTE1
WHERE CTE.avg_x = (SELECT MIN(CTE.avg_x) FROM CTE);


---* DELTA200 method.

WITH CTE AS
         (
             SELECT AVG(A.salary) AS avg_x, A.department_id
             FROM employees A,
                  employees B
             WHERE A.manager_id = B.employee_id(+)
             GROUP BY A.department_id
             HAVING AVG(A.salary) > (SELECT MIN(SUM(salary))
                                     FROM employees
                                     GROUP BY department_id)
                AND AVG(A.salary) = (
                 SELECT sal -----* 4th avg(min(salary))
                 FROM (SELECT AVG(salary) AS sal
                       FROM employees
                       GROUP BY department_id) E1
                 WHERE 4 = (SELECT COUNT(*)
                            FROM (SELECT AVG(salary) AS sal
                                  FROM employees
                                  GROUP BY department_id) E2
                            WHERE E1.sal >= E2.sal)
             )
         ),
     CTE1 AS
         (SELECT SUM(salary), department_id
          FROM employees
          GROUP BY department_id
          HAVING SUM(salary) = (SELECT MIN(SUM(salary))
                                FROM employees
                                GROUP BY department_id)
         )
SELECT *
FROM CTE,
     CTE1;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-<[DELTA 200]-< d e l t a - 2 0 0 >-
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
79--* manager in the range of 2nd min net salary
SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID = ANY (SELECT MANAGER_ID FROM EMPLOYEES)
  AND SALARY BETWEEN
        (SELECT MAX(RN)
         from (
                  SELECT*
                  from (
                           SELECT DISTINCT SUM(SALARY + NVL(COMMISSION_PCT, 0)) OVER (PARTITION BY DEPARTMENT_ID) AS RN
                           FROM EMPLOYEES)
                  ORDER BY RN asc)
         WHERE ROWNUM <= 2) - 500
    AND
        (SELECT MAX(RN)
         from (
                  SELECT*
                  from (
                           SELECT DISTINCT SUM(SALARY + NVL(COMMISSION_PCT, 0)) OVER (PARTITION BY DEPARTMENT_ID) AS RN
                           FROM EMPLOYEES)
                  ORDER BY RN ASC)
         WHERE ROWNUM <= 2) + 500;

--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-<[DELTA 200]-< d e l t a - 2 0 0 >- Mid-row -<
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
80--*emp salary greater than mid row of manager (order by DESC)
SELECT *
FROM employees
WHERE salary >
      (SELECT *
       FROM (
                SELECT salary
                FROM employees
                WHERE employee_id = ANY (SELECT manager_id FROM employees)
                  AND ROWNUM <= (SELECT COUNT(*) / 2
                                 FROM employees
                                 WHERE employee_id = ANY (SELECT manager_id FROM employees))
                    MINUS
                SELECT salary
                FROM employees
                WHERE employee_id = ANY (SELECT manager_id FROM employees)
                  AND ROWNUM <> (SELECT COUNT (*) / 2
                    FROM employees
                    WHERE employee_id = ANY (SELECT manager_id FROM employees))
            )
      )
    MINUS
SELECT *
FROM employees
WHERE employee_id = ANY (SELECT manager_id FROM employees);


--* Master method : --* mid row
SELECT *
FROM employeex
WHERE ROWNUM <= (SELECT CASE MOD(COUNT(1), 2)
                            WHEN 0 THEN (COUNT(1) / 2) + 1
                            ELSE ROUND(COUNT(1) / 2) END
                 FROM employeex)
    MINUS
SELECT *
FROM employeex
WHERE ROWNUM < (SELECT (COUNT(1) / 2) FROM employeex);

--* failure Of master method --- but hey ...? its working strange huh!
WITH CTE AS
         (SELECT *
          FROM employees
          WHERE employee_id = ANY (SELECT manager_id FROM employees)
         )
SELECT *
FROM CTE
WHERE ROWNUM <= (SELECT CASE MOD(COUNT(1), 2)
                            WHEN 0 THEN (COUNT(1) / 2) + 1
                            ELSE ROUND(COUNT(1) / 2) END
                 FROM CTE)
    MINUS
SELECT *
FROM CTE
WHERE ROWNUM < (SELECT (COUNT(1) / 2) FROM CTE)


---* SHOW next records after dividing the table
SELECT *
FROM employeex MINUS
SELECT *
FROM employeex
WHERE ROWNUM <= (SELECT CASE MOD(COUNT(*), 2)
                            WHEN 0 THEN (COUNT(*) / 2) + 1
                            ELSE COUNT(*) / 2
                            END
                 FROM employeex);

--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-<[DELTA 200]-< d e l t a - 2 0 0 >- 3 quarter of output table-< department >-
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
81--* 3rd quarter of department column
-- salary dep  < whole dep salary
SELECT department_id, salary
FROM (
         SELECT department_id, salary, COUNT(*) OVER (ORDER BY LENGTH(ROWNUM) ) AS RN
         FROM (
                  SELECT department_id, salary
                  FROM employees X
                  WHERE (department_id, salary) IN
                        (SELECT *
                         FROM (
                                  SELECT*
                                  FROM (SELECT department_id, MAX(salary)
                                        FROM employees
                                        GROUP BY department_id
                                        ORDER BY department_id) MINUS SELECT *
                                  FROM (WITH CTE AS
                                      (SELECT department_id, MAX (salary)
                                      FROM employees
                                      GROUP BY department_id
                                      ORDER BY department_id)
                                      SELECT *
                                      FROM CTE
--WHERE ROWNUM <= (SELECT COUNT(*)/2 FROM CTE )) ;

                                      WHERE ROWNUM <= (SELECT CASE MOD(COUNT (1), 2)
                                      WHEN 0 THEN (COUNT (1) / 2)
                                      ELSE COUNT (1) / 2
                                      END
                                      FROM CTE))
                              ))
                     OR department_id IS NULL
                  ORDER BY department_id)
         ORDER BY department_id)
WHERE ROWNUM <= RN / 2;


--* #3rd quarter of any table. But only for non output table.
WITH CTE AS
         (SELECT emp_id, emp_name
          FROM employeex
          WHERE emp_id = ANY (SELECT manager_id FROM employeex)
         )

SELECT *
FROM CTE
WHERE ROWNUM <= (SELECT CASE MOD(COUNT(ROWNUM / 2), 2)
                            WHEN 0 THEN FLOOR((COUNT(ROWNUM) * 75) / 100)
                            ELSE FLOOR((COUNT(ROWNUM) * 75) / 100) + 1
                            END
                 FROM CTE)
    MINUS

SELECT *
FROM CTE
WHERE ROWNUM <= (SELECT COUNT(ROWNUM) / 2 FROM CTE)
;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
82--* Count the number of Vowels in a String.
---* displaying 107 Rows WHY ...?
SELECT LENGTH(first_name)
FROM employees CONNECT BY LEVEL <= 1;


--* using REGEXP_COUNT()
SELECT emp_id,
       emp_name,
       REGEXP_COUNT(UPPER(emp_name), 'A') A,
       REGEXP_COUNT(UPPER(emp_name), 'E') E,
       REGEXP_COUNT(UPPER(emp_name), 'I') I,
       REGEXP_COUNT(UPPER(emp_name), 'O') O,
       REGEXP_COUNT(UPPER(emp_name), 'U') U
FROM employeex;


---*W/o Using REGEXP_COUT
WITH CTE AS (
    SELECT UPPER(first_name || last_name)  e_name,
           LENGTH(first_name || last_name) Length
    FROM employees
    WHERE employee_id = 100)
SELECT e_name, A, COUNT(*)
FROM (SELECT e_name, length, SUBSTR(e_name, LEVEL, 1) A
      FROM CTE CONNECT BY LEVEL <= length)
WHERE A IN ('A', 'E', 'I', 'O', 'U')
GROUP BY e_name, A;


--* W/o REGEXP_COUNT and using PIVOT <||>
WITH CTE AS
         (SELECT UPPER(first_name || last_name)  e_name,
                 LENGTH(first_name || last_name) Length
          FROM employees
          WHERE employee_id = 200)
SELECT *
FROM (
         SELECT e_name,
                vow,
                COUNT(*) cnt
         FROM (SELECT e_name, length, SUBSTR(e_name, LEVEL, 1) vow
               FROM CTE CONNECT BY LEVEL <= length
              )
         WHERE vow IN ('A', 'E', 'I', 'O', 'U')
         GROUP BY e_name, vow) PIVOT (MAX(cnt) FOR vow IN ('A','E','I','O','U'));


--* COUNT 'A' , 'T' FROM 'DATTATRAY'.
WITH CTE AS
             (SELECT 'DATTATRAY' S FROM dual)
SELECT ext, S, COUNT(*)
FROM (
         SELECT SUBSTR(S, LEVEL, 1) ext, S
         FROM CTE CONNECT BY LEVEL <= LENGTH(S)
     )
WHERE ext IN ('A', 'T')
GROUP BY ext, S;


--* COUNT 'A' , 'T' FROM 'DATTATRAY'.[PIVOT-ed]
WITH CTE AS
             (SELECT 'DATTATRAY' S FROM dual)
SELECT *
FROM (
         SELECT ext, S, COUNT(*) cnt
         FROM (
                  SELECT SUBSTR(S, LEVEL, 1) ext, S
                  FROM CTE CONNECT BY LEVEL <= LENGTH(S)
              )
         WHERE ext IN ('A', 'T')
         GROUP BY ext, S) PIVOT (MAX(cnt) FOR ext IN ('A','T'));


--* Master Method :
WITH CTE AS (SELECT 'DATTATRAY' S FROM dual)
SELECT LENGTH(S) - LENGTH(REPLACE(S, 'A', '')) AS A,
       LENGTH(S) - LENGTH(REPLACE(S, 'T', '')) AS T
FROM CTE;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
83--*Concat Previous Value And Print -ve left bottom Triangle as per alphabets of col1.
---< everyday Practice >--
LOGIC :
__________________________________________________________
col1 | col2     |    LISTAGG                  | Occurance |
˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
A    |   1      |        1,2,3                |    1 --* 1st Row extract till 1st Comma
A    |   2      |        1,2,3                |    2 --* 2nd Row extract till 2nd Comma
A    |   3      |        1,2,3                |    3 --* 3rd Row extract till 3rd Comma
-< we will concatinate the 3rd comma >-
B    |  100     |   100,200,300,400,500       |    1
B    |  200     |   100,200,300,400,500       |    2
B    |  300     |   100,200,300,400,500       |    3
B    |  400     |   100,200,300,400,500       |    4
B    |  500     |   100,200,300,400,500       |    5

SELECT *
FROM T1;

SELECT SUBSTR(agg, 1, comma_cnt)
FROM ( --* concat comma for last position
         SELECT col1, col2, agg, occ, INSTR(agg || ',', ',', 1, occ) comma_cnt
         FROM (
                  SELECT col1,
                         col2,
                         LISTAGG(col2, ',') WITHIN GROUP (ORDER BY col2) OVER (PARTITION BY col1) agg,
                         ROW_NUMBER() OVER (PARTITION BY col1 ORDER BY col2)                      occ
                  FROM T1));


84--*Print 'A' Without using 'OR' Operator
SELECT *
FROM T2;

SELECT *
FROM T2
WHERE col1 || col2 || col3 || col4 || col5 LIKE '%A%';

---* another method
SELECT col1 AS output
FROM T2
WHERE col1 = 'A'
UNION ALL
SELECT col2
FROM T2
WHERE col2 = 'A'
UNION ALL
SELECT col3
FROM T2
WHERE col3 = 'A'
UNION ALL
SELECT col4
FROM T2
WHERE col4 = 'A'
UNION ALL
SELECT col5
FROM T2
WHERE col5 = 'A';


--* another method
SELECT *
FROM T2
WHERE INSTR(col1 || col2 || col3 || col4 || col5, 'A') > 0;


85--*SELECT data from TT1 Not exist in TT2 w/o using 'NOT' Operator
SELECT *
FROM TT1;
SELECT *
FROM TT2;

--* EXIST   --< Practice req. >--
SELECT*
FROM TT1
WHERE NOT EXISTS(SELECT 1
                 FROM TT2
                 WHERE TT1.c1 = TT2.c1);

--* w/o using NOT
SELECT *
FROM TT1 MINUS
SELECT*
FROM TT2;


--* master Method : (CO-related SUB QUERY)
SELECT *
FROM TT1
WHERE 1 > (SELECT COUNT(*)
           FROM TT2
           WHERE TT1.c1 = TT2.c1);

---* Ultimate method :
SELECT*
FROM TT1,
     TT2
WHERE TT1.c1 = TT2.c1(+) ---* put ; and run it understand the logic
  AND TT2.c1 IS NULL;

--* ultimate method : B
SELECT *
FROM TT1
         FULL OUTER JOIN TT2 ON TT1.c1 = TT2.c1 ---* put ; and run it understand the logic
WHERE TT2.c1 IS NULL;


--* Another method --< Practice req. >--
SELECT *
FROM TT1
WHERE (SELECT COUNT(*)
       FROM TT2
       WHERE TT2.c1 = TT1.c1) = 0;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
84--* FIND the MAX salary w/o using
--MAX()
--ROW_NUMBER()
--Analytical Functions
--Joins & Sub-queries
LATERAL JOIN : Method

SELECT*
FROM employeex A, LATERAL
    (SELECT *
     FROM (SELECT COUNT(*) C FROM employeex B WHERE A.salary <= B.salary)
     WHERE C = 1);

---* SPECIAL method
SELECT salary
FROM employeex
WHERE salary > ALL (SELECT salary - 1 FROM employeex);

--*FETCH method / easy methods
SELECT *
FROM employeex
ORDER BY salary DESC
    FETCH FIRST ROW ONLY;


--*FETCH/OFFSET method to find N'th MAX salary
SELECT *
FROM employeex
ORDER BY salary DESC
OFFSET (0) ROWS FETCH FIRST 1 ROW only;
--* first

SELECT *
FROM employeex
ORDER BY salary DESC
OFFSET (2 - 1) ROW FETCH FIRST 1 ROW ONLY;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
85--* Divide the column into 2 parts and display in front of it
SELECT *
FROM emp1;

WITH CTE AS
         (SELECT empno,
                 ename,
                 ROW_NUMBER() OVER (ORDER BY empno)                               RN, COUNT(1) OVER ()                                                 C, ROUND(COUNT(1) OVER () / 2) - ROW_NUMBER() OVER (ORDER BY empno) C1
          FROM emp1),
     CTE1 AS (SELECT empno, ename, C1 FROM CTE WHERE C1 >= 0),
     CTE2 AS (SELECT empno, ename, ABS(C1) C1 FROM CTE WHERE C1 < 0)
SELECT CTE1.empno, CTE1.ename, CTE2.empno, CTE2.ename
FROM CTE1,
     CTE2
WHERE CTE1.C1 = CTE2.C1(+);


86--*Display last date w/o using last_day.
WITH CTE AS (SELECT TO_DATE('2022-03-15', 'YYYY-MM-DD') D FROm dual)
SELECT ADD_MONTHS(TRUNC(D, 'MONTH'), 1) - 1
FROM CTE;


87--*FETCH last 3 records W/o using ROWNUM / ROW_NUMBER().
SELECT *
FROM employeex OFFSET (SELECT COUNT(*) FROM employeex) - 3 ROW FETCH NEXT 3 ROWS ONLY;


--* ROWID [ co - related subquery method]
SELECT *
FROM employeex A
WHERE 3 > (SELECT COUNT(*) FROM employeex B WHERE A.ROWID < B.ROWID);


88--*Get diagonal data from the table.
SELECT *
FROM T3;

--* STEP 1 :
SELECT ROWNUM, c1, c2, c3
FROM T3;

--* STEP 1A:
SELECT ROWNUM,
       DECODE(ROWNUM, 1, c1),
       DECODE(ROWNUM, 2, c2),
       DECODE(ROWNUM, 3, c3)
FROM T3;


--* STEP 2:
SELECT ROWNUM,
       DECODE(ROWNUM, 1, c1, 0) +
       DECODE(ROWNUM, 2, c2, 0) +
       DECODE(ROWNUM, 3, c3, 0) A
FROM T3;


--* Master Method [ DECODE ]
SELECT DECODE(ROWNUM, 1, c1, 2, c2, 3, c3) A
FROM T3;


---* Master method [ CASE ]

SELECT CASE
           WHEN R = 1 THEN c1
           WHEN R = 2 THEN c2
           WHEN R = 0 THEN c3
           END AS X
FROM (
         SELECT MOD(ROWNUM, 3) R, C1, C2, C3
         FROM T3);


---* in case of More number of ROWS.
SELECT MOD(ROWNUM, 3),
       c1,
       c2,
       c3,
       DECODE(MOD(ROWNUM, 3), 1, c1, 2, c2, 0, c3) X
FROM T3;


89--*Return Mid column name, w/o using column name
WITH CTE AS (
    SELECT ROWNUM R, column_name FROM USER_TAB_COLUMNS WHERE table_name = 'EMPLOYEEX'
)
SELECT column_name
FROM CTE
WHERE R = (SELECT ROUND(AVG(R)) FROM CTE);


90[HIERARCHIAL] relationships.
---* :BOSS
SELECT SYS_CONNECT_BY_PATH(emp_name, ' ===* ')
FROM employeex
START WITH manager_id IS NULL
CONNECT BY manager_id = PRIOR emp_id;


---* : any particular manager
SELECT SYS_CONNECT_BY_PATH(emp_name, ' ===* ')
FROM employeex START WITH emp_name = 'JONAS'
CONNECT BY PRIOR emp_id = manager_id;

SELECT salary, SYS_CONNECT_BY_PATH(emp_name, ' ===* ') X
FROM employeex START WITH emp_name = 'JONAS'
CONNECT BY PRIOR emp_id = manager_id;

---* Salary  OF manager Group:
SELECT SUM(salary)
FROM employeex START WITH emp_name = 'JONAS'
CONNECT BY PRIOR emp_id = manager_id;

---* Salary  OF manager Group: ===* of every manager
SELECT emp_id,
       emp_name,
       salary,
       (SELECT SUM(salary)
        FROM employeex START
WITH emp_name = A.emp_name
CONNECT BY PRIOR emp_id = manager_id) group_sal
FROM employeex A;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
91--* check whether string is ANAGRAM or NOT.
eg. ===* SILENT ===* LISTEN
WITH CTE AS (
    SELECT 'SILENT' S1, 'LISTEN' S2
    FROM dual)
SELECT S1,
       S2,
       (CASE
            WHEN SUM(A1) = SUM(A2) THEN 'VALID ANAGRAM'
            ELSE ' NOT VALID ANAGRAM'
           END) Validation
FROM (
         SELECT S1,
                S2,
                SUBSTR(S1, LEVEL, 1)        C1,
                SUBSTR(S2, LEVEL, 1)        C2,
                ASCII(SUBSTR(S1, LEVEL, 1)) A1,
                ASCII(SUBSTR(S2, LEVEL, 1)) A2
         FROM CTE CONNECT BY LEVEL <= LENGTH(S1))
GROUP BY S1, S2;


---* Another example
WITH CTE AS (SELECT 'EARTH' S1, 'HEART' S2 FROM dual)
SELECT S1,
       S2,
       (CASE
            WHEN SUM(A1) = SUM(A2) THEN 'VALID ANAGRAM'
            ELSE 'NOT VALID ANAGRAM'
           END) VALIDATION
FROM (
         SELECT ASCII(SUBSTR(S1, LEVEL, 1)) A1,
                ASCII(SUBSTR(S1, LEVEL, 1)) A2,
                S1,
                S2
         FROM CTE CONNECT BY LEVEL <= LENGTH(S1))
GROUP BY S1, S2;


92--* Sort the numbers of each row in ascending order
SELECT *
FROM TX;

--* STEP 1 :
WITH CTE AS (SELECT ROWNUM R, C1 FROM TX)
SELECT R, L, C1 ---* w/o lateral ------* this C1 will not work
FROM CTE, LATERAL (SELECT LEVEL L
                   FROM dual
CONNECT BY LEVEL <= LENGTH (C1))

--* STEP 2:
WITH CTE AS (SELECT ROWNUM R, C1 FROM TX)
SELECT R,
       LISTAGG(SUBSTR(C1, L, 1), '') WITHIN GROUP ( ORDER BY L )               A,
       LISTAGG(SUBSTR(C1, L, 1), '') WITHIN
GROUP (ORDER BY SUBSTR(C1, L, 1) ) B
FROM CTE, LATERAL (SELECT LEVEL L
    FROM dual
    CONNECT BY LEVEL <= LENGTH (C1) )
GROUP BY R
ORDER BY R;


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
93--*Fetch Number and strings in to 2 Separate Columns.
--* CAST() ===* value into numerical datatype
SELECT *
FROM mix;

--* CAST exception:                    ---* String won't Work here.
SELECT C1, CAST(C1 AS NUMBER DEFAULT - 9999 ON CONVERSION ERROR)
FROM mix;


--* STEP 1 :
SELECT C1, CAST(C1 AS NUMBER DEFAULT - 999 ON CONVERSION ERROR)
FROM mix
WHERE CAST(C1 AS NUMBER DEFAULT - 999 ON CONVERSION ERROR) = -999;


--* STEP 2:
SELECT C1, ROWNUM R
FROM mix
WHERE CAST(C1 AS NUMBER DEFAULT - 999 ON CONVERSION ERROR) = -999;


SELECT C1, ROWNUM R
FROM MIX
WHERE CAST(C1 AS NUMBER DEFAULT - 999 ON CONVERSION ERROR) <> -999;

--* STEP 3:
SELECT A.c1 AS Str_data, B.c1 AS Num_data
FROM (
         SELECT C1, ROWNUM R
         FROM mix
         WHERE CAST(C1 AS NUMBER DEFAULT - 999 ON CONVERSION ERROR) = -999) A
         FULL OUTER JOIN ---- *(Practice every day)
    (SELECT C1, ROWNUM R
     FROM mix
     WHERE CAST(C1 AS NUMBER DEFAULT - 999 ON CONVERSION ERROR) <> -999) B
                         ON A.R = B.R;


94--* Additional question.
-- display each value twice.
SELECT *
FROM x;

---* method 1:
SELECT c1
FROM x,
     (SELECT 1 FROM dual union ALL SELECT 1 FROM dual)
ORDER BY 1;

--* master method 2:
SELECT C1
FROM x, LATERAL (SELECT 1 FROM dual
CONNECT BY LEVEL <= 2);
--OR
SELECT C1
FROM x,
     (SELECT 1 FROM dual CONNECT BY LEVEL <= 2);


95--* Search a string w/o USING LIKE Operator
SELECT emp_name
FROM employeex
WHERE emp_name LIKE 'K%';

--Answer:
--*STEP :1
SELECT SUBSTR(emp_name, 1, 1), SUBSTR(emp_name, -1, 1)
FROM employeex;

--*STEP :2
SELECT emp_name
FROM employeex
WHERE SUBSTR(emp_name, 1, 1) = 'K'
  AND SUBSTR(emp_name, -1, 1) = 'G';


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
96--* CHECK THE SUDOKU game.
SELECT *
FROM SUDOKU;
===*RULES :
--SUM OF EACH COLUMN =45
--SUM OF EACH ROW    =45
--SUM OF EACH GROUP  =45

--* STEP :1 --> Summission OF column Values
SELECT SUM(C1) c1,
       SUM(C2) c2,
       SUM(C3) c3,
       SUM(C4) c4,
       SUM(C5) c5,
       SUM(C6) c6,
       SUM(C7) c7,
       SUM(C8) c8,
       SUM(C9) c9
FROM SUDOKU;


--* STEP :2 --> Summission OF Row values
SELECT ROW_NUM, C1 + C2 + C3 + C4 + C5 + C6 + C7 + C8 + C9 Row_sum
FROM SUDOKU;

--* STEP :3A --> GROUP wise Summission
SELECT ROW_NUM, C1 + C2 + C3, C4 + C5 + C6, C7 + C8 + C9, CEIL(ROWNUM / 3)
FROM SUDOKU;
--* STEP :3B --> GROUP wise Summission
SELECT 'G' || CEIL(ROWNUM / 3)
     , SUM(C1 + C2 + C3) G1
     , SUM(C4 + C5 + C6) G2
     , SUM(C7 + C8 + C9) G3
FROM SUDOKU
GROUP BY 'G' || CEIL(ROWNUM / 3);


--* Final Step A:
SELECT column_name, col_val AS col_sum
FROM (
         SELECT SUM(C1) c1,
                SUM(C2) c2,
                SUM(C3) c3,
                SUM(C4) c4,
                SUM(C5) c5,
                SUM(C6) c6,
                SUM(C7) c7,
                SUM(C8) c8,
                SUM(C9) c9
         FROM SUDOKU) UNPIVOT (Col_val FOR column_name IN (c1,c2,c3,c4,c5,c6,c7,c8,c9));


--* Final Step B:
SELECT column_name, column_val
FROM (
         SELECT 'G' || CEIL(ROWNUM / 3)
              , SUM(C1 + C2 + C3) G1
              , SUM(C4 + C5 + C6) G2
              , SUM(C7 + C8 + C9) G3
         FROM SUDOKU
         GROUP BY 'G' || CEIL(ROWNUM / 3)) UNPIVOT (column_val FOR column_name IN (G1,G2,G3));

---* Grand FINAL step :
SELECT CASE
           WHEN SUM(DISTINCT col_sum) = 45 THEN 'Pass'
           ELSE 'FAIL'
           END AS sud_checker
FROM (
         SELECT column_name, col_val AS col_sum
         FROM (
                  SELECT SUM(C1) c1,
                         SUM(C2) c2,
                         SUM(C3) c3,
                         SUM(C4) c4,
                         SUM(C5) c5,
                         SUM(C6) c6,
                         SUM(C7) c7,
                         SUM(C8) c8,
                         SUM(C9) c9
                  FROM SUDOKU) UNPIVOT (Col_val FOR column_name IN (c1,c2,c3,c4,c5,c6,c7,c8,c9))
         UNION ALL
         SELECT ROW_NUM, C1 + C2 + C3 + C4 + C5 + C6 + C7 + C8 + C9 Row_sum
         FROM SUDOKU
         UNION ALL
         SELECT column_name, column_val
         FROM (
                  SELECT 'G' || CEIL(ROWNUM / 3)
                       , SUM(C1 + C2 + C3) G1
                       , SUM(C4 + C5 + C6) G2
                       , SUM(C7 + C8 + C9) G3
                  FROM SUDOKU
                  GROUP BY 'G' || CEIL(ROWNUM / 3)) UNPIVOT (column_val FOR column_name IN (G1,G2,G3)));


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
97--*** Service_name infront of product_service table.
SELECT *
FROM service;
SELECT *i
FROM product_service;

LOGIC
:   --* REGEXP_SUBSTR(service_order, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2)
_________________________________________________________________________________
product_code | product_desc  |    service_order  | LEVEL | CODE   | service_name |
˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
     P1      |   PROD -P1    | A,C        |    1  |   A    | SERVICE- A   |
P1      |   PROD -P1    | A,C        |    2  |   C    | SERVICE- C   |

P2      |   PROD -P2    | C,B,D       |    1  |   C    | SERVICE- C   |
P2      |   PROD -P2    | C,B,D       |    2  |   B    | SERVICE- B   |
P2      |   PROD -P2    | C,B,D       |    3  |   D    | SERVICE- D   |


--*STEP 1:
SELECT product_code, product_desc, service_order, L
FROM product_service, LATERAL (SELECT LEVEL L
                               FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT(service_order, ',') + 1);

--*STEP 2: But see this
˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
--* REGEXP To extract Nth occurance to N+1 occurance
--< PRACTICE everyday >-
-- '(.*?,)
-- {'||(1-1)||'}
-- ([^,]*)'
--* METHOD 1:
SELECT REGEXP_SUBSTR(service_order, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2) AS A
FROM product_service;

--* METHOS 2: (For single string )                      --* -2 For double string
SELECT SUBSTR(service_order, INSTR(service_order, ',', 1, L) - 1, 1) occ, service_order, product_code
FROM product_service, LATERAL (SELECT LEVEL L
                               FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT(service_order, ',') + 1);

˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜


--* STEP 2: A

SELECT product_code,
       product_desc,
       service_order,
       L,
       REGEXP_SUBSTR(service_order, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2) AS A
FROM product_service, LATERAL (SELECT LEVEL L
                               FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT(service_order, ',') + 1);


--* STEP 3: Joining
SELECT product_code,
       product_desc,
       service_order,
       L,
       REGEXP_SUBSTR(service_order, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2) AS Occ,
       service.service_name
FROM product_service,
     service,
    LATERAL (SELECT LEVEL L FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT(service_order, ',') + 1 )
WHERE service.service_code = REGEXP_SUBSTR(service_order, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2)
ORDER BY product_code, product_desc, service_order, L;


--* FINAL STEP:
SELECT product_code,
       product_desc,
       service_order,
       LISTAGG(service.service_name, ',') WITHIN GROUP (ORDER BY L) AS service_names
FROM product_service,
    service,
    LATERAL (SELECT LEVEL L FROM dual CONNECT BY LEVEL <= REGEXP_COUNT(service_order, ',') + 1)
WHERE service.service_code = REGEXP_SUBSTR(service_order, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2)
GROUP BY product_code, product_desc, service_order
ORDER BY product_code, product_desc, service_order;


---* Another way :
SELECT DISTINCT product_code,
                product_desc,
                service_order,
                LISTAGG(service_name, ',') WITHIN GROUP (ORDER BY L) OVER (PARTITION BY product_code) service_order_new
FROM (
    SELECT service_name, service_order, L, product_code, product_desc
    FROM product_service,
    service, LATERAL (SELECT LEVEL L
    FROM dual
    CONNECT BY LEVEL <= REGEXP_COUNT(service_order, ',') + 1)
    WHERE service.service_code = SUBSTR(service_order, INSTR(service_order, ',', 1, L) - 1, 1))
ORDER BY product_code;


98--* Multiple Rows into single row.
SELECT *
FROM empm;

--* Method 1A :
SELECT empno,
       DECODE(c1, 'Name', c2)    Name,
       DECODE(c1, 'Address', c2) Address,
       DECODE(c1, 'Phone', c2)   Phone
FROM empm;

---* Method 1B:
SELECT empno,
       MAX(DECODE(c1, 'Name', c2))    Name,
       MAX(DECODE(c1, 'Address', c2)) Address,
       MAX(DECODE(c1, 'Phone', c2))   Phone
FROM empm
GROUP BY empno;


---* Method 2: Pivot
SELECT *
FROM empm PIVOT (MAX(c2) FOR c1 IN ('Name','Address','Phone'));


99--*MAX value across row and columns.
--logic  GREATEST( MAX(c1) , MAX(c2),Max(c3))


100--* Commulative sum
SELECT salary, SUM(salary) OVER ( ORDER BY salary) AS RN
FROM employeex
    101
--* Distinct records w/o USING DISTINCT keyword.
--* method 1:
SELECT first_name
FROM employees
GROUP BY first_name;

--* method 2 :
SELECT first_name
FROM employees
UNION
SELECT first_name
FROM employees;

--* method 3 :
SELECT first_name
FROM employees
INTERSECT
SELECT first_name
FROM employees;

--* master method 4:
SELECT first_name
FROM employees MINUS
SELECT NULL
FROM dual;

--* master method 5:
SELECT *
FROM (
         SELECT first_name, RANK() OVER (PARTITION BY first_name ORDER BY ROWNUM) RN
         FROM employees)
WHERE RN = 1;

--* master method 6:
SELECT *
FROM employees
WHERE ROWID IN (
    SELECT MAX(ROWID)
    FROM employees
    GROUP BY first_name)

--OR
SELECT first_name
FROM employees A
WHERE ROWID IN (SELECT MAX(ROWID)
                FROM employees B
                WHERE A.first_name = B.first_name)


---* master method 7:
SELECT *
FROM employees A
WHERE 1 = (SELECT COUNT(*)
           FROM employees B
           WHERE A.first_name = B.first_name
             AND A.rowid <= B.rowid); ---*[ doubt ]


102--* Complex WITH clause / FACTORIAL  --[  Recursive - Subquery ]--
WITH CTE (N) AS (SELECT 1
                 FROM dual
                 UNION ALL
                 SELECT N + 1
                 FROM CTE
                 WHERE N < 5)
SELECT *
FROM CTE;

---* Multi-recursion
WITH CTE (N1, N2, N3) AS (SELECT 1, 'X', 'Y'
                          FROM dual
                          UNION ALL
                          SELECT N1 + 1, N2 || 'X', N3 || 'Y'
                          FROM CTE
                          WHERE N1 < 10)
SELECT *
FROM CTE;


103--* Find 2nd occurance of a character.
WITH CTE AS (SELECT 'BLUEBERRY' S FROM dual)
SELECT *
FROM (
         SELECT SUBSTR(S, L, 1)                  C,
                L,
                REGEXP_COUNT(S, SUBSTR(S, L, 1)) cnt,
                ROW_NUMBER()                     OVER (PARTITION BY SUBSTR(S, L, 1) ORDER BY L) Occ
         FROM CTE, LATERAL (SELECT LEVEL L
                            FROM dual
         CONNECT BY LEVEL <= LENGTH (S))
WHERE REGEXP_COUNT(S, SUBSTR(S, L, 1)) = 2 --* Filter to group multiple character
    )
WHERE occ = 2
ORDER BY L --FETCH FIRST ROW ONLY
;


104--* SWAP gender in 1 single Query
SELECT *
FROM emp_fake;
UPDATE emp_fake
SET SEX= CASE
             WHEN SEX = 'F' THEN 'M'
             ELSE 'F'
    END;

--*Oppostite Experiment
UPDATE emp_fake
SET SEX = CASE
              WHEN SEX = 'M' THEN 'F'
              ELSE 'M'
    END;


--* DECODE method :
UPDATE emp_fake
SET SEX = DECODE(SEX, 'M', 'F', 'M');
UPDATE emp_fake
SET SEX = DECODE(SEX, 'F', 'M', 'F');


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0 >
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
105--*** Display values with null From 2 / 3 columns \
SELECT *
FROM null1;
-< Practice every Day >

SELECT A.c1, B.c2, C.c3
FROM null1 A,
     null1 B,
     null1 C
WHERE REGEXP_LIKE(A.c1, '^[[:digit:]]$')
  AND REGEXP_LIKE(B.c2, '^[[:digit:]]$')
  AND REGEXP_LIKE(C.c3, '[^[:digit:]]$');


--* IMLERITH method: part-1 :
SELECT LISTAGG(c1, ',') WITHIN GROUP (ORDER BY c1) A,
       LISTAGG(C2, ',') WITHIN
GROUP (ORDER BY c2) B,
    LISTAGG(c3, ',') WITHIN
GROUP (ORDER BY c3) B ---* multiple same columns
FROM null1 ---* but 'column ambiguously' ERROR with WITH  clause
GROUP BY NULL;


--* IMLERITH method: part-2 :
WITH CTE AS (
    SELECT LISTAGG(c1, ',') WITHIN
GROUP (ORDER BY c1) A,
    LISTAGG(C2, ',') WITHIN
GROUP (ORDER BY c2) B,
    LISTAGG(c3, ',') WITHIN
GROUP (ORDER BY c3) C
FROM null1
GROUP BY NULL)
SELECT A, B, C
FROM CTE, LATERAL ( SELECT LEVEL L
                    FROM dual
CONNECT BY LEVEL <= LENGTH (REPLACE(A, ',', '')));


--* IMLERITH master Step / Final STEP : (Using regexp)
WITH CTE AS (
    SELECT LISTAGG(c1, ',') WITHIN
GROUP ( ORDER BY c1) A,
    LISTAGG(c2, ',') WITHIN
GROUP (ORDER BY c2) B,
    LISTAGG(c3, ',') WITHIN
GROUP (ORDER BY c3) C
FROM null1
GROUP BY NULL)
SELECT REGEXP_SUBSTR(A, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2) A,
       REGEXP_SUBSTR(B, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2) B,
       REGEXP_SUBSTR(C, '(.*?,){' || (L - 1) || '}([^,]*)', 1, 1, '', 2) C
FROM CTE, LATERAL (SELECT LEVEL L
                   FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT(A, ',') + 1 );


---* IMLERITH's Another method : (using substr / instr)
WITH CTE AS (
    SELECT LISTAGG(c1, ',') WITHIN
GROUP (ORDER BY c1) A,
    LISTAGG(c1, ',') WITHIN
GROUP (ORDER BY c2) B,
    LISTAGG(c3, ',') WITHIN
GROUP (ORDER BY c3) C
FROM null1
GROUP BY NULL)
SELECT SUBSTR(A, INSTR(A, ',', 1, L) - 1, 1)                                       A,---* FOR single string
       SUBSTR(B, INSTR(B, ',', 1, L) - 1, 1)                                       B,
       SUBSTR(C, INSTR(C, ',', 1, L) - 2, LENGTH(C) - LENGTH(REPLACE(C, ',', ''))) C ---* FOR double string
FROM CTE, LATERAL (SELECT LEVEL L
                   FROM dual
CONNECT BY LEVEL <= LENGTH (REPLACE(A
         , ','
         , ''))
    );



˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜*** Duplication Methods ***˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜˜
--* Check_constraints
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'EMP_FAKE';

==* Method : A
SELECT *
FROM emp_fake;
--* Query
SELECT *
FROM emp_fake A
WHERE 2 = (SELECT COUNT(*)
           FROM emp_fake
           WHERE A.first_name = first_name) ===* Method : B


--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
-[DELTA 200]-< d e l t a - 2 0 0  HUB >- Rownumwith JOINS-< department >-;
--<|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|/|\|/|\/|\|/|\|/|\|>--
--< Contact here For Confusion >-
--* SOME CRITICAL PROBLEMS
SELECT B.dep_id, COUNT(A.emp_id) AS cnt ----- * and we are talking about this count.
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id
  AND ROWNUM <= (SELECT ROUND(COUNT(ROWNUM) / 2) ---* because at rownum 7 COUNT is 4 for 2001
                 FROM employeex A,
                      department B
                 WHERE A.dep_id(+) = B.dep_id)

GROUP BY B.dep_id
HAVING COUNT(*) >= 0;


---* very important working with count and ROWNUM WITH join
SELECT COUNT(ROWNUM) / 2
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id;

--*dep_id 1001 ,count(1)
SELECT B.dep_id, COUNT(A.emp_id)
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id
  AND ROWNUM <= 1----* increase this value and in the output you will see change in count
GROUP BY B.dep_id
HAVING COUNT(*) >= 0;

--*dep_id 1001 ,count(2)
SELECT B.dep_id, COUNT(A.emp_id)
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id
  AND ROWNUM <= 2
GROUP BY B.dep_id
HAVING COUNT(*) >= 0;

---* Whats wrong with this code ...?
SELECT B.dep_id, COUNT(A.emp_id)
FROM employeex A,
     department B
WHERE A.dep_id(+) = B.dep_id
  AND ROWNUM <= 12 ----* because of join max rows are 15

GROUP BY B.dep_id
HAVING COUNT(*) >= 0;

---15 /4 ,....here SO its like 3,9,12,15
-- 3 = ROWNUM (3) i.e,  1->3
-- 6 = ROWNUM (6) i.e,  3->6
-- 9 = ROWNUM (9) i.e,  6->9
--15 = ROWNUM (15) i.e, 9->15


------------------------/ END /------------------------------------
--* employee/manager/boss relationship
--*master method:
SELECT A.first_name                                                        AS employees,
       B.first_name                                                        AS managers,
       (SELECT first_name FROM employees WHERE employee_id = B.manager_id) AS Managers_Head,
       (SELECT first_name FROM employees WHERE manager_id is NULL)         AS BOSS
FROM employees A
         LEFT OUTER JOIN employees B
                         ON A.manager_id = B.employee_id;


SELECT A.emp_id                   "Employees",
       B.emp_id                   "MANAGERS",
       B.manager_id               "MANAGER's HEAD",
       --C.emp_id "MANAGERS's HEAD"
       -- C.manager_id "BOSS"
       (SELECT emp_name
        FROM employeex
        WHERE manager_id IS NULL) "BOSS"
FROM employeex A,
     employeex B
     --    employeex C
WHERE A.manager_id = B.emp_id;
-- AND B.manager_id = C.emp_id ORDER BY B.emp_id;;


SELECT A.employee_id,
       B.employee_id "EMP's MANAGER",
       B.manager_id  "MANAGER's HEAD",
       C.employee_id "MANAGER's HEAD",
       C.manager_id  "BOSS"
FROM employees A,
     employees B,
     employees C
WHERE A.manager_id = B.employee_id WHERE A.manager_id = B.employee_id
  AND B.manager_id = C.employee_id;
1
1
1
1
1
1
1