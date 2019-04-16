//
//  Environment.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation

enum EnvironmentType : String {
  case dev
  case qa
  case prod
  
  func description()->String {
    var result:String = ""
    switch self {
    case .dev:
      result = "Development"
    case .qa:
      result = "QA"
    case .prod:
      result = "Production"
    }
    return result
  }
  
  func getBaseUrl()->String {
    var baseUrl:String = ""
    switch self {
    case .dev:
      baseUrl = "https://api.fancycars.ca"
    case .qa:
      baseUrl = "https://api.fancycars.ca"
    case .prod:
      baseUrl = "https://api.fancycars.ca"
    }
    return baseUrl
  }
}

struct Environment {
  static var type : EnvironmentType = {
    #if DEBUG
    return .dev
    #else
    return .prod
    #endif
  }()
}
