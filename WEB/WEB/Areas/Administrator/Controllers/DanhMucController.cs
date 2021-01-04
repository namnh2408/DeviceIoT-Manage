using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WEB.Areas.Administrator.Controllers
{
    public class DanhMucController : Controller
    {
        Models.AdminContext db = new Models.AdminContext();
        AdminDB aDB = new AdminDB();
        //
        // GET: /Administrator/Category/
        [HandleError]
        public ActionResult Index(string error)
        {
            //if (Session["accname"] == null)
            //{
            //    Session["accname"] = null;
            //    return RedirectToAction("Login", "Account");
            //}
            //else
            //{
            //    ViewBag.CateError = error;
            //    var model = aDB.LayDanhMuc();
            //    return View(model);
            //}
            ViewBag.CateError = error;
            var model = aDB.LayDanhMuc();
            return View(model);
        }

        [HandleError]
        public ActionResult Create()
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

        [HandleError]
        [HttpPost]
        public ActionResult Create(Models.DanhMuc taoDM, HttpPostedFileBase file)
        {

            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                if (file != null)
                {
                    if (file.ContentLength > 0)
                    {
                        try
                        {
                            string nameFile = Path.GetFileName(file.FileName);
                            file.SaveAs(Path.Combine(Server.MapPath("/Images"), nameFile));
                            taoDM.DanhMucImg = "/Images/" + nameFile;
                        }
                        catch (Exception)
                        {
                            ViewBag.CreateCategory = "Không thể chọn ảnh.";
                        }
                    }
                    try
                    {
                        if (db.DanhMucs.SingleOrDefault(cr => cr.TenDanhMuc.Equals(taoDM.TenDanhMuc)) == null)
                        {
                            aDB.ThemDanhMuc(taoDM);
                            ViewBag.CreateCategory = "Thêm danh mục thành công.";
                        }
                        else
                        {
                            ViewBag.CreateCategory = "Tên danh mục đã tồn tại.";
                        }
                    }
                    catch (Exception)
                    {
                        ViewBag.CreateCategory = "Không thể thêm danh mục.";
                    }
                }
                else
                {
                    ViewBag.HinhAnh = "Vui lòng chọn hình ảnh.";
                }
                return View();
            }
        }

        [HandleError]
        public ActionResult Edit(int id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var model = db.DanhMucs.SingleOrDefault(c => c.MaDanhMuc.Equals(id));
                return View(model);
            }
        }

        [HandleError]
        [HttpPost]
        public ActionResult Edit(Models.DanhMuc suaDM, HttpPostedFileBase file)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                if (file != null)
                {
                    if (file.ContentLength > 0)
                    {
                        try
                        {
                            string nameFile = Path.GetFileName(file.FileName);
                            file.SaveAs(Path.Combine(Server.MapPath("/Images"), nameFile));
                            suaDM.DanhMucImg = "/Images/" + nameFile;
                        }
                        catch (Exception)
                        {
                            ViewBag.EditCategory = "Không thể chọn ảnh.";
                        }
                    }
                }
                try
                {
                    if (ModelState.IsValid)
                    {
                        if (db.DanhMucs.SingleOrDefault(cr => cr.TenDanhMuc.Equals(suaDM.TenDanhMuc)) == null)
                        {
                            aDB.SuaDanhMuc(suaDM);
                            ViewBag.EditCategory = "Cập nhật danh mục thành công.";
                        }
                        else
                        {
                            ViewBag.EditCategory = "Tên danh mục đã tồn tại.";
                        }
                    }
                }
                catch (Exception)
                {
                    ViewBag.EditCategory = "Không thể cập nhật danh mục.";
                }
                return View();
            }
        }

        [HandleError]
        public ActionResult Delete(int id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var model = db.DanhMucs.SingleOrDefault(h => h.MaDanhMuc.Equals(id));
                try
                {
                    if (model != null)
                    {
                        aDB.XoaDanhMuc(id);
                        return RedirectToAction("Index", "DanhMuc", new { error = "Xoá danh mục thành công." });
                    }
                    else
                    {
                        return RedirectToAction("Index", "DanhMuc", new { error = "Danh mục không tồn tại." });
                    }
                }
                catch (Exception)
                {
                    return RedirectToAction("Index", "DanhMuc", new { error = "Không thể xoá danh mục." });
                }
            }
        }
    }
}