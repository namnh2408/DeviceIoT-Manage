//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Iot_Shop.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Orders_Item
    {
        public string Id_Order { get; set; }
        public int Id_Product { get; set; }
        public Nullable<double> Price { get; set; }
        public Nullable<int> Amount { get; set; }
        public Nullable<double> Discount { get; set; }
        public Nullable<double> Total { get; set; }
        public Nullable<int> Status { get; set; }
    
        public virtual Order Order { get; set; }
        public virtual Product Product { get; set; }
    }
}
