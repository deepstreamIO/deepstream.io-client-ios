//
//  Subscriber.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

final public class Subscriber {
    
    init() {
        let authData = ["username" : "Yasser"]
        
        let properties : [String : Int] = [
            "SUBSCRIPTION_TIMEOUT" : 500,
            "RECORD_READ_ACK_TIMEOUT" : 500,
            "RECORD_READ_TIMEOUT" : 500,
        ]
        
        guard let client = DSDeepstreamClient("0.0.0.0:6020", properties: properties.toProperties) else {
            print("Subscriber: Unable to initialize client")
            return
        }
        
        self.subscribeConnectionChanges(client: client)
        self.subscribeRuntimeErrors(client: client)
        
        guard let loginResult = client.login(authData.jsonElement) else {
            print("Subscriber: Failed to login")
            return
        }
        
        if (!loginResult.loggedIn()) {
            print("Subscriber: Failed to login \(loginResult.getErrorEvent())")
        } else {
            print("Subscriber: Login Success")
            self.subscribeEvent(client: client)
            self.makeSnapshot(client: client, recordName: "record/snapshot")
            self.hasRecord(client: client)
            self.subscribeRecord(client: client, recordName: "record/b")
            self.subscribeAnonymousRecord(client: client)
            self.subscribeList(client:client)
            self.makeRpc(client: client)
            self.subscribePresence(client: client)
            self.queryClients(client: client)
        }
    }
    
    private func hasRecord(client: DSDeepstreamClient) {
        guard let hasResult = client.record.has("record/has") else {
            print("Subscriber: Has did not work")
            return
        }
        
        print("Subscriber: Has result: \(hasResult)")
    }
    
    private func makeSnapshot(client: DSDeepstreamClient, recordName: String) {
        let snapshotResult = client.record.snapshot(recordName)!
        
        if (snapshotResult.hasError()) {
            print("Subscriber: Snapshot did not work because: \(snapshotResult.getError().getMessage())")
        } else {
            print("Subscriber: Snapshot result: \(snapshotResult)")
        }
    }
    
    private func makeRpc(client: DSDeepstreamClient) {
        DispatchQueue.main.async {
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                let data = [
                    floor(Double(arc4random()) * 10),
                    floor(Double(arc4random()) * 10)
                ]

                guard let rpcResponse = client.rpc.make("add-numbers", data: data.jsonElement) else {
                    print("RPC failed")
                    return
                }

                print("Subscriber: RPC success with data: \(rpcResponse.getData()!)")
            }
            RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            timer.fire()
        }
    }
    
    private func subscribeRuntimeErrors(client: DSDeepstreamClient) {
        client.setRuntimeErrorHandler(RuntimeErrorHandler())
    }
    
    private func subscribeConnectionChanges(client: DSDeepstreamClient) {
        client.addConnectionChange(AppConnectionStateListener())
    }
    
    private func subscribeAnonymousRecord(client: DSDeepstreamClient) {
        let _ = client.record.getAnonymousRecord()
    }
    
    private func subscribeList(client: DSDeepstreamClient) {
        guard let list = client.record.getList("list/a") else {
            print("Subscriber: Unable to get list: list/a")
            return
        }
        
        final class SubscribeListChangedListener : NSObject, DSListChangedListener {
            func onListChanged(_ listName: String!, entries: IOSObjectArray!) {
                print("Subscriber: List \(listName) entries changed to \(entries)")
            }
        }
        list.subscribe(SubscribeListChangedListener())
        
        final class SubscribeListEntryChangedListener : NSObject, DSListEntryChangedListener {
            func onEntryAdded(_ listName: String!, entry entry_: String!, position: jint) {
                print("Subscriber: List \(listName) entry \(entry_) added at \(position)")
            }
            
            func onEntryRemoved(_ listName: String!, entry entry_: String!, position: jint) {
                print("Subscriber: List \(listName) entry \(entry_) removed from \(position)")
            }
            
            func onEntryMoved(_ listName: String!, entry entry_: String!, position: jint) {
                print("Subscriber: List \(listName) entry \(entry_) move to \(position)")
            }
        }
        list.subscribe(toListEntryChange: SubscribeListEntryChangedListener())
    }
    
    private func subscribeRecord(client: DSDeepstreamClient, recordName: String) {
        guard let record = client.record.getRecord(recordName) else {
            print("Subscriber: Unable to get recordName \(recordName)")
            return
        }
        
        final class SubscribeRecordChangedCallback : NSObject, DSRecordChangedCallback {
            func onRecordChanged(_ recordName: String!, data: GSONJsonElement!) {
                print("Subscriber: Record '\(recordName!)' changed, data is now: \(data.dict)")
            }
        }
        
        record.subscribe(SubscribeRecordChangedCallback())
        print("Subscriber: Record '\(record.name()!)' initial state: \(record.get()!)")
    }
    
    private func subscribeEvent(client: DSDeepstreamClient) {
        
        final class SubscriberEventListener : NSObject, DSEventListener {
            func onEvent(_ eventName: String!, args: Any!) {
                guard let parameters = (args as? GSONJsonArray)?.array else {
                    print("Subscriber: Unable to cast args as JsonArray")
                    return
                }
                
                if (parameters.count < 2) {
                    print("Subscriber: Less than 2 parameters")
                    return
                }
                
                guard let first = parameters[0] as? String,
                    let second = parameters[0] as? Int64 else {
                    return
                }
                
                print("Subscriber: Event '\(eventName!)' occurred with: \(first) at \(second)")
            }
        }
        
        client.event.subscribe("event/a", eventListener: SubscriberEventListener())
    }
    
    private func subscribePresence(client: DSDeepstreamClient) {
        
        final class SubscriberPresenceEventListener : NSObject, DSPresenceEventListener {
            func onClientLogin(with username: String!) {
                print("Subscriber: \(username!) logged in")
            }
            
            func onClientLogout(with username: String!) {
                print("Subscriber: \(username!) logged out")
            }
        }
        
        client.presence.subscribe(SubscriberPresenceEventListener())
    }
    
    private func queryClients(client: DSDeepstreamClient) {
        guard let clients = client.presence.getAll() else {
            print("Subscriber: Unable to get all clients")
            return
        }
        
        print("Subscriber: Clients currently connected:")
        for i : Int32 in 0..<clients.length() {
            if let c = clients.object(at: UInt(i)) {
                print("\(c) ", terminator:"")
            }
        }
        print()
    }
}
