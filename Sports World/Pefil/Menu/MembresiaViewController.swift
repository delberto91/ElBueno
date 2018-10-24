//
//  MembresiaViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 5/10/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
class MembresiaViewController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var user = SavedData.getTheName()
    var profileImageURL = SavedData.getTheProfilePic()
    var club = SavedData.getTheClub()
    var memberNumber = SavedData.getTheMemberNumber()
    /////////////////OUTLETS DE LA TARJETA DE FRENTE////////////
    
    @IBOutlet weak var card_front: UIImageView!
    @IBOutlet weak var viewToTouch: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var baseClub: UILabel!
    @IBOutlet weak var memberShipNumber: UILabel!
    @IBOutlet weak var bienvenidoLabel: UILabel!
    @IBOutlet weak var esfuerzateLabel: UIImageView!
    
    ///////////////////OUTLETS BOTONES///////////////////////
    @IBOutlet weak var pasesDeInvitadoButton: UIButton!
    @IBOutlet weak var beneficiosButton: UIButton!
    @IBOutlet weak var segurosButton: UIButton!
    
    
    var  isOpen = false
    
    //////////////////////OUTLESTS DE LA TARJETA DETRÁS///////////////
    @IBOutlet weak var qrImage: UIImageView!
    
    /////////OUTLETS DE LOS BOTONES///////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Mi credencial", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

        /////////VALIDACIONES SI LOS CAMPOS ESTÁN VACIOS//////
        if profileImageURL == nil {
            userImage.image = #imageLiteral(resourceName: "back_button")
        } else {
            userImage.downloadImage(downloadURL: "https://crm.sportsworld.com.mx/imagenes/personas/\(SavedData.getTheUserId()).jpg", completion: { result in
                
            
        })
        }
        if userName == nil {
            userName.text = ""
        } else {
           userName.text = user
        }
        if club == nil {
        baseClub.text = ""
        } else {
            baseClub.text = club
        }
        if memberNumber == nil {
            memberShipNumber.text = ""
        } else {
            let memberToString: String! = String(describing: SavedData.getTheMemberNumber())
            print("Aqui está el memberToString", memberToString)
            memberShipNumber.text! = memberToString
        }
////////////////////////CONFIGURA LAS LINEAS DE ARRIBA Y ABAJO DE LOS BOTONES////////
        pasesDeInvitadoButton.addTopBorderWithColor(pasesDeInvitadoButton, color: UIColor.white, width: 0.4)
        beneficiosButton.addTopBorderWithColor(beneficiosButton, color: UIColor.white, width: 0.4)
        
      
        
        beneficiosButton.addBottomBorderWithColor(beneficiosButton, color: UIColor.white, width: 0.4)
        segurosButton.addBottomBorderWithColor(segurosButton, color: UIColor.white, width: 0.4)
        
        
        bienvenidoLabel.isHidden = true
        esfuerzateLabel.isHidden = true
       // qrImage.isHidden = true
      //  isOpen = true
       // let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
      //  self.viewToTouch.addGestureRecognizer(gesture)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   /* @objc func checkAction(sender : UITapGestureRecognizer) {
        if isOpen{
            isOpen = false
            let image = UIImage(named: "credencial_front")
            card_front.image = image
            memberShipNumber.isHidden = false
            userName.isHidden = false
            userImage.isHidden = false
            baseClub.isHidden = false
            qrImage.isHidden = true
            bienvenidoLabel.isHidden = true
            esfuerzateLabel.isHidden = true
            pasesDeInvitadoButton.isHidden = false
            beneficiosButton.isHidden = false
            segurosButton.isHidden = false
            
            UIView.transition(with: card_front, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            isOpen = true
            let image = UIImage(named: "credencial_back")
            card_front.image = image
            userName.isHidden = true
            userImage.isHidden = true
            baseClub.isHidden = true
            qrImage.isHidden = false
            memberShipNumber.isHidden = true
            bienvenidoLabel.isHidden = false
            esfuerzateLabel.isHidden = false
            pasesDeInvitadoButton.isHidden = true
            beneficiosButton.isHidden = true
            segurosButton.isHidden = true
            UIView.transition(with: card_front, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }*/
    
    //MARK:- BOTONES ACCIONES
    @IBAction func clickPasesDeInvitadoButton(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "PasesDeInvitadoViewController") as! PasesDeInvitadoViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    @IBAction func clickSegurosButton(_ sender: Any) {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "SegurosViewController") as! SegurosViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    @IBAction func clickBeneficiosButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            self.getConvenios()
        }
        
    }
    
    func getConvenios() {
       APIManager.sharedInstance.logotipoConvenio = []
       APIManager.sharedInstance.nombreConvenio = []
       APIManager.sharedInstance.clausulasConvenio = []
        
        activity.isHidden = false
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        APIManager.sharedInstance.getConvenios(onSuccess: { json in
            DispatchQueue.main.async {
                if(json == JSON.null) {
                    Alert.ShowAlert(title: "", message: "Hubo un error, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                }
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
                    print("Success Request Getting Convenios")
                let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "BeneficiosViewController") as! BeneficiosViewController
                self.navigationController!.pushViewController(VC1, animated: true)
                
            }
            
        }, onFailure: { error in
            self.activity.isHidden = true
            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        })
    }
   
    
   
}
