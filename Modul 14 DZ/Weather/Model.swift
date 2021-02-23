//
//  Model.swift
//  Modul 14 DZ
//
//  Created by Vladimir Karsakov on 11.01.2021.
//

import Foundation
import RealmSwift

struct Model: Codable {
    let list: [List1]
}

struct List1: Codable {
    let main: Temp
    let weather: [Weather]
    let date: String

    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case date = "dt_txt"
    }
}

struct Temp: Codable {
    let temp: Double
}

struct Weather: Codable {
    let icon: String
}

@objcMembers
class List1Realm: Object{
    dynamic var data = ""
    dynamic var icon = ""
    dynamic var temp = 0.0
}
