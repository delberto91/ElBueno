//
//  ConveniosTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/7/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ConveniosTableViewCell: UITableViewCell {

    @IBOutlet weak var imageToShow: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
