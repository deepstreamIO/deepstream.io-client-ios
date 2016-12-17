//
//  PublisherListener.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//
//

import Foundation

final class PublisherListener: NSObject, ListenListener {
    // private var scheduledFuture :
    
    //init (scheduledFuture: ScheduledFuture) {
    // self.scheduledFuture = scheduledFuture
    //}
    
    func onSubscription(forPatternAdded subscription: String!) -> jboolean {
        print("Record \(subscription) just subscribed")
        //let executor =
        
        return true
    }
    
    func onSubscription(forPatternRemoved subscription: String!) {
        print("Record \(subscription) just unsubscribed.")
        // self.scheduledFuture[0].cancel(false)
    }
}
