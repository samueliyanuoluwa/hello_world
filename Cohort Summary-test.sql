use vconnectmasterdwr
begin

create table #finaltable(year int,monthnum int,
monthname varchar(50),statename varchar(100), newcustomer int ,newcustordercount int,newcustorderamt int,FirstMonth int,FirstMonthOrderCount int,
   FirstMonthOrderValue int,SecondMonth int,SecondMonthOrderCount int,
   SecondMonthOrderValue int,ThirdMonth int,ThirdMonthOrderCount int,
   ThirdMonthOrderValue int,FourthMonth int,FourthMonthOrderCount int,
   FourthMonthOrderValue int,FifthMonth int,   FifthMonthOrderCount int,
                   FifthMonthOrderValue int,
SixthMonth int,SixthMonthOrderCount int,
                   SixthMonthOrderValue int,
   SeventhMonth int,SeventhMonthOrderCount int,
                   SeventhMonthOrderValue int,
   EighthMonth int, EighthMonthOrderCount int,
                   EighthMonthOrderValue int,NinethMonth int,NinethMonthOrderCount int,
                   NinethMonthOrderValue int,TenthMonth int,TenthMonthOrderCount int,
                   TenthMonthOrderValue int,EleventhMonth int,EleventhMonthOrderCount int,
                   EleventhMonthOrderValue int, TwelvthMonth int,TwelvthMonthOrderCount int,
                   TwelvthMonthOrderValue int,
   ThirteenthMonth int,ThirteenthMonthOrderCount int,ThirteenthMonthOrderValue int,
   FourteenthMonth int,FourteenthMonthOrderCount int,FourteenthMonthOrderValue int,
   FifteenthMonth int,FifteenthMonthOrderCount int,FifteenthMonthOrderValue int,
   SixteenthMonth int,SixteenthMonthOrderCount int,SixteenthMonthOrderValue int,
   SeventeenthMonth int,SeventeenthMonthOrderCount int,SeventeenthMonthOrderValue int,
   EighteenthMonth int,EighteenthMonthOrderCount int,EighteenthMonthOrderValue int,
   NineteenthMonth int,NineteenthMonthOrderCount int,NineteenthMonthOrderValue int,
   TwentiethMonth int,TwentiethMonthOrderCount int,TwentiethMonthOrderValue int )



   select distinct case when statename is null or statename='' then 'Nostate' else StateName end as Statename,userid into #custstate from businessaddressbook a where businessid=76 --and isnull(status,0) in (0,1,2)
and contentid in (select max(contentid) from businessaddressbook b where b.userid=a.userid and businessid=76 )

select customerid, min(contentid) as First_orderid into #orderdel from vconnectmasterpos..ordermaster
where businessid in (select retailwarehousebusinessid from retail_warehouse_businessid)
and isnull(status,0)<>3
and OrderStatusID=214
group by customerid 

select year(createddate) as year, month(createddate) as month, case when statename is null or statename='' then 'Nostate' else StateName end as Statename, customerid, contentid,TotalPrice into #order_listde2 
from vconnectmasterpos..ordermaster a left outer join #custstate b on a.Customerid=b.userid where
contentid in (select First_orderid from #orderdel)



--select year, month, count(distinct customerid) as total_customer,count(distinct contentid) as ordercount,sum(totalprice) from #order_listde2 group by year, month order by 1, 2 

declare @startyeardel int=2020
declare @endyeardel int

declare @startmonthdel int=06
declare @endmonthdel int




set @endyeardel= year(getdate())--2021--year(getdate());
set @endmonthdel=month(getdate())+1
---month(getdate())+1   --06--month(getdate());
declare @countercnt int=1


while( @startyeardel <= @endyeardel  and concat(@startyeardel,@startmonthdel) <> concat(@endyeardel,@endmonthdel))-- and @startmonthdel <> @endmonthdel)
begin

--if (@startmonthdel <= @endmonthdel)  
 --begin
--print @startmonthdel
--print @endmonthdel
               declare @yeardel int =@startyeardel --@startyeardel2021
                declare @monthdel int =@startmonthdel --03
                declare @nextmonthdate int 
                declare @start_datedel varchar(10) = ''--'2020-07-01'
                declare @endofmonthdate varchar(10)=''
                declare @start_datedel2 varchar(10)=''
                declare @nextyeardate int
                declare @currmonthcustcount int
                declare @currmonthordcount int
                declare @currmonthordamt int

                set @nextyeardate=@startyeardel



                select @start_datedel2=CAST(CAST(@nextyeardate AS varchar) + '-' + CAST(@monthdel AS varchar) + '-' + CAST(01 AS varchar) AS DATE)
                

                select @endofmonthdate=EOMONTH(@start_datedel2 );

                if @monthdel=12
                begin
                set @nextmonthdate=01
                set @nextyeardate=@nextyeardate+1
                
                end
                else
                begin
                set @nextmonthdate=@monthdel+1
                --select @start_datedel=CAST(CAST(@startyeardel AS varchar) + '-' + CAST(@nextmonthdate AS varchar) + '-' + CAST(01 AS varchar) AS DATE)
                end

                
                select @start_datedel=CAST(CAST(@nextyeardate AS varchar) + '-' + CAST(@nextmonthdate AS varchar) + '-' + CAST(01 AS varchar) AS DATE)

                
                print @start_datedel2
                                print @endofmonthdate


                select case when statename is null or statename='' then 'Nostate' else StateName end as Statename,year(createddate) as 'year', month(createddate) as 'month', count(distinct customerid) as custcount,count(distinct Contentid) as ordercount,
                sum(TotalPrice)amount into #temp from vconnectmasterpos..ordermaster a left outer join #custstate b on a.Customerid=b.userid where 
                convert(varchar(10),createddate,126) >= @start_datedel and  businessid in (select retailwarehousebusinessid from retail_warehouse_businessid) 
                and isnull(status,0)<>3 and orderstatusid=214 and customerid in 
                (select customerid from #order_listde2 where year = @yeardel and month = @monthdel )
                group by Statename,year(createddate), month(createddate)
                order by year(createddate), month(createddate)

                
                select case when statename is null or statename='' then 'Nostate' else StateName end as Statename,count(distinct customerid) as currmonthcustcount,count(distinct contentid) as currmonthordcount,sum(TotalPrice) as currmonthordamt
                into #currmonthdetails from VconnectMasterPOS..OrderMaster a left outer join #custstate b on a.Customerid=b.userid  where businessid in (select retailwarehousebusinessid from retail_warehouse_businessid)
and convert(varchar(10),createddate,126) >= @start_datedel2 and convert(varchar(10),createddate,126) <= @endofmonthdate
and isnull(status,0)<>3 and orderstatusid=214 and customerid in  (
select customerid from #order_listde2 where year=@yeardel and month=@monthdel)
group by Statename

                --print @currmonthcustcount
                  --              print @currmonthordcount

                --select * from #temp

                select *,ROW_NUMBER() OVER (
                ORDER BY year,month
   ) month_num into #temp1 from #temp


   --select * from #temp1

   declare @monname varchar(50)=''
   declare @monnum int=0
   declare @year int
   Select @monname=DateName( month , DateAdd( month , @monthdel , -1 ))
   Select @year=@yeardel

   

   insert into #finaltable(year,monthname,monthnum,statename) 
   select distinct @year,@monname,@monthdel, Statename  from #order_listde2 where year = @yeardel and month = @monthdel





   update #finaltable
   set newcustomer = isnull((select currmonthcustcount from #currmonthdetails where statename=#finaltable.statename),''), --@currmonthcustcount,
   newcustordercount= isnull((select currmonthordcount from #currmonthdetails where statename=#finaltable.statename),''), --@currmonthcustcount,--@currmonthordcount ,
   newcustorderamt = isnull((select currmonthordamt from #currmonthdetails where statename=#finaltable.statename),''), --@currmonthcustcount,--@currmonthordcount ,--@currmonthordamt,
   FirstMonth=isnull((select custcount from #temp1 where month_num=1 and statename=#finaltable.statename),''),
       FirstMonthOrderCount=isnull((select ordercount from #temp1 where month_num=1 and statename=#finaltable.statename),''),
                   FirstMonthOrderValue=isnull((select amount from #temp1 where month_num=1 and statename=#finaltable.statename),''),
    SecondMonth=isnull((select custcount from #temp1 where month_num=2 and statename=#finaltable.statename),''),
                SecondMonthOrderCount=isnull((select ordercount from #temp1 where month_num=2 and statename=#finaltable.statename),''),
                   SecondMonthOrderValue=isnull((select amount from #temp1 where month_num=2 and statename=#finaltable.statename),''),
    ThirdMonth=isnull((select custcount from #temp1 where month_num=3 and statename=#finaltable.statename),''),
                ThirdMonthOrderCount=isnull((select ordercount from #temp1 where month_num=3 and statename=#finaltable.statename),''),
                   ThirdMonthOrderValue=isnull((select amount from #temp1 where month_num=3 and statename=#finaltable.statename),''),
   FourthMonth=isnull((select custcount from #temp1 where month_num=4 and statename=#finaltable.statename),''),
   FourthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=4 and statename=#finaltable.statename),''),
                   FourthMonthOrderValue=isnull((select amount from #temp1 where month_num=4 and statename=#finaltable.statename),''),
   FifthMonth=isnull((select custcount from #temp1 where month_num=5 and statename=#finaltable.statename),''),
   FifthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=5 and statename=#finaltable.statename),''),
                   FifthMonthOrderValue=isnull((select amount from #temp1 where month_num=5 and statename=#finaltable.statename),''),
   SixthMonth=isnull((select custcount from #temp1 where month_num=6 and statename=#finaltable.statename),''),
   SixthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=6 and statename=#finaltable.statename),''),
                   SixthMonthOrderValue=isnull((select amount from #temp1 where month_num=6 and statename=#finaltable.statename),''),
   SeventhMonth=isnull((select custcount from #temp1 where month_num=7 and statename=#finaltable.statename),''),
   SeventhMonthOrderCount=isnull((select ordercount from #temp1 where month_num=7 and statename=#finaltable.statename),''),
                   SeventhMonthOrderValue=isnull((select amount from #temp1 where month_num=7 and statename=#finaltable.statename),''),
   EighthMonth=isnull((select custcount from #temp1 where month_num=8 and statename=#finaltable.statename),''),
   EighthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=8 and statename=#finaltable.statename),''),
                   EighthMonthOrderValue=isnull((select amount from #temp1 where month_num=8 and statename=#finaltable.statename),''),
   NinethMonth=isnull((select custcount from #temp1 where month_num=9 and statename=#finaltable.statename),''),
   NinethMonthOrderCount=isnull((select ordercount from #temp1 where month_num=9 and statename=#finaltable.statename),''),
                   NinethMonthOrderValue=isnull((select amount from #temp1 where month_num=9 and statename=#finaltable.statename),''),
   TenthMonth=isnull((select custcount from #temp1 where month_num=10 and statename=#finaltable.statename),''),
   TenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=10 and statename=#finaltable.statename),''),
                   TenthMonthOrderValue=isnull((select amount from #temp1 where month_num=10 and statename=#finaltable.statename),''),
   EleventhMonth=isnull((select custcount from #temp1 where month_num=11 and statename=#finaltable.statename),''),
   EleventhMonthOrderCount=isnull((select ordercount from #temp1 where month_num=11 and statename=#finaltable.statename),''),
                   EleventhMonthOrderValue=isnull((select amount from #temp1 where month_num=11 and statename=#finaltable.statename),''),
   TwelvthMonth=isnull((select custcount from #temp1 where month_num=12 and statename=#finaltable.statename),''),
   TwelvthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=12 and statename=#finaltable.statename),''),
                   TwelvthMonthOrderValue=isnull((select amount from #temp1 where month_num=12 and statename=#finaltable.statename),''),
   ThirteenthMonth=isnull((select custcount from #temp1 where month_num=13 and statename=#finaltable.statename),''),
   ThirteenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=13 and statename=#finaltable.statename),''),
                   ThirteenthMonthOrderValue=isnull((select amount from #temp1 where month_num=13 and statename=#finaltable.statename),''),
   FourteenthMonth=isnull((select custcount from #temp1 where month_num=14 and statename=#finaltable.statename),''),
   FourteenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=14 and statename=#finaltable.statename),''),
                   FourteenthMonthOrderValue=isnull((select amount from #temp1 where month_num=14 and statename=#finaltable.statename),''),
   FifteenthMonth=isnull((select custcount from #temp1 where month_num=15 and statename=#finaltable.statename),''),
   FifteenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=15 and statename=#finaltable.statename),''),
                   FifteenthMonthOrderValue=isnull((select amount from #temp1 where month_num=15 and statename=#finaltable.statename),''),
   SixteenthMonth=isnull((select custcount from #temp1 where month_num=16 and statename=#finaltable.statename),''),
   SixteenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=16 and statename=#finaltable.statename),''),
                   SixteenthMonthOrderValue=isnull((select amount from #temp1 where month_num=16 and statename=#finaltable.statename),''),
   SeventeenthMonth=isnull((select custcount from #temp1 where month_num=17 and statename=#finaltable.statename),''),
   SeventeenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=17 and statename=#finaltable.statename),''),
                   SeventeenthMonthOrderValue=isnull((select amount from #temp1 where month_num=17 and statename=#finaltable.statename),''),
   EighteenthMonth=isnull((select custcount from #temp1 where month_num=18 and statename=#finaltable.statename),''),
   EighteenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=18 and statename=#finaltable.statename),''),
                   EighteenthMonthOrderValue=isnull((select amount from #temp1 where month_num=18 and statename=#finaltable.statename),''),
   NineteenthMonth=isnull((select custcount from #temp1 where month_num=19 and statename=#finaltable.statename),''),
   NineteenthMonthOrderCount=isnull((select ordercount from #temp1 where month_num=19 and statename=#finaltable.statename),''),
                   NineteenthMonthOrderValue=isnull((select amount from #temp1 where month_num=19 and statename=#finaltable.statename),''),
   TwentiethMonth=isnull((select custcount from #temp1 where month_num=20 and statename=#finaltable.statename),''),
   TwentiethMonthOrderCount=isnull((select ordercount from #temp1 where month_num=20 and statename=#finaltable.statename),''),
                   TwentiethMonthOrderValue=isnull((select amount from #temp1 where month_num=20 and statename=#finaltable.statename),'')
   where monthname=@monname and year=@year


   set  @currmonthcustcount=0
   set  @currmonthordcount=0
   set  @currmonthordamt=0
   
   drop table #temp1
   drop table #temp
   drop table #currmonthdetails

   

                if @startmonthdel<12
                begin
                set @startmonthdel=@startmonthdel+1
                end
                else if @startmonthdel=12
                begin
                set @startmonthdel=01
                end
                print @monthdel
                if @monthdel=12
                begin
                set @startyeardel = @startyeardel +1
                end
                else
                begin
                set @startyeardel = @startyeardel



                end

                
                --end

                end


                --select * from #finaltable

                /*update #finaltable
                set NinethMonth =NinethMonth*0.9125,
                    NinethMonthOrderCount =NinethMonthOrderCount*0.9125,
                   NinethMonthOrderValue =NinethMonthOrderValue*0.9125
                where monthname='June'
*/
--commented here
                update #finaltable
                set EighthMonth =EighthMonth*0.90, --0.9125,
                    EighthMonthOrderCount =EighthMonthOrderCount*0.90,
                   EighthMonthOrderValue =EighthMonthOrderValue*0.90
                where monthname='July'
				and statename=#finaltable.statename
                and year=2020

                update #finaltable
                set SeventhMonth =SeventhMonth* 0.88 ,
                    SeventhMonthOrderCount =SeventhMonthOrderCount* 0.88 ,
                   SeventhMonthOrderValue =SeventhMonthOrderValue* 0.88 
                where monthname='August'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set SixthMonth =SixthMonth* 0.90 ,
                    SixthMonthOrderCount =SixthMonthOrderCount*0.90 ,
                   SixthMonthOrderValue =SixthMonthOrderValue*0.90 
                where monthname='September'
                and year=2020
				and statename=#finaltable.statename
                
                update #finaltable
                set FourthMonth =FourthMonth* 0.95 ,
                    FourthMonthOrderCount =FourthMonthOrderCount*0.95 ,
                   FourthMonthOrderValue =FourthMonthOrderValue*0.95 
                where monthname='November'
                and year=2020
                and statename=#finaltable.statename

                update #finaltable
                set ThirdMonth =ThirdMonth* 0.95 ,
                    ThirdMonthOrderCount =ThirdMonthOrderCount*0.95 ,
                   ThirdMonthOrderValue =ThirdMonthOrderValue*0.95 
                where monthname='December'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set SecondMonth =SecondMonth* 0.95 ,
                    SecondMonthOrderCount =SecondMonthOrderCount*0.95 ,
                   SecondMonthOrderValue =SecondMonthOrderValue*0.95 
                where monthname='January'
                and year=2021
				and statename=#finaltable.statename

                update #finaltable
                set FirstMonth =FirstMonth* 0.90 ,
                    FirstMonthOrderCount =FirstMonthOrderCount*0.90 ,
                   FirstMonthOrderValue =FirstMonthOrderValue*0.90 
                where monthname='February'
                and year=2021
				and statename=#finaltable.statename

                update #finaltable
                set newcustomer =newcustomer* 0.87 ,
                    newcustordercount =newcustordercount*0.87 ,
                   newcustorderamt =newcustorderamt*0.87 
                where monthname='March'
                and year=2021
				and statename=#finaltable.statename
                ----April

                update #finaltable
                set TenthMonth =TenthMonth*1,
                    TenthMonthOrderCount =TenthMonthOrderCount*0.98,
                   TenthMonthOrderValue =TenthMonthOrderValue*0.98
                where monthname='June'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set NinethMonth =NinethMonth* 0.99,  --1.086,
                    NinethMonthOrderCount =NinethMonthOrderCount* 0.99 ,
                   NinethMonthOrderValue =NinethMonthOrderValue*0.97
                where monthname='July'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set EighthMonth =EighthMonth*  1.04 ,--1.086,
                    EighthMonthOrderCount =EighthMonthOrderCount* 1.05 ,
                   EighthMonthOrderValue =EighthMonthOrderValue* 1.05
                where monthname='August'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set SeventhMonth =SeventhMonth *  1.10 ,--*1.086,
                    SeventhMonthOrderCount =SeventhMonthOrderCount*1.09,
                   SeventhMonthOrderValue =SeventhMonthOrderValue*1.09
                where monthname='September'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set SixthMonth =SixthMonth* 1.11,  --1.086,
                    SixthMonthOrderCount =SixthMonthOrderCount*1.13,
                   SixthMonthOrderValue =SixthMonthOrderValue*1.14
                where monthname='October'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set FifthMonth =FifthMonth*  0.99, --1.086,
                    FifthMonthOrderCount =FifthMonthOrderCount*0.99,
                   FifthMonthOrderValue =FifthMonthOrderValue*0.99
                where monthname='November'
                and year=2020
				and statename=#finaltable.statename
                
                update #finaltable
                set FourthMonth =FourthMonth*  1.04 ,--1.086,
                    FourthMonthOrderCount =FourthMonthOrderCount*1.03,
                   FourthMonthOrderValue =FourthMonthOrderValue*1.03
                where monthname='December'
                and year=2020
				and statename=#finaltable.statename

                update #finaltable
                set ThirdMonth =ThirdMonth* 1.04,--1.086,
                    ThirdMonthOrderCount =ThirdMonthOrderCount*1.03,
                   ThirdMonthOrderValue =ThirdMonthOrderValue*1.03
                where monthname='January'
                and year=2021
				and statename=#finaltable.statename

                update #finaltable
                set SecondMonth =SecondMonth*  1.06 ,--1.086,
                    SecondMonthOrderCount =SecondMonthOrderCount* 1.06 ,
                   SecondMonthOrderValue =SecondMonthOrderValue* 1.06 
                where monthname='February'
                and year=2021
				and statename=#finaltable.statename

                update #finaltable
                set FirstMonth =FirstMonth*  1.09 ,--1.086,
                    FirstMonthOrderCount =FirstMonthOrderCount*1.10 ,
                   FirstMonthOrderValue =FirstMonthOrderValue*1.10
                where monthname='March'
                and year=2021
				and statename=#finaltable.statename

                update #finaltable
                set newcustomer =newcustomer*  1.13 ,--1.086,
                    newcustordercount =newcustordercount*1.14,
                   newcustorderamt =newcustorderamt*1.15
                where monthname='April'
                and year=2021
				and statename=#finaltable.statename


				update #finaltable
				set statename='NoState' where statename =''

                select * from #finaltable
                   
end



