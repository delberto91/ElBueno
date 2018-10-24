//
//  Video.swift
//  TableStyleNetflix
//
//  Created by VicktorManuel on 7/30/18.
//  Copyright © 2018 VicktorManuel. All rights reserved.
//

import UIKit

struct Video {
    var titulo:String
    var urlImagen:String
    var urlVideo:String
    
    init(titulo: String, urlImagen:String,urlVideo:String) {
        self.titulo = titulo
        self.urlImagen = urlImagen
        self.urlVideo = urlVideo
    }
}
