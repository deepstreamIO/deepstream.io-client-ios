//
//  RunTimeHandler.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

final class RuntimeErrorHandler : NSObject, DeepstreamRuntimeErrorHandler {
    func onException(_ topic: Topic!, event: Event!, errorMessage: String!) {
        print("Error: \(errorMessage!) for topic: \(topic!), event: \(event!)")
    }
}
