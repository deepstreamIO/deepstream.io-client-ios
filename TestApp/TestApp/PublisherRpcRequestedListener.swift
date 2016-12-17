//
//  PublisherRpcRequestedListener.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//
//

import Foundation

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
