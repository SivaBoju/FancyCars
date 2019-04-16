//
//  FancyData.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation
import UIKit

//  MARK: - Abstract Class
class FancyData:NSObject {
  
  //  MARK: - Properties
  var deviceType:String
  var platform:String
  var language:String
  var environment:String
  var contentType:String
  let device:UIDevice
  
  //  MARK: - Life Cycle
  fileprivate override init() {
    //  abstract class, so no values
    self.device   = UIDevice.current
    self.deviceType = ""
    self.platform   = ""
    self.language   = ""
    self.environment = ""
    self.contentType  = ""
  }
  
  //  MARK: - Private Methods
  private func getType()->String {
    return self.device.model
  }
  
  private func getPlatform()->String {
    return self.device.systemName
  }
  
  private func getLanguage()->String {
    let languageCode = Locale.current.languageCode ?? "en"
    return languageCode
  }
  
  //  MARK: - Private Methods
  fileprivate func initDefaults() {
    self.deviceType  = self.getType()
    self.platform    = self.getPlatform()
    self.language    = self.getLanguage()
    self.environment = ""
    self.contentType = "application/json"
  }
  
}

//  MARK: - Header Data Development
class FancyDataDev: FancyData {
  
  //  MARK: - Life Cycle
  override init() {
    super.init()
    self.initDefaults()
    //  Override, if required
    self.environment = "Dev"
  }
}

//  MARK: - Header Data QA
class FancyDataQA: FancyData {
  
  //  MARK: - Life Cycle
  override init() {
    super.init()
    self.initDefaults()
    //  Override, if required
    self.environment = "QA"
  }
}

//  MARK: - Header Data Production
class FancyDataProd: FancyData {
  
  //  MARK: - Life Cycle
  override init() {
    super.init()
    self.initDefaults()
    //  Override, if required
    self.environment = "Prod"
  }
}
