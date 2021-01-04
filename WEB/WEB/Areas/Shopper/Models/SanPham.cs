namespace WEB.Areas.Shopper.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("SanPham")]
    public partial class SanPham
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SanPham()
        {
            ChiTietHDs = new HashSet<ChiTietHD>();
        }

        [Key]
        public int MaSP { get; set; }

        public int MaLoaiSP { get; set; }

        public int MaThuongHieu { get; set; }

        [Required]
        [StringLength(500)]
        public string TenSP { get; set; }

        public string ThongSoKyTHuat { get; set; }

        [Column(TypeName = "money")]
        public decimal Gia { get; set; }

        public int Discount { get; set; }

        public int? SoLuongSP { get; set; }

        public string HinhAnh { get; set; }

        public DateTime? NgayThem { get; set; }

        public bool? TinhTrang { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ChiTietHD> ChiTietHDs { get; set; }

        public virtual LoaiSP LoaiSP { get; set; }

        public virtual ThuongHieu ThuongHieu { get; set; }
    }
}
