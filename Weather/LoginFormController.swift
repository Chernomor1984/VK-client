//
//  LoginFormController.swift
//  Weather
//
//  Created by Eugene Khizhnyak on 12.09.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit

private let loginIdentifier = "loginIdentifier"

class LoginFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHideKeyboradGestureRecognizer()
    }
    // пофиксить баг со скроллом
    // добавить text field delegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func logout(unwindSegue: UIStoryboardSegue) {
        loginTextField.text! = ""
        passwordTextField.text! = ""
    }
    
    // MARK: - Private
    
    func addHideKeyboradGestureRecognizer() {
        let hideKeyboradGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboradGestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    func userDataIsValid() -> Bool {
        let login = loginTextField!.text
        let password = passwordTextField!.text
        return login == "admin" && password == "admin"
    }
    
    func showLoginErrorAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    
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
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == loginIdentifier {
            let dataIsValid = userDataIsValid()
            
            if !dataIsValid {
                showLoginErrorAlert()
            }
            return dataIsValid
        } else {
            return true
        }
    }
}
