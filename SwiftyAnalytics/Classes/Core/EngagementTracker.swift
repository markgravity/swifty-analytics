//
//  EngagementTracker.swift
//  SwiftyAnalytics
//
//  Created by Mark G on 6/21/20.
//
#if os(iOS)
import UIKit
#else
import WatchKit
#endif

public class EngagementTracker {
    public static var didBecomeActiveNotification: Notification.Name {
        var name: Notification.Name!
        #if os(iOS)
        name = UIApplication.didBecomeActiveNotification
        #elseif os(watchOS)
        name = Notification.Name(rawValue: "WatchExtensionDidBecomeActive")
        #endif
        
        return name
    }
    
    public static var didEnterBackgroundNotification: Notification.Name {
        var name: Notification.Name!
        #if os(iOS)
        name = UIApplication.didEnterBackgroundNotification
        #elseif os(watchOS)
        name = Notification.Name(rawValue: "WatchExtensionDidEnterBackground")
        #endif
        
        return name
    }
    
    fileprivate var _trackeds = [String: [Tracked]]()
    fileprivate let _minimumTime: Int
    
    public init(minimum: Int = 1000) {
        _minimumTime = minimum
        _registerNotifications()
    }
    
    public func begin(for id: String, at date: Date = Date()) {
        _trackeds[id] = [.init(start: date, end: nil)]
    }
    
    public func end(for id: String) -> Int? {
        
        guard let trackeds = _trackeds[id] else { return nil }
        
        
        // Remove from tracked list
        _trackeds.removeValue(forKey: id)
        
        // Return engagement time
        var total = 0
        for tracked in trackeds {
            
            guard let end = tracked.end else {
                let time = Int(abs(tracked.start.timeIntervalSinceNow) * 1000)
                total += time >= _minimumTime ? time : 0
                break
            }
            
            let time = Int(abs(tracked.start.timeIntervalSince(end)) * 1000)
            total += time >= _minimumTime ? time : 0
        }
        
        guard total > 0 else { return nil }
        return total
    }
}

// MARK: - Engagement Tracker
fileprivate extension EngagementTracker {
    
    func _registerNotifications() {
        
        NotificationCenter.default.addObserver(forName: Self.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] _ in
            
            guard let `self` = self else { return }
            for (id, trackeds) in self._trackeds {
                
                // Append a tracker that begin from now,
                // with end is nil
                var trackeds = trackeds
                guard !trackeds.contains(where: { $0.end == nil })
                    else { continue }
                
                trackeds.append(.init(start: Date(), end: nil))
                
                self._trackeds[id] = trackeds
            }
        }
        
        NotificationCenter.default.addObserver(forName: Self.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] _ in
            
            guard let `self` = self else { return }
            for (id, trackeds) in self._trackeds {
                
                // Set end time for last tracker
                var trackeds = trackeds
                guard let index = trackeds.lastIndex(where: { $0.end == nil })
                    else { continue }
                var tracked = trackeds[index]
                tracked.end = Date()
                trackeds[index] = tracked
                
                self._trackeds[id] = trackeds
            }
        }
    }
}

fileprivate struct Tracked {
    let start: Date
    var end: Date?
}
