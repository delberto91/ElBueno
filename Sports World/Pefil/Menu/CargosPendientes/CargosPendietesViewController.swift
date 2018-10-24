//
//  CargosPendietesViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 5/16/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
 var isCellTouched: Bool!
var idMovimientoFinal: String!
class CargosPendietesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private let cell = "CargosPendietesTableViewCell"
    var totalArrayAmount = [Double]()
    var charges = APIManager.sharedInstance.totalImportes
     var descriptions = APIManager.sharedInstance.totalDescripciones
    @IBOutlet weak var tabView: UITableView!
    @IBOutlet weak var aceptarButton: UIButton!
    
    private var selectedIndexPaths: [IndexPath] = []
    
    @IBOutlet weak var pagarButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if charges.count == 0 {
            aceptarButton.isEnabled = false
            Alert.ShowAlert(title: "", message: APIManager.sharedInstance.messageForCharges , titleForTheAction: "Aceptar", in: self)
        } else {
            aceptarButton.isEnabled = true 
        }
        isCellTouched = false
        aceptarButton.layer.cornerRadius = 8.0
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Mis compras", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel

        self.tabView.rowHeight = 118
        

 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    //MARK:- TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("charges.count", charges.count)
        return charges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! CargosPendietesTableViewCell
        cel.amountCharge.text = descriptions[indexPath.row]
        cel.titleCharge.text = "$\(charges[indexPath.row])"
        
        var idMovimiento = APIManager.sharedInstance.idMovimiento[indexPath.row]
        
        idMovimientoFinal = idMovimiento
        
       //cel.selectButton.indexPath = indexPath as NSIndexPath
        cel.selectButton.isSelected =
            self.selectedIndexPaths.contains(indexPath)
          idMovimientoFinal = idMovimiento
        cel.selectButtonWasPressed = { [weak self] isSelected in
         idMovimientoFinal = idMovimiento
            
            guard let `self` = self else { return }
            if isSelected {
                idMovimientoFinal! = idMovimiento

                print("Estos son los cargos finales.",idMovimientoFinal!)
                self.selectedIndexPaths.append(indexPath)
            } else {
                self.selectedIndexPaths = self.selectedIndexPaths.filter({ $0 == indexPath })
            }
        }
       
        
        return cel
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! CargosPendietesTableViewCell
          cel.amountCharge.text! = charges[indexPath.row]
          // cel.selectButton.backgroundColor = UIColor.red
        
        
        var idMovimiento = APIManager.sharedInstance.idMovimiento[indexPath.row]
        
        idMovimientoFinal = idMovimiento
        
      
        
        
       
     
        if let amountToInt = NumberFormatter().number(from: cel.amountCharge.text!) {
            var amountInt = amountToInt.doubleValue
            totalArrayAmount.append(amountInt)
            var totalSum = totalArrayAmount.reduce(0, +)
            //totalAmount = totalSum
       
        } else {
            print("Hubo un error")
        }
        
    }
    

    //MARK:- BOTONES
    
    @IBAction func clickPagarButton(_ sender: Any) {
        if isCellTouched == false {
    Alert.ShowAlert(title: "", message: "Selecciona un cargo para avanzar", titleForTheAction: "Aceptar", in: self)
        } else {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        }
       
    }
}
