using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace WEB.Areas.Administrator.Controllers
{
    public class ThongKeController : Controller
    {
        // GET: Administrator/ThongKe
        AdminDB aDB = new AdminDB();
        [HandleError]
        public ActionResult Index()
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                DateTime value = new DateTime();
                value = DateTime.Now;
                int mm = value.Month;
                int yy = value.Year;
                ViewBag.DoanhThu = aDB.TinhDoanhThuNam().ToString("#,##0");
                ViewBag.HoaDonDangGiao = aDB.TinhSoHoaDonChuaGiao();
                ViewBag.HoaDonDaHoanTat = aDB.TinhSoHoaDonDaGiao();
                ViewBag.HoaDonChoXacNhan = aDB.TinhSoHDTrongNgay();
                ViewBag.HoaDonDaXacNhan = aDB.TinhSoHoaDonChuaHoanTat();
                ViewBag.SanPhamHetHang = aDB.SoSanPhamHetHang();
                ViewBag.NewCus = aDB.newCustomer();
                ViewBag.DoanhThuThangNam = aDB.TinhDoanhThuTheoThangNam(mm, yy).ToString("#,##0");
                return View();
            }
        }
        [HandleError]
        public ActionResult DoanhThuThangNam()
        {

            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                DateTime value = new DateTime();
                value = DateTime.Now;
                int mm = value.Month;
                int yy = value.Year;
                var model = aDB.LayHoaDonTheoThangNam(mm, yy);
                return View(model);
            }
        }
        [HandleError]
        public ActionResult DoanhThuCacThang(string id)
        {

            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.Thang = id;
                ViewBag.doanhthu = aDB.TinhDoanhThuTheoThangNam(Int32.Parse(id), DateTime.Now.Year).ToString("#,##0");
                var model = aDB.LayHoaDonTheoThang(id);
                return View(model);
            }
        }
        [HandleError]
        public ActionResult DoanhThuNam()
        {

            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                return View();
            }
        }
    }
}