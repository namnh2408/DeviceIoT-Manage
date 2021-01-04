using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PagedList;
using PagedList.Mvc;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace WEB.Areas.Administrator.Controllers
{
    public class SanPhamController : Controller
    {
        Models.AdminContext dbPro = new Models.AdminContext();
        WEB.Repository.ShopDAO shopDAO = new Repository.ShopDAO();
        AdminDB aDB = new AdminDB();
        //
        // GET: /Administrator/Product/
        [HandleError]
        public ActionResult Index(string error, string name)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.ProError = error;
                var model = aDB.LaySanPham();
                if (!string.IsNullOrEmpty(name))
                {
                    model = aDB.TimSanPham(name);
                }
                return View(model);
            }
        }

        [HandleError]
        public ActionResult Index2(string error, string name)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.ProError = error;
                var model = aDB.LaySanPhamHetHang();
                if (!string.IsNullOrEmpty(name))
                {
                    model = model.Where(p => p.TenSP.Contains(name)).ToList();
                }
                return View(model);
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
                ViewBag.pdcListCreate = new SelectList(dbPro.ThuongHieux, "MaThuongHieu", "TenTH");
                ViewBag.typeListCreate = new SelectList(dbPro.LoaiSPs, "MaLoaiSP", "TenLoaiSP");
                return View();
            }
        }

        [HandleError]
        [HttpPost]
        public ActionResult Create(Models.SanPham createPro, HttpPostedFileBase file)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {

                ViewBag.pdcListCreate = new SelectList(dbPro.ThuongHieux, "MaThuongHieu", "TenTH");
                ViewBag.typeListCreate = new SelectList(dbPro.LoaiSPs, "MaLoaiSP", "TenLoaiSP");
                var pro = dbPro.SanPhams.SingleOrDefault(c => c.MaSP.Equals(createPro.MaSP));
                if (file != null)
                {
                    if (file.ContentLength > 0)
                    {
                        try
                        {
                            string nameFile = Path.GetFileName(file.FileName);
                            file.SaveAs(Path.Combine(Server.MapPath("/Images"), nameFile));
                            createPro.HinhAnh = "/Images/" + nameFile;
                        }
                        catch (Exception)
                        {
                            ViewBag.CreateProError = "Không thể chọn ảnh.";
                        }
                    }
                    try
                    {
                        if (pro != null)
                        {
                            ViewBag.CreateProError = "Mã sản phẩm đã tồn tại.";
                        }
                        else
                        {
                            aDB.ThemSanPham(createPro);
                            ViewBag.CreateProError = "Thêm sản phẩm thành công.";
                        }
                    }
                    catch (Exception)
                    {
                        ViewBag.CreateProError = "Không thể thêm sản phẩm.";
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
                ViewBag.pdcListCreate = new SelectList(dbPro.ThuongHieux, "MaThuongHieu", "TenTH");
                ViewBag.typeListCreate = new SelectList(dbPro.LoaiSPs, "MaLoaiSP", "TenLoaiSP");
                var model = dbPro.SanPhams.SingleOrDefault(p => p.MaSP.Equals(id));
                return View(model);
            }
        }

        [HandleError]
        [HttpPost]
        public ActionResult Edit(Models.SanPham editPro, HttpPostedFileBase file)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                ViewBag.pdcListCreate = new SelectList(dbPro.ThuongHieux, "MaThuongHieu", "TenTH");
                ViewBag.typeListCreate = new SelectList(dbPro.LoaiSPs, "MaLoaiSP", "TenLoaiSP");
                if (file != null)
                {
                    if (file.ContentLength > 0)
                    {
                        try
                        {
                            string nameFile = Path.GetFileName(file.FileName);
                            file.SaveAs(Path.Combine(Server.MapPath("/Images"), nameFile));
                            editPro.HinhAnh = "/Images/" + nameFile;
                        }
                        catch (Exception)
                        {
                            ViewBag.EditProError = "Không thể chọn ảnh.";
                        }
                    }
                }
                try
                {
                    aDB.SuaSanPham(editPro);
                    ViewBag.EditProError = "Cập nhật sản phẩm thành công.";
                }
                catch (Exception)
                {
                    ViewBag.EditProError = "Không thể cập nhật sản phẩm.";
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
                var model = dbPro.SanPhams.SingleOrDefault(h => h.MaSP.Equals(id));
                try
                {
                    if (model != null)
                    {
                        aDB.XoaSanPham(id);
                        return RedirectToAction("Index", "SanPham", new { error = "Xoá sản phẩm thành công." });
                    }
                    else
                    {
                        return RedirectToAction("Index", "SanPham", new { error = "Sản phẩm không tồn tại." });
                    }
                }
                catch (Exception)
                {
                    return RedirectToAction("Index", "SanPham", new { error = "Không thể xoá sản phẩm." });
                }

            }
        }
        [HandleError]
        public ActionResult Details(int id)
        {
            if (Session["accname"] == null)
            {
                Session["accname"] = null;
                return RedirectToAction("Login", "Account");
            }
            else
            {
                var model = aDB.XemChiTietSanPham(id).SingleOrDefault();
                return View(model);
            }
        }
    }
}