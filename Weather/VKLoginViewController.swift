//
//  VKLoginViewController.swift
//  VK
//
//  Created by Eugene Khizhnyak on 30.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase

public let tokenKey = "tokenKey"
public let userIDKey = "userIDKey"

private let loginIdentifier = "loginIdentifier"

class VKLoginViewController: UIViewController {
    let vkAppID = "6202964"
    
    var loginWebView: WKWebView! {
        didSet {
            loginWebView.navigationDelegate = self
        }
    }
    
    private lazy var database: DatabaseReference = Database.database().reference()
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        loginWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = loginWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlRequest = RequestFactory.vkAuthRequest(clientID: vkAppID)
        loginWebView.load(urlRequest)
    }
    
    // MARK: - Private
    
    private func updateFirebaseWithUserID(userID: String?) {
        guard let userID = userID else {
            return
        }
        let data = ["userID" : userID]
        database.child("Users").updateChildValues(data) { (error, dbRef) in
            if let error = error {
                print("error occured:\(error.localizedDescription)")
                return
            }
            print("user id updated successfully!")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logout(unwindSegue: UIStoryboardSegue) {
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        let parameters = fragment
            .components(separatedBy: "&")
            .map {$0.components(separatedBy: "=")}
            .reduce([String: String]()) { result, param in
                var dictionary = result
                let key = param[0]
                let value = param[1]
                dictionary[key] = value
                return dictionary
        }
        
        if let token = parameters["access_token"], let userID = parameters["user_id"] {
            UserDefaults.standard.setValue(token, forKey: tokenKey)
            UserDefaults.standard.setValue(userID, forKey: userIDKey)
            updateFirebaseWithUserID(userID: userID)
        }
        decisionHandler(.cancel)
        self.performSegue(withIdentifier: loginIdentifier, sender: self)
    }
}
