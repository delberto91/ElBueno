//
//  TiendaViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/9/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class TiendaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    
    //MARK:- VARIABLES y CONSTANTES.
    private let cell = "TiendaCollectionViewCell"
    var activeValue = ""
    var allClubes = APIManager.sharedInstance.finalList.removeDuplicates()
    var allClubesIds = APIManager.sharedInstance.finalId.removeDuplicates()
    
 var productos : [Tienda] = [Tienda]()
    
    //MARK:_ OUTLETS.
    
    @IBOutlet weak var clubName: UILabel!
    
    @IBOutlet weak var pickerClubes: UIPickerView!
    @IBOutlet weak var colleView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerClubes.delegate = self
        pickerClubes.isHidden = true
        
        activity.hideActivity(viewController: self)
        
        colleView.delegate = self
        colleView.dataSource = self
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Tienda", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        let carrito    = UIImage(named: "carrito")!
        let carritoButton   = UIBarButtonItem(image: carrito,  style: .plain, target: self, action: #selector(TiendaViewController.goToAnotherView))
        
        
        navigationItem.rightBarButtonItems = [carritoButton];
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //LLAMA A LA PETICIOÓN.
        //self.getProductos()
        
    }
    //MARK:- MÉTODOS
    //Consume al servicio.
    func getProductos() {
    activity.showActivity(viewController: self)
        APIManagerV.sharedInstance.getProductosTienda(clubId: idFinalProducto, onSuccess:  { response in
            
            DispatchQueue.main.async {
           
                self.productos = response.data
                if response.code == 200 {
                     self.colleView.reloadData()
                 self.activity.hideActivity(viewController: self)
                    
                } else {
                    
                   self.activity.hideActivity(viewController: self)
                    Alert.ShowAlert(title: "", message: response.message, titleForTheAction: "Aceptar", in: self)
                }
            }

            })
    }
    //Te lleva a la pantalla del carrito.
    @objc func goToAnotherView() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "CarritoViewController") as! CarritoViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
  
    //MARK:- DATASOURCE COLLECTIONVIEW.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cel = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath as IndexPath) as! TiendaCollectionViewCell
        
        cel.productPrice.text? = String(self.productos[indexPath.row].descripcion)
        cel.productName.text? = self.productos[indexPath.row].nombre
        cel.precioProducto.text? = "$\(self.productos[indexPath.row].importe)"
        return cel 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleProductoViewController") as? DetalleProductoViewController
        vc?.productoNombre = self.productos[indexPath.row].nombre
        vc?.precio = (String (self.productos[indexPath.row].importe))
        vc?.descripcion = self.productos[indexPath.row].descripcion
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickPickerButton(_ sender: Any) {
        self.pickerClubes.alpha = 1
        pickerClubes.isHidden = false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.pickerClubes.alpha = 1
        return  allClubes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return allClubes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        var idFinales = allClubesIds[row]
        clubName.text = allClubes[row]
        idFinalProducto = String(idFinales)
        
        self.getProductos()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.pickerClubes.alpha = 0
        }) { (finished) in
            self.pickerClubes.isHidden = true
            self.view.endEditing(true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = allClubes[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
}
