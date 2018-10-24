//
//  EventosMainViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/6/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import SwiftyJSON
var isProximos: Bool!

class EventosMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    private let cell = "EventosTableViewCell"
    var eventos =  [Eventos]()
    var eventosAnteriores = [Eventos]()
    var eventosFuturos = [Eventos]()
    var arregloActual = [Eventos]()
    var galeria = [GaleriaEventos]()
    var isProx:Bool = true
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true 
        containerView.isHidden = true
        segmentedControl.selectedSegmentIndex = 0
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        
        self.activity.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Eventos", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
    }
    
    func compareDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
          dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        let date = Date()
        let result = dateFormatter.string(from: date)
        self.eventosAnteriores.removeAll()
        self.eventosFuturos.removeAll()
        self.arregloActual.removeAll()
        let newDate = removeTimeStamp(fromDate: date)
        
        for i in self.eventos{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
              dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
            if let dateTemp = dateFormatter.date(from: i.fecha) {
         
                if newDate < dateTemp {
                
                    eventosFuturos.append(i)
                    print("la fecha es menor")
                }else if newDate > dateTemp  {
                    eventosAnteriores.append(i)
                    print("la fecha es mayor")
                    
                } else if newDate == dateTemp {
                    print("la fecha es igual")
                     eventosFuturos.append(i)
                }
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
         
            isProx = true
            isProximos = true 
            self.arregloActual = self.eventosFuturos
           
        } else if segmentedControl.selectedSegmentIndex == 1 {
            isProx = false
            self.arregloActual = self.eventosAnteriores
           
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Tools.clearAllFilesFromTempDirectory()
        
        APIManager.sharedInstance.getEventos(onSuccess: { response in
          
            DispatchQueue.main.async {
                self.eventos = []
                self.activity.isHidden = false
                self.activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                
                if response.code == 200 {
                    self.eventos = response.data
                    
                    self.tableView.reloadData()
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.compareDate()
                    
                }else{
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                    self.view.isUserInteractionEnabled = true
                }
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arregloActual.count
    }
    
    func getMonth(mes:String)->String{
        switch mes {
        case "01":
            return "Ene"
        case "02":
            return "Feb"
        case "03":
            return "Mar"
        case "04":
            return "Abr"
        case "05":
            return "May"
        case "06":
            return "Jun"
        case "07":
            return "Jul"
        case "08":
            return "Agos"
        case "09":
            return "Sept"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dic"
        
        default:
            return "Error"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isProx{
            print("mes \(self.arregloActual[indexPath.row].fecha)")
            var fechaMes = String(self.arregloActual[indexPath.row].fecha)[3 ..< 5]
            fechaMes = getMonth(mes: fechaMes)
            let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! EventosTableViewCell
            cel.lugarEventoLabel.text! = self.arregloActual[indexPath.row].ubicacion
            cel.nameEventoLabel.text! = self.arregloActual[indexPath.row].nombre
            cel.fechaEventoLabel.text! = fechaMes
            cel.fecha.text! = String(self.arregloActual[indexPath.row].fecha.prefix(2))
            cel.infoButtonWasPressed = {
                
            }
            return cel
            
        }else{
            let cel = tableView.dequeueReusableCell(withIdentifier: "EventosProximosViewController", for: indexPath as IndexPath) as! EventosProximosViewController
            cel.imagen.downloadedFrom(link: self.arregloActual[indexPath.row].imagen, contentMode: .scaleAspectFill)
            cel.titleEvents.text! = self.arregloActual[indexPath.row].nombre
            cel.subtTitleEvents.text! = self.arregloActual[indexPath.row].descripcion
            //var gal = arregloActual[indexPath.row].galeria[indexPath.row].ruta
            return cel
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! EventosTableViewCell
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleEventoViewController") as? DetalleEventoViewController
        
            vc?.detailEvent = self.arregloActual[indexPath.row]
            //vc?.idEvento = self.eventos[indexPath.row].id
          // vc?.urlEvento = self.galeria[indexPath.row].ruta
     
        self.navigationController?.pushViewController(vc!, animated: true)

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if isProx{
//            return 105
            return 84
         }else{
            return UIScreen.main.bounds.height * 0.3
        }
    }
    @IBAction func clickSegmentedControl(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            //containerView.isHidden = true
            //tableView.isHidden = false
            isProx = true
            self.arregloActual = self.eventosFuturos
            tableView.reloadData()
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            //containerView.isHidden = false
          //  tableView.isHidden = true
            isProx = false
             self.arregloActual = self.eventosAnteriores
            tableView.reloadData()
        }
    }
    
}
