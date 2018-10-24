//
//  EnviaPaseViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
class EnviaPaseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
      var currentTextField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
///////////////////////////////////EN ESTA PARTE DEBEMOS ASIGNARLE A LOS TEXTFIELDS UN STRING VACIO POR EJEMPLO nombreTextField.text = "" Esto es para que si se presiona el botón de enviar sin datos no afecte y no truene y si vaya como un string vacio en lugar de nulo///////////////////
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EnviaPaseViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        nombreTextField.layer.cornerRadius = 10
        correoTextField.layer.cornerRadius = 10
        enviarButton.layer.cornerRadius = 10
        nombreTextField.text = ""
        correoTextField.text = "" 
        activity.isHidden = true 
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
  
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField?.resignFirstResponder()
        textField.resignFirstResponder()
        currentTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nombreTextField) {
            correoTextField.becomeFirstResponder()
        }else if(textField == correoTextField) {
            currentTextField?.resignFirstResponder()
        }
        return true
    }
    @IBAction func clickEnviarButton(_ sender: Any) {
        
        self.sendPaseInvitado()
    }
    func sendPaseInvitado() {
        self.activity.startAnimating()
        self.activity.isHidden = false 
        self.view.isUserInteractionEnabled = false
        APIManager.sharedInstance.enviarPasesInvitado(to: correoTextField.text!, nameto: nombreTextField.text!,onSuccess: { json in
            DispatchQueue.main .async {
                if (json == JSON.null) {
                    Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                } else {
                if APIManager.sharedInstance.codeMessage == 200 {
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    let alertController = UIAlertController(title: "", message: APIManager.sharedInstance.message, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else if APIManager.sharedInstance.codeMessage >= 400 {
                    
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "Aceptar", in: self)
                }
                }
            }
        }, onFailure: { error in
            print("Error en hacer este login")
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.view.isUserInteractionEnabled = true
            Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "Aceptar", in: self)
            self.activity.isHidden = true
        })
    }
}
