using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using WEB.Areas.Administrator.Models;

namespace WEB.Areas.Administrator
{
    public class AdminDB
    {
        public static string cn = @"Data Source=DESKTOP-869UNC4;Initial Catalog=WatchShop;Integrated Security=True";
        SqlConnection conn = new SqlConnection(cn);
        Models.AdminContext context = new Models.AdminContext();

        #region Thao tác bảng danh mục
        public List<DanhMuc> LayDanhMuc()
        {
            var data = context.DanhMucs.SqlQuery("[dbo].[LayDanhMuc]").ToList();
            return data;
        }
        public void ThemDanhMuc(DanhMuc dM)
        {
            SqlCommand com = new SqlCommand("ThemDanhMuc", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@TenDanhMuc", dM.TenDanhMuc);
            com.Parameters.AddWithValue("@DanhMucImg", dM.DanhMucImg);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void SuaDanhMuc(DanhMuc dM)
        {
            SqlCommand com = new SqlCommand("SuaDanhMuc", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaDanhMuc", dM.MaDanhMuc);
            com.Parameters.AddWithValue("@TenDanhMuc", dM.TenDanhMuc);
            com.Parameters.AddWithValue("@DanhMucImg", dM.DanhMucImg);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void XoaDanhMuc(int MaDanhMuc)
        {
            SqlCommand com = new SqlCommand("XoaDanhMuc", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaDanhMuc", MaDanhMuc);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        #endregion

        #region Thao tác bảng loại sản phẩm
        public List<LoaiSP> LayLoaiSP()
        {
            var data = context.LoaiSPs.SqlQuery("[dbo].[LayLoaiSP]").ToList();
            return data;
        }
        public void ThemLoaiSP(LoaiSP Lsp)
        {
            SqlCommand com = new SqlCommand("ThemLoaiSanPham", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaDanhMuc", Lsp.MaDanhMuc);
            com.Parameters.AddWithValue("@TenLoaiSP", Lsp.TenLoaiSP);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void SuaLoaiSP(LoaiSP Lsp)
        {
            SqlCommand com = new SqlCommand("SuaLoaiSP", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaLoaiSP", Lsp.MaLoaiSP);
            com.Parameters.AddWithValue("@MaDanhMuc", Lsp.MaDanhMuc);
            com.Parameters.AddWithValue("@TenLoaiSP", Lsp.TenLoaiSP);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void XoaLoaiSP(int MaLoaiSP)
        {
            SqlCommand com = new SqlCommand("XoaLoaiSP", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaLoaiSP", MaLoaiSP);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        #endregion

        #region Thao tác bảng sản phẩm
        public List<SanPham> LaySanPham()
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPham]").ToList();
            return data;
        }
        public List<SanPham> LaySanPhamHetHang()
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamHetHang]").ToList();
            return data;
        }
        public List<SanPham> TimSanPham(string TenSP)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[TimSanPham] @TenSP", new SqlParameter("TenSP", TenSP)).ToList();
            return data;
        }
        public List<SanPham> XemChiTietSanPham(int id)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[XemChiTietSanPham] @MaSP", new SqlParameter("MaSP", id)).ToList();
            return data;
        }
        public void ThemSanPham(SanPham Sp)
        {
            SqlCommand com = new SqlCommand("ThemSanPham", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaLoaiSP", Sp.MaLoaiSP);
            com.Parameters.AddWithValue("@MaThuongHieu", Sp.MaThuongHieu);
            com.Parameters.AddWithValue("@TenSP", Sp.TenSP);
            com.Parameters.AddWithValue("@ThongSoKyTHuat", Sp.ThongSoKyTHuat);
            com.Parameters.AddWithValue("@Gia", Sp.Gia);
            com.Parameters.AddWithValue("@Discount", Sp.Discount);
            com.Parameters.AddWithValue("@SoLuongSP", Sp.SoLuongSP);
            com.Parameters.AddWithValue("@HinhAnh", Sp.HinhAnh);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void SuaSanPham(SanPham Sp)
        {
            SqlCommand com = new SqlCommand("SuaSanPham", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaSP", Sp.MaSP);
            com.Parameters.AddWithValue("@MaLoaiSP", Sp.MaLoaiSP);
            com.Parameters.AddWithValue("@MaThuongHieu", Sp.MaThuongHieu);
            com.Parameters.AddWithValue("@TenSP", Sp.TenSP);
            com.Parameters.AddWithValue("@ThongSoKyThuat", Sp.ThongSoKyTHuat);
            com.Parameters.AddWithValue("@Gia", Sp.Gia);
            com.Parameters.AddWithValue("@Discount", Sp.Discount);
            com.Parameters.AddWithValue("@SoLuongSP", Sp.SoLuongSP);
            com.Parameters.AddWithValue("@HinhAnh", Sp.HinhAnh);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void XoaSanPham(int MaSP)
        {
            SqlCommand com = new SqlCommand("XoaSanPham", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaSP", MaSP);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        #endregion
        #region Thao tác bảng thương hiệu
        public List<ThuongHieu> LayThuongHieu()
        {
            var data = context.ThuongHieux.SqlQuery("[dbo].[LayThuongHieu]").ToList();
            return data;
        }
        public void ThemThuongHieu(ThuongHieu Th)
        {
            SqlCommand com = new SqlCommand("ThemThuongHieu", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@TenTH", Th.TenTH);
            com.Parameters.AddWithValue("@Photo", Th.Photo);
            com.Parameters.AddWithValue("@Email", Th.Email);
            com.Parameters.AddWithValue("@DiaChi", Th.DiaChi);
            com.Parameters.AddWithValue("@DienTHoai", Th.DienTHoai);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void SuaThuongHieu(ThuongHieu Th)
        {
            SqlCommand com = new SqlCommand("SuaThuongHieu", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaThuongHieu", Th.MaThuongHieu);
            com.Parameters.AddWithValue("@TenTH", Th.TenTH);
            com.Parameters.AddWithValue("@Photo", Th.Photo);
            com.Parameters.AddWithValue("@Email", Th.Email);
            com.Parameters.AddWithValue("@DiaChi", Th.DiaChi);
            com.Parameters.AddWithValue("@DienTHoai", Th.DienTHoai);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void XoaThuongHieu(int MaThuongHieu)
        {
            SqlCommand com = new SqlCommand("XoaThuongHieu", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaThuongHieu", MaThuongHieu);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        #endregion
        #region Thao tác bảng khách hàng
        public List<KhachHang> LayKhachHang()
        {
            var data = context.KhachHangs.SqlQuery("[dbo].[LayKhachhang]").ToList();
            return data;
        }
        public List<KhachHang> TimKhachHang(string phone)
        {
            var data = context.KhachHangs.SqlQuery("[dbo].[TimKhachHang] @Phone", new SqlParameter("Phone", phone)).ToList();
            return data;
        }
        #endregion
        #region Thao tác bảng hóa đơn
        public List<HoaDon> LayHoaDonChuaXacNhan()
        {
            var data = context.HoaDons.SqlQuery("[dbo].[LayHoaDonChuaXacNhan]").ToList();
            return data;
        }
        public List<HoaDon> TimHoaDonDangGiao(string dt)
        {
            var data = context.HoaDons.SqlQuery("[dbo].[TimHoaDonDangGiao] @ngay", new SqlParameter("ngay", dt)).ToList();
            return data;
        }
        public List<HoaDon> LayHoaDonDaXacNhan()
        {
            var data = context.HoaDons.SqlQuery("[dbo].[LayHoaDonDaXacNhan]").ToList();
            return data;
        }
        public List<HoaDon> LayHoaDonChuaGiao()
        {
            var data = context.HoaDons.SqlQuery("[dbo].[LayHoaDonChuaGiao]").ToList();
            return data;
        }
        public List<HoaDon> LayHoaDonHoanTat()
        {
            var data = context.HoaDons.SqlQuery("[dbo].[LayHoaDonHoanTat]").ToList();
            return data;
        }
        public List<HoaDon> LayHoaDonTheoThangNam(int Thang, int Nam)
        {
            var data = context.HoaDons.SqlQuery("[dbo].[LayHoaDonTheoThangNam] @Thang, @Nam", new SqlParameter("Thang", Thang), new SqlParameter("Nam", Nam)).ToList();
            return data;
        }
        public List<HoaDon> LayHoaDonTheoThang(string Thang)
        {
            var data = context.HoaDons.SqlQuery("[dbo].[LayHoaDonTheoThang] @Thang", new SqlParameter("Thang", Thang)).ToList();
            return data;
        }
        public void ThemHoaDonDaXacNhan(string id)
        {
            SqlCommand com = new SqlCommand("ThemHoaDonDaXacNhan", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", id);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void ThemHoaDonChuaHoantat(HoaDon hD)
        {
            SqlCommand com = new SqlCommand("ThemHoaDonChuaHoantat", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", hD.MaHD);
            com.Parameters.AddWithValue("@NgayGiao", hD.NgayGiao);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void ThemHoaDonDaHoanTat(string id)
        {
            SqlCommand com = new SqlCommand("ThemHoaDonDaHoanTat", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", id);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void HuyHoaDon(string id)
        {
            SqlCommand com = new SqlCommand("HuyHoaDon", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", id);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public List<HoaDon> TimHoaDonChuaXacNhan(string name)
        {
            var data = context.HoaDons.SqlQuery("[dbo].[TimHoaDonChuaXacNhan] @DienThoai", new SqlParameter("DienThoai", name)).ToList();
            return data;
        }
        public List<HoaDon> TimHoaDonDaXacNhan(string name)
        {
            var data = context.HoaDons.SqlQuery("[dbo].[TimHoaDonDaXacNhan] @DienThoai", new SqlParameter("DienThoai", name)).ToList();
            return data;
        }
        public List<HoaDon> TimHoaDonDaHoanTat(string name)
        {
            var data = context.HoaDons.SqlQuery("[dbo].[TimHoaDonDaHoanTat] @DienThoai", new SqlParameter("DienThoai", name)).ToList();
            return data;
        }
        #endregion

        #region Thao tác thống kê(function)
        public int TinhSoHDTrongNgay()
        {
            int data = context.Database.SqlQuery<int>("select [dbo].[TinhSoHDTrongNgay]()").Single();
            return data;
        }
        public decimal TinhDoanhThuNam()
        {
            decimal data = context.Database.SqlQuery<decimal>("select [dbo].[TinhDoanhThuNam]()").Single();
            return data;
        }
        public int TinhSoHoaDonDaGiao()
        {
            int data = context.Database.SqlQuery<int>("select [dbo].[TinhSoHoaDonDaGiao]()").Single();
            return data;
        }
        public int TinhSoHoaDonChuaGiao()
        {
            int data = context.Database.SqlQuery<int>("select [dbo].[TinhSoHoaDonChuaGiao]()").Single();
            return data;
        }
        public int TinhSoHoaDonChuaHoanTat()
        {
            int data = context.Database.SqlQuery<int>("select [dbo].[TinhSoHoaDonChuaHoanTat]()").Single();
            return data;
        }
        public int SoSanPhamHetHang()
        {
            int data = context.Database.SqlQuery<int>("select [dbo].[SoSanPhamHetHang]()").Single();
            return data;
        }
        public int newCustomer()
        {
            int data = context.Database.SqlQuery<int>("select [dbo].[newCustomer]()").Single();
            return data;
        }
        public decimal TinhDoanhThuTheoThangNam(int thang, int nam)
        {
            decimal data = context.Database.SqlQuery<decimal>("select [dbo].[TinhDoanhThuTheoThangNam](@Thang,@Nam)", new SqlParameter("Thang", thang)
                , new SqlParameter("Nam", nam)).Single();
            return data;
        }
        #endregion
    }
}