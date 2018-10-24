//
//  CalendarioInBodyViewController.swift
//  Sports World
//
//  Created by VicktorManuel on 7/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//


import CoreLocation
import UIKit
import JTAppleCalendar
import SwiftyJSON
import EventKit
var isoDate: String = ""
class CalendarioInBodyViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var monthLabel: UILabel!
    var ishorarioTouched: Bool!
    var moveIndex : Int = 0
    var year : Int = 0
    var month : Int = 0
    var countCells = 0
    var dateSelected = ""
     var locManager = CLLocationManager()
    var acceptSaveToCalendar = Bool()
    @IBOutlet weak var cerrarBtn: UIButton!
    @IBOutlet weak var enviarButton: UIButton!
    
   
    var mesSelect: Int = 0
    @IBOutlet weak var nueve: UIButton!
    @IBOutlet weak var cinco: UIButton!
    @IBOutlet weak var doce: UIButton!
    var tempClub : ClubInBody = ClubInBody()
    let formatter = DateFormatter()
    var arregloFechas:[String] = [String]()
    var itemsHorario = [[String:[String:Int]]]()
    var cambiarColor:Bool = false
    var currentClub : ClubInBody = ClubInBody()
    
    @IBOutlet weak var clubName: UILabel!
    //Picker
    var pickerClubes : [ClubInBody] = [ClubInBody]()
    var picker = UIPickerView()
    
    //Selecciona Horario
    var horarioSeleccionado = "8:00"
    //Fecha solicitud
    var fechaSeleccionada = "2018-11-30"
    
    @IBOutlet weak var mesSiguienteLabel: UIButton!
    @IBOutlet weak var atrasMes: UIButton!
    @IBOutlet weak var calendarioAmor: UICollectionView!
    
    //Picker horario
    
    @IBOutlet weak var pickerHorarios: UIPickerView!
    
    @IBOutlet weak var horarioLabel: UILabel!
    
    @IBOutlet weak var pickerHorarioOpenButton: UIButton!
    var horas:[String] = [String]()
    var currentLocation: CLLocation!
    var fecha:String!
    var hora:String!
    var idClub:Int!
    var idAgenda:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ishorarioTouched = false
     activity.isHidden = true 
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back_button"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        LocationReporter.shared.userLocation.observe { [weak self] result in
            switch result {
            case let .value(location):
                self?.currentLocation = location
                SavedData.setTheLatitude(double: location.coordinate.latitude)
                SavedData.setTheLongitude(double: location.coordinate.longitude)
            case let .failure(error):
                print(error)
            }
        }
        
        calendarioAmor.isHidden = true
        cerrarBtn.isHidden = true
        self.clubName.text = "Seleccionar un club"

       
        pickerHorarioOpenButton.isHidden = true
        horarioLabel.isHidden = true
        atrasMes.isHidden = true
        var date = Date()
        var calendar = Calendar.current
        mesSelect = calendar.component(.month, from: date)
        /*
        if !SavedData.getInBody(){
            backGround.isHidden = false
            SavedData.setInBody(isInBody: true)
        }else{
            backGround.isHidden = true
            
        }
        */
        
        enviarButton.layer.cornerRadius = 8
        
        APIManager.sharedInstance.getClubsInBody(onSuccess: { json in
            DispatchQueue.main.async {
                if(json.code == 200){
                    //self.pickerClubes.insert(currentClub.seleccionaUnclub, at: 0)
                    self.pickerClubes = json.data
                    let clubTemp:ClubInBody = ClubInBody()
                    clubTemp.name = "Selecciona un club"
                    self.pickerClubes.insert(clubTemp, at: 0)
                    print(self.pickerClubes.count)
                    
                    self.picker.reloadAllComponents()
                   self.pickerClubes = self.pickerClubes.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
                    let tempclubes = self.pickerClubes
                    var tempList = [ClubInBody]()
                    for temp in tempclubes{
                        
                        if(tempList.filter({$0.name.uppercased() == temp.name.uppercased()}).count == 0){
                            tempList.append(temp)
                        }else if(tempList.count == 0){
                            tempList.append(temp)
                        }
                    }
                    self.pickerClubes = tempList
                    clubTemp.name = "Selecciona un club"
                    self.pickerClubes.insert(clubTemp, at: 0)
                    }else{
                     Alert.ShowAlert(title: "Algo paso 😳", message: "No cargaron correctamente los clubs", titleForTheAction: "Aceptar", in: self)
                    }
                }
            })
        
     
        
        let pickerRect = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 64)
        
        let pickerRect2 = CGRect(x: 0, y: 300, width: self.view.bounds.width, height: self.view.bounds.height - 64)
        
        
        picker.frame = pickerRect
        picker.backgroundColor = UIColor.black
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.tag = 0
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        view.addSubview(picker)
        //picker horarios
        pickerHorarios.backgroundColor = UIColor.black
        pickerHorarios.setValue(UIColor.white, forKey: "textColor")
        
        pickerHorarios.delegate = self
        pickerHorarios.dataSource = self
        pickerHorarios.isHidden = true
        pickerHorarios.tag = 1
        
        // Do any additional setup after loading the view, typically from a nib.
        self.cinco.layer.cornerRadius = self.cinco.bounds.height / 2
        self.cinco.layer.borderWidth = 2
        self.cinco.layer.borderColor = UIColor.white.cgColor
        
        self.nueve.layer.cornerRadius = self.cinco.bounds.height / 2
        self.nueve.layer.borderWidth = 2
        self.nueve.layer.borderColor = UIColor.white.cgColor
        
        self.doce.layer.cornerRadius = self.cinco.bounds.height / 2
        self.doce.layer.borderWidth = 2
        self.doce.layer.borderColor = UIColor.white.cgColor
        
        self.calendarioAmor.delegate = self
        self.calendarioAmor.dataSource = self
        self.horarioSeleccionado = ""
        //updateCalendar()
        
    }
    @objc func back(){
        //performSegue(withIdentifier: "backSegue", sender: nil)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickEnPicker(_ sender: Any){
        print("hola mundo")
    }
    
  
    @IBAction func hiddenPicker(_ sender: Any) {
       /* self.pickerHorarios.isHidden = true
        self.picker.isHidden = true
        self.cerrarBtn.isHidden = true
        
        self.updateCalendar()*/
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citaSegue"{
            let vc = segue.destination as! CitaAgendadaViewController
            /*self.fecha = i.fechaSolicitud
            self.hora = i.horario
            self.idClub = i.idUn*/
            vc.fecha = self.fecha
            vc.horario = self.hora
            vc.idUNTemp = self.idClub
            vc.idAgenda = self.idAgenda
        }
    }
    //Asigno horas
    func asignarHorasPorHorario(fecha:String){
        horas.append("hora")
      

        print(fecha)
        horas.removeAll()
        
        self.horas.append("Selecciona un horario")
        for i in self.horariosTemp{
        
            if fecha == i.fecha{
                 
                for e in i.hora{
                    horas.append(e)
                   
                }
            }
        }
        pickerHorarios.reloadAllComponents()
    }
    
    @IBAction func agendarCitaAction(_ sender: Any) {
        //backGround.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        var date = Date()
        var calendar = Calendar.current
        
        self.year = calendar.component(.year, from: date)
        self.month = calendar.component(.month, from: date)
        
        let dateComponents = DateComponents(year: self.year, month: mesSelect)
        calendar = Calendar.current
        date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        let cal = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
          dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        var dateComponentsTemp = DateComponents()
        dateComponentsTemp.year = self.year
        dateComponentsTemp.month = self.mesSelect
        dateComponentsTemp.day = 1
        
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponentsTemp)
        
        self.moveIndex = cal.component(.weekday, from: someDateTime!) - 1
        
        self.countCells = numDays + self.moveIndex
        return self.countCells
        
    }
    
    
    func getMonth(month:Int) -> String{
        switch month {
        case 1:
            return "Enero"
            break
        case 2:
            return "Febrero"
            break
        case 3:
            return "Marzo"
            break
        case 4:
            return "Abril"
            break
        case 5:
            return "Mayo"
            break
        case 6:
            return "Junio"
            break
        case 7:
            return "Julio"
            break
        case 8:
            return "Agosto"
            break
        case 9:
            return "Septiembre"
            break
        case 10:
            return "Octubre"
            break
        case 11:
            return "Noviembre"
            break
        case 12:
            return "Diciembre"
            break
        default:
            return ""
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CalendarCollectionViewCell
        cel.dayLabel.textColor = UIColor.white
        cel.dayLabel.alpha = 0.5
        if(indexPath.row >= moveIndex){
            cel.dayLabel.text = "\(indexPath.row - moveIndex + 1)"
            
            var dateComponentsTemp = DateComponents()
            dateComponentsTemp.year = self.year
           /* dateComponentsTemp.month = self.month
            monthLabel.text = getMonth(month: self.month)*/
            dateComponentsTemp.month = mesSelect
            monthLabel.text = getMonth(month: mesSelect)
            
            dateComponentsTemp.day = indexPath.row - moveIndex + 1
            
            // Create date from components
            let userCalendar = Calendar.current // user calendar
            let someDateTime = userCalendar.date(from: dateComponentsTemp)
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "es_MX_POSIX")
            let fechaTem : String = formatter.string(from: someDateTime!)
            if(self.arregloFechas.filter({$0 == fechaTem}).count > 0){
                cel.dayLabel.textColor = UIColor.white
                cel.dayLabel.alpha = 1
            }
            
            
        }else{
            cel.dayLabel.text = ""
        }
        
        cel.dayLabel.layer.cornerRadius = cel.dayLabel.bounds.width / 2
        cel.dayLabel.layer.borderWidth = 2
        return cel
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        for i in 0...(self.countCells - 1) {
            // do something
            let cell : CalendarCollectionViewCell? = self.calendarioAmor.cellForItem(at:  IndexPath(row: i, section: 0)) as? CalendarCollectionViewCell
            cell?.dayLabel.layer.borderColor = UIColor.clear.cgColor
        }
        let tempCellSelect : CalendarCollectionViewCell = self.calendarioAmor.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        
        var dateComponentsTemp = DateComponents()
        dateComponentsTemp.year = self.year
        dateComponentsTemp.month = mesSelect
        dateComponentsTemp.day = indexPath.row - moveIndex + 1
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponentsTemp)
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let fechaTem : String = formatter.string(from: someDateTime!)
        if(self.arregloFechas.filter({$0 == fechaTem}).count > 0){
            tempCellSelect.dayLabel.layer.borderColor = UIColor.white.cgColor
            self.dateSelected = fechaTem
            self.asignarHorasPorHorario(fecha: fechaTem)
            pickerHorarioOpenButton.isHidden = false
            horarioLabel.isHidden = false
        }
  
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print((calendarioAmor.frame.width)/7)
        return CGSize(width:(calendarioAmor.frame.width)/7, height: (calendarioAmor.frame.width)/7)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // calendarioAmor.isHidden = false
        if pickerView.tag == 0{
            return self.pickerClubes.count
        }else{
            return self.horas.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // calendarioAmor.isHidden = false
        if pickerView.tag == 0{
            return self.pickerClubes[row].name
        }else{
            return self.horas[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
           calendarioAmor.isHidden = false
            self.currentClub = self.pickerClubes[row]
            //APIManager.sharedInstance.selectedClub = self.currentClub
            self.clubName.text = self.currentClub.name
            //APIManager.sharedInstance.infoVC.updateValues()
            self.horarioSeleccionado = ""
            self.dateSelected = ""
            
            self.cinco.layer.cornerRadius = self.cinco.bounds.height / 2
            self.cinco.layer.borderWidth = 2
            self.cinco.layer.borderColor = UIColor.white.cgColor
            self.cinco.setTitleColor(UIColor.white, for: .normal)
            self.cinco.backgroundColor = UIColor.clear
            
            self.nueve.layer.cornerRadius = self.cinco.bounds.height / 2
            self.nueve.layer.borderWidth = 2
            self.nueve.layer.borderColor = UIColor.white.cgColor
            self.nueve.setTitleColor(UIColor.white, for: .normal)
            self.nueve.backgroundColor = UIColor.clear
            
            self.doce.layer.cornerRadius = self.cinco.bounds.height / 2
            self.doce.layer.borderWidth = 2
            self.doce.layer.borderColor = UIColor.white.cgColor
            self.doce.setTitleColor(UIColor.white, for: .normal)
            self.doce.backgroundColor = UIColor.clear
            
            
            UIView.animate(withDuration: 1.0, animations: {
                self.picker.alpha = 0
            }) { (finished) in
                self.picker.isHidden = true
                self.view.endEditing(true)
                let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.clickEnPicker(_:)))
                self.clubName.isUserInteractionEnabled = true
                self.clubName.addGestureRecognizer(tap2)
                self.updateCalendar()
                
            }
        }else{
            horarioSeleccionado = self.horas[row]
            self.pickerHorarios.isHidden = true
            self.horarioLabel.text = self.horas[row]
            
        }
    }
    
    @objc func lblTapped(sender: Any) {
        print("*")
        
        picker.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 0{
            return NSAttributedString(string: self.pickerClubes[row].name, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        }else{
             return NSAttributedString(string: self.horas[row], attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        }
    }
    
    
    @IBAction func picker(_ sender: Any) {
        print("*")
        self.picker.alpha = 1
        //self.cerrarBtn.isHidden = false
       // self.currentClub = self.pickerClubes.first!
        self.clubName.text = self.currentClub.name
        picker.isHidden = false
        calendarioAmor.isHidden = false
        
    }
    
    @IBAction func pickerHorario(_ sender: Any) {
         self.ishorarioTouched = true
         calendarioAmor.isHidden = false
        self.pickerHorarios.alpha = 1
        pickerHorarios.isHidden = false
        //self.cerrarBtn.isHidden = false
       // horarioSeleccionado = self.horas.first!
        // self.pickerHorarios.isHidden = true
        self.horarioLabel.text = self.horas.first!
    }
    
    @IBAction func backClick(_ sender: Any) {
        //let _ = self.navigationController?.popViewController(animated: true)
        // performSegue(withIdentifier: "backSegue", sender: nil)
        //dismiss(animated: true, completion: nil)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func enviarSolicitud(_ sender: Any) {
        
     agendadoUltimo = false
           
            if self.ishorarioTouched == false {
                Alert.ShowAlert(title: "", message: "Debes seleccionar un horario para continuar", titleForTheAction: "Aceptar", in: self)
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            } else {
                self.activity.isHidden = false
                self.activity.startAnimating()
                self.view.isUserInteractionEnabled = false
                print(self.dateSelected)
                var count = 0
                if(self.horarioSeleccionado != "" && self.dateSelected != ""){
                    print(self.dateSelected + " " + self.horarioSeleccionado)
                    print(self.currentClub.idUn)
                    self.activity.isHidden = false
                    self.activity.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    
                    APIManager.sharedInstance.hacerReservacion(horario: self.horarioSeleccionado, fechaSolicitud: self.dateSelected + " " + self.horarioSeleccionado + ":00", idClub: self.currentClub.idUn, onSuccess: { json in
                        DispatchQueue.main.async {
                            if(json.code == 200){
                                 isoDate = self.dateSelected + " " + self.horarioSeleccionado + ":00"
    
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    if count == 0{
                                        self.sendInBody()
                                        count += 1
                                    }
                                }
                                
                                self.activity.isHidden = true
                                self.activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                
                            }else{
                                self.activity.isHidden = true
                                self.activity.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                Alert.ShowAlert(title: "", message: json.message, titleForTheAction: "Aceptar", in: self)
                                
                            }
                        }
                        
                    })
                }else{
                    Alert.ShowAlert(title: "", message: "Selecciona una fecha y horario", titleForTheAction: "Aceptar", in: self)
                }
            }
            
       
    }
   
    
    
    

    @IBAction func siguienteMes(_ sender: Any) {
       
            self.mesSelect += 1
            mesSiguienteLabel.isHidden = true
            atrasMes.isHidden = false
        self.horarioSeleccionado = ""
        self.calendarioAmor.reloadData()
        self.reloadCalendar()
        
        
        
    }
    
   
    
    var horariosTemp : [Horarios] = [Horarios]()
    var horariosToShow : [Horarios] = [Horarios]()
    
    func updateCalendar(){
        if(self.countCells > 0){
            for i in 0...(self.countCells - 1) {
                // do something
                let cell : CalendarCollectionViewCell? = self.calendarioAmor.cellForItem(at:  IndexPath(row: i, section: 0)) as? CalendarCollectionViewCell
                cell?.dayLabel.layer.borderColor = UIColor.clear.cgColor
            }
        }
        self.arregloFechas = [String]()
        self.calendarioAmor.reloadData()
        
        APIManager.sharedInstance.getReservacionesInBody(clubId: self.currentClub.idUn,onSuccess: { json in
            DispatchQueue.main.async {
                if (json == JSON.null) {
                    print("Hubo un error")
                }else{
                    self.arregloFechas.removeAll()
                  
                    for fechas in APIManager.sharedInstance.horarios{
                        print(fechas.fecha)
                        
                        self.arregloFechas.append(fechas.fecha)
                        self.horariosTemp = APIManager.sharedInstance.horarios
                    }
                    print("Arreglo fechas:\(self.arregloFechas.count)")
                   
                    DispatchQueue.main.async {
                        self.horarioSeleccionado = "12:00"
                         self.reloadCalendar()
                        self.calendarioAmor.reloadData()
                    }
                    
                }
                
            }
        }, onFailure: { error in
            print(error)
        })
    }
    
    func configuracionCalendarioDeAmor(){
        //calendarioAmor.minimumLineSpacing = 0
        //calendarioAmor.minimumInteritemSpacing = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func atrasMesAction(_ sender: Any) {
        
        
        
        mesSiguienteLabel.isHidden = false
        atrasMes.isHidden = true
        var date = Date()
        var calendar = Calendar.current
        mesSelect = calendar.component(.month, from: date)
        self.horarioSeleccionado = "12:00"
        self.reloadCalendar()
        
        // updateCalendar()
        
    }
    
    @IBAction func sieteadoce(_ sender: Any) {
        self.horarioSeleccionado = "h7-12"
        
        self.cinco.layer.cornerRadius = self.cinco.bounds.height / 2
        self.cinco.layer.borderWidth = 2
        self.cinco.layer.borderColor = UIColor.white.cgColor
        self.cinco.setTitleColor(UIColor.white, for: .normal)
        self.cinco.backgroundColor = UIColor.clear
        
        self.nueve.layer.cornerRadius = self.cinco.bounds.height / 2
        self.nueve.layer.borderWidth = 2
        self.nueve.layer.borderColor = UIColor.white.cgColor
        self.nueve.setTitleColor(UIColor.white, for: .normal)
        self.nueve.backgroundColor = UIColor.clear
        
        self.doce.layer.cornerRadius = self.cinco.bounds.height / 2
        self.doce.layer.borderWidth = 2
        self.doce.layer.borderColor = UIColor.white.cgColor
        self.doce.setTitleColor(UIColor.black, for: .normal)
        self.doce.backgroundColor = UIColor.white
        
        self.reloadCalendar()
    }
    @IBAction func cincoanueve(_ sender: Any) {
        self.horarioSeleccionado = "h17-21"
        
        self.cinco.layer.cornerRadius = self.cinco.bounds.height / 2
        self.cinco.layer.borderWidth = 2
        self.cinco.layer.borderColor = UIColor.white.cgColor
        self.cinco.setTitleColor(UIColor.white, for: .normal)
        self.cinco.backgroundColor = UIColor.clear
        
        self.nueve.layer.cornerRadius = self.cinco.bounds.height / 2
        self.nueve.layer.borderWidth = 2
        self.nueve.layer.borderColor = UIColor.white.cgColor
        self.nueve.setTitleColor(UIColor.black, for: .normal)
        self.nueve.backgroundColor = UIColor.white
        
        self.doce.layer.cornerRadius = self.cinco.bounds.height / 2
        self.doce.layer.borderWidth = 2
        self.doce.layer.borderColor = UIColor.white.cgColor
        self.doce.setTitleColor(UIColor.white, for: .normal)
        self.doce.backgroundColor = UIColor.clear
        
        self.reloadCalendar()
    }
    
    @IBAction func doceacinco(_ sender: Any) {
        self.horarioSeleccionado = "h12-17"
        
        self.cinco.layer.cornerRadius = self.cinco.bounds.height / 2
        self.cinco.layer.borderWidth = 2
        self.cinco.layer.borderColor = UIColor.white.cgColor
        self.cinco.setTitleColor(UIColor.black, for: .normal)
        self.cinco.backgroundColor = UIColor.white
        
        self.nueve.layer.cornerRadius = self.cinco.bounds.height / 2
        self.nueve.layer.borderWidth = 2
        self.nueve.layer.borderColor = UIColor.white.cgColor
        self.nueve.setTitleColor(UIColor.white, for: .normal)
        self.nueve.backgroundColor = UIColor.clear
        
        self.doce.layer.cornerRadius = self.cinco.bounds.height / 2
        self.doce.layer.borderWidth = 2
        self.doce.layer.borderColor = UIColor.white.cgColor
        self.doce.setTitleColor(UIColor.white, for: .normal)
        self.doce.backgroundColor = UIColor.clear
        
        self.reloadCalendar()
    }
    
    func sendInBody(){
        APIManager.sharedInstance.getReservasInBody(onSuccess: {
            reservas in
            DispatchQueue.main.async {
                if reservas.code == 200{
                    if reservas.data.count > 0{
                        for i in reservas.data{
                            self.fecha = i.fechaSolicitud
                            self.hora = i.horario
                            self.idClub = i.idUn
                            self.idAgenda = i.idAgenda
                        }
                        
                    }
                    
                        
                         let _ = self.navigationController?.popViewController(animated: true)
                    
                            self.performSegue(withIdentifier: "citaSegue", sender: nil)
                    
                    
                }
                
            }
        })
    }
    
    func reloadCalendar(){
        self.arregloFechas = [String]()
        if(self.countCells > 0){
            for i in 0...(self.countCells - 1) {
                // do something
                let cell : CalendarCollectionViewCell? = self.calendarioAmor.cellForItem(at:  IndexPath(row: i, section: 0)) as? CalendarCollectionViewCell
                cell?.dayLabel.layer.borderColor = UIColor.clear.cgColor
            }
        }
        //self.calendarioAmor = newc
        self.calendarioAmor.reloadData()
        for hourTemp in self.horariosTemp{
           // if(hourTemp.hora[self.horarioSeleccionado]! > 0){
                self.arregloFechas.append(hourTemp.fecha)
           // }
        }
        self.calendarioAmor.reloadData()
        //self.calendarioAmor.selectedDates
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarioAmor.isHidden = true
        
        var currentLocation: CLLocation!

        LocationReporter.shared.userLocation.observe { [weak self] result in
            switch result {
            case let .value(location):
                self?.currentLocation = location
                SavedData.setTheLatitude(double: location.coordinate.latitude)
                SavedData.setTheLongitude(double: location.coordinate.longitude)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status
        {
        case .authorizedWhenInUse:
            // locationManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locManager.startUpdatingLocation()
            break
            
        default:
            break
            // User denied access, handle as appropriate
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
   /* override func viewWillDisappear(_ animated: Bool) {
        
        
        if isMovingFromParentViewController{
          
        }
    }*/
}




