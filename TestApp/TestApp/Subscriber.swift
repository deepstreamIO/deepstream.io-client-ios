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
        
        // TODO: Config Properties
        let config : [String : Int] = [
            ConfigOptions_Enum.SUBSCRIPTION_TIMEOUT.string : 500,
            ConfigOptions_Enum.RECORD_READ_ACK_TIMEOUT.string : 500,
            ConfigOptions_Enum.RECORD_READ_TIMEOUT.string : 500
        ]
        
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
        
    }
    
    private func makeSnapshot(client: DeepstreamClient, recordName: String) {
        
    }
    
    private func makeRpc(client: DeepstreamClient) {
        
    }
    
    private func subscribeRuntimeErrors(client: DeepstreamClient) {
        
    }
    
    private func subscribeConnectionChanges(client: DeepstreamClient) {
    
    }
    
    private func subscribeAnonymousRecord(client: DeepstreamClient) {
        
    }
    
    private func subscribeList(client: DeepstreamClient) {
        
    }
    
    private func subscribeRecord(client: DeepstreamClient, recordName: String) {
        
    }
    
    private func subscribeEvent(client: DeepstreamClient) {
        
    }
    
    private func subscribePresence(client: DeepstreamClient) {
        
    }
    
    private func queryClients(client: DeepstreamClient) {
        
    }
}
