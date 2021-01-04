using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WEB.Areas.Administrator.Models;

namespace WEB.Areas.Administrator.Controllers
{
    public class AccountController : Controller
    {
        Models.AdminContext dbLog = new Models.AdminContext();
        Repository.ShopDAO dao = new Repository.ShopDAO();
        // GET: Administrator/Account
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken()]
        public ActionResult Login(Models.QuanTri adLogin)
        {
            try
            {
                var model = dbLog.QuanTris.SingleOrDefault(a => a.TaiKhoan.Equals(adLogin.TaiKhoan));
                if (model != null)
                {
                    if (model.MatKhau.Equals(dao.Encrypt(adLogin.MatKhau)))
                    {
                        Session["accname"] = model.TaiKhoan;
                        return RedirectToAction("Index", "ThongKe");
                    }
                    else
                    {
                        Session["accname"] = null;
                        ViewBag.LoginError = "Sai tài khoản hoặc mật khẩu.";
                    }
                }
                else
                {
                    Session["accname"] = null;
                    ViewBag.LoginError = "Sai tài khoản hoặc mật khẩu.";
                }
            }
            catch (Exception)
            {
                Session["accname"] = null;
                ViewBag.LoginError = "Sai tài khoản hoặc mật khẩu.";
            }
            return View();
        }

        public ActionResult Logout()
        {
            System.Web.Security.FormsAuthentication.SignOut();
            Session["accname"] = null;
            return RedirectToAction("Login", "Account");
        }
    }
}