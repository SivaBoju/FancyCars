//
//  FancyHeader.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation

//  MARK: - Alias
public typealias HTTPHeaders = [String:String]

//  MARK: - Abstract Class
class FancyHeader {
  
  //  MARK: - Properties
  fileprivate let kDeviceType:String  = "X-Device-Type"
  fileprivate let kPlatform:String    = "X-Platform"
  fileprivate let kEnvironment:String = "X-Environment"
  fileprivate let kLanguage:String    = "Content-Language"
  fileprivate let kContentType:String = "Content-Type"
  fileprivate var headers:HTTPHeaders
  
  //  MARK: - Life Cycle
  fileprivate init() {
    //  abstract class, so no values
    self.headers = [:]
  }
  
  //  MARK: - Public Methods
  func getHeaders()->HTTPHeaders {
    return self.headers
  }
}

//  MARK: - Fancy Header Dev
class FancyHeaderDev:FancyHeader {
  
  //  MARK: - Properties
  fileprivate let data = FancyDataDev()
  
  //  MARK: - Life Cycle
  override init() {
    super.init()
    self.initHeaders()
  }
  
  private func initHeaders() {
    self.headers = [
      self.kDeviceType  : self.data.deviceType,
      self.kPlatform    : self.data.platform,
      self.kEnvironment : self.data.environment,
      self.kLanguage    : self.data.language,
      self.kContentType : self.data.contentType
    ]
  }
  
}

//  MARK: - Fancy Header QA
class FancyHeaderQA:FancyHeader {
  
  //  MARK: - Properties
  fileprivate let data = FancyDataQA()
  
  //  MARK: - Life Cycle
  override init() {
    super.init()
    self.initHeaders()
  }
  
  private func initHeaders() {
    self.headers = [
      self.kDeviceType  : self.data.deviceType,
      self.kPlatform    : self.data.platform,
      self.kEnvironment : self.data.environment,
      self.kLanguage    : self.data.language,
      self.kContentType : self.data.contentType
    ]
  }
  
}

//  MARK: - Fancy Header Prod
class FancyHeaderProd:FancyHeader {
  
  //  MARK: - Properties
  fileprivate let data = FancyDataProd()
  
  //  MARK: - Life Cycle
  override init() {
    super.init()
    self.initHeaders()
  }
  
  private func initHeaders() {
    self.headers = [
      self.kDeviceType  : self.data.deviceType,
      self.kPlatform    : self.data.platform,
      self.kEnvironment : self.data.environment,
      self.kLanguage    : self.data.language,
      self.kContentType : self.data.contentType
    ]
  }
}
