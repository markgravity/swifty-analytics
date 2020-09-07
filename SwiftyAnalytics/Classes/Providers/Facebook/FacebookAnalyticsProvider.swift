//
//  FacebookAnalyticsProvider.swift
//  FirebaseCore
//
//  Created by Mark G on 3/25/20.
//

import FBSDKCoreKit
import UIKit

public class FacebookAnalyticsProvider: AnalyticsProviable {
    
    public init() {}
    public func setUserId(_ userId: String?) {
        AppEvents.userID = userId
    }
    
    public func setUserProperty(_ value: String?, for name: String) {

    }
    
    public func setScreenName(_ screenName: String?, screenClass: String?) {
        
    }
    
    public func log(event name: String, parameters: [String:Any]?) {
        let event = AppEvents.Name(rawValue: name)
        guard let parameters = parameters else {
            AppEvents.logEvent(event)
            return
        }
        
        AppEvents.logEvent(event, parameters: parameters)
    }
    
//    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//
//    public func applicationDidBecomeActive(_ application: UIApplication) {
//        AppEvents.activateApp()
//    }
//
//
//    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
//        return handled
//    }
}
