//
//  main.swift
//  TestApp
//
//  Created by Akram Hussein on 17/12/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import Foundation

DispatchQueue.main.async {
    let publisher = Publisher()
}

DispatchQueue.global().async {
    let subscriber = Subscriber()
}

RunLoop.main.run()
