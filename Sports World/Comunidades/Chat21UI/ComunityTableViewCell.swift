//
//  ComunityTableViewCell.swift
//  Sports World
//
//  Created by Glauco Valdes on 10/21/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ComunityTableViewCell: UITableViewCell {

    @IBOutlet weak var comunity: UILabel!
    @IBOutlet weak var count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
