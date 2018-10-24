//
//  LoginTableViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 26/12/17.
//  Copyright © 2017 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Foundation
import CryptoSwift

var passwordLogin: String!
var userLogin: String!

class LoginTableViewController: UITableViewController, UITextFieldDelegate{
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userGrayView: UIView!
    @IBOutlet weak var passwordGrayView: UIView!
    var originalContainerFrame: CGRect?
    var currentTextField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userGrayView.layer.cornerRadius = 8
        self.passwordGrayView.layer.cornerRadius = 8
       self.userTextField.autocorrectionType = .no
        self.passwordTextField.autocorrectionType = .no
         userGrayView.addBottomBorderWithColor(userGrayView, color: UIColor.red, width: 2.0)
        self.passwordGrayView.addBottomBorderWithColor(passwordGrayView, color: UIColor.red, width: 2.0)
        userLogin = ""
        passwordLogin = ""
     
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - TEXTEFIELD
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      

        /*Cambio el día 2 de octubre del 2018*/
        
        currentTextField = textField
        userLogin = self.userTextField.text!
        passwordLogin = self.passwordTextField.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField?.resignFirstResponder()
        textField.resignFirstResponder()
        currentTextField = nil
        
        userLogin = self.userTextField.text!
        passwordLogin = self.passwordTextField.text!
   
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.userTextField) {
            passwordTextField.becomeFirstResponder()
        }else if(textField == self.passwordTextField) {
            currentTextField?.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    

}
