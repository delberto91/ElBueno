//
//  PasesDeInvitadoTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class PasesDeInvitadoTableViewCell: UITableViewCell {
    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var numberOfPass: UILabel!
    @IBOutlet weak var vigencia: UILabel!
    @IBOutlet weak var viewUnderLined: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageToShow.image = UIImage(named: "pase_de_invitado_image")
        
        viewUnderLined.addBottomBorderWithColor(viewUnderLined, color: UIColor.white, width: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
