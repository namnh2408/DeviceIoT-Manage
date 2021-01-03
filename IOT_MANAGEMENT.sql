CREATE DATABASE IOT_MANAGEMENT
GO
USE IOT_MANAGEMENT
GO

CREATE TABLE Role
(
	RoleID INT IDENTITY(1,1)NOT NULL PRIMARY KEY,
	RoleName NVARCHAR(30) NULL
)

--bảng User dùng để lưu thông tin người dùng
CREATE TABLE Users
(
	Id_Users INT IDENTITY(1,1),
	Username NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	Password NVARCHAR(100) NOT NULL,
	Full_Name NVARCHAR(200) NULL,
	Address NVARCHAR(100) NULL,
	Gender NVARCHAR(5) NULL,
	Phone NVARCHAR(15) NULL,
	Birthday DATE NULL ,
	RoleID INT NULL,
	Avatar NVARCHAR(100) NULL,
	Create_User DATE NULL,--ngày tạo user
	UNIQUE (Username, Email),
	PRIMARY KEY (Id_Users)
)

ALTER TABLE dbo.Users ADD FOREIGN KEY (RoleID) REFERENCES dbo.Role(RoleID)



--bảng Address dùng để địa chỉ của người dùng khi mua hàng
CREATE TABLE Address
(
	Id_Address INT IDENTITY(1,1)NOT NULL  PRIMARY KEY,
	Id_Users INT NULL  REFERENCES dbo.Users(Id_Users),
	Name NVARCHAR(100) NULL , -- tên người nhận hàng
	Address NVARCHAR(100) NULL , -- địa chỉ nhận hàng của người dùng
	Phone NVARCHAR(20) NULL ,
	Default_Address INT NULL  -- địa chỉ mặt định của người dùng
)

CREATE TABLE Shop
(
	Id_Shop INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Address NVARCHAR(100) NULL,
	Id_Users INT NULL REFERENCES dbo.Users(Id_Users),
	Name_Shop NVARCHAR(100) NULL,
	Description NVARCHAR(100) NULL,
	Pictures NTEXT NULL
)

--Category lưu thông tin các loại thiết bị
CREATE TABLE Category
(
	Id_Category INT IDENTITY(1,1) PRIMARY KEY,
	Name_Category NVARCHAR(1000) NOT NULL 
)

-- Product lưu thông tin của thiết bị
CREATE TABLE Product
(
	Id_Product INT IDENTITY(1,1) PRIMARY KEY,
	Name_Product NVARCHAR(500)NOT NULL ,
	Price REAL NOT NULL ,
	Amount INT NOT NULL ,
	Id_Category INT NOT NULL  REFERENCES dbo.Category(Id_Category),
	Id_Shop INT NOT NULL REFERENCES dbo.Shop(Id_Shop),
	Pictures NTEXT NULL,
	Description NVARCHAR(1000) NOT NULL
)
ALTER TABLE dbo.Product ADD Status INT

CREATE TABLE Orders
(
	Id_Order NCHAR(10) PRIMARY KEY,
	Id_Users INT NULL REFERENCES dbo.Users(Id_Users),
	Id_Shop INT NULL REFERENCES dbo.Shop(Id_Shop),
	Delivery FLOAT NULL,
	Payment NVARCHAR(100) NULL,
	Create_Orders DATETIME NULL, --ngày tạo đơn
	Status INT NULL,
	Description NVARCHAR(1000) NULL,
	Id_Address INT NULL REFERENCES dbo.Address(Id_Address), -- địa chỉ nhận hàng
	Total_Order FLOAT NULL
)

CREATE TABLE Orders_Item
(
	Id_Order NCHAR(10) REFERENCES dbo.Orders(Id_Order),
	Id_Product INT NOT NULL REFERENCES dbo.Product(Id_Product),
	Price FLOAT  NULL,
	Amount INT  NULL,
	Discount FLOAT NULL,
	Total FLOAT  NULL,
	Status INT  NULL,
	PRIMARY KEY (Id_Order, Id_Product)
)


CREATE TABLE Cart
(
	Id_Cart INT PRIMARY KEY,
	Id_Users INT NOT NULL REFERENCES dbo.Users(Id_Users)
)

CREATE TABLE Cart_Item
(
	Id_Cart INT NOT NULL REFERENCES dbo.Cart(Id_Cart),
	Amount  INT NOT NULL,
	Id_Product INT NOT NULL REFERENCES dbo.Product(Id_Product),
	PRIMARY KEY (Id_Cart,Id_Product)
)


--bảng dùng để theo dõi một đơn hàng
CREATE TABLE Orders_Track
(
	Id_Track INT IDENTITY(1,1) NOT NULL,-- id của đơn hàng cần theo dõi
	Id_Order NCHAR(10) NULL REFERENCES dbo.Orders(Id_Order),
	Date_Update DATETIME NULL, 
	Status INT NULL,-- trạng thái của đơn hàng
	Description NVARCHAR(1000) NULL,
	Id_Shipper INT NULL REFERENCES dbo.Users(Id_Users),
	PRIMARY KEY (Id_Track)
)
GO
----------------------------------------------FUNCTION----------------------------------------------
-- Mã hóa mật khẩu dưới dạng MD5
--CONVERT cho phép chuyển đổi một biểu thức nào đó sang một kiểu dữ liệu bất kì
-- CONVERT (kieudulieu(do_dai), bieuthuc, dinh_dang)
----định dạng = 2 ==> các ký tự 0x không được thêm vào bên trái kết quả được chuyển đổi cho kiểu 2
--HASHBYTES trả về hàm băm của dữ liệu đầu vào
--MD5 tạo ra giá trị băm 128 bit (16 bytes), thường được thể hiện ở định dạng văn bản dưới
----dạng số thập lục phân 32 chữ số.
CREATE FUNCTION dbo.MaHoaMD5 (@password NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN CONVERT(NVARCHAR(100), HASHBYTES('MD5', @password), 2)
END
GO

--lấy thông tin của người giao hàng
CREATE FUNCTION dbo.GetShipper()
RETURNS TABLE
AS
	RETURN SELECT * FROM dbo.Users WHERE dbo.Users.RoleID = 3
GO  

--Function CheckAdminLogin: dùng để kiểm tra admin đăng nhập
CREATE FUNCTION dbo.CheckAdminLogin (@email NVARCHAR(100), @password NVARCHAR(100))
RETURNS @result TABLE (RESULT INT)
AS
BEGIN
	DECLARE @pass NVARCHAR(100)
	SET @pass=dbo.MaHoaMD5((@password))
	IF EXISTS (SELECT * FROM dbo.Users WHERE dbo.Users.Email = @email AND dbo.Users.Password = @pass AND dbo.Users.RoleID = 1)
	BEGIN
		INSERT INTO @result 
		        ( RESULT )
		VALUES  ( 1  -- RESULT - int
		          )
	END
	ELSE
	BEGIN
		INSERT INTO @result
		        ( RESULT )
		VALUES  ( 0  -- RESULT - int
		          )
	END
	RETURN
END
GO 

-- Function GetLatestStatus: nhận trạng thái mới của đơn hàng đang theo dõi trong bảng order_track
CREATE FUNCTION dbo.GetLatestStatus()
RETURNS TABLE
AS
RETURN
	SELECT dbo.Orders_Track.Id_Track, dbo.Orders.Id_Order, dbo.Orders_Track.Date_Update, dbo.Orders_Track.Status, dbo.Orders_Track.Description, dbo.Orders_Track.Id_Shipper
	FROM dbo.Orders_Track, dbo.Orders
	WHERE dbo.Orders_Track.Status = dbo.Orders.Status
	AND dbo.Orders_Track.Id_Order = dbo.Orders.Id_Order
GO 

--Function Load_User_Cart: lấy tất cả thông tin liên quan về giỏ hàng của người dùng có Id_Users được truyền vào
CREATE FUNCTION dbo.Load_User_Cart(@id_users INT)
RETURNS TABLE
AS
RETURN (SELECT dbo.Product.Pictures, dbo.Product.Name_Product, dbo.Product.Description, dbo.Product.Price, dbo.Product.Id_Shop, dbo.Cart_Item.Amount, dbo.Cart_Item.Id_Product
		FROM dbo.Cart, dbo.Cart_Item, dbo.Product
		WHERE dbo.Cart.Id_Users = @id_users
		AND dbo.Cart.Id_Cart = dbo.Cart_Item.Id_Cart
		AND dbo.Product.Id_Product = dbo.Cart_Item.Id_Product
		)
GO 

-- Function GetLatestDate: nhận thông tin ngày cuối cùng trong bảng order_track dựa vào id_order
CREATE FUNCTION dbo.GetLatestDate(@id_order INT)
RETURNS DATETIME
AS
BEGIN
	DECLARE @last_day DATETIME
	SELECT @last_day = dbo.Orders_Track.Date_Update
	FROM dbo.Orders_Track
	WHERE dbo.Orders_Track.Id_Track = (SELECT MAX(dbo.Orders_Track.Id_Track) FROM dbo.Orders_Track)
	AND dbo.Orders_Track.Id_Order = @id_order
	RETURN @last_day
END
GO 

-- Function GetDateTotal:
CREATE FUNCTION dbo.GetDateTotal(@id_shop INT, @date DATE, @hour INT)
RETURNS INT
AS 
BEGIN
	DECLARE @total INT
	--Hàm DATEPART trả về một giá trị thời gian của đối số truyền vào, có thể là ngày, tháng, năm, quý, giờ, phút, giây, mili giây,.... Giá trị trả về này là kiểu số nguyên (int)
	-- DATEPART(dangthoigian, thoigian) ==> DATEPART(HOUR,Date_Update) : lấy ra giờ của thuộc tính Date_Update
	-- chọn ra tổng giá trị của Total_Order theo id_shop của shop đã nhập vào; khi đơn hàng đó thuộc đơn hàng đang được theo dõi; và có hour bằng với @hour nhập vào; có ngày cập nhật bằng với ngày nhập vào và đơn hàng đó phải có trạng thái là đã giao hàng
	SET @total = (SELECT SUM(Total_Order) from dbo.Orders,dbo.Orders_Track where Id_Shop = @id_shop and Orders.Id_Order = dbo.Orders_Track.Id_Order AND DATEPART(HOUR,Date_Update) = @hour AND CONVERT(DATE,Date_Update) = @date AND dbo.Orders_Track.Status = 4)
	--khi @total không có giá trị 
	IF (@total IS NULL)
	BEGIN
		SET @total =0
	END
	--trả về @total
	RETURN @total
END
GO 

--Function GetMonthTotal: 
CREATE FUNCTION dbo.GetMonthTotal(@id_shop INT, @date DATE, @day INT)
RETURNS INT
AS 
BEGIN
	DECLARE @total INT
	--Hàm DAY() trả về một số nguyên là ngày trong tháng (từ 1 đến 31) từ thời gian được truyền vào. DAY(thoigian)
	--Hàm MONTH() trả về một số nguyên là tháng trong năm (từ 1 đến 12) từ thời gian được truyền vào. MONTH(thoigian)
	--Hàm YEAR() trả về một số nguyên có 4 chữ số là giá trị năm trong mốc thời gian được truyền vào. YEAR(thoigian)
	SET @total = (SELECT SUM(Total_Order) from dbo.Orders,dbo.Orders_Track where Id_Shop = @id_shop and Orders.Id_Order = dbo.Orders_Track.Id_Order AND DAY(Date_Update) = @day AND MONTH(Date_Update) = MONTH(@date) AND YEAR(Date_Update)= YEAR(@date) AND dbo.Orders_Track.Status = 4)
	--khi @total không có giá trị 
	IF (@total IS NULL)
	BEGIN
		SET @total =0
	END
	--trả về @total
	RETURN @total
END
GO 

----------------------------------------------TRIGGER----------------------------------------------
-- Mã hóa mật khẩu dưới dạng MD5 khi thêm hoặc update User
CREATE TRIGGER dbo.MaHoaDangMD5
ON dbo.Users
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @newpassword NVARCHAR(100), @email NVARCHAR(100), @oldpassword NVARCHAR(100), @mahash NVARCHAR(100)
	SELECT @newpassword = Inserted.Password, @email = Inserted.Email
	FROM Inserted
	SELECT @oldpassword = Deleted.Password
	FROM Deleted
	PRINT @email
	PRINT @newpassword
	IF (NOT EXISTS (SELECT * 
					FROM Deleted))
	BEGIN
		SELECT * FROM Inserted
		SET @mahash = dbo.MaHoaMD5(@newpassword)
		PRINT @email
		PRINT @newpassword
		PRINT @mahash
		--cập nhật lại mật khẩu của user dựa theo email nhập vào
		UPDATE dbo.Users
		SET dbo.Users.Password = @mahash
		WHERE dbo.Users.Email = @email
	END
	ELSE IF (@newpassword != @oldpassword)
	BEGIN
		SELECT * FROM Inserted
		SET @mahash = dbo.MaHoaMD5(@newpassword)
		UPDATE dbo.Users
		SET dbo.Users.Password = @mahash
		WHERE dbo.Users.Email = @email 
	END
END
GO 

--Trigger ChangeStatus: khi người mua thay đổi một default_address thành 1 thì sẽ thay đổi
--tất cả các default_address còn lại thành 0, default_address là địa chỉ mặc định mà người 
--dùng dùng để mua hàng
CREATE TRIGGER dbo.ChangeStatus
ON dbo.Address
FOR UPDATE
AS
BEGIN
	DECLARE @id_address INT, @olddefault_address INT, @newdefault_address INT, @id_users int
	SELECT @id_address = Inserted.Id_Address, @newdefault_address = Inserted.Default_Address,
			@olddefault_address = Deleted.Default_Address, @id_users=Inserted.Id_Users
	FROM Inserted, Deleted
	IF (@newdefault_address = 1 AND @olddefault_address = 0)
	BEGIN
		 UPDATE dbo.Address
		 SET dbo.Address.Default_Address = 0 
		 WHERE dbo.Address.Id_Address != @id_address
		 AND dbo.Address.Id_Users = @id_users
	END
END
GO 

--Trigger AddToCart: + tăng số lượng sản phẩm trong giỏ hàng sau khi thêm sản phẩm vào giỏ hàng
-- nếu sản phẩm đó đã tồn tại trong giỏ hàng
-- + nếu sản phẩm chưa có trong giỏ hàng thì thêm sản phẩm vào giỏ hàng với số lượng là 1
CREATE TRIGGER dbo.AddToCart 
ON dbo.Cart_Item
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @amount INT, @id_product INT, @id_cart INT
	SELECT @id_product = Inserted.Id_Product, @id_cart = Inserted.Id_Cart
	FROM Inserted
	PRINT @id_product
	PRINT @id_cart
	--lấy ra số lượng của sản phẩm có trong giỏ hàng
	SELECT @amount = dbo.Cart_Item.Amount
	FROM dbo.Cart_Item
	WHERE dbo.Cart_Item.Id_Product = @id_product
	AND dbo.Cart_Item.Id_Cart = @id_cart
	PRINT @amount
	--nếu giỏ hàng chưa có sản phẩm 
	IF (@amount IS NULL)
	BEGIN
		PRINT 'Insert Success'
		--tiến hành thêm sản phẩm vào trong giỏ hàng
		INSERT INTO dbo.Cart_Item
		        ( Id_Cart, Amount, Id_Product )
		VALUES  ( @id_cart, -- Id_Cart - int
		          1, -- Amount - int
		          @id_product  -- Id_Product - int
		          )
	END
	--nếu trong giỏ hàng đã có sản phẩm ==> tăng số lượng sản phẩm đó trong giỏ hàng
	ELSE
	BEGIN
		UPDATE dbo.Cart_Item
		SET dbo.Cart_Item.Amount = @amount + 1
		WHERE dbo.Cart_Item.Id_Product = @id_product
		AND dbo.Cart_Item.Id_Cart = @id_cart
	END
END
GO 

--Trigger Cal_Total_Order: Khi thêm sản phẩm được mua trong một đơn hàng, tính toán tổng tiền
-- phải trả của cả đơn hàng đó và cập nhật vào bảng Orders.
-- Sau đó, tiến hành xóa sản phẩm được mua ra khỏi giỏ hàng, cập nhật lại số lượng sản phẩm
-- của shop và tạo miêu tả cho đơn hàng
CREATE TRIGGER dbo.Cal_Total_Orders
ON dbo.Orders_Item
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @id_Order INT, @total FLOAT, @delivery FLOAT, @id_product INT, @amount INT
	SELECT @id_Order = Inserted.Id_Order, @id_product = Inserted.Id_Product,
			@amount = Inserted.Amount
	FROM Inserted
	-- lấy ra tiền vận chuyển cho đơn hàng
	SELECT @delivery = dbo.Orders.Delivery 
	FROM dbo.Orders
	WHERE dbo.Orders.Id_Order = @id_Order
	-- lấy tổng tiền của đơn hàng dựa vào id_Order
	SELECT @total = SUM(dbo.Orders_Item.Total)
	FROM dbo.Orders_Item
	WHERE dbo.Orders_Item.Id_Order = @id_Order
	GROUP BY dbo.Orders_Item.Id_Order
	--cập nhật lại tổng tiền trong bảng Orders
	UPDATE dbo.Orders
	--tổng tiền sẽ bằng tổng số tiền của các sản phẩm trong 1 đơn hàng + tiền vận chuyển
	SET dbo.Orders.Total_Order = @total + @delivery    
	WHERE dbo.Orders.Id_Order = @id_Order

	IF (NOT EXISTS (SELECT * FROM Deleted))
	BEGIN
		-- xóa giỏ hàng sau khi mua hàng
		DELETE FROM dbo.Cart_Item
		WHERE dbo.Cart_Item.Id_Product = @id_product
		AND dbo.Cart_Item.Id_Cart = (SELECT dbo.Orders.Id_Users
									 FROM dbo.Orders
									 WHERE dbo.Orders.Id_Order = @id_Order)
		DECLARE @quantity INT
		SELECT @quantity = dbo.Product.Amount
		FROM dbo.Product
		WHERE dbo.Product.Id_Product = @id_product	
		--cập nhật là số lượng hàng trong bảng Product
		UPDATE dbo.Product 
		SET dbo.Product.Amount = @quantity - @amount
		WHERE dbo.Product.Id_Product = @id_product
		-- thêm miêu tả cho đơn hàng
		DECLARE @description NVARCHAR(1000)
		SELECT @description = dbo.Orders.Description
		FROM dbo.Orders
		WHERE dbo.Orders.Id_Order = @id_Order	
		DECLARE @name_product NVARCHAR(500)
		SELECT @name_product = dbo.Product.Name_Product
		FROM dbo.Product 
		WHERE dbo.Product.Id_Product = @id_product
		-- nếu trong mô tả của đơn hàng không tồn tại sản phẩm thì thêm tên sản phẩm vào mô tả của đơn hàng
		IF (@description = '')
		BEGIN
			UPDATE dbo.Orders
			SET dbo.Orders.Description = @name_product
			WHERE dbo.Orders.Id_Order = @id_Order
		END
		ELSE
		-- nếu đơn hàng đã chứa sản phẩm ==> mô tả đơn hàng = tên sản phẩm đầu tiên + (n) sản phẩm khác
		-- với n là số lượng các sản phẩm còn lại trong đơn hàng đó
		BEGIN
			--Hàm CAST dùng để chuyển đổi một biểu thức từ một kiểu dữ liệu này sang kiểu dữ liệu khác. 
			-- CAST(bieuthuc AS kieudulieu [(do_dai)])
			UPDATE dbo.Orders
			SET dbo.Orders.Description = @name_product + N'và' + CAST((SELECT COUNT(dbo.Orders_Item.Id_Product)
																		FROM dbo.Orders_Item
																		WHERE dbo.Orders_Item.Id_Order = @id_Order)-1 AS NVARCHAR(10)) + N'Sản phẩm khác'
			WHERE dbo.Orders.Id_Order = @id_Order
		END
	END
END
GO 


--Trigger InsertStatus : dùng để thêm trạng thái của đơn hàng và đưa ra ip_shipper của đơn hàng đó
CREATE TRIGGER dbo.InsertStatus
ON dbo.Orders_Track
FOR INSERT
AS
BEGIN
	DECLARE @new_status INT, @id_shipper INT, @id_order INT, @description NVARCHAR(1000), @id_track INT
	SELECT @new_status = Inserted.Status, @id_order = Inserted.Id_Order, @description = Inserted.Description,
			@id_track = Inserted.Id_Track, @id_shipper = Inserted.Id_Shipper
	FROM Inserted
	-- @newstatus là trạng thái người dùng đang chờ lấy hàng
	IF (@new_status = 2)
	BEGIN
		-- đưa ra một ip_shipper ngẫu nhiên
		-- select top dùng để lấy bản ghi từ 1 hoặc nhiều bảng trong sql và giới hạn số bản ghi trả về dựa trên giá trị hoặc phần trăm cố định
		-- Top 1 => lấy 1 hàng đầu tiên từ bộ kết quả
		-- order by : xếp thứ tự kết quả
		-- Hàm NEWID() mỗi lần được gọi sẽ trả về một giá trị kiểu uniqueidentifier bất kì và duy nhất, --> mệnh đề Order By NewId() giúp cho câu lệnh chọn ra 1 bản ghi hoàn toàn ngẫu nhiên
		-- kiểu dữ liệu uniqueidentifier: một cột được khai báo kiểu dữ liệu này sẽ sử dụng 16 bytes trong bộ nhớ máy tính. ==> có thể dùng Hàm NEWID() để tạo ra giá trị này một cách tự động
		SET @id_shipper = (SELECT TOP 1 Id_Users FROM dbo.GetShipper()ORDER BY NEWID())
		-- cập nhật lại bản Order_Track
		UPDATE dbo.Orders_Track
		SET dbo.Orders_Track.Id_Order = @id_order,
			dbo.Orders_Track.Date_Update  = GETDATE(),
			dbo.Orders_Track.Description = @description,
			dbo.Orders_Track.Id_Shipper = @id_shipper
		WHERE dbo.Orders_Track.Id_Track = @id_track
	END
	ELSE
    BEGIN
    	IF (@new_status = 0 )
		-- đơn hàng đã hủy
		BEGIN
			UPDATE dbo.Orders_Track
			SET dbo.Orders_Track.Id_Order = @id_order,
				dbo.Orders_Track.Date_Update = GETDATE(),
				dbo.Orders_Track.Description = @description,
				dbo.Orders_Track.Id_Shipper = NULL
			WHERE dbo.Orders_Track.Id_Track = @id_track
		END
		ELSE
		BEGIN
			-- tiến hành lấy id_shipper trước vì không thể để ip_shipper null được (vì khi ip_shipper null là status = 0 ==> kết thúc quá trình làm việc của shipper)
			SET @id_shipper = (SELECT DISTINCT (dbo.Orders_Track.Id_Shipper)
								FROM dbo.Orders_Track
								WHERE dbo.Orders_Track.Id_Order = @id_order 
								AND dbo.Orders_Track.Id_Shipper IS NOT NULL)
			UPDATE dbo.Orders_Track
			SET dbo.Orders_Track.Id_Order = @id_order,
				dbo.Orders_Track.Date_Update = GETDATE(),
				dbo.Orders_Track.Description = @description,
				dbo.Orders_Track.Id_Shipper = @id_shipper
			WHERE dbo.Orders_Track.Id_Track = @id_track
		END
    END
END
GO 

-- Trigger UpdateStatus: cập nhật lại trạng thái mới nhất của đơn hàng (khi trạng thái đơn hàng chuyển từ chờ lấy hàng sang đã hủy; đang giao; đã giao; trả hàng, hoàn tiền)
CREATE TRIGGER dbo.UpdateStatus 
ON dbo.Orders_Track
FOR UPDATE
AS
BEGIN
	DECLARE @newstatus INT, @oldstatus INT, @id_order INT
	SELECT @newstatus = Inserted.Status, @oldstatus = Deleted.Status, @id_order = Inserted.Id_Order
	FROM Inserted, Deleted
	-- tiến hành cập nhật trạng thái cho đơn hàng
	UPDATE dbo.Orders
	SET dbo.Orders.Status = @newstatus
	WHERE dbo.Orders.Id_Order = @id_order
END
GO 

--Trigger ConfirmOrder:
CREATE TRIGGER dbo.ConfirmOrder 
ON dbo.Orders
FOR UPDATE
AS
BEGIN
	DECLARE @newid_order INT, @new_status INT, @old_status INT, @exists INT
	SELECT @newid_order = Inserted.Id_Order, @new_status = Inserted.Status, @old_status = Deleted.Status
	FROM Inserted, Deleted

	--Shipper_id đang ở nhận giá trị null
	-- tiến hành kiểm tra xem Id_order và status mới nhập vào có tồn tại trong Order_Track hay chưa
	-- nếu chưa tồn tại thì thêm vào (sẽ thực hiện khi status từ chờ lấy hàng chuyển sang đã hủy; đang giao; đã giao; trả hàng, hoàn tiền)
	IF ((SELECT COUNT(*) FROM dbo.Orders_Track WHERE dbo.Orders_Track.Id_Order = @newid_order AND dbo.Orders_Track.Status = @new_status) = 0)
	BEGIN
		IF (@new_status = 2)
		BEGIN
			INSERT INTO dbo.Orders_Track
			        ( Id_Order ,
			          Date_Update ,
			          Status 			         
			        )
			VALUES  ( @newid_order , -- Id_Order - int
			          GETDATE() , -- Date_Update - datetime
			          @new_status  -- Status - int			         
			        )
		END
		ELSE
		BEGIN
			IF (@new_status != 1)
			BEGIN
				INSERT INTO dbo.Orders_Track
			        ( Id_Order ,
			          Date_Update ,
			          Status 			         
			        )
			VALUES  ( @newid_order , -- Id_Order - int
			          GETDATE() , -- Date_Update - datetime
			          @new_status  -- Status - int			         
			        )
			END
		END
	END
END
GO 

--Trigger AddCart: thêm cart khi thêm User; lấy id_users từ bảng Users thêm vào id_cart của bảng Cart
CREATE TRIGGER dbo.AddCart 
ON dbo.Users
FOR INSERT
AS
BEGIN
	DECLARE @id_users INT
	SELECT @id_users = Inserted.Id_Users
	FROM Inserted
	INSERT INTO dbo.Cart (Id_Cart, Id_Users) SELECT Id_Users, Id_Users FROM dbo.Users WHERE dbo.Users.Id_Users =@id_users	        
END
GO

--Trigger AddShop: Thêm Shop khi thêm Users; lấy id_users, avatar, usename từ bảng Users thêm vào Id_Users, Pictures, Name_Shop của bảng Shop
CREATE TRIGGER dbo.AddShop
ON dbo.Users
FOR INSERT
AS
BEGIN
	DECLARE @id_Users INT
	SELECT @id_Users = Inserted.Id_Users
	FROM Inserted
	INSERT INTO dbo.Shop
	        ( Name_Shop,
			  Pictures,
			  Id_Users
	        )
	SELECT dbo.Users.Username, dbo.Users.Avatar, dbo.Users.Id_Users
	FROM dbo.Users
	WHERE dbo.Users.Id_Users = @id_Users
END
GO


----------------------------------------------VIEW----------------------------------------------
--View User_LoadAllProduct : lấy danh sách thiết bị từ bảng Product
CREATE VIEW dbo.User_LoadAllProduct
AS 
	SELECT * FROM dbo.Product
GO

--View User_LoadProduct : lấy danh sách thiết bị từ bảng Product
CREATE VIEW dbo.User_LoadProduct
AS 
	SELECT * FROM dbo.Product
GO

-- View Order_All: lấy danh sách đơn hàng theo Id_Users của Users từ bảng Orders
CREATE VIEW dbo.Order_All
AS 
	SELECT dbo.Users.Username, dbo.Orders.Id_Order, dbo.Orders.Delivery, dbo.Orders.Create_Orders, dbo.Orders.Status, dbo.Orders.Description,
			dbo.Address.Address, dbo.Orders.Total_Order
	FROM dbo.Users, dbo.Address, dbo.Orders
	WHERE dbo.Orders.Id_Users = dbo.Address.Id_Users
	AND dbo.Orders.Id_Users = dbo.Users.Id_Users
GO 


-- View Order_Cancel: lấy ra danh sách các đơn hàng ở trạng thái hủy đơn
CREATE VIEW Order_Cancel
AS 
	SELECT * FROM dbo.Order_All WHERE Status = 0
GO 

-- View Order_Confirm : lấy ra danh sách các đơn hàng ở trạng thái đang chờ lấy hàng
CREATE VIEW dbo.Order_Confirm
AS
	SELECT * FROM dbo.Order_All WHERE Status = 1
GO

--View Order_Delivered:  lấy ra danh sách các đơn hàng ở trạng thái đã giao hàng
CREATE VIEW dbo.Order_Delivered
AS 
	SELECT * FROM dbo.Order_All WHERE Status = 4
GO

--View Order_Delivering:  lấy ra danh sách các đơn hàng ở trạng thái đang giao hàng
CREATE VIEW dbo.Order_Delivering
AS
	SELECT * FROM dbo.Order_All WHERE Status = 3
GO 

--View Order_Receive:  lấy ra danh sách các đơn hàng ở trạng thái chờ lấy hàng
CREATE VIEW dbo.Order_Receive
AS
	SELECT * FROM dbo.Order_All WHERE Status = 2
GO

--View User_Order_Items: lấy danh sách tất cả các sản phẩm trong giỏ hàng của User
CREATE VIEW dbo.Order_Items
AS
	SELECT * FROM dbo.Orders_Item
GO

-- View User_Orders: lấy các thông tin đơn hàng của người mua
CREATE VIEW User_Orders
AS
	SELECT * FROM dbo.Orders
GO 

-- View Category: lấy tất cả các loại thiết bị
CREATE VIEW dbo.Category_All
AS
	SELECT * FROM dbo.Category
GO

--View Product_All : lấy ra tất cả các sản phẩm
CREATE VIEW dbo.Product_All
AS
	SELECT * FROM dbo.Product
GO 

--View Shop_All: lấy ra tất cả shop
CREATE VIEW dbo.Shop_All
AS
	SELECT * FROM dbo.Shop
GO 

----------------------------------------------STORE PROCEDURE----------------------------------------------
--Procedure ChangeStatus: đầu vào là id_order (id của đơn hàng) và biến trạng thái (status)
-----tiến hành thực hiện cập nhật trạng thái đơn hàng có id_order được truyền vào (trong bảng Orders) với biến trạng thái
CREATE PROCEDURE dbo.StatusChange (@id_order INT, @status INT)
AS 
BEGIN
	UPDATE dbo.Orders
	SET dbo.Orders.Status = @status
	WHERE dbo.Orders.Id_Order = @id_order
END
GO 

--Procedure Detail_Order: lấy ra thông tin chi tiết của đơn hàng
CREATE PROCEDURE dbo.Detail_Order(@id_shipper INT)
AS 
BEGIN
	select GLS.Id_Order, dbo.Address.Name, dbo.Address.Address, dbo.Address.Phone, dbo.Orders.Description, dbo.Orders.Payment, dbo.Orders.Total_Order, dbo.Orders.Status
	FROM dbo.GetLatestStatus() GLS, dbo.Orders, dbo.Address
	WHERE GLS.Id_Order = dbo.Orders.Id_Order
	AND dbo.Orders.Id_Address = dbo.Address.Id_Address
	AND GLS.Id_Shipper = @id_shipper
END
GO 

--Procedure FindProducts: lấy ra tất cả sản phẩm của 1 shop theo tên sản phẩm, loại, kho hàng. Trả về bảng bao gồm chi tiết các sản phẩm của Shop từ bảng Product
CREATE PROCEDURE dbo.FindProduct (@id_shop INT, @name NVARCHAR(500) NULL, @category INT, @amountMin INT, @amountMax INT)
AS
BEGIN
	IF (@name IS NULL AND @category = 0 )
	BEGIN
		SELECT * FROM dbo.Product
		WHERE @id_shop = dbo.Product.Id_Shop
		AND dbo.Product.Amount BETWEEN @amountMin AND @amountMax
	END
	ELSE IF (@name IS NULL AND @amountMin = 0 AND @amountMax = 0)
	BEGIN
		SELECT * FROM dbo.Product
		WHERE @category= dbo.Product.Id_Category
		AND dbo.Product.Id_Shop = @id_shop
	END
	ELSE IF (@category = 0 AND @amountMin = 0 AND @amountMax = 0)
	BEGIN
		SELECT * FROM dbo.Product
		WHERE dbo.Product.Name_Product LIKE '%'+@name+'%'
		AND @id_shop = dbo.Product.Id_Shop
	END
	ELSE IF (@category = 0)
	BEGIN
		SELECT * FROM dbo.Product
		WHERE @id_shop = dbo.Product.Id_Shop
		AND dbo.Product.Name_Product LIKE '%'+@name+'%'
		AND dbo.Product.Amount BETWEEN @amountMin AND @amountMax
	END
	ELSE IF (@name IS NULL)
	BEGIN
		SELECT * FROM dbo.Product
		WHERE @category = dbo.Product.Id_Category
		AND @id_shop = dbo.Product.Id_Shop
		AND dbo.Product.Amount BETWEEN @amountMin AND @amountMax
	END
	ELSE IF (@amountMin = 0 AND @amountMax = 0)
	BEGIN
		SELECT * FROM dbo.Product
		WHERE dbo.Product.Id_Category = @category
		AND  dbo.Product.Id_Shop = @id_shop
		AND dbo.Product.Name_Product LIKE '%'+@name+'%'
	END
	ELSE
    BEGIN
    	SELECT * FROM dbo.Product
		WHERE dbo.Product.Id_Category = @category
		AND dbo.Product.Id_Shop = @id_shop
		AND dbo.Product.Name_Product LIKE '%'+@name+'%'
		AND dbo.Product.Amount BETWEEN @amountMin AND @amountMax
    END
END
GO 

--Procedure GetProductById: lấy thông tin sản phẩm tương ứng với id của sản phẩm được truyền vào
CREATE PROCEDURE dbo.GetProductById(@id_product INT)
AS
BEGIN
	SELECT * FROM dbo.Product
	WHERE dbo.Product.Id_Product = @id_product
END
GO


--Procedure GetIdFromEmail: lấy id_user của người dùng thông qua email nhập vào
CREATE PROCEDURE dbo.GetIdFromEmail (@email NVARCHAR(100))
AS
BEGIN
	SELECT dbo.Users.Id_Users
	FROM dbo.Users
	WHERE dbo.Users.Email = @email
END
GO 

--Procedure GetOrdersOfUsers: lấy tất cả thông tin đơn hàng của một user có id_users được truyền vào
CREATE PROCEDURE dbo.GetOrdersOfUsers(@id_users INT)
AS 
BEGIN
	SELECT * FROM dbo.User_Orders
	WHERE Id_Users = @id_users
END
GO 

--Procedure GetProduct: lấy ra tất cả các sản phẩm của một shop.Truyền vào id_shop, ==> kết quả trả về một bảng bao gồm chi tiết các sản phẩm của shop từ bảng product
CREATE PROCEDURE dbo.GetProduct(@id_shop INT)
AS
BEGIN
	SELECT * FROM dbo.Product
	WHERE dbo.Product.Id_Shop = @id_shop
END
GO 

--Procedure ListOrderDetailUser: danh sách đơn hàng chi tiết của người dùng theo từng id_order
CREATE PROCEDURE dbo.ListOrderDetailUser(@id_order INT)
AS
BEGIN
	SELECT dbo.Orders_Item.Id_Order,dbo.Orders_Item.Id_Product, dbo.Product.Price, dbo.Orders_Item.Amount, dbo.Orders_Item.Discount, dbo.Orders_Item.Status, dbo.Product.Name_Product, dbo.Product.Pictures, dbo.Product.Description
	FROM dbo.Orders_Item
	INNER JOIN dbo.Product
	ON Product.Id_Product = Orders_Item.Id_Product
	AND dbo.Orders_Item.Id_Order = @id_order
END
GO 

--Procedue ListOrderUser: lấy ra thông tin danh sách đơn hàng của người dùng theo id và trạng thái
CREATE PROCEDURE dbo.ListOrderUser(@id_users INT, @status INT)
AS
BEGIN
	--nếu trạng thái đơn hàng đưa vào là khác với -1=> lấy ra thông tin đơn hàng dựa theo status và id_users đó
	IF (@status != -1)
	BEGIN
		SELECT dbo.Orders.Id_Order, dbo.Shop.Name_Shop, dbo.Orders.Delivery, dbo.Orders.Payment, dbo.Orders.Create_Orders, dbo.Orders.Total_Order, dbo.Orders.Status
		FROM dbo.Orders, dbo.Shop
		WHERE dbo.Orders.Id_Users = @id_users
		AND dbo.Orders.Status = @status
		AND dbo.Orders.Id_Shop=dbo.Shop.Id_Shop
	END
	--ngược lại thì đưa ra danh sách của tất cả các đơn hàng theo id_users nhập vào
	ELSE
	BEGIN
		SELECT dbo.Orders.Id_Order, dbo.Shop.Name_Shop, dbo.Orders.Delivery, dbo.Orders.Payment, dbo.Orders.Create_Orders, dbo.Orders.Total_Order, dbo.Orders.Status
		FROM dbo.Orders, dbo.Shop
		WHERE dbo.Orders.Id_Users = @id_users		
		AND dbo.Orders.Id_Shop=dbo.Shop.Id_Shop
	END
END
GO 

-- Procedure GetShipper:
CREATE PROCEDURE dbo.StoreProcedure_GetShipper
AS
BEGIN
	SELECT * FROM dbo.Users
	WHERE dbo.Users.RoleID = 3
END
GO 

--Procedure ReportAdminIndex
CREATE PROCEDURE dbo.ReportAdminIndex
AS
BEGIN
	DECLARE @total_status FLOAT, @orders INT, @users INT, @ship FLOAT, @discount FLOAT, @products INT
	SET @total_status =(SELECT SUM(dbo.Orders.Total_Order) FROM dbo.Orders WHERE dbo.Orders.Status=2)
	SET @orders =(SELECT COUNT(*) FROM dbo.Orders WHERE dbo.Orders.Status=2)
	SET @users =(SELECT COUNT(*) FROM dbo.Users WHERE dbo.Users.RoleID = 2)
	SET @ship =(SELECT SUM(dbo.Orders.Delivery) FROM dbo.Orders WHERE dbo.Orders.Status=2)
	SET @discount =(SELECT SUM(dbo.Orders_Item.Discount) FROM dbo.Orders_Item)
	SET @products =(SELECT SUM(dbo.Orders_Item.Amount) FROM dbo.Orders_Item)
	SELECT @total_status AS [Total], @orders AS [Orders], @users AS [Users], @ship AS [Ship], @discount AS [Discount], @products AS [Products]
END
GO 

--Procedure ResetPassword: đặt lại mật khẩu cho người dùng
CREATE PROCEDURE dbo.ResetPassword(@id_users INT)
AS
BEGIN
	UPDATE dbo.Users
	SET dbo.Users.Password = '1234567'
	WHERE dbo.Users.Id_Users=@id_users
END
GO 


--Procedure AccountChangePassword: chỉnh sửa lại password của bảng Users khi thay đổi mật khẩu
CREATE PROCEDURE dbo.AccountChangePassword(@email NVARCHAR(100), @password NVARCHAR(100))
AS 
BEGIN
	UPDATE dbo.Users
	SET dbo.Users.Password = @password
	WHERE dbo.Users.Email = @email
END
GO 

--Procedure AccountResgister: thêm users khi đăng kí tài khoản 
CREATE PROCEDURE dbo.AccountResgister(@username NVARCHAR(50), @password NVARCHAR(100), @email NVARCHAR(100))
AS
BEGIN
	INSERT INTO dbo.Users
	        ( Username ,
	          Email ,
	          Password 	          
	        )
	VALUES  (@username , -- Username - nvarchar(50)
	         @email, -- Email - nvarchar(100)
	         @password  -- Password - nvarchar(100)	         
	        )
END
GO 

--Procedure ConfirmProductAdmin: 
CREATE PROCEDURE dbo.ConfirmProductAdmin(@id_product INT)
AS
BEGIN
	UPDATE dbo.Product
	SET dbo.Product.Status = 1
	WHERE dbo.Product.Id_Product = @id_product
    
END
GO 

--Procedure EditProfile: chỉnh sửa thông tin của User
CREATE PROCEDURE dbo.EditProfile (@id_users INT, @username NVARCHAR(50), @email NVARCHAR(100), @address NVARCHAR(100), @gender NVARCHAR(5), @phone NVARCHAR(15), @birthday DATE, @avatar NVARCHAR(100))
AS
BEGIN
	UPDATE dbo.Users
	SET dbo.Users.Username = @username,
		dbo.Users.Email = @email,
		dbo.Users.Address = @address,
		dbo.Users.Gender = @gender,
		dbo.Users.Phone = @phone,
		dbo.Users.Birthday = @birthday,
		dbo.Users.Avatar = @avatar
	WHERE dbo.Users.Id_Users = @id_users
END
GO 

--Procedure GetAddressById: lấy ra thông tin của địa chỉ dựa vào id_address nhập vào
CREATE PROCEDURE dbo.GetAddressById(@id_address INT)
AS
BEGIN
	SELECT * FROM dbo.Address
	WHERE dbo.Address.Id_Address = @id_address
END
GO 


--Procedure GetCartItem: thêm sản phẩm vào trong giỏ hàng
CREATE PROCEDURE dbo.GetCartItem(@id_cart INT)
AS 
BEGIN
	SELECT dbo.Product.Name_Product, dbo.Product.Pictures, dbo.Cart_Item.Amount, dbo.Product.Price
	FROM dbo.Product, dbo.Cart_Item
	WHERE dbo.Cart_Item.Id_Cart = @id_cart
END
GO 

--Procedure GetOrderDetail:
CREATE PROCEDURE dbo.GetOrderDetail(@id_order INT)
AS 
BEGIN
	SELECT dbo.Orders.Id_Order, dbo.Orders.Id_Shop, dbo.Shop.Name_Shop, dbo.Orders.Delivery, dbo.Orders.Payment, dbo.Orders.Create_Orders, dbo.Orders.Status, dbo.Orders.Id_Address,
			dbo.Orders.Total_Order, dbo.Product.Pictures, dbo.Orders_Item.Id_Product, dbo.Product.Name_Product, dbo.Orders_Item.Price, dbo.Orders_Item.Amount,
			dbo.Orders_Item.Discount, dbo.Orders_Item.Total
	FROM dbo.Orders, dbo.Orders_Item, dbo.Shop, dbo.Product
	WHERE dbo.Orders.Id_Order = dbo.Orders_Item.Id_Order
	AND dbo.Shop.Id_Shop = dbo.Orders.Id_Shop
	AND dbo.Orders.Id_Order = @id_order
	AND dbo.Product.Id_Product = dbo.Orders_Item.Id_Product
END
GO 

--Procedure GetUserAddress: lấy tất cả địa chỉ của User với tham số truyền vào là Id_users của User
CREATE PROCEDURE dbo.GetUserAddress(@id_users INT)
AS
BEGIN
	SELECT * FROM dbo.Address
	WHERE dbo.Address.Id_Users = @id_users
END
GO 

--Procedure ListProductOfShop: đưa ra danh sách sản phẩm của shop
CREATE PROCEDURE dbo.ListProductOfShop(@id_shop INT)
AS
BEGIN
	SELECT dbo.Product.Id_Product AS ID, dbo.Product.Name_Product AS [Product Name], dbo.Product.Price, dbo.Product.Amount, dbo.Product.Pictures, dbo.Category.Name_Category AS [Type Name], dbo.Product.Description
	FROM dbo.Product, dbo.Category
	WHERE dbo.Product.Id_Shop = @id_shop
	AND dbo.Category.Id_Category = dbo.Product.Id_Category
END
GO 

--Procedure LoadUserCart: load giỏ hàng của người dùng
CREATE PROCEDURE dbo.LoadUserCart(@id_users INT)
AS
BEGIN
	SELECT dbo.Product.Pictures, dbo.Product.Name_Product, dbo.Product.Description, dbo.Product.Price, dbo.Product.Id_Shop, dbo.Cart_Item.Amount, dbo.Cart_Item.Id_Product
	FROM dbo.Cart, dbo.Cart_Item, dbo.Product, dbo.Shop
	WHERE dbo.Cart.Id_Users = @id_users
	AND dbo.Cart.Id_Cart = dbo.Cart_Item.Id_Cart
	AND dbo.Product.Id_Product = dbo.Cart_Item.Id_Product
	AND dbo.Product.Id_Shop = dbo.Shop.Id_Shop    
END
GO 

--Procedure StoreProcedure_Login: lấy ra user theo email và password. kiểm tra đăng nhập có hợp lệ hay không
CREATE PROCEDURE dbo.StoreProcedure_Login(@email NVARCHAR(100), @password NVARCHAR(100))
AS 
BEGIN
	DECLARE @passhash NVARCHAR(100)
	SET @passhash = dbo.MaHoaMD5(@password)
	SELECT * FROM dbo.Users
	WHERE dbo.Users.Email = @email
	AND dbo.Users.Password = @passhash
END
GO 

--Procedure ProductByShop: lấy tất cả thông tin sản phẩm của một shop có id_shop được truyền vào
CREATE PROCEDURE dbo.ProductByShop(@id_shop INT)
AS 
BEGIN
	SELECT * FROM dbo.Product
	WHERE dbo.Product.Id_Shop = @id_shop
END
GO 

--Procedure ProductByCategory: lấy tất cả thông tin sản phẩm theo mã loại (id_category) được truyền vào
CREATE PROCEDURE dbo.ProductByCategory(@id_category INT)
AS
BEGIN
	SELECT * FROM dbo.Product
	WHERE dbo.Product.Id_Category = @id_category
END
GO 

--Procedure SearchProduct: lấy thông tin của sản phẩm theo tên(name_product) và mã loại(id_category),  nếu id_category=0 thì chia lấy sản phẩm theo tên
CREATE PROCEDURE dbo.SearchProduct(@name_product NVARCHAR(500), @id_category INT)
AS
BEGIN
	IF (@id_category = 0)
	BEGIN
		SELECT * FROM dbo.Product
		WHERE dbo.Product.Name_Product LIKE N'%'+@name_product+'%'
		OR dbo.Product.Description LIKE N'%'+@name_product+'%'
	END
	ELSE
	BEGIN
		SELECT * FROM dbo.Product
		WHERE (dbo.Product.Name_Product LIKE N'%'+@name_product+'%'
		OR dbo.Product.Description LIKE N'%'+@name_product+'%')
		AND dbo.Product.Id_Category = @id_category
	END
END
GO 

--Procedure ShipperOrder: lấy ra thông tin của đơn hàng đang được theo dõi giao cho shipper
CREATE PROCEDURE dbo.ShipperOrder(@id_shipper INT)
AS
BEGIN
	SELECT * FROM dbo.Orders_Track
	WHERE dbo.Orders_Track.Id_Shipper = @id_shipper
	AND dbo.Orders_Track.Date_Update = dbo.GetLatestDate(Id_Order)
END
GO 

--Procedure UserLogin
CREATE PROCEDURE dbo.UserLogin(@username NVARCHAR(50), @password NVARCHAR(100))
AS
BEGIN
	DECLARE @count INT
	DECLARE @res BIT
    SELECT @count = COUNT(*) FROM dbo.Users WHERE dbo.Users.Username = @username AND dbo.Users.Password = @password
	IF (@count > 0)
	BEGIN
		SET @res = 1
	END
	ELSE
	BEGIN
		SET @res = 0
	END
	SELECT @res
END
GO 

--Procedure ViewOrders: lấy ra thông tin đơn hàng của Shop dựa theo tình trạng đơn hàng với tham số truyền vào là Id của shop và tình trạng đơn hàng
CREATE PROCEDURE dbo.ViewOrders(@id_shop INT, @status INT)
AS
BEGIN
	IF (@status != -1)
	BEGIN
		SELECT dbo.Order_All.Username, dbo.Order_All.Id_Order, dbo.Order_All.Delivery, dbo.Order_All.Create_Orders, dbo.Order_All.Status, dbo.Order_All.Description, dbo.Order_All.Address, dbo.Order_All.Total_Order
		FROM dbo.Order_All 
		INNER JOIN dbo.Orders
		ON dbo.Orders.Id_Order = dbo.Order_All.Id_Order
		WHERE dbo.Orders.Id_Shop = @id_shop
	END
END
GO 

----------------------------------------------INSERT INTO----------------------------------------------
INSERT INTO dbo.Role
        ( RoleName )
VALUES  ( N'Admin'  -- RoleName - nvarchar(30)
          )
INSERT INTO dbo.Role
        ( RoleName )
VALUES  ( N'User'  -- RoleName - nvarchar(30)
          )
INSERT INTO dbo.Role
        ( RoleName )
VALUES  ( N'Shipper'  -- RoleName - nvarchar(30)
          )
INSERT INTO dbo.Users
        ( Username ,
          Email ,
          Password ,
          Full_Name ,
          Address ,
          Gender ,
          Phone ,
          Birthday ,
          RoleID ,
          Avatar ,
          Create_User
        )
VALUES  ( N'binhan' , -- Username - nvarchar(50)
          N'doanlebinhan9a6@gamil.com' , -- Email - nvarchar(100)
          N'281163' , -- Password - nvarchar(100)
          N'Bình An' , -- Full_Name - nvarchar(200)
          N'Võ Văn Ngân, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'Nữ', -- Gender - nvarchar(5)
          N'0359231769' , -- Phone - nvarchar(15)
          '2000-07-28', -- Birthday - date
          1 , -- RoleID - int
          NULL, -- Avatar - nvarchar(100)
          GETDATE()  -- Create_User - date
        )
INSERT INTO dbo.Users
        ( Username ,
          Email ,
          Password ,
          Full_Name ,
          Address ,
          Gender ,
          Phone ,
          Birthday ,
          RoleID ,
          Avatar ,
          Create_User
        )
VALUES  ( N'hoangan' , -- Username - nvarchar(50)
          N'hoangan281163@gamil.com' , -- Email - nvarchar(100)
          N'281163' , -- Password - nvarchar(100)
          N'Hoàng An' , -- Full_Name - nvarchar(200)
          N'Võ Văn Ngân, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'Nam', -- Gender - nvarchar(5)
          N'0359231769' , -- Phone - nvarchar(15)
          '2000-07-28', -- Birthday - date
          3 , -- RoleID - int
          NULL, -- Avatar - nvarchar(100)
          GETDATE()  -- Create_User - date
        )
INSERT INTO dbo.Users
        ( Username ,
          Email ,
          Password ,
          Full_Name ,
          Address ,
          Gender ,
          Phone ,
          Birthday ,
          RoleID ,
          Avatar ,
          Create_User
        )
VALUES  ( N'khainguyen' , -- Username - nvarchar(50)
          N'khainguyen2811@gamil.com' , -- Email - nvarchar(100)
          N'281163' , -- Password - nvarchar(100)
          N'Khải Nguyên' , -- Full_Name - nvarchar(200)
          N'Võ Văn Ngân, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'Nam', -- Gender - nvarchar(5)
          N'0359231769' , -- Phone - nvarchar(15)
          '2000-11-28', -- Birthday - date
          2 , -- RoleID - int
          NULL, -- Avatar - nvarchar(100)
          GETDATE()  -- Create_User - date
        )
INSERT INTO dbo.Users
        ( Username ,
          Email ,
          Password ,
          Full_Name ,
          Address ,
          Gender ,
          Phone ,
          Birthday ,
          RoleID ,
          Avatar ,
          Create_User
        )
VALUES  ( N'khailinh' , -- Username - nvarchar(50)
          N'khailinh@gamil.com' , -- Email - nvarchar(100)
          N'281163' , -- Password - nvarchar(100)
          N'Khải Linh' , -- Full_Name - nvarchar(200)
          N'Võ Văn Ngân, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'Nữ', -- Gender - nvarchar(5)
          N'0359231769' , -- Phone - nvarchar(15)
          '2000-11-28', -- Birthday - date
          NULL, -- RoleID - int
          NULL, -- Avatar - nvarchar(100)
          GETDATE()  -- Create_User - date
        )

INSERT INTO dbo.Address
        ( Id_Users ,
          Name ,
          Address ,
          Phone ,
          Default_Address
        )
VALUES  ( 1 , -- Id_Users - int
          N'binhan' , -- Name - nvarchar(100)
          N'Bình Thọ, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'0359231769' , -- Phone - nvarchar(20)
          1  -- Default_Address - int
        )
INSERT INTO dbo.Address
        ( Id_Users ,
          Name ,
          Address ,
          Phone ,
          Default_Address
        )
VALUES  ( 1 , -- Id_Users - int
          N'binhan' , -- Name - nvarchar(100)
          N'Linh Chiểu, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'0359231769' , -- Phone - nvarchar(20)
          0  -- Default_Address - int
        )
INSERT INTO dbo.Address
        ( Id_Users ,
          Name ,
          Address ,
          Phone ,
          Default_Address
        )
VALUES  ( 1 , -- Id_Users - int
          N'binhan' , -- Name - nvarchar(100)
          N'Linh Trung, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'0359231769' , -- Phone - nvarchar(20)
          0  -- Default_Address - int
        )
INSERT INTO dbo.Address
        ( Id_Users ,
          Name ,
          Address ,
          Phone ,
          Default_Address
        )
VALUES  ( 3 , -- Id_Users - int
          N'khainguyen' , -- Name - nvarchar(100)
          N'Bình Thọ, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'0359231769' , -- Phone - nvarchar(20)
          1  -- Default_Address - int
        )
INSERT INTO dbo.Address
        ( Id_Users ,
          Name ,
          Address ,
          Phone ,
          Default_Address
        )
VALUES  ( 3 , -- Id_Users - int
          N'khainguyen' , -- Name - nvarchar(100)
          N'Lê Văn Việt, Hồ Chí Minh' , -- Address - nvarchar(100)
          N'0359231769' , -- Phone - nvarchar(20)
          0  -- Default_Address - int
        )

INSERT INTO dbo.Shop
        ( Address ,
          Id_Users ,
          Name_Shop ,
          Description ,
          Pictures
        )
VALUES  ( N'Bến Tra' , -- Address - nvarchar(100)
          4 , -- Id_Users - int
          N'Thiết Bị Iot' , -- Name_Shop - nvarchar(100)
          N'Shop bán các thiết bị iot, bao gồm thiết bị chiếu sáng, cảm biến,...' , -- Description - nvarchar(100)
          NULL  -- Pictures - ntext
        )

INSERT INTO dbo.Category
        ( Name_Category )
VALUES  (N'Chiếu Sáng'  -- Name_Category - nvarchar(1000)
          )
INSERT INTO dbo.Category
        ( Name_Category )
VALUES  (N'Camera'  -- Name_Category - nvarchar(1000)
          )
INSERT INTO dbo.Category
        ( Name_Category )
VALUES  (N'Giải Trí'  -- Name_Category - nvarchar(1000)
          )
INSERT INTO dbo.Category
        ( Name_Category )
VALUES  (N'Điều Hòa'  -- Name_Category - nvarchar(1000)
          )
INSERT INTO dbo.Category
        ( Name_Category )
VALUES  (N'Nhà Bếp'  -- Name_Category - nvarchar(1000)
          )

INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Philips Hue White Ambiance GU10 Spotlight' , -- Name_Product - nvarchar(500)
          890.000 , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Đèn âm trần Philips Hue Centura Recessed Spotlight WACA' , -- Name_Product - nvarchar(500)
          1.875000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Đèn ốp trần Philips Hue White Ambiance Being Ceiling Flushmount' , -- Name_Product - nvarchar(500)
          5700000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Đèn bàn thông minh Philips Hue Go Portable Color Ambiance' , -- Name_Product - nvarchar(500)
          2500000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Đèn thông minh Philips Hue Play Light Bar đồng bộ 16 triệu màu' , -- Name_Product - nvarchar(500)
          4200000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Đèn bàn Philips Hue Bloom White and Color Ambiance Zigbee Version' , -- Name_Product - nvarchar(500)
          1860000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Dây LED 2 mét Philips Hue Lightstrip Base Pack với Bluetooth' , -- Name_Product - nvarchar(500)
          2400000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Bóng đèn dây tóc thông minh Philips Hue Filament E27' , -- Name_Product - nvarchar(500)
          2400000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Sengled Smart LED Soft White A19 Bulb' , -- Name_Product - nvarchar(500)
          2500000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Bóng đèn Sengled Smart LED Soft White A19 là cách đơn giản để bắt đầu với hệ thống chiếu sáng thông minh. Tạo bầu không khí ấm áp trong phòng khách hoặc phòng ngủ của bạn với ánh sáng 2700K tự nhiên. Được chứng nhận hoạt động với Amazon Alexa và Echo Plus, Trợ lý Google, Samsung SmartThings và Wink.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Sengled Smart LED Soft White BR30 Bulb' , -- Name_Product - nvarchar(500)
          3000000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Nhận ánh sáng thông minh có thể lập trình một cách đơn giản và thuận tiện. Sengled Smart LED Soft White BR30 bóng đèn vừa với đèn lon âm tường. Sử dụng các ứng dụng và trung tâm tương thích để Bật / Tắt, làm mờ và chạy đúng lịch trình. Được chứng nhận cho Amazon Alexa, Google Home, SmartThings và Wink.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Bóng đèn thông minh Philips Hue White and Color Ambiance E27' , -- Name_Product - nvarchar(500)
          1500000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Bộ 2 Bóng Đèn Philips Hue White Ambiance Starter Kit E27' , -- Name_Product - nvarchar(500)
          1500000  , -- Price - real
          10 , -- Amount - int
          1 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Tương thích Apple HomeKit, Google Assistant, Amazon Alexa. Công suất 5.5W 220-240V, 200 lumen, nhiệt độ màu 2200-6500 Kelvin. Điều khiển từ xa, hẹn giờ, cài đặt ngữ cảnh, điều khiển bằng giọng nói. Thời gian hoạt động 25,000 giờ. Giao thức kết nối Zigbee và Bluetooth. Để dùng các chức năng thông minh bạn cần có một Philips Hue Bridge. Bảo hành: 1 Năm'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Camera IP 360 độ 1080P TP-Link Tapo C200 Trắng' , -- Name_Product - nvarchar(500)
          800000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Bao quát tốt với góc quay rộng: xoay 360 độ, góc lên xuống 114 độ. Thiết kế nhỏ gọn, hiện đại, dùng tiện lợi cho nhiều không gian, điều khiển dễ dàng qua ứng dụng Tapo. Cung cấp hình ảnh và video full HD 1080p, quan sát khoảng cách trực quan đến 9 m. Giám sát ban đêm với hồng ngoại 850 nm cùng bộ lọc đổi màu tự động khi ánh sáng yếu. Hỗ trợ lưu trữ thẻ MicroSD trên máy (lên đến 128 GB). Giao tiếp thông qua loa ngoài và micrô tích hợp.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Camera IP 1080P TP-Link Tapo C100 Trắng' , -- Name_Product - nvarchar(500)
          1000000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Camera IP cài đặt và quản lý tiện lợi, hiệu quả với ứng dụng Tapo.
			Chất lượng hình ảnh Full HD, quan sát ban đêm với tầm nhìn trực quan đến 9 m.
			Thiết kế nhỏ gọn, hiện đại, chân đế xoay linh hoạt, thích hợp cho nhiều không gian.
			Hỗ trợ lưu trữ thẻ MicroSD trên máy (lên đến 128 GB).
			Giao tiếp thông qua loa ngoài và micrô tích hợp.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Camera IP 1080P Xiaomi Mi Home Magnetic Mount QDJ4065GL Trắng' , -- Name_Product - nvarchar(500)
          1000000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Chuẩn hình ảnh và video Full HD, góc kính rộng 170 độ.
			Thiết kế nhỏ gọn, hiện đại, tinh tế, dùng tốt cho cả trong nhà và ngoài trời.
			Hỗ trợ đàm thoại 2 chiều ổn định, mượt mà như trên điện thoại.
			Chống bụi, kháng nước chuẩn IP65 an toàn trong mọi điều kiện thời tiết.
			Hỗ trợ lưu trữ thẻ MicroSD trên máy (lên đến 32GB).
			Hệ thống đèn hồng ngoại cho khoảng cách quan sát rộng.
			Lưu ý: Sản phẩm cần mua thêm adapter sạc (củ sạc) và thẻ nhớ để sử dụng.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Camera IP 1080P Ezviz CS-C1HC (D0-1D2WFR) Trắng' , -- Name_Product - nvarchar(500)
          1500000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Hình ảnh sắc nét full HD - 1080p.
			Góc nhìn rộng tới 130°.
			Hỗ trợ thẻ MicroSD (tối đa 256GB).
			Trang bị tính năng phát hiện chuyển động.
			Hình ảnh ban đêm rõ nét, hỗ trợ hồng ngoại ban đêm tới 12 m.
			Hỗ trợ tính năng thông minh: Đàm thoại hai chiều.
			Thương hiệu Ezviz đã được tin dùng trên 80 quốc gia.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Camera IP 1080P EZVIZ CS-CV246 Trắng' , -- Name_Product - nvarchar(500)
          2500000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Hình ảnh sắc nét full HD - 1080p.
			Khả năng quát sát toàn cảnh 360°.
			Hỗ trợ thẻ MicroSD (tối đa 128GB).
			Tính năng phát hiện và bám theo chuyển động thông minh.
			Hỗ trợ tính năng thông minh: đàm thoại hai chiều, báo động chuyển động.
			Chế độ riêng tư cho phép thiết bị tạm ngừng khi không cần thiết.
			Hỗ trợ đèn hồng ngoại với tầm nhìn 10 m.
			Sử dụng cổng sạc micro USB.
			Có thể kết nối qua Wi-Fi hoặc trực tiếp qua mạng LAN.
			Dễ dàng điều khiển với ứng dụng Ezviz.
			Thương hiệu Ezviz đã được tin dùng trên 80 quốc gia.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Camera IP 1080P Kbvision KN-TGH21PWN Trắng' , -- Name_Product - nvarchar(500)
          3000000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Hình ảnh sắc nét với độ phân giải Full HD - 1080p.
			Quay quét ngang 355 độ tốc độ 100° /s, quay dọc lên xuống -5 độ - 80 độ.
			Hỗ trợ thẻ Micro SD (tối đa 256 GB).
			Cấp nguồn điện qua cổng micro USB.
			Trang bị tính năng phát hiện chuyển động.
			Tiện lợi hơn với khả năng thiết lập chu kỳ hoạt động.
			Hình ảnh ban đêm rõ nét, hỗ trợ hồng ngoại ban đêm tới 15m.
			Hỗ trợ tính năng thông minh: đàm thoại hai chiều, báo động chuyển động.
			Dễ dàng điều khiển với ứng dụng KBONE.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Loa Karaoke LG RN5' , -- Name_Product - nvarchar(500)
          7600000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Thiết kế chắc chắn, sang trọng, phù hợp cho mọi không gian.
			Âmh trầm mạnh mẽ trong diện tích hơn 50 m2 với công nghệ Super Bass Bost và công suất 300 W.
			Hiệu ứng đèn nhấp nháy sinh động với đèn flash trên điện thoại qua tính năng Party Strobe.
			Kết nối 2 loa với nhau, điều khiển đèn của loa dễ dàng cùng chế độ Wireless Party Link và Dance Lighting.
			Chuyển đổi kết nối giữa 2 điện thoại nhờ tính năng kết nối đa điểm.
			Tạo nên những bản phối khác biệt với bàn hiệu chỉnh DJ - DJ Pad.
			Dễ dàng điều khiển bằng điện thoại với ứng dụng XBoom.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Loa Bluetooth Apple Homepod Mini' , -- Name_Product - nvarchar(500)
          6000000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Thiết kế chắc chắn, sang trọng, phù hợp cho mọi không gian.
			Âmh trầm mạnh mẽ trong diện tích hơn 50 m2 với công nghệ Super Bass Bost và công suất 300 W.
			Hiệu ứng đèn nhấp nháy sinh động với đèn flash trên điện thoại qua tính năng Party Strobe.
			Kết nối 2 loa với nhau, điều khiển đèn của loa dễ dàng cùng chế độ Wireless Party Link và Dance Lighting.
			Chuyển đổi kết nối giữa 2 điện thoại nhờ tính năng kết nối đa điểm.
			Tạo nên những bản phối khác biệt với bàn hiệu chỉnh DJ - DJ Pad.
			Dễ dàng điều khiển bằng điện thoại với ứng dụng XBoom.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Sonos Playbase - Sleek Soundbase for TV, Movies, Music, and More - Black' , -- Name_Product - nvarchar(500)
          6000000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Thiết kế chắc chắn, sang trọng, phù hợp cho mọi không gian.
			Âmh trầm mạnh mẽ trong diện tích hơn 50 m2 với công nghệ Super Bass Bost và công suất 300 W.
			Hiệu ứng đèn nhấp nháy sinh động với đèn flash trên điện thoại qua tính năng Party Strobe.
			Kết nối 2 loa với nhau, điều khiển đèn của loa dễ dàng cùng chế độ Wireless Party Link và Dance Lighting.
			Chuyển đổi kết nối giữa 2 điện thoại nhờ tính năng kết nối đa điểm.
			Tạo nên những bản phối khác biệt với bàn hiệu chỉnh DJ - DJ Pad.
			Dễ dàng điều khiển bằng điện thoại với ứng dụng XBoom.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Loa streaming qua WiFi SONOS Play 1 - Trắng' , -- Name_Product - nvarchar(500)
          6800000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Thiết kế chắc chắn, sang trọng, phù hợp cho mọi không gian.
			Âmh trầm mạnh mẽ trong diện tích hơn 50 m2 với công nghệ Super Bass Bost và công suất 300 W.
			Hiệu ứng đèn nhấp nháy sinh động với đèn flash trên điện thoại qua tính năng Party Strobe.
			Kết nối 2 loa với nhau, điều khiển đèn của loa dễ dàng cùng chế độ Wireless Party Link và Dance Lighting.
			Chuyển đổi kết nối giữa 2 điện thoại nhờ tính năng kết nối đa điểm.
			Tạo nên những bản phối khác biệt với bàn hiệu chỉnh DJ - DJ Pad.
			Dễ dàng điều khiển bằng điện thoại với ứng dụng XBoom.'  -- Description - nvarchar(1000)
        )
INSERT INTO dbo.Product
        ( Name_Product ,
          Price ,
          Amount ,
          Id_Category ,
          Id_Shop ,
          Pictures ,
          Description
        )
VALUES  ( N'Loa streaming qua WiFi SONOS Play 1 - Đen' , -- Name_Product - nvarchar(500)
          6800000 , -- Price - real
          10 , -- Amount - int
          2 , -- Id_Category - int
          1 , -- Id_Shop - int
          NULL , -- Pictures - ntext
          N'Thiết kế chắc chắn, sang trọng, phù hợp cho mọi không gian.
			Âmh trầm mạnh mẽ trong diện tích hơn 50 m2 với công nghệ Super Bass Bost và công suất 300 W.
			Hiệu ứng đèn nhấp nháy sinh động với đèn flash trên điện thoại qua tính năng Party Strobe.
			Kết nối 2 loa với nhau, điều khiển đèn của loa dễ dàng cùng chế độ Wireless Party Link và Dance Lighting.
			Chuyển đổi kết nối giữa 2 điện thoại nhờ tính năng kết nối đa điểm.
			Tạo nên những bản phối khác biệt với bàn hiệu chỉnh DJ - DJ Pad.
			Dễ dàng điều khiển bằng điện thoại với ứng dụng XBoom.'  -- Description - nvarchar(1000)
        )
