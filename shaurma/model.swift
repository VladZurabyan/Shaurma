//
//  Model.swift
//  shaurma
//
//  Created by Admin on 8/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct MyPlace {
        var name: String
        var loc: String
        var lat: Double
        var long: Double
    }


struct MarkerView {
    var title: String
    var img: Data?
    var location: String
}
