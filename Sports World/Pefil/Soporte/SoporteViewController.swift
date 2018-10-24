//
//  SoporteViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/18/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import MessageUI
class SoporteViewController: UIViewController, MFMailComposeViewControllerDelegate {
 
    

    
    //MARK:- OUTLETS
    @IBOutlet weak var tabView: UITableView!
    
    //MARK:- VARIABLES.
    var phoneNumber = "018000079727"
    var arrayOfQuestions = ["pregunta"]
    var cell = "SoporteTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
      
    
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Soporte técnico", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
    }
    @IBAction func sendemail(_ sender: Any) {
        self.sendEmail()
    }
    
    @IBAction func callCenter(_ sender: Any) {
        self.goToThePhone()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
 
        
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        
    }
 
    
    //MARK:- MÉTODOS
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
            Alert.ShowAlert(title: "", message: "Los servicios de correo no están disponibles.", titleForTheAction: "Aceptar", in: self)
            
        } else {
            let BarButtonItemAppearance = UIBarButtonItem.appearance()
            BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], for: .normal)
            
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
        
        
       // let BarButtonItemAppearance = UIBarButtonItem.appearance()
        //BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], for: .normal)
    }
    
    func goToThePhone() {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    //MAK:- DATASOURCE DE LA TABLA
  
    
  

}
