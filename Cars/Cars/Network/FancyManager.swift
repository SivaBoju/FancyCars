//
//  FancyManager.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation

public class FancyManager:NSObject {
  
  //  MARK: - Properties
  fileprivate let fancyApi:FancyApi = FancyApi()
  
  //  MARK: - Life Cycle
  override fileprivate init() {
    super.init()
  }
  
  //  MARK: - Public Methods
  fileprivate func processResponse(_ response:HTTPURLResponse)->ResultType {
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failedAuthentication
    case 501...599: return .failedRequest
    case 600:       return .failedOutdated
    default:        return .failedNetwork
    }
  }
  
  fileprivate func shouldProcessData(_ data:Data?, _ response:URLResponse?, _ error:Error?)->(type:ResultType, data:Data) {
    var resultType:ResultType = .unknown
    var resultData:Data = Data()
    
    if error != nil { resultType = .failedNetwork }
    if resultType == .unknown {
      guard let response = response as? HTTPURLResponse else {
        resultType = .failedUnknown
        return (resultType, resultData)
      }
      resultType = self.processResponse(response)
    }
    
    if resultType == .success {
      guard let data = data else {
        resultType = .failedData
        return (resultType, resultData)
      }
      resultData = data
      return (resultType, resultData)
    }
    
    return (resultType, resultData)
  }
}

//  MARK: - Data Manager Settings
public class FancyManagerSettings: FancyManager {
  
  //  MARK: - Life Cycle
  override public init() {
    super.init()
  }
  
  //  MARK: - Public Methods
  func getCars(_ completion: @escaping (_ cars:[Car], _ result:ResultType)->()) {
    
    self.fancyApi.execute(FancyApiType.getCars) { (data, response, error) in
      let result = self.shouldProcessData(data, response, error)
      switch result.type {
      case .success:
        do {
          let decoder = JSONDecoder()
          let data = try decoder.decode([Car].self, from: result.data)
          completion(data, result.type)
        } catch {
          completion([], .failedJson)
        }
      default:
        completion([],result.type)
      }
    }
  }
  
  func getCarAvailability(_ completion: @escaping (_ availability:CarAvailability?, _ result:ResultType)->()) {
    
    //  Car Parameter needs to be passed - TO DO
    self.fancyApi.execute(FancyApiType.getCarAvailability) { (data, response, error) in
      let result = self.shouldProcessData(data, response, error)
      switch result.type {
      case .success:
        do {
          let decoder = JSONDecoder()
          let data = try decoder.decode(CarAvailability.self, from: result.data)
          completion(data, result.type)
        } catch {
          completion(nil, .failedJson)
        }
      default:
        completion(nil,result.type)
      }
    }
  }
  
}
