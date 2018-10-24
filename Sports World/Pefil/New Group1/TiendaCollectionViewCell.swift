//
//  TiendaCollectionViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/10/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class TiendaCollectionViewCell: UICollectionViewCell {
   
    //MARK:- OUTLETS.
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var precioProducto: UILabel!
    
    
    override func awakeFromNib() {
     
        
        //Configura la vista del total de productos.
       self.configContainer()
       
      
        
    }
    
    //MARK:- MÉTODOS.
    func configContainer() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.addBorder(side: .top, color: UIColor.white, width: 2.0)
        if #available(iOS 11.0, *) {
            containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = containerView.frame
            rectShape.position = containerView.center
            rectShape.path = UIBezierPath(roundedRect: containerView.bounds,    byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            containerView.layer.backgroundColor = UIColor.green.cgColor
            containerView.layer.mask = rectShape
        }
    }

}
