//
//  AppDelegate.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  //  MARK: - Properties
  var window: UIWindow?
  var isAuthorizedDevice:Bool = false

  //  MARK: - Life Cycle
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //  verify if the device is jail broken
    self.isAuthorizedDevice = application.isJailbroken()
    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    //  add splash view
    //  to hide application active screen
    let splashView = UIImageView(frame: UIScreen.main.bounds)
    splashView.tag = 999
    guard let image = UIImage(named: "FancyCar") else { return }
    splashView.image = image
    window?.addSubview(splashView)
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    //  remove splash view
    //  to reveal application active screen
    if let view = window?.viewWithTag(999) {
      view.removeFromSuperview()
    }
  }

}
