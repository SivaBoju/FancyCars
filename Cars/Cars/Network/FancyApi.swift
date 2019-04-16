//
//  FancyApi.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import Foundation

public typealias APICompletion = (_ data:Data?, _ response:URLResponse?, _ error:Error?)->()
public typealias Parameters  = [String : Any]

public enum HTTPMethod : String {
  case get    = "GET"
  case post   = "POST"
  case put    = "PUT"
  case patch  = "PATCH"
  case delete = "DELETE"
}

//  MARK: - Enum
public enum ResultType:String {
  case success
  case failedAuthentication
  case failedRequest
  case failedOutdated
  case failedNetwork
  case failedData
  case failedJson
  case failedUrl
  case failedUnknown
  case unknown
  
  //  MARK: - Public Methods
  public func localizedDescription()->String {
    var description:String = ""
    switch self {
    case .success:
      description = "Network call executed successfully"
    default:
      description = "Network call failed for some reason CR\(self.getCode())"
    }
    return description
  }
  
  //  MARK: - Private Methods
  func getCode()->Int {
    var code:Int = -1
    switch self {
    case .success:
      code = 200
    case .failedData:
      code = 801
    case .failedJson:
      code = 802
    case .failedNetwork:
      code = 803
    case .failedRequest:
      code = 804
    case .failedOutdated:
      code = 805
    case .failedAuthentication:
      code = 806
    case .failedUrl:
      code = 807
    default:
      code = 899
    }
    return code
  }
}


//  MARK: - Alias
enum FancyApiType {
  case getCars
  case getCarAvailability
  case unknown
  
  func getPath()->String {
    var path:String = ""
    switch self {
    case .getCars:
      path = "cars"
    case .getCarAvailability:
      path = "availability"
    default:
      path = ""
    }
    return path
  }
  
  func getBaseUrl()->String {
    let environmentType = Environment.type
    return environmentType.getBaseUrl()
  }
  
  func getURL()-> URL? {
    let baseUrl  = self.getBaseUrl()
    let endpoint = self.getPath()
    return URL(string: baseUrl + endpoint)
  }
  
  func getMethod()->HTTPMethod {
    var method = HTTPMethod.get
    switch self {
    default:
      method = .get
    }
    return method
  }
  
  func getTimeoutInterval()->Int {
    var interval:Int = 10
    switch self {
    default:
      interval = 10
    }
    return interval
  }
  
}

//  MARK: - Abstract Class
class FancyApi:NSObject, URLSessionDelegate {
  
  //  MARK: - Properties
  fileprivate var apiType:FancyApiType
  fileprivate var task:URLSessionTask?
  fileprivate var headerDev:FancyHeaderDev
  fileprivate var headerQA:FancyHeaderQA
  fileprivate var headerProd:FancyHeaderProd
  
  //  MARK: - Life Cycle
  override init() {
    //  Abstract class, so no values
    self.apiType = .unknown
    self.headerDev = FancyHeaderDev()
    self.headerQA     = FancyHeaderQA()
    self.headerProd  = FancyHeaderProd()
  }
  
  //  MARK: - Private Methods
  func getMethod()->HTTPMethod {
    return self.apiType.getMethod()
  }
  
  func getTimeoutInterval()->Int {
    return self.apiType.getTimeoutInterval()
  }
  
  func getHeaders()->HTTPHeaders {
    let environmentType = Environment.type
    switch environmentType {
    case .prod:
      return self.headerProd.getHeaders()
    case .qa:
      return self.headerQA.getHeaders()
    default:
      return self.headerDev.getHeaders()
    }
  }
  
  func getRequest()->URLRequest? {
    if let url = self.apiType.getURL() {
      var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeInterval(self.getTimeoutInterval()))
      request.httpMethod = self.getMethod().rawValue
      request.allHTTPHeaderFields = self.getHeaders()
      return request
    }
    return nil
  }
  
  //  MARK: - Public Methods
  func execute(_ apiType:FancyApiType, parameters:Parameters = [:], completion: @escaping APICompletion) {
    
    self.cancel()
    
    self.apiType = apiType
    //    SSL Pinning - TO DO
    //    let configuration = URLSessionConfiguration.default
    //    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    let session = URLSession.shared
    guard var request = self.getRequest() else {
      let error = NSError(domain: "", code: ResultType.failedUrl.getCode(), userInfo: nil)
      completion(nil,nil,error)
      return
    }
    do {
      let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
      request.httpBody = data
    }
    catch {
    }
    self.task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      completion(data, response, error)
    })
    
    self.task?.resume()
  }
  
  func cancel() {
    self.task?.cancel()
  }
  
  //  MARK: - URLSession Delegate Methods
  func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    guard let serverTrust = challenge.protectionSpace.serverTrust else {
      return
    }
    let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
    
    // Set SSL policies for domain name check
    let policies = NSMutableArray();
    policies.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
    SecTrustSetPolicies(serverTrust, policies);
    
    // Evaluate server certificate
    var result: SecTrustResultType = .unspecified
    let status = SecTrustEvaluate(serverTrust, &result)
    var isServerTrusted:Bool = false
    if status == errSecSuccess {
      let unspecified = SecTrustResultType.unspecified
      let proceed = SecTrustResultType.proceed
      isServerTrusted = result == unspecified || result == proceed
    }
    
    
    // Get local and remote cert data
    let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
    guard
      let pathToCert = Bundle.main.path(forResource: "fancyCars", ofType: "cer"),
      let localCertificate:NSData = NSData(contentsOfFile: pathToCert) else {
        return
    }
    if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificate as Data)) {
      let credential:URLCredential = URLCredential(trust: serverTrust)
      completionHandler(.useCredential, credential)
    }
    else {
      completionHandler(.cancelAuthenticationChallenge, nil)
    }
  }
}
