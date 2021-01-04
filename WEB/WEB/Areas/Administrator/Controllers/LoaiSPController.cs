using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WEB.Areas.Administrator.Controllers
{
    public class LoaiSPController : Controller
    {
        Models.AdminContext dbType = new Models.AdminContext();
        AdminDB aDB = new AdminDB();
        //
        // GET: /Administrator/ProductType/
        [HandleError]
        public ActionResult Index(string error)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.TypeError = error;
                return View(aDB.LayLoaiSP());
            }
        }

        [HandleError]
        [HttpGet]
        public ActionResult Create()
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.cateListCreate = new SelectList(dbType.DanhMucs, "MaDanhMuc", "TenDanhMuc");
                return View();
            }
        }

        [HandleError]
        [HttpPost]
        public ActionResult Create(Models.LoaiSP createType)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.cateListCreate = new SelectList(dbType.DanhMucs, "MaDanhMuc", "TenDanhMuc");
                try
                {
                    if (ModelState.IsValid)
                    {
                        //dbType.ProductTypes.Add(createType);
                        //dbType.SaveChanges();
                        aDB.ThemLoaiSP(createType);
                        ViewBag.CreateTypeError = "Thêm loại sản phẩm thành công.";
                    }
                }
                catch (Exception)
                {
                    ViewBag.CreateTypeError = "Không thể thêm loại sản phẩm.";
                }
                return View();
            }
        }

        [HandleError]
        [HttpGet]
        public ActionResult Edit(int id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.cateListEdit = new SelectList(dbType.DanhMucs, "MaDanhMuc", "TenDanhMuc");
                return View(dbType.LoaiSPs.SingleOrDefault(e => e.MaLoaiSP.Equals(id)));
            }
        }

        [HandleError]
        [HttpPost]
        public ActionResult Edit(Models.LoaiSP editType)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.cateListEdit = new SelectList(dbType.DanhMucs, "MaDanhMuc", "TenDanhMuc");
                try
                {
                    if (ModelState.IsValid)
                    {
                        //dbType.Entry(editType).State = System.Data.Entity.EntityState.Modified;
                        //dbType.SaveChanges();
                        aDB.SuaLoaiSP(editType);
                        ViewBag.EditTypeError = "Cập nhật loại sản phẩm thành công.";
                    }
                }
                catch (Exception)
                {
                    ViewBag.EditTypeError = "Không thể cập nhật loại sản phẩm.";
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
                var model = dbType.LoaiSPs.SingleOrDefault(h => h.MaLoaiSP.Equals(id));
                try
                {
                    if (model != null)
                    {
                        aDB.XoaLoaiSP(id);
                        return RedirectToAction("Index", "LoaiSP", new { error = "Xoá loại sản phẩm thành công." });
                    }
                    else
                    {
                        return RedirectToAction("Index", "LoaiSP", new { error = "Loại sản phẩm không tồn tại." });
                    }
                }
                catch (Exception)
                {
                    return RedirectToAction("Index", "LoaiSP", new { error = "Không thể xoá loại sản phẩm." });
                }
            }
        }
    }
}