//
//  ClaseCategoriasViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/2/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ClaseCategoriasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, OtherController {
    @IBOutlet weak var mesLabel: UILabel!
    
    
    func loadNewScreen(controller: UIViewController) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ClaseCategoriasDetailViewController") as? ClaseCategoriasDetailViewController
       vc?.htmlString = descriptionHtml
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    private let cellCollection = "ClaseCategoriasCollectionViewCell"
    private let cellTable = "ClaseCategoriasTableViewCell"
    var currentSelected = Date()
    let formatter = DateFormatter()
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var tabView: UITableView!
    
    //Termina la configuración del calendario.
    var days = [Int]()
    var daysDateFormat = [Date]()
    //var currentClub : Club = Club()
    //var reorder = APIManager.sharedInstance.reorderLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.delegate = self
        tabView.dataSource = self
        colleView.delegate = self
        colleView.dataSource = self
        activity.isHidden = true
        
        colleView.isUserInteractionEnabled = true
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: tituloClase, attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
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
               
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let indexPath : IndexPath = IndexPath(row: move, section: 0)
            
            self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
        
    }

    var hours : [String] = [String]()
     var clases : [String] = [String]()
    var localClasss : [ClassCategoria] = [ClassCategoria]()
    func updateCalendar(){
        
        
        DispatchQueue.main.async {
            self.activity.isHidden = false
            self.activity.startAnimating()
            self.view.isUserInteractionEnabled = false
            self.hours = []
            self.tabView.reloadData()
        
            
            
            
            APIManager.sharedInstance.getClasessByCategoria(date:self.currentSelected,idClase: ffff, onSuccess: { classResponse in
                DispatchQueue.main.async {
                    
                    self.activity.isHidden = false
                    self.activity.startAnimating()
                    self.view.isUserInteractionEnabled = true
                    if  classResponse.status == false {
                        Alert.ShowAlert(title: "¡Lo sentimos!", message: "Servicio no disponible, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                    } else  {
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print(classResponse.data)
                        self.localClasss = classResponse.data.sorted(by: {$0.distance < $1.distance})
                        self.hours = uniq(source: self.localClasss.map { $0.club})
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
    
        
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.activity.isHidden = false
        self.activity.startAnimating()
        APIManager.sharedInstance.getClasessByCategoria(date:self.currentSelected,idClase: ffff, onSuccess: { classResponse in
            DispatchQueue.main.async {
                print("okfokfoeskfposkfop", ffff)
             
                self.view.isUserInteractionEnabled = false
                if  classResponse.status == false {
                    Alert.ShowAlert(title: "¡Lo sentimos!", message: "Servicio no disponible, intenta mas tarde.", titleForTheAction: "Aceptar", in: self)
                } else  {
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    print(classResponse.data)
                    self.localClasss = classResponse.data.sorted(by: {$0.distance < $1.distance})
                    self.hours = uniq(source: self.localClasss.map { $0.club})
                    self.tabView.reloadData()
                }
            }
            
        }, onFailure: { error in
            self.activity.isHidden = true
            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
        })
        
        
    
    }
    //MARK:- CONFIGURA LA VISTA DEL CALENDARIO.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cellCollection, for: indexPath as IndexPath) as! ClaseCategoriasCollectionViewCell
        cel.dayNumberLabel.text = String(days[indexPath.row])
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale!
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = "EEE"
        
        
        cel.dayLabel.text =  dateFormatter.string(from: self.daysDateFormat[indexPath.row])
        
        if(self.currentSelected.compare(self.daysDateFormat[indexPath.row]) == ComparisonResult.orderedSame ){
            var finalMonth =  self.currentSelected.getMonthName()
            mesLabel.text = finalMonth
            
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
        var finalMonth =  self.currentSelected.getMonthName()
        mesLabel.text = finalMonth
        for i in 0...(self.colleView.visibleCells.count - 1){
            let tempCell : ClaseCategoriasCollectionViewCell = self.colleView.visibleCells[i] as! ClaseCategoriasCollectionViewCell
            
            tempCell.dayNumberLabel.layer.borderWidth = 0.0
            tempCell.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            tempCell.dayNumberLabel.layer.cornerRadius = 0
            
        }
        let tempCellSelect : ClaseCategoriasCollectionViewCell = self.colleView.cellForItem(at: indexPath) as! ClaseCategoriasCollectionViewCell
        //tempCellSelect.dayNumberLabel.textColor = UIColor.red
        tempCellSelect.dayNumberLabel.layer.borderWidth = 2.0
        tempCellSelect.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
        tempCellSelect.dayNumberLabel.layer.cornerRadius = tempCellSelect.dayNumberLabel.bounds.width / 2
        self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        self.updateCalendar()
        
        
        
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
        
        return dateAsString
        
        //let dt : Date = dateFormatter.date(from: str)!
        //dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localClasss.filter({$0.club == self.hours[section]}).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTable, for: indexPath) as! ClaseCategoriasTableViewCell
        
        
        let items = self.localClasss.filter({$0.club == self.hours[indexPath.section]})
            .sorted(by: { lhs, rhs in
                let lhsDate = lhs.dateInicio(lhs.inicio)
                let rhsDate = rhs.dateInicio(rhs.inicio)
                return lhsDate < rhsDate
            })
        cell.delegate = self
        
        cell.hourLabel.text! = items[indexPath.row].formattedInicio(items[indexPath.row].inicio)
        cell.entrenadorLabel.text! = items[indexPath.row].instructor
        
        if(items[indexPath.row].inscrito){
            cell.hourLabel?.textColor = UIColor.green
            cell.entrenadorLabel?.textColor = UIColor.green
            
        }else{
            cell.hourLabel?.textColor = UIColor.white
            cell.entrenadorLabel?.textColor = UIColor.white
            
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touch")
        
        
        ExternosAPI.sharedInstance.tipoDeUsuario(completion: { tipo in
            
            DispatchQueue.main.async {
                switch tipo {
                case 1,2:
                    
                    let items = self.localClasss.filter({$0.club == self.hours[indexPath.section]})
                        .sorted(by: { lhs, rhs in
                            let lhsDate = lhs.dateInicio(lhs.inicio)
                            let rhsDate = rhs.dateInicio(rhs.inicio)
                            return lhsDate < rhsDate
                        })
                    self.reservacion(items: items,indexPath: indexPath,tableView)
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
    
    func reservacion(items: [ClassCategoria],indexPath: IndexPath,_ tableView: UITableView){
        let dateAsString = String(format: "%@ %@",
                                  items[indexPath.row].iniciovigencia,
                                  items[indexPath.row].inicio)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date = dateFormatter.date(from: dateAsString)
        let now = Date()
        
        self.activity.isHidden = false
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        
        let params : [String:Any] = ["classdate": items[indexPath.row].iniciovigencia,
                                     "user_id" : SavedData.getTheUserId(),
                                     "employed_id" :0,
                                     "origin" : 4,
                                     "confirm" : 0,
                                     "idconfirm" : 1,
                                     "idinstactprg" : items[indexPath.row].idinstalacionactividadprogramada]
        if(!items[indexPath.row].inscrito){
            if(now < date!){
                APIManager.sharedInstance.makeReservation(params: params , onSuccess: { result in
                    
                    DispatchQueue.main .async {
                        
                        
                        if(result.status == true){
                            items[indexPath.row].inscrito = true
                            let cell = tableView.cellForRow(at: indexPath) as!  ClaseCategoriasTableViewCell
                            //cell.backgroundColor = UIColor.red
                            cell.hourLabel?.textColor = UIColor.green
                            cell.entrenadorLabel?.textColor = UIColor.green
                            Alert.ShowAlert(title: "Reservación", message: "Tu clase ha sido reservada", titleForTheAction: "Aceptar", in: self)
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
            }else{
                Alert.ShowAlert(title: "Reservación", message: "No puedes reservar clases anteriores a la fecha y hora", titleForTheAction: "Aceptar", in: self)
                
                self.activity.isHidden = true
                self.activity.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }else{
            
            let dateTime = String(format: "%@ %@",
                                  items[indexPath.row].iniciovigencia,
                                  items[indexPath.row].inicio)
            
            let params = [
                "personaact": "\(SavedData.getTheUserId())",
                "fechahora": dateTime,
                "idclub": "0",
                "idsalon": "\(items[indexPath.row].idsalon)",
                "idclase": "\(items[indexPath.row].idclase)",
                "usuario": "mefistoxxx",
                "instalacionactprogramada": "\(items[indexPath.row].idinstalacionactividadprogramada)"
                ] as [String : String]
            APIManager.sharedInstance.cancelReservation(params: params , onSuccess: { result in
                
                DispatchQueue.main .async {
                    
                    if(result.status == true){
                        items[indexPath.row].inscrito = false
                        let cell = tableView.cellForRow(at: indexPath) as!  ClaseCategoriasTableViewCell
                        cell.hourLabel?.textColor = UIColor.white
                        cell.entrenadorLabel?.textColor = UIColor.white
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


}



