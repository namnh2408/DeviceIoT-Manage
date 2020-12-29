CREATE DATABASE QLThietBiIoT
GO

USE QLThietBiIoT
GO

--phân quyền cho từng user 
-- user với quyền là quan hệ 1-nhiều
CREATE TABLE Quyen
(
	quyen_id NVARCHAR(50) PRIMARY KEY,
	tenquyen NVARCHAR(50) --0 x 1 w 2 r 3 rx 4 rwx 5 6 7rwx
)

--loại người dùng
CREATE TABLE Usertype
(
	usertype_id NVARCHAR(50),
	usertype_name NVARCHAR(100),
	PRIMARY KEY(usertype_id)
)

CREATE TABLE Usertype_quyen
(
	usertype_id NVARCHAR(50) REFERENCES dbo.Usertype(usertype_id),
	quyen_id NVARCHAR(50) REFERENCES dbo.Quyen(quyen_id),
	ghichu NVARCHAR(MAX),
	PRIMARY KEY (usertype_id,quyen_id)
)


--CREATE TABLE Accounts
--(
--	id INT IDENTITY PRIMARY KEY,
--	Username VARCHAR(50),
--	Email  VARCHAR(50),
--	Password VARCHAR(300)
--)

--ALTER TABLE dbo.Accounts ADD UNIQUE(Email)
--ALTER TABLE dbo.Accounts ADD UNIQUE(Username)

CREATE TABLE Users
(
	user_id INT IDENTITY,
	firstname NVARCHAR(50),
	lastname NVARCHAR(50),
	username VARCHAR(50) UNIQUE,
	email VARCHAR(100) UNIQUE,
	password NVARCHAR(300),	
	usertype NVARCHAR(50) REFERENCES dbo.Usertype(usertype_id),
	avatar NVARCHAR(MAX),
	block BIT DEFAULT 0, --0: false (không khóa) 1: true (khóa)
	registerdate DATETIME, --ngày đăng kí thành viên
	GioiTinh NVARCHAR(5),
	NgaySinh DATE,
	DienThoai INT,
	DiaChi NVARCHAR(100),	
	TrangThai BIT DEFAULT 0,-- 1. online , 0. offline
	id_Project VARCHAR(20),
	PRIMARY KEY(user_id)
)

CREATE TABLE Projects
(
	id_Project VARCHAR(20) PRIMARY KEY,
	Name_Projects NVARCHAR(255),
	Category_number INT,	-- số lượng các category có trong 1 project
	NgayTaoProject DATE -- mới thêm
)

CREATE TABLE Image_Projet
(
	id_image_project VARCHAR(20) PRIMARY KEY,
	name NVARCHAR(255),
	url NTEXT,
	id_project VARCHAR(20) REFERENCES dbo.Projects(id_Project)
)

ALTER TABLE dbo.Users ADD FOREIGN KEY (id_Project) REFERENCES dbo.Projects(id_Project)

CREATE TABLE Work_On
(
	id_user INT  REFERENCES dbo.Users(user_id),
	id_Project VARCHAR(20) REFERENCES dbo.Projects(id_Project),
	TrangThai BIT -- 1.  hoan thanh 2. chưa hoan thanh
	PRIMARY KEY(id_user, id_Project)
)

CREATE TABLE Categories
(
	id_Category VARCHAR(20) PRIMARY KEY,
	Name_Category NVARCHAR(255),
	Num_Product INT,-- số lượng product của một category
	NgayTaoCategory DATE, --mới thêm -- ngày nhập category vào trong project có thể trùng với ngày tạo project
	id_Project VARCHAR(20) REFERENCES dbo.Projects(id_Project)
)

CREATE TABLE Image_Categories
(
	id_image_categories INT IDENTITY PRIMARY KEY,
	name NVARCHAR(255),
	url NTEXT,
	id_category VARCHAR(20) REFERENCES dbo.Categories(id_Category)
)

CREATE TABLE Product
(
	id_Product VARCHAR(20) PRIMARY KEY,
	Name_Product NVARCHAR(255),
	Status BIT ,-- 1. hoat dong  0. khong hoat dong
	NgayTaoProduct DATE, --mới thêm -- ngày nhập các product vào trong category, có thể trùng hoặc không trung với ngày tạo category
	Image_Prodcut NTEXT,
	id_category VARCHAR(20) REFERENCES dbo.Categories(id_Category),
)
GO

CREATE TABLE Image_Product
(
	id_image_product INT IDENTITY PRIMARY KEY,
	name NVARCHAR(255),
	url NTEXT,
	id_product VARCHAR(20) REFERENCES dbo.Product(id_Product)
)


SELECT * FROM dbo.Users
GO 

CREATE PROCEDURE [dbo].[Sp_Users_Login]
@UserName VARCHAR(50),
@PassWord VARCHAR(300)
AS
BEGIN
	DECLARE @count INT
	DECLARE @res BIT
    SELECT @count=COUNT(*) FROM dbo.Users WHERE username = @UserName AND password = @PassWord
	IF @count > 0
		SET @res = 1
	ELSE
		SET @res = 0

	RETURN @res
END
GO

EXEC dbo.[Sp_Users_Login] @UserName = 'an', -- varchar(50)
    @PassWord = '123' -- varchar(300)

	SELECT * FROM dbo.Users
	go

INSERT INTO dbo.Projects VALUES('Pro1' , N'Phong Ngu', 2)
INSERT INTO dbo.Projects VALUES('Pro2' , N'Phong Khach', 1)
INSERT INTO dbo.Projects VALUES('Pro3' , N'Nha Bep', 1)

INSERT INTO dbo.Categories VALUES ('PAN1', N'Quat', 1, 'Pro1')
INSERT INTO dbo.Categories VALUES ('Light1', N'Den', 1, 'Pro1')
INSERT INTO dbo.Categories VALUES ('PAN2', N'Quat', 2, 'Pro2')
INSERT INTO dbo.Categories VALUES ('Light3', N'Den', 2, 'Pro3')

INSERT INTO dbo.Product VALUES ( '1', N'Quat', 0, 'PAN1')
INSERT INTO dbo.Product VALUES ( '2', N'Den Chum', 0, 'Light1')
INSERT INTO dbo.Product VALUES ( '3', N'Quat', 0, 'PAN2')
INSERT INTO dbo.Product VALUES ( '4', N'Quat', 0, 'PAN2')
INSERT INTO dbo.Product VALUES ( '5', N'Den tran', 0, 'Light3')
INSERT INTO dbo.Product VALUES ( '6', N'Den ngu', 0, 'Light3')

INSERT INTO dbo.Work_On VALUES ( 'hcmute', 'Pro1', 0)
INSERT INTO dbo.Work_On VALUES ( 'hcmute', 'Pro2', 1)
INSERT INTO dbo.Work_On VALUES ( 'gacon123', 'Pro3', 0)
GO


