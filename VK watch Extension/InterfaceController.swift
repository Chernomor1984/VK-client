//
//  InterfaceController.swift
//  VK watch Extension
//
//  Created by Eugene Khizhnyak on 05.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import WatchConnectivity
import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    @IBOutlet weak var indicatorImage: WKInterfaceImage!
    
    private var session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // MARK: - Life cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session?.delegate = self
        session?.activate()
    }
    
    // MARK: - Private
    
    private func sendParentAppRequest() {
        if !(session?.isReachable)! {
            self.showConfirmationAlertController(title: "Parent app is unreachable", message: "Try again later")
            return
        }
        
        let replyHandler = { [weak self] (response: [String : Any]) in
            DispatchQueue.main.async {
                self?.indicatorImage.hideActivityIndicator()
            }
            print(response)
        }
        
        let errorHandler = { [weak self] (error: Error) in
            DispatchQueue.main.async {
                self?.indicatorImage.hideActivityIndicator()
                self?.showConfirmationAlertController(title: "Error!", message: error.localizedDescription)
            }
        }
        session?.sendMessage(["requestType" : "friendsListRequest"], replyHandler: replyHandler, errorHandler: errorHandler)
        indicatorImage.showActivityIndicator()
    }
    
    // MARK: - Private
    
    private func showConfirmationAlertController(title: String?, message: String?) {
        let okAction = WKAlertAction(title: "Ok", style: .cancel, handler: {})
        self.presentAlert(withTitle: title, message: message, preferredStyle: .alert, actions: [okAction])
    }
}

extension InterfaceController: WCSessionDelegate {
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated{
            self.sendParentAppRequest()
        } else {
            self.showConfirmationAlertController(title: "Parent app is unreachable", message: "Try again later")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage:\(message)")
    }
}
