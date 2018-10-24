//
//  ConfiguracionTableViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 5/25/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import UserNotifications
var height: Double?
var weight : Double?
var age: Int?
class ConfiguracionTableViewController: UITableViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var membershipTxtField: UITextField!
    @IBOutlet weak var clubTxtField: UITextField!
    @IBOutlet weak var membershipTypeTxtField: UITextField!
    @IBOutlet weak var mantenimientoTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var heightTxtField: UITextField!
    @IBOutlet weak var weightTxtField: UITextField!
    @IBOutlet weak var mailTxtField: UITextField!
    var currentTextField: UITextField?
    
    @IBOutlet weak var avisoDePrivacidad: UIButton!
    var profileImageURL = APIManager.sharedInstance.profileImage
    var user = SavedData.getTheName()
    var mailText = APIManager.sharedInstance.mail
    var membresia = APIManager.sharedInstance.memberNumber
    var club = APIManager.sharedInstance.club
    var tipoMembresia = APIManager.sharedInstance.member_type
    var mantenimiento = APIManager.sharedInstance.mainteiment
    var edad  = APIManager.sharedInstance.age
    var altura = APIManager.sharedInstance.height
    var peso = APIManager.sharedInstance.weight
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            
            switch setttings.soundSetting{
            case .enabled:
                DispatchQueue.main.async {
                self.switchNotification.setOn(true, animated: false)
                }
                
            case .disabled:
                DispatchQueue.main.async {
                self.switchNotification.setOn(false, animated: false)
                }
                
            case .notSupported:
                DispatchQueue.main.async {
                self.switchNotification.setOn(false, animated: false)
                }
            }
        
        }
        
    }
    func pushEnabledAtOSLevel() -> Bool {
        guard let currentSettings = UIApplication.shared.currentUserNotificationSettings?.types else { return false }
        return currentSettings.rawValue != 0
    }
    override func viewDidLoad() {
        
        
        APIManager.sharedInstance.heightTextField = self.heightTxtField
        APIManager.sharedInstance.weightTextField = self.weightTxtField
        //APIManager.sharedInstance.config = self
        username.layer.cornerRadius = 2
        membershipTxtField.layer.cornerRadius = 2
        clubTxtField.layer.cornerRadius = 2
        membershipTypeTxtField.layer.cornerRadius = 2
        mantenimientoTxtField.layer.cornerRadius = 2
        ageTxtField.layer.cornerRadius = 2
        heightTxtField.layer.cornerRadius = 2
        weightTxtField.layer.cornerRadius = 2
        mailTxtField.layer.cornerRadius = 2
        super.viewDidLoad()
        avisoDePrivacidad.addTopBorderWithColor(avisoDePrivacidad, color: UIColor.white, width: 0.5)
         avisoDePrivacidad.addBottomBorderWithColor(avisoDePrivacidad, color: UIColor.white, width: 0.5)
        
        if user == nil {
            username.text = SavedData.getTheName()
         } else {
            username.text = SavedData.getTheName()

          }
        if membresia == nil {
            membershipTxtField.text = ""
        } else {
            membershipTxtField.text = String(describing: membresia!)
        }
        if club == nil {
            clubTxtField.text = SavedData.getTheClub()
        } else {
            clubTxtField.text = club
        }
        if tipoMembresia == nil {
            membershipTypeTxtField.text = SavedData.gettMemberType()
        } else {
            membershipTypeTxtField.text = tipoMembresia
        }
        if mantenimiento == nil {
            mantenimientoTxtField.text = SavedData.getTheMantaniance()
        } else {
            mantenimientoTxtField.text = mantenimiento
        }
        if edad == nil {
            ageTxtField.text = String(describing: SavedData.getTheAge())
        } else {
            ageTxtField.text = String(describing: edad!)
            age = Int(ageTxtField.text!)
            SavedData.setTheAge(age: age!)
            ageTxtField.text = String(describing: SavedData.getTheAge())

        }
        if altura == nil {
           heightTxtField.text = String(describing: SavedData.getTheHeight())
        } else {
            heightTxtField.text = altura
            height = Double(heightTxtField.text!)
            //SavedData.setTheHeight(height: height!)
            heightTxtField.text = String(describing: SavedData.getTheHeight())
        }
        if peso == nil {
             weightTxtField.text = String(describing: SavedData.getTheWeight())
        } else {
            weight = Double(weightTxtField.text!)
           // SavedData.setTheWeight(weight: weight ?? 0 )
            weightTxtField.text = String(describing: SavedData.getTheWeight())
        }
        
        if mailText == "" {
          mailTxtField.text = ""
         } else {
           mailTxtField.text = SavedData.getTheEmail()
    }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
      
}
    
    @objc func willEnterForeground() {
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            
            switch setttings.soundSetting{
            case .enabled:
                DispatchQueue.main.async {
                    self.switchNotification.setOn(true, animated: false)
                }
                
            case .disabled:
                DispatchQueue.main.async {
                    self.switchNotification.setOn(false, animated: false)
                }
                
            case .notSupported:
                DispatchQueue.main.async {
                    self.switchNotification.setOn(false, animated: false)
                }
            }
            
        }
        // do stuff
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentTextField?.resignFirstResponder()
        textField.resignFirstResponder()
        currentTextField = nil
        
        peso = weightTxtField.text!
        weight = Double(peso!)
        SavedData.setTheWeight(weight: weight ?? 0.0)
        
        altura = heightTxtField.text!
        
        height = Double(altura!)
        
        SavedData.setTheHeight(height: height ?? 0.0)
        
    }
    
    @IBAction func switchNotification(_ sender: Any) {
      /*  if `switch`.isOn == true {
            `switch`.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        } else if `switch`.isOn == false {
            UserDefaults.standard.set((sender as AnyObject).isOn, forKey: "switchState")
                
            }*/
        switchNotification.setOn(!switchNotification.isOn, animated: false)
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
         
            if (UIApplication.shared.canOpenURL(appSettings as URL)) {  //First check Google Mpas installed on User's phone or not.
                UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                
            }
            
        }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if (textField ==  ageTxtField) {
            heightTxtField.becomeFirstResponder()
        }  else if (textField == heightTxtField) {
            weightTxtField.becomeFirstResponder()
        } else if (textField ==  weightTxtField) {
           currentTextField?.resignFirstResponder()
    }
        return true
    }

}
