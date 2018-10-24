//
//  ObjetivoTableViewCell.swift
//  Sports World
//
//  Created by Glauco Valdes on 6/26/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class ObjetivoTableViewCell: UITableViewCell {

    @IBOutlet weak var objetivo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
