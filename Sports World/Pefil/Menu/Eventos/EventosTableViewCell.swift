//
//  EventosTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 8/6/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class EventosTableViewCell: UITableViewCell {
    @IBOutlet weak var infoButton: UIButton! {
        didSet {
            infoButton.addTarget(self, action: #selector(self.infoButtonWasPressed(_:)), for: .touchUpInside)
        }
    }
    //EventosTableViewCell proximos 
    @IBOutlet weak var nameEventoLabel: UILabel!
    @IBOutlet weak var lugarEventoLabel: UILabel!
    @IBOutlet weak var fechaEventoLabel: UILabel!
    @IBOutlet weak var rojoView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    
    
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var view: UIView! {
        didSet {
            view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
            view.layer.borderWidth = 1
            view.layer.masksToBounds = true
            view.clipsToBounds = true
        }
    }
    
    var infoButtonWasPressed: ( () -> Void )?
    
    @objc
    private func infoButtonWasPressed(_ sender: Any) {
        infoButtonWasPressed?()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.cornerRadius = frame.height * 0.05
    }
}
