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
    
    // MARK: Private
    
    func addHideKeyboradGestureRecognizer() {
        let hideKeyboradGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboradGestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
}
