 //
//  CitaAgendadaViewController.swift
//  Sports World
//
//  Created by VicktorManuel on 8/15/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import EventKit
 var agendadoUltimo: Bool = false
class CitaAgendadaViewController: UIViewController {

    let eventStore = EKEventStore()
    @IBOutlet weak var botonAceptar: UIButton!
    @IBOutlet weak var libretaView: UIView!
    @IBOutlet weak var circuloMask: UIView!
    @IBOutlet weak var claseLabel: UILabel!
    @IBOutlet weak var dondeLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var botonCancelar: UIButton!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    var fecha:String!
    var horario:String!
    var idUNTemp:Int!
    var idAgenda:Int = 0
    var agendado: Bool = false
    
    @IBOutlet weak var gimnasioLabel: UILabel!
    var clubsAll : [ClubInBody] = [ClubInBody]()
    var currentClub : ClubInBody = ClubInBody()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fechaLabel.text = "\(fecha[8 ..< 10]) de \(getMonth(month: fecha[5 ..< 7]))"
        hourLabel.text = "\(horario[0 ..< 5]) hrs"
        //self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        /* let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back_button"), style: .done, target: self, action: #selector(back))
         self.navigationItem.leftBarButtonItem = leftBarButtonItem*/
        /*
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back_button"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem*/
        
        
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 5, height: 5)
        menuBtn.setImage(UIImage(named:"back_button"), for: .normal)
        menuBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 32)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
        
        APIManager.sharedInstance.getClubsInBody(onSuccess: { json in
            DispatchQueue.main.async {
                if(json.code == 200){
                    DispatchQueue.main.async {
                        self.clubsAll = json.data
                        
                        for i in self.clubsAll{
                            if i.idUn == self.idUNTemp{
                                self.dondeLabel.text = i.name
                            }
                        }
                    }
                }else{
                    Alert.ShowAlert(title: "Algo paso 😳", message: "No cargaron correctamente los clubs", titleForTheAction: "Aceptar", in: self)
                }
            }
        })
        // Do any additional setup after loading the view.
    }

     @objc func back() {
        // Perform your custom actions
        // ...
       //performSegue(withIdentifier: "volverWess", sender: nil)
       // self.navigationController?.popViewController(animated: true)
         let _ = self.navigationController?.popViewController(animated: true)
    }
    func getMonth(month:String) -> String{
        switch month {
        case "01":
            return "Enero"
            break
        case "02":
            return "Febrero"
            break
        case "03":
            return "Marzo"
            break
        case "04":
            return "Abril"
            break
        case "05":
            return "Mayo"
            break
        case "06":
            return "Junio"
            break
        case "07":
            return "Julio"
            break
        case "08":
            return "Agosto"
            break
        case "09":
            return "Septiembre"
            break
        case "10":
            return "Octubre"
            break
        case "11":
            return "Noviembre"
            break
        case "12":
            return "Diciembre"
            break
        default:
            return ""
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        circuloMask.layer.masksToBounds = true
        circuloMask.layer.cornerRadius = circuloMask.frame.width/2
        libretaView.layer.masksToBounds = true
        libretaView.layer.cornerRadius = 16
        
        botonCancelar.layer.masksToBounds = true
        botonCancelar.layer.cornerRadius = 15
        
        botonAceptar.layer.masksToBounds = true
        botonAceptar.layer.cornerRadius = 15
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    let id = event.eventIdentifier ?? "NO ID"
                    _ = eventStore.event(withIdentifier: id)
                    
                  self.agendado = true
                    
                } catch let e as NSError {
                    completion?(false, e)
                    
                    Alert.ShowAlert(title: "", message: "Ocurrió un error al querer agregar a tu calendario.", titleForTheAction: "Aceptar", in: self)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
 public func deleteEvent()
    {
        let startDate = NSDate().addingTimeInterval(60*60*24*(-2))
        let endDate = NSDate().addingTimeInterval(60*60*24*7)
        
        let predicate2 = eventStore.predicateForEvents(withStart: startDate as Date, end: endDate as Date, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        let eV = eventStore.events(matching: predicate2) as [EKEvent]!
        
        if eV != nil {
            for i in eV! {
                
                do{
                    (try eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                    agendadoUltimo = true
                }
                catch let error {
                    print("Error removing events: ", error)
                }
                
            }
        }
        
    }
    
    

    @IBAction func cancelarCita(_ sender: Any) {
        
        
        APIManager.sharedInstance.cancelReservaInBody(idAgenda: String(idAgenda), onSuccess: {
            respuesta in
            
            DispatchQueue.main.async {
                print(respuesta)
                self.deleteEvent()
                let alertController = UIAlertController(title: "", message: "Haz cancelado tu cita", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                   
                    
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
                // Add the actions
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
        }, onFailure: {
            error in
            
             Alert.ShowAlert(title: "", message: "Ocurrio un error al cancelar tu cita", titleForTheAction: "", in: self)
            let _ = self.navigationController?.popViewController(animated: true)
            
        })
    }
    @IBAction func acept(_ sender: Any) {
        
        if agendadoUltimo == true {
            
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let myAlert = UIAlertController(title: "¡Listo!", message: "Agrega tu cita en el calendario de tu celular para que no la olvides.", preferredStyle: .alert)
        
        let seguirComprando = UIAlertAction(title: "Agendar en calendario", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.agendado = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            let date = dateFormatter.date(from:isoDate)!
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let finalDate = calendar.date(from:components)
            let endDate = calendar.date(byAdding: .minute, value: 5, to: finalDate!)
            
            self.addEventToCalendar(title: "Cita inbody", description: "Cita agendada.", startDate: finalDate!, endDate: endDate!)
            
            if self.agendado == true {
                agendadoUltimo = true
                   let _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        let irACarrito = UIAlertAction(title: "No agendar en calendario", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
            self.dismiss(animated: true , completion: nil)
        }
        
        //myAlert.addAction(cancelButton)
        myAlert.addAction(seguirComprando)
        myAlert.addAction(irACarrito)
        
        self.present(myAlert, animated: true , completion: nil)
   
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    


}
