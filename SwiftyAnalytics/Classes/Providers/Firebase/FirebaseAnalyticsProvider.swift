//
//  FirebaseAnalyticsProvider.swift
//  SwiftyAnalytics
//
//  Created by Mark G on 3/25/20.
//

import FirebaseCore
import FirebaseAnalytics

public class FirebaseAnalyticsProvider: AnalyticsProviable {

    public var shouldAppendingAutomaticallyCollectedParamaters: Bool = true
    public var shouldLoggingPopupViewEvent: Bool = true
    
    public init(options: FirebaseOptions? = nil) {
        
        guard FirebaseApp.app() == nil else { return }
        guard let options = options else {
            FirebaseApp.configure()
            return
        }
        FirebaseApp.configure(options: options)
    }

    public func setUserId(_ userId: String?) {
        FirebaseAnalytics.Analytics.setUserID(userId)
    }

    public func setUserProperty(_ value: String?, for name: String) {
        FirebaseAnalytics.Analytics.setUserProperty(value, forName: name)
    }

    public func setScreenName(_ screenName: String?, screenClass: String?) {
        FirebaseAnalytics.Analytics.setScreenName(screenName, screenClass: screenClass)
    }

    public func log(event name: String, parameters: [String:Any]?) {
        FirebaseAnalytics.Analytics.logEvent(name, parameters: parameters)
    }
}
