//
//  FacturasTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 7/5/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class FacturasTableViewCell: UITableViewCell {
    @IBOutlet weak var conceptoFactura: UILabel!
    @IBOutlet weak var fechaFactura: UILabel!
    @IBOutlet weak var montoFactura: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
