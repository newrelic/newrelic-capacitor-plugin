import Foundation
import Capacitor
import NewRelic
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(NewRelicCapacitorPluginPlugin)
public class NewRelicCapacitorPluginPlugin: CAPPlugin {
    private let implementation = NewRelicCapacitorPlugin()
    
    public override func load() {
        
        NewRelic.setPlatform(NRMAApplicationPlatform.platform_Cordova);
        NewRelic.start(withApplicationToken:"AA0bdcf0840aa947658bfb3c276ca6760e00dba650-NRMA")   
        
  }

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func setUserId(_ call: CAPPluginCall) {
        let userId = call.getString("userId") ?? ""
        NewRelic.setUserId(userId)
        call.resolve()
    }
    
    @objc func setAttribute(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? ""
        let value = call.getString("value") ?? ""

        NewRelic.setAttribute(name, value:value)
        call.resolve()
    }
    
    @objc func removeAttribute(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? ""
        NewRelic.removeAttribute(name)
        call.resolve()
    }
    
    @objc func recordBreadcrumb(_ call: CAPPluginCall) {
        let name = call.getString("name") ?? ""
        let eventAttributes = call.getObject("eventAttributes")
        
        NewRelic.recordBreadcrumb(name,attributes: eventAttributes);
        call.resolve()
    }
    
    @objc func recordCustomEvent(_ call: CAPPluginCall) {
        let name = call.getString("eventName") ?? ""
        let eventType = call.getString("eventType") ?? ""
        let attributes = call.getObject("attributes")
        
        NewRelic.recordCustomEvent(eventType, name: name,attributes: attributes)
        call.resolve()
    }
    
    @objc func startInteraction(_ call: CAPPluginCall) {
        let actionName = call.getString("value") ?? ""
        
        let interactionId = NewRelic.startInteraction(withName: actionName)
        call.resolve([
            "value": interactionId
        ])
    }
    
    @objc func endInteraction(_ call: CAPPluginCall) {
        let interactionId = call.getString("interactionId") ?? ""
     
        
        NewRelic.stopCurrentInteraction(interactionId)
        call.resolve()
    }
}
