//
//  ViewController.swift
//  DeepstreamIO
//
//  Created by Akram Hussein on 09/28/2016.
//  Copyright (c) 2016 Akram Hussein. All rights reserved.
//

import UIKit

typealias RecordSubscriptionCallbackHandler = ((recordName: String, path: String, data: JsonElement) -> Void)

class RecordSubscriptionCallback : NSObject, RecordPathChangedCallback {
    
    private var handler : RecordSubscriptionCallbackHandler!
    
    func onRecordPathChanged(recordName: String!, path: String!, data: JsonElement!) {
        print("\(recordName):\(path) = \(data)")
        self.handler(recordName: recordName, path: path, data: data)
    }
    
    init(handler: RecordSubscriptionCallbackHandler) {
        self.handler = handler
    }
}

class RuntimeErrorHandler : NSObject, DeepstreamRuntimeErrorHandler {
    func onException(topic: Topic!, event: Event!, errorMessage: String!) {
        print("Error: \(errorMessage) for topic:\(topic), event:\(event)")
    }
}

extension DeepstreamClient
{
    // Needed as J2ObjC does not translate properties
    // Required explicit getters/setters in Java
    var record : RecordHandler? {
        get {
            return self.valueForKey("record_") as? RecordHandler
        }
    }
}

final class ViewController: UIViewController {
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var textField: UITextField!
    
    // Deepstream
    
        var client : DeepstreamClient?
        var record : Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDeepstream()
    }
    
    func setupDeepstream() {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            // Setup Deepstream.io client 
            // NOTE: REPLACE HOST
            self.client = DeepstreamClient("138.68.154.77:6021")
            self.client?.setRuntimeErrorHandler(RuntimeErrorHandler())
            
            sleep(5)
            guard let client = self.client else {
                print("Error: Unable to init client")
                return
            }

            // Login

            let loginResult = client.login()

            if (loginResult.getErrorEvent() == nil) {
                print("Successfully logged in")
            } else {
                print("Error: Failed to log in...exiting")
                return
            }

            // Get record handler
            guard let record = client.record?.getRecord("some-name") else {
                return
            }

            self.record = record

            // Init UI against latest record state
            let currentRecordText = client.record?.getRecord("firstname").get().getAsString()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.textField.text = currentRecordText
            })

            // Subscribe to updates
            let callback = RecordSubscriptionCallback(handler: { (recordName, path, data) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let recordText = data.getAsString()
                    self.textField.text = recordText
                })
            })
            
            record.subscribe("firstname", recordPathChangedCallback: callback)
        })
    }
    
    @IBAction func editingChanged(sender: UITextField) {
        if let record = self.record {
            record.set("firstname", value: sender.text)
        }
    }
}