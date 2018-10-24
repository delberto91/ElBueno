//
//  CalificacionVideosViewController.swift
//  Sports World
//
//  Created by VicktorManuel on 8/17/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import DLRadioButton

class CalificacionVideosViewController: UIViewController {
    @IBOutlet weak var caritaTriste: UIButton!
    @IBOutlet weak var caritaSudor: UIButton!
    @IBOutlet weak var caritaMasOMenos: UIButton!
    @IBOutlet weak var caritaFeliz: UIButton!
    @IBOutlet weak var caritaExcelente: UIButton!
    @IBOutlet weak var botonEnviar: UIButton!
    
    @IBOutlet weak var otroBTN: DLRadioButton!
    @IBOutlet weak var casaBTN: DLRadioButton!
    @IBOutlet weak var gymBTN: DLRadioButton!
    
    
    @IBOutlet weak var NoMeGusto: DLRadioButton!
    @IBOutlet weak var Regular: DLRadioButton!
    @IBOutlet weak var MeGusto: DLRadioButton!
    @IBOutlet weak var MeEncanto: DLRadioButton!
    
    @IBOutlet weak var textoLabel: UILabel!
    @IBOutlet var starButtons: [UIButton] = []
    
    @IBOutlet weak var icon_mal: UIImageView!
    
    @IBOutlet weak var icon_cansado: UIImageView!
    
    @IBOutlet weak var icon_regular: UIImageView!
    @IBOutlet weak var icon_bien: UIImageView!
    
    @IBOutlet weak var icon_excelente: UIImageView!
    
    var primeraSeleccion:String = ""
    var segundaSeleccion:String = ""
    var terceraSeleccion:String = ""
    
    var claveEntrenamiento:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Encuesta", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        textoLabel.text = ""
        botonEnviar.layer.masksToBounds = true
        botonEnviar.layer.cornerRadius = 15
        
        gymBTN.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
          casaBTN.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
          otroBTN.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButton), for: UIControlEvents.touchUpInside)
        
          NoMeGusto.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButtonDown), for: UIControlEvents.touchUpInside)
    Regular.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButtonDown), for: UIControlEvents.touchUpInside)
    MeGusto.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButtonDown), for: UIControlEvents.touchUpInside)
    MeEncanto.addTarget(self, action: #selector(CalificacionVideosViewController.logSelectedButtonDown), for: UIControlEvents.touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    

    
    
    @IBAction func starWasPressed(_ sender: UIButton) {
        starButtons
            .forEach({ $0.isSelected = false })
        starButtons
            .filter({ $0.tag <= sender.tag })
            .forEach({ $0.isSelected = true })
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
                if button.titleLabel?.text == "Gym"{
                    primeraSeleccion = "1"
                }else if button.titleLabel?.text == "Casa"{
                    primeraSeleccion = "2"
                }else if button.titleLabel?.text == "Otro"{
                    primeraSeleccion = "3"
                }
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
        }
    }
    
    
    @objc @IBAction private func logSelectedButtonDown(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
                if button.titleLabel?.text == "Me encantó"{
                    terceraSeleccion = "9"
                }else if button.titleLabel?.text == "Me gustó"{
                    terceraSeleccion = "10"
                }else if button.titleLabel?.text == "Regular"{
                    terceraSeleccion = "11"
                }else if button.titleLabel?.text == "No me gustó"{
                    terceraSeleccion = "12"
                }
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func caritaTristeAction(_ sender: Any) {
       segundaSeleccion = "4"
        textoLabel.text = "Mal"
        icon_mal.image = UIImage(named: "icon_malrojo")
        icon_cansado.image = UIImage(named: "icon_cansado")
        icon_regular.image = UIImage(named: "icon_regular")
        icon_bien.image = UIImage(named: "icon_bien")
        icon_excelente.image = UIImage(named: "icon_excelente")
        
    }
    
    @IBAction func caritaSudorAction(_ sender: Any) {
  segundaSeleccion = "5"
        textoLabel.text = "Cansado"
        icon_mal.image = UIImage(named: "icon_mal")
        icon_cansado.image = UIImage(named: "icon_cansadorojo")
        icon_regular.image = UIImage(named: "icon_regular")
        icon_bien.image = UIImage(named: "icon_bien")
        icon_excelente.image = UIImage(named: "icon_excelente")
    }
   
    @IBAction func caritaMasOMenosAction(_ sender: Any) {
  segundaSeleccion = "6"
        textoLabel.text = "Regular"
        icon_mal.image = UIImage(named: "icon_mal")
        icon_cansado.image = UIImage(named: "icon_cansado")
        icon_regular.image = UIImage(named: "icon_regularrojo")
        icon_bien.image = UIImage(named: "icon_bien")
        icon_excelente.image = UIImage(named: "icon_excelente")
    }
    
    @IBAction func caritaFelizAction(_ sender: Any) {
        segundaSeleccion = "7"
        textoLabel.text = "Bien"
        icon_mal.image = UIImage(named: "icon_mal")
        icon_cansado.image = UIImage(named: "icon_cansado")
        icon_regular.image = UIImage(named: "icon_regular")
        icon_bien.image = UIImage(named: "icon_bienrojo")
        icon_excelente.image = UIImage(named: "icon_excelente")
        
    }
    @IBAction func caritaExcelenteAction(_ sender: Any) {
      segundaSeleccion = "8"
        textoLabel.text = "Excelente"
        icon_mal.image = UIImage(named: "icon_mal")
        icon_cansado.image = UIImage(named: "icon_cansado")
        icon_regular.image = UIImage(named: "icon_regular")
        icon_bien.image = UIImage(named: "icon_bien")
        icon_excelente.image = UIImage(named: "icon_excelenterojo")
        
    }
    
    @IBAction func BotonEnviarAction(_ sender: Any) {
        var resultado = "\(primeraSeleccion),\(segundaSeleccion),\(terceraSeleccion)"
        APIManager.sharedInstance.evaluacionEncuestaVideo(claveEntrenamiento: claveEntrenamiento, respuestas: resultado, onSuccess: {
            respuesta in
            Alert.ShowAlert(title: "", message: APIManager.sharedInstance.message, titleForTheAction: "Ok", in: self)
            print(respuesta)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                _ = self.navigationController?.popViewController(animated: true)
            }
            
        }, onFailure: {
            error in
            
            print("un error")
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
