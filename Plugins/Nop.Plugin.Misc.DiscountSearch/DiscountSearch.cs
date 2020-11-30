using Nop.Services.Cms;
using Nop.Services.Plugins;
using System;
using System.Collections.Generic;

namespace NOP.Plugin.Misc.Search
{
    public class DiscountSearch : IWidgetPlugin
    {
        public bool HideInWidgetList => throw new NotImplementedException();

        public PluginDescriptor PluginDescriptor { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public string GetConfigurationPageUrl()
        {
            throw new NotImplementedException();
        }

        public string GetWidgetViewComponentName(string widgetZone)
        {
            throw new NotImplementedException();
        }

        public IList<string> GetWidgetZones()
        {
            throw new NotImplementedException();
        }

        public void Install()
        {
            throw new NotImplementedException();
        }

        public void PreparePluginToUninstall()
        {
            throw new NotImplementedException();
        }

        public void Uninstall()
        {
            throw new NotImplementedException();
        }

        public void Update(string currentVersion, string targetVersion)
        {
            throw new NotImplementedException();
        }
    }
}
