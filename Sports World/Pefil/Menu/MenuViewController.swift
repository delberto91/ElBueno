//
//  MenuViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 27/12/17.
//  Copyright © 2017 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import WatchKit
import MessageUI

var codeForInbody: Int = 0

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var viewToShow: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var programaLabel: UILabel!
    
    //var profileImageURL = APIManager.sharedInstance.profileImage
    var profileName = SavedData.getTheName()
    var nombres = APIManager.sharedInstance.nombreConvenio
    var menuActividad : MenuActividad = MenuActividad()
    var phoneNumber = "018000079727"
    //var menuActividadResponse: [MenuActividad] = [MenuActividad]()
    //////////CONECTA LOS OUTLETS DEL BOTÓN DEL MENÚ//////////
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        APIManager.sharedInstance.getMenuActividad(onSuccess: {response in
            DispatchQueue.main.async {
                
                var code  = response.code
                
                codeForInbody = code
                
                self.nivelLabel.text = String(APIManager.sharedInstance.nivel)
                self.programaLabel.text = APIManager.sharedInstance.rutina
                
                
            }
            
        })
        if APIManager.sharedInstance.profileImage == "vacio"  {
            let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
            profileImage.image = UIImage(data: data as Data)
            
            
        } else  {
            self.profileImage.downloadImage(downloadURL: SavedData.getTheProfilePic(), completion: { result in
                
            })
            
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let settings    = UIImage(named: "settings_icon")!
        let soporte  = UIImage(named: "soporte")!
        
        let editButton   = UIBarButtonItem(image: settings,  style: .plain, target: self, action: #selector(MenuViewController.clickConfig))
        let searchButton = UIBarButtonItem(image: soporte,  style: .plain, target: self, action: #selector(MenuViewController.selectOption))
        
        navigationItem.rightBarButtonItems = [editButton, searchButton]; APIManager.sharedInstance.getMenuActividad(onSuccess: {response in
            DispatchQueue.main.async {
               
                var code  = response.code
                
                 codeForInbody = code
                
                
                
                
                self.nivelLabel.text = String(APIManager.sharedInstance.nivel)
                self.programaLabel.text = APIManager.sharedInstance.rutina
              
                
                
            }
            
        })
        
        APIManager.sharedInstance.getLastInbody(onSuccess: { json in
            
        })
        
        
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Mi perfil", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
//        profileImage.frame = CGRect(x: self.view.frame.width / 2 - 45, y: userName.frame.origin.y + userName.bounds.height, width: 90, height: 90)
        var nombres = APIManager.sharedInstance.nombreConvenio
        viewToShow.isHidden = false
        var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
     /*   if profileImageURL == "" {
            profileImage.image = #imageLiteral(resourceName: "logo_forgot_password")
        } else {
            DispatchQueue.main.async {
                self.profileImage.downloadImage(downloadURL:SavedData.getTheProfilePic(), completion: { result in
                    
                })
            }
          
        }*/
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        
        
        
        
        //  getThePendingCharges()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //profileImage.layer.cornerRadius = 100
        

        if userName == nil {
            userName.text = "No disponilbe"
        } else {
            userName.text = profileName
        }
        
        
        
        
    }
    

    
    @IBAction func clickConfiguracionButton(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ConfiguracionViewController") as! ConfiguracionViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    @objc func clickConfig() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ConfiguracionViewController") as! ConfiguracionViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
   
    
   

    func getThePendingCharges(){
        APIManager.sharedInstance.getPendingCharges(onSuccess: { json in
            DispatchQueue.main.async {
                   
            
                if APIManager.sharedInstance.status == true {
                    
                    print("Success Request GetCharges")
                }
            }
            
        }, onFailure: { error in
            
        })
    }
    //Configura la alerta.
   @objc func selectOption() {
    
    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "SoporteViewController") as! SoporteViewController
    self.navigationController!.pushViewController(VC1, animated: true)
       /* let myAlert = UIAlertController(title: "Selecciona una opción.", message: "", preferredStyle: .actionSheet)
        
        let sendMail = UIAlertAction(title: "Envíar Correo", style: UIAlertActionStyle.default) {
            UIAlertAction in
       
            self.sendEmail()
        }
        let call = UIAlertAction(title: "Llamar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.goToThePhone()
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        myAlert.addAction(cancelButton)
        myAlert.addAction(sendMail)
        myAlert.addAction(call)
    
    let BarButtonItemAppearance = UIBarButtonItem.appearance()
    BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: .normal)
    
        self.present(myAlert, animated: true , completion: nil)*/
    }
    
    //ENVIA e-mail
    
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
           Alert.ShowAlert(title: "", message: "Los servicios de correo no están disponibles.", titleForTheAction: "Aceptar", in: self)
           
        } else {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([])
            mailVC.setSubject("Soporte Sports World \(SavedData.getTheMemberNumber())")
            mailVC.setMessageBody("\(SavedData.getTheName()) membresia: \(SavedData.getTheMemberNumber())", isHTML: false)
            mailVC.setToRecipients(["recipient@example.com"])
            
            self.present(mailVC, animated: true, completion: nil)
        }
      
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
