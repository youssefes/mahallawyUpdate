//
//  RegisterAsDelivery.swift
//  Mahallawy
//
//  Created by jooo on 10/7/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Toast_Swift
import Kingfisher
class RegisterAsDelivery: BaseWireFrame<registerViewModel> {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var ageTf: UITextField!
    @IBOutlet weak var imageofMotoS: UIImageView!
    @IBOutlet weak var imageOfIdentifer: UIImageView!
    @IBOutlet weak var imageOfLicence: UIImageView!
    @IBOutlet weak var phonetf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var imageOfUser: UIImageView!
    var dispatchGroup = DispatchGroup()
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    var isLicenceImage = false
    var isUserImage = false
    var isMotoimage = false
    var isIdentifierImage = false
    
    var LicenceImage = ""
    var UserImage = ""
    var Motoimage = ""
    var IdentifierImage = ""
    var isUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: registerViewModel) {
        setUpUi()
        
        if let brandData = ViewModel.BarndData{
            isUpdate = true
            title = brandData.fullname
            fullName.text = brandData.fullname
            phonetf.text = brandData.phone
            ageTf.text = brandData.age
            
            registerBtn.setTitle("تحديث", for: .normal)
            
            if let image =  brandData.profile_img {
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    imageOfUser.kf.setImage(with: resource)
                }
            }
            if let image =  brandData.card_img_img {
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    imageOfIdentifer.kf.setImage(with: resource)
                }
            }
            if let image =  brandData.moto_img {
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    imageofMotoS.kf.setImage(with: resource)
                }
            }
            if let image =  brandData.driving_license {
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    imageOfLicence.kf.setImage(with: resource)
                }
            }
            
        }else{
            title = "تسجيل كمندوب توصيل"
        }
        
    }
    
    func setUpUi(){
        tapGestureInImage()
    }

    func tapGestureInImage(){
        imageOfUser.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImage))
        gesture.numberOfTapsRequired = 1
        imageOfUser.addGestureRecognizer(gesture)
        
        imageOfIdentifer.isUserInteractionEnabled = true
        let gesturemap = UITapGestureRecognizer(target: self, action: #selector(IdenfifierImage))
        gesture.numberOfTapsRequired = 1
        imageOfIdentifer.addGestureRecognizer(gesturemap)
        
        imageOfLicence.isUserInteractionEnabled = true
        let gestureLicence = UITapGestureRecognizer(target: self, action: #selector(licenceImage))
        gesture.numberOfTapsRequired = 1
        imageOfLicence.addGestureRecognizer(gestureLicence)
        
        imageofMotoS.isUserInteractionEnabled = true
        let gesturMoto = UITapGestureRecognizer(target: self, action: #selector(MotoImage))
        gesture.numberOfTapsRequired = 1
        imageofMotoS.addGestureRecognizer(gesturMoto)
    }
    
    
    @objc func userImage(){
        isLicenceImage = false
        isUserImage = true
        isMotoimage = false
        isIdentifierImage = false
        handleUploadImage()
    }
    
    @objc func licenceImage(){
        isLicenceImage = true
        isUserImage = false
        isMotoimage = false
        isIdentifierImage = false
        handleUploadImage()
    }
    
    @objc func MotoImage(){
        isLicenceImage = false
        isUserImage = false
        isMotoimage = true
        isIdentifierImage = false
        handleUploadImage()
    }
    
    @objc func IdenfifierImage(){
        isLicenceImage = false
        isUserImage = false
        isMotoimage = false
        isIdentifierImage = true
        handleUploadImage()
    }
    
    func uploadImages(image : UIImage,isLicenceImage: Bool , isUserImage : Bool, isMotoimage : Bool ,isIdentifierImage : Bool){
        loadingView.startAnimating()
        loadingView.isHidden = false
        registerBtn.isHidden = true
        vieeModel.uplaodImages(images: image).subscribe(onNext: { (uploadRespond) in
            guard let imageurl = uploadRespond.data?[0].imageurl else {return}
            if isMotoimage{
                self.dispatchGroup.leave()
                self.Motoimage = imageurl
            }else if isUserImage{
                self.dispatchGroup.leave()
                self.UserImage = imageurl
            }else if isLicenceImage{
                self.dispatchGroup.leave()
                self.LicenceImage = imageurl
            }else if isIdentifierImage{
                self.dispatchGroup.leave()
                self.IdentifierImage = imageurl
            }
        }, onError: { (error) in
            self.registerBtn.isHidden = false
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
    
    @IBAction func regigsterBtn(_ sender: UIButton) {
        
        
        guard let imageofuser = imageOfUser.image , imageofuser != UIImage(named: "ic_camera") else {
            self.showMassage(massage: " من فضلك اضاف صور شخصية", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
            
        }
        guard  let password = passwordTf.text, !password.isEmpty, let phone = phonetf.text, !phone.isEmpty,let name = fullName.text , !name.isEmpty ,let age = ageTf.text, !age.isEmpty else {return}
        if phone.first != "0" || phone.count < 11{
            self.showMassage(massage: " من فضلك ادخل رقم هاتف صحيج", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
     
      
        guard let imageofidentifer = imageOfIdentifer.image else {
            self.showMassage(massage: " من فضلك اضاف صور البطاقة", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
            
        }
        guard let imageOfLicence = imageOfLicence.image else {
            self.showMassage(massage: " من فضلك اضاف صور رخصة القيادة", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
            
        }
        guard let imageofMoto = imageofMotoS.image else {
            self.showMassage(massage: " من فضلك اضاف صور الموتوسيكل", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
            
        }
        dispatchGroup.enter()
        uploadImages(image: imageofuser, isLicenceImage: false, isUserImage: true, isMotoimage: false, isIdentifierImage: false)
        dispatchGroup.enter()
        uploadImages(image: imageofidentifer, isLicenceImage: false, isUserImage: false, isMotoimage: false, isIdentifierImage: true)
      
        dispatchGroup.enter()
        uploadImages(image: imageOfLicence, isLicenceImage: true, isUserImage: false, isMotoimage: false, isIdentifierImage: false)
      
        dispatchGroup.enter()
        uploadImages(image: imageofMoto, isLicenceImage: false, isUserImage: false, isMotoimage: true, isIdentifierImage: false)
    
        sender.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
 
        dispatchGroup.notify(queue: .main) {
            let paramerters : [String : String] = [
                "name" : name,
                "phone":phone,
                "password": password,
                "age":age,
                "profile_img": self.UserImage,
                "moto_img": self.Motoimage,
                "card_img_img": self.IdentifierImage,
                "driving_license": self.LicenceImage,
                "device_type" : "ios"
            ]
            print(paramerters)
            self.vieeModel.RegisterAsDelivery(postData: paramerters).subscribe(onNext: { [weak self]  (DeliveryData) in
                guard let self = self else {return}
                guard  let delivery = DeliveryData.info.first else {return}
                    print(delivery)
                if  delivery.status {
                    if let id = delivery.id, let userType = delivery.usertype, let deliveryname = delivery.fullname , let userImage = delivery.profile_img{
                        UserDefaults.standard.set(deliveryname, forKey: NetworkConstants.brandname)
                        UserDefaults.standard.set(userType, forKey: NetworkConstants.userType)
                        UserDefaults.standard.set(id, forKey: NetworkConstants.userIdKey)
                        UserDefaults.standard.set(userImage, forKey: NetworkConstants.brandlogo)
                    }
                   
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        // Encode Note
                        let data = try encoder.encode(delivery)
                        // Write/Set Data
                        UserDefaults.standard.set(data, forKey: NetworkConstants.deliveryDate)
                        UserDefaults.standard.synchronize()
                        let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
                        self.navigationController?.pushViewController(HomeView, animated: true)
                    } catch {
                        print("Unable to Encode Note (\(error))")
                    }
                  
                }else{
                    guard let msg = delivery.message else {return}
                    self.loadingView.isHidden = true
                    self.registerBtn.isHidden = false
                    self.loadingView.startAnimating()
                    self.showMassage(massage: msg, colorStyle: .red)
                }
               
            }, onError: { [weak self] (error) in
                guard let self = self else {return}
                let msg = error.localizedDescription
                self.loadingView.isHidden = true
                self.registerBtn.isHidden = false
                self.loadingView.startAnimating()
                self.showMassage(massage: msg, colorStyle: .red)
            }).disposed(by: self.disposePag)
        }
        }
        
    
}
extension RegisterAsDelivery  : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if isMotoimage{
                imageofMotoS.image = chosenimage
                imageofMotoS.contentMode = .scaleAspectFill
            }else if isUserImage{
                imageOfUser.image = chosenimage
                imageOfUser.contentMode = .scaleAspectFill
            }else if isLicenceImage{
                imageOfLicence.image = chosenimage
                imageOfLicence.contentMode = .scaleAspectFill
            }else if isIdentifierImage{
                imageOfIdentifer.image = chosenimage
                imageOfIdentifer.contentMode = .scaleAspectFill
            }
            
            
            
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if isMotoimage{
                imageofMotoS.image = image
                imageofMotoS.contentMode = .scaleAspectFill
            }else if isUserImage{
                imageOfUser.image = image
                imageOfUser.contentMode = .scaleAspectFill
            }else if isLicenceImage{
                imageOfLicence.image = image
                imageOfLicence.contentMode = .scaleAspectFill
            }else if isIdentifierImage{
                imageOfIdentifer.image = image
                imageOfIdentifer.contentMode = .scaleAspectFill
            }
            
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
