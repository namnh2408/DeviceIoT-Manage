CREATE DATABASE IOT_MANAGEMENT
GO
USE IOT_MANAGEMENT
GO
CREATE TABLE Users
(
	Id_Users INT IDENTITY(1,1) NOT NULL,
	Username NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	Password NVARCHAR(300) NOT NULL,
	FisrtName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NULL,
	Address NVARCHAR(100) NULL,
	Gender NVARCHAR(5) NULL,
	Phone NVARCHAR(15) NULL,
	Birthday DATE NULL ,
	RoleID INT NULL,
	Avatar NVARCHAR(100) NULL,
	Create_User DATE NULL,--ngày tạo user
	Block BIT DEFAULT 0, --0: False (không khóa) 1: true (khóa)
	Status BIT DEFAULT 0, --1. online , 0. offline
	UNIQUE (Username, Email),
	PRIMARY KEY (Id_Users)
)

CREATE TABLE Role
(
	RoleID INT IDENTITY(1,1) NOT NULL,
	RoleName NVARCHAR(30) NULL,
	PRIMARY KEY (RoleID)
)


CREATE TABLE Project
(
	Id_Project VARCHAR(20) PRIMARY KEY,
	Id_Users INT REFERENCES dbo.Users(Id_Users),
	Name_Project VARCHAR(255) NULL,
	Category_Number INT NULL, --số lượng các category có trong 1 project
	Create_Project DATE NULL, --ngày tạo project
	Image_Project NTEXT NULL
)

ALTER TABLE dbo.Users ADD CONSTRAINT Users_Role FOREIGN KEY (RoleID) REFERENCES dbo.Role(RoleID)
GO

CREATE TABLE Work_On
(
	Id_User INT REFERENCES dbo.Users (Id_Users),
	Id_Project VARCHAR(20) REFERENCES dbo.Project(Id_Project),
	Status BIT NULL, -- 1. hoàn thành 0. chưa hoàn thành
	PRIMARY KEY (Id_User,Id_Project)
)

CREATE TABLE Categories
(
	Id_Category VARCHAR(20) PRIMARY KEY,
	Name_Category NVARCHAR(255) NULL,	
	Create_Category DATE NULL, -- ngày tạo category vào trong project, có thể trùng với ngày tạo project
	Num_Product INT NULL, -- số lượng product có trong category
	Id_Project VARCHAR(20) REFERENCES dbo.Project(Id_Project),
	Image_Category NTEXT NULL
)

CREATE TABLE Project_Categories
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Id_Project VARCHAR(20) REFERENCES dbo.Project(Id_Project),
	Id_Categories VARCHAR(20) REFERENCES dbo.Categories(Id_Category)
)

CREATE TABLE Product
(
	Id_Product VARCHAR(20) PRIMARY KEY,
	Name_Product NVARCHAR(255) NULL,
	Create_Product DATE NULL, -- ngày tạo product vào trong category, có thể trùng hoặc không trùng với ngày tạo category
	Image_Product NTEXT NULL,
	Id_Category VARCHAR(20) REFERENCES dbo.Categories(Id_Category)
) 
GO 

CREATE TABLE Category_Product
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Id_Category VARCHAR(20) REFERENCES dbo.Categories(Id_Category),
	Id_Product VARCHAR(20) REFERENCES dbo.Product(Id_Product),
	Status BIT NULL --1. hoạt động 0. không hoạt động
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

		