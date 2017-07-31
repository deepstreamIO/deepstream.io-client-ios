//
//  PublishListenListener.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//
//

import Foundation

typealias PublisherListenListenerCallbackHandler = ((String, DSDeepstreamClient) -> Void)

final class PublisherListenListener: NSObject, DSListenListener {
    
    private var handler : PublisherListenListenerCallbackHandler!
    private var client : DSDeepstreamClient!
    
    init(handler: @escaping PublisherListenListenerCallbackHandler, client: DSDeepstreamClient) {
        self.handler = handler
        self.client = client
    }
    
    func onSubscription(forPatternAdded subscription: String!) -> jboolean {
        print("Publisher: Record \(subscription!) just subscribed")
        self.handler(subscription, self.client)
        return true
    }
    
    func onSubscription(forPatternRemoved subscription: String!) {
        print("Publisher: Record \(subscription!) just unsubscribed")
    }
}
