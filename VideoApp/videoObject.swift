//
//  videoObject.swift
//  VideoApp
//
//  Created by macbook on 4/20/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class videoObject {
    
    var poster:String?
    var title:String?
    var year:String?
    var director:String?
    var actors:String?
    
    init(pIn:String, tIn:String, yIn:String, dIn:String, aIn:String){
        self.poster = pIn
        self.title = tIn
        self.year = yIn
        self.director = dIn
        self.actors = aIn
    }
}
