using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using PagedList;

namespace WEB.Areas.Administrator.Controllers
{
    public class KhachHangController : Controller
    {
        Models.AdminContext dbCus = new Models.AdminContext();
        AdminDB aDB = new AdminDB();
        //
        // GET: /Administrator/Category/
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
                ViewBag.CusError = error;
                var model = aDB.LayKhachHang();
                if (!string.IsNullOrEmpty(name))
                {
                    model = aDB.TimKhachHang(name);
                }
                return View(model);
            }
        }
    }
}