//
//  RegistroExternosViewController.swift
//  Sports World
//
//  Created by Martin Rodriguez on 10/18/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class RegistroExternosViewController: UIViewController {

    @IBOutlet weak var spiner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.spiner.isHidden = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func cerrarClick(_ sender: Any) {
         self.dismiss(animated: true , completion: nil)
    }
    
    @IBOutlet weak var registro: UIButton!
    @IBAction func registroClick(_ sender: Any) {
        
        let registroData = RegistroRequest(nombre: nombreRegistroExterno, paterno: paternoRegistroExterno, materno: maternoRegistroExterno, fechaNacimiento: nacimientoRegistroExterno, email: correoRegistroExterno, telefono: telefonoExterno,password: contraseñaExterno)
        self.spiner.isHidden = false
        self.spiner.startAnimating()
        ExternosAPI.sharedInstance.registrar(registroRequest: registroData, completion: { responseData in
           
             DispatchQueue.main.async {
                self.spiner.stopAnimating()
                self.spiner.isHidden = true
                
                let controladorAlerta = UIAlertController(title: "Aceptar", message: responseData.message, preferredStyle: .alert)
                
                // Create the actions
                let boton = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    if(responseData.code != 200){
                        if let phoneCallURL = URL(string: "tel://018000079727") {
                            
                            let application:UIApplication = UIApplication.shared
                            if (application.canOpenURL(phoneCallURL)) {
                                application.open(phoneCallURL, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
                
                controladorAlerta.addAction(boton)
                // Present the controller
                self.present(controladorAlerta, animated: true, completion: nil)
            }
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
