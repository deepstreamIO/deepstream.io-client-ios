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
            print("Publisher: Unable to initialize client")
            return
        }
        
        self.subscribeConnectionChanges(client: client)
        self.subscribeRuntimeErrors(client: client)
        
        guard let loginResult = client.login(with: authData) else {
            print("Publisher: Failed to login")
            return
        }
        
        if (!loginResult.loggedIn()) {
            print("Publisher: Provider Failed to login \(loginResult.getErrorEvent())")
        } else {
            print("Publisher: Provider Login Success")
            self.listenEvent(client: client)
            self.listenRecord(client: client)
            self.provideRpc(client: client)
        }
    }
    
    private func listenRecord(client: DeepstreamClient) {
        guard let record = client.record else {
            print("Publisher: No record")
            return
        }
        
        let handler = PublisherListenListener(handler: { (subscription, client) in
            self.updateRecord(subscription: subscription, client: client)
        }, client: client)
        
        record.listen("record/.*", listenCallback: handler)
    }
    
    private func updateRecord(subscription: String, client: DeepstreamClient) {
        guard let record = client.record?.getRecord(subscription) else {
            print("Publisher: Getting record for subscription '\(subscription)' failed")
            return
        }
        
        var count = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            let timeInterval : TimeInterval = Date().timeIntervalSince1970
            let data : JsonObject = JsonObject()
            data.addProperty(with: "timer", with: NSNumber(value: timeInterval))
            data.addProperty(with: "id", with: subscription)
            data.addProperty(with: "count", with: NSNumber(value: count))
            count += 1
            record.set(data)
        }
        timer.fire()
    }
    
    private func listenEvent(client: DeepstreamClient) {        
        client.event?.listen(with: "event/.*",
                             with: PublisherListenListener(handler: { (subscription, client) in
                                print("Publisher: Event \(subscription) just subscribed.")
                                self.publishEvent(subscription: subscription, client: client);
                             }, client: client))
    }
    
    private func publishEvent(subscription: String, client: DeepstreamClient) {
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            let timeInterval : TimeInterval = Date().timeIntervalSince1970
            let data : [Any] = ["An event just happened", timeInterval]
            client.event?.emit(with: subscription, withId: data.jsonElement)
        }
        timer.fire()
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
                                print("Publisher: Got an RPC request")
                                
                                guard let numbers = (data as? JsonArray)?.array as? [Double] else {
                                    print("Publisher: Unable to cast data to Array")
                                    return
                                }

                                if (numbers.count < 2) { return }
                                
                                let random = (Double(arc4random()) / Double(UInt32.max))
                                switch (random) {
                                case 0..<0.2:
                                    response.reject()
                                case 0..<0.7:
                                    let value = numbers[0] + numbers[1]
                                    response.send(value)
                                default:
                                    print("Publisher: This intentionally randomly failed")
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
