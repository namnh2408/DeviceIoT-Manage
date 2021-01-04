CREATE DATABASE IOT_MANAGEMENT
GO
USE IOT_MANAGEMENT
GO

--bảng User dùng để lưu thông tin người dùng
CREATE TABLE Users
(
	Id_Users INT IDENTITY(1,1),
	Username NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	Password NVARCHAR(300) NOT NULL,
	Address NVARCHAR(100)NOT NULL,
	Gender NVARCHAR(5) NOT NULL,
	Phone NVARCHAR(15) NOT NULL,
	Birthday DATE NOT NULL ,
	RoleID INT NOT NULL,
	Avatar NVARCHAR(100),
	Create_User DATE NOT NULL,--ngày tạo user
	UNIQUE (Username, Email),
	PRIMARY KEY (Id_Users)
)


CREATE TABLE Role
(
	RoleID INT IDENTITY(1,1)NOT NULL PRIMARY KEY,
	RoleName NVARCHAR(30) NOT NULL
)

--bảng Address dùng để địa chỉ của người dùng khi mua hàng
CREATE TABLE Address
(
	Id_Address INT IDENTITY(1,1)NOT NULL  PRIMARY KEY,
	Id_Users INT NOT NULL  REFERENCES dbo.Users(Id_Users),
	Name NVARCHAR(100) NOT NULL , -- tên người nhận hàng
	Address NVARCHAR(100)NOT NULL , -- địa chỉ nhận hàng của người dùng
	Phone NVARCHAR(20)NOT NULL ,
	Default_Address INT NOT NULL  -- địa chỉ mặt định của người dùng
)

CREATE TABLE Shop
(
	Id_Shop INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Address NVARCHAR(100) NOT NULL,
	Id_Users INT NOT NULL REFERENCES dbo.Users(Id_Users),
	Name_Shop NVARCHAR(100) NOT NULL,
	Description NVARCHAR(100) NOT NULL,
	Pictures NTEXT
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
	Id_Store INT NOT NULL REFERENCES dbo.Shop(Id_Shop),
	Pictures NTEXT,
	Description NVARCHAR(1000) NOT NULL
)

CREATE TABLE Orders
(
	Id_Order INT IDENTITY(1,1) PRIMARY KEY,
	Id_Users INT NOT NULL REFERENCES dbo.Users(Id_Users),
	Id_Shop INT NOT NULL REFERENCES dbo.Shop(Id_Shop),
	Delivery FLOAT NOT NULL,
	Payment NVARCHAR(100) NOT NULL,
	Create_Orders DATETIME NOT NULL, --ngày tạo đơn
	Status INT NOT NULL,
	Description NVARCHAR(1000) NOT NULL,
	Id_Address INT NOT NULL REFERENCES dbo.Address(Id_Address), -- địa chỉ nhận hàng
	Total_Order FLOAT NOT NULL
)

CREATE TABLE Orders_Item
(
	Id_Order INT IDENTITY(1,1) REFERENCES dbo.Orders(Id_Order),
	Id_Product INT NOT NULL REFERENCES dbo.Product(Id_Product),
	Price FLOAT NOT NULL,
	Amount INT NOT NULL,
	Discount FLOAT,
	Total FLOAT NOT NULL,
	Status INT NOT NULL
)

CREATE TABLE Cart
(
	Id_Cart INT IDENTITY(1,1) PRIMARY KEY,
	Id_Users INT NOT NULL REFERENCES dbo.Users(Id_Users)
)

CREATE TABLE Cart_Item
(
	Id_Cart INT NOT NULL REFERENCES dbo.Cart(Id_Cart),
	Amount  INT NOT NULL,
	Id_Product INT NOT NULL REFERENCES dbo.Product(Id_Product),
	PRIMARY KEY (Id_Cart,Id_Product)
)
GO

----------------------------------------------FUNCTION----------------------------------------------
-- Mã hóa mật khẩu dưới dạng MD5
--CONVERT cho phép chuyển đổi một biểu thức nào đó sang một kiểu dữ liệu bất kì
--HASHBYTES trả về hàm băm của dữ liệu đầu vào
--MD5 tạo ra giá trị băm 128 bit (16 bytes), thường được thể hiện ở định dạng văn bản dưới
----dạng số thập lục phân 32 chữ số.
CREATE FUNCTION dbo.MaHoaMD5 (@password NVARCHAR(300))
RETURNS NVARCHAR(300)
AS
BEGIN
	RETURN CONVERT(NVARCHAR(300), HASHBYTES('MD5', @password), 2)
END
GO



----------------------------------------------TRIGGER----------------------------------------------
-- Mã hóa mật khẩu dưới dạng MD5 khi thêm hoặc update User
CREATE TRIGGER dbo.MaHoaDangMD5
ON dbo.Users
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @newpassword NVARCHAR(300), @email NVARCHAR(100), @oldpassword NVARCHAR(300), @mahash NVARCHAR(300)
	SELECT @newpassword = Inserted.Password, @email = Inserted.Email
	FROM Inserted
	SELECT @oldpassword = Deleted.Password
	FROM Deleted
	IF (NOT EXISTS (SELECT * 
					FROM Deleted))
	BEGIN
		SELECT * FROM Inserted
		SET @mahash = dbo.MaHoaMD5(@newpassword)
		--cập nhật lại mật khẩu của user dựa theo email nhập vào
		UPDATE dbo.Users
		SET dbo.Users.Password = @mahash
		WHERE dbo.Users.Email = @email
	END
	ELSE IF (@newpassword != @oldpassword)
	BEGIN
		SET @mahash = dbo.MaHoaMD5(@newpassword)
		UPDATE dbo.Users
		SET dbo.Users.Password = @mahash
		WHERE dbo.Users.Email = @email 
	END
END
GO 



----------------------------------------------STORE PROCEDURE----------------------------------------------
--Procedure lấy ra user theo email và password
CREATE PROCEDURE dbo.StoreProcedure_Login (@email NVARCHAR(100), @password NVARCHAR(300))
AS 
BEGIN
	DECLARE @passwordHash NVARCHAR(300)
	SET @passwordHash = dbo.MaHoaMD5(@password)
	SELECT * 
	FROM dbo.Users
	WHERE dbo.Users.Email = @email
	AND dbo.Users.Password = @passwordHash
END
GO 

--Procedure thêm user khi đăng kí tài khoản
CREATE PROCEDURE dbo.StoreProcedure_AccountResgister @username NVARCHAR(50), @password NVARCHAR(300), @email NVARCHAR(100)
AS
BEGIN
	INSERT INTO dbo.Users
	        ( Username ,
	          Email ,
	          Password
	        )
	VALUES  ( @username,
			  @email,
			  @password	         
	        )
END
GO

--Procedure chỉnh sửa password của bảng User khi user thực hiện thay đổi mật khẩu
CREATE PROCEDURE dbo.StoreProcedure_AccountChangePassword @email NVARCHAR(100), @password NVARCHAR(300)
AS
BEGIN
	UPDATE dbo.Users
	SET dbo.Users.Password = @password
	WHERE dbo.Users.Email = @email
END
GO 

----------------------------------------------VIEW----------------------------------------------
--lấy danh sách thiết bị từ bảng Product
CREATE VIEW dbo.LoadProduct
AS
	SELECT * FROM dbo.Product

GO 
--lấy tất cả thiết bị
CREATE VIEW dbo.View_Products
AS
	SELECT * FROM dbo.Product
GO 

--lấy danh sách dự án từ bảng Project
CREATE VIEW dbo.LoadProject
AS
	SELECT * FROM dbo.Project

GO 
--lấy tất cả dự án
CREATE VIEW dbo.View_Projects
AS
	SELECT * FROM dbo.Project
GO 

--lấy danh sách loại thiết bị từ bảng Categories
CREATE VIEW dbo.LoadCategory
AS
	SELECT * FROM dbo.Categories

GO 
--lấy tất cả loại thiết bị
CREATE VIEW dbo.View_Category
AS
	SELECT * FROM dbo.Categories
GO 
----------------------------------------------INSERT INTO----------------------------------------------
INSERT INTO dbo.Role
        ( RoleName )
VALUES  ( N'Admin'  -- RoleName - nvarchar(30)
          )
INSERT INTO dbo.Users
        ( Username ,
          Email ,
          Password ,
          FisrtName ,
          LastName ,
          Address ,
          Gender ,
          Phone ,
          Birthday ,
          RoleID ,
          Avatar ,
          Create_User ,
          Block ,
          Status
        )
VALUES  ( N'Admin1' , -- Username - nvarchar(50)
          N'admin123@gmail.com' , -- Email - nvarchar(100)
          N'123' , -- Password - nvarchar(300)
          N'Admin' , -- FisrtName - nvarchar(50)
          N'một' , -- LastName - nvarchar(50)
          N'hồ chí minh' , -- Address - nvarchar(100)
          N'nam' , -- Gender - nvarchar(5)
          N'09182736478' , -- Phone - nvarchar(15)
          '2000-08-11' , -- Birthday - date
          1 , -- RoleID - int
          NULL , -- Avatar - nvarchar(100)
          GETDATE() , -- Create_User - date
          NULL , -- Block - bit
          NULL  -- Status - bit
        )

		