//
//  LoginFormController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 12.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHideKeyboradGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonTapHandler(_ sender: UIButton) {
        let login = loginTextField!.text
        let password = passwordTextField!.text
        
        if login == "admin" && password == "admin" {
            print("авторизация успешна!")
        } else {
            print("данные неверны")
        }
    }
    
    // MARK: Private
    
    func addHideKeyboradGestureRecognizer() {
        let hideKeyboradGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboradGestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    // MARK: Notifications
    
    @objc func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        scrollView?.contentInset = contentInset;
        scrollView?.scrollIndicatorInsets = contentInset
    }
    
    @objc func KeyboardWillHide(notification: Notification) {
        scrollView?.contentInset = UIEdgeInsets.zero
        scrollView?.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
