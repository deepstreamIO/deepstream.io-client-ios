//
//  ViewController.swift
//  DeepstreamIO
//
//  Created by Akram Hussein on 09/28/2016.
//  Copyright (c) 2016 deepstreamHub GmbH. All rights reserved.
//

import UIKit

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
        DispatchQueue.global().async {

            // Setup Deepstream.io client

            // NOTE: REPLACE HOST
            let DeepstreamHubURL = "127.0.0.1:6020"

            guard let client = IOSDeepstreamFactory.getInstance().getClient(url: DeepstreamHubURL) else {
                print("Unable to initialize client")
                return
            }
            self.client = client
            self.client?.setRuntimeErrorHandler(RuntimeErrorHandler())

            sleep(5)

            // Login
            guard let loginResult = client.login() else{
                print("Unable to get login result")
                return
            }

            if (loginResult.getErrorEvent() == nil) {
                print("Successfully logged in")
            } else {
                print("Error: Failed to log in...exiting")
                return
            }

            // Get record handler
            guard let record = client.record.getRecord("some-name") else {
                return
            }

            self.record = record

            // Init UI against latest record state

            if let currentRecord = self.record?.get("firstname"), currentRecord != JsonNull() {
                DispatchQueue.main.async {
                    self.textField.text = currentRecord.getAsString()
                }
            }

            // Subscribe to updates

            // Convenience typealias
            typealias RecordSubscriptionCallbackHandler = ((String, String, JsonElement) -> Void)

            // Declare inner class - an implementation of interface
            final class RecordSubscriptionCallback : NSObject, RecordPathChangedCallback {

                private var handler : RecordSubscriptionCallbackHandler!

                func onRecordPathChanged(_ recordName: String!, path: String!, data: JsonElement!) {
                    print("\(recordName):\(path) = \(data)")
                    self.handler(recordName, path, data)
                }

                init(handler: @escaping RecordSubscriptionCallbackHandler) {
                    self.handler = handler
                }
            }

            let callback = RecordSubscriptionCallback(handler: { (recordName, path, data) -> Void in
                DispatchQueue.main.async {
                    if( data.getAsJsonPrimitive().isString() ) {
                        let recordText = data.getAsString()
                        self.textField.text = recordText
                    }
                }
            })

            record.subscribe("firstname", recordPathChangedCallback: callback)
        }
    }

    @IBAction func editingChanged(_ sender: UITextField) {
        if let record = self.record {
            record.set("firstname", value: sender.text)
        }
    }
}
