using WEB.Areas.Shopper.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WEB.Areas.Shopper.Controllers
{
    public class ThanhToanController : Controller
    {
        UserContext db = new UserContext();
        UserDB uDB = new UserDB();
        // GET: Shopper/ThanhToan
        public ActionResult Index()
        {
            List<CartItem> giohang = Session["giohang"] as List<CartItem>;
            return View(giohang);
        }

        [HttpPost]
        public ActionResult StepEnd()
        {
            //Nhận dữ liệu trên form từ trang index
            string DienThoai = Request.Form["DienThoai"];
            string HoTenKH = Request.Form["HoTenKH"];
            string EmailKH = Request.Form["EmailKH"];
            string DiaChiKH = Request.Form["DiaChiKH"];
            string note = Request.Form["note"];
            //kiểm tra xem có customer chưa và cập nhật lại
            KhachHang newCus = new KhachHang();
            var cus = db.KhachHangs.FirstOrDefault(p => p.DienThoai.Equals(DienThoai));
            if (cus != null)
            {
                //nếu có số điện thoại trong db rồi
                //cập nhật thông tin và lưu
                cus.HoTenKH = HoTenKH;
                cus.EmailKH = EmailKH;
                cus.DiaChiKH = DiaChiKH;
                uDB.UpdateKhachHang(cus);
            }
            else
            {
                //nếu chưa có sđt trong db
                //thêm thông tin và lưu
                newCus.DienThoai = DienThoai;
                newCus.HoTenKH = HoTenKH;
                newCus.EmailKH = EmailKH;
                newCus.DiaChiKH = DiaChiKH;
                uDB.ThemKhachHang(newCus);
            }
            //Thêm thông tin vào order và orderdetail
            List<CartItem> giohang = Session["giohang"] as List<CartItem>;
            //thêm order mới
            HoaDon newOrder = new HoaDon();
            string newIDOrder = (Int32.Parse(db.HoaDons.OrderByDescending(p => p.MaHD).FirstOrDefault().MaHD.Replace("HD", "")) + 1).ToString();
            newOrder.MaHD = "HD" + newIDOrder;
            newOrder.DienThoai = DienThoai;
            newOrder.GhiChu = note;
            uDB.ThemHoaDon(newOrder);
            //thêm details

            for (int i = 0; i < giohang.Count; i++)
            {
                ChiTietHD newOrdts = new ChiTietHD();
                newOrdts.MaHD = newOrder.MaHD;
                newOrdts.MaSP = giohang.ElementAtOrDefault(i).SanPhamID;
                newOrdts.TenSP = giohang.ElementAtOrDefault(i).TenSanPham;
                newOrdts.DonGia = giohang.ElementAtOrDefault(i).DonGia;
                newOrdts.SoLuong = giohang.ElementAtOrDefault(i).SoLuong;
                newOrdts.TongCong = giohang.ElementAtOrDefault(i).ThanhTien;
                uDB.ThemChiTietHD(newOrdts);
                uDB.CapNhatToTalHoaDon(newOrdts.MaHD);
            }

            Session["MHD"] = "HD" + newIDOrder;
            Session["Phone"] = DienThoai;
            //xoá sạch giỏ hàng
            giohang.Clear();
            return RedirectToAction("HoaDon", "ThanhToan");
        }

        public ActionResult HoaDon()
        {
            return View();
        }
    }
}