//
//  RootView.swift
//  Filmily
//
//  Created by macbook on 5/30/16.
//  Copyright © 2016 magic. All rights reserved.
//

import Foundation
class RootView {
    internal var loadResult: Int = 0
//    internal var protocols : NSObjectProtocol?
    class var shareInstance: RootView {
        struct Singleton {
            static let shareInstance = RootView()
        }
        return Singleton.shareInstance
    }
    
    func loadResult1(value: Int){
        self.loadResult += value
    }
    
    func loadResult2(value: Int){
        if self.loadResult > 0 {
            self.loadResult -= value

        }
    }
    func loadResultDefults(value: Int){
        self.loadResult = value
            
    }
}