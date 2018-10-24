//
//  LoginViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 26/12/17.
//  Copyright © 2017 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CryptoSwift
import SwiftyJSON


class LoginViewController: UIViewController {
    
    var player: AVPlayer?
      public var phoneNumber = "018000079727"
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var labelPolitica: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    var playerLayer = AVPlayerLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        labelPolitica.text = "Al iniciar sesión aceptas el Aviso de Privacidad y los Términos y Condiciones."
        loginButton.layer.cornerRadius = 8 
        activity.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadVideo()
    }
    
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - MÉTODOS
    //DECLARA TODOS LOS MÉTODOS.
    
    func validateTextFields () -> Bool {
        if userLogin != "" && passwordLogin != ""{
            Alert.ShowAlert(title: "", message: "Verifica que tus campos esten llenos antes de continuar", titleForTheAction: "ACEPTAR", in: self)
            return false
        } else {
            return true
        }
    }
    func passToAnotherView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        if let play = player{
            play.pause()
            player = nil
            print("stop")
        }
        self.present(vc, animated: true, completion: nil)

    }
  
    //REALIZA EL LOGIN
    
    func login() {
        self.activity.isHidden = false
        self.activity.startAnimating()
        view.isUserInteractionEnabled = false
        let passSha1 = passwordLogin.sha1()
        let stringToLowerCase = "\(userLogin!).\(passSha1)".lowercased()
        let stringToBase64 = stringToLowerCase.toBase64()
        print("ESte es el stringToBase64", stringToBase64)
        
        ExternosAPI.sharedInstance.login(llave: stringToBase64, completion: { responseData in
            
            DispatchQueue.main.async {
                
                if(responseData.code != 200){
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if(responseData.message == ""){
                        Alert.ShowAlert(title: "", message: "Lo sentimos, hubo un error intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                    }else{
                        
                        Alert.ShowAlert(title: "", message: responseData.message, titleForTheAction: "ACEPTAR", in: self)
                        
                    }
                    
                }else{
                    SavedData.setTheProfilePic(profilePic: responseData.data.profile_photo)
                    SavedData.setTheName(theName: responseData.data.name)
                    SavedData.setTheMemberNumber(memberNumber: responseData.data.membernumber)
                    SavedData.seTMemUnicId(memUnicId: responseData.data.memunic_id)
                    SavedData.setTheClub(club: responseData.data.club)
                    SavedData.setTheEmail(email: responseData.data.mail)
                    SavedData.setMemberType(memberType: responseData.data.member_type)
                    SavedData.setTheMantaniance(mantaniance: responseData.data.mainteiment)
                    SavedData.setTheUserId(userId: responseData.data.user_id)
                    APIManager.sharedInstance.userId = responseData.data.user_id
                    
                    APIManager.sharedInstance.getClubesForRegister(onSuccess: { json in
                        
                        DispatchQueue.main.async {
                            self.activity.isHidden = true
                            self.activity.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            self.passToAnotherView()
                        }
                    }, onFailure: { error in
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        Alert.ShowAlert(title: "", message: "Lo sentimos, hubo un error intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                    })
                }
            }
            
        })
        
   
    }
    //NO HACE NADA
    @objc func passToAnotherController() {
        
    }
    
    //CONFIGURA EL TIMER DEL VIDEO
    func schedule() {
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(passToAnotherController), userInfo: nil, repeats: true);
        
    }

    //CONFIGURA EL VIDEO.
    private func loadVideo() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        
        let path = Bundle.main.path(forResource: "VIDEO_LOGIN", ofType:"mp4")
        player = AVPlayer.init(url: NSURL(fileURLWithPath: path!) as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        player?.play()
        self.view.layer.addSublayer(playerLayer)
        schedule()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
        }
    }
/////////////////////////////////FUNCIONES PARA MOSTRAR/OCULTAR ACTIVITY/////////////////////////////////////////
   
    //MARK: - BOTONES
    //CONFIGURA EL COMPORTAMIENTO DE LOS BOTONES.
    
    @IBAction func clickSoporteButton(_ sender: Any) {
        
        let myAlert = UIAlertController(title: "¿Tienes alguna duda?", message: "Nuestro equipo de soporte te puede ayudar, comunícate con nosotros al \(phoneNumber) tu cita en el calendario de tu celular para que no la olvides.", preferredStyle: .alert)
        
        let seguirComprando = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if let phoneCallURL = URL(string: " tel://\(self.phoneNumber)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
        
        let irACarrito = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        //myAlert.addAction(cancelButton)
        myAlert.addAction(seguirComprando)
        myAlert.addAction(irACarrito)
        
        self.present(myAlert, animated: true , completion: nil)
        
       
    }
    
    
    @IBAction func openExternosSignUp(_ sender: Any) {
        let story: UIStoryboard = UIStoryboard(name: "RegistoExternos", bundle: nil)
        let viewC : UIViewController = story.instantiateViewController(withIdentifier: "RegistroExternos") as! RegistroExternosViewController
        
        self.present(viewC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func clickLoginButton(_ sender: Any) {
        if userLogin.isEmpty == true  || passwordLogin.isEmpty == true {
            
            if Reachability.isConnectedToNetwork() {
                login()
                
            } else{
                Alert.ShowAlert(title: "", message: "No cuentas con internet, verifica tu conexión o intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
            }
        } else {
                Alert.ShowAlert(title: "", message: "Favor de verificar tus datos.", titleForTheAction: "Aceptar", in: self)
        }
      
      
        
    }
  
    
}
