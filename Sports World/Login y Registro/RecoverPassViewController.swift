//
//  RecoverPassViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/15/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
class RecoverPassViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var cancelarButton: UIButton!
    @IBOutlet weak var recuperarButton: UIButton!
     var phoneNumber = "018000079727"
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true 
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RecoverPassViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        cancelarButton.layer.cornerRadius = 8
        recuperarButton.layer.cornerRadius = 8 
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func clickBackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func recoverPasseword() {
        activity.isHidden = false
        activity.startAnimating()
        view.isUserInteractionEnabled = false
        APIManager.sharedInstance.recoverPassword(email: emailForRecoverPassword, onSuccess: { json in
            DispatchQueue.main .async {
                if (json == JSON.null) {
                    Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                } else {
                print("Esto es lo que se va", emailForRecoverPassword)
                if APIManager.sharedInstance.codeMessage == 200 {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
               
                    let alertController = UIAlertController(title: "Aceptar", message: APIManager.sharedInstance.message, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let alertController = UIAlertController(title: "Aceptar", message: APIManager.sharedInstance.message, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                        self.goToThePhone()
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                }
            }
            
        }, onFailure: { error in
            self.activity.isHidden = true
            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "Aceptar", in: self)
        })
    }
    @IBAction func clickRecuperarButton(_ sender: Any) {
        if emailForRecoverPassword != "" {

        if Reachability.isConnectedToNetwork() {
            recoverPasseword()
        } else {
            Alert.ShowAlert(title: "", message: "No cuentas con internet, verifica tu conexión o intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
        }
            
        } else {
            Alert.ShowAlert(title: "", message: "Favor de verificar tus datos.", titleForTheAction: "Aceptar", in: self)
        }

}
    func goToThePhone() {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }

}
