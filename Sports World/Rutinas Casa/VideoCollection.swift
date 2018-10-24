//
//  VideoCollection.swift
//  TableStyleNetflix
//
//  Created by VicktorManuel on 7/30/18.
//  Copyright © 2018 VicktorManuel. All rights reserved.
//

import UIKit

struct VideoCollection{
    
    var video:[Video]!
    var titulo:String!
    
    init(video: [Video], titulo:String) {
        self.video = video
        self.titulo = titulo
    }
}
