//
//  CarritoViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/10/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class CarritoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    //MARK:- Variables y constantes.
    
    @IBOutlet weak var totalSuma: UILabel!
    
    private let cell = "CarritoTableViewCell"
    var arraySuma: [Int] = []
    var sumaTotal : Int = Int()
    
    @IBOutlet weak var totalTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configura el título de la vista.
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Carrito", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //MARK:- DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return producto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! CarritoTableViewCell
       cel.productName.text = producto[indexPath.row].nombre
       cel.precioProducto.text = producto[indexPath.row].costo
        let costos : Int = Int(producto[indexPath.row].costo)!
        self.arraySuma.append(costos)
        let tot  = self.arraySuma.reduce(0, +)
        sumaTotal = tot
        print("Súmale paps", sumaTotal)
        
        //Total con IVA
        totalSuma.text = ("$" + String(sumaTotal) + " MXN")
        
    
        let totalPago = sumaTotal
        
        //Total en cadena.
        totalTotal.text = ("$" + String(totalPago) + " MXN")
        
        

        
        return cel
    }
    
    @IBAction func clickPagarButton(_ sender: Any) {
        isProducto = true

        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController")as! PaymentsViewController
  
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    

}
