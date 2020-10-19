//
//  AnalyticsProvidable.swift
//  SwiftyAnalytics
//
//  Created by Mark G on 3/25/20.
//


import StoreKit

// MARK: - Providable
public protocol AnalyticsProviable {
    var shouldAppendingAutomaticallyCollectedParamaters: Bool { get set }
    var shouldLoggingPopupViewEvent: Bool { get set }
    
    func setUserId(_ userId: String?)
    func setUserProperty(_ value: String?, for name: String)
    func setScreenName(_ screenName: String?, screenClass: String?)
    func log(event name: String, parameters: [String:Any]?)
    
    @available(watchOSApplicationExtension 6.2, *)
    func log(iap transaction: SKPaymentTransaction, product: SKProduct, receipt: String)
}

public extension AnalyticsProviable {
    var shouldAppendingAutomaticallyCollectedParamaters: Bool { true }
    var shouldLoggingPopupViewEvent: Bool { true }
    
    func setUserId(_ userId: String?) {}
    func setUserProperty(_ value: String?, for name: String) {}
    func setScreenName(_ screenName: String?, screenClass: String?) {}
    
    func log(event name: String, parameters: [String:Any]?) {
        log(event: name, parameters: parameters)
    }
    
    @available(watchOSApplicationExtension 6.2, *)
    func log(iap transaction: SKPaymentTransaction, product: SKProduct, receipt: String){}
}
