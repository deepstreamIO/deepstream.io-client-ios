//
//  Publisher.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

final public class Publisher {
    
    init() {
        let authData : JsonObject = JsonObject()
        authData.addProperty(with: "username", with: "Publisher")
        
        guard let client = DeepstreamClient("0.0.0.0:6020") else {
            print("Error: Unable to initialize client")
            return
        }
        
        self.subscribeConnectionChanges(client: client)
        self.subscribeRuntimeErrors(client: client)
        
        guard let loginResult = client.login(with: authData) else {
            print("Error: Failed to login")
            return
        }
        
        if (!loginResult.loggedIn()) {
            print("Provider Failed to login \(loginResult.getErrorEvent())")
        } else {
            print("Provider Login Success")
            self.listenEvent(client: client)
            self.listenRecord(client: client)
            self.provideRpc(client: client)
        }
    }
    
    private func listenRecord(client: DeepstreamClient) {
        guard let record = client.record else {
            print("No record")
            return
        }
        
        let handler = PublisherListener(handler: { (subscription, client) in
            self.updateRecord(subscription: subscription, client: client)
        }, client: client)
        
        record.listen("record/.*", listenCallback: handler)
    }
    
    private func updateRecord(subscription: String, client: DeepstreamClient) {
        guard let record = client.record?.getRecord(subscription) else {
            return
        }
        
        guard let data = JsonObject() else {
            return
        }
        
        var count = 0
        // TODO: Place inside loop
        //let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let timeInterval : TimeInterval = Date().timeIntervalSince1970
            data.addProperty(with: "timer", with: NSNumber(value: timeInterval))
            data.addProperty(with: "id", with: subscription)
            data.addProperty(with: "count", with: NSNumber(value: count))
            count += 1
            record.set(data)
        //}

        //timer.fire()
    }
    
    private func listenEvent(client: DeepstreamClient) {
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
        
        client.event?.listen(with: "event/.*",
                             with: PublisherListener(handler: { (subscription, client) in
                                print("Event \(subscription) just subscribed.")
                                self.publishEvent(subscription: subscription, client: client);
                             }, client: client))
    }
    
    private func publishEvent(subscription: String, client: DeepstreamClient) {
        // TODO: Place inside loop
        let timeInterval : TimeInterval = Date().timeIntervalSince1970
        let data : [Any] = ["An event just happened", timeInterval]
        
        client.event?.emit(with: subscription, withId: data)
    }

    private func provideRpc(client: DeepstreamClient) {
        typealias PublisherRpcRequestedListenerHandler = ((String, Any, RpcResponse) -> Void)
        
        final class PublisherRpcRequestedListener : NSObject, RpcRequestedListener {
            private var handler : PublisherRpcRequestedListenerHandler!
            
            init(handler: @escaping PublisherRpcRequestedListenerHandler) {
                self.handler = handler
            }
            
            func onRPCRequested(_ rpcName: String!, data: Any!, response: RpcResponse!) {
                self.handler(rpcName, data, response)
            }
        }
        
        client.rpc?.provide("add-numbers",
                            rpcRequestedListener: PublisherRpcRequestedListener { (rpcName, data, response) in
                                print("Got an RPC request")
                                
                                guard let numbers = data as? JsonArray else {
                                    print("Unable to cast data to JsonArray")
                                    return
                                }
                                
                                let first = numbers.getWith(0).getAsDouble()
                                let second = numbers.getWith(1).getAsDouble()
                                
                                let random = (Double(arc4random()) / Double(UInt32.max))
                                switch (random) {
                                case 0..<0.2:
                                    response.reject()
                                case 0..<0.7:
                                    let value = first + second
                                    response.send(value)
                                default:
                                    print("This intentionally randomly failed")
                                }
        })
    }
    
    private func subscribeRuntimeErrors(client: DeepstreamClient) {
        client.setRuntimeErrorHandler(RuntimeErrorHandler())
    }
    
    private func subscribeConnectionChanges(client: DeepstreamClient) {
        client.addConnectionChangeListener(with: AppConnectionStateListener())
    }
}
