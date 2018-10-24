//
//  DetalleProductoViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/15/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
var isProducto: Bool = false
var idFinalProducto: String = ""
  var producto: [Producto] = [Producto]()
class DetalleProductoViewController: UIViewController {
  

    //MARK:- VARIABLES CONSTANTES Y OUTLETS.

    @IBOutlet weak var imagenProducto: UIImageView!
    @IBOutlet weak var nombreProducto: UILabel!
    @IBOutlet weak var fechaProducto: UILabel!
    @IBOutlet weak var costoProducto: UILabel!
    @IBOutlet weak var descripcionProducto: UITextView!
    var activeValue = ""
    var allClubes = APIManager.sharedInstance.finalList.removeDuplicates()
    var allClubesIds = APIManager.sharedInstance.finalId.removeDuplicates()
  
    var productoAgregar = Producto()
    var descripcion = ""
    var precio = ""
    var productoNombre = ""
    var imagen = ""
    var fecha = ""
    var costoProductoFinal: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     
      descripcionProducto.text = descripcion
      nombreProducto.text = productoNombre
      fechaProducto.text = fecha
        
      costoProducto.text = "$\(precio) MXN"
       costoProductoFinal  = precio
      
        let carrito    = UIImage(named: "carrito")!
        let carritoButton   = UIBarButtonItem(image: carrito,  style: .plain, target: self, action: #selector(DetalleProductoViewController.goToAnotherView))
        
        
        navigationItem.rightBarButtonItems = [carritoButton];
        
        //Configura el título de la pantalla
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "Detalle Producto", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
   
        
    }

    //MARK:- FUNCIONES.
    @objc func goToAnotherView() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "CarritoViewController") as! CarritoViewController
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    //MARK:- BOTONES.
    
    //Se agrega al carrito y te envía a la otra pantalla.
    @IBAction func clickAgregarAlCarrito(_ sender: Any) {
        
        productoAgregar.nombre = nombreProducto.text!
        productoAgregar.costo = costoProductoFinal
        producto.append(productoAgregar)
     
        shoeAlert()
        
    }
    


    
    
    @objc func stayHere() {
      //self.pickerClubes.isHidden = true
    }
    // cancel
    @objc func goToCarrito() {
        // self.pickerClubes.isHidden = true
    }
    
    @objc func shoeAlert() {
        let myAlert = UIAlertController(title: "¡Tu producto se agregó exitosamente!", message: "", preferredStyle: .alert)
        
        let seguirComprando = UIAlertAction(title: "Seguir comprando", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.navigationController?.popViewController(animated: true)
         
        }
        let irACarrito = UIAlertAction(title: "Ir a mi carrito", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "CarritoViewController") as! CarritoViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        }
     
        //myAlert.addAction(cancelButton)
       myAlert.addAction(seguirComprando)
       myAlert.addAction(irACarrito)
     self.present(myAlert, animated: true , completion: nil)
    }
}
