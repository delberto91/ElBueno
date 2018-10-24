//
//  PasesRedimidosTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class PasesRedimidosTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloPase: UILabel!
    @IBOutlet weak var imagenPase: UIImageView!
    @IBOutlet weak var vigenciaPase: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagenPase.image = UIImage(named: "pase_de_invitado_image")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
