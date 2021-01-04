using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PagedList;
using System.IO;

namespace WEB.Areas.Shopper
{
    public class SanPhamController : Controller
    {
        Models.UserContext db = new Models.UserContext();
        // GET: Shopper/Products
        //hiển thị sản phẩm theo  loại
        UserDB uDB = new UserDB();
        public ActionResult SanPhamTheoLoai(int id, int? page)
        {
            ViewBag.typeName = db.LoaiSPs.SingleOrDefault(t => t.MaLoaiSP == id).TenLoaiSP;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(uDB.LaySanPhamTheoLoai(id).ToPagedList(pageNumber, pageSize));
        }
        //hiển thị sản phẩm theo thương hiệu
        public ActionResult SanPhamTheoThuongHieu(int id, int? page)
        {
            ViewBag.pdcName = db.ThuongHieux.SingleOrDefault(c => c.MaThuongHieu == id).TenTH;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(uDB.LaySanPhamTheoThuongHieuController(id).ToPagedList(pageNumber, pageSize));
        }
        //hiển thị sản phẩm theo tên sp
        public ActionResult SanPhamTheoTenSP(string name, int? page)
        {
            ViewBag.search = name;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(uDB.LaySanPhamTheoTen(name).ToPagedList(pageNumber, pageSize));
        }
        //hiển thị sản phẩm theo tên loại
        public ActionResult SanPhamTheoTenLoai(string name, int? page)
        {
            ViewBag.tName = name;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(db.SanPhams.Where(p => p.MaLoaiSP == db.LoaiSPs.FirstOrDefault(t => t.TenLoaiSP.Equals(name)).MaLoaiSP).OrderByDescending(x => x.NgayThem).ToPagedList(pageNumber, pageSize));
        }
        //Hiển thị sản phẩm mới nhất
        public ActionResult SanPhamMoiNhat(string title, int? page)
        {
            ViewBag.titleDisplay = title;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(uDB.LaySanPhamMoiNhat().ToPagedList(pageNumber, pageSize));
        }
        //Hiển thị sản phẩm giảm giá cao nhất
        public ActionResult SanPhamGiamGiaCaoNhat(string title, int? page)
        {
            ViewBag.titleDisplayOfDis = title;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(uDB.LaySanPhamGiamGiaCaoNhatView().ToPagedList(pageNumber, pageSize));
        }
        //Hiển thị chi tiết sản phẩm

        public ActionResult ChiTietSanPham(int id)
        {
            return View(uDB.XemChiTietSanPham(id).SingleOrDefault());
        }

        // Hiển thị sản phẩm theo danh mục
        public ActionResult SanPhamTheoDanhMuc(int id, int? page)
        {
            ViewBag.DanhMuc = db.DanhMucs.SingleOrDefault(t => t.MaDanhMuc == id).TenDanhMuc;
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(uDB.LaySanPhamTheoDanhMuc(id).ToPagedList(pageNumber, pageSize));
        }
    }
}