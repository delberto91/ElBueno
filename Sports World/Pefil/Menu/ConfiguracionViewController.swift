//
//  ConfiguracionViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 5/22/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import MobileCoreServices
import SwiftyJSON

class ConfiguracionViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var miPerfilLabel: UILabel!
    @IBOutlet weak var guardarButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var finalImage: String!

    var newPick: Bool? 
    // var profileImageURL = SavedData.getTheProfilePic()
    //////////VARIABLES////////////////////
    var currentTextField: UITextField?
    var isFirstTime: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        guardarButton.isUserInteractionEnabled = false
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Detalle perfil", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "power_Button"), style: .done, target: self, action: #selector(ConfiguracionViewController.logout))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        profileImage.frame = CGRect(x: self.view.frame.width / 2 - 45, y: miPerfilLabel.frame.origin.y + miPerfilLabel.bounds.height, width: 90, height: 90)
        
        guardarButton.layer.cornerRadius = 8 
        if APIManager.sharedInstance.profileImage  == "vacio"  {
            let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
            profileImage.image = UIImage(data: data as Data)
            
          
        } else  {
            self.profileImage.downloadImage(downloadURL: SavedData.getTheProfilePic(), completion: { result in
                
            })
            
        }
 
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        activity.isHidden = true
      
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConfiguracionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
   
    
    func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: .zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    func getNotoficacionBaja() {
        APIManagerV.sharedInstance.notificacionAlta(tipoDispositivo: 0, type: 0, onSuccess: { response in
            
            
            DispatchQueue.main.async {
                
                if response.code == 200 {
                    
                    print("Se dio de baja al usuario")
                } else {
                    print("No se pudo dar de baja correctamente.")
                }
            }
            
        })
    }
 
    @objc func logout() {
        self.getNotoficacionBaja()
        isFirstTimeFromAppDelegate = true 
        activity.isHidden = false
        activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        ExternosAPI.sharedInstance.guardarTipoDeUsuario(tipo: -1)
        SavedData.setTheName(theName: "")
        SavedData.setTheUserId(userId: 0)
        SavedData.setTheLatitude(double: 0.0)
        SavedData.setTheLongitude(double: 0.0)
        SavedData.setTheWeight(weight: 0.0)
        SavedData.setTheHeight(height: 0.0)
        SavedData.setTheAge(age: 0)
        SavedData.setTheEmail(email: "")
        SavedData.setTheProfilePic(profilePic: "")
        SavedData.setTheEmail(email: "")
        SavedData.setTheMantaniance(mantaniance: "")
        SavedData.seTMemUnicId(memUnicId: 0)
        SavedData.setMemberType(memberType: "")
        SavedData.setTheClub(club: "")
        self.present(SplashViewController(), animated: true, completion: nil)
        activity.isHidden = true
        activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
    }
    //DESAPARECE EL TECLADO TOCANDO LA VISTA.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
    
    func updateUserInfo() {
        activity.isHidden = false
        activity.startAnimating()
        view.isUserInteractionEnabled = false
        var height: Double = 0
        var weight: Double = 0
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        if let h = numberFormatter.number(from: APIManager.sharedInstance.heightTextField.text!){
            height = Double(truncating: h)
        }
        if let w = numberFormatter.number(from: APIManager.sharedInstance.weightTextField.text!){
            weight = Double(truncating: w)
        }
        APIManager.sharedInstance.profileUpdate(height: height, weight: weight, age: SavedData.getTheAge(), img: finalImage ,onSuccess: { json in
            DispatchQueue.main.async {
                APIManager.sharedInstance.profileImage = "vacio"
               
                if APIManager.sharedInstance.status == true {
                    print("success updateprofile")
                    
                    SavedData.setTheHeight(height: height )
                    SavedData.setTheWeight(weight: weight)
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.view.isUserInteractionEnabled = true
                
                    Alert.ShowAlert(title: "¡Listo!", message: "Se actulizó correctamente.", titleForTheAction: "ACEPTAR", in: self)
                    
                    /*self.profileImage.downloadImage(downloadURL: SavedData.getTheProfilePic(), completion: { result in
                        
                    })*/
                } else if APIManager.sharedInstance.status == false {
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "¡Lo sentimos!", message: "Hubo un error al actulizar tus datos.", titleForTheAction: "ACEPTAR", in: self)
                } else {
                 
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "¡Listo!", message: "Se actualizó correctamente.", titleForTheAction: "ACEPTAR", in: self)
                 /*  self.profileImage.downloadImage(downloadURL: SavedData.getTheProfilePic(), completion: { result in
                        
                    })*/
                }
            }
            
        }, onFailure: { error in
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.view.isUserInteractionEnabled = true
           /* self.profileImage.downloadImage(downloadURL: SavedData.getTheProfilePic(), completion: { result in
                
            })*/
            
        })

    }
    @IBAction func clickActualizarButton(_ sender: Any) {
        if height == 0.0 && weight == 0.0  {
           Alert.ShowAlert(title: "", message: "Debes de poner tu peso y tu estatura para poder continuar", titleForTheAction: "Aceptar", in: self)
        }
        updateUserInfo()
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let myAlert = UIAlertController(title: "Seleccionar imagen.", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Cámara", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera;
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
        let cameraRoll = UIAlertAction(title: "Álbum de fotos", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                
                let BarButtonItemAppearance = UIBarButtonItem.appearance()
            BarButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: .normal)
                
                self.present(imagePicker, animated: true, completion: nil)
              

        }
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        myAlert.addAction(cancelButton)
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRoll)
        self.present(myAlert, animated: true , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guardarButton.isUserInteractionEnabled = true

        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
        profileImage.image = UIImage(data: data as Data)
        //profileImage.image = image
        
        
        let imageToConvert: UIImage = profileImage.image!
        let imageResized = imageToConvert.resizeWithWidth(width: 700.0)
        if let imageData = imageResized?.jpeg(.lowest) {
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            finalImage = strBase64
            
            
        }
        
        dismiss(animated:true, completion: nil)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        }
    
}
