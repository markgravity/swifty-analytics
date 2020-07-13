//
//  AnalyticsEventable.swift
//  SwiftyAnalytics
//
//  Created by Mark G on 3/25/20.
//

// MARK: - Eventable
public protocol AnalyticsEventable {
    func name() -> String
    func parameters(_ provider: AnalyticsProviable) -> [String:Any]?
    func providers() -> [AnalyticsProviable.Type]?
}
