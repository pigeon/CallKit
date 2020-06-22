//
//  ViewController.swift
//  CallUI
//
//  Created by Dmytro Golub on 21/06/2020.
//  Copyright © 2020 Dmytro Golub. All rights reserved.
//

import UIKit
import CallKit

class ViewController: UIViewController, CXProviderDelegate {
    
    let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "My App"))

    override func viewDidLoad() {
        super.viewDidLoad()
        provider.setDelegate(self, queue: nil)
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    @IBAction private func callDidInitialise(_ sender: Any) {
        let update = CXCallUpdate()
         //update.remoteHandle = CXHandle(type: .generic, value: /*"The Mad Hatter"*/)
        update.remoteHandle = CXHandle(type: .emailAddress, value: /*"The Mad Hatter"*/ "themadhatter@apple.com")
         provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })

    }
    
    @IBAction private func outgoingCallDidInitialise(_ sender: Any) {
        let controller = CXCallController()
        let transaction = CXTransaction(action: CXStartCallAction(call: UUID(), handle: CXHandle(type: .generic, value: "Alice")))
        controller.request(transaction, completion: { error in })
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 5) {
            self.provider.reportOutgoingCall(with: controller.callObserver.calls[0].uuid, connectedAt: nil)
        }
    }
}

