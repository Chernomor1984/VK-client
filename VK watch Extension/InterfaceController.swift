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
    
    var news = [WatchAppNews]()
    
    private var session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // MARK: - Life cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session?.delegate = self
        session?.activate()
    }
    
    // MARK: - Public
    
    func updateTable() {
        tableView.setNumberOfRows(news.count, withRowType: "news")
        
        for (index, news) in news.enumerated(){
            if let row = tableView.rowController(at: index) as? NewsRow {
                row.text.setText(news.text)
            }
        }
    }
    
    // MARK: - Private
    
    private func handleResponse(response: [String : Any]) {
        if let response = response["newsListReply"] as? [[String : String]] {
            news = response.flatMap{ singleNews in
                let news = WatchAppNews()
                
                if let stringURL = singleNews.keys.first {
                    news.url = URL(string: stringURL)
                }
                
                if let text = singleNews.values.first {
                    news.text = text
                }
                return news
            }
            DispatchQueue.main.async {
                self.updateTable()
            }
        }
    }
    
    private func sendParentAppRequest() {
        if !(session?.isReachable)! {
            self.showErrorAlertController(title: "Parent app is unreachable", message: "Try again later")
            return
        }
        
        let replyHandler = { [weak self] (response: [String : Any]) in
            DispatchQueue.main.async {
                self?.indicatorImage.hideActivityIndicator()
                self?.handleResponse(response: response)
            }
        }
        
        let errorHandler = { [weak self] (error: Error) in
            DispatchQueue.main.async {
                self?.indicatorImage.hideActivityIndicator()
                self?.showErrorAlertController(title: "Error!", message: error.localizedDescription)
            }
        }
        session?.sendMessage(["requestType" : "newsListRequest"], replyHandler: replyHandler, errorHandler: errorHandler)
        indicatorImage.showActivityIndicator()
    }
    
    private func showErrorAlertController(title: String?, message: String?) {
        let closeAction = WKAlertAction(title: "Close", style: .cancel, handler: {})
        let sendAction = WKAlertAction(title: "Try again", style: .cancel, handler: {
            self.sendParentAppRequest()
        })
        self.presentAlert(withTitle: title, message: message, preferredStyle: .alert, actions: [closeAction, sendAction])
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated{
            self.sendParentAppRequest()
        } else {
            self.showErrorAlertController(title: "Parent app is unreachable", message: "Try again later")
        }
    }
}
