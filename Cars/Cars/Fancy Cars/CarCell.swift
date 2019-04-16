//
//  CarCell.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import UIKit

//  MARK: - Class
class CarCell: UITableViewCell {

  //  MARK: - Outlets
  @IBOutlet internal weak var carImageView:UIImageView!
  @IBOutlet internal weak var carNameLabel:UILabel!
  @IBOutlet internal weak var carMakeLabel:UILabel!
  @IBOutlet internal weak var carModelLabel:UILabel!
  @IBOutlet internal weak var carAvailabilityLabel:UILabel!
  @IBOutlet internal weak var carBuyButton:UIButton!

  //  MARK: - Properties
  private var car:Car?
  
  //  MARK: - Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    self.initScreen()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  private func initScreen() {
    self.carBuyButton.layer.cornerRadius = 3.0
    self.carBuyButton.layer.borderWidth  = 1.0
    self.carBuyButton.layer.borderColor  = self.carBuyButton.tintColor.cgColor
    self.carBuyButton.isHidden = true
    self.carImageView.image = UIImage(named: "car")
  }
  
  //  MARK: - Public Methods
  func setupCell(_ car:Car) {
    self.car = car
    self.carNameLabel.text  = car.name
    self.carMakeLabel.text  = car.make
    self.carModelLabel.text = car.model
    self.carAvailabilityLabel.text = car.availability.available
    self.updateImage()
    self.updateAvailability()
  }
  
  func updateImage() {
    guard
      let car = self.car,
      !car.img.isEmpty
      else { return }
    //  do background download and update image
    self.carImageView.imageFromServerURL(urlString: car.img)
  }
  
  func updateAvailability() {
    guard let car = self.car else { return }
    self.carBuyButton.isHidden = !car.availability.isAvailable()
    //  do background api check availability and update buy button
  }
}
