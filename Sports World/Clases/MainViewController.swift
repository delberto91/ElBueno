//
//  MainViewController.swift
//  Sports World
//  Created by Aldo Gutierrez Montoya on 2/27/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    private var cell = "MainCollectionViewCell"
    var locManager = CLLocationManager()
    var reservaCorrecta:Bool = false
    var encuestasPendientes:[DatosEncuesta] = [DatosEncuesta]()
    
    @IBOutlet weak var mesLabel: UILabel!
    @IBAction func picker(_ sender: Any) {
        print("*")
        if(self.picker.isHidden){
            self.picker.alpha = 1
            self.picker.isHidden = false
        }else{
            UIView.animate(withDuration: 1.0, animations: {
                self.picker.alpha = 0
            }) { (finished) in
                self.picker.isHidden = true
                self.view.endEditing(true)
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblTapped(sender:)))
                self.clubName.isUserInteractionEnabled = true
                self.clubName.addGestureRecognizer(tap)
                
            }
        }
        
    }
    
    
 
    
    var arrayOfDays = ["1", "2","3","4", "5"]
    
    let items = ["pizza", "deep dish pizza", "calzone"]
    
    let titles = ["Margarita", "BBQ Chicken", "Pepperoni", "sausage", "meat lovers", "veggie lovers", "sausage", "chicken pesto", "prawns", "mushrooms"]
    var currentSelected = Date()
    let formatter = DateFormatter()
    
    var pickerClubes : [Club] = [Club]()
    
    @IBOutlet weak var clubName: UILabel!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var categoriasView: UIView!
    @IBOutlet weak var informacionView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
   
    var currentLocation: CLLocation!

    //Termina la configuración del calendario.
    var days = [Int]()
    var daysDateFormat = [Date]()
    var currentClub : Club = Club()
    var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    //var reorder = APIManager.sharedInstance.reorderLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //profileImage.layer.cornerRadius = 100
        segmentedControl.layer.cornerRadius = 20
      
        let font = UIFont.init(name: "LarkeNeue-Regular", size: 15)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font!],
                                                for: .normal)
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
        /*
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            currentLocation = locManager.location
            SavedData.setTheLatitude(double: currentLocation.coordinate.latitude)
            SavedData.setTheLongitude(double: currentLocation.coordinate.longitude)
            
        }
        */
        if(APIManager.sharedInstance.reorderLocation()){
        }
        self.activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
         self.activity.activityIndicatorViewStyle = .whiteLarge
        self.activity.color = UIColor(red: 233/255, green: 37/255, blue: 48/255, alpha: 1.0)
        
       
        self.view.addSubview(self.activity)
        self.activity.isHidden = true
        APIManager.sharedInstance.mainClassViewController = self
        tabView.delegate = self
        tabView.dataSource = self
        colleView.delegate = self
        colleView.dataSource = self
        
        colleView.isUserInteractionEnabled = true
        formatter.dateFormat = "dd"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let result = formatter.string(from: currentSelected)
        print("date", result)
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        
        self.currentSelected = date
        var move = 0
        let minusValue = cal.component(.weekday, from: cal.date(byAdding: .day, value: -1, to: date)!)
        
        date = cal.date(byAdding: .day, value: -minusValue + 1, to: date)!
        for i in 1 ... (minusValue + 14) {
            let day = cal.component(.day, from: date)
            days.append(day)
            daysDateFormat.append(date)
            if(self.currentSelected == date){
                move = i - 1
            }
            date = cal.date(byAdding: .day, value: +1, to: date)!
            
        }
        
        print("Dias", days)
        print("Dias", days)
        
        segmentedControl.selectedSegmentIndex = 1
        
        //Customiza la navigationBar para que sea transparente.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        //Configura las vistas para mostrar las vistas del segmented
        
        informacionView.isHidden = true
        categoriasView.isHidden = true
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        if Reachability.isConnectedToNetwork() {
           
            
            self.currentClub = (APIManager.sharedInstance.allClubes.sorted(by: { $0.distance < $1.distance }).first)!
            APIManager.sharedInstance.selectedClub = self.currentClub
            self.clubName.text = self.currentClub.name
            
            
            self.pickerClubes = APIManager.sharedInstance.allClubes.filter({($0.group.uppercased() != "FAVORITOS") || ($0.group.uppercased() != "PRÓXIMAS APERTURAS")})
            
            self.pickerClubes = self.pickerClubes.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
            
            let tempclubes = self.pickerClubes
            var tempList = [Club]()
            for temp in tempclubes{
                
                if(tempList.filter({$0.name.uppercased() == temp.name.uppercased()}).count == 0){
                    tempList.append(temp)
                }else if(tempList.count == 0){
                    tempList.append(temp)
                }
            }
            self.pickerClubes = tempList
            
            //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
            //view.addGestureRecognizer(tap)
            
            let pickerRect = CGRect(x: 0, y: 80, width: self.view.bounds.width, height: self.view.bounds.height - 64)
            
            
            
            
            
            
            picker.frame = pickerRect
            picker.backgroundColor = UIColor.black
            picker.setValue(UIColor.white, forKeyPath: "textColor")
            
            picker.delegate = self
            picker.dataSource = self
            picker.isHidden = true
            view.addSubview(picker)
        } else {
            Alert.ShowAlert(title: "", message: "Ocurrió un error intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
            self.activity.isHidden = true
            self.activity.stopAnimating()
        }
      
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let indexPath : IndexPath = IndexPath(row: move, section: 0)
            
            self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblTapped(sender:)))
        self.clubName.isUserInteractionEnabled = true
        self.clubName.addGestureRecognizer(tap)
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
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 1.0, animations: {
            self.picker.alpha = 0
        }) { (finished) in
            self.picker.isHidden = true
            self.view.endEditing(true)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblTapped(sender:)))
            self.clubName.isUserInteractionEnabled = true
            self.clubName.addGestureRecognizer(tap)
            
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
   
    
    var hours : [String] = [String]()
    var localClasss : [ClassSW] = [ClassSW]()
    func updateCalendar(){
        
        
        DispatchQueue.main.async {
            self.activity.isHidden = false
            self.activity.startAnimating()
            self.view.isUserInteractionEnabled = false
          
            self.hours = []
            self.tabView.reloadData()
          
            
            APIManager.sharedInstance.getClasessByClub(date:self.currentSelected,idClub: APIManager.sharedInstance.selectedClub.clubId, onSuccess: { classResponse in
                DispatchQueue.main.async {
              
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    if  classResponse.status == false {
                        Alert.ShowAlert(title: "¡Lo sentimos!", message: "Servicio no disponible, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                    } else  {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    print(classResponse.data)
                    self.localClasss = classResponse.data.sorted(by: {$0.clase < $1.clase})
                    self.hours = uniq(source: classResponse.data.map { $0.inicio}).sorted()
                    self.tabView.reloadData()
                 
                       
                    }
                }
                
            }, onFailure: { error in
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            })
          
          
            }
        self.activity.isHidden = true
        self.activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
       
    }
    
    func getTheClubes() {
        APIManager.sharedInstance.getClubesForRegister(onSuccess: { json in
            
            DispatchQueue.main.async {
                
            }
        }, onFailure: { error in
            
        })
        
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: self.pickerClubes[row].name, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
    }
    var picker = UIPickerView()
    @IBAction func lblTapped(sender: UITapGestureRecognizer) {
        print("*")
        picker.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerClubes .count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentClub = self.pickerClubes[row]
        APIManager.sharedInstance.selectedClub = self.currentClub
        self.clubName.text = self.currentClub.name
        //self.picker.isHidden = true
        
        
        APIManager.sharedInstance.infoVC.updateValues()
        self.updateCalendar()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.picker.alpha = 0
        }) { (finished) in
            
            self.picker.isHidden = true
            self.view.endEditing(true)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblTapped(sender:)))
            self.clubName.isUserInteractionEnabled = true
            self.clubName.addGestureRecognizer(tap)
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerClubes[row].name
    }
    
    deinit {
        print("\(#function)")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func getNotoficacion() {
        APIManagerV.sharedInstance.notificacionAlta(tipoDispositivo: 0, type: 1, onSuccess: { response in
            
            
            DispatchQueue.main.async {
                
                if response.code == 200 {
                    
                    print("Se consumió bien el servicio en appDelegate")
                } else {
                    print("Se consumió mal el servicio en appDelegate")
                }
            }
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        var currentLocation: CLLocation!
        self.getNotoficacion()
        
     
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
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

        if(APIManager.sharedInstance.reorderLocation()){
        }

        
        self.htmlString = ""
        self.selectedTag = 0
        if(!self.comesFromWebView){
            //self.getTheClubes()
            
            self.clubName.text = APIManager.sharedInstance.selectedClub.name
            self.updateCalendar()
            APIManager.sharedInstance.infoVC.updateValues()
        }else{
            
        }
        self.comesFromWebView = false
        
       
        
    }
    //MARK:- CONFIGURA LA VISTA DEL CALENDARIO.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath) as! MainCollectionViewCell
        cel.dayNumberLabel.text = String(days[indexPath.row])
        

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale!
          dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.dateFormat = "EEE"
        
        cel.dayLabel.text =  dateFormatter.string(from: self.daysDateFormat[indexPath.row])
        var finalDate = self.daysDateFormat[indexPath.row]
        var finalMonth = finalDate.getMonthName()
        mesLabel.text = finalMonth
        if let date = formatter.date(from: cel.dayLabel.text!) {
            let dateString = formatter.string(from: date)
            
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
            
            
            
        }
        
        if(self.currentSelected.compare(self.daysDateFormat[indexPath.row]) == ComparisonResult.orderedSame ){
            
            cel.dayNumberLabel.layer.borderWidth = 2.0
            cel.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
            cel.dayNumberLabel.layer.cornerRadius = cel.dayNumberLabel.bounds.width / 2
            
        }else{
            //cel.dayNumberLabel.textColor = UIColor.white
            
            cel.dayNumberLabel.layer.borderWidth = 0.0
            cel.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            cel.dayNumberLabel.layer.cornerRadius = 0
        }
        return cel
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelected = self.daysDateFormat[indexPath.row];
        var finalMonth = self.currentSelected.getMonthName()
        mesLabel.text = finalMonth
        for i in 0...(self.colleView.visibleCells.count - 1){
            let tempCell : MainCollectionViewCell = self.colleView.visibleCells[i] as! MainCollectionViewCell
            
            
            //tempCell.dayNumberLabel.textColor = UIColor.white
            
            tempCell.dayNumberLabel.layer.borderWidth = 0.0
            tempCell.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            tempCell.dayNumberLabel.layer.cornerRadius = 0
            
        }
        let tempCellSelect : MainCollectionViewCell = self.colleView.cellForItem(at: indexPath) as! MainCollectionViewCell
        //tempCellSelect.dayNumberLabel.textColor = UIColor.red
        tempCellSelect.dayNumberLabel.layer.borderWidth = 2.0
        tempCellSelect.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
        tempCellSelect.dayNumberLabel.layer.cornerRadius = tempCellSelect.dayNumberLabel.bounds.width / 2
        self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        self.updateCalendar()
        
        
        
    }
    
    //MARK:- BOTONES
    
    @IBAction func clickMenuButton(_ sender: Any) {
        DispatchQueue.main.async {
            
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        }
    }
    
    @IBAction func clickMapaButton(_ sender: Any) {
      activity.isHidden = false
      activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        LocationReporter.shared.userLocation.observe { [weak self] result in
            switch result {
            case let .value(location):
                SavedData.setTheLatitude(double: location.coordinate.latitude)
                SavedData.setTheLongitude(double: location.coordinate.longitude)
                
                if(APIManager.sharedInstance.reorderLocation()){
                    if let VC1 = self?.storyboard!.instantiateViewController(withIdentifier: "ClubesViewController") as? ClubesViewController {
                        self?.navigationController!.pushViewController(VC1, animated: true)
                        self?.activity.isHidden = true
                        self?.activity.stopAnimating()
                        self?.view.isUserInteractionEnabled = true
                      
                    }
                    
                }
                
            case let .failure(error):
                print(error)
                self?.activity.isHidden = true
                self?.activity.stopAnimating()
                self?.view.isUserInteractionEnabled = true
               
            }
        }
        
      
    }
    @IBAction func clickSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            informacionView.isHidden = false
            categoriasView.isHidden = true
            tabView.isHidden = true
            mesLabel.isHidden = true
            
        } else if sender.selectedSegmentIndex == 1 {
            informacionView.isHidden = true
            categoriasView.isHidden = true
            tabView.isHidden = false
            mesLabel.isHidden = false 
            
        } else if sender.selectedSegmentIndex == 2 {
            informacionView.isHidden = true
            categoriasView.isHidden = false
            tabView.isHidden = true
            
        }
    }
    //MARK:- TableView
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "LarkeNeueBold-Bold", size: 20)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.hours.count //titles.count
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateAsString = self.hours[section]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date = dateFormatter.date(from: dateAsString)
        //let date: Date = dateFormatter.date(from:  dateFormatter.string(from: dateAsString))!
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
        
        //let dt : Date = dateFormatter.date(from: str)!
        //dateFormatter.timeZone = TimeZone(abbreviation: "PST")

    }
    
    
    //  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //    return titles
    // }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localClasss.filter({$0.inicio == self.hours[section]}).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClasesTableViewCell", for: indexPath) as! ClasesTableViewCell
        
        let tempClass = self.localClasss.filter({$0.inicio == self.hours[indexPath.section]})[indexPath.row]
        
        cell.tag = tempClass.idclase
        cell.nameLabel.text! = tempClass.clase
        cell.instructorName.text! = tempClass.instructor
        
        if(tempClass.inscrito){
            cell.nameLabel?.textColor = UIColor.green
            cell.instructorName?.textColor = UIColor.green
            
        }else{
            cell.nameLabel?.textColor = UIColor.white
            cell.instructorName?.textColor = UIColor.white
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touch")
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        ExternosAPI.sharedInstance.tipoDeUsuario(completion: { tipo in
            
            DispatchQueue.main.async {
                switch tipo {
                case 1,2:
                    let tempClass = self.localClasss.filter({$0.inicio == self.hours[indexPath.section]})[indexPath.row]
                    self.reservacion(tempClass: tempClass,indexPath: indexPath,tableView)
                    break;
                case 3:
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Externos", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "AlertaExternosA") as! AlertaExternosViewController
                    self.navigationController?.pushViewController(newViewController, animated: true)
                    break;
                default:
                    break;
                }
            }
            
        })
        
        
    }
    
    func reservacion(tempClass: ClassSW,indexPath: IndexPath,_ tableView: UITableView){
        let dateAsString = String(format: "%@ %@",
                                  tempClass.iniciovigencia,
                                  tempClass.inicio)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        let date = dateFormatter.date(from: dateAsString)
        let now = Date()
        
        
        
        
        let params : [String:Any] = ["classdate": tempClass.iniciovigencia,
                                     "user_id" : SavedData.getTheUserId(),
                                     "employed_id" :0,
                                     "origin" : 4,
                                     "confirm" : 0,
                                     "idconfirm" : 1,
                                     "idinstactprg" : tempClass.idinstalacionactividadprogramada]
        if(!tempClass.inscrito){
            if(now < date!){
                APIManager.sharedInstance.makeReservation(params: params , onSuccess: { result in
                    
                    DispatchQueue.main .async {
                        
                        
                        if(result.status == true){
                            self.localClasss.filter({$0.inicio == self.hours[indexPath.section]})[indexPath.row].inscrito = true
                            let cell = tableView.cellForRow(at: indexPath) as!  ClasesTableViewCell
                            //cell.backgroundColor = UIColor.red
                            cell.nameLabel?.textColor = UIColor.green
                            cell.instructorName?.textColor = UIColor.green
                            self.reservaCorrecta = true
                            Alert.ShowAlert(title: "Reservación", message: "Tu clase ha sido reservada", titleForTheAction: "Aceptar", in: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                APIManager.sharedInstance.getEncuestasPendientes(onSuccess: {response in
                                    DispatchQueue.main.async {
                                        if response.status == true {
                                            print("correcto \(response.data)")
                                            self.encuestasPendientes = response.data
                                            if self.encuestasPendientes.count > 0{
                                                self.performSegue(withIdentifier: "segueCalifica", sender: nil)
                                            }
                                        }
                                    }})
                                
                            }
                        }else{
                            Alert.ShowAlert(title: "", message: result.message, titleForTheAction: "Aceptar", in: self)
                        }
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                    }
                }, onFailure: { error in
                    
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    
                })
            }else{
                Alert.ShowAlert(title: "Reservación", message: "No puedes reservar clases anteriores a la fecha y hora", titleForTheAction: "Aceptar", in: self)
                reservaCorrecta = false
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
            // if reservaCorrecta {
            
            //   reservaCorrecta = false
            // }
        }else{
            reservaCorrecta = false
            let dateTime = String(format: "%@ %@",
                                  tempClass.iniciovigencia,
                                  tempClass.inicio)
            
            let params = [
                "personaact": "\(SavedData.getTheUserId())",
                "fechahora": dateTime,
                "idclub": "0",
                "idsalon": "\(tempClass.idsalon)",
                "idclase": "\(tempClass.idclase)",
                "usuario": "mefistoxxx",
                "instalacionactprogramada": "\(tempClass.idinstalacionactividadprogramada)"
                ] as [String : String]
            APIManager.sharedInstance.cancelReservation(params: params , onSuccess: { result in
                
                DispatchQueue.main .async {
                    
                    if(result.status == true){
                        self.localClasss.filter({$0.inicio == self.hours[indexPath.section]})[indexPath.row].inscrito = false
                        let cell = tableView.cellForRow(at: indexPath) as!  ClasesTableViewCell
                        cell.nameLabel?.textColor = UIColor.white
                        cell.instructorName?.textColor = UIColor.white
                        Alert.ShowAlert(title: "Reservación", message: "Tu clase ha sido cancelada", titleForTheAction: "Aceptar", in: self)
                    }else{
                        Alert.ShowAlert(title: "Reservación", message: result.message, titleForTheAction: "Aceptar", in: self)
                    }
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                
            }, onFailure: { error in
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            })
        }
    }
    
    
    func loadWebView(){
        self.performSegue(withIdentifier: "showWebView", sender: nil)
    }
    var htmlString : String = String()
    var selectedTag : Int = 0
    var comesFromWebView : Bool = Bool()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showWebView"){
            let vc : WebVC = (segue.destination as? WebVC)!
            vc.htmlString = self.htmlString
            self.comesFromWebView = true
            vc.titlesString = (self.localClasss.filter({$0.idclase == self.selectedTag}).first?.clase)!
        }
    }
    
}

