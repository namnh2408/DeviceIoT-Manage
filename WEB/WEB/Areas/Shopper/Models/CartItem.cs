using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Areas.Shopper.Models
{
    public class CartItem
    {

        public int SanPhamID { get; set; }
        public string TenSanPham { get; set; }
        public string Hinh { get; set; }
        public decimal DonGia { get; set; }
        public int SoLuong { get; set; }
        public int soluongmax { get; set; }
        public decimal ThanhTien
        {
            get
            {
                return SoLuong * DonGia;
            }
        }
        /*
        public CartItem(string proID)
        {
            Product p = db.Products.Single(pr => pr.proID.Equals(proID));

            soluongmax = p.soluong;
        }
        */
    }
}