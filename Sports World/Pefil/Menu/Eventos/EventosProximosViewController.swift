//
//  EventosProximosViewController.swift
//  Sports World
//
//  Created by VicktorManuel on 8/13/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit

class EventosProximosViewController: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var calificaciones: UILabel!
    @IBOutlet weak var subtTitleEvents: UILabel!
    @IBOutlet weak var titleEvents: UILabel!
    
    @IBOutlet weak var labelBlanco: UIView! {
        didSet {
            labelBlanco.layer.masksToBounds = true
            labelBlanco.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundCorners(cornerRadius: labelBlanco.frame.height * 0.1, layer: labelBlanco.layer, rect: labelBlanco.bounds)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            roundCorners(cornerRadius: self.labelBlanco.frame.height * 0.1, layer: self.labelBlanco.layer, rect: self.labelBlanco.bounds)
        }
        
    }

}
func roundCorners(cornerRadius: CGFloat, layer: CALayer, rect: CGRect) {
    let path = UIBezierPath(roundedRect: rect,
                            byRoundingCorners: [.bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = rect
    maskLayer.path = path.cgPath
    layer.mask = maskLayer
}
