//
//  RunTimeHandler.swift
//  DeepstreamIO
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

final class RuntimeErrorHandler : NSObject, DeepstreamRuntimeErrorHandler {
    func onException(_ topic: Topic!, event: Event!, errorMessage: String!) {
        if (errorMessage != nil && topic != nil && event != nil) {
            print("Error: \(errorMessage!) for topic: \(topic!), event: \(event!)")
        }
    }
}
