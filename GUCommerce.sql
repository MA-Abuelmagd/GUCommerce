Create DataBase GUCommerce;
Create Table Users(
	username Varchar(200) Primary Key,
	first_name Varchar(50),
	last_name Varchar(50),
	password Varchar(20),
	email Varchar(50)
);
Create Table User_mobile_numbers(
	mobile_number Varchar(20),
	username Varchar(200),
	Primary Key(mobile_number,username),
	Foreign Key(username) References Users on Delete Cascade on Update Cascade
);
Create Table User_Addresses(
	address Varchar(500),
	username Varchar(200),
	Primary Key(username,address),
	Foreign Key(username) References Users on Delete Cascade on Update Cascade
);
Create Table Customer(
	points Int Default '0',
	username Varchar(200),
	Foreign Key(username) References Users on Delete Cascade on Update Cascade,
	Primary Key(username)
);
Create Table Admins(
	username Varchar(200) Primary Key,
	Foreign Key(username) References Users on Delete Cascade on Update Cascade
);
Create Table Vendor(
	username Varchar(200) Primary Key,
	activated Bit Default '0',
	company_name Varchar(20),
	bank_acc_no Varchar(20),
	admin_username Varchar(200),
	Foreign Key(username) References Users on Delete Cascade on Update Cascade,
	Foreign Key(admin_username) References Admins on Delete No Action on Update No action --Delete and update manually
);
Create Table Delivery_Person(
	username Varchar(200) Primary Key,
	is_activated Bit Default '0',
	Foreign Key(username) References Users on Delete Cascade on Update Cascade
);
Create Table Credit_Card(
	number Varchar(30) Primary Key,
	expiry_date DATE,
	cvv_code Varchar(20)
);
Create Table Delivery(
	id INT Primary Key IDENTITY,
	type Varchar(20),
	time_duration Int,
	fees Decimal(5,3),
	username Varchar(200),
	Foreign Key(username) References Admins on Delete Cascade on Update Cascade
);
Create Table GiftCard(
	code Varchar(20) Primary Key,
	expiry_date Date,
	amount Int,
	username Varchar(200),
	Foreign Key(username) References Admins on Delete Cascade on Update Cascade
);
Create Table Orders(
	order_no Int Primary Key Identity,
	total_amount Decimal(10,3),
	order_date Date,
	cash_amount Decimal(10,3),
	credit_amount Decimal(10,3),
	payment_type Varchar(20),
	order_status Varchar(50) Default 'Not Processed',
	remaining_days Int,
	time_limit Int,
	GiftCardCodeUsed Varchar(20),
	customer_name Varchar(200),
	delivery_id Int,
	CreditCard_number Varchar(30),
	Foreign Key(CreditCard_number) References Credit_Card on Delete Cascade on Update Cascade,
	Foreign Key(GiftCardCodeUsed) References GiftCard on Delete Cascade on Update Cascade,
	Foreign Key(customer_name) References Customer on Delete No Action on Update No Action, --Delete and update manually
	Foreign Key(delivery_id) References Delivery on Delete No Action on Update No Action --Delete and update manually
);
Create Table Products(
	serial_no Int Primary Key IDENTITY,
	product_name Varchar(50),
	category Varchar(20),
	product_description Varchar(1000),
	price Decimal(10,2),
	final_price Decimal(10,2),
	color Varchar (20),
	available Bit,
	rate int,
	vendor_username Varchar(200),
	customer_username Varchar(200),
	customer_order_id Int,
	Foreign Key(vendor_username) References Vendor on Delete No Action on Update No Action, --Delete and update manually
	Foreign Key(customer_username) References Customer on Delete No Action on Update No Action, --Delete and update manually
	Foreign Key(customer_order_id) References Orders on Delete No Action on Update No Action
);
Create Table CustomerAddstoCartProduct(
	serial_no Int,
	customer_username Varchar(200),
	Primary Key(serial_no,customer_username),
	Foreign Key(serial_no) References Products on Delete Cascade on Update Cascade,
	Foreign Key(customer_username) References Customer on Delete No Action on Update No Action --Delete and update manually
);
Create Table Todays_Deals(
	deal_id Int Primary Key Identity,
	deal_amount Int,
	expiry_date Date,
	admin_username Varchar(200),
	Foreign Key(admin_username) References Admins on Delete Cascade on Update Cascade
);
Create Table Todays_Deals_Products(
	deal_id Int,
	serial_no Int,
	Primary Key(deal_id, serial_no),
	Foreign Key(deal_id) References Todays_Deals on Delete Cascade on Update Cascade,
	Foreign Key(serial_no) References Products on Delete No Action on Update No Action --Delete and update manually
);
Create Table offer(
	offer_id Int Primary Key Identity,
	offer_amount int,
	expiry_date Date
);
Create Table offersOnProduct(
	offer_id Int,
	serial_no Int,
	Primary Key(offer_id,serial_no),
	Foreign Key(offer_id) References Offer on Delete Cascade on Update Cascade,
	Foreign Key(serial_no) References Products on Delete Cascade on Update Cascade
);
Create Table Customer_Question_Product(
	serial_no Int,
	customer_name Varchar(200),
	question Varchar(100),
	answer Varchar(500),
	Primary Key(serial_no,customer_name),
	Foreign Key(serial_no) References Products on Delete Cascade on Update Cascade,
	Foreign Key(customer_name) References Customer on Delete No Action on Update No Action --delete and update manualy
);
Create Table Wishlist(
	username Varchar(200),
	name Varchar(100),
	Primary Key(username,name),
	Foreign Key(username) References Customer on Delete Cascade on Update Cascade
);
Create Table Wishlist_Product(
	username Varchar(200),
	wish_name Varchar(100),
	serial_no int,
	Primary Key(username, wish_name, serial_no),
	Foreign Key(username,wish_name) References Wishlist on Delete Cascade on Update Cascade,
	Foreign Key(serial_no) References Products on Delete No Action on Update No Action --Delete and update manually
);
Create Table Admin_Customer_Giftcard(
	code Varchar(20),
	customer_username Varchar(200),
	admin_username Varchar(200),
	remaining_points Int,
	Primary Key(code, customer_username, admin_username),
	Foreign Key(code) References GiftCard on Delete Cascade on Update Cascade,
	Foreign Key(customer_username) References Customer on Delete No Action on Update No Action, --Delete and update manually
	Foreign Key(admin_username) References Admins on Delete No Action on Update No Action --Delete and update manually
);
Create Table Admin_Delivery_Order(
	delivery_username Varchar(200),
	order_no Int,
	admin_username Varchar(200),
	delivery_window VarchAr(100),
	Primary Key(delivery_username,order_no),
	Foreign Key(delivery_username) References Delivery_Person on Delete Cascade on Update Cascade,
	Foreign Key(order_no) References Orders on Delete No Action on Update No Action, --Delete and update manually
	Foreign Key(admin_username) References Admins on Delete No Action on Update No Action --Delete and update manually
);
Create Table Customer_CreditCard(
	customer_name Varchar(200),
	cc_number Varchar(30),
	Primary Key(customer_name,cc_number),
	Foreign Key(customer_name) References Customer on Delete Cascade on Update Cascade,
	Foreign Key(cc_number) References Credit_Card on Delete Cascade on Update Cascade
);
------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------Procedures---------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------Regesteration-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
Go;
Create Proc customerRegister
	@username Varchar(20),
	@first_name Varchar(20),
	@last_name Varchar(20),
	@password Varchar(20),
	@email Varchar(50)
	AS
	Begin
		IF Not Exists(Select username
			From Users
			Where Users.username = @username)
			Begin
				Insert Into Users(username,first_name,last_name,password,email) 
					Values(@username,@first_name,@last_name,@password,@email);
				Insert Into Customer(username) Values(@username);
			End
		Else
			print'Username Already Taken';
	End
Go;
Create Proc vendorRegister
	@username Varchar(20),
	@first_name Varchar(20),
	@last_name Varchar(20),
	@password Varchar(20),
	@email Varchar(50),
	@company_name Varchar(20),
	@bank_acc_no Varchar(20)
	AS
	Begin
		IF Not Exists(Select username
			From Users
			Where Users.username = @username)
			Begin
				Insert Into Users(username,first_name,last_name,password,email) 
					Values(@username,@first_name,@last_name,@password,@email);
				Insert Into Vendor(username, bank_acc_no, company_name)
					Values(@username, @bank_acc_no, @company_name);
			End
		Else
			print'Username Already Taken';
	End
drop Table Todays_Deals_Products;
------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------Users-----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--a)
Go;
Create Procedure userLogin
	@username Varchar(20),
	@password Varchar(20),
	@success Bit Output,
	@type Int Output
	AS
	Begin
		If Exists (Select username, password
				   From Users 
				   Where username = @username AND password = @password)
		Begin
			Set @success =1
			if Exists(Select username
				 From Customer
				 Where username=@username)
				 Set @type =0
			Else
				Begin
					if Exists (Select username
							   From Vendor 
							   Where username=@username)
						Set @type =1
				    Else
						if Exists (Select username
								   From Admins
								   Where username =@username)
							Set @type =2
						Else
							Set @type =3
				End
			End
			Else
				Set @success =0
		print @success
		print @type	
	End
--b)
Go;
Create Procedure addMobile
	@username Varchar(20),
	@mobile_number Varchar(20)
	AS
	Begin
		Insert Into User_mobile_numbers (username ,mobile_number) Values (@username,@mobile_number)
	End
--c)
Go;
Create Procedure addAddress
	@username Varchar(20),
	@address Varchar(100)
	AS
	Begin
		Insert Into User_Addresses(username ,address) Values (@username ,@address)
	End
------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------Customer---------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--a)
Go;
Create Procedure showProducts
	AS
	Begin
		Select *
		From Products
	End
--b)
Go;
Create Proc ShowProductsbyPrice
	AS
	Begin
		Select *
		From Products
		Order BY price ASC
	End
--c)
Go;
Create Proc searchbyname
	@text Varchar(20)
	AS
	Begin
		Select *
		From Products
		Where product_name Like '%'+@text+'%'
	END
--d)
Go;
Create Proc AddQuestion
	@serial int, 
	@customer varchar(20), 
	@Question varchar(50)
	AS
	Begin
		Insert Into Customer_Question_Product(serial_no, customer_name, question) Values(@serial, @customer, @Question)
	END
--e)
Go;
Create Proc addToCart
	@customername varchar(20), 
	@serial int
	AS
	Begin
		Insert Into CustomerAddstoCartProduct(customer_username, serial_no) Values(@customername, @serial)
	End
Go;
Create Proc removefromCart
	@customername varchar(20), 
	@serial int
	AS
	Begin
		Delete From CustomerAddstoCartProduct Where customer_username=@customername AND serial_no=@serial
	End
--f)
Go;
Create Proc createWishlist
	@customername varchar(20), 
	@name varchar(20)
	AS
	Begin
		Insert Into Wishlist(username,name) Values(@customername,@name)
	End
--g)
Go;
Create Proc AddtoWishlist
	@customername varchar(20), 
	@wishlistname varchar(20), 
	@serial int
	As
	Begin
		Insert Into Wishlist_Product (username, serial_no, wish_name) Values(@customername, @serial, @wishlistname) 
	End
GO;
Create Proc removefromWishlist
	@customername varchar(20), 
	@wishlistname varchar(20), 
	@serial int
	AS
	Begin
		Delete From Wishlist_Product Where username=@customername AND wish_name = @wishlistname AND serial_no=@serial
	End
--h)
Go;
Create Proc showWishlistProduct
	@customername varchar(20), 
	@name varchar(20)
	AS
	Begin
		Select p.*
		From Products p	
			Inner Join Wishlist_Product w On w.serial_no=p.serial_no
		Where w.username=@customername AND w.wish_name=@name
	End
--i)
Go;
Create Proc viewMyCart
	@customer varchar(20)
	AS
	Begin
		Select p.*
		From Products p
			Inner Join CustomerAddstoCartProduct c On p.serial_no=c.serial_no
		Where c.customer_username=@customer
	End
--j)
Go;
Create Proc calculatepriceOrder
	@customername varchar(20),
	@sum decimal(10,2) Output
	As
	Begin
		Select @sum=Sum(p.price)
		From CustomerAddstoCartProduct c 
			Inner Join Products p On c.serial_no=p.serial_no
		Where c.customer_username=@customername
		print @sum
	End
Go;
Create Proc productsinorder
	@customername varchar(20), 
	@orderID int
	As
	Begin
		Update Products 
		Set
			available=available-1,
			customer_username = @customername,
			customer_order_id = @orderID
		From
			Products p Inner Join CustomerAddstoCartProduct c On p.serial_no = c.serial_no 
		Select c.serial_no
		From CustomerAddstoCartProduct c
		Where customer_username=@customername
		Delete c1
		From CustomerAddstoCartProduct c1
			Inner Join CustomerAddstoCartProduct c2 On c1.serial_no= c2.serial_no 
		Where c1.serial_no=c2.serial_no AND c1.customer_username <> @customername
	End
Go;
Create Proc emptyCart
	@customername varchar(20)
	AS
	Begin
		Delete From CustomerAddstoCartProduct Where customer_username=@customername
	End
Go;
Create Proc makeOrder
	@customername varchar(20)
	AS
	Begin
		Declare @sum Decimal(10,2)
		Exec calculatepriceOrder @customername ,@sum OUTPUT; 
		--To add the gift Card of the customer to the order automatically
		Declare @gift Varchar(20)
		Select @gift=code
		From Admin_Customer_Giftcard
		Where customer_username=@customername


		Insert Into Orders (customer_name,total_amount,order_date,GiftCardCodeUsed) Values (@customername,@sum,(SELECT CONVERT (date, CURRENT_TIMESTAMP)),@gift);
		Declare @id int
		Select Top 1 @id=order_no
		From Orders
		Order By order_no desc
		Exec productsinorder @customername, @id;
		Exec emptyCart @customername;
	End
--k)
Go;
Create Proc cancelOrder
	@orderid int
	As
	Begin
		Declare @ex_date Date
		Select @ex_date = g.expiry_date
		From Orders o 
			Inner Join GiftCard g on o.GiftCardCodeUsed=g.code
		where o.order_no=@orderid
		if (@ex_date < (SELECT CONVERT (date, CURRENT_TIMESTAMP)))
		Begin
			--We Get The Points used 
			Declare @points_used int
			Select @points_used = total_amount-(cash_amount+credit_amount)
			From Orders
			Where order_no=@orderid
			
			-- Updating Points To Admin Customer GiftCard
			Declare @gift Varchar(20)
			Select @gift=GiftCardCodeUsed
			From Orders
			Where order_no=@orderid

			Update Admin_Customer_Giftcard
			Set 
				remaining_points=remaining_points+@points_used
			Where code=@gift
			--Updating Points To Customer
			Declare @customer Varchar(20)
			Select @customer=customer_name
			From Orders
			Where order_no=@orderid
			Update Customer
			Set
				points=points+(@points_used)
			From Customer c
				Inner Join Orders o On c.username=o.customer_name
			Where o.order_no=@orderid
			-- Deleting the row from the order table
			Delete From Orders
			Where Orders.order_no=@orderid
			-- Deleting the row of the order from every table using it
			Delete From Admin_Delivery_Order
			where Admin_Delivery_Order.order_no=@orderid

			--Update The Products
			-- update Availablity and delete the username and order id and rate
			Update Products
			Set
				available=available+1,
				rate=Null,
				customer_username=Null,
				customer_order_id=NULL
			Where Products.customer_order_id=@orderid
		End
		Else
		Begin
			-- Deleting the row from the order table
			Delete From Orders
			Where Orders.order_no=@orderid
			--Update The Products
			-- update Availablity and delete the username and order id and rate
			Update Products
			Set
				available=available+1,
				rate=Null,
				customer_username=Null,
				customer_order_id=NULL
			Where Products.customer_order_id=@orderid
		End
	End
--l)
Go;
Create Proc returnProduct
	@serialno int, 
	@orderid int
	AS
	Begin
		Declare @cash Int 
		Set @cash=0;
		Declare @credit Int
		Set @credit=0;
		Declare @total Int
		Select @cash = cash_amount , @credit=credit_amount, @total=total_amount
		From Orders
		Where Orders.order_no=@orderid And cash_amount IS Not Null And credit_amount IS Not Null
		If(@total<> (@cash+@credit))
		Begin
			Declare @ex_date Date
			Select @ex_date = g.expiry_date
			From Orders o 
				Inner Join GiftCard g on o.GiftCardCodeUsed=g.code
			where o.order_no=@orderid
			if (@ex_date < (SELECT CONVERT (date, CURRENT_TIMESTAMP)))
			Begin
				--We Get The Points used 
				Declare @points_used int
				Select @points_used = total_amount-(cash_amount+credit_amount)
				From Orders
				Where order_no=@orderid
				-- Updating Points
				-- Check if the  points is greater than the amount of the points used
				Declare @price int
				Select @price=price
				From Products
				Where serial_no=@serialno
				if (@points_used>@price)
				Begin
					Update Admin_Customer_Giftcard
					Set 
						remaining_points=remaining_points+@price
					From Orders o
						Inner Join Admin_Customer_Giftcard a On o.GiftCardCodeUsed=a.code

					Update Customer
					Set
						points=points+@price
					From Customer c
						Inner Join Orders o On c.username=o.customer_name
					Where o.order_no=@orderid
				End
				Else
				Begin
					Update Admin_Customer_Giftcard
					Set 
						remaining_points=remaining_points+(@points_used)
					From Orders o
						Inner Join Admin_Customer_Giftcard a On o.GiftCardCodeUsed=a.code

					Update Customer
					Set
						points=points+(@points_used)
					From Customer c
						Inner Join Orders o On c.username=o.customer_name
					Where o.order_no=@orderid
				End
				--Update The Products
				-- update Availablity and delete the username and order id and rate
				Update Products
				Set
					available=available+1,
					rate=Null,
					customer_username=Null,
					customer_order_id=NULL
				Where Products.customer_order_id=@serialno
				--Update The Order
				Update Orders
				Set
					total_amount=total_amount-@price
				Where order_no=@orderid
			End
			Else
			Begin
				--Update The Products
				-- update Availablity and delete the username and order id and rate
				Update Products
				Set
					available=available+1,
					rate=Null,
					customer_username=Null,
					customer_order_id=NULL
				Where Products.customer_order_id=@serialno
				--Update The Order
				Update Orders
				Set
					total_amount=total_amount-(@cash+@credit+@points_used)
				Where order_no=@orderid
			End
		End
		Else
		Begin
			--Update The Products
			-- update Availablity and delete the username and order id and rate
			Update Products
			Set
				available=available+1,
				rate=Null,
				customer_username=Null,
				customer_order_id=NULL
			Where Products.customer_order_id=@serialno
			--Update The Order
			Update Orders
			Set
				total_amount=total_amount-(@cash+@credit+@points_used)
			Where order_no=@orderid
		End
	End
--m)
Go;
Create Proc ShowproductsIbought
	@customername varchar(20)
	As
	Begin
		Select *
		From Products
		Where Products.customer_username  Is Not Null
	End
--n)
Go;
Create Proc rate
	@serialno int, 
	@rate int , 
	@customername varchar(20)
	AS
	Begin
		Update Products
		Set
			rate=@rate
		Where
			customer_username=@customername AND serial_no=@serialno
	End
--o)
Go;
Create Proc SpecifyAmount
	@customername varchar(20), 
	@orderID int, 
	@cash decimal(10,2), 
	@credit decimal(10,2)
	AS
	Begin
		if(@cash IS null)
			Set @cash=0
		if(@credit Is null)
			Set @credit=0
		Declare @total decimal(10,2)
		Select @total=total_amount
		From Orders
		Where Orders.order_no = @orderID
		If(@total = (@credit+@cash))
		Begin
			Update Orders
			Set
				cash_amount=@cash,
				credit_amount=@credit
			Where order_no=@orderID
		End
		Else
		Begin
			Declare @remaining decimal(10,2)
			Set @remaining=@total-(@cash+@credit)
			Declare @giftCard Varchar(20)
			Select @giftCard=GiftCardCodeUsed
			From Orders
			Where order_no=@orderID
			--Update Admin Customer GiftCard
			Update Admin_Customer_Giftcard
			Set
				remaining_points=remaining_points-@remaining
			Where code=@giftCard
			--Update Customer
			Update Customer
			Set
				points=points-@remaining
			Where username=@customername
			--Update Order
			Update Orders
			Set
				cash_amount=@cash,
				credit_amount=@credit
			Where order_no=@orderID
		End
	End
--p)
Go;
Create Proc AddCreditCard
	@creditcardnumber varchar(20), 
	@expirydate date , 
	@cvv varchar(4), 
	@customername varchar(20)
	AS
	Begin
		Insert Into Credit_Card(number, expiry_date, cvv_code) Values(@creditcardnumber, @expirydate, @cvv)
		Insert Into Customer_CreditCard(customer_name,cc_number) Values(@customername, @creditcardnumber)
	End
--q)
Go;
Create Proc ChooseCreditCard
	@creditcard varchar(20), 
	@orderid int
	AS
	Begin
		Declare @cc_number Varchar(20)
		Select @cc_number=Credit_Card.number
		From Credit_Card
		Where Credit_Card.number=@creditcard
		Update Orders
		Set
			CreditCard_number=@cc_number
		Where order_no=@orderid
	End
--r)
Go;
Create Proc vewDeliveryTypes
	AS
	Begin
		Select *
		From Delivery
	End
--s)
Go;
Create Proc specifydeliverytype
	@orderID int, 
	@deliveryID int
	AS
	Begin
		Declare @time int
		Select @time=Delivery.time_duration
		From Delivery
		Where Delivery.id=@deliveryID
		Update Orders
		Set
			delivery_id=@deliveryID,
			remaining_days=@time
		Where
			order_no=@orderID
	End
--t)
Go;
Create Proc trackRemainingDays
	@orderid int, 
	@customername varchar(20),
	@days int Output
	As
	Begin
		Declare @remainingDays int
		Select @remainingDays=d.time_duration
		From Delivery d
			Inner Join Orders o On o.delivery_id=d.id
		Where o.order_no=@orderid
		
		
		
		Select @days= @remainingDays-(SELECT DATEDIFF(day,order_date,(SELECT CONVERT (date, CURRENT_TIMESTAMP))) AS DateDiff)
		From Orders
		Where order_no=@orderid
		
		Update Orders
		Set
			remaining_days=@days
		Where order_no=@orderid
		Print @days
	End
--u)
Go;
Create Proc recommmend
	@customername varchar(20)
	AS
	Begin
		--Here is to Display the whole Products
		Select p.*
		From(--Second We Get From The Top 3 Categories The Top 3 Wished Products serial_no Among All The Customers in the Wishlist Product
			Select Top 3 p.serial_no
			From 
				(--First We Get The Top Three Wishlist From My Cart
				Select	Top 3 P.category 
				From CustomerAddstoCartProduct C
					Inner Join Products P On P.serial_no=C.serial_no
				Where C.customer_username=@customername
				Group By P.category
				Order BY COUNT(P.category) Desc) As TopCategories

					Inner Join Products p On p.category = TopCategories.category
					Inner Join Wishlist_Product w On w.serial_no=p.serial_no
			Group By p.serial_no
			Order By COUNT(w.serial_no) Desc) AS TopProductsWished

				Inner Join Products p On p.serial_no=TopProductsWished.serial_no
		--And This is for The First Part
		Union
		--And Finally We Display the products
		Select p.*
		From(--Thirdly WE Get The Top 3 wished Products serial_no in the similar customers wish list
				Select Top 3 COUNT(w.serial_no) as Counts,w.serial_no
				From (--Secondly We Get The Top 3 Similar Customers To Our Customer whose having the most common products
						Select Top 3 Count(c.serial_no) AS serial_no,c.customer_username
						From (--Firstly We Get The Cart Of The Customer
								Select serial_no
								From CustomerAddstoCartProduct
								Where customer_username=@customername) As CartCustomer

									Inner Join CustomerAddstoCartProduct c On c.serial_no=CartCustomer.serial_no
						Where c.customer_username<>@customername And c.serial_no=CartCustomer.serial_no
						Group By c.customer_username
						Order By Count(c.serial_no) Desc) AS TopCommonUsers

							Inner Join Wishlist_Product w On w.username=TopCommonUsers.customer_username
						Where w.username<>@customername 
						Group By w.serial_no
						Having COUNT(w.serial_no)>1
						Order By COUNT(w.serial_no) DESC) As Top3WishedProducts

							Inner Join Products p on p.serial_no=Top3WishedProducts.serial_no
	End
------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------Vendor-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--A)
Go;
Create Proc postProduct
	@vendorUsername varchar(20),
	@product_name varchar(20) ,
	@category varchar(20), 
	@product_description text ,
	@price decimal(10,2),
	@color varchar(20)
	As
	Begin
		INSERT INTO Products(product_name, category ,product_description ,price ,color,vendor_username )
		VALUES(@product_name,@category,@product_description,@price,@color,@vendorUsername)
	End
--B)
Go;
Create Proc vendorviewProducts
	@vendorname varchar(20)
	As
	Begin
		select *
		from Products 
		where Products.vendor_username = @vendorname
	End
--C)
Go;
Create Proc EditProduct
	@vendorname varchar(20), 
	@serialnumber int, 
	@product_name varchar(20) ,
	@category varchar(20),
	@product_description text , 
	@price Decimal(10,2), 
	@color Varchar(20)
	As
	Begin
		Update Products
		Set
			product_name=@product_name,
			category=@category,
			product_description=@product_description,
			price=@price,
			color=@color
		Where serial_no=@serialnumber AND vendor_username=@vendorname
	End
--D)
Go;
Create Proc deleteProduct
	@vendorname varchar(20), 
	@serialnumber int
	As
	Begin
		Delete From Products
		Where vendor_username=@vendorname AND serial_no=@serialnumber
		
		--Delete from Wishlist product to update it manually
		Delete From Wishlist_Product
		Where serial_no=@serialnumber

		--delete from todaysDeals Products to update it manually
		Delete From Todays_Deals_Products
		Where serial_no=@serialnumber
	End
--E)
Go;
Create Proc viewQuestions
    @vendorname varchar(20)
    As
    Begin
        select cp.*
            from Customer_Question_Product cp
               inner join Products p on cp.serial_no=p.serial_no
                where p.vendor_username = @vendorname
    End

--F) Answer questions related to my products on the system.
Go;
Create Proc answerQuestions
	@vendorname varchar(20), 
	@serialno int, 
	@customername varchar(20), 
	@answer text
	As
	Begin
		If Exists (Select *
				   From Products p 
				   Where @vendorname = p.vendor_username AND @serialno = p.serial_no)
		Begin 
			UPDATE Customer_Question_Product 
			SET Customer_Question_Product.answer= @answer
			WHERE Customer_Question_Product.serial_no=@serialno and Customer_Question_Product.customer_name= @customername
		End
	End
--g) create offers on products I posted (one at a time) and update the product’s final price accordingly
--Signature:
--Name: addOffer
--Input: offeramount int, expiry _date datetime
--Output: Nothing
Go;
Create Proc addOffer
	@offeramount int, 
	@expiry_date datetime
	As
	Begin
		insert into offer(offer_amount,expiry_date) 
		values(@offeramount,@expiry_date)
	End

Go;
create Proc checkOfferonProduct
	@serial int, 
	@activeoffer bit output
	As
	Begin
		
		If Exists (Select offer_id
				   From offersOnProduct p
						
				   Where p.offer_id=@serial)
		Begin 
			set @activeoffer =1
		End
		Else
			Set @activeoffer=0
	End
Go;
Create Proc checkandremoveExpiredoffer
	@offerid int 
	As
	Begin
		Declare @exDate Date
		Select @exDate
		From offer
		Where offer_id=@offerId
		if (@exDate > (SELECT CONVERT (date, CURRENT_TIMESTAMP)))
			Update Products
			Set
				final_price=price
			From 
				Products p Inner Join offersOnProduct o On p.serial_no=o.serial_no
			delete from offersOnProduct 
			Where @offerid = offer_id;	
	End
Go;
create Proc applyOffer
	@vendorname varchar(20),
	@offerid int,
	@serial int 
	As
	Begin
		Declare @active Bit
		Exec checkOfferonProduct @offerid ,@active Output;
		If (@active =1)
			Print 'The product has an active offer'
		Else
		Begin
				declare @temp int
				select @temp = offer.offer_amount
				from offer 
				where offer.offer_id=@offerid
				UPDATE Products 
				SET Products.final_price= final_price-((@temp/100)*final_price)
				where Products.vendor_username=@vendorname and @serial=Products.serial_no	
				Insert Into offersOnProduct(offer_id,serial_no)Values(@offerid,@serial)
		End

	End
------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------Admin--------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--A)Activate non-activated vendors.
Go;
create Proc activateVendors
	@admin_username varchar(20),
	@vendor_username varchar(20)
	As
	Begin
		UPDATE Vendor 
		SET vendor.activated = 1 
		where vendor.username=@vendor_username 
		UPDATE Vendor 
		SET vendor.admin_username = @admin_username 
		where vendor.username=@vendor_username 								
	End
--b) Invite delivery persons to the system.
Go;
create Proc inviteDeliveryPerson
	@delivery_username varchar(20),
	@delivery_email varchar(50)
	AS
	Begin
		IF Not Exists(Select username
					  From Users
					  Where Users.username = @delivery_username)
		Begin
			Insert Into Users(username,email) 
			Values(@delivery_username,@delivery_email);
			
			Insert Into Delivery_Person(username) Values(@delivery_username)
		End
		Else
			print'Username Already Taken';
	End

--c) Review all the orders made through the website.
Go;
create Proc reviewOrders
	As
	Begin
		select *
		from Orders
	End
--d) Update the order status to “in process”.

Go;
create Proc updateOrderStatusInProcess
	@order_no int,
	@delivery_email varchar(50)
	As
	Begin
		update Orders
		set Orders.order_status='in process'
		where Orders.order_no=@order_no
	End
--e) Add new delivery type on the system, specifying its time duration, and fees

Go;
create Proc addDelivery
	@delivery_type varchar(20),
	@time_duration int,
	@fees decimal(5,3),
	@admin_username varchar(20)
	As
	Begin
			INSERT INTO Delivery(Type,time_duration ,fees,username) VALUES(@delivery_type,@time_duration ,@fees,@admin_username)
	End
--f) Assign orders to deliver personnel.
Go;
create Proc assignOrdertoDelivery
	@delivery_username varchar(20),
	@order_no int,
	@admin_username varchar(20)
	As
	Begin
		Insert Into Admin_Delivery_Order(delivery_username,order_no,admin_username) Values (@delivery_username,@order_no,@admin_username)
	End
--g) Add a new Today’s Deals on products and update the product’s final price accordingly.
--Signature:
--Name: createTodaysDeal
--Input: deal_amount int,admin_username varchar(20),expiry_date datetime
--Output: Nothing
Go;
create Proc createTodaysDeal
	@deal_amount int,
	@admin_username varchar(20),
	@expiry_date datetime
	As
	Begin
		INSERT INTO Todays_Deals(deal_amount, admin_username ,expiry_date) VALUES(@deal_amount,@admin_username,@expiry_date)
	End
Go;
create Proc checkTodaysDealOnProduct
	@serial_no INT,
	@activeDeal BIT output
	As
	Begin
		If Exists (Select serial_no
				   From Todays_Deals_Products p
						
				   Where p.serial_no=@serial_no)
		Begin 
			set @activeDeal =1
		End
		Else
			Set @activeDeal=0
		print @activeDeal
	End
Go;
create Proc addTodaysDealOnProduct
	@deal_id int,
	@serial_no int
	As
	Begin
		Declare @active Bit
		Exec checkTodaysDealOnProduct @serial_no ,@active Output;
		If (@active =1)
			Print 'The product has an active deal'
		Else
		Begin
				declare @temp int
					select @temp = deal_amount
					from Todays_Deals 
					where Todays_Deals.deal_id=@deal_id

				Update Products
				Set
					final_price = final_price-((@temp/100)*final_price)
				Where 
					serial_no=@serial_no;
				Insert Into Todays_Deals_Products(deal_id,serial_no)Values(@deal_id,@serial_no)
			End
		End
Go;
create Proc removeExpiredDeal
	@deal_iD int
	As
	Begin
		Declare @exDate Date
		Select @exDate
		From Todays_Deals
		Where deal_id=@deal_iD
		if (@exDate < (SELECT CONVERT (date, CURRENT_TIMESTAMP)))
			Update Products
			Set
				final_price=price
			From 
				Products p Inner Join Todays_Deals_Products t On p.serial_no=t.serial_no
			delete from Todays_Deals_Products
			Where @deal_id = deal_id;	
	End
--h) Create Gift Cards.
Go;
create Proc createGiftCard
	@code varchar(10),
	@expiry_date datetime,
	@amount int,
	@admin_username varchar(20)
	As
	Begin
		INSERT INTO GiftCard(amount, code,expiry_date,username) VALUES(@amount,@code,@expiry_date,@admin_username)
	End
--i) Give Gift Cards to special customers.

Go;
create Proc removeExpiredGiftCard
	@code varchar(10)
	As
	Begin
		IF Exists(Select *
					 from GiftCard
					 where GiftCard.code=@code)
		Begin 
			IF Not Exists(Select *
						   from GiftCard
						   where GiftCard.code=@code and GiftCard.expiry_date < CURRENT_TIMESTAMP)
			Begin
				delete from Admin_Customer_Giftcard where @code = Admin_Customer_Giftcard.code ;
				delete from GiftCard Where @code = GiftCard.code ;
				select *
				from GiftCard
				select *
				from Admin_Customer_Giftcard
				select Username,points
				from Customer
			End
			Else 
			Begin 
				select *
				from GiftCard
			End
		End					
	End
Go;
create Proc checkGiftCardOnCustomer
	@code varchar(10),
	@activeGiftCard BIT output
	As
	Begin
		set @activeGiftCard = 0
		IF  Exists(Select *
				   from Admin_Customer_Giftcard
				   where Admin_Customer_Giftcard.code=@code)
		Begin
			set @activeGiftCard = 1;
		End
		print @activeGiftCard
	End
Go;
create Proc giveGiftCardtoCustomer
	@code varchar(10),
	@customer_name varchar(20),
	@admin_username varchar(20)
	As
	Begin	
		declare @temppoints int ;
		select @temppoints =amount
		from GiftCard
		where GiftCard.code=@code
		INSERT INTO Admin_Customer_Giftcard(admin_username,code,customer_username,remaining_points) VALUES(@admin_username,@code,@customer_name,@temppoints)
		select @temppoints =sum(remaining_points) 
		from Admin_Customer_Giftcard
		where Admin_Customer_Giftcard.customer_username=@customer_name
		update Customer
		set  Customer.points = @temppoints
		where Customer.username=@customer_name  	
	End
------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------Delivery Personnel-------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
--a)
Go;
Create Proc acceptAdminInvitation
	@delivery_username varchar(20)
	AS
	Begin
		Update Delivery_Person
		Set
			is_activated=1
		Where username=@delivery_username;
	End
--b)
Go;
Create Proc deliveryPersonUpdateInfo
	@username varchar(20),
	@first_name varchar(20),
	@last_name varchar(20),
	@password varchar(20),
	@email varchar(50)
	AS
	Begin
		Update Users
		Set
			first_name=@first_name,
			last_name=@last_name,
			password=@password,
			email=@email
		Where username=@username
	End
--c)
Go;
Create Proc viewmyorders
	@deliveryperson varchar(20)
	AS
	Begin
		Select o.* 
		From Orders o
			Inner Join Admin_Delivery_Order a On a.order_no=o.order_no
		Where a.delivery_username=@deliveryperson
	End
--d)
Go;
Create Proc specifyDeliveryWindow
	@delivery_username varchar(20),
	@order_no int,
	@delivery_window varchar(50)
	AS
	Begin
		Update Admin_Delivery_Order
		Set
			order_no=@order_no,
			delivery_window=@delivery_window
		Where delivery_username=@delivery_username
	End
--e)
Go;
Create Proc updateOrderStatusOutforDelivery
	@order_no int
	AS
	Begin
		Update Orders
		Set
			order_status='Out for delivery'
		Where order_no=@order_no
	End
--f)
Go;
Create Proc updateOrderStatusDelivered
	@order_no int
	AS
	Begin
		Update Orders
		Set
			order_status='Delivered'
		Where order_no=@order_no
	End

------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------Insertions------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Users(Username,first_name,last_name,password,email) VALUES('hana.aly','hana','aly','pass1','hana.aly@guc.edu.eg')
INSERT INTO Users(Username,first_name,last_name,password,email) VALUES('ammar.yasser','ammar','yasser','pass4','ammar.yasser@guc.edu.eg')
INSERT INTO Users(Username,first_name,last_name,password,email) VALUES('nada.sharaf','nada','sharaf','pass7','nada.sharaf@guc.edu.eg')
INSERT INTO Users(Username,first_name,last_name,password,email) VALUES('hadeel.adel','hadeel','adel','pass13','hadeel.adel@guc.edu.eg')

INSERT INTO Admins(Username) VALUES('hana.aly')
INSERT INTO Admins(Username) VALUES('nada.sharaf')

INSERT INTO Customer(Username,points) VALUES('ammar.yasser',15)

INSERT INTO CustomerAddstoCartProduct(serial_no,customer_username)VALUES(1,'ammar.yasser')

INSERT INTO Vendor(username,activated,company_name,bank_acc_no,admin_username) VALUES('hadeel.adel',1,'Dello',47449349234,'hana.aly')

INSERT INTO Delivery_Person(is_activated,username) VALUES(1,'mohamed.tamer')

INSERT INTO User_Addresses(address,username) VALUES('New Cairo','hana.aly')
INSERT INTO User_Addresses(address,username) VALUES('Heliopolis','hana.aly')

INSERT INTO User_mobile_numbers (mobile_number,username) VALUES(01111111111,'hana.aly')
INSERT INTO User_mobile_numbers (mobile_number,username) VALUES(1211555411,'hana.aly')

INSERT INTO Credit_Card(number,expiry_date ,cvv_code) VALUES( '4444-5555-6666-8888' ,'2028-10-19',232)


INSERT INTO Delivery(Type,time_duration ,fees) VALUES('pick-up',7 ,10)
INSERT INTO Delivery(Type,time_duration ,fees) VALUES('regular',14 ,30)
INSERT INTO Delivery(Type,time_duration ,fees) VALUES('speedy ',1 ,50)

INSERT INTO Products(product_name, category ,product_description ,price, final_price ,color ,available ,rate ,vendor_username ) VALUES('bag','Fashion','backbag',100,100,'yellow',1,0,'hadeel.adel')
INSERT INTO Products(product_name, category ,product_description ,price, final_price ,color ,available ,rate ,vendor_username ) VALUES('blue pen','stationary','useful pen',10,10,'Blue',1,0,'hadeel.adel')
INSERT INTO Products(product_name, category ,product_description ,price, final_price ,color ,available ,rate ,vendor_username ) VALUES('blue pen','stationary','useful pen',10,10,'Blue',0,0,'hadeel.adel')

INSERT INTO Todays_Deals(deal_amount, admin_username ,expiry_date) VALUES(30,'hana.aly','2019-11-30')
INSERT INTO Todays_Deals(deal_amount, admin_username ,expiry_date) VALUES(40,'hana.aly','2019-11-18')
INSERT INTO Todays_Deals(deal_amount, admin_username ,expiry_date) VALUES(50,'hana.aly','2019-12-12')
INSERT INTO Todays_Deals(deal_amount, admin_username ,expiry_date) VALUES(10,'nada.sharaf','2019-11-12')

INSERT INTO offer(offer_id ,offer_amount,expiry_date) VALUES(1,50,'2019-11-30')

INSERT INTO Wishlist (username,name) VALUES( 'ammar.yasser','fashion')

INSERT INTO Wishlist_Product(username ,wish_name,serial_no) VALUES('ammar.yasser','fashion',2)
INSERT INTO Wishlist_Product(username ,wish_name,serial_no) VALUES('ammar.yasser','fashion',3)

Insert Into GiftCard(code,expiry_date,amount) Values('G101','2019-11-18',100)

INSERT INTO Customer_CreditCard(customer_name,cc_number) VALUES('ammar.yasser', '4444-5555-6666-8888')

------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------Testing--------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------Customer-------------------------------------------------------------------------
--1. customerRegister:
--a)
Exec customerRegister 'ahmed.ashraf','ahmed','ashraf','pass123','ahmed@yahoo.com';
-------------------------------------------------------------------------------------------------------
--2. vendorRegister:
--a)
Exec vendorRegister 'eslam.mahmod','eslam','mahmod','pass1234','hopa@gmail.com','Market','132132513';
-------------------------------------------------------------------------------------------------------
--3. userLogin:
Declare @success Bit,
		@type Int
--a)
Exec userLogin 'eslam.mahmod','pass123', @success Output,@type Output;
--b)
Exec userLogin 'eslam.mahmod','pass1234',@success Output,@type Output;
--c)
Exec userLogin 'ahmed.ashraf','pass123',@success Output,@type Output;
--d)
Exec userLogin 'ahmed.ashraf','pass',@success Output, @type Output;
-------------------------------------------------------------------------------------------------------
--4. addMobile:
--a)
Exec addMobile 'ahmed.ashraf','01111211122'
--b)
Exec addMobile 'ahmed.ashraf','0124262652'
-------------------------------------------------------------------------------------------------------
--5. AddAddress:
--a)
Exec addAddress 'ahmed.ashraf','nasr city'
-------------------------------------------------------------------------------------------------------
--6. showProducts: Test again
Exec showProducts;
-------------------------------------------------------------------------------------------------------
--7. ShowProductsbyPrice :
--a)
Exec ShowProductsbyPrice;
-------------------------------------------------------------------------------------------------------
--8. Searchbyname:
--a)
Exec searchbyname 'blue';
-------------------------------------------------------------------------------------------------------
--9. AddQuestion:
--a)
Exec AddQuestion 1,'ahmed.ashraf' ,'size?';
-------------------------------------------------------------------------------------------------------
--10. addToCart:
--a)
Exec addToCart 'ahmed.ashraf',1;
--b)
Exec addToCart 'ahmed.ashraf',2;
-------------------------------------------------------------------------------------------------------
--11. removefromCart:
--a)
Exec removefromCart 'ahmed.ashraf',2;
-------------------------------------------------------------------------------------------------------
--12. Create (a) wish list(s):
--a)
Exec createWishlist 'ahmed.ashraf','fashion';
-------------------------------------------------------------------------------------------------------
--13. AddtoWishlist :
--a)
Exec AddtoWishlist 'ahmed.ashraf','fashion',1;
--b)
Exec AddtoWishlist 'ahmed.ashraf','fashion',2;
-------------------------------------------------------------------------------------------------------
--14. removefromWishlist:
--a)
Exec removefromWishlist 'ahmed.ashraf','fashion',1;
-------------------------------------------------------------------------------------------------------
--15. showWishlistProduct:
Exec showWishlistProduct 'ahmed.ashraf','fashion'
-------------------------------------------------------------------------------------------------------
--16. viewMyCart :
Exec viewMyCart 'ahmed.ashraf';
-------------------------------------------------------------------------------------------------------
--17. Make Orders:
--a. calculatepriceOrder:
Declare @sum int
Exec calculatepriceOrder 'ahmed.ashraf',@sum Output;
--b. Productsinorder:
Exec productsinorder 'ahmed.ashraf',1;
--c. emptyCart:
Exec emptyCart 'ahmed.ashraf';
--d. makeOrder:
Exec makeOrder 'ahmed.ashraf';
-------------------------------------------------------------------------------------------------------
--18. cancelOrder:
Exec cancelOrder 9;
-------------------------------------------------------------------------------------------------------
--19. returnProduct :
Exec returnProduct 2, 10;
-------------------------------------------------------------------------------------------------------
--20. ShowproductsIbought:
Exec ShowproductsIbought 'ahmed.ashraf';
-------------------------------------------------------------------------------------------------------
--21. Rate:
Exec rate 1,3,'ahmed.ashraf';
-------------------------------------------------------------------------------------------------------
--22.Specify Amount:
Exec SpecifyAmount 'ahmed.ashraf', 10 , null,50
Update Customer 
Set 
	points =100
Where username='ahmed.ashraf'
-------------------------------------------------------------------------------------------------------
--23. AddcreditCard:
Exec AddCreditCard '4444-5555-6666-8888','2028-10-19',232,'ahmed.ashraf';
-------------------------------------------------------------------------------------------------------
--24. ChooseCreditCard:
Exec ChooseCreditCard '4444-5555-6666-8888',1;
-------------------------------------------------------------------------------------------------------
--25. vewDeliveryTypes:
Exec vewDeliveryTypes;
-------------------------------------------------------------------------------------------------------
--26. Specifydeliverytype
Exec specifydeliverytype 1,1;
-------------------------------------------------------------------------------------------------------
--27. trackRemainingDays:
Declare @days int
Exec trackRemainingDays 1,'ahmed.ashraf',@days Output;
-------------------------------------------------------------------------------------------------------
--28. Recommend:
Exec recommmend 'ahmed.ashraf'
----------------------------------------------------------------------Vendor--------------------------------------------------------------------------
--1. Post products on the system.
Exec postProduct  'eslam.mahmod',  'pencil','stationary', 'HB0.7', 10, 'red'
-------------------------------------------------------------------------------------------------------
--2. View the products I posted on the system.
Exec vendorviewProducts 'eslam.mahmod'
-------------------------------------------------------------------------------------------------------
--3. Edit products I posted on the system:
Exec EditProduct 'eslam.mahmod' ,4 ,'pencil','stationary','useful','20','white';
-------------------------------------------------------------------------------------------------------
--4. Delete products I posted on the system
Exec deleteProduct 'eslam.mahmod' ,4;
-------------------------------------------------------------------------------------------------------
--5. View questions related to my products on the system
Exec viewQuestions 'hadeel.adel';
-------------------------------------------------------------------------------------------------------
--6. Answer questions related to my products on the system:
Exec answerQuestions 'hadeel.adel',1,'ahmed.ashraf','40'
-------------------------------------------------------------------------------------------------------
--7. create offers on products I posted (one at a time) and update the product’s final price accordingly
--a. addOffer:
Exec addOffer 50 ,'2019/10/11'
--b. applyOffer:
Exec applyOffer 'hadeel.adel',2,1;
--d)
Exec checkandremoveExpiredoffer  2
----------------------------------------------------------------------Admin--------------------------------------------------------------------------
--a) activateVendors:
Exec  activateVendors 'hana.aly' , 'eslam.mahmod'
-------------------------------------------------------------------------------------------------------
--b) inviteDeliveryPerson:
Exec  inviteDeliveryPerson 'mohamed.tamer' , 'moha@gmail.com'
-------------------------------------------------------------------------------------------------------
--c) reviewOrders:
Exec  reviewOrders;
-------------------------------------------------------------------------------------------------------
--d) updateOrderStatusInProcess:
Exec  updateOrderStatusInProcess 1,'moha@gmail.com'
-------------------------------------------------------------------------------------------------------
--e) addDelivery:
Exec  addDelivery 'pick-up', 7,10,'hana.aly'
-------------------------------------------------------------------------------------------------------
--f) assignOrdertoDelivery:
Exec assignOrdertoDelivery 'mohamed.tamer',1,'hana.aly'
-------------------------------------------------------------------------------------------------------
--g) 1) createTodaysDeal:
Exec  createTodaysDeal 30, 'hana.aly','2019/11/30'
--2) addTodaysDealOnProduct:
Exec  addTodaysDealOnProduct  1,2
--3) checkTodaysDealOnProduct:
Declare @active Bit
Exec  checkTodaysDealOnProduct 2,@active Output;
--4) removeExpiredDeal:
Exec removeExpiredDeal 1
-------------------------------------------------------------------------------------------------------
--h) createGiftCard:
Exec  createGiftCard 'G101' ,'2019/12/30', 100, 'hana.aly'
Exec  createGiftCard 'G102' ,'2019/11/17', 100, 'hana.aly'
-------------------------------------------------------------------------------------------------------
--i) Give Gift Cards to special customers:
Exec  giveGiftCardtoCustomer  'G101' ,'ahmed.ashraf',  'hana.aly'
Exec  giveGiftCardtoCustomer  'G102' ,'ahmed.ashraf',  'hana.aly'
Exec removeExpiredGiftCard 'G101'
Exec removeExpiredGiftCard 'G102'
Declare @active Bit
Exec checkGiftCardOnCustomer 'G101',@active Output
Exec checkGiftCardOnCustomer 'G102',@active Output
-----------------------------------------------------------------Delivery Personnel-------------------------------------------------------------------
--1) Accept the admin invitation
exec acceptAdminInvitation 'mohamed.tamer';
--2) Add additional credentials to the system other than the username (password.. etc.)
exec deliveryPersonUpdateInfo 'mohamed.tamer', 'mohamed' ,'tamer', 'pass16','mohamed.tamer@guc.edu.eg'
--3) View all the orders I am assigned to
exec viewmyorders 'mohamed.tamer'
--4) Specify a delivery window for each customer order
exec specifyDeliveryWindow 'mohamed.tamer', 1 ,'Today between 10 am and 3 pm'
--5) Update the status of an order when it’s out for delivery
exec updateOrderStatusOutforDelivery 1
--6)Update the status of an order when it gets delivered.
exec updateOrderStatusDelivered 1
-----------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------Viewing--------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM Users;
SELECT * FROM Admins;
SELECT * FROM Customer;
SELECT * FROM CustomerAddstoCartProduct;
SELECT * FROM Vendor;
SELECT * FROM Delivery_Person;
SELECT * FROM User_Addresses;
SELECT * FROM User_mobile_numbers;
SELECT * FROM Credit_Card;
SELECT * FROM Delivery;
SELECT * FROM Products;
SELECT * FROM Todays_Deals;
SELECT * FROM offer;
SELECT * FROM Wishlist;
SELECT * FROM Wishlist_Product;
SELECT * FROM Customer_CreditCard;
SELECT * FROM GiftCard;
SELECT * FROM Orders;
SELECT * FROM Todays_Deals_Products;
SELECT * FROM offersOnProduct;
SELECT * FROM Customer_Question_Product;
SELECT * FROM Admin_Customer_Giftcard;
SELECT * FROM Admin_Delivery_Order;







