//
//  Horarios.swift
//  Sports World
//
//  Created by VicktorManuel on 7/8/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit



class Horarios: NSObject {
    var hora:[String:Int]
    var fecha:String
    init(hora:[String:Int], fecha:String) {
        self.hora = hora
        self.fecha = fecha
    }
    
}
