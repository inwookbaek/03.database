/*
	Function?
	
	1. function
	
	   보통의 경우 값을 계산하고 그 결과를 반환하기 위해서 function을 사용한다. 
		 대부분 prodedure과 유사하지만
		 
		 1) in 파라미터만 사용할 수 있다.
		 2) 반드시 반환될 값의 데이터 타입을 return문안에 선언해야 한다.
	
	2. 문법
	
	   1) pl/sql 블럭안에는 적어도 한개의 return문이 있어야 한다.
		 2) 선언방법
		 
		    create or replace function 펑션이름(arg1 in 데이타입, ...) 
				return 데이터타입 is[as]
					변수선언...
				[pragma autonomous_transaction]
				begin
				end 펑션이름;
				
	3. 주의사항
	
		 오라클함수 즉, function에서는 기본적으로 DML(insert, update, delete)문을 사용할 수 없다.
		 만약에 사용하고자 할 경우 begin 바로 위에 pragma autonomous_transaction을 선언하면 사용
		 할 수 있다.
		 
  4. procedure vs function
	
	   procedure                            function
		 ---------------------------          -------------------------
		 서버에서 실행(속도가 빠름)           클라이언트에서 시랭
		 return값이 있어도 되고 없어도 된다.  return값이 필수
		 return값이 여러개(out여러개)         return값이 하나만 가능
		 파라미터는 in, out                   in만 있다
		 select절에는 사용불가                selcet에서 사용 가능
		    --> call , execute                   --> select 펑션() from dual;
*/
-- 실습1. 사원번호를 입력받아서 급여를 10% 인상하는 함수작성하기
create or replace function fn_01(p_empno in number) return number is
	v_sal 	number;
pragma autonomous_transaction;	
begin 
	update emp
	   set sal = sal * 1.1
	 where empno = p_empno;
	 
	 commit;
	 
	 select sal
		 into v_sal
		 from emp
	 	where empno = p_empno;
		
		return v_sal;
end fn_01;

select * from emp; -- 968
select sum(sal) from emp;
select fn_01(7369) from dual;
-- call fn_01(7369); procedure는 call로 호출이 가능하지만 fucntion할 수 없다.

-- 실습2. 부피를 계산하는 함수 fn_02
-- 부피 = 길이 * 넓이 * 높이 
create or replace function fn_02(p_length in number, p_width in number, p_height in number) return number is
	v_result    number;
begin
	v_result := p_length * p_width * p_height;
	return v_result;
end fn_02;
select fn_02(10,10,10) from dual;
select fn_02(32133,321310,1220) from dual;
-- sql*plus : execute fn_02(10,10,10);

-- 실습3. 현재일을 입력받아서 해당월의 마지막일자를 구하는 함수
create or replace function fn_03(p_date in date) return date as
	v_result   date;
begin
	v_result := add_months(p_date, 1) - to_char(p_date, 'DD');
	return v_result;
end fn_03;
select fn_03(sysdate) from dual;

-- 실습4. '홍길동'문자열을 전달받아서 '길동'만 리턴하는 함수 fn_04
create or replace function fn_04(p_name in varchar2) return varchar2 is
	v_result   varchar2(20);
begin
	v_result := substr(p_name, 2);
	return v_result;
end fn_04;
select fn_04('홍길동') from dual;
select ename, fn_04(ename) from emp;

-- 실습5. fn_05: 현재일 입력받아서 '2023년 04월 03일'의 형태로 리턴
create or replace function fn_05(p_date in date) return varchar2 is
	v_result   varchar2(30);
begin
	v_result := to_char(p_date, 'yyyy"년" MM"월" dd"일"');
	return v_result;
end fn_05;

select fn_05(sysdate) from dual;
select name, fn_05(hiredate) from professor;

-- 실습06. fn_06: jumin번호를 입력받아서 남자 or 여자를 구분하는 리턴 함수
select * from student;
create or replace function fn_06(p_ssn in varchar2) return varchar2 is
	v_result   varchar2(10);
begin
	v_result := substr(p_ssn, 7, 1);
	
	if v_result in ('1', '3')
		then v_result := '남자';
		else v_result := '여자';
	end if;
	
	return v_result;
end fn_06;
select fn_06('9511181000000') from dual union all
select fn_06('9511182000000') from dual union all
select fn_06('9511183000000') from dual union all
select fn_06('9511184000000') from dual;

select name, fn_06(jumin), fn_05(birthday) from student;

-- 실습07 fn_07: professor에서 hiredate를 현재일기준으로 근속년월을 계산함수
-- hint) 근속년 floor(months_between()), 근속월ceil(months_between()) -> 12년 5개월
create or replace function fn_07(p_hiredate in date) return varchar2 is
	v_result   varchar2(20);
begin
	v_result := floor(months_between(sysdate, p_hiredate) / 12)  || '년 '
				        || ceil(mod(months_between(sysdate, p_hiredate), 12)) || '개월';
	return v_result;
end fn_07;

select sysdate
		 , months_between(sysdate, '20200101') / 12
		 , floor(months_between(sysdate, '20200101') / 12) 년
		 , ceil(mod(months_between(sysdate, '20200101'), 12)) 월
		 , mod(3, 2)
  from dual;

select fn_07('20200101') from dual;
select name, hiredate, fn_07(hiredate) from professor;
select ename, hiredate, fn_07(hiredate) from emp;
