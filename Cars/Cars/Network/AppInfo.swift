//
//  AppInfo.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation

//  MARK: - Class
struct AppInfo {
  
  //  MARK: - Life Cycle
  fileprivate init() {
    //  init not allowed
  }
  
  //  MARK: - Properties
  internal static let appName:String = {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
  }()
  
  internal static let version:String = {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  }()
  
  internal static let build:String = {
    return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
  }()
  
}
