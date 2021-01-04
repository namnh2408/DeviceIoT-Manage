using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using WEB.Areas.Shopper.Models;

namespace WEB.Areas.Shopper
{
    
    public class UserDB
    {
        public static string cn = @"Data Source=DESKTOP-869UNC4;Initial Catalog=WatchShop;Integrated Security=True";
        SqlConnection conn = new SqlConnection(cn);
        Models.UserContext context = new Models.UserContext();

        #region Các thao tác tìm kiếm sản phẩm(Thủ tục)
        public List<SanPham> LaySanPhamTheoLoai(int id)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamTheoLoai] @MaLoaiSP", new SqlParameter("MaLoaiSP", id)).ToList();
            return data;
        }
        public List<SanPham> LaySanPhamTheoThuongHieuController(int id)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamTheoThuongHieuController] @MaThuongHieu", new SqlParameter("MaThuongHieu", id)).ToList();
            return data;
        }
        public List<SanPham> LaySanPhamTheoThuongHieuOrderNgayThemView(int id)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamTheoThuongHieuOrderNgayThemView] @MaThuongHieu", new SqlParameter("MaThuongHieu", id)).ToList();
            return data;
        }
        public List<SanPham> LaySanPhamMoiNhat()
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamMoiNhat]").ToList();
            return data;
        }
        public List<SanPham> LaySanPhamGiamGiaCaoNhatView()
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamGiamGiaCaoNhatView]").ToList();
            return data;
        }
        public List<SanPham> LaySanPhamTheoDanhMuc(int id)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamTheoDanhMuc] @MaDanhMuc", new SqlParameter("MaDanhMuc", id)).ToList();
            return data;
        }
        public List<SanPham> LaySanPhamTheoTen(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamTheoTen] @TenSP", new SqlParameter("TenSP", DBNull.Value)).ToList();
                return data;
            }
            else
            {
                var data = context.SanPhams.SqlQuery("[dbo].[LaySanPhamTheoTen] @TenSP", new SqlParameter("TenSP", name)).ToList();
                return data;
            }
        }
        public List<SanPham> XemChiTietSanPham(int id)
        {
            var data = context.SanPhams.SqlQuery("[dbo].[XemChiTietSanPham] @MaSP", new SqlParameter("MaSP", id)).ToList();
            return data;
        }
        #endregion
        #region Xử lý mua hàng
        public void ThemKhachHang(KhachHang kH)
        {
            SqlCommand com = new SqlCommand("ThemKhachHang", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@DienThoai", kH.DienThoai);
            com.Parameters.AddWithValue("@HoTenKH", kH.HoTenKH);
            com.Parameters.AddWithValue("@EmailKH", kH.EmailKH);
            com.Parameters.AddWithValue("@DiaChiKH", kH.DiaChiKH);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void UpdateKhachHang(KhachHang kH)
        {
            SqlCommand com = new SqlCommand("UpdateKhachHang", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@DienThoai", kH.DienThoai);
            com.Parameters.AddWithValue("@HoTenKH", kH.HoTenKH);
            com.Parameters.AddWithValue("@EmailKH", kH.EmailKH);
            com.Parameters.AddWithValue("@DiaChiKH", kH.DiaChiKH);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void ThemHoaDon(HoaDon hD)
        {
            SqlCommand com = new SqlCommand("ThemHoaDon", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", hD.MaHD);
            com.Parameters.AddWithValue("@DienThoai", hD.DienThoai);
            com.Parameters.AddWithValue("@GhiChu", hD.GhiChu);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void CapNhatToTalHoaDon(string MaHD)
        {
            SqlCommand com = new SqlCommand("CapNhatToTalHoaDon", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", MaHD);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        public void ThemChiTietHD(ChiTietHD CThd)
        {
            SqlCommand com = new SqlCommand("ThemChiTietHD", conn);
            com.CommandType = CommandType.StoredProcedure;
            com.Parameters.AddWithValue("@MaHD", CThd.MaHD);
            com.Parameters.AddWithValue("@MaSP", CThd.MaSP);
            com.Parameters.AddWithValue("@TenSP", CThd.TenSP);
            com.Parameters.AddWithValue("@DonGia", CThd.DonGia);
            com.Parameters.AddWithValue("@SoLuong", CThd.SoLuong);
            com.Parameters.AddWithValue("@TongCong", CThd.TongCong);
            conn.Open();
            com.ExecuteNonQuery();
            conn.Close();
        }
        #endregion

    }
}