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
        let authData : JsonObject = JsonObject()
        authData.addProperty(with: "username", with: "Yasser")
        
        let properties : JavaUtilProperties = JavaUtilProperties()
        properties.put(withId: ConfigOptions_Enum.SUBSCRIPTION_TIMEOUT.string, withId: 500)
        properties.put(withId: ConfigOptions_Enum.RECORD_READ_ACK_TIMEOUT.string, withId: 500)
        properties.put(withId: ConfigOptions_Enum.RECORD_READ_TIMEOUT.string, withId: 500)
        
        guard let client = DeepstreamClient("0.0.0.0:6020", properties: properties) else {
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
            print("Failed to login \(loginResult.getErrorEvent())")
        } else {
            print("Login Success")
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
    
    private func hasRecord(client: DeepstreamClient) {
        guard let hasResult = client.record?.getRecord("record/has") else {
            print("Has did not work")
            return
        }
        
        print("Has result: \(hasResult)")
    }
    
    private func makeSnapshot(client: DeepstreamClient, recordName: String) {
        guard let snapshotResult : JsonElement = client.record?.snapshot(recordName) else {
            print("Snapshot did not work")
            return
        }
    
        print("Snapshot result: \(snapshotResult)")
    }
    
    private func makeRpc(client: DeepstreamClient) {
        // TODO: Place in loop

        let numbers : JavaUtilArrayList = JavaUtilArrayList(int: 2)
        numbers.add(with: 0, withId: floor(Double(arc4random()) * 10))
        numbers.add(with: 1, withId: floor(Double(arc4random()) * 10))
        
        guard let rpcResponse = client.rpc?.make("add-numbers", data: numbers) else {
            print("RPC failed")
            return
        }
        
        print("RPC success with data: \(rpcResponse.getData())")
    }
    
    private func subscribeRuntimeErrors(client: DeepstreamClient) {
        client.setRuntimeErrorHandler(RuntimeErrorHandler())
    }
    
    private func subscribeConnectionChanges(client: DeepstreamClient) {
        client.addConnectionChangeListener(with: AppConnectionStateListener())
    }
    
    private func subscribeAnonymousRecord(client: DeepstreamClient) {
        let _ = client.record?.getAnonymousRecord()
    }
    
    private func subscribeList(client: DeepstreamClient) {
        guard let list = client.record?.getList("list/a") else {
            print("Unable to get list: list/a")
            return
        }
        
        final class SubscribeListChangedListener : NSObject, ListChangedListener {
            func onListChanged(_ listName: String!, entries: JavaUtilListProtocol!) {
                print("List \(listName) entries changed to \(entries)")
            }
        }
        list.subscribe(SubscribeListChangedListener())
        
        final class SubscribeListEntryChangedListener : NSObject, ListEntryChangedListener {
            func onEntryAdded(_ listName: String!, entry entry_: String!, position: jint) {
                print("List \(listName) entry \(entry_) added at \(position)")
            }
            
            func onEntryRemoved(_ listName: String!, entry entry_: String!, position: jint) {
                print("List \(listName) entry \(entry_) removed from \(position)")
            }
            
            func onEntryMoved(_ listName: String!, entry entry_: String!, position: jint) {
                print("List \(listName) entry \(entry_) move to \(position)")
            }
        }
        list.subscribe(with: SubscribeListEntryChangedListener())
    }
    
    private func subscribeRecord(client: DeepstreamClient, recordName: String) {
        guard let record = client.record?.getRecord(recordName) else {
            print("Unable to get recordName \(recordName)")
            return
        }
        
        final class SubscribeRecordChangedCallback : NSObject, RecordChangedCallback {
            func onRecordChanged(_ recordName: String!, data: JsonElement!) {
                print("Record '\(recordName)' changed, data is now: \(data)")
            }
        }
        
        record.subscribe(SubscribeRecordChangedCallback())
        print("Record '\(record.name())' initial state: \(record.get())")
    }
    
    private func subscribeEvent(client: DeepstreamClient) {
        
        final class SubscriberEventListener : NSObject, EventListener {
            func onEvent(with eventName: String!, withId args: Any!) {
                guard let parameters = args as? JsonArray else {
                    print("Unable to cast args as JsonArray")
                    return
                }
                
                let first = parameters.getWith(0).getAsString()
                let second = parameters.getWith(1).getAsLong()
                
                print("Event '\(eventName!)' occurred with: \(first) at \(second)")
            }
        }
        
        client.event?.subscribe(with: "event/a", with: SubscriberEventListener())
    }
    
    private func subscribePresence(client: DeepstreamClient) {
        
        final class SubscriberPresenceEventListener : NSObject, PresenceEventListener {
            func onClientLogin(with username: String!) {
                print("\(username) logged in")
            }
            
            func onClientLogout(with username: String!) {
                print("\(username) logged out")
            }
        }
        
        client.presence?.subscribe(with: SubscriberPresenceEventListener())
    }
    
    private func queryClients(client: DeepstreamClient) {
        guard let clients = client.presence?.getAll() else {
            print("Unable to get all clients")
            return
        }
                
        print("Clients currently connected:")
        for c : String in clients.toNSArray() {
           print("\(c) ", terminator:"")
        }
        print()
    }
}
