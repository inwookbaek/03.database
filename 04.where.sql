/*
	A. where 조건절
	
	1. 비교연산자
 
		=, 
		!=, <>
		>
		>=
		<
		<=
		
	2. 기타연산자
		a and b: 논리곱
		a or b : 논리합
		not a  : 부정 
		between A and B : a 와 b사이의 데이를 검색, a는 b보다 작은 값으로 정의
		in(a,b,c...)    : a,b,c..의 값을 가지고 있는 데이터를 검색
		like (%, _와 같이 사용) : 특정 패턴을 가지고 있는 데이터를 검색
				-> '%A' 끝이 A로 끝나는 데이터, 'A%' A로 시작, '%A%' A를 포함
		is null/ is not null : null값 여부를 가지고 있는 데이터를 검갯
		
*/

/* A. 비교연산자 */
-- 1. 급여(sal)가 5000인 사원 조회하기
select * from emp;
select * from emp where sal = 5000;
select * from emp where sal = 1600;

-- 2. 급여(sal)가 900 보다 작은 사원은?
select * from emp where sal < 900;
select * from emp where sal > 900;
select * from emp where sal >= 900;
select * from emp where sal <> 900;
select * from emp where sal != 900;

-- 3. 이름이 smith인 사원 조회하기
select * from emp where ename = 'smith';
select * from emp where ename = 'SMITH';
select * from emp where ename = SMITH; --(x) SMITH은 열이름으로 인식

-- 대소문자변환함수 upper(), lower()
select * from emp where ename = 'SMITH';
select ename from emp where ename = upper('smith');
select ename from emp where lower(ename) = 'smith';

-- 4. 입사일자(hiredate)
-- 입사일자가 1980-12-17인 사원을 조회
-- (hint) date타입은 비교할 때 문자열로 간주
select * from emp;

/* 연습문제 */
-- ex01) 급여가 1000보다 작은 사원만 출력하기(ename/sal/hiredate 만 출력)
-- ex02) 부서(dept)테이블에서 부서번호와, 부서명을 별칭으로 한 sql문을 작성
-- ex03) 사원테이블에서 직급만 출력하는데 중복되지 않게 출력하는 sql문
-- ex04) 급여가 800인 사원만 조회
-- ex05) 사원명이 BLAKE인 사원만 출력
-- ex06) 사원이름 JAMES~MARTIN사이의 사원을 사원번호, 사원명, 급여를 출력
-- and / between 두가지형태로 작성
 

