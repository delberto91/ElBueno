//
//  InbodyTableViewCell.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/8/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Charts
class InbodyTableViewCell: UITableViewCell {
    @IBOutlet weak var pesoLabel: UILabel!
    @IBOutlet weak var estaturaLabel: UILabel!
    @IBOutlet weak var relacionCinturaCadera: UILabel!
    @IBOutlet weak var porcentajeGrasaCorporal: UILabel!
    @IBOutlet weak var indiceMasaCorporal: UILabel!
    @IBOutlet weak var masaMuscularEsqueleto: UILabel!
    @IBOutlet weak var masaGrasaCorporal: UILabel!
    @IBOutlet weak var aguaCorporalTotal: UILabel!
    
    @IBOutlet weak var barChart: BarChartView!
    
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
                pesoLabel.addBottomBorderWithColor(pesoLabel, color: UIColor.white, width: 0.5)
        estaturaLabel.addBottomBorderWithColor(estaturaLabel, color: UIColor.white, width: 0.5)
        relacionCinturaCadera.addBottomBorderWithColor(relacionCinturaCadera, color: UIColor.white, width: 0.5)
        porcentajeGrasaCorporal.addBottomBorderWithColor(porcentajeGrasaCorporal, color: UIColor.white, width: 0.5)
        indiceMasaCorporal.addBottomBorderWithColor(indiceMasaCorporal, color: UIColor.white, width: 0.5)
        masaMuscularEsqueleto.addBottomBorderWithColor(masaMuscularEsqueleto, color: UIColor.white, width: 0.5)
        masaGrasaCorporal.addBottomBorderWithColor(masaGrasaCorporal, color: UIColor.white, width: 0.5)
        aguaCorporalTotal.addBottomBorderWithColor(aguaCorporalTotal, color: UIColor.white, width: 0.5)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
