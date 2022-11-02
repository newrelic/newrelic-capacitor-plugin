#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(NewRelicCapacitorPluginPlugin, "NewRelicCapacitorPlugin",
           CAP_PLUGIN_METHOD(start, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setUserId, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setAttribute, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(removeAttribute, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(recordBreadcrumb, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(recordCustomEvent, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(startInteraction, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(endInteraction, CAPPluginReturnNone);

)
