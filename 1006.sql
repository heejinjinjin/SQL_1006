create or replace procedure interest
as
    myInterest numeric;
    price numeric;
    cursor interestCursor is select saleprice from orders;
begin
    myInterest := 0.0;
    open interestCursor;
    loop
        fetch interestCursor into price;
        exit when interestCursor%NOTFOUND;
        if price >= 30000 then
            myInterest := myInterest + price*0.1;
        else
            myInterest := myInterest + price*0.05;
        end if;
    end loop;
    close interestCursor;
    DBMS_OUTPUT.PUT_LINE('전체 이익금액 = ' || round(myInterest, 3));
end;

set serveroutput on;
exec interest;

create table book_log(
    bookid_l number,
    bookname_l varchar2(40),
    publisher_l varchar2(40),
    price_l number
);

create or replace trigger afterinsertbook
after insert on book for each row
declare
    aveage number;
begin
    insert into book_log 
    values (:new.bookid, :new.bookname, :new.publisher, :new.price);
    DBMS_OUTPUT.PUT_LINE('삽입 행을 book_log 테이블에 백업했습니다.');
end;

insert into book values(17, '과학좋아요', '과학미디어', 25000);

select * from book where bookid = 17;
select * from book_log where bookid_l = 17;

-- 사용자 정의 함수 만들기
create or replace function fnc_interest (price number)
                            return int
is
    myInterest number;
begin
    if price >= 30000 then
        myInterest := price*0.1;
    else
        myInterest := price*0.05;
    end if;
    return myInterest;
end;

-- 실행할 때 블럭설정하고 실행
select custid, orderid, saleprice, fnc_interest(saleprice) 이익금 from orders;

-- insertcustomer 프로시저를 작성하시오
create or replace PROCEDURE INSERTCUSTOMER (
    myCustId in number,
    myName in varchar2,
    myAddress in varchar2,
    myPhone in varchar2)
AS 
BEGIN
  insert into customer(custid, name, address, phone)
  values(myCustId, myName, myAddress, myPhone);
END INSERTCUSTOMER;

exec insertcustomer(6, '명라멜', '서울 이태원 보광동', '010-1234-1234');
exec insertcustomer(7, '서지니', '서울특별시 강동구', '010-0000-4000');

select * from customer;