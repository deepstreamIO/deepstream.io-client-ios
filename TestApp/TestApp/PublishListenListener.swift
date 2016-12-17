//
//  PublishListenListener.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//
//

import Foundation

typealias PublisherListenListenerCallbackHandler = ((String, DeepstreamClient) -> Void)

final class PublisherListenListener: NSObject, ListenListener {
    
    private var handler : PublisherListenListenerCallbackHandler!
    private var client : DeepstreamClient!
    
    init(handler: @escaping PublisherListenListenerCallbackHandler, client: DeepstreamClient) {
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
