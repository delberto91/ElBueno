//
//  RecoverPassTableViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/15/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
var emailForRecoverPassword = String()

class RecoverPassTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backView: UIView!
    
    var originalContainerFrame: CGRect?
    var currentTextField: UITextField?
    override func viewDidLoad() {
        
        backView.layer.cornerRadius = 8
        super.viewDidLoad()
        emailTextField.delegate = self 
        emailTextField.addBottomBorderWithColor(emailTextField, color: UIColor.red, width: 2.0)
        emailTextField.text = ""
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    //MARK:- TEXTFIELDS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        emailForRecoverPassword = emailTextField.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField?.resignFirstResponder()
        emailForRecoverPassword = emailTextField.text!
        print("Este es el valor de email for recovery", emailForRecoverPassword)
        textField.resignFirstResponder()
        currentTextField = nil
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == emailTextField) {
            
            
            currentTextField?.resignFirstResponder()
        }
        return true
    }
}
