//
//  CarsViewController.swift
//  Cars
//
//  Created by Sivakumar Boju on 2019-04-16.
//  Copyright © 2019 Ambas. All rights reserved.
//

import UIKit

enum SortBy:Int {
  case byName = 0
  case byAvailability = 1
}

//  MARK: - Class
class CarsViewController: UIViewController {

  //  MARK: - Outlets
  @IBOutlet weak var segmentedControl:UISegmentedControl!
  @IBOutlet weak var tableView:UITableView!
  @IBOutlet weak var infoLabel:UILabel!

  //  MARK: - Properties
  private var cars:[Car] = []
  
  //  MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initScreen()
  }
  
  private func initScreen() {
    self.setupData()
    self.setupAppInfo()
    self.setupTableView()
    self.doRefresh()
  }
  
  //  MARK: - Helper Methods
  private func setupAppInfo() {
    self.infoLabel.text = "\(AppInfo.appName) v\(AppInfo.version) (b\(AppInfo.build))"
  }

  private func setupTableView() {
    self.tableView.dataSource = self
    self.tableView.delegate   = self
  }
  
  private func setupData() {
    //  request API for cars - TO DO
    //  mocked with temp data
    self.saveCars()
    self.getCars()
  }
  
  private func saveCars() {
    let car1 = Car(id: 1, img: "Acura", name: "Acura", make: "Acura", model: "Legend", year: 2020, availability: CarAvailability(available: "In Dealership"))
    let car2 = Car(id: 1, img: "BMW", name: "BMW", make: "BMW", model: "X3", year: 2020, availability: CarAvailability(available: "Out of Stock"))
    let car3 = Car(id: 1, img: "Benz", name: "Mercedez Benz", make: "Mercedez Benz", model: "200 series", year: 2020, availability: CarAvailability(available: "In Dealership"))
    self.cars = [car1, car2, car3]
    UserDefaults.standard.set(try? PropertyListEncoder().encode(self.cars), forKey:"cars")
  }
  
  private func getCars() {
    guard
      let carsData = UserDefaults.standard.value(forKey: "cars") as? Data,
      let myCars = try? PropertyListDecoder().decode(Array<Car>.self, from: carsData)
    else {
      return
    }
    self.cars = myCars
  }
  
  @IBAction private func doSort() {
    self.doRefresh()
  }
  
  private func doRefresh() {
    let tempCars = self.cars
    if self.segmentedControl.selectedSegmentIndex == SortBy.byName.rawValue {
      self.cars = tempCars.sorted(by: {$0.name < $1.name})
    }
    else {
      self.cars = tempCars.sorted(by: {$0.availability.available < $1.availability.available})
    }
    self.tableView.reloadData()
  }
}

//  MARK: - Extension Table View Datasource and Delegate Methods
extension CarsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.cars.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let carCell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
    let car = self.cars[indexPath.row]
    carCell.setupCell(car)
    return carCell
  }

}
