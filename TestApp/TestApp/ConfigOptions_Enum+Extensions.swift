//
//  ConfigOptions+Extensions.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

extension ConfigOptions_Enum {
    var string : String {
        get {
            switch (self) {
            case .PATH:
                return "PATH"
            case .ENDPOINT_TYPE:
                return "ENDPOINT_TYPE"
            case .RECONNECT_INTERVAL_INCREMENT:
                return "RECONNECT_INTERVAL_INCREMENT"
            case .MAX_RECONNECT_INTERVAL:
                return "MAX_RECONNECT_INTERVAL"
            case .MAX_RECONNECT_ATTEMPTS:
                return "MAX_RECONNECT_ATTEMPTS"
            case .RPC_ACK_TIMEOUT:
                return "RPC_ACK_TIMEOUT"
            case .RPC_RESPONSE_TIMEOUT:
                return "RPC_RESPONSE_TIMEOUT"
            case .SUBSCRIPTION_TIMEOUT:
                return "SUBSCRIPTION_TIMEOUT"
            case .MAX_MESSAGES_PER_PACKET:
                return "MAX_MESSAGES_PER_PACKET"
            case .TIME_BETWEEN_SENDING_QUEUED_PACKAGES:
                return "TIME_BETWEEN_SENDING_QUEUED_PACKAGES"
            case .RECORD_READ_ACK_TIMEOUT:
                return "RECORD_READ_ACK_TIMEOUT"
            case .RECORD_READ_TIMEOUT:
                return "RECORD_READ_TIMEOUT"
            case .RECORD_DELETE_TIMEOUT:
                return "RECORD_DELETE_TIMEOUT"
            }
        }
    }
}
