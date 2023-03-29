/*
	View?
	
	1. view란 가상의 테이블이다.
	2. view에는 실제 데이터가 존재하지 않고 view를 통해서 데이터만 조회할 수 있다.
	3. view는 복잡한 query를 통해 조회할 수 있는 결과를 사전에 정의한 view를 통해
	   간단히 조회할 수 있게 한다.
  4. 한개의 view로 여러 개의 Table테이터를 검색할 수 있게 한다.
	5. 특정 기준에 따라 사용자별로 다른 조회 결과를 얻을 수 있게 한다.
	
	view의 제한조건
	
	1. 테이블에 not null로 만든 컬럼들이 view에 포함되어야 한다.
	2. view를 통해서도 데이터를 insert할 수 있다. 단, rowid, rownum, nextval, curval
	   등과 같은 가상의 컬럼에 대해 참조하고 있을 경우에 가능하다.
	3. with read only옵션으로 설정된 view는 어떠한 데이터를 갱신할 수 없다.
	4. with check option을 설정한 view는 view조건에 해당되는 데이터맘 삽입, 삭제, 수정
	   할 수 있다.
			
	view 문법
	
	create [or replace] [force|noforce] view 뷰이름 as
	sub query...
	with read only
	with check option
	
	1. or replace : 동일 이름의 view가 존재할 경우 삭제후 다시 생성(대체)
	2. force|noforce : 테이블의 존재유무와 상관없이 view를 생성할지 여부
	3. with read only : 조회만 가능한 view
	4. with check option : 주어진 check옵션 즉, 제약조건에 맞는 데이터만 입력하거나 수정가능
	
	view조회방법
	
	테이블과 동일한 문법으로 사용
	
	view를 생성할 수 있는 권한 부여하기
	
	1. 사용자권한조회 : select * from user_role_privs;
	2. 권한 부여방법  : sysdba에 권한으로 부여 가능
	   grant create view to scott(사용자계정 or schema)
	
*/
select * from emp;

create or replace view v_emp as
select ename, job, deptno from emp; -- insufficient privileges

-- 1. create view 권한 부여하기
-- grant connect, resource to scott;
grant create view to scott;

-- 2. 권한조회
select * from user_role_privs;

-- 3. 단순 view 생성하기
create or replace view v_emp as
select ename, job, deptno from emp; 

select * from v_emp;

-- 4. 사용자 view목록 조회하기
select * from user_views;

select * from emp;
select * from dept;
 
-- 5. 복합 view
create or replace view v_emp_dname as
select emp.ename, dpt.dname, emp.deptno
  from emp emp, dept dpt
 where emp.deptno = dpt.deptno;

select * from v_emp_dname;


-- 실습. 급여(sal, comm)가 포함된 view
-- 예) 급여조회권한이 있는 담당자만 사용할 수 있는 view
create or replace view v_emp_sal as
select empno 사원번호
     , ename "사원 이름"
		 , job   직급
		 , sal   급여
		 , nvl(comm, 0)  커미션
  from emp;

select * from v_emp_sal;
select * from v_emp_sal where job = 'CLERK'; -- "JOB": invalid identifier
select * from v_emp_sal where "직급" = 'CLERK';
select * from v_emp_sal where "사원 이름" = 'SMITH';

select *
  from (select empno 사원번호
						 , ename "사원 이름"
						 , job   직급
						 , sal   급여
						 , nvl(comm, 0)  커미션
					from emp)
 where job = 'CLERK'; -- "JOB": invalid identifier

select *
  from (select empno 사원번호
						 , ename "사원 이름"
						 , job   직급
						 , sal   급여
						 , nvl(comm, 0)  커미션
					from emp)
 where 직급 = 'CLERK';
 
 -- 6. table과 view의 join?
 select emp.deptno, v_emp.*
   from emp emp, v_emp_sal v_emp
  where emp.empno = v_emp.사원번호;
	 
create or replace view v_test as
 select emp.deptno, v_emp.*
   from emp emp, v_emp_sal v_emp
  where emp.empno = v_emp.사원번호;

select * from v_test;	 

-- 실습. emp에서 부서번호, dept에서 dname, v_emp_sal와 join
-- 사원번호, 사원이름, 부서명, 직급, 급여 출력할 수 있는 join query를 작성하기
select * from V_EMP_SAL;
select * from emp;
select * from dept;

create or replace view v_test2 as 
select emp.deptno
     , dpt.dname
		 , sal.*
  from emp emp
	   , dept dpt
		 , v_emp_sal sal
 where emp.deptno = dpt.deptno
   and emp.empno = sal.사원번호;
 
select * from v_test2;

-- 7. inline view
-- 제약사항 : 한개의 컬럼만 정의할 수 있다.
select emp.ename
     , dpt.dname
  from emp emp
	   , dept dpt
 where emp.deptno = dpt.deptno;
 
select emp.ename
     , (select deptno, dname from dept dpt where emp.deptno = dpt.deptno) 
  from emp emp; --  too many values
 
select emp.ename
     , (select dname from dept dpt where emp.deptno = dpt.deptno) 부서번호
  from emp emp; 
 
select emp.ename
     , dpt.dname 부서번호
  from emp emp
	   , (select deptno, dname from dept dpt) dpt
  where emp.deptno = dpt.deptno
 
 -- 8. view 삭제하기
 drop view v_test2;
 select * from user_views;
 
-- 실습. emp와 dept를 조회 : 부서번호와 부서별최대급여 및 부서명을 조회
-- 1) view를 생성
-- 2) inline view로 작성
-- deptno, dname, max_sal :
-- view이름 : v_max_sal_01
create or replace view v_max_sal_01 as
select deptno
     , max(sal) 최대급여
  from emp
 group by deptno
 order by deptno;
 
select * from v_max_sal_01;

select d.deptno
     , d.dname
		 , m.최대급여
  from dept d
	   , v_max_sal_01 m
 where d.DEPTNO = m.DEPTNO;


create or replace view v_max_sal_02 as
select emp.deptno  부서번호
     , dpt.dname   부서이름
		 , max(sal)    최대급여
  from emp  emp
		 , dept dpt
 where emp.deptno = dpt.deptno
 group by emp.deptno, dpt.dname
 order by emp.deptno;

select * from v_max_sal_02;

-- inline view (sub query - inline view에 group by 사용)
create or replace view v_max_sal_03 as
select dpt.deptno
     , dpt.dname
		 , sal.max_sal
  from dept dpt
	   , (select deptno, sum(sal) as max_sal from emp group by deptno) sal
 where dpt.deptno = sal.deptno;

select * from v_max_sal_03;


-- inline view 
create or replace view v_max_sal_04 as
select dpt.deptno
     , dpt.dname
		 , nvl((select max(sal) from emp emp where dpt.deptno = emp.deptno group by deptno), 0) 부서별최대급여
  from dept dpt;	 

select * from v_max_sal_04;

/* 연습문제 */
-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회 View
select * from professor;
select * from department;

create or replace view v_prof_dept as 
select pro.profno
     , pro.name
		 , dpt.dname
  from professor 	pro
		 , department dpt
 where pro.deptno = dpt.deptno;

select * from v_prof_dept;

-- ex02) inline view를 사용, student, department를 사용 학과별로 
-- 학생들의 최대키, 최대몸무게, 학과명을 출력
select * from student;

create or replace view v_max_by_dept as
select dpt.deptno 학과번호
     , dpt.dname  학과명
		 , std.최대신장
		 , std.최대체중
  from department dpt
	   , (select deptno1
				     , max(height) 최대신장
						 , max(weight) 최대체중 
				  from student
				 group by deptno1) std
 where dpt.deptno = std.deptno1;	 
		 
select * from v_max_by_dept;

-- ex03) inline view를 사용, 학과명, 학과별최대키, 학과별로 가장 키가 큰 학생들의
-- 이름과 키를 출력
select deptno1
		 , max(height) 최대신장
		 , max(weight) 최대체중 
	from student
 group by deptno1

create or replace view v_max_by_std as
select std2.name
     , dpt.dname
		 , std1.최대신장
		 , std1.최대체중
  from (select deptno1
						 , max(height) 최대신장
						 , max(weight) 최대체중 
					from student
				 group by deptno1) std1
		 , student 		std2
		 , department dpt
 where std1.최대신장 = std2.height
   and std1.최대체중 = std2.weight
	 and std1.deptno1  = dpt.deptno;
	   
		 
select std2.name
     , dpt.dname
		 , std1.최대신장
		 , std1.최대체중
  from v_max_by_dept std1
		 , student 		std2
		 , department dpt
 where std1.최대신장 = std2.height
   and std1.최대체중 = std2.weight
	 and std1.학과번호  = dpt.deptno;		 

-- ex04) student에서 학생키가 동일학년의 평균키보다 큰 학생들의 학년과 이름과 키
-- 해당 학년의 평균키를 출력 단, inline view로
-- 1. 학년별 평균키
select std.grade
     , avg(std.height) avg_height
  from student std
 group by std.grade;

-- 2. 동일학년, 학생신장이 평큔키보다 큰 학생
select std.grade
     , std.name
		 , std.height
		 , grd.avg_height
  from student std
	   , (select std.grade, avg(std.height) avg_height from student std group by std.grade) grd
 where std.grade = grd.grade
	 and std.height > grd.avg_height
 order by std.grade;

create or replace view v_avg_by_grade as
select std.grade
     , std.name
		 , std.height
		 , grd.avg_height
  from student std
	   , (select std.grade
		         , avg(std.height) avg_height 
				  from student std 
				 group by std.grade) grd
 where std.grade = grd.grade
	 and std.height > grd.avg_height
 order by std.grade;

select * from v_avg_by_grade;

-- ex05) professor에서 교수들의 급여순위와 이름, 급여출력 단, 급여순위 1~5위까지
-- rownum
select pro.name
     , pro.pay
		 , rownum
	from professor pro
 order by pro.pay desc;
 
 select rownum, t1.* 
   from (select pro.name
						  , pro.pay
							, rownum
					 from professor pro
				  order by pro.pay desc) t1
	where rownum <= 5;


-- ex06) 교수번호정렬후 3건씩해서 급여합계와 급여평균을 출력
-- hint) 
select rownum, profno, pay, ceil(rownum/3) from professor; -- rollup

select profno
     , sum(pay)
		 , round(avg(pay), 1)
  from (select rownum num, profno, name, pay from professor)
 group by ceil(rownum/3), rollup(profno)
 order by ceil(rownum/3);
 
select profno
     , name
     , sum(pay)
		 , round(avg(pay), 1)
  from (select rownum num, profno, name, pay from professor)
 group by ceil(rownum/3), rollup(profno, name)
 order by ceil(rownum/3); 
 
select profno
     , name
		 , pay
     , sum(pay)
		 , round(avg(pay), 1)
  from (select rownum num, profno, name, pay from professor)
 group by ceil(rownum/3), rollup(profno, name, pay)
 order by ceil(rownum/3); 
 
select name
     , sum(pay)
		 , round(avg(pay), 1)
  from (select rownum num, profno, name, pay from professor)
 group by ceil(rownum/3), rollup(name)
 order by ceil(rownum/3);
 
-- materialized view
create MATERIALIZED view 뷰이름 
build immediate
refersh
on demand
....
as
select 문장