#  Fancy Cars

## Requirements
- Show list of all the cars and for each car, they want to show picture, name, make, model and availability of the car. 
- Your app should support infinite scroll for the listing of the cars
- Have a sort Dropdown which can sort the results by both the name and availability of the car
- Show a buy button that only shows up if Availability is “In Dealership”
- Make sure your app can also work when its offline

## Guidelines
- For this exercise, please build the app using either React Native, Kotlin, Java, Swift or Objective C. We prefer React Native if you can build app using it.

- Assume that BE will expose two services - AvailabilityService to get availability of the cars and CarService to get list of all the cars. You can stub the API data in your App and don’t have to write the service.

### API spec is as follows: 

GET /availability?id=123 
RESPONSE: {available: “In Dealership”}  // all  options are [ “Out of Stock”, “Unavailable”]

GET /cars
RESPONSE:  [ {id: 1, img: http://myfancycar/image, name: “My Fancy Car”, make: “MyMake”, model: “MyModel”, year: 2018} ….]


## Stretched Goals 
1. Added check to identity for jail broken devices
2. Added app info with name, version and build
3. Added some sample extension methods
4. Added a network framework layer such as header data, header, api requests and data manager for different environments
5. Added an environment structure
6. Added a splash view for screen data protection


## Notes
1. Network layer is added and some sample methods are implemented, but not used
2. UserDefaults is used for storing and retrieving the temp data
