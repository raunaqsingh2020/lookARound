//
//  ViewController.swift
//  lookARound
//
//  Created by Jesse Liu on 2019-09-07.
//  Copyright © 2019 Jesse Liu. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import ARCL
import SceneKit


struct Welcome: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let geometry: Geometry
    //let icon: String
    let name: String
    //let photos: [Photo]
    let place_id: String
    let types: [String]
    //let vicinity: String
    //let openingHours: OpeningHours?
    //let plusCode: PlusCode?
    let rating: Double?
    //let userRatingsTotal: Int?

}

// MARK: - Geometry
struct Geometry: Decodable {
    let location: Location
    let viewport: Viewport
}

// MARK: - Location
struct Location: Decodable {
    let lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Decodable {
    let northeast, southwest: Location
}

// MARK: - OpeningHours
struct OpeningHours: Decodable {
    let openNow: Bool
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var sceneLocationView = SceneLocationView()

    let locationManager = CLLocationManager()
    
    var currentLocation = CLLocation()
    
    var places: [Place] = []
    
    var selected = 0 //0 - establishment, 1 - food, 2 - ent, 3 - shop, 4 - services, 5 - transit
    
    var timer: Timer?
    
    let food = UIButton(frame: CGRect(x: 20, y: 570, width: 51, height: 70))
    let foodLabel = UILabel(frame: CGRect(x: 32, y: 638, width: 70, height: 20))
    let entertainment = UIButton(frame: CGRect(x: 91, y: 570, width: 51, height: 70))
    let entertainmentLabel = UILabel(frame: CGRect(x: 85, y: 638, width: 70, height: 20))
    let shopping = UIButton(frame: CGRect(x: 162, y: 570, width: 51, height: 70))
    let shoppingLabel = UILabel(frame: CGRect(x: 166, y: 638, width: 70, height: 20))
    let services = UIButton(frame: CGRect(x: 234, y: 570, width: 51, height: 70))
    let servicesLabel = UILabel(frame: CGRect(x: 238, y: 638, width: 70, height: 20))
    let transit = UIButton(frame: CGRect(x: 304, y: 570, width: 51, height: 70))
    let transitLabel = UILabel(frame: CGRect(x: 314, y: 638, width: 70, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.view.frame.width)
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        // Do any additional setup after loading the view.
        
        currentLocation = CLLocation(latitude: 39.9516104394942, longitude: -75.19077887765616)
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        getPlaces(location: currentLocation, radius: 1000, type: "establishment")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            for place in self.places {
                //print(place.name)
                self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                //print(place.place_id)
            }
            //self.drawPins(name: "test", distance: 3.0, lat:-75.1914, long: 39.9517)

        }
        
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

        
    }
    
    @objc func runTimedCode(){
        places.removeAll()
        print(currentLocation)
        if(selected == 0){
            getPlaces(location: currentLocation, radius: 1000, type: "establishment")
            sceneLocationView.removeAllNodes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for place in self.places {
                    self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                }
            }
        }else if(selected == 1){
            getPlaces(location: currentLocation, radius: 1000, type: "food")
            sceneLocationView.removeAllNodes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for place in self.places {
                    self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                }
            }
        }else if(selected == 2){
            getPlaces(location: currentLocation, radius: 1000, type: "movie_theater")
            getPlaces(location: currentLocation, radius: 1000, type: "amusement_park")
            getPlaces(location: currentLocation, radius: 1000, type: "aquarium")
            getPlaces(location: currentLocation, radius: 1000, type: "art_gallery")
            getPlaces(location: currentLocation, radius: 1000, type: "bowling_alley")
            getPlaces(location: currentLocation, radius: 1000, type: "museum")
            getPlaces(location: currentLocation, radius: 1000, type: "casino")
            getPlaces(location: currentLocation, radius: 1000, type: "night_club")
            getPlaces(location: currentLocation, radius: 1000, type: "zoo")
            getPlaces(location: currentLocation, radius: 1000, type: "stadium")
            sceneLocationView.removeAllNodes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for place in self.places {
                    self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                }
            }
        }else if(selected == 3){
            getPlaces(location: currentLocation, radius: 1000, type: "department_store")
            getPlaces(location: currentLocation, radius: 1000, type: "convenience_store")
            getPlaces(location: currentLocation, radius: 1000, type: "electronics_store")
            getPlaces(location: currentLocation, radius: 1000, type: "shopping_mall")
            getPlaces(location: currentLocation, radius: 1000, type: "clothing_store")
            sceneLocationView.removeAllNodes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for place in self.places {
                    self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                }
            }
        }else if(selected == 4){
            getPlaces(location: currentLocation, radius: 1000, type: "airport")
            getPlaces(location: currentLocation, radius: 1000, type: "atm")
            getPlaces(location: currentLocation, radius: 1000, type: "bank")
            getPlaces(location: currentLocation, radius: 1000, type: "beauty_salon")
            getPlaces(location: currentLocation, radius: 1000, type: "church")
            getPlaces(location: currentLocation, radius: 1000, type: "gas_station")
            getPlaces(location: currentLocation, radius: 1000, type: "gym")
            getPlaces(location: currentLocation, radius: 1000, type: "library")
            getPlaces(location: currentLocation, radius: 1000, type: "lodging")
            getPlaces(location: currentLocation, radius: 1000, type: "police")
            sceneLocationView.removeAllNodes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for place in self.places {
                    self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                }
            }
        }else if(selected == 5){
            getPlaces(location: currentLocation, radius: 1000, type: "transit_station")
            getPlaces(location: currentLocation, radius: 1000, type: "train_station")
            getPlaces(location: currentLocation, radius: 1000, type: "subway_station")
            getPlaces(location: currentLocation, radius: 1000, type: "bus_station")
            sceneLocationView.removeAllNodes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for place in self.places {
                    self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
        
        self.view.addSubview(food)
        food.setImage(UIImage(named: "food"), for: .normal)
        self.view.addSubview(entertainment)
        entertainment.setImage(UIImage(named: "entertainment"), for: .normal)
        self.view.addSubview(services)
        services.setImage(UIImage(named: "services"), for: .normal)
        self.view.addSubview(transit)
        transit.setImage(UIImage(named: "transit"), for: .normal)
        self.view.addSubview(shopping)
        shopping.setImage(UIImage(named: "shopping"), for: .normal)
        
        shoppingLabel.text = "Shopping"
        foodLabel.text = "Food"
        transitLabel.text = "Transit"
        servicesLabel.text = "Services"
        entertainmentLabel.text = "Entertainment"
        
        entertainmentLabel.textColor = .white
        shoppingLabel.textColor = .white
        foodLabel.textColor = .white
        servicesLabel.textColor = .white
        transitLabel.textColor = .white
        
        entertainmentLabel.textColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 1)
        shoppingLabel.textColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 1)
        foodLabel.textColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 1)
        servicesLabel.textColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 1)
        transitLabel.textColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 1)
        
        transitLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 10)
        entertainmentLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 10)
        foodLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 10)
        servicesLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 10)
        shoppingLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 10)

        
        shopping.addTarget(self, action: #selector(shopped), for: .touchUpInside)
        food.addTarget(self, action: #selector(fooded), for: .touchUpInside)
        entertainment.addTarget(self, action: #selector(entertained), for: .touchUpInside)
        services.addTarget(self, action: #selector(serviced), for: .touchUpInside)
        transit.addTarget(self, action: #selector(transited), for: .touchUpInside)


        
        self.view.addSubview(shoppingLabel)
        self.view.addSubview(foodLabel)
        self.view.addSubview(transitLabel)
        self.view.addSubview(servicesLabel)
        self.view.addSubview(entertainmentLabel)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneLocationView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
    }
    
    @objc func handleTap(sender:UITapGestureRecognizer){
        //print("tapped")
        guard let sceneView = sender.view as? SceneLocationView else {return}
        let touchLcoation = sender.location(in: sceneLocationView)
        let hitTestResult = sceneLocationView.hitTest(touchLcoation, types: .estimatedHorizontalPlane)
    
        if hitTestResult.isEmpty {
            print("empty")
        }else{
            print("hit")
        }
    }
    
    @objc func shopped(){
        food.setImage(UIImage(named: "food"), for: .normal)
        entertainment.setImage(UIImage(named: "entertainment"), for: .normal)
        services.setImage(UIImage(named: "services"), for: .normal)
        transit.setImage(UIImage(named: "transit"), for: .normal)
        shopping.setImage(UIImage(named: "shoppinginverted"), for: .normal)
        selected = 3
        places.removeAll()
        getPlaces(location: currentLocation, radius: 1000, type: "department_store")
        getPlaces(location: currentLocation, radius: 1000, type: "convenience_store")
        getPlaces(location: currentLocation, radius: 1000, type: "electronics_store")
        getPlaces(location: currentLocation, radius: 1000, type: "shopping_mall")
        getPlaces(location: currentLocation, radius: 1000, type: "clothing_store")
        sceneLocationView.removeAllNodes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
        for place in self.places {
            self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
        }
        }
    }
    
    @objc func entertained(){
        food.setImage(UIImage(named: "food"), for: .normal)
        entertainment.setImage(UIImage(named: "entertainmentinverted"), for: .normal)
        services.setImage(UIImage(named: "services"), for: .normal)
        transit.setImage(UIImage(named: "transit"), for: .normal)
        shopping.setImage(UIImage(named: "shopping"), for: .normal)
        selected = 2
        places.removeAll()
        getPlaces(location: currentLocation, radius: 1000, type: "movie_theater")
        getPlaces(location: currentLocation, radius: 1000, type: "amusement_park")
        getPlaces(location: currentLocation, radius: 1000, type: "aquarium")
        getPlaces(location: currentLocation, radius: 1000, type: "art_gallery")
        getPlaces(location: currentLocation, radius: 1000, type: "bowling_alley")
        getPlaces(location: currentLocation, radius: 1000, type: "museum")
        getPlaces(location: currentLocation, radius: 1000, type: "casino")
        getPlaces(location: currentLocation, radius: 1000, type: "night_club")
        getPlaces(location: currentLocation, radius: 1000, type: "zoo")
        getPlaces(location: currentLocation, radius: 1000, type: "stadium")
        sceneLocationView.removeAllNodes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        for place in self.places {
            self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
        }
        }
    }
    
    @objc func fooded(){
        food.setImage(UIImage(named: "foodinverted"), for: .normal)
        entertainment.setImage(UIImage(named: "entertainment"), for: .normal)
        services.setImage(UIImage(named: "services"), for: .normal)
        transit.setImage(UIImage(named: "transit"), for: .normal)
        shopping.setImage(UIImage(named: "shopping"), for: .normal)
        selected = 1
        places.removeAll()
        getPlaces(location: currentLocation, radius: 1000, type: "restaurant")
        sceneLocationView.removeAllNodes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        for place in self.places {
            self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
        }
        }
        printPlaces()
    }
    
    @objc func serviced(){
        food.setImage(UIImage(named: "food"), for: .normal)
        entertainment.setImage(UIImage(named: "entertainment"), for: .normal)
        services.setImage(UIImage(named: "servicesinverted"), for: .normal)
        transit.setImage(UIImage(named: "transit"), for: .normal)
        shopping.setImage(UIImage(named: "shopping"), for: .normal)
        selected = 4
        places.removeAll()
        getPlaces(location: currentLocation, radius: 1000, type: "airport")
        getPlaces(location: currentLocation, radius: 1000, type: "atm")
        getPlaces(location: currentLocation, radius: 1000, type: "bank")
        getPlaces(location: currentLocation, radius: 1000, type: "beauty_salon")
        getPlaces(location: currentLocation, radius: 1000, type: "church")
        getPlaces(location: currentLocation, radius: 1000, type: "gas_station")
        getPlaces(location: currentLocation, radius: 1000, type: "gym")
        getPlaces(location: currentLocation, radius: 1000, type: "library")
        getPlaces(location: currentLocation, radius: 1000, type: "lodging")
        getPlaces(location: currentLocation, radius: 1000, type: "police")
        sceneLocationView.removeAllNodes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

        for place in self.places {
            self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
        }
        }
        
        
    }
    
    @objc func transited(){
        food.setImage(UIImage(named: "food"), for: .normal)
        entertainment.setImage(UIImage(named: "entertainment"), for: .normal)
        services.setImage(UIImage(named: "services"), for: .normal)
        transit.setImage(UIImage(named: "transitInverted"), for: .normal)
        shopping.setImage(UIImage(named: "shopping"), for: .normal)
        selected = 5
        places.removeAll()
        getPlaces(location: currentLocation, radius: 1000, type: "transit_station")
        getPlaces(location: currentLocation, radius: 1000, type: "train_station")
        getPlaces(location: currentLocation, radius: 1000, type: "subway_station")
        getPlaces(location: currentLocation, radius: 1000, type: "bus_station")
        sceneLocationView.removeAllNodes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

        for place in self.places {
            self.drawPins(name: place.name, distance: place.dist, lat: place.lat, long: place.lng)
        }
        }
    }
    
    func printPlaces(){
        for place in self.places {
            print(place.name)
        }
    }

    
    func drawPins(name: String, distance: Double, lat: Double, long: Double){
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let location = CLLocation(coordinate: coordinate, altitude: Double.random(in: -250..<200))
        //print("altitude: \(location.altitude)")
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 275, height: 100))
        nameLabel.text = "\(name)"
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 30)
        nameLabel.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 0.75)
        nameLabel.layer.cornerRadius = 50
        nameLabel.layer.borderWidth = 2
        nameLabel.layer.borderColor = UIColor.white.cgColor
        nameLabel.clipsToBounds = true
        let distLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        distLabel.text = String(format: "%.2f", distance) + " miles"
        distLabel.textAlignment = .center
        distLabel.textColor = .white
        distLabel.font = UIFont(name:"HelveticaNeue", size: 20)
        distLabel.backgroundColor = UIColor(hue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 0.0)
        distLabel.layer.cornerRadius = 50
        distLabel.clipsToBounds = true
        
        nameLabel.addSubview(distLabel)
        distLabel.center.y = nameLabel.center.y + 25
        distLabel.center.x = nameLabel.center.x
        
        //nameLabel.minimumScaleFactor = 0.8
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //tap.numberOfTapsRequired = 1
        //nameLabel.isUserInteractionEnabled = true
        //distLabel.isUserInteractionEnabled = true
        //nameLabel.addGestureRecognizer(tap)
        //distLabel.addGestureRecognizer(tap)
        
        let annotationNode = LocationAnnotationNode(location: location, view: nameLabel)
        annotationNode.scaleRelativeToDistance = false
        
        //annotationNode.scale = SCNVector3(x: 100.0, y: 100.0, z: 100.0)
        //print(annotationNode.scale)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        //sceneLocationView.isUserInteractionEnabled = true
        
    }
    
    //@objc func handleTap(_ sender: UITapGestureRecognizer) {
        //print("titttie")
    //}
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
    }

    
    let apiURL = "https://maps.googleapis.com/maps/api/place/"
    let apiKey = "YOUR-API-KEY-HERE"
    
    func distanceBtwnPts(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double{
        let radius = 6371.0;
        let dLat = (lat2-lat1) * .pi / 180
        let dLon = (lon2-lon1) * .pi / 180
        let a = sin(dLat/2)*sin(dLat/2) + cos(lat1 * .pi / 180)*cos(lat1 * .pi / 180)*sin(dLon/2)*sin(dLon/2)
        let c = 2*atan2(sqrt(a),sqrt(1-a))
        return (radius * c);
    }
    
    
    func getPlaces(location: CLLocation, radius: Int, type: String) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let urlString = apiURL + "nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&sensor=true&types=\(type)&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            let dataAsString = String(data: data, encoding: .utf8)
            
            //print(dataAsString)

            //self.places.removeAll()

            
            do{
                let place = try JSONDecoder().decode(Welcome.self, from: data)
                let resultsArr = place.results
                for result in resultsArr {
                    var tempPlace = Place()
                    tempPlace.name = result.name
                    tempPlace.place_id = result.place_id
                    tempPlace.types = result.types
                    tempPlace.rating = 0.0
                    if let doubleRating = result.rating {
                        tempPlace.rating = doubleRating
                    }
                    tempPlace.lat = result.geometry.location.lat
                    tempPlace.lng = result.geometry.location.lng
                    tempPlace.dist = self.distanceBtwnPts(lat1: tempPlace.lat, lon1: tempPlace.lng, lat2: self.currentLocation.coordinate.latitude, lon2: self.currentLocation.coordinate.longitude)*0.621371
                    self.places.append(tempPlace)
                    self.places.sort(by: { $0.rating > $1.rating })
                    if(self.places.count>15){
                        for j in 15...self.places.count-1 {
                            self.places.remove(at: j)
                        }
                    }
                    
                }
            } catch {
                print("JSONSerialization error:", error)
            }
            
        }.resume()
        
    }
    

}


