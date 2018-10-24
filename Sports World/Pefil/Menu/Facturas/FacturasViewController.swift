//
//  FacturasViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 7/5/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class FacturasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tabView: UITableView!

   
    
private let cell = "FacturasTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        if APIManager.sharedInstance.folios.count == 0 {
            Alert.ShowAlert(title: "", message: "No tienes facturas para consultar.", titleForTheAction: "Aceptar", in: self)
        }
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white 
        tabView.delegate = self
        self.tabView.reloadData()
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Facturas", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIManager.sharedInstance.folios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! FacturasTableViewCell
        
        cel.conceptoFactura.text = APIManager.sharedInstance.folios[indexPath.row]
        cel.fechaFactura.text = APIManager.sharedInstance.fechas[indexPath.row]
        cel.montoFactura.text = "$\(APIManager.sharedInstance.importes[indexPath.row])"
        
        
        return cel
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleFacturaViewController") as? DetalleFacturaViewController
        
       vc?.descripcionFactura = APIManager.sharedInstance.pdfs[indexPath.row]
      
            
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    
}
