//
//  Extensions.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import UIKit

//  MARK: - Application Extensions
extension UIApplication {
  //  method to check if the device is jail broken
  //  to restrict app launches from unauthorized devices
  func isJailbroken() -> Bool {
    #if arch(i386) || arch(x86_64)
    return false
    #else
    let fileManager = FileManager.default
    let filesToCheck = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/bin/ssh",
      "/usr/sbin/sshd",
      "/var/cache/apt",
      "/etc/apt",
      "/var/lib/cydia",
      "/private/var/tmp/cydia.log",
      "/var/tmp/cydia.log"
    ]
    
    for file in filesToCheck {
      guard fileManager.fileExists(atPath: file) == false else {
        return true
      }
    }
    return false
    #endif
  }
}

//  MARK: - ImageView Extensions
extension UIImageView {
  public func imageFromServerURL(urlString: String) {
    URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
      
      if error != nil {
        return
      }
      DispatchQueue.main.async(execute: { () -> Void in
        guard let image = UIImage(data: data!) else { return }
        self.image = image
        self.setNeedsDisplay()
      })
      
    }).resume()
  }
}

//  MARK: - View Extensions
extension UIView {
  //  method to load view from xib file
  func loadViewFromNib(nibName:String) -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    return view
  }
  
  //  method to load the content view from xib file
  func loadContentView(nibName:String)->UIView {
    let contentView = self.loadViewFromNib(nibName: nibName)
    contentView.backgroundColor = UIColor.clear
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    addSubview(contentView)
    return contentView
  }
  
}
