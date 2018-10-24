//
//  RoutineDetailViewController.swift
//  SW_etapa_IV
//
//  Created by Mario Canto on 7/30/18.
//  Copyright © 2018 Aldo Gutierrez Montoya. All rights reserved.

//

import UIKit
import AVKit
import AVFoundation
import UIKit


final class RoutineDetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var routineImageView: UIImageView!
    @IBOutlet weak var routineTitleLabel: UILabel!
    @IBOutlet weak var reproductionsLabel: UILabel!
    @IBOutlet var starButtons: [UIButton] = []
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var trainerImageView: UIImageView!
    
    @IBOutlet weak var trainerDescriptionLabel: UITextView!
    var videoRoutine : RutinasCasa = RutinasCasa()
    var videoURL: NSURL? = nil
    var videoPlayer: AVPlayer? = AVPlayer()
    let playerViewController = AVPlayerViewController()
    
    @IBOutlet weak var likeButton: UIButton!
    //Estrellas
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    //Datos
    
    @IBOutlet weak var imagenData: UIImageView!
    
    
    
    @IBAction func starWasPressed(_ sender: UIButton) {
        starButtons
            .forEach({ $0.isSelected = false })
        self.starButtons
            .forEach({ $0.isSelected = $0.tag <= sender.tag })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        //descriptionLabel.isHidden = true
        print(videoRoutine.videoDistribucion)
        self.routineTitleLabel.text = self.videoRoutine.nombreEntrenamiento
        estrellitaDondeEstas()
        setDatosCoach()
        self.descriptionTextView.text! = videoRoutine.descripEntre
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboard()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
 
    
    func setDatosCoach(){
        routineTitleLabel.text = videoRoutine.nombreEntrenamiento
        if(self.videoRoutine.favorito == 1){
            
            self.likeButton.isSelected = true
            self.likeButton.isSelected = true
            likeButton.setImage(UIImage(named: "heart_red"), for: UIControlState.normal)
            
            
        } else if(self.videoRoutine.favorito == 0) {
            likeButton.setImage(UIImage(named: "heart_image"), for: UIControlState.normal)
        }
        
        DispatchQueue.main.async {
            self.imagenData.downloadImageSync(downloadURL: self.videoRoutine.foto, completion: { result in
                
            })
            
            print(self.videoRoutine.foto)
        }
        
        reproductionsLabel.text = "\(videoRoutine.numeroReproduccion) Reproducciones"
        
        //coach
        
        
        trainerDescriptionLabel.text = "\(videoRoutine.coach.nombre) \(videoRoutine.coach.apellidos)\n\n\(videoRoutine.coach.descripcion)"
        
        
        trainerDescriptionLabel.setContentOffset(CGPoint.zero, animated: false)
        
        trainerDescriptionLabel.contentOffset = CGPoint.zero
        DispatchQueue.main.async {
            self.trainerImageView.downloadImageSync(downloadURL: self.videoRoutine.coach.foto, completion: { result in
                
            })
        }
        
    }
    
    
    func estrellitaDondeEstas(){
        
        self.starButtons
            .forEach({ $0.isSelected = $0.tag < videoRoutine.calificacion })
        if videoRoutine.calificacion == 0 {
            star1.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star2.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star3.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        } else if videoRoutine.calificacion == 1 {
            
            star1.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star2.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star3.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        } else if videoRoutine.calificacion == 2 {
            star1.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star2.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star3.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            
        } else if videoRoutine.calificacion == 3 {
            
            star1.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star2.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star3.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
            star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        } else if videoRoutine.calificacion == 4 {
            star1.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star2.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star3.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star4.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        } else if videoRoutine.calificacion == 5 {
            star1.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star2.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star3.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star4.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
            star5.setImage(UIImage(named:"estrellaAmarilla"), for: .normal)
        }
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reproductionsLabel.text! = "\(videoRoutine.numeroReproduccion) reproducciones"
        descriptionTextView.text! = videoRoutine.descripEntre
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Workout", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        if playerViewController.isBeingDismissed ?? false {
            playerViewController.player = nil
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        print(videoRoutine.videoDistribucion)
        
        performSegue(withIdentifier: "PlayerSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerSegue" {
            let destination = segue.destination as!
            AVPlayerViewController
            
            print(videoRoutine.videoDistribucion)
            let url = URL(string:
                videoRoutine.videoDistribucion)
            
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
                destination.player?.play()
                if #available(iOS 11.0, *) {
                    destination.exitsFullScreenWhenPlaybackEnds = true
                } else {
                    // Fallback on earlier versions
                }
                NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: destination.player?.currentItem)
            }
        }//else if segue.identifier == "segueCalificacion"{
        //    let vc = segue.destination as! CalificacionVideosViewController
        //    vc.claveEntrenamiento = videoRoutine.claveEntrenamiento
       // }
    }
    
    
    
    @objc func moviePlayBackFinished() {
        print("termine")
        APIManager.sharedInstance.finishedVideo(id: "--", entrenamiento: videoRoutine.claveEntrenamiento, onSuccess:{ response in
            DispatchQueue.main.async {
                print(response)
               // self.performSegue(withIdentifier: "segueCalificacion", sender: nil)
            }
            
        }, onFailure: {
            error in
            
            print("hubo error")
            
        })
        
    }
    
    
    @IBAction func segueCalificacion(_ sender: Any) {
      //  self.performSegue(withIdentifier: "segueCalificacion", sender: nil)
    }
    @IBOutlet weak var segueCalificacion: UIButton!
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }
    
    
    func playerDidReachEndNotificationHandler(notification: NSNotification)
    {
        print("playerDidReachEndNotification")
    }
    
    @IBOutlet weak var playVideo: UIButton!
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func star1(_ sender: Any) {
        voto1()
    }
    
    @IBAction func star2(_ sender: Any) {
        voto2()
    }
    
    @IBAction func star3(_ sender: Any) {
        voto3()
    }
    
    @IBAction func star4(_ sender: Any) {
        voto4()
    }
    
    @IBAction func star5(_ sender: Any) {
        voto5()
    }
    
    @IBAction func like(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        APIManager.sharedInstance.guardarFavoritosEntrenamientos(claveEntrenamiento: videoRoutine.claveEntrenamiento, onSuccess: {
            respuesta in
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("com.sportsworld.update.routines"), object: self)
            }
            
        }, onFailure: {
            error in
            
            print("un error")
        })
        
        // TODO: call api resource
    }
    
    //Configuración de estrellas
    func voto0(){
        star1.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star2.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star3.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
    }
    func voto1(){
        star1.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star2.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star3.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        makeVoto(voto: 1)
        
    }
    
    func voto2(){
        star1.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star2.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star3.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        makeVoto(voto: 2)
    }
    
    func voto3(){
        star1.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star2.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star3.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star4.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        makeVoto(voto: 3)
    }
    
    func voto4(){
        star1.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star2.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star3.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star4.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star5.setImage(UIImage(named:"estrellaBlanca"), for: .normal)
        makeVoto(voto: 4)
    }
    
    func voto5(){
        star1.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star2.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star3.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star4.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        star5.setImage(UIImage(named:"estrellaAmarilla"), for: .selected)
        makeVoto(voto: 5)
    }
    
    func makeVoto(voto:Int){
        APIManager.sharedInstance.calificacionVideo(entrenamiento: videoRoutine.claveEntrenamiento, calificacion: voto, onSuccess:{ response in
            DispatchQueue.main.async {
                print(response)
            }
            
        }, onFailure: {
            error in
            
            print("hubo error")
            
        })
    }
}
