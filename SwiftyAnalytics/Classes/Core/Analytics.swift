//
//  Analytics.swift
//  SwiftyAnalytics
//
//  Created by Mark G on 3/25/20.
//

import StoreKit

// MARK: Analytics
public class Analytics<EventType: AnalyticsEventable>: AnalyticsProviable {
    fileprivate var _providers: [AnalyticsProviable]!
    fileprivate var _popupAnyalyticDatas = [PopupAnalyticData]()
    fileprivate var _engagementTracker = EngagementTracker()
    
    public init() {
        
        _registerPopupNotifications()
    }
}

// MARK: - Public
extension Analytics {
    public func configure(providers: [AnalyticsProviable]) {
        _providers = providers
    }
    
    /// Set user id
    public func setUserId(_ userId: String?) {
        _providers.forEach { $0.setUserId(userId) }
    }
    
    /// Set user attributes
    public func setUserProperty(_ value: String?, for name: String) {
        _providers.forEach { $0.setUserProperty(value, for: name) }
    }
    
    /// Set screen name associated with a class
    public func setScreenName<T>(_ screenName: String?, type: T.Type) {
        _providers.forEach { $0.setScreenName(screenName, screenClass: "\(T.self)" )}
    }
    
    /// Set popup name associated with a class
    public func setPopupName<T>(_ popupName: String?, type: T.Type) {
       
        guard
            let index = self._popupAnyalyticDatas
                .lastIndex(where: { $0.className == "\(type.self)" })
            else { return }
        var data = self._popupAnyalyticDatas[index]
        data.name = popupName
        self._popupAnyalyticDatas[index] = data
    }
    
    /// Log an event with name & parameters
    public func log(event name: String, parameters: [String:Any]?) {
        
        let parameters = _appendAutomaticallyCollectedParamaters(parameters)
        print("[analytics] - log > ", name, parameters == nil ? nil : parameters!)
        _providers
            .forEach { $0.log(event: name, parameters: parameters) }
    }
    
    public func log(event name: String, parameters: [String:Any]?, providers: [AnalyticsProviable.Type]) {
        
        let parameters = _appendAutomaticallyCollectedParamaters(parameters)
        print("[analytics] - log > ", name, parameters == nil ? nil : parameters!)
        let all = _getFilteredProviders(providers)
        all
            .forEach { $0.log(event: name, parameters: parameters) }
    }
    
    /// Log an event with an `EventType`
    public func log(event: EventType) {
        
        var all = _providers
        if let types = event.providers() {
            all = _getFilteredProviders(types)
        }
        
        all?.forEach {
            
            let parameters = _appendAutomaticallyCollectedParamaters(event.parameters($0))
            print("[analytics] - log > ", event.name(), parameters == nil ? nil : parameters!)
            $0.log(
                event: event.name(),
                parameters: parameters
            )
        }
    }
    
    /// Log in-app purchase
    @available(watchOSApplicationExtension 6.2, *)
    public func log(iap transaction: SKPaymentTransaction, product: SKProduct, receipt: String) {
        _providers.forEach {
            $0.log(iap: transaction, product: product, receipt: receipt)
        }
    }
}

// MARK: - Private
extension Analytics {
    
    ///
    fileprivate func _getFilteredProviders(_ types: [AnalyticsProviable.Type]) -> [AnalyticsProviable] {
        let typeStrings = types.map { "\($0.self)" }
        return _providers.filter {
            typeStrings.contains("\($0.self)")
        }
    }
    
    fileprivate func _appendAutomaticallyCollectedParamaters(_ parameters: [String:Any]?) -> [String:Any]? {
        var parameters = parameters
        
        // Append popup if has
        if let data = _popupAnyalyticDatas.last,
            parameters?["popup_class"] == nil {
            parameters = parameters ?? [:]
            parameters?["popup_class"] = data.className
            parameters?["popup"] = data.name
        }
        
        return parameters
    }
}

// MARK: - Popup
extension Analytics {
    
    fileprivate func _registerPopupNotifications() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "AnalyticsPopupOpen"), object: nil, queue: nil) { [weak self] notification in
            
            guard
                let `self` = self,
                let className = notification.object as? String
                else { return }
            
            let id = "\(Date())"
            self._engagementTracker.begin(for: id)
            self._popupAnyalyticDatas.append(
                .init(engagementTrackerId: id, className: className, name: nil)
            )
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "AnalyticsPopupClose"), object: nil, queue: nil) { [weak self] notification in
            
            guard
                let `self` = self,
                let className = notification.object as? String,
                let index = self._popupAnyalyticDatas
                    .lastIndex(where: { $0.className == className })
                else { return }
            
            // Remove
            let data = self._popupAnyalyticDatas[index]
            self._popupAnyalyticDatas.remove(at: index)
            
            // Log
            let time = self._engagementTracker.end(for: data.engagementTrackerId)
            self.log(event: "popup_view", parameters: [
                "popup_class" : className,
                "popup": data.name as Any,
                "sa_engagement_time_msec": time as Any
            ])
        }
    }
}

fileprivate struct PopupAnalyticData {
    let engagementTrackerId: String
    let className: String
    var name: String?
}
