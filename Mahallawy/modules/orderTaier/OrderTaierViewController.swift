//
//  OrderTaierViewController.swift
//  Mahallawy
//
//  Created by jooo on 10/21/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreLocation
import RxCocoa
import RxSwift
class OrderTaierViewController: BaseWireFrame<OrderTaierViewModel> {
    @IBOutlet weak var imageofProdect: UIImageView!
    
    @IBOutlet weak var conformBtn: UIButton!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var imageOfProviderAddress: UIImageView!
    @IBOutlet weak var imageOfAddressClient: UIImageView!
    @IBOutlet weak var AddressTf: UITextField!
    @IBOutlet weak var phoneOfClientTf: UITextField!
    @IBOutlet weak var nameOfClientTf: UITextField!
    @IBOutlet weak var descriptionOfProdecTf: UITextField!
    @IBOutlet weak var priceOfProdect: UITextField!
    @IBOutlet weak var nameOfProdectTf: UITextField!
    @IBOutlet weak var NameOfProfider: UITextField!
    @IBOutlet weak var phoneOfProfider: UITextField!
    @IBOutlet weak var addressOfProfider: UITextField!
    var locationOfClient : CLLocationCoordinate2D?
    var locationOfProvider : CLLocationCoordinate2D?
    var selecteImage = false
    var brandlogo : BehaviorRelay<String> = .init(value: "")
    var ClientAddress = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: OrderTaierViewModel) {
        // MARK:   bind  location name from map
        mapViewController.selectedAddre.subscribe(onNext: {[weak self] (address) in
            guard let self = self else {return}
            if self.ClientAddress {
                print(address)
                self.AddressTf.text = address
            }else{
                print(address)
                self.addressOfProfider.text = address
            }
        }).disposed(by: disposePag)
        
        // MARK:   bind selected location from map
        mapViewController.selectedLocation.subscribe(onNext: {[weak self] (location) in
            guard let self = self else {return}
            if self.ClientAddress {
                self.locationOfClient = location
            }else{
                self.locationOfProvider = location
            }
        }).disposed(by: disposePag)
        tapGestureInImage()
        
        self.brandlogo.subscribe(onNext: {[weak self] (imageUrl) in
            guard let self = self else {return}
            if imageUrl.isEmpty{
                print("no thing")
            }else{
                self.conformOrder(prodectImage: imageUrl)
            }
        },onError: {[weak self] error in
            guard let self = self else {return}
            self.showMassage(massage: "error in upload image", colorStyle: DesignSystem.Colors.MainColor.color)
        }).disposed(by: disposePag)
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        uploadImages()
    }
    
    @IBAction func addressOfCloent(_ sender: Any) {
        ClientAddress = true
        let mapView = coordinator.mainNavigator.viewController(for: .mapView(cartDate: []))
        navigationController?.pushViewController(mapView, animated: true)
    }
    @IBAction func addressofProvider(_ sender: Any) {
        ClientAddress = false
        let mapView = coordinator.mainNavigator.viewController(for: .mapView(cartDate: []))
        navigationController?.pushViewController(mapView, animated: true)
    }
    func tapGestureInImage(){
        imageofProdect.isUserInteractionEnabled = true
        let gestureProdect = UITapGestureRecognizer(target: self, action: #selector(imageGesture))
        gestureProdect.numberOfTapsRequired = 1
        imageofProdect.addGestureRecognizer(gestureProdect)
        
        imageOfProviderAddress.isUserInteractionEnabled = true
        let gesturemap = UITapGestureRecognizer(target: self, action: #selector(shoeMapForProvider))
        gesturemap.numberOfTapsRequired = 1
        imageOfProviderAddress.addGestureRecognizer(gesturemap)
        
        imageOfAddressClient.isUserInteractionEnabled = true
        let gesturAddressClient = UITapGestureRecognizer(target: self, action: #selector(shoeMapForClient))
        gesturAddressClient.numberOfTapsRequired = 1
        imageOfAddressClient.addGestureRecognizer(gesturAddressClient)
    }
    
    @objc func shoeMapForClient(){
        ClientAddress = true
        let mapView = coordinator.mainNavigator.viewController(for: .mapView(cartDate: []))
        navigationController?.pushViewController(mapView, animated: true)
    }
    
    @objc func shoeMapForProvider(){
        ClientAddress = false
        let mapView = coordinator.mainNavigator.viewController(for: .mapView(cartDate: []))
        navigationController?.pushViewController(mapView, animated: true)
    }
    
    @objc func imageGesture(){
        handleUploadImage()
    }
    
    func uploadImages(){
        guard let profileImage = imageofProdect.image else {
            self.showMassage(massage: "من فضلك اختار صور المنتح", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            return
        }
        
        if !selecteImage {
            self.showMassage(massage: "من فضلك اختار صور المنتح", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            return
        }
        loadingView.startAnimating()
        loadingView.isHidden = false
        conformBtn.isHidden = true
        vieeModel.uplaodImages(images: profileImage).subscribe(onNext: { (uploadRespond) in
            guard let imageurl = uploadRespond.data?[0].imageurl else {return}
            self.brandlogo.accept(imageurl)
        }, onError: { (error) in
            self.conformBtn.isHidden = false
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            
            let error = error as NSError
            if error.code == 13 {
                self.showMassage(massage: "لا يوجد اتصال بالانتزنت", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            }else{
                self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            }
        }).disposed(by: disposePag)
    }
    
    func conformOrder(prodectImage : String){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        guard let nameOfProdect = nameOfProdectTf.text , !nameOfProdect.isEmpty, let descProdect = descriptionOfProdecTf.text , !descProdect.isEmpty, let clientPhone = phoneOfClientTf.text , !clientPhone.isEmpty,let  phoneOfProvider = phoneOfProfider.text , !phoneOfProvider.isEmpty ,let prise = priceOfProdect.text , !prise.isEmpty, let addessOfClient = AddressTf.text , !addessOfClient.isEmpty, let addressOFprovider = addressOfProfider.text , !addressOFprovider.isEmpty , let clientName = nameOfClientTf.text , !clientName.isEmpty, let providerName = NameOfProfider.text , !providerName.isEmpty else {return}
        
        guard let clientLocation = locationOfClient else {return}
        guard let locationLocation = locationOfProvider else {return}
        
        
        if phoneOfProvider.first != "0" || phoneOfProvider.count < 11{
            self.showMassage(massage: " من فضلك ادخل رقم محمول المرسل بشكل صحيح", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        
        if clientPhone.first != "0" || clientPhone.count < 11{
            self.showMassage(massage: " من فضلك ادخل رقم محمول المستلم بشكل صحيح", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        
        let parmters : [String : String] = [
            "product_name": nameOfProdect,
            "product_img": prodectImage,
            "cost": prise,
            "order_description": descProdect,
            "customer_name": clientName,
            "customer_phone": clientPhone,
            "longitude": "\(clientLocation.longitude)",
            "latitude": "\(clientLocation.latitude)",
            "location": addessOfClient,
            "shop_name": providerName,
            "shop_phone": phoneOfProvider,
            "shop_location": addressOFprovider,
            "shop_long": "\(locationLocation.longitude)",
            "shop_lat": "\(locationLocation.latitude)",
            "caller_id": userId,
        ]
        
        let searchDelivery = coordinator.mainNavigator.viewController(for: .SearchDelivertyViewController(orderId: nil, OrderTaiarDate: parmters, image: imageofProdect.image))
       navigationController?.pushViewController(searchDelivery, animated: true)

    }
    
}

extension OrderTaierViewController  : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selecteImage = true
            imageofProdect.image = chosenimage
            imageofProdect.isCircle = true
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageofProdect.image = image
            imageofProdect.isCircle = true
            selecteImage = true
        }
        dismiss(animated: true, completion: nil)
    }
    func handleUploadImage(){
        let imagepicker = UIImagePickerController()
        imagepicker.sourceType = .photoLibrary
        
        imagepicker.allowsEditing = true
        imagepicker.delegate      = self
        present(imagepicker, animated: true, completion: nil)
    }
}

