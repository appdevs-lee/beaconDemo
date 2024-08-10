//
//  Trilateration.swift
//  beaconDemo
//
//  Created by Awesomepia on 8/1/24.
//

import Foundation

class AP {
    let x: Double
    let y: Double
    var distance: Double
    
    init(x: Double, y: Double, distance: Double) {
        self.x = x
        self.y = y
        self.distance = distance
    }
}

class Trilateration {
    var AP1: AP
    var AP2: AP
    var AP3: AP
    
    init(AP1: AP, AP2: AP, AP3: AP) {
        self.AP1 = AP1
        self.AP2 = AP2
        self.AP3 = AP3
        
    }
    
    func calcUserLocation() -> (x: Double, y: Double) {
        let A: Double = 2 * (self.AP2.x - self.AP1.x)
        let B: Double = 2 * (self.AP2.y - self.AP1.y)
        let C: Double = pow(self.AP1.distance, 2) - pow(self.AP2.distance, 2) - pow(self.AP1.x, 2) + pow(self.AP2.x, 2) - pow(self.AP1.y, 2) + pow(self.AP2.y, 2)
        let D: Double = 2 * (self.AP3.x - self.AP2.x)
        let E: Double = 2 * (self.AP3.y - self.AP2.y)
        let F: Double = pow(self.AP2.distance, 2) - pow(self.AP3.distance, 2) - pow(self.AP2.x, 2) + pow(self.AP3.x, 2) - pow(self.AP2.y, 2) + pow(self.AP3.y, 2)
        
        let user_x: Double = ( (F * B) - (E * C) ) / ( (B * D) - (E * A))
        let user_y: Double = ( (F * A) - (D * C) ) / ( (A * E) - (D * B))
        return (x: user_x, y: user_y)
        
    }
    
}
