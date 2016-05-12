//
//  movieObject.swift
//  Filmily
//
//  Created by macbook on 5/12/16.
//  Copyright © 2016 magic. All rights reserved.
//

import UIKit

class movieObject{
    var id:Int?
    var poster:String?
    var title:String?
    var year:Int?
    var director:String?
    var actors:String?
    var plot: String?
    var trailer: String?
    
    init(mid: Int, pIn:String, tIn:String, yIn:Int, dIn:String, aIn:String, plotIn: String, trailIn: String){
        self.id = mid
        self.poster = pIn
        self.title = tIn
        self.year = yIn
        self.director = dIn
        self.actors = aIn
        self.plot = plotIn
        self.trailer = trailIn
    }
}
