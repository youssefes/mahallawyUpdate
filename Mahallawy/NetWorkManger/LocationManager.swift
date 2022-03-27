//
//  LocationManager.swift
//  delivery
//
//  Created by youssef on 3/6/18.
//  Copyright © 2018 youssef. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import RxCocoa
import RxSwift
import Alamofire

class LocationManagerSingalTon : NSObject{
    
   
    static var shared = LocationManagerSingalTon()
    let gecoder = CLGeocoder()
    var isAuthorization : Bool = false
    var locationDistanse : Double = 5000
    var navigationStart = false
    
    var addressName = [String]()
 
    var userLocation  : PublishSubject<CLLocationCoordinate2D> = .init()
    var address : BehaviorRelay<String> = .init(value: "")
    
    var LocationManager : CLLocationManager = CLLocationManager()
    
    func checkLocationManger(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            self.checkAuthorizationStaus()
        }else{
            print("do not allow")
        }
    }
    
    func setupLocationManger(){
           LocationManager.delegate = self
           LocationManager.desiredAccuracy = kCLLocationAccuracyBest
       }
}

extension LocationManagerSingalTon : CLLocationManagerDelegate{
    func checkAuthorizationStaus(){
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startGetLocation()
            print("allow to know location WhenInUse")
        case .denied:
            break
        case .notDetermined:
            LocationManager.requestAlwaysAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
          startGetLocation()
            print("allow to know location")
        @unknown default:
            print("no more check in switch")
        }
    }
    
    func startGetLocation(){
        LocationManager.startUpdatingLocation()
        guard let location = LocationManager.location?.coordinate else{return}
        userLocation.onNext(location)
        isAuthorization = true
        getNameOfMyLocation(location: location)
    }
    
    func getNameOfMyLocation(location : CLLocationCoordinate2D){
        self.addressName.removeAll()
        print(location)
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        gecoder.reverseGeocodeLocation(location) { (placesMark, error) in
            guard let placeMark = placesMark?.first else { return }
            
            
            if let locationName = placeMark.name {
                self.addressName.append(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                self.addressName.append(street)
                print(street)
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                self.addressName.append(city)
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            // Country
            if let country = placeMark.country {
                self.addressName.append(country)
            }
            
            let addressString  = self.addressName.joined(separator: "/")
            self.address.accept(addressString)
            
        }
        
    }
    
   
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStaus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
    }
    
}


