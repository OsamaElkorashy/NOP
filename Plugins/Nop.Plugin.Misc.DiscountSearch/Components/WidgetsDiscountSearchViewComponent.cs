using System;
using Microsoft.AspNetCore.Mvc;
using Nop.Core;
using Nop.Core.Caching;
using Nop.Plugin.Widgets.DiscountSearch.Infrastructure.Cache;
using Nop.Plugin.Widgets.DiscountSearch.Models;
using Nop.Services.Caching;
using Nop.Services.Configuration;
using Nop.Services.Media;
using Nop.Web.Framework.Components;

namespace Nop.Plugin.Widgets.DiscountSearch.Components
{
    [ViewComponent(Name = "WidgetsDiscountSearch")]
    public class WidgetsDiscountSearchViewComponent : NopViewComponent
    {
        private readonly ICacheKeyService _cacheKeyService;
        private readonly IStoreContext _storeContext;
        private readonly IStaticCacheManager _staticCacheManager;
        private readonly ISettingService _settingService;
        private readonly IPictureService _pictureService;
        private readonly IWebHelper _webHelper;

        public WidgetsDiscountSearchViewComponent(ICacheKeyService cacheKeyService,
            IStoreContext storeContext, 
            IStaticCacheManager staticCacheManager, 
            ISettingService settingService, 
            IPictureService pictureService,
            IWebHelper webHelper)
        {
            _cacheKeyService = cacheKeyService;
            _storeContext = storeContext;
            _staticCacheManager = staticCacheManager;
            _settingService = settingService;
            _pictureService = pictureService;
            _webHelper = webHelper;
        }

        public IViewComponentResult Invoke(string widgetZone, object additionalData)
        {
            var discountSearchSettings = _settingService.LoadSetting<DiscountSearchSettings>(_storeContext.CurrentStore.Id);

            var model = new PublicInfoModel
            {
                PictureUrl = "http://localhost:15536/images/thumbs/0000002_desktops_450.jpg"
            };


            return View("~/Plugins/Widgets.DiscountSearch/Views/PublicInfo.cshtml", model);
        }

        protected string GetPictureUrl(int pictureId)
        {
            var cacheKey = _cacheKeyService.PrepareKeyForDefaultCache(ModelCacheEventConsumer.PICTURE_URL_MODEL_KEY, 
                pictureId, _webHelper.IsCurrentConnectionSecured() ? Uri.UriSchemeHttps : Uri.UriSchemeHttp);

            return _staticCacheManager.Get(cacheKey, () =>
            {
                //little hack here. nulls aren't cacheable so set it to ""
                var url = _pictureService.GetPictureUrl(pictureId, showDefaultPicture: false) ?? "";
                return url;
            });
        }
    }
}
