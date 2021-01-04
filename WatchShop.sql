﻿---------------------------------- /// TẠO CSDL /// -----------------------------------
create database WatchShop
go
use WatchShop
go
-- Bảng danh mục sản phẩm
create table DanhMuc(
MaDanhMuc int identity(1,1) constraint PK_MaDanhMuc primary key not null,
TenDanhMuc nvarchar(200) not null,
DanhMucImg nvarchar(max) not null
)
go
-- Bảng loại sản phẩm
create table LoaiSP(
MaLoaiSP int identity(1,1) constraint PK_MaLoaiSP primary key not null,
MaDanhMuc int constraint FK_MaDanhMuc foreign key references DanhMuc(MaDanhMuc) not null,
TenLoaiSP nvarchar(200) not null,
)
go
-- Bảng Thương Hiệu
create table ThuongHieu(
MaThuongHieu int identity(1,1) constraint PK_MaThuongHieu primary key not null,
TenTH nvarchar(200) not null,
Photo nvarchar(max) not null,
Email nvarchar(max),
DiaChi nvarchar(max),
DienTHoai nvarchar(max),
)
go
-- Bảng sản phẩm
create table SanPham(
MaSP int identity(1000,1) constraint PK_MaSP primary key not null,
MaLoaiSP int constraint FK_MaLoaiSP foreign key references LoaiSP(MaLoaiSP) not null,
MaThuongHieu int constraint FK_MaThuongHieu foreign key references ThuongHieu(MaThuongHieu) not null,
TenSP nvarchar(500) not null,
ThongSoKyTHuat nvarchar(max),
Gia money not null,
Discount int not null,
SoLuongSP int constraint kiemtrasoluongsanpham check(SoLuongSP>=0),
HinhAnh nvarchar(max),
NgayThem datetime,
TinhTrang bit
)
go

-- Bảng Khách hàng
create table KhachHang(
DienThoai varchar(10) constraint PK_DienThoai primary key,
HoTenKH nvarchar(200) not null,
EmailKH nvarchar(200) unique not null,
DiaChiKH nvarchar(500) not null
)
go

-- Bảng Hóa đơn
create table HoaDon(
MaHD varchar(20) constraint PK_MaHD primary key not null,
DienThoai varchar(10) constraint FK_DienThoai foreign key references KhachHang(DienThoai) not null,
NgayTao datetime,
NgayGiao datetime,
XacNhan bit,
HoanTat bit,
GhiChu nvarchar(500),
Total money not null
)
go
-- Bảng Chi tiết hóa đơn
create table ChiTietHD(
MaHD varchar(20)  foreign key references HoaDon(MaHD) not null,
MaSP int foreign key references SanPham(MaSP) not null,
TenSP nvarchar(500) not null,
DonGia money not null,
SoLuong int not null,
TongCong money not null,
constraint PK_SanPham_HoaDon primary key(MaHD,MaSP)
)
go
-- Bảng Admin
create table QuanTri(
TaiKhoan nvarchar(100) primary key,
MatKhau varchar(200),
)
go

----------------------------------/// THỦ TỤC ///-----------------------------------
--------------- ===THAO TÁC QUẢN TRỊ====----------------
-------------- [Bảng DanhMuc] -------------
-- Lấy danh mục view
create view LayDanhMucView
as
select * from DanhMuc
go
-- Lấy danh mục
create proc LayDanhMuc
as
begin
SET NOCOUNT ON;
select * from LayDanhMucView
end
go
-- Thêm danh mục
create proc ThemDanhMuc
@TenDanhMuc nvarchar(200),
@DanhMucImg nvarchar(max)
as
begin
SET NOCOUNT ON;
insert into DanhMuc
values(@TenDanhMuc,@DanhMucImg)
end
go
-- Sửa danh mục
create proc SuaDanhMuc
@MaDanhMuc int,
@TenDanhMuc nvarchar(200),
@DanhMucImg nvarchar(max)
as
begin
SET NOCOUNT ON;
update DanhMuc
set
	TenDanhMuc=@TenDanhMuc,
	DanhMucImg=@DanhMucImg
where MaDanhMuc=@MaDanhMuc
end
go
-- Xóa danh mục
create proc XoaDanhMuc
@MaDanhMuc int
as
begin
SET NOCOUNT ON;
delete from DanhMuc
where MaDanhMuc=@MaDanhMuc
end
go
-------------- [Bảng LoaiSP] -------------
-- Lấy loại sản phẩm view
create view LayLoaiSPView
as
select * from LoaiSP
go
-- Lấy loại sản phẩm
create proc LayLoaiSP
as
begin
SET NOCOUNT ON;
select * from LayLoaiSPView
end
go
-- Thêm loại sản phẩm
create proc ThemLoaiSanPham
@MaDanhMuc int,
@TenLoaiSP nvarchar(200)
as
begin
SET NOCOUNT ON;
insert into LoaiSP
values(@MaDanhMuc,@TenLoaiSP)
end
go
-- Sửa loại sản phẩm
create proc SuaLoaiSP
@MaLoaiSP int,
@MaDanhMuc int,
@TenLoaiSP nvarchar(200)
as
begin
SET NOCOUNT ON;
update LoaiSP
set
	MaDanhMuc=@MaDanhMuc,
	TenLoaiSP=@TenLoaiSP
where MaLoaiSP=@MaLoaiSP
end
go
-- Xóa loại sản phẩm
create proc XoaLoaiSP
@MaLoaiSP int
as
begin
SET NOCOUNT ON;
delete from LoaiSP
where MaLoaiSP=@MaLoaiSP
end
go
-------------- [Bảng SanPham] -------------
-- Lấy sản phẩm view
create view LaySanPhamView
as
select * from SanPham
go

-- Lấy sản phẩm
create proc LaySanPham
as
begin
SET NOCOUNT ON;
select * from LaySanPhamView
end
go
-- Xem chi tiết sản phẩm
create proc XemChiTietSanPham
@MaSP int
as
begin
SET NOCOUNT ON;
select * from SanPham where MaSP=@MaSP
end
go
-- Thêm sản phẩm
create proc ThemSanPham
@MaLoaiSP int,
@MaThuongHieu int,
@TenSP nvarchar(500),
@ThongSoKyTHuat nvarchar(max),
@Gia money,
@Discount int,
@SoLuongSP int,
@HinhAnh nvarchar(max)
as
begin
SET NOCOUNT ON;
insert into SanPham
values(@MaLoaiSP,@MaThuongHieu,@TenSP,@ThongSoKyTHuat,@Gia,@Discount,@SoLuongSP,@HinhAnh,getdate(),1)
end
go
-- Sửa sản phẩm
create proc SuaSanPham
@MaSP int,
@MaLoaiSP int,
@MaThuongHieu int,
@TenSP nvarchar(200),
@ThongSoKyThuat nvarchar(max),
@Gia money,
@Discount int,
@SoLuongSP int,
@HinhAnh nvarchar(max)
as
begin
SET NOCOUNT ON;
update SanPham set
MaLoaiSP=@MaLoaiSP,
MaThuongHieu=@MaThuongHieu,
TenSP=@TenSP,
ThongSoKyTHuat=@ThongSoKyThuat,
Gia=@Gia,
Discount=@Discount,
SoLuongSP=@SoLuongSP,
HinhAnh=@HinhAnh
where
MaSP=@MaSP
end
go
-- Xóa Sản phẩm
create proc XoaSanPham
@MaSP int
as
begin
SET NOCOUNT ON;
delete from SanPham where MaSP=@MaSP
end
go
-- Tìm sản phẩm
create proc TimSanPham
@TenSP nvarchar(500)
as
begin
select * from SanPham where TenSP like '%' +@TenSP+'%'
end
go
-- Lấy sản phẩm hết hàng View
create view LaySanPhamHetHangView
as
select * from SanPham where TinhTrang=0
go
-- Lấy sẩn phẩm hết hàng
create proc LaySanPhamHetHang
as
begin
SET NOCOUNT ON;
select * from LaySanPhamHetHangView
end
go
-------------- [Bảng ThuongHieu] -------------
-- Lấy thương hiệu view
create view LayThuongHieuView
as
select * from ThuongHieu
go
-- Lấy thương hiệu
create proc LayThuongHieu
as
begin
SET NOCOUNT ON;
select * from LayThuongHieuView
end
go
-- Thêm thương hiệu
create proc ThemThuongHieu
@TenTH nvarchar(200),
@Photo nvarchar(max) ,
@Email nvarchar(max),
@DiaChi nvarchar(max),
@DienTHoai nvarchar(max)
as
begin
SET NOCOUNT ON;
insert into ThuongHieu
values(@TenTH,@Photo,@Email,@DiaChi,@DienTHoai)
end
go
-- Sửa thương hiệu
create proc SuaThuongHieu
@MaThuongHieu int,
@TenTH nvarchar(200),
@Photo nvarchar(max) ,
@Email nvarchar(max),
@DiaChi nvarchar(max),
@DienTHoai nvarchar(max)
as
begin
SET NOCOUNT ON;
update ThuongHieu set
TenTH=@TenTH,
Photo=@Photo,
Email=@Email,
DiaChi=@DiaChi,
DienTHoai=@DienTHoai
where MaThuongHieu=@MaThuongHieu
end
go
-- Xóa thương hiệu
create proc XoaThuongHieu
@MaThuongHieu int
as
begin
SET NOCOUNT ON;
delete from ThuongHieu where MaThuongHieu=@MaThuongHieu
end
go
-------------- [Bảng KhachHang] -------------
-- Lấy khách hàng view
create view LayKhachhangView
as
select * from KhachHang
go
-- Lấy khách hàng
create proc LayKhachhang
as
begin
SET NOCOUNT ON;
select * from LayKhachhangView
end
go
-- Tìm khách hàng
create proc TimKhachHang
@Phone varchar(10)
as
begin
select * from KhachHang where DienThoai like '%' + @Phone+ '%'
end
go
-- Thêm khách hàng
create proc ThemKhachHang
@DienThoai varchar(10),
@HoTenKH nvarchar(200),
@EmailKH nvarchar(200),
@DiaChiKH nvarchar(500)
as
begin
SET NOCOUNT ON;
insert into KhachHang
values(@DienThoai,@HoTenKH,@EmailKH,@DiaChiKH)
end
go
-- Update khách hàng nếu đã tồn tại numerPhone
create proc UpdateKhachHang
@DienThoai varchar(10),
@HoTenKH nvarchar(200),
@EmailKH nvarchar(200),
@DiaChiKH nvarchar(500)
as
begin
SET NOCOUNT ON;
update KhachHang set
HoTenKH=@HoTenKH,
EmailKH=@EmailKH,
DiaChiKH=@DiaChiKH
where DienThoai=@DienThoai
end
go
-------------- [Bảng HoaDon] -------------

-- Lấy hóa đơn chưa xác nhận
create proc LayHoaDonChuaXacNhan
as
begin
SET NOCOUNT ON;
select * from HoaDon where XacNhan=0 and HoanTat=0 order by NgayTao asc
end
go
-- Lấy hóa đơn đã xác nhận
create proc LayHoaDonDaXacNhan
as
begin
SET NOCOUNT ON;
select * from HoaDon where XacNhan=1 and HoanTat=0 and NgayGiao is null order by NgayTao asc
end
go
-- Lấy hóa đơn chưa giao
create proc LayHoaDonChuaGiao
as
begin
SET NOCOUNT ON;
select * from HoaDon where XacNhan=1 and HoanTat=0 and NgayGiao is not null order by NgayTao desc
end
go
-- Lấy hóa đơn đã hoàn tất
create proc LayHoaDonHoanTat
as
begin
SET NOCOUNT ON;
select * from HoaDon where XacNhan=1 and HoanTat=1 order by NgayTao desc
end
go
-- Tìm hóa đơn đang giao
create proc TimHoaDonDangGiao
@ngay varchar(10)
as
begin
SET NOCOUNT ON;
select * from HoaDon where XacNhan=1 and HoanTat=0 and convert(varchar(10),NgayGiao,103)=@ngay
end
go
-- Lấy hóa đơn theo tháng năm
create proc LayHoaDonTheoThangNam
@Thang int,
@Nam int
as
begin
SET NOCOUNT ON;
select * from HoaDon where HoanTat=1 and XacNhan=1 and MONTH(NgayTao)=@Thang and YEAR(NgayTao)=@Nam
end
go
-- Lấy hóa đơn theo tháng
create proc LayHoaDonTheoThang
@Thang int
as
begin
SET NOCOUNT ON;
select * from HoaDon where HoanTat=1 and XacNhan=1 and MONTH(NgayTao)=@Thang and YEAR(NgayTao)=YEAR(GETDATE())
end
go
-- Thêm hóa đơn
create proc ThemHoaDon
@MaHD varchar(20),
@DienThoai varchar(10),
@GhiChu nvarchar(500)
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		insert into HoaDon(MaHD,DienThoai,NgayTao,NgayGiao,XacNhan,HoanTat,GhiChu,Total)
		values(@MaHD,@DienThoai,getdate(),null,0,0,@GhiChu,0)
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go
-- Thêm hóa đơn được xác nhận
create proc ThemHoaDonDaXacNhan
@MaHD varchar(20)
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		update HoaDon set
		XacNhan=1
		where MaHD=@MaHD
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go
-- Thêm hóa đơn chưa hoàn tất(đã thanh toán + chưa giao)
create proc ThemHoaDonChuaHoantat
@MaHD varchar(20),
@NgayGiao datetime
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		update HoaDon set
		NgayGiao=@NgayGiao
		where MaHD=@MaHD
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go
-- Thêm hóa đơn đã hoàn tất
create proc ThemHoaDonDaHoanTat
@MaHD varchar(20)
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		update HoaDon set
		HoanTat=1
		where MaHD=@MaHD
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go
-- Huỷ hóa đơn
create proc HuyHoaDon
@MaHD varchar(20)
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		delete from ChiTietHD  where MaHD=@MaHD
		delete from HoaDon  where MaHD=@MaHD
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go
-- Tính tổng tiền cho hóa đơn
create function TinhToTalHD (@MaHD varchar(20))
returns money
as
begin
	declare @Total money=(select sum(TongCong) from ChiTietHD where MaHD=@MaHD)
	return @Total 
end
go
-- Cập nhật giá hóa đơn
create proc CapNhatToTalHoaDon
@MaHD varchar(20)
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		update HoaDon set
		Total=(select dbo.TinhToTalHD(@MaHD))
		where MaHD=@MaHD
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go
-- Tìm hóa đơn chưa xác nhận theo điện thoại khách hàng
create proc TimHoaDonChuaXacNhan
@DienThoai varchar(10)
as
begin
SET NOCOUNT ON;
select * from HoaDon where DienThoai like '%' + @DienThoai+'%' and HoanTat=0 and XacNhan=0
end
go
-- Tìm hóa đơn đã xác nhận theo điện thoại khách hàng
create proc TimHoaDonDaXacNhan
@DienThoai varchar(10)
as
begin
SET NOCOUNT ON;
select * from HoaDon where DienThoai like '%' + @DienThoai+'%' and HoanTat=0 and XacNhan=1
end
go
-- Tìm hóa đơn đã hoàn tất theo điện thoại khách hàng
create proc TimHoaDonDaHoanTat
@DienThoai varchar(10)
as
begin
SET NOCOUNT ON;
select * from HoaDon where DienThoai like '%' + @DienThoai+'%' and HoanTat=1 and XacNhan=1
end
go
-------------- [Bảng ChiTietHD] -------------

-- Thêm chi tiết hóa đơn
create proc ThemChiTietHD
@MaHD varchar(20),
@MaSP int,
@TenSP nvarchar(50),
@DonGia money,
@SoLuong int,
@TongCong money
as
begin
SET NOCOUNT ON;
begin tran
	begin try
		insert into ChiTietHD
		values(@MaHD,@MaSP,@TenSP,@DonGia,@SoLuong,@TongCong)
		commit tran
	end try
begin catch
	rollback tran
end catch
end
go

--------------- ===THAO TÁC NGƯỜI DÙNG====----------------

-- Lấy sản phẩm theo loại sản phẩm
create proc LaySanPhamTheoLoai
@MaLoaiSP int
as
begin
SET NOCOUNT ON;
select * from SanPham S  where S.MaLoaiSP=@MaLoaiSP order by S.MaLoaiSP desc
end
go
-- Lấy sản phẩm theo tên sản phẩm
create proc LaySanPhamTheoTen
@TenSP nvarchar(500)
as
begin
SET NOCOUNT ON;
select * from SanPham where TenSP like '%' +@TenSP+'%' order by TenSP desc
end
go
-- Lấy sản phẩm theo thương hiệu
create proc LaySanPhamTheoThuongHieuController
@MaThuongHieu int
as
begin
SET NOCOUNT ON;
select * from SanPham S  where S.MaThuongHieu=@MaThuongHieu order by S.MaThuongHieu desc
end
go

-- Lấy sản phẩm theo thương hiệu order theo ngày thêm
create proc LaySanPhamTheoThuongHieuOrderNgayThemView
@MaThuongHieu int
as
begin
SET NOCOUNT ON;
select * from SanPham S where S.MaThuongHieu=@MaThuongHieu and S.MaLoaiSP<13 order by S.NgayThem desc
end
go
-- Lấy sản phẩm mới nhất
create proc LaySanPhamMoiNhat
as
begin
SET NOCOUNT ON;
select * from SanPham where MaLoaiSP<13 order by NgayThem desc
end
go

-- Lấy sản phẩm giảm giá cao nhất
create proc LaySanPhamGiamGiaCaoNhatView
as
begin
SET NOCOUNT ON;
select * from SanPham where Discount!=0 order by Discount desc
end
go
-- Lấy sản phẩm theo danh mục
create proc LaySanPhamTheoDanhMuc
@MaDanhMuc int
as
begin
SET NOCOUNT ON;
select * from SanPham S inner join LoaiSP L on S.MaLoaiSP=L.MaLoaiSP inner join DanhMuc D on L.MaDanhMuc=D.MaDanhMuc where D.MaDanhMuc=@MaDanhMuc order by S.NgayThem desc
end
go
----------------------------------/// TRIGGER ///-----------------------------------
-- cập nhật số lượng sản phẩm trong bảng SanPham đặt hàng hoặc cập nhật
create trigger trg_DatHang on ChiTietHD after insert as
begin
	SET NOCOUNT ON;
	update SanPham
	set SoLuongSP=SoLuongSP-(
	select Soluong
	from inserted
	where MaSP=SanPham.MaSP
	)
	from SanPham
	join inserted on SanPham.MaSP=inserted.MaSP
end
go
--  cập nhật số lượng sản phẩm trong bảng SanPham sau khi cập nhật đặt hàng
create trigger trg_HuyDatHang on ChiTietHD for delete as
begin
	SET NOCOUNT ON;
	update SanPham
	set SoLuongSP=SoLuongSP+
	(select SoLuong From deleted where MaSP=SanPham.MaSP)
	from SanPham
	join deleted on SanPham.MaSP=deleted.MaSP
end
go
-- cập nhật số lượng sản phẩm trong bảng SanPham sau khi hủy đặt hàng
create trigger trg_CapNhatDatHang on ChiTietHD after update as
begin
	SET NOCOUNT ON;
	update SanPham set SoLuongSP=SoLuongSP-
	(select SoLuong from inserted where MaSP=SanPham.MaSP)+
	(select SoLuong from deleted where MaSP=SanPham.MaSP)
	from SanPham
	join deleted on SanPham.MaSP=deleted.MaSP
end
go
-- cập nhật tình trạng sản phẩm
create trigger KiemTraSLSanPham on SanPham after update as
begin
 declare @sl int
 set @sl=(select SoLuongSP from inserted)
if(@sl=0)
begin
	update SanPham
	set TinhTrang=0 from inserted where SanPham.MaSP=inserted.MaSP
end
else
begin
update SanPham
set TinhTrang=1 from inserted where SanPham.MaSP=inserted.MaSP
end
end
go
-------------------------------/// FUNCTION ///-----------------------------------
-- Tính tổng danh thu năm
create function TinhDoanhThuNam()
returns decimal
as
begin
	declare @TongDoanhThuNam decimal
	declare @kiemtra int = (select count(MaHD) from HoaDon where HoanTat=1 and XacNhan=1 and YEAR(NgayTao)=YEAR(GETDATE()))
	if(@kiemtra=0)
	begin
		set @TongDoanhThuNam=0
	end
	else
	begin
		set @TongDoanhThuNam =(select sum(Total) from HoaDon where HoanTat=1 and XacNhan=1 and YEAR(NgayTao)=YEAR(GETDATE()))
	end
return @TongDoanhThuNam
end
go
-- Tính số hóa đơn đã được đặt 
create function TinhSoHDTrongNgay()
returns int
as
begin
	declare @TongHDDuocDat int=(select count(MaHD) from HoaDon where XacNhan=0 and HoanTat=0)
	return @TongHDDuocDat
end
go
-- Tính số hóa đơn chưa giao
create function TinhSoHoaDonChuaGiao()
returns int
as
begin
	declare @TongHDChuaGiao int=(select count(MaHD) from HoaDon where HoanTat=0 and XacNhan=1 and NgayGiao is not null)
	return @TongHDChuaGiao
end
go
-- Tính số hóa đơn đã hoàn tất(đã giao) 
create function TinhSoHoaDonDaGiao()
returns int
as
begin
	declare @TongHDDaGiao int=(select count(MaHD) from HoaDon where HoanTat=1 and XacNhan=1)
	return @TongHDDaGiao
end
go
-- Tính số hóa đơn chưa hoàn tất
create function TinhSoHoaDonChuaHoanTat()
returns int
as
begin
	declare @HDChuaHT int=(select count(MaHD) from HoaDon where HoanTat=0 and XacNhan=1 and NgayGiao is null)
	return @HDChuaHT
end
go
-- Tính số sản phẩm hết hàng
create function SoSanPhamHetHang()
returns int
as
begin
	declare @sphethang int=(select count(MaSP) from SanPham where TinhTrang=0 and SoLuongSP=0)
	return @sphethang
end
go
-- Tính số khách hàng mới
create function newCustomer()
returns int
as
begin
	declare @dem int=(select COUNT(DienThoai) from KhachHang)
	return @dem
end
go
-- Tính doanh thu theo tháng / năm
create function TinhDoanhThuTheoThangNam(@Thang int,@Nam int)
returns decimal
as
begin
	declare @doanhthu decimal
	declare @kiemtra int = (select count(MaHD) from HoaDon where HoanTat=1 and XacNhan=1 and MONTH(NgayTao)=@Thang and YEAR(NgayTao)=@Nam)
	if(@kiemtra=0)
	begin
		set @doanhthu=0
	end
	else
	begin
		set @doanhthu=(select sum(Total) from HoaDon where HoanTat=1 and XacNhan=1 and MONTH(NgayTao)=@Thang and YEAR(NgayTao)=@Nam)
	end
return @doanhthu
end
go
----------------------------------/// INSERT Dữ Liệu ///-----------------------------------
-- Thêm dữ liệu bảng quản trị
insert into QuanTri values('Admin','Z8iwc6Uz2M+EpI1l6kLxPQ==')
INSERT INTO dbo.QuanTri
        ( TaiKhoan, MatKhau )
VALUES  ( N'admin1', -- TaiKhoan - nvarchar(100)
          'admin123'  -- MatKhau - varchar(200)
          )
-- Thêm dữ liệu bảng khách hàng
insert into KhachHang values('0385369830',N'Nguyễn Văn Thắng',N'nvt@gmail.com',N'484 Lê Văn Việt')
insert into KhachHang values('0388452147',N'Vũ Trung Kiên',N'Kien@gmail.com',N'Thủ Đức')
insert into KhachHang values('0382013685',N'Trần Văn Hân Minh Đính',N'tvhmd@gmail.com',N'Thủ Đức')
insert into KhachHang values('0123456111',N'Vương Thị Thu Trang',N'vttt@gmail.com',N'Quận 1')
insert into KhachHang values('0123456789',N'Trần Thành Long',N'long@gmail.com',N'Biên Hòa Đồng Nai')
insert into KhachHang values('0785359535',N'Vương Quốc Vinh',N'vinh@gmail.com',N'Biên Hòa')

-- Thêm dữ liệu bảng danh mục
insert into DanhMuc values(N'Đồng hồ nam',N'/Images/Đồng-Hồ-Nam-FNGEEN-DÂY-HỢP-KIM-5.jpg')--1
insert into DanhMuc values(N'Đồng hồ nữ',N'/Images/dong-ho-nu-thoi-trang-hieu-guou-1461-1-1461M-GO-4.jpg')--2
insert into DanhMuc values(N'Phụ kiện',N'/Images/Day-da-be-da-bo-dong-ho-chinh-hang.jpg')--3
-- Thêm dữ liệu bảng loại sản phẩm
insert into LoaiSP values(1,N'Đồng hồ nam Casio')--1
insert into LoaiSP values(1,N'Đồng hồ nam Daniel Wellington')--2
insert into LoaiSP values(1,N'Đồng hồ nam Fossil')--3



insert into LoaiSP values(2,N'Đồng hồ nữ Anne Klein')--4
insert into LoaiSP values(2,N'Đồng hồ nữ Bulova')--5
insert into LoaiSP values(2,N'Đồng hồ nữ Caravelle')--6
insert into LoaiSP values(2,N'Đồng hồ nữ Casio')--7
insert into LoaiSP values(2,N'Đồng hồ nữ Daniel Wellington')--8
insert into LoaiSP values(2,N'Đồng hồ nữ Fossil')--9
insert into LoaiSP values(2,N'Đồng hồ nữ Marc Jacobs')--10
insert into LoaiSP values(2,N'Đồng hồ nữ Micheal Kors')--11
insert into LoaiSP values(2,N'Đồng hồ nữ Skagen')--12


insert into LoaiSP values(3,N'Dây đồng hồ nam')--13
insert into LoaiSP values(3,N'Dây đồng hồ nữ')--14
insert into LoaiSP values(3,N'Vòng tay')--15
insert into LoaiSP values(1,N'Đồng hồ nam Skagen')--16
-- Thêm dữ liệu vào bảng thương hiệu
insert into ThuongHieu values(N'Anne Klein',N'/Images/logo-01-01.jpg',N'AnneKlein@gmail.com',N'Mỹ','0385639830')--1
insert into ThuongHieu values(N'Bulova',N'/Images/bulova-logo-black-01-01.jpg',N'Bulova@gmail.com',N'Mỹ','0385639830')--2
insert into ThuongHieu values(N'Caravelle',N'/Images/Caravelle-New-Yorklogo-01-01.jpg',N'Caravella@gmail.com',N'Mỹ','0385639830')--3
insert into ThuongHieu values(N'Casio',N'/Images/5847eab1cef1014c0b5e4840-01-01.jpg',N'Casio@gmail.com',N'Nhật Bản','0385639830')--4
insert into ThuongHieu values(N'Daniel Wellington',N'/Images/logo-daniel-wellington-01-01.jpg',N'DW@gmail.com',N'Mỹ','0385639830')--5
insert into ThuongHieu values(N'Fossil',N'/Images/thumb_31585_logo_retailer_1x-01-01.jpg',N'Fossil@gmail.com',N'Mỹ','0385639830')--6
insert into ThuongHieu values(N'Marc Jacobs',N'/Images/20161111104807_221_mj_logo_new-01-01.jpg',N'MarcJacob@gmail.com',N'Mỹ','0385639830')--7
insert into ThuongHieu values(N'Micheal Kors',N'/Images/57ea67b554764-01.jpg',N'MichealKors@gmail.com',N'Mỹ','0385639830')--8
insert into ThuongHieu values(N'Skagen',N'/Images/skagen-logo-01-01.jpg',N'Skagen@gmail.com',N'Mỹ','0385639830')--9
-- Thêm dữ liệu bảng sản phẩm
insert into SanPham values(1,4,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',1000000,5,999,N'/Images/Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ.jpg',getdate(),1)
insert into SanPham values(1,4,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Xanh Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',1200000,0,999,N'/Images/Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Xanh Đen.jpg',getdate(),1)
insert into SanPham values(1,4,N'Đồng hồ nam dây cao su Casio W-W218H-1AVDF 44,4×43,2mm - Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',1000000,0,999,N'/Images/Đồng hồ nam dây cao su Casio W-W218H-1AVDF 44,4×43,2mm - Đen.jpg',getdate(),1)
insert into SanPham values(1,4,N'Đồng hồ nam dây Inox Casio AQ-230GA-9DMQ 38mm - Vàng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',2200000,0,999,N'/Images/Đồng hồ nam dây Inox Casio AQ-230GA-9DMQ 38mm - Vàng.jpg',getdate(),1)
insert into SanPham values(1,4,N'Đồng hồ nam dây Inox Casio AQ-230A-7DMQ 38mm - Bạc',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',2200000,10,999,N'/Images/Đồng hồ nam dây Inox Casio AQ-230A-7DMQ 38mm - Bạc.jpg',getdate(),1)


insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Black York 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',3000000,15,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Black York 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Black Reading 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',3200000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Black Reading 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Black Bristol 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',2000000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Black Bristol 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Black St Mawes 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',5000000,20,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Black St Mawes 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Black Sheffield 40mm - Vàng Hong',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',3000000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Black Sheffield 40mm - Vàng Hong.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic St Mawes 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',4000000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic St Mawes 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic York 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic York 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Reading 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',2350000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Reading 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Bristol 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',2200000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Bristol 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(2,5,N'Đồng hồ nam dây da Daniel Wellington Classic Sheffield 40mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Đồng hồ nam dây da Daniel Wellington Classic Sheffield 40mm - Vàng Hồng.jpg',getdate(),1)


insert into SanPham values(3,6,N'Đồng hồ nam dây da Fossil FS5268 44mm - Vàng',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',1500000,5,999,N'/Images/Đồng hồ nam dây da Fossil FS5268 44mm - Vàng.jpg',getdate(),1)
insert into SanPham values(3,6,N'Đồng hồ nam dây kim loại Fossil FS5236 44mm - Bạc',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',2000000,5,999,N'/Images/Đồng hồ nam dây kim loại Fossil FS5236 44mm - Bạc.jpg',getdate(),1)
insert into SanPham values(3,6,N'Đồng hồ nam dây da Fossil FS5237 44mm - Vàng Hồng',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',3000000,0,999,N'/Images/Đồng hồ nam dây da Fossil FS5237 44mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(3,6,N'Đồng hồ nam dây kim loại Fossil FS5238 44mm - Bạc',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',4000000,0,999,N'/Images/Đồng hồ nam dây kim loại Fossil FS5238 44mm - Bạc.jpg',getdate(),1)
insert into SanPham values(3,6,N'Đồng hồ nam dây da Fossil FS5159 45mm - Vàng Hồng',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',5000000,0,999,N'/Images/Đồng hồ nam dây da Fossil FS5159 45mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(3,6,N'Đồng hồ nam dây da Fossil FSBQ2064 45mm - Bạc',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',7000000,10,999,N'/Images/Đồng hồ nam dây da Fossil FSBQ2064 45mm - Bạc.jpg',getdate(),1)
insert into SanPham values(3,6,N'Đồng hồ nam dây da Fossil FSME3041 44mm - Bạc',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',6000000,8,999,N'/Images/Đồng hồ nam dây da Fossil FSME3041 44mm - Bạc.jpg',getdate(),1)


insert into SanPham values(16,9,N'Đồng hồ nam dây da Skagen SKW6217 40mm - Vàng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',500000,10,999,N'/Images/Đồng hồ nam dây da Skagen SKW6217 40mm - Vàng.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây da Skagen SKW6210 40mm - Đen',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',2200000,0,999,N'/Images/Đồng hồ nam dây da Skagen SKW6210 40mm - Đen.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây da Skagen SKW6086 40mm - Bạc',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',6200000,0,999,N'/Images/Đồng hồ nam dây da Skagen SKW6086 40mm - Bạc.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây da Skagen SKW6066 40mm - Vàng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',3500000,0,999,N'/Images/Đồng hồ nam dây da Skagen SKW6066 40mm - Vàng.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây lưới Skagen SKW6053 45mm - Đen',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',100000,0,999,N'/Images/Đồng hồ nam dây lưới Skagen SKW6053 45mm - Đen.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây lưới Skagen SKW6052 45mm - Bạc',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',200000,0,999,N'/Images/Đồng hồ nam dây lưới Skagen SKW6052 45mm - Bạc.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây lưới Skagen SKW6296 40mm - Vàng Hồng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',2800000,0,999,N'/Images/Đồng hồ nam dây lưới Skagen SKW6296 40mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(16,9,N'Đồng hồ nam dây da Skagen SKW6215 40mm - Bạc',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',4200000,5,999,N'/Images/Đồng hồ nam dây da Skagen SKW6215 40mm - Bạc.jpg',getdate(),1)


insert into SanPham values(4,1,N'Combo đồng hồ nữ dây kim loại Anne Klein AK1470GBST 32mm - Vàng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1800000,5,999,N'/Images/Combo đồng hồ nữ dây kim loại Anne Klein AK1470GBST 32mm - Vàng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Combo đồng hồ nữ dây kim loại Anne Klein AK2245RTST 26mm - Vàng Hồng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1500000,0,999,N'/Images/Combo đồng hồ nữ dây kim loại Anne Klein AK2245RTST 26mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Combo đồng hồ nữ dây kim loại Anne Klein AK2716RNST 26mm - Vàng Hồng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1500000,0,999,N'/Images/Combo đồng hồ nữ dây kim loại Anne Klein AK2716RNST 26mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Combo đồng hồ nữ dây kim loại Anne Klein AK3140INST 28mm - Vàng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1500000,0,999,N'/Images/Combo đồng hồ nữ dây kim loại Anne Klein AK3140INST 28mm - Vàng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây da Anne Klein AK1396BMBK 34mm - Vàng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',2500000,0,999,N'/Images/Đồng hồ nữ dây da Anne Klein AK1396BMBK 34mm - Vàng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein 12-2269MPTT 35mm - Vàng, Bạc',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',3000000,5,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein 12-2269MPTT 35mm - Vàng, Bạc.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein 1980BMRG 34mm - Vàng Hồng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',3500000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein 1980BMRG 34mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK1362RGRG 32mm - Vàng Hồng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK1362RGRG 32mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK1980BKGB 28mm - Vàng, Đen',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',21000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK1980BKGB 28mm - Vàng, Đen.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK2158RGRG 30mm - Vàng Hồng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK2158RGRG 30mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK2159SVSV 30mm - Bạc',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK2159SVSV 30mm - Bạc.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK2435SVTT 28mm - Vàng, Bạc',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1200000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK2435SVTT 28mm - Vàng, Bạc.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK2677MPRT 28mm - Vàng Hồng, Bạc',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',1000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK2677MPRT 28mm - Vàng Hồng, Bạc.jpg',getdate(),1)
insert into SanPham values(4,1,N'Đồng hồ nữ dây kim loại Anne Klein AK3070MPRG 28mm - Vàng Hồng',N'+Thương hiệu: Anne Klein; +Xuất xứ: Mỹ',8000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Anne Klein AK3070MPRG 28mm - Vàng Hồng.jpg',getdate(),1)


insert into SanPham values(5,2,N'Đồng hồ nữ dây kim loại Bulova 97P111 27mm - Vàng Hồng',N'+Thương hiệu: Bulova; +Xuất xứ: Mỹ',4000000,5,999,N'/Images/Đồng hồ nữ dây kim loại Bulova 97P111 27mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(5,2,N'Đồng hồ nữ dây kim loại Bulova 98L212 23mm - Vàng Hồng',N'+Thương hiệu: Bulova; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Bulova 98L212 23mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(5,2,N'Đồng hồ nữ dây kim loại Bulova 98L213 23mm - Vàng',N'+Thương hiệu: Bulova; +Xuất xứ: Mỹ',3000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Bulova 98L213 23mm - Vàng.jpg',getdate(),1)


insert into SanPham values(6,3,N'Đồng hồ nữ dây da Caravelle 43I167 36mm - Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',8000000,5,999,N'/Images/Đồng hồ nữ dây da Caravelle 43I167 36mm - Bạc.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây da Caravelle 43N103 30mm - Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',4000000,0,999,N'/Images/Đồng hồ nữ dây da Caravelle 43N103 30mm - Bạc.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 43L165 37mm - Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 43L165 37mm - Bạc.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 43L186 36mm - Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',3000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 43L186 36mm - Bạc.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 43L193 30mm - Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',3000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 43L193 30mm - Bạc.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 43M112 36mm - Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',1000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 43M112 36mm - Bạc.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L170 36mm - Vàng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',5000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L170 36mm - Vàng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L175 30mm - Vàng Hồng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L175 30mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L179 36mm - Vàng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',9000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L179 36mm - Vàng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L214 36mm - Vàng Hồng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',1000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L214 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L215 36mm - Vàng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',7000000,10,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L215 36mm - Vàng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L218 36mm - Vàng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L218 36mm - Vàng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44L233 36mm - Vàng Hồng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',6000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44L233 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 44N109 38mm - Vàng',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',7000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 44N109 38mm - Vàng.jpg',getdate(),1)
insert into SanPham values(6,3,N'Đồng hồ nữ dây kim loại Caravelle 45L157 28mm - Vàng Hồng,Bạc',N'+Thương hiệu: Caravella; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Caravelle 45L157 28mm - Vàng Hồng,Bạc.jpg',getdate(),1)

insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110GA-1A1 46,3×43,4mm - Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',2000000,10,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110GA-1A1 46,3×43,4mm - Đen.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Vải Jean Casio BABY-G BA-110DC-2A2 46,3×43,4mm - Xanh',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',5000000,5,999,N'/Images/Đồng Hồ Nữ Vải Jean Casio BABY-G BA-110DC-2A2 46,3×43,4mm - Xanh.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CR-7A 46,3×43,4mm - Trắng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',4000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CR-7A 46,3×43,4mm - Trắng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CR-4A 46,3×43,4mm - Đỏ Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',1000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CR-4A 46,3×43,4mm - Đỏ Đen.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CR-2A 46,3×43,4mm - Xanh',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',3000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CR-2A 46,3×43,4mm - Xanh.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CP-4A 46,3×43,4mm - Hồng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',6000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CP-4A 46,3×43,4mm - Hồng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CH-7A 46,3×43,4mm - Trắng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',9000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CH-7A 46,3×43,4mm - Trắng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CH-3A 46,3×43,4mm - Xanh',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',2000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CH-3A 46,3×43,4mm - Xanh.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CH-1A 46,3×43,4mm - Đen Tím',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',1000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CH-1A 46,3×43,4mm - Đen Tím.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CF-7A 46,3×43,4mm - Trắng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',7000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CF-7A 46,3×43,4mm - Trắng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CF-1A 46,3×43,4mm - Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',3000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110CF-1A 46,3×43,4mm - Đen.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110BE-7A 46,3×43,4mm - Trắng Xanh',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',3000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110BE-7A 46,3×43,4mm - Trắng Xanh.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110BC-1A 46,3×43,4mm - Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',3000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110BC-1A 46,3×43,4mm - Đen.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110-7A3 46,3×43,4mm - Trắng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',2000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110-7A3 46,3×43,4mm - Trắng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110-7A1 46,3×43,4mm - Trắng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',1000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110-7A1 46,3×43,4mm - Trắng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110-4A1  46,3×43,4mm - Hồng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',5000000,0,999,N'/Images/Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110-4A1  46,3×43,4mm - Hồng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng hồ nữ dây cao su CASIO BABY-G BA-110-4A2 46,3×43,4mm - Hồng Nhạt',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',5000000,0,999,N'/Images/Đồng hồ nữ dây cao su CASIO BABY-G BA-110-4A2 46,3×43,4mm - Hồng Nhạt.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng hồ nữ dây cao su CASIO BABY-G BA-110-1A 46,3×43,4mm - Đen',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',4000000,0,999,N'/Images/Đồng hồ nữ dây cao su CASIO BABY-G BA-110-1A 46,3×43,4mm - Đen.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng hồ nữ dây kim loại Casio B650WC-5ADF 43,1 x 41,2mm - Vàng Hồng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',5000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Casio B650WC-5ADF 43,1 x 41,2mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(7,4,N'Đồng Hồ Nữ dây kim loại Casio LA690WGA-9DF 30,4×26,7mm - Vàng',N'+Thương hiệu: Casio; +Xuất xứ: Nhật Bản',4000000,0,999,N'/Images/Đồng Hồ Nữ dây kim loại Casio LA690WGA-9DF 30,4×26,7mm - Vàng.jpg',getdate(),1)


insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Black York 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',4000000,10,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Black York 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Black Reading 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',5000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Black Reading 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Black Bristol 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',8000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Black Bristol 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Black St Mawes 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',2000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Black St Mawes 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Black Sheffield 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',3000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Black Sheffield 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic St Mawes 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',7000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic St Mawes 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic York 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',7000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic York 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Reading 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',5000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Reading 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Bristol 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',6000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Bristol 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(8,5,N'Đồng hồ nữ dây da Daniel Wellington Classic Sheffield 36mm - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Đồng hồ nữ dây da Daniel Wellington Classic Sheffield 36mm - Vàng Hồng.jpg',getdate(),1)


insert into SanPham values(9,6,N'Đồng hồ nữ dây kim loại Fossil ES3590 38mm - Vàng Hồng',N'+Thương hiệu: Fossil; +Xuất xứ: Mỹ',20000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Fossil ES3590 38mm - Vàng Hồng.jpg',getdate(),1)



insert into SanPham values(10,7,N'Đồng hồ nữ dây da Marc Jacobs  MBM1283 36mm - Vàng Hồng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',6000000,8,999,N'/Images/Đồng hồ nữ dây da Marc Jacobs  MBM1283 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây da Marc Jacobs MJ1599 36mm - Vàng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',4000000,0,999,N'/Images/Đồng hồ nữ dây da Marc Jacobs MJ1599 36mm - Vàng.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây da Marc Jacobs MJ1600 28mm - Vàng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',6000000,0,999,N'/Images/Đồng hồ nữ dây da Marc Jacobs MJ1600 28mm - Vàng.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây da Marc Jacobs MJ-MBM1267 37mm - Vàng Hồng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',4000000,0,999,N'/Images/Đồng hồ nữ dây da Marc Jacobs MJ-MBM1267 37mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây kim loại Marc Jacobs  MBM3245 36mm - Vàng Hồng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Marc Jacobs  MBM3245 36mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây kim loại Marc Jacobs  MBM3248 28mm - Vàng Hồng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',10000000,20,999,N'/Images/Đồng hồ nữ dây kim loại Marc Jacobs  MBM3248 28mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây kim loại Marc Jacobs MJ3572 34mm - Bạc',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',8000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Marc Jacobs MJ3572 34mm - Bạc.jpg',getdate(),1)
insert into SanPham values(10,7,N'Đồng hồ nữ dây kim loại Marc Jacobs MJ3574 34mm - Vàng Hồng',N'+Thương hiệu: Marc Jacobs; +Xuất xứ: Pháp',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Marc Jacobs MJ3574 34mm - Vàng Hồng.jpg',getdate(),1)


insert into SanPham values(11,8,N'Đồng hồ nữ dây kim loại Michael Kors MK3192 39mm - Vàng Hồng',N'+Thương hiệu: Micheal Kors; +Xuất xứ: Mỹ',8000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Michael Kors MK3192 39mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(11,8,N'Đồng hồ nữ dây kim loại Michael Kors MK3640 36.5mm - Vàng Hồng',N'+Thương hiệu: Micheal Kors; +Xuất xứ: Mỹ',2000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Michael Kors MK3640 36.5mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(11,8,N'Đồng hồ nữ dây kim loại Michael Kors MK3643 33mm - Vàng Hồng',N'+Thương hiệu: Micheal Kors; +Xuất xứ: Mỹ',1000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Michael Kors MK3643 33mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(11,8,N'Đồng hồ nữ dây kim loại Michael Kors MK3706 36.5mm - Vàng Hồng',N'+Thương hiệu: Micheal Kors; +Xuất xứ: Mỹ',9000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Michael Kors MK3706 36.5mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(11,8,N'Đồng hồ nữ dây kim loại Michael Kors MK6551 40mm - Vàng Hồng',N'+Thương hiệu: Micheal Kors; +Xuất xứ: Mỹ',9000000,0,999,N'/Images/Đồng hồ nữ dây kim loại Michael Kors MK6551 40mm - Vàng Hồng.jpg',getdate(),1)


insert into SanPham values(12,9,N'Đồng hồ nữ dây da Skagen SKW2390 34mm - Vàng Hồng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',4000000,0,999,N'/Images/Đồng hồ nữ dây da Skagen SKW2390 34mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(12,9,N'Đồng hồ nữ dây da Skagen SKW2354 34mm - Vàng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',2000000,0,999,N'/Images/Đồng hồ nữ dây da Skagen SKW2354 34mm - Vàng.jpg',getdate(),1)
insert into SanPham values(12,9,N'Đồng hồ nữ dây lưới Skagen SKW2391 30mm - Bạc',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',1000000,0,999,N'/Images/Đồng hồ nữ dây lưới Skagen SKW2391 30mm - Bạc.jpg',getdate(),1)
insert into SanPham values(12,9,N'Đồng hồ nữ dây lưới Skagen SKW2151 30mm - Vàng Hồng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',3000000,0,999,N'/Images/Đồng hồ nữ dây lưới Skagen SKW2151 30mm - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(12,9,N'Đồng hồ nữ dây lưới Skagen SKW2385 30mm - Vàng',N'+Thương hiệu: Skagen; +Xuất xứ: Đan Mạch',6000000,0,999,N'/Images/Đồng hồ nữ dây lưới Skagen SKW2385 30mm - Vàng.jpg',getdate(),1)

insert into SanPham values(13,5,N'Dây Nato nam Daniel Wellington Cornwall 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Nato nam Daniel Wellington Cornwall 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Da nam Daniel Wellington Reading 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Da nam Daniel Wellington Reading 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Nato nam Daniel Wellington Oxford 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Nato nam Daniel Wellington Oxford 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Nato nam Daniel Wellington Canterbury 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Nato nam Daniel Wellington Canterbury 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Nato nam Daniel Wellington Cambridge 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Nato nam Daniel Wellington Cambridge 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Nato nam Daniel Wellington Glasgow 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',800000,0,999,N'/Images/Dây Nato nam Daniel Wellington Glasgow 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Da nam Daniel Wellington St Mawes 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',800000,0,999,N'/Images/Dây Da nam Daniel Wellington St Mawes 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Da nam Daniel Wellington Sheffield 40mm  - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',800000,0,999,N'/Images/Dây Da nam Daniel Wellington Sheffield 40mm  - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Da nam Daniel Wellington Bristol 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',500000,0,999,N'/Images/Dây Da nam Daniel Wellington Bristol 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Da nam Daniel Wellington York 40mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',500000,0,999,N'/Images/Dây Da nam Daniel Wellington York 40mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Nato nam Daniel Wellington Cornwall 40mm - Sliver',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',500000,0,999,N'/Images/Dây Nato nam Daniel Wellington Cornwall 40mm - Sliver.jpg',getdate(),1)
insert into SanPham values(13,5,N'Dây Da nam Daniel Wellington Sheffield 40mm - Sliver',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',400000,0,999,N'/Images/Dây Da nam Daniel Wellington Sheffield 40mm - Sliver.jpg',getdate(),1)


insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Cornwall 36mm',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Cornwall 36mm.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Da nữ Daniel Wellington Sheffield 36mm - Sliver',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Da nữ Daniel Wellington Sheffield 36mm - Sliver.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Cornwall 36mm  - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',700000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Cornwall 36mm  - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Da nữ Daniel Wellington Reading 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',200000,0,999,N'/Images/Dây Da nữ Daniel Wellington Reading 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Classy Winchester 26mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',500000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Classy Winchester 26mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Classy Winchester 34mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',300000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Classy Winchester 34mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Winchester 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Winchester 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Oxford 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',900000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Oxford 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Canterbury 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',850000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Canterbury 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Nato nữ Daniel Wellington Glasgow 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',100000,0,999,N'/Images/Dây Nato nữ Daniel Wellington Glasgow 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Da nữ Daniel Wellington St Mawes 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',500000,0,999,N'/Images/Dây Da nữ Daniel Wellington St Mawes 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Da nữ Daniel Wellington Sheffield 36mm  - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',800000,0,999,N'/Images/Dây Da nữ Daniel Wellington Sheffield 36mm  - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Da nữ Daniel Wellington Bristol 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',900000,0,999,N'/Images/Dây Da nữ Daniel Wellington Bristol 36mm - Rose Gold.jpg',getdate(),1)
insert into SanPham values(14,5,N'Dây Da nữ Daniel Wellington York 36mm - Rose Gold',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',1000000,0,999,N'/Images/Dây Da nữ Daniel Wellington York 36mm - Rose Gold.jpg',getdate(),1)


insert into SanPham values(15,5,N'Vòng tay Daniel Wellington Classic Cuff L - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',400000,0,999,N'/Images/Vòng tay Daniel Wellington Classic Cuff L - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(15,5,N'Vòng tay Daniel Wellington Classic Cuff S - Vàng Hồng',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',300000,0,999,N'/Images/Vòng tay Daniel Wellington Classic Cuff S - Vàng Hồng.jpg',getdate(),1)
insert into SanPham values(15,5,N'Vòng tay Daniel Wellington Classic Cuff L - Bạc',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',200000,0,999,N'/Images/Vòng tay Daniel Wellington Classic Cuff L - Bạc.jpg',getdate(),1)
insert into SanPham values(15,5,N'Vòng tay Daniel Wellington Classic Cuff S - Bạc',N'+Thương hiệu: Daniel Wellington; +Xuất xứ: Thụy Điển',900000,0,999,N'/Images/Vòng tay Daniel Wellington Classic Cuff S - Bạc.jpg',getdate(),1)

-- Thêm dữ liệu bảng hóa đơn và chi tiết hóa đơn
-- Tháng 1
insert into HoaDon values('HD1','0385369830','01/05/2020','01/08/2020',1,1,'Không có',1000000)
insert into ChiTietHD values('HD1',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,1,1000000)

insert into HoaDon values('HD2','0382013685','01/09/2020','01/10/2020',1,1,'Không có',1000000)
insert into ChiTietHD values('HD2',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,1,1000000)

-- Tháng 3
insert into HoaDon values('HD3','0123456111','03/05/2020','03/08/2020',1,1,'Không có',3000000)
insert into ChiTietHD values('HD3',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,3,3000000)


insert into HoaDon values('HD4','0388452147','03/05/2020','03/08/2020',1,1,'Không có',6000000)
insert into ChiTietHD values('HD4',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,6,6000000)
-- Tháng 5
insert into HoaDon values('HD5','0382013685','05/14/2020','05/15/2020',1,1,'Không có',3000000)
insert into ChiTietHD values('HD5',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,3,3000000)
insert into HoaDon values('HD8','0382013685','05/01/2020','05/02/2020',1,1,'Không có',10000000)
insert into ChiTietHD values('HD8',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,1,1000000)
insert into ChiTietHD values('HD8',1002,N'Đồng hồ nam dây cao su Casio W-W218H-1AVDF 44,4×43',1000000,3,3000000)

-- Tháng 7
insert into HoaDon values('HD6','0385369830','07/22/2020','07/25/2020',1,1,'Không có',3000000)
insert into ChiTietHD values('HD6',1000,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm x 43.2 mm - Đen Đỏ',1000000,3,3000000)

-- Tháng 12
insert into HoaDon values('HD7','0785359535','12/22/2020','12/25/2020',1,1,'Không có',29730000)
insert into ChiTietHD values('HD7',1001,N'Đồng hồ nam dây cao su Casio W-218H-2AVDF 44.4 mm ',1200000,1,1200000)
insert into ChiTietHD values('HD7',1002,N'Đồng hồ nam dây cao su Casio W-W218H-1AVDF 44,4×43',1000000,1,1000000)
insert into ChiTietHD values('HD7',1062,N'Đồng Hồ Nữ Dây Nhựa Casio BABY-G BA-110GA-1A1 46,3',1800000,1,1800000)

