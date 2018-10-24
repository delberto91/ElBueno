//
//  CalificacionClaseViewController.swift
//  Sports World
///Users/vicktormanuel/Documents/GitHub/SportsWorldDefinitivo/Sports World/Menu/Inbody/CalendarioInBodyViewController.swift
//  Created by VicktorManuel on 8/10/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class CalificacionClaseViewController: UIViewController {

    @IBOutlet weak var queteParecioText: UILabel!
    var arregloDeClases:[DatosEncuesta] = [DatosEncuesta]()
    //Reservar
    @IBAction func sendTextComments(_ sender: Any) {
        
        if !self.comentarioTxt.text.isEmpty{
            APIManager.sharedInstance.calificacionEncuesta(idInstalacionActividadProgramada: "\(self.idEjercicio)", idSatisfaccionPregunta: "\(self.idsatisfaccionpregunta)", calificacion: "\(self.numEstrellas)", comentario: self.comentarioTxt.text, onSuccess:{ json in
                
                
                DispatchQueue.main.async {
                 
                    Alert.ShowAlert(title: "", message: "Gracias por ayudarnos a mejorar", titleForTheAction: "Aceptar", in: self)
                }
   
            }, onFailure: { error in
                
                })
        }else{
            APIManager.sharedInstance.calificacionEncuesta(idInstalacionActividadProgramada: "\(self.idEjercicio)", idSatisfaccionPregunta: "\(self.idsatisfaccionpregunta)", calificacion: "\(self.numEstrellas)", comentario: self.comentarioTxt.text, onSuccess:{ json in
                
                DispatchQueue.main.async {
                    
                    Alert.ShowAlert(title: "", message: "Gracias por ayudarnos a mejorar", titleForTheAction: "Aceptar", in: self)
                }
                
            }, onFailure: { error in
                
            })
        }
        
         self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var comentarioTxt: UITextView!
    @IBOutlet weak var musicaBtn: UIButton!
    @IBOutlet weak var limpiezaBtn: UIButton!
    
    @IBOutlet weak var instructorBtn: UIButton!
    @IBOutlet weak var comentarioEstrella: UILabel!
    @IBOutlet weak var estrella5: UIButton!
    @IBOutlet weak var estrella4: UIButton!
    @IBOutlet weak var estrella3: UIButton!
    @IBOutlet weak var estrella2: UIButton!
    @IBOutlet weak var estrella1: UIButton!
    @IBOutlet var starButtons: [UIButton] = []
    var botonSeleccionado:Int = 0
    var encuestasPendientes:[DatosEncuesta] = [DatosEncuesta]()
    var instructora:String = ""
    var ejercicio:String = ""
    var idEjercicio:Int = 0
    var idsatisfaccionpregunta:Int = 0
    var numEstrellas:Int = 1
    
    
    @IBOutlet weak var quePodemosMejorarLabel: UILabel!
    @IBOutlet weak var primerosBotones: UIStackView!
    
    @IBOutlet weak var segundosBotones: UIStackView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getServicios()
        moveTextFieldForKeyBoard()
        configurarEstrellas()
        configurarBotones()
        insertarTextos()
        desaparecerQuePodemosHacer()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalificacionClaseViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    func desaparecerQuePodemosHacer(){
        primerosBotones.isHidden = true
        segundosBotones.isHidden = true
        quePodemosMejorarLabel.isHidden = true
    }
    func aparecerQuePodemosHacer(){
        primerosBotones.isHidden = false
        segundosBotones.isHidden = false
        quePodemosMejorarLabel.isHidden = false
    }
    
    
    override func viewDidLayoutSubviews() {
        insertarTextos()
    }
    @IBAction func backButtonWasPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.flashScrollIndicators()
        insertarTextos()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func starWasPressed(_ sender: UIButton) {
        starButtons
            .forEach({ $0.isSelected = false })
        starButtons
            .filter({ $0.tag <= sender.tag })
            .forEach({ $0.isSelected = true })
    }
    
    @IBOutlet weak var botonEnviar: UIButton!
    func insertarTextos(){
//        comentarioTxt.layer.masksToBounds = true
//        comentarioTxt.layer.cornerRadius = 10
//        botonEnviar.layer.masksToBounds = true
//        botonEnviar.layer.cornerRadius = 10
        queteParecioText.text = "¿Qué te parecio la última clase que tomaste de \(self.ejercicio) con \(self.instructora)?"
        queteParecioText.setNeedsLayout()
        queteParecioText.setNeedsDisplay()
    }
    
    func getServicios(){
        APIManager.sharedInstance.getEncuestasPendientes(onSuccess: {response in
            DispatchQueue.main.async {
                if response.status == true {
                  print("correcto \(response.data)")
                    self.encuestasPendientes = response.data
                    for encuesta in self.encuestasPendientes{
                        self.instructora = encuesta.instructor
                        self.ejercicio = encuesta.clase
                        self.idEjercicio = encuesta.idinstalacionactividadprogramada
                        print(encuesta.instructor)
                        self.insertarTextos()
                    }
                }
            }})
        
       /* APIManager.sharedInstance.getEvaluacionClases(onSuccess: {response in
            DispatchQueue.main.async {
                if response.status == true {
                    print("correcto")
                }
            }})*/
    }
    
    func configurarBotones(){
       
//        musicaBtn.layer.masksToBounds = false
//
//        musicaBtn.layer.cornerRadius = 15
//        musicaBtn.clipsToBounds = true
//
//
//        limpiezaBtn.layer.masksToBounds = false
//
//        limpiezaBtn.layer.cornerRadius = 15
//        limpiezaBtn.clipsToBounds = true
//
//
//        equipoBtn.layer.masksToBounds = false
//
//        equipoBtn.layer.cornerRadius = 15
//        equipoBtn.clipsToBounds = true
//
//
//        instructorBtn.layer.masksToBounds = false
//
//        instructorBtn.layer.cornerRadius = 15
//        instructorBtn.clipsToBounds = true
    }
    
    func configurarEstrellas(){
        estrella1.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella2.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella3.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella4.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella5.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        comentarioEstrella.text = ""
        
    }

    @IBAction func star5Action(_ sender: Any) {
         numEstrellas = 5
        desaparecerQuePodemosHacer()
        estrella1.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella2.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella3.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella4.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella5.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        comentarioEstrella.text = "Excelente"
        //comentarioEstrella.setNeedsDisplay()
        //comentarioEstrella.setNeedsLayout()
    }
    @IBAction func star4Action(_ sender: Any) {
        numEstrellas = 4
        desaparecerQuePodemosHacer()
        estrella1.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella2.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella3.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella4.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella5.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        comentarioEstrella.text = "Bueno"
        //comentarioEstrella.setNeedsDisplay()
       // comentarioEstrella.setNeedsLayout()
    }
    @IBAction func star3Action(_ sender: Any) {
        numEstrellas = 3
        aparecerQuePodemosHacer()
        estrella1.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella2.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella3.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella4.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella5.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        comentarioEstrella.text = "Regular"
        //comentarioEstrella.setNeedsDisplay()
    //    comentarioEstrella.setNeedsLayout()
    }
    @IBAction func star2Action(_ sender: Any) {
        numEstrellas = 2
        aparecerQuePodemosHacer()
        
        estrella1.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella2.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella3.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella4.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella5.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        comentarioEstrella.text = "Malo"
        //comentarioEstrella.setNeedsDisplay()
       // comentarioEstrella.setNeedsLayout()
    }
    @IBAction func star1Action(_ sender: Any) {
         numEstrellas = 1
       aparecerQuePodemosHacer()
        estrella1.setImage(UIImage(named: "estrellaAmarilla"), for: .selected)
        estrella2.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella3.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella4.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        estrella5.setImage(UIImage(named: "estrellaBlanca"), for: .normal)
        comentarioEstrella.text = "Pesimo"
       // comentarioEstrella.setNeedsDisplay()
    //    comentarioEstrella.setNeedsLayout()
    }
    
    @IBAction func limpiezaAction(_ sender: Any) {
         botonSeleccionado = 646
        idsatisfaccionpregunta = 321
        limpiezaBtn.backgroundColor = UIColor.red
        equipoBtn.backgroundColor = UIColor.clear
        instructorBtn.backgroundColor = UIColor.clear
        musicaBtn.backgroundColor = UIColor.clear
    }
    @IBOutlet weak var equipoBtn: UIButton!
    
    @IBAction func equipoBtnAction(_ sender: Any) {
        botonSeleccionado = 645
        idsatisfaccionpregunta = 322
        limpiezaBtn.backgroundColor = UIColor.clear
        equipoBtn.backgroundColor = UIColor.red
        instructorBtn.backgroundColor = UIColor.clear
        musicaBtn.backgroundColor = UIColor.clear
    }
    @IBAction func instructorBtn(_ sender: Any) {
        botonSeleccionado = 647
        idsatisfaccionpregunta = 320
        limpiezaBtn.backgroundColor = UIColor.clear
        equipoBtn.backgroundColor = UIColor.clear
        instructorBtn.backgroundColor = UIColor.red
        musicaBtn.backgroundColor = UIColor.clear
     
    }
    @IBAction func musicaBtnAction(_ sender: Any) {
        botonSeleccionado = 662
        idsatisfaccionpregunta = 333
        limpiezaBtn.backgroundColor = UIColor.clear
        equipoBtn.backgroundColor = UIColor.clear
        instructorBtn.backgroundColor = UIColor.clear
        musicaBtn.backgroundColor = UIColor.red
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
