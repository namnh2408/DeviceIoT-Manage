CREATE DATABASE BANDONGHO
GO
USE BANDONGHO
GO

---Tạo bảng sản phẩm
CREATE TABLE SANPHAM 
(
	MASP INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	TENSP NVARCHAR(50),
	HINHLON VARCHAR(50), 
	HINHNHO VARCHAR(50),
	MOTA NTEXT,
	MATH INT,
	DANHGIA NTEXT,
	SOLUONG INT,
	MALOAISP CHAR(7),
	DONGIA FLOAT
)

---Tạo bảng loại sản phẩm
CREATE TABLE LOAISANPHAM 
(
	MALOAISP CHAR(7) NOT NULL PRIMARY KEY,
	TENLOAISP NVARCHAR(50),
)


---Tạo bảng thương hiệu
CREATE TABLE THUONGHIEU 
(
	MATH INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	TENTH NVARCHAR(50),
	HINHTH VARCHAR(50)
)

---Tạo bảng đơn đặt hàng
CREATE TABLE DONHANG
(
	MADH INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
	MAKH INT,
	TRANGTHAI NVARCHAR(20),
	DIACHIGIAO NTEXT,
	SDT VARCHAR(12),
	NGAYDAT DATETIME,
	NGAYGIAO DATETIME,
	MOTA NTEXT,
	TONGTIEN FLOAT
)

------Tạo bảng chi tiết đơn đặt hàng
CREATE TABLE CHITIETDONHANG 
(
	MADH INT NOT NULL,
	MASP INT NOT NULL,
	SOLUONG INT,
	PRIMARY KEY(MADH, MASP)
)

---Tạo bảng khuyến mãi
CREATE TABLE KHUYENMAI
(
	MAKM CHAR(7) NOT NULL PRIMARY KEY,
	TENKM NVARCHAR(50),
	NGAYBD DATETIME,
	NGAYKT DATETIME
)

---Tạo bảng chi tiết khuyến mãi
CREATE TABLE CHITIETKM
(
	MAKM CHAR(7) NOT NULL,
	MASP INT NOT NULL,
	PHANTRAMKM INT,
	PRIMARY KEY(MAKM, MASP)
)

---Tạo bảng khách hàng
CREATE TABLE KHACHHANG
(
	MAKH INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	MATK INT,
	TENKH NVARCHAR(50),
	EMAIL VARCHAR(50),
	SDT VARCHAR(12),
	GIOITINH NVARCHAR(3),
	DIACHI NTEXT,
)

---Tạo bảng tài khoản
CREATE TABLE TAIKHOAN
(
	MATK INT NOT NULL PRIMARY KEY IDENTITY(1, 1),
	TENDN VARCHAR(20),
	MATKHAU VARCHAR(32),
	NGAYDANGKY DATETIME,
	TRANGTHAI BIT,
	MALOAITK CHAR(7)
)

---Tạo bảng loại tài khoản
CREATE TABLE LOAITK
(
	MALOAITK CHAR(7) NOT NULL PRIMARY KEY,
	TENLOAITK NVARCHAR(20)
)

---Tạo bảng bình luận
--CREATE TABLE BINHLUAN
--(
--	MABL CHAR(7) NOT NULL PRIMARY KEY,
--	MATK CHAR(7),
--	MASP CHAR(7),
--	NOIDUNG NTEXT,
--	NGAYBINHLUAN DATETIME 
--)

-----Tạo bảng đánh giá
--CREATE TABLE DANHGIA
--(
--	MADG CHAR(7) NOT NULL PRIMARY KEY,
--	MASP CHAR(7),
--	MATK CHAR(7),
--	NOIDUNG NTEXT,
--	SOSAO VARCHAR(1) 
--)



---Tạo khóa ngoại cho bảng  chi tiết sản phẩm
--ALTER TABLE CHITIETSANPHAM ADD CONSTRAINT FK_CTSP_LSP FOREIGN KEY(MALOAISP) REFERENCES LOAISANPHAM(MALOAISP)
--ALTER TABLE CHITIETSANPHAM ADD CONSTRAINT FK_CTSP_MAU FOREIGN KEY(MAMAU) REFERENCES MAUSAC(MAMAU)
--ALTER TABLE CHITIETSANPHAM ADD CONSTRAINT FK_CTSP_SIZE FOREIGN KEY(MASIZE) REFERENCES SIZE(MASIZE)
--ALTER TABLE CHITIETSANPHAM ADD CONSTRAINT FK_CTSP_SP FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP)


---Tạo khóa ngoại cho bảng sản phẩm
ALTER TABLE SANPHAM ADD CONSTRAINT FK_SP_TH FOREIGN KEY(MATH) REFERENCES THUONGHIEU(MATH)
ALTER TABLE SANPHAM ADD CONSTRAINT FK_SP_LSP FOREIGN KEY(MALOAISP) REFERENCES LOAISANPHAM(MALOAISP)

---Tạo khóa ngoại cho bảng đơn hàng
ALTER TABLE DONHANG ADD CONSTRAINT FK_DH_KH FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH)

---Tạo khóa ngoại cho bảng chi tiết đơn hàng
ALTER TABLE CHITIETDONHANG ADD CONSTRAINT FK_CTDH_DH FOREIGN KEY(MADH) REFERENCES DONHANG(MADH)
ALTER TABLE CHITIETDONHANG ADD CONSTRAINT FK_CTDH_SP FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP)

---Tạo khóa ngoại cho bảng chi tiết khuyến mãi
ALTER TABLE CHITIETKM ADD CONSTRAINT FK_CTKM_KM FOREIGN KEY(MAKM) REFERENCES KHUYENMAI(MAKM)
ALTER TABLE CHITIETKM ADD CONSTRAINT FK_CTKM_SP FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP)

---Tạo khóa ngoại cho bảng khách hàng
ALTER TABLE KHACHHANG ADD CONSTRAINT FK_KH_TK FOREIGN KEY(MATK) REFERENCES TAIKHOAN(MATK)

---Tạo khóa ngoại cho bảng tài khoản
ALTER TABLE TAIKHOAN ADD CONSTRAINT FK_TK_LTK FOREIGN KEY(MALOAITK) REFERENCES LOAITK(MALOAITK)

---Tạo khóa ngoại cho bảng bình luận
--ALTER TABLE BINHLUAN ADD CONSTRAINT FK_BL_TK FOREIGN KEY(MATK) REFERENCES TAIKHOAN(MATK)
--ALTER TABLE BINHLUAN ADD CONSTRAINT FK_BL_SP FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP)

-----Tạo khóa ngoại cho bảng đánh giá
--ALTER TABLE DANHGIA ADD CONSTRAINT FK_DG_SP FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP)
--ALTER TABLE DANHGIA ADD CONSTRAINT FK_DG_TK FOREIGN KEY(MATK) REFERENCES TAIKHOAN(MATK)

INSERT INTO LOAITK VALUES ('LK00001', N'Admin')
INSERT INTO LOAITK VALUES ('LK00002', N'User')

INSERT INTO TAIKHOAN VALUES ('user', 'd95c2712448b912279457601ae231a42', '2018-05-16 12:54:33.240', 1, 'LK00002')
INSERT INTO TAIKHOAN VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', '2018-05-16 12:54:33.240', 1, 'LK00001')


INSERT INTO THUONGHIEU VALUES (N'Tissot', N'TH00001.jpg')
INSERT INTO THUONGHIEU VALUES (N'Frederique Constant', N'TH00002.jpg')
INSERT INTO THUONGHIEU VALUES (N'Calvin Klein', N'TH00003.jpg')

INSERT INTO LOAISANPHAM VALUES ('LP00001', N'Đồng hồ nam')
INSERT INTO LOAISANPHAM VALUES ('LP00002', N'Đồng hồ nữ')

INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T106.417.16.031.00', N'SP00001.jpg', N'SP00001', N'Đồng hồ nam, Dây da, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire, Bảo hành toàn cầu 2 năm', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 3, 'LP00001', 11930000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T085.410.22.013.00', N'SP00002.jpg', N'SP00002', N'Đồng hồ nam, Dây da, Thép không gỉ 316L/Mạ PVD, Kính sapphire, Bảo hành toàn cầu 2 năm, ', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 4, 'LP00001', 10980000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T063.617.36.037.00', N'SP00003.jpg', N'SP00003', N'Đồng hồ nam, Dây da, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire, Bảo hành toàn cầu 2 năm', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 6, 'LP00001', 14060000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Frederique Constant FC-282AS5B4', N'SP00004.jpg', N'SP00004', N'Đồng hồ nam, Dây da, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire, Bảo hành toàn cầu 2 năm', 2, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00001', 27040000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T006.408.22.037.00', N'SP00005.jpg', N'SP00005', N'Thiết kế truyền thống và chuẩn mực của nghệ thuật chế tác đồng hồ, Cỗ máy ETA 2824 được modified đem đến trải nghiệm cơ khí tuyệt vời, Dây da thanh lịch kết hợp cùng lớp vỏ thép trắng xám tạo nên tổng thể hài hòa tuyệt đối', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 4, 'LP00001', 36020000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T063.907.36.068.00', N'SP00006.jpg', N'SP00006', N'Đồng hồ nam, Dây da, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire, Bảo hành toàn cầu 2 năm', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 7, 'LP00001', 21940000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ CK (Calvin Klein) K6L2M116', N'SP00007.jpg', N'SP00007', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính cứng, Bảo hành toàn cầu 2 năm', 3, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 1, 'LP00002', 6820000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ CK (Calvin Klein) K5U2M141', N'SP00008.jpg', N'SP00008', N'Đồng hồ nữ, Dây da, Vỏ Thép không gỉ 316L/Mạ PVD, Kính cứng, Bảo hành toàn cầu 2 năm', 3, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 3, 'LP00002', 7650000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T086.407.22.051.00', N'SP00009.jpg', N'SP00009', N'Đồng hồ nam, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Sapphire chống lóa', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00001', 27900000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Frederique Constant FC-200V5S35', N'SP00010.jpg', N'SP00010', N'Đồng hồ nam, Dây da cá sấu, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 2, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00001', 14630000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T060.407.22.051.00', N'SP00011.jpg', N'SP00011', N'Đồng hồ nam, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 3, 'LP00001', 23130000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T101.452.11.031.00', N'SP00012.jpg', N'SP00012', N'Đồng hồ nam, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 3, 'LP00001', 10260000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ CK (Calvin Klein) K0K21107', N'SP00013.jpg', N'SP00013', N'Đồng hồ nam, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính cứng', 3, N'Chỉ có Xwatch Luxury mới giúp được bạn: - Bảo hành 5 năm cả lỗi người dùng theo tiêu chuẩn Thụy Sĩ - Đội ngũ kĩ thuật chuyên nghiệp được đào tạo bài bản từ chuyên gia Thụy Sĩ - Đổi trả trong 15 ngày - Hậu mãi: thay pin trọn đời, lau dầu miễn phí trong 5 năm', 5, 'LP00001', 7360000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Frederique Constant FC-312G4S4', N'SP00014.jpg', N'SP00014', N'Đồng hồ nam, Dây da cá sấu, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 2, N'Điều mà Linh ấn tượng nhất là chế độ bảo hành 5 năm theo tiêu chuẩn Thuỵ Sĩ cho cả lỗi người dùng. Điều này không phải nơi nào cũng có. Rõ ràng các bạn không chỉ là kinh doanh đơn thuần', 4, 'LP00001', 54300000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Frederique Constant FC-393RM5B4', N'SP00015.jpg', N'SP00015', N'Đồng hồ nam, Dây da cá sấu, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 2, N'“Du thuyền” sang trọng trên cổ tay. Sở hữu ngay tác phẩm độc đáo từ Frederique Constant', 4, 'LP00001', 87050000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Frederique Constant FC-303RMC6B4', N'SP00016.jpg', N'SP00016', N'Đồng hồ nam, Dây da cá sấu, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire, Lịch ngày, 26 chân kính, tần số 28800 alt/h', 2, N'Tại sao bạn nên sở hữu tác phẩm này: Gam trầm trên chiếc đồng hồ vừa cổ điển vừa mới lạ, Thiết kế đơn giản nhưng bộc lộ sự nam tính rõ rệt, Cỗ máy automatic Thụy Sĩ đỉnh cao', 1, 'LP00001', 46090000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Frederique Constant FC-330MC4P5', N'SP00017.jpg', N'SP00017', N'Đồng hồ nam, Dây da cá sấu, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 2, N'“Du thuyền” sang trọng trên cổ tay. Sở hữu ngay tác phẩm độc đáo từ Frederique Constant', 2, 'LP00001', 44240000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ CK (Calvin Klein) K5U2S146', N'SP00018.jpg', N'SP00018', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính cứng', 3, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 1, 'LP00002', 9720000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ CK (Calvin Klein) K6L2SB16', N'SP00019.jpg', N'SP00019', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính cứng', 3, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00002', 7790000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T035.207.36.061.00', N'SP00020.jpg', N'SP00020', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00002', 22410000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T109.210.33.031.00', N'SP00021.jpg', N'SP00021', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 1, 'LP00002', 6750000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T103.310.36.111.00', N'SP00022.jpg', N'SP00022', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 3, 'LP00002', 11680000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T101.210.22.031.00', N'SP00023.jpg', N'SP00023', N'Đồng hồ nữ, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00002', 10730000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T094.210.26.111.01', N'SP00024.jpg', N'SP00024', N'Đồng hồ nữ, Dây da, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00002', 9790000)
INSERT INTO SANPHAM VALUES (N'Đồng hồ Tissot T058.009.33.031.01', N'SP00025.jpg', N'SP00025', N'Đồng hồ nữ, Dây da, Thép không gỉ 316L/Mạ PVD, Vỏ Thép không gỉ 316L/Mạ PVD, Kính sapphire', 1, N'XWatch Luxury là địa chỉ đầu tiên tại Việt Nam thực hiện chiến dịch Tẩy chay Đồng hồ Fake - Bảo vệ lợi ích người tiêu dùng (xem chi tiết tại https://thamdinhdongho.vn/) . XWatch Luxury được ủy quyền trực tiếp từ các thương hiệu danh tiếng như Tissot, Frederique Constant, Calvin Klein, Ogival. 100% nhập khẩu nguyên chiếc, đầy đủ phụ kiện đi kèm (sổ, hộp, thẻ bảo hành toàn cầu) và giấy chứng nhận hàng chính hãng.', 2, 'LP00002', 11210000)

