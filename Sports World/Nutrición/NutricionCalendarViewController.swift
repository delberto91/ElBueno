//
//  NutricionCalendarViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/25/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class NutricionCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var miSemanaLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var seleccionarMetaButton: UIButton!
    
    @IBOutlet weak var mesLabel: UILabel!
    private let cell = "NutricionCalendarTableViewCell"
     private let collectionCell = "NutricionCollectionViewCell"
    var days = [Int]()
    var daysDateFormat = [Date]()
    var currentSelected = Date()
    let formatter = DateFormatter()
     var dietas : [DietaPersonalizada] = [DietaPersonalizada]()
    var dietaP = DietaPersonalizada()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        
        containerView.isHidden = true 
        seleccionarMetaButton.layer.cornerRadius = 8
        APIManager.sharedInstance.nutritionVC = self
        self.view.isUserInteractionEnabled = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
     //   let font = UIFont.init(name: "LarkeNeue-Regular", size: 15)
     //   segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font!],
      //                                          for: .normal)

        segmentedControl.selectedSegmentIndex = 1
        
        tabView.delegate = self
        tabView.dataSource = self
        colleView.isHidden = false
        
        formatter.dateFormat = "dd"
        
        let result = formatter.string(from: currentSelected)
        print("date", result)
        
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        
        self.currentSelected = date
        var move = 0
        date = cal.date(byAdding: .day, value: -10, to: date)!
        for i in 1 ... 20 {
            let day = cal.component(.day, from: date)
            days.append(day)
            daysDateFormat.append(date)
            if(self.currentSelected == date){
                move = i - 1
            }
            date = cal.date(byAdding: .day, value: +1, to: date)!
            
        }
        
        
        
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icon_perfil"), style: .done, target: self, action: #selector(NutricionCalendarViewController.goTonAnotherViewController))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icono_receta"), style: .done, target: self, action: #selector(NutricionCalendarViewController.goToConfiguracion))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let titleLabel = UILabel()
         titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
     
         let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Mi plan", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        
       APIManager.sharedInstance.getDiet(meta:0 ,onSuccess: { response in
            
            DispatchQueue.main.async {
                
                if response.code == 200 {
                    self.containerView.isHidden = true
                } else {
                    self.containerView.isHidden = false 
                }
                self.showDiet(response: response)
                
                let currentDate = self.currentSelected
                guard
                    let day = Calendar.current.dateComponents([.day], from: currentDate).day,
                    let indexOf = self.days.index(of: day)
                    else {
                        return
                }
                let indexPath = IndexPath(item: Int(indexOf), section: 0)
                self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                let tempCellSelect: RutinasCollectionViewCell? = self.colleView.cellForItem(at: indexPath) as? RutinasCollectionViewCell
                //tempCellSelect.dayNumberLabel.textColor = UIColor.red
                tempCellSelect?.dayNumberLabel.layer.borderWidth = 2.0
                tempCellSelect?.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
                tempCellSelect?.dayNumberLabel.layer.cornerRadius = tempCellSelect?.dayNumberLabel.bounds.width ?? 0 / 2
                
                
            }
        })

    }
    var localdiets : [DietDateData] = [DietDateData] ()
    var localComida : [Comida] = [Comida] ()
    func showDiet(response: AsignMetaResponse){
        self.localdiets = response.data
        self.days = [Int]()
        self.daysDateFormat = [Date]()
        let cal = Calendar.current
        self.currentSelected = Date()
        var move = 0
        var i = 0
        for element in self.localdiets{
            let day = cal.component(.day, from: element.dia)
            self.days.append(day)
            self.daysDateFormat.append(element.dia)
            if(self.currentSelected == element.dia){
                move = i
            }
            i = i + 1
        }
        if(move == 0 && self.localdiets.count > 0 ){
//            self.currentSelected = self.localdiets[0].dia
        }
        self.colleView.reloadData()
        
        if(self.localdiets.count > 0){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                let indexPath : IndexPath = IndexPath(row: move, section: 0)
                
                let currentDate = self.currentSelected
                if
                    let day = Calendar.current.dateComponents([.day], from: currentDate).day,
                    let indexOf = self.days.index(of: day)
                     {
                        
                        
                        APIManager.sharedInstance.getDietById(id:self.localdiets[Int(indexOf)].cableDieta ,onSuccess: { response in
                            
                            DispatchQueue.main.async {
                                
                                //self.showDiet(response: response)
                                self.localComida = response.data
                                if(self.localComida.count == 0){
                                    
                                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                                }else{
                                    self.containerView.isHidden = true
                                    self.tabView.reloadData()
                                    
                                }
                            }
                            
                        })
                        
                        let indexPath = IndexPath(item: Int(indexOf), section: 0)
                        
                        let tempCellSelect: RutinasCollectionViewCell? = self.colleView.cellForItem(at: indexPath) as? RutinasCollectionViewCell
                        //tempCellSelect.dayNumberLabel.textColor = UIColor.red
                        tempCellSelect?.dayNumberLabel.layer.borderWidth = 2.0
                        tempCellSelect?.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
                        tempCellSelect?.dayNumberLabel.layer.cornerRadius = tempCellSelect?.dayNumberLabel.bounds.width ?? 0 / 2
                        
                        self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
                
                

                self.containerView.isHidden = true
                

            })
        }else{
            self.containerView.isHidden = true
            //Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.getDietaPersonalizada()
    }
    
 
  @objc  func goToConfiguracion() {
    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "RecetasViewController") as! RecetasViewController
    self.navigationController!.pushViewController(VC1, animated: true)
    }
    @objc func goTonAnotherViewController() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
////////////////////////////////////COLLECTIONVIEW////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelected = self.daysDateFormat[indexPath.row];
        var finalMonth =  self.currentSelected.getMonthName()
        mesLabel.text = finalMonth
        
        for i in 0...(self.colleView.visibleCells.count - 1){
            let tempCell : NutricionCollectionViewCell = self.colleView.visibleCells[i] as! NutricionCollectionViewCell
            
            
            //tempCell.dayNumberLabel.textColor = UIColor.white
            
            tempCell.dayNumberLabel.layer.borderWidth = 0.0
            tempCell.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            tempCell.dayNumberLabel.layer.cornerRadius = 0
            
        }
        let tempCellSelect : NutricionCollectionViewCell = self.colleView.cellForItem(at: indexPath) as! NutricionCollectionViewCell
        //tempCellSelect.dayNumberLabel.textColor = UIColor.red
        tempCellSelect.dayNumberLabel.layer.borderWidth = 2.0
        tempCellSelect.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
        tempCellSelect.dayNumberLabel.layer.cornerRadius = tempCellSelect.dayNumberLabel.bounds.width / 2
        
        self.colleView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        self.localComida = [Comida]()
        self.tabView.reloadData()
        APIManager.sharedInstance.getDietById(id:self.localdiets[indexPath.row].cableDieta ,onSuccess: { response in
            
            DispatchQueue.main.async {
                  
                //self.showDiet(response: response)
                self.localComida = response.data
                if(self.localComida.count == 0){
                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                }else{
                    self.tabView.reloadData()
                }
            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cal = Calendar.current
  let cel = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath as IndexPath) as! NutricionCollectionViewCell
//    cel.dayNumberLabel.text = String(days[indexPath.row] + 1)
        cel.dayNumberLabel.text = String(days[indexPath.row])
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale!
        dateFormatter.locale = Locale(identifier: "es_MX")
          dateFormatter.locale = Locale(identifier: "es_MX_POSIX")
        dateFormatter.dateFormat = "EEE"
//        cel.dayLabel.text =  dateFormatter.string(from: cal.date(byAdding: .day, value: +1, to: self.daysDateFormat[indexPath.row])!)
        cel.dayLabel.text =  dateFormatter.string(from: cal.date(byAdding: .day, value: 0, to: self.daysDateFormat[indexPath.row])!)
        
        
        let currentDate = self.currentSelected
        var finalMonth =  currentDate.getMonthName()
        mesLabel.text = finalMonth
        if
            let day = Calendar.current.dateComponents([.day], from: currentDate).day,
            let indexOf = self.days.index(of: day) {
            let selectedIndexPath = IndexPath(item: Int(indexOf), section: 0)
            if selectedIndexPath == indexPath {
                cel.dayNumberLabel.layer.borderWidth = 2.0
                cel.dayNumberLabel.layer.borderColor = UIColor.white.cgColor
                cel.dayNumberLabel.layer.cornerRadius = cel.dayNumberLabel.bounds.width / 2
            } else {
                cel.dayNumberLabel.layer.borderWidth = 0.0
                cel.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
                cel.dayNumberLabel.layer.cornerRadius = 0
            }
        } else {
            cel.dayNumberLabel.layer.borderWidth = 0.0
            cel.dayNumberLabel.layer.borderColor = UIColor.clear.cgColor
            cel.dayNumberLabel.layer.cornerRadius = 0
        }
        
   
        return cel 
    }
    

    
   //////TABLEVIEW////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localComida.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! NutricionCalendarTableViewCell
        cel.time.text = self.localComida[indexPath.row].horario
        cel.type.text = self.localComida[indexPath.row].tipo
        
        cel.dietaDescripcion.text = self.localComida[indexPath.row].descripcion
        return cel 
    }
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0

    }
   

    @IBAction func clickSeleccionarMetaButton(_ sender: Any) {
        containerView.isHidden = false 
    }
    
    @IBAction func clickSegmentedControl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
           
            webView.isHidden = false
            mesLabel.isHidden = true
              miSemanaLabel.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            webView.isHidden = true
            miSemanaLabel.isHidden = false
            mesLabel.isHidden = false 
        }
            
        
    }
    //Llama a dietas personalizadas.
    func getDietaPersonalizada() {
        //activity.showActivity(viewController: self)
        APIManagerV.sharedInstance.getDietaPersonalizada(onSuccess:  { response in
            
            DispatchQueue.main.async {
                
                self.dietas = response.data
                if response.code == 200 {
                  
                   self.webView.loadHTMLString(APIManagerV.sharedInstance.webContent, baseURL: nil)
                    
                } else {
                    
                
                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                }
            }
            
        })
    }


    
}
