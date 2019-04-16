//
//  Car.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation

struct CarAvailability:Codable {
  var available:String
  
  func isAvailable()->Bool {
    return self.available.lowercased() == "in dealership".lowercased()
  }
}

struct Car:Codable {
  var id:Int
  var img:String
  var name:String
  var make:String
  var model:String
  var year:Int
  var availability:CarAvailability
  
  enum CodingKeys: String, CodingKey {
    case id
    case img
    case name
    case make
    case model
    case year
    case availability
  }
  
  mutating func encode(encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(img, forKey: .img)
    try container.encode(name, forKey: .name)
    try container.encode(make, forKey: .make)
    try container.encode(model, forKey: .model)
    try container.encode(year, forKey: .year)
    self.availability = CarAvailability(available: "Unknown")
  }
}
