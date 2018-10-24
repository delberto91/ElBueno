//
//  RegisterViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 10/01/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
class RegisterViewController: UIViewController {

    @IBOutlet weak var guardarButton: UIButton!
    @IBOutlet weak var registrarButton: UIButton!
    @IBOutlet weak var cancelarButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var phoneNumber = "018000079727"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrarButton.layer.cornerRadius = 8 
        cancelarButton.layer.cornerRadius = 8
        activityIndicator.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //MARK:- BUTTONS
    @IBAction func clickBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
      
    }
    
    @IBAction func clickRegistrarButton(_ sender: Any) {
        if typeInvited == "" {
            Alert.ShowAlert(title: "", message: "Debes seleccionar un tipo de usuario para continuar", titleForTheAction: "Aceptar", in: self)
        } else {
            
        if Reachability.isConnectedToNetwork() {
            registerUser()
            
        } else {
            Alert.ShowAlert(title: "", message: "No cuentas con internet, verifica tu conexión o intenta mas tarde.", titleForTheAction: "ACEPTAR", in: self)
        }
        
    }
    }
    func registerUser() {
    
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        APIManager.sharedInstance.register(email: emailRegister, tipo: typeInvited, club: finalIdClub, membresia: memberRegister, id: memberRegister, onSuccess: {json in
            DispatchQueue.main.async {
                
                
            if APIManager.sharedInstance.codeMessage >= 400 {
                if (json == JSON.null) {
                    Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde", titleForTheAction: "Aceptar", in: self)
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                let alertController = UIAlertController(title: "Aceptar", message: APIManager.sharedInstance.message, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                  self.goToThePhone()
                }
               
                alertController.addAction(okAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }else if APIManager.sharedInstance.codeMessage == 200 {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                let alertController = UIAlertController(title: "", message: APIManager.sharedInstance.message, preferredStyle: .alert)
                
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                        self.returnToLogin()
                }
                // Add the actions
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
          }
           
        }, onFailure: { error in
            DispatchQueue.main.async {
               
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.show(alert, sender: nil)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
   
        })
    }
    
    func goToThePhone() {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }

    }
    

    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func returnToLogin() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
       self.dismiss(animated: true , completion: nil)

    }
}
