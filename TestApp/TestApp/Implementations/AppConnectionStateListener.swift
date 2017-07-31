//
//  AppConnectionStateListener.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

final class AppConnectionStateListener : NSObject, DSConnectionStateListener {
    func connectionStateChanged(_ connectionState: DSConnectionState!) {
        print("Connection state changed \(connectionState!)")
    }
}
