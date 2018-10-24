//
//  CarritoTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 10/10/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class CarritoTableViewCell: UITableViewCell {

    //MARK:- OUTLETS.
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDate: UILabel!
    @IBOutlet weak var precioProducto: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
