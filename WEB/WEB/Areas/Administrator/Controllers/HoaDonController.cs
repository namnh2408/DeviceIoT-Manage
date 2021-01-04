using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WEB.Areas.Administrator.Models;

namespace WEB.Areas.Administrator.Controllers
{
    public class HoaDonController : Controller
    {
        Models.AdminContext db = new Models.AdminContext();
        AdminDB aDB = new AdminDB();
        // GET: Administrator/Orders
        [HandleError]
        public ActionResult Index(string name, string error)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.CateError = error;
                var model = aDB.LayHoaDonChuaXacNhan();
                if (!string.IsNullOrEmpty(name))
                {
                    model = aDB.TimHoaDonChuaXacNhan(name);
                }
                return View(model);
            }
        }
        [HandleError]
        public ActionResult Index2(string name, string error)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.CateError = error;
                var model = aDB.LayHoaDonDaXacNhan();
                if (!string.IsNullOrEmpty(name))
                {
                    model = aDB.TimHoaDonDaXacNhan(name);
                }
                return View(model);
            }
        }
        [HandleError]
        public ActionResult Index3(string name, string error)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.CateError = error;
                var model = aDB.LayHoaDonChuaGiao();
                if (!string.IsNullOrEmpty(name))
                {
                    model = aDB.TimHoaDonDangGiao(name);
                }
                return View(model);
            }
        }

        [HandleError]
        public ActionResult Index4(string name, string error)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.CateError = error;
                var model = aDB.LayHoaDonHoanTat();
                if (!string.IsNullOrEmpty(name))
                {
                    model = aDB.TimHoaDonDaHoanTat(name);
                }
                return View(model);
            }
        }
        // GET: Administrator/Orders/Details/5
        [HandleError]
        public ActionResult Details(string id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var model = db.HoaDons.SingleOrDefault(p => p.MaHD.Equals(id));
                return View(model);
            }
        }
        [HandleError]
        public ActionResult Details2(string id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var model = db.HoaDons.SingleOrDefault(p => p.MaHD.Equals(id));
                return View(model);
            }
        }

        // GET: Administrator/Orders/Edit/5
        [HandleError]
        public ActionResult XacNhan(string id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                aDB.ThemHoaDonDaXacNhan(id);
                return RedirectToAction("Index", "HoaDon");
            }
        }

        [HandleError]
        public ActionResult HoanTat(string id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                aDB.ThemHoaDonDaHoanTat(id);
                return RedirectToAction("Index3", "HoaDon");
            }
        }
        [HandleError]
        [HttpGet]
        public ActionResult Edit(string id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                return View(db.HoaDons.SingleOrDefault(e => e.MaHD.Equals(id)));
            }
        }

        [HandleError]
        [HttpPost]
        public ActionResult Edit(Models.HoaDon editType)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        aDB.ThemHoaDonChuaHoantat(editType);
                        ViewBag.EditTypeError = "Cập nhật hóa đơn thành công.";
                    }
                }
                catch (Exception)
                {
                    ViewBag.EditTypeError = "Không thể cập nhật hóa đơn.";
                }
                return View();
            }
        }

        [HandleError]
        public ActionResult Delete(string id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var model = db.HoaDons.SingleOrDefault(h => h.MaHD.Equals(id));
                try
                {
                    if (model != null)
                    {
                        aDB.HuyHoaDon(id);
                        return RedirectToAction("Index2", "HoaDon", new { error = "Hủy hóa đơn thành công." });
                    }
                    else
                    {
                        return RedirectToAction("Index2", "HoaDon", new { error = "Hóa đơn không tồn tại." });
                    }
                }
                catch (Exception)
                {
                    return RedirectToAction("Index2", "HoaDon", new { error = "Không thể hủy hóa đơn." });
                }

            }
        }
    }
}