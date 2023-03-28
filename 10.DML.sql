/* DML

	1. insert : 테이블에 데이터를 추가
	2. update : 테이블에 데이터를 수정
	3. delete : 테이블에 데이터를 삭제
	4. merge  : 2개이상의 테이블을 한개의 테이블로 병합
*/

/* A. insert 
	
	1. 테이블에 새로운 행(row, record)를 추가할 때 사용하는 명령
	2. 테이블에 새로운 데이터를 입력(추가)하기 위한 데이터조작어
	3. 문법
	
	   1) insert into 테이블명 (컬럼1...컬럼n) values(값1...값n);
		 2) insert into 테이블명 values(값1...값n);
		 3) 서브쿼리를 이용해서 기존 테이블에 데이터를 추가하는 방법
		    ... insert into 테이블명 select 컬럼1...컬럼n 테이블명 where ....
				... 동일갯수, 동일순서, 동일데이터타입일 경우에 사용가능
		 4) insert all
		           when 조건 then into
							 when 조건 then into 
		 5) insert all
		           into 테이블명 values()
							 into 테이블명 values()
*/
-- 1. 레코드추가
-- 실습1. dept2에 추가해 보기
-- 1) 부서번호=9000, 부서명=태스트부서_1, 상위부서=1006, 지역=기타지역
-- 2) 부서번호=9001, 부서명=태스트부서_2, 상위부서=1006, 지역=기타지역
-- 3) 부서번호=9001, 부서명=태스트부서_3, 상위부서=1006, 지역=기타지역 -- 추가여부확인!!!
select * from dept2;
insert into dept2(dcode, dname, pdept, area) values(9000, '테스트부서_1', 1006, '기타지역');
insert into dept2 values(9001, '테스트부서_2', 1006, '기타지역');
insert into dept2 values(9001, '테스트부서_3', 1006, '기타지역'); -- unique constraint violated

-- 실습2. professor에 교수번호=5001, 교수명=홍길동, id=hong, position=정교수, 급여=510, 입사일=오늘
select * from professor;
insert into professor(profno, name, id, position, pay, hiredate)
       values(5001, '홍길동', 'hong', '정교수', 510, sysdate);

-- 실습3. 
-- 1) professor의 구조만 복사해서 professor4
-- 2) professor에서 profno가 4000보다 큰 교수만 professor4에 추가
create table professor4 as select * from professor where 1=2;
select * from professor4;
insert into professor4 select * from professor where profno > 4000;
select * from professor4;

-- 실습4.
-- professor을 기준으로 prof_3과 prof_4테이블을 생성
-- 1) 각각 profno number, name varchar2(25)의 2개의 컬럼만 존재하는 테이블 생성
-- 2) prof-3에는 1000~1999번까지의 교수만
-- 3) prof-4에는 2000~2999번까지의 교수만 복사
create table prof_3 (profno number, name varchar2(25));
create table prof_4 as select * from prof_3 where 1=2;

insert into prof_3 select profno, name from professor where profno between 1000 and 1999;
insert into prof_4 select profno, name from professor where profno between 2000 and 2999;

select * from prof_3;
select * from prof_4;

-- 2. insert all(1)
drop table prof_3;
drop table prof_4;

create table prof_3 (profno number, name varchar2(25));
create table prof_4 as select * from prof_3 where 1=2;

insert all
  when profno between 1000 and 1999 then into prof_3 values(profno, name)
	when profno between 2000 and 2999 then into prof_4 values(profno, name)
select * from professor;

select * from prof_3;
select * from prof_4;

-- 3. insert all(2)
-- 동일자료를 각각 다른 테이블에 추가하는 방법
drop table prof_3;
drop table prof_4;

create table prof_3 (profno number, name varchar2(25));
create table prof_4 as select * from prof_3 where 1=2;

insert all
  into prof_3 values(profno, name)
  into prof_4 values(profno, name)
select profno, name from professor
 where profno between 3000 and 3999;

select * from prof_3;
select * from prof_4;

/* B. update

	1. 테이블에 있는 데이터를 수정하기 위해서 사용되는 명령
	2. 기존의 행 or 열을 수정하기 위해서 사용
	3. 주의할 점 where 조건절에 특정의 조건을 정의하지 않을 경우 전체 데이터가 수정이 된다.
	4. 문법
		  
			update 테이블명
			   set 컬럼 = 값
			 where 조건절
*/
drop table emp999;
create table emp999 as select * from emp;
select * from emp999;

-- update 주의할 점
update emp999
   set ename = '스미스';

-- 1. 전체 사원의 부서번호를 10, 급여를 0으로 수정하기
update emp999
   set deptno = 10, 
	     sal = 0;

select * from emp999;

drop table emp999;
create table emp999 as select * from emp;
select * from emp999;

-- 실습1. 전체 사원의 급여를 10% 인상하기
select sal * 1.1 "10% 인상급여" from emp999;
select * from emp999;

-- 실습2. 모든 사원의 입사일을 현재일로 수정하기(sysdate)

-- professor4로 테이블을 생성한 후에 
-- 실습3. professor에서 직급이 assistant professor인 사람의 보너스를 200으로 인상하기
-- 실습4. professor에서 Sharon Stone과 직급이 동일한 교수들의 급열르 15%인상하기
-- hint) 서브쿼리를 이용 where절에 서브쿼리를 지정  
--  where position = (select from profeessor where name 샤론스톤의 position)   























