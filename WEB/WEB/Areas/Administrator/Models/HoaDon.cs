namespace WEB.Areas.Administrator.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("HoaDon")]
    public partial class HoaDon
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public HoaDon()
        {
            ChiTietHDs = new HashSet<ChiTietHD>();
        }

        [Key]
        [StringLength(20)]
        public string MaHD { get; set; }

        [Required]
        [StringLength(10)]
        public string DienThoai { get; set; }

        public DateTime? NgayTao { get; set; }

        public DateTime? NgayGiao { get; set; }

        public bool? XacNhan { get; set; }

        public bool? HoanTat { get; set; }

        [StringLength(500)]
        public string GhiChu { get; set; }

        [Column(TypeName = "money")]
        public decimal Total { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ChiTietHD> ChiTietHDs { get; set; }

        public virtual KhachHang KhachHang { get; set; }
    }
}
