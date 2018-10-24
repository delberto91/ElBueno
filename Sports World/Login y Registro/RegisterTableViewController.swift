//
//  RegisterTableViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 10/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Foundation
//Creamos variables globales para acceder a ellas desde la clase RegisterViewController que es donde se va a hacer la petición.
var idClub = String()
var finalIdClub: String = ""
var typeInvited: String = ""
var emailRegister: String = ""
var memberRegister: String = ""
class RegisterTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //MARK: - OUTLETS
    var pickOption = ["Selecciona un tipo de usuario","Socio", "Invitado", "Empleado"]
    var allClubes = APIManager.sharedInstance.finalList.removeDuplicates()
    var allClubesIds = APIManager.sharedInstance.finalId.removeDuplicates()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var clubTextField: UITextField!
    @IBOutlet weak var memberTextField: UITextField!
    @IBOutlet weak var invitedType: UITextField!
    
    @IBOutlet weak var invitedTypeView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var memberTypeView: UIView!
    @IBOutlet weak var clubTypeView: UIView!
    
    //MARK: - VARIABLES
    var originalContainerFrame: CGRect?
    var currentTextField: UITextField?
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    var picker: UIPickerView!
    
    override func viewDidLoad() {
        
        invitedTypeView.layer.cornerRadius = 8
        emailView.layer.cornerRadius = 8
        memberTypeView.layer.cornerRadius = 8
        clubTypeView.layer.cornerRadius = 8
        
        
        super.viewDidLoad()
        //CONFIGURA ASPECTO DE LOS TEXTFIELDS.
        invitedTypeView.addBottomBorderWithColor(invitedTypeView, color: UIColor.red, width: 2.0)
        emailTextField.isHidden = true
        memberTextField.isHidden = true
        clubTextField.isHidden = true
        
        emailView.addBottomBorderWithColor(emailView, color: UIColor.red, width: 2.0)
        memberTypeView.addBottomBorderWithColor(memberTypeView, color: UIColor.red, width: 2.0)
        clubTypeView.addBottomBorderWithColor(clubTypeView, color: UIColor.red, width: 2.0)
        
        emailView.isHidden = true
        memberTypeView.isHidden = true
        clubTypeView.isHidden = true
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // get number of elements in each pickerview
        
        switch activeTextField {
        case 1:
            return pickOption.count
        case 2:
            return allClubes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        currentTextField?.delegate = self
        
        if currentTextField?.tag == 1 {
            return pickOption[row]
        } else if currentTextField?.tag == 2 {
            return allClubes[row]
        } else {
            pickerView.isHidden = true
            
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set currect active value based on picker view
        
        if currentTextField?.tag == 1 {
            activeValue = pickOption[row]
            currentTextField?.text = activeValue
            typeInvited = pickOption[row]
            print("Este es el pickOption", typeInvited)
        } else if currentTextField?.tag == 2 {
            activeValue = allClubes[row]
            currentTextField?.text = activeValue
            
            var idFinales = allClubesIds[row]
            finalIdClub = String(idFinales)
            
            
        } else {
            activeValue = ""
        }
    }
    
    
    func pickUpValue(textField: UITextField) {
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        
        //self.picker.backgroundColor = UIColor.white
        //self.picker.setValue(UIColor.red, forKey: "textColor")
        //atePicker.backgroundColor = UIColor.white
        
        
        textField.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1)
        toolBar.sizeToFit()
        //toolBar.backgroundColor = UIColor.clear
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Aceptar", style: .plain, target: self, action: #selector(RegisterTableViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(RegisterTableViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        doneButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.darkGray],
                                          for: .normal)
        
        cancelButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.darkGray],
                                            for: .normal)
    }
    
    
    @objc func doneClick() {
        currentTextField?.text = activeValue
        currentTextField?.resignFirstResponder()
    }
    // cancel
    @objc func cancelClick() {
        currentTextField?.resignFirstResponder()
    }
    
    
    // MARK: - TABLEVIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //MARK: - TEXFIELD
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        
        if currentTextField?.tag == 1 {
            activeTextField = 1
            currentTextField?.text = activeValue
            self.pickUpValue(textField: textField)
            
        } else if currentTextField?.tag == 2 {
            activeTextField = 2
            currentTextField?.text = activeValue
            self.pickUpValue(textField: textField)
        } else {
            
        }
        
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if invitedType.text == "Socio" {
            
            memberTextField.attributedPlaceholder = NSAttributedString(string: "Membresia", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            
            clubTypeView.isHidden = false
            emailView.isHidden = false
            memberTypeView.isHidden = false
            
            clubTextField.isHidden = false
            emailTextField.isHidden = false
            memberTextField.isHidden = false
            
            
            
            
            
            emailRegister = emailTextField.text!
            
            if clubTextField.text == nil {
                clubTextField.text = ""
                
            }
            if memberTextField.text == nil {
                memberTextField.text = ""
                
            } else {
                memberRegister = memberTextField.text!
                print("Aqui está el member register", memberRegister)
            }
            
        } else if invitedType.text == "Empleado" {
            
            
            clubTypeView.isHidden = true
            emailView.isHidden = false
            memberTypeView.isHidden = true
            
            clubTextField.isHidden = true
            emailTextField.isHidden = false
            memberTextField.isHidden = true
            emailRegister = emailTextField.text!
            
            if clubTextField.text == nil {
                clubTextField.text = ""
                idClub = clubTextField.text!
                
            }
            if memberTextField.text == nil {
                memberTextField.text = ""
                memberRegister = memberTextField.text!
            }
            
        }else if invitedType.text == "Invitado"{
            memberTextField.attributedPlaceholder = NSAttributedString(string: "id Invitado", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            
            emailRegister = emailTextField.text!
            
            
            clubTypeView.isHidden = true
            emailView.isHidden = false
            memberTypeView.isHidden = false
            
            clubTextField.isHidden = true
            emailTextField.isHidden = false
            memberTextField.isHidden = false
            
            if clubTextField.text == nil {
                clubTextField.text = ""
                idClub = clubTextField.text!
                
            }
            if memberTextField.text == nil {
                
                memberTextField.text = ""
                
            } else {
                memberRegister = memberTextField.text!
            }
            
        }
        
        currentTextField?.resignFirstResponder()
        textField.resignFirstResponder()
        currentTextField = nil
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == invitedType) {
            if textField.text == "Socio" {
                print("Es socio")
                
                clubTypeView.isHidden = false
                emailView.isHidden = false
                memberTypeView.isHidden = false
                
                clubTextField.isHidden = false
                emailTextField.isHidden = false
                memberTextField.isHidden = false
                
            } else if textField.text == "Invitado" {
                print("Es invitado")
                
                clubTypeView.isHidden = true
                emailView.isHidden = false
                memberTypeView.isHidden = false
                
                clubTextField.isHidden = true
                emailTextField.isHidden = false
                memberTextField.isHidden = false
                
            } else if textField.text == "Empleado" {
                print("Es empleado")
                
                
                clubTypeView.isHidden = true
                emailView.isHidden = false
                memberTypeView.isHidden = true 
                
                clubTextField.isHidden = true
                emailTextField.isHidden = false
                memberTextField.isHidden = true
                
            }
            emailTextField.becomeFirstResponder()
        }else if(textField == emailTextField) {
            
            emailRegister = emailTextField.text ?? ""
            
            memberTextField.becomeFirstResponder()
        }else if(textField == memberTextField) {
            memberRegister = memberTextField.text ?? ""
            if invitedType.text == "Invitado" {
                currentTextField?.resignFirstResponder()
            } else {
                
            }
            if invitedType.text == "Empleado" {
                currentTextField?.resignFirstResponder()
            }
        }else if (textField == clubTextField) {
            invitedType.becomeFirstResponder()
            
        }
        invitedType?.resignFirstResponder()
        return true
    }
}

