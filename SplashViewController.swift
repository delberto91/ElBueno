//
//  SplashViewController.swift
//  Sports World
//
//  Created by Delberto Martinez Salazar on 26/12/17.
//  Copyright © 2017 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
class SplashViewController: UIViewController {

    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() {
            getTheClubes()
        } else {
            Alert.ShowAlert(title: "", message: "No cuentas con internet, verifica tu conexión o intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
        }
        

    }
    
    func getTheClubes() {
   
        
        
          self.getTheNews()
  
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadVideo()
    }
    
    // PASA A OTRA VISTA.
  @objc func passToAnotherController() {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    if let play = player{
        play.pause()
        player = nil
        print("stop")
    }
    self.present(vc, animated: true, completion: nil)
        
    }
    
    //CONFIGURA EL TIMER DEL VIDEO
    func schedule() {
        if isFirstTimeFromAppDelegate == true {
            _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(passToAnotherController), userInfo: nil, repeats: true);
        } else {
            
        }
     
    }

    //CONFIGURA EL VIDEO.
    private func loadVideo() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch { }
        
        let path = Bundle.main.path(forResource: "VIDEO_SPLASH", ofType:"mp4")
        player = AVPlayer.init(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        player?.play()
        self.view.layer.addSublayer(playerLayer)
        schedule()
    }
    
    func getTheNews(){
        APIManager.sharedInstance.getNews(onSuccess: { json in
            DispatchQueue.main.async {
                if APIManager.sharedInstance.status == true {
                    
                    print("Success Request GetCharges")
                }
            }
            
        }, onFailure: { error in
            
        })
    }
    
    
}
