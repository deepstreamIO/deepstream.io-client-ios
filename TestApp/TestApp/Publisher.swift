//
//  Publisher.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//
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
        
    }
    
    //private func updateRecord(subscription: String, client: DeepstreamClient, scheduledFuture: ScheduledFuture) {
    //
    //}
    
    private func listenEvent(client: DeepstreamClient) {
        
    }
    
    //private func publishEvent(subscription: String, client: DeepstreamClient, executorService: ScheduledExecutorService) {
    //
    // }

    private func provideRpc(client: DeepstreamClient) {
        
    }
    
    private func subscribeRuntimeErrors(client: DeepstreamClient) {
        
    }
    
    private func subscribeConnectionChanges(client: DeepstreamClient) {
        
    }
}
