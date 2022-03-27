//
//  HomeViewController.swift
//  delivery
//
//  Created by youssef on 3/14/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class mapViewController: BaseWireFrame<mapViewModel> {
    
    @IBOutlet weak var tableViewResultOfSearsh: UITableView!
    
    static var selectedAddre :  PublishSubject<String> = .init()
    static var selectedLocation :  PublishSubject<CLLocationCoordinate2D> = .init()
    var selectedAddre :  String?
    var selectedLocation :  CLLocationCoordinate2D?
    var address = [String]()
    var postal_code = ""
    let cellIdentefier = "mapTableViewCell"
    @IBOutlet weak var searchBar: UISearchBar!
    var locations :[MKMapItem] = []
    var showMenu : Bool = false
    let gecoder = CLGeocoder()
    var LocationManager : CLLocationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationManger()
        setupUi()
    
    }
    
    func setupUi(){
    
        searchBar.compatibleSearchTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        mapView.delegate = self
        searchBar.delegate = self
        
        let Tapgesture = UITapGestureRecognizer(target: self, action: #selector(revealRegionDetailsWithLongPressOnMap(sender:)))
        mapView.addGestureRecognizer(Tapgesture)
        searchBar.compatibleSearchTextField.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        searchBar.compatibleSearchTextField.font = UIFont(name:Font.Regular.name, size: 16)
        tableViewResultOfSearsh.register(UINib(nibName: cellIdentefier, bundle: nil), forCellReuseIdentifier: cellIdentefier)
        tableViewResultOfSearsh.delegate = self
        tableViewResultOfSearsh.dataSource = self
        tableViewResultOfSearsh.isHidden = true
    }
    
    @objc func revealRegionDetailsWithLongPressOnMap(sender: UITapGestureRecognizer){
        
        let annotations = self.mapView.annotations
        for _annotation in annotations {
            if let annotation = _annotation as? MKAnnotation
            {
                self.mapView.removeAnnotation(annotation)
            }
        }
    
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        getNameOfMyLocation(location: locationCoordinate)
        let pin = MKPointAnnotation()
        pin.coordinate = locationCoordinate
        mapView.addAnnotation(pin)
        mapView.setCenter(locationCoordinate, animated: true)
        tableViewResultOfSearsh.isHidden = true
        searchBar.endEditing(true)
        selectedLocation = locationCoordinate
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bind(ViewModel: mapViewModel) {
        
    }
    
    @IBAction func takePlace(_ sender: Any) {
        guard let selectedAddre = selectedAddre else {return}
        guard let selectLocation = selectedLocation else {return}
    
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String {
            print(userId)
            
            if vieeModel.ArrayOfCartData.isEmpty {
                navigationController?.popViewController(animated: true)
            }else{
                let conform = coordinator.mainNavigator.viewController(for:.ConformOrderViewController(Caratdate: vieeModel.ArrayOfCartData, nameOfAddress: selectedAddre, AddressLocation: selectLocation))
                navigationController?.pushViewController(conform, animated: true)
            }
            
            
        }else{
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setupLocationManger(){
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationManger(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            self.checkAuthorizationStaus()
        }else{
            print("do not allow")
        }
    }
}

extension mapViewController: CLLocationManagerDelegate{
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
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        guard let userLocation = LocationManager.location?.coordinate else {return}
        selectedLocation = userLocation
        getNameOfMyLocation(location: userLocation)
        centerUserLocation(center: userLocation)
        
    }
    
    func getCiteusingGecoder(nameOfLocation : String) {
        //Alexandria
        gecoder.geocodeAddressString(nameOfLocation) { (placeMarks, error) in
            if let err = error{
                print(err.localizedDescription)
            }
        
            guard let placeMarks = placeMarks, let placeMark = placeMarks.first, let location = placeMark.location else {return}
           print(location)
        }
        
        
    }
    
    func getNameOfMyLocation(location : CLLocationCoordinate2D){
        
        self.address.removeAll()
        print(location)
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
            gecoder.reverseGeocodeLocation(location) { (placesMark, error) in
                guard let placeMark = placesMark?.last else { return }
                print(placeMark)
                // Location name
                if let locationName = placeMark.locality {
                    print(locationName)
                    self.address.append(locationName)
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    self.address.append(street)
                    print(street)
                    
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                    print(city)
                    self.address.append(city)
                }
                
                if let administrativeArea = placeMark.administrativeArea {
                    print(administrativeArea)
                    self.address.append(administrativeArea)
                }
               let addressString  = self.address.joined(separator: "/")
                self.selectedAddre = addressString
                self.searchBar.text = addressString
                mapViewController.selectedAddre.onNext(addressString)
            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStaus()
    }
    
    func centerUserLocation(center : CLLocationCoordinate2D){
        mapViewController.selectedLocation.onNext(center)
        mapView.setCenter(center, animated: true)
    }
    
    
}

extension mapViewController : MKMapViewDelegate, UISearchBarDelegate{
  

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            locations.removeAll()
            tableViewResultOfSearsh.isHidden = true
        }
        findLocation(quary: searchText) { (locations) in
            self.locations = locations
            
            self.tableViewResultOfSearsh.isHidden = false
            DispatchQueue.main.async {
                self.tableViewResultOfSearsh.reloadData()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "MyCustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
        
    }
    
    
    func findLocation(quary : String ,  commplation : @escaping (_ places : [MKMapItem])->Void){
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = quary
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            commplation(response.mapItems)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }

}

extension mapViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentefier, for: indexPath) as! mapTableViewCell
        cell.nameOflbl?.text = locations[indexPath.item].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinatefalid = locations[indexPath.row].placemark.coordinate
        let title = locations[indexPath.row].name
        let pin = MKPointAnnotation()
        pin.coordinate = coordinatefalid
        pin.title = locations[indexPath.row].name
        centerUserLocation(center: coordinatefalid)
        mapView.addAnnotation(pin)
        mapView.setCenter(coordinatefalid, animated: true)
        tableViewResultOfSearsh.isHidden = true
        searchBar.text = locations[indexPath.row].name
        selectedAddre = title
        selectedLocation = coordinatefalid
        getNameOfMyLocation(location: coordinatefalid)
        view.endEditing(true)
        
    }
    
    
}
