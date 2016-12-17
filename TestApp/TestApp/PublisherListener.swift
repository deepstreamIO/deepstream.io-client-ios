//
//  PublisherListener.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

typealias PublisherListenerCallbackHandler = ((String, DeepstreamClient) -> Void)

final class PublisherListener: NSObject, ListenListener {
    
    private var handler : PublisherListenerCallbackHandler!
    private var client : DeepstreamClient!
    
    init(handler: @escaping PublisherListenerCallbackHandler, client: DeepstreamClient) {
        self.handler = handler
        self.client = client
    }
    
    func onSubscription(forPatternAdded subscription: String!) -> jboolean {
        print("Record \(subscription!) just subscribed")
        self.handler(subscription, self.client)
        return true
    }
    
    func onSubscription(forPatternRemoved subscription: String!) {
        print("Record \(subscription!) just unsubscribed")
    }
}
