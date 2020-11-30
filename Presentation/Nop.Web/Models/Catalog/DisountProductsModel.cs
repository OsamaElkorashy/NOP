using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc.Rendering;
using Nop.Web.Framework.Mvc.ModelBinding;
using Nop.Web.Framework.Models;

namespace Nop.Web.Models.Catalog
{
    public partial class DisountProductsModel : BaseNopModel
    {
        public DisountProductsModel()
        {
            PagingFilteringContext = new CatalogPagingFilteringModel();
            Products = new List<ProductOverviewModel>();
        }

        /// <summary>
        /// Discount ID
        /// </summary>
        [NopResourceDisplayName("Search.Discount")]
        public int did { get; set; }
        public CatalogPagingFilteringModel PagingFilteringContext { get; set; }
        public IList<ProductOverviewModel> Products { get; set; }

    }
}