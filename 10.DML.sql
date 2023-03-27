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






