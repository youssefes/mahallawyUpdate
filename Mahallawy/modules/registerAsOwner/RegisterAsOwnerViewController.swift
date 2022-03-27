//
//  RegisterAsOwnerViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import YPImagePicker
import iOSDropDown
import Alamofire
import CoreLocation
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import Toast_Swift
import Kingfisher

class RegisterAsOwnerViewController: BaseWireFrame<registerViewModel> {
    
    @IBOutlet weak var regisretBtn: UIButton!
     @IBOutlet weak var loadingRegister: NVActivityIndicatorView!
    @IBOutlet weak var nameOfMarket: UITextField!
    @IBOutlet weak var descraptionTf: UITextField!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var selectCatories: DropDown!
    @IBOutlet weak var timeOfWork: UITextField!
    @IBOutlet weak var imageMap: UIImageView!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var uiCollectionViewImafes: UICollectionView!
    
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet weak var newPasswordStack: UIStackView!
    
    var arrayOfIndexcatagories : [String] = []
    var arrayOfselectedString = [String]()
    var catagoryId : String?
    var gender = "male"
    var location : CLLocationCoordinate2D?
    var arrayOfselectedImage = [UIImage]()
 
    let cellIdentifier = "ImageOfMarketCollectionViewCell"
    
    var picker : YPImagePicker?
    var isImageUpdataed = false
    var isUpdate = false
    
    let dispatchGrop = DispatchGroup()
    var pice : PublishSubject<String> = .init()
    var brandlogo : BehaviorRelay<String> = .init(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: registerViewModel) {
         // MARK:   bind  brand data to update
        
        if let brandData = ViewModel.BarndData{
            isUpdate = true
            newPasswordStack.isHidden = false
            title = brandData.fullname
            nameOfMarket.text = brandData.fullname
            descraptionTf.text = brandData.infoDescription
            addressTf.text = brandData.address
            emailTf.text = brandData.email
            phoneTf.text = brandData.phone
            catagoryId = brandData.categoryid
            let Oldloacation = CLLocationCoordinate2D(latitude: Double(brandData.latitude ?? "0.0") ?? 0.0, longitude: Double(brandData.longitude ?? "0.0") ?? 0.0)
            self.location = Oldloacation
   
            selectCatories.text = brandData.categoryname
            if let image =  brandData.brandlogo {
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    userProfileImage.kf.setImage(with: resource)
                }
            }
            
            timeOfWork.text = brandData.worktime
            if let pices = brandData.pics {
                let array = pices.components(separatedBy: "-")
                self.arrayOfselectedString = array
                self.arrayOfselectedString.removeAll(where: {$0 == ""})
            }
            regisretBtn.setTitle("تحديث", for: .normal)
            
        }else{
            title = "تسجيل كصاحب متجر او منشاة"
        }
        
        ViewModel.SeccessUpdateBrandProfile.asObservable().subscribe(onNext: { [weak self] (resulteUpdate) in
            guard let self = self else {return}
            self.loadingRegister.isHidden = true
            self.regisretBtn.isHidden = false
            if resulteUpdate.response[0].statues {
                self.showMassage(massage: resulteUpdate.response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
            }else {
                self.showMassage(massage: resulteUpdate.response[0].message, colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            }
            
        }, onError: {[weak self] (error) in
            guard let self = self else {return}
            self.loadingRegister.isHidden = true
            self.regisretBtn.isHidden = false
            self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        }).disposed(by: disposePag)
        
        
        // MARK:   bind  location name from map 
        mapViewController.selectedAddre.subscribe(onNext: {[weak self] (address) in
            guard let self = self else {return}
            print(address)
            self.addressTf.text = address
        }).disposed(by: disposePag)
        
        // MARK:   bind selected location from map
        mapViewController.selectedLocation.subscribe(onNext: {[weak self] (location) in
            guard let self = self else {return}
            self.location = location
        }).disposed(by: disposePag)
        
        // MARK:   bind get Catagories func
        
        ViewModel.SeccessgetCatagoriesObservable.subscribe(onNext: { [weak self](catagories) in
            guard let self = self else {return}
            self.selectCatories.optionArray = catagories.categories.map({$0.catname})
            self.arrayOfIndexcatagories = catagories.categories.map({$0.id})
        }, onError: { [weak self] (error) in
                guard let self = self else {return}
            self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                
        }).disposed(by: disposePag)
        
        
        // MARK:   bind register func
    }
    func setupUi(){
        uiCollectionViewImafes.delegate = self
        uiCollectionViewImafes.dataSource = self
        uiCollectionViewImafes.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        tapGestureInImage()
        
        /// Allow swipe to select images.
     var config = YPImagePickerConfiguration()
 
        // Build a picker with your configuration
       config.library.maxNumberOfItems = 4
 
        picker = YPImagePicker(configuration: config)
        // MARK:   bind selected images  of prodect
        picker?.didFinishPicking { [unowned picker , weak self] items, cancelled in
           guard let self = self else {return}
            
           self.arrayOfselectedImage.removeAll()
            self.isImageUpdataed = true
            if items.isEmpty {
                self.isImageUpdataed = false
            }
           for item in items {
               switch item {
               case .photo(let photo):
                   self.arrayOfselectedImage.append(photo.image)
               case .video( _):
                   self.showMassage(massage: "من فضلك اختار صور فقد اختيار الفديو غير متاح حاليا", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
               }
           }
            self.uiCollectionViewImafes.reloadData()
            picker?.dismiss(animated: true, completion: nil)
       }
        vieeModel.getCatagories()
        
        // The the Closure returns Selected Index and String
        selectCatories.didSelect{ [weak self](selectedText , index ,id) in
            guard let self = self else {return}
            self.catagoryId = self.arrayOfIndexcatagories[index]
        }
         // MARK:   bind images upload of prodect
        pice.subscribe(onNext: { [weak self] (pics) in
            guard let self = self else {return}
            var picsToSend = pics
            if self.arrayOfselectedImage.count == 1{
                picsToSend += "--"
                self.registerOwner(Pics: picsToSend)
            }else if self.arrayOfselectedImage.count == 2{
                picsToSend += "-"
                self.registerOwner(Pics: picsToSend)
            } else if self.arrayOfselectedImage.count == 3{
                picsToSend += ""
                self.registerOwner(Pics: picsToSend)
            }else{
                self.registerOwner(Pics: picsToSend)
            }
            
            }, onError: {[weak self] (error) in
                guard let self = self else {return}
                self.regisretBtn.isHidden = false
                self.loadingRegister.isHidden = true
                self.loadingRegister.stopAnimating()
                self.showMassage(massage: "حدث خطا اثناء رفع الصور", colorStyle:#colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
        }).disposed(by: disposePag)
    }
    
    @IBAction func dissmisBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func SelectLoction(_ sender: Any) {
        let mapView = coordinator.mainNavigator.viewController(for: .mapView(cartDate: []))
        navigationController?.pushViewController(mapView, animated: true)
    }
    
    func tapGestureInImage(){
        userProfileImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageGesture))
        gesture.numberOfTapsRequired = 1
        userProfileImage.addGestureRecognizer(gesture)
        
        imageMap.isUserInteractionEnabled = true
        let gesturemap = UITapGestureRecognizer(target: self, action: #selector(shoeMap))
        gesture.numberOfTapsRequired = 1
        imageMap.addGestureRecognizer(gesturemap)
    }
    
    @objc func shoeMap(){
        let mapView = coordinator.mainNavigator.viewController(for: .mapView(cartDate: []))
        navigationController?.pushViewController(mapView, animated: true)
    }
    
    @objc func imageGesture(){
        handleUploadImage()
    }
 
    func uploadImages(){
    
        guard let profileImage = userProfileImage.image , profileImage != UIImage(named: "ic_camera") else {
            self.showMassage(massage: " من فضلك اضاف صور شخصية", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
            
        }
        loadingRegister.startAnimating()
        loadingRegister.isHidden = false
        regisretBtn.isHidden = true
        vieeModel.uplaodImages(images: profileImage).subscribe(onNext: { (uploadRespond) in
            guard let imageurl = uploadRespond.data?[0].imageurl else {return}
            self.brandlogo.accept(imageurl)
        }, onError: { (error) in
            self.regisretBtn.isHidden = false
            self.loadingRegister.isHidden = true
            self.loadingRegister.stopAnimating()
            
            let error = error as NSError
            if error.code == 13 {
                self.showMassage(massage: "لا يوجد اتصال بالانتزنت", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            }else{
                self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            }
        }).disposed(by: disposePag)
    }
    
   
   
    
    func uploadImagesOfProdect(){
        let group = DispatchGroup()
        var imagesSteing = ""
        for(_,image) in arrayOfselectedImage.enumerated(){
            group.enter()
            vieeModel.uplaodImages(images: image).subscribe(onNext: {  (uploadRespond) in
                guard let imageurl = uploadRespond.data?[0].imageurl else {return}
                imagesSteing += "\(imageurl)-"
                group.leave()
            }, onError: { [weak self] (error) in
                guard let self = self else {return}
                group.leave()
                self.pice.onError(error)
                return
            }).disposed(by: disposePag)
            
        }
        
         // MARK:   notify finished  upload  images of Prodect
        group.notify(queue: .main) {  [weak self] in
            guard let self = self else {return}
            self.pice.onNext(imagesSteing)
        }
    }
    
    func registerOwner(Pics : String){
        
        guard let email = emailTf.text, !email.isEmpty, let phone = phoneTf.text, !phone.isEmpty, let address = addressTf.text, !address.isEmpty,let name = nameOfMarket.text , !name.isEmpty ,
            let catagpry =  selectCatories.text , !catagpry.isEmpty, let description =  descraptionTf.text , !description.isEmpty, let timeOfWork =  timeOfWork.text , !timeOfWork.isEmpty  else {return}
        if phone.first != "0" || phone.count < 11{
            self.showMassage(massage: " من فاضلك ادخل رقم هاتف صحيج", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        guard let password = self.passwordTf.text , !password.isEmpty else {
            self.showMassage(massage: "من فضلك ادخل كلمة السر ", colorStyle: #colorLiteral(red: 0.4083364606, green: 0.1163095608, blue: 0.09655132145, alpha: 1))
            return
        }
        let newpassword = passwordTf.text
        // MARK:   upload profile image
        uploadImages()
        
         // MARK: subscribe to fun of  profile image upload
        self.brandlogo.subscribe(onNext: { (imageUrl) in
            if imageUrl.isEmpty{
                print("no thing")
            }else{
                if self.isUpdate{
                    guard let userid = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String , let cataId =  self.catagoryId else {return}
                    let paramerter : [String : String] = [
                        "userid" : userid,
                        "fullname" : name,
                        "description": description,
                        "email": email,
                        "phone":phone,
                        "password": password ,
                        "address":address,
                        "longitude": "\(self.location?.longitude  ?? 0)" ,
                        "latitude": "\(self.location?.latitude ?? 0)" ,
                        "worktime": timeOfWork,
                        "categoryid": cataId,
                        "categoryname" : catagpry,
                        "brandlogo" : imageUrl,
                        "pics" : Pics,
                        "old_password" : newpassword ?? "",
                        "device_type" : "ios"
                    ]
                    
                    let brandInf = Info(status: true, message: "", id: userid, usertype: "1", fullname: name, infoDescription: description, email: email, phone: phone, gender: self.gender, address: address, brandlogo: imageUrl, longitude: "\(self.location?.longitude  ?? 0)", latitude: "\(self.location?.latitude ?? 0)", worktime: timeOfWork, categoryid: cataId, categoryname: catagpry, pics: Pics, profile_img: nil, moto_img: nil, card_img_img: nil, driving_license: nil, age: nil)
                    
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        // Encode Note
                        let data = try encoder.encode(brandInf)
                        // Write/Set Data
                        UserDefaults.standard.set(data, forKey: NetworkConstants.brandModel)
                    } catch {
                        print("Unable to Encode Note (\(error))")
                    }
                    UserDefaults.standard.set(cataId, forKey: NetworkConstants.catid)
                    UserDefaults.standard.set(catagpry, forKey: NetworkConstants.catname)
                    UserDefaults.standard.set(name, forKey: NetworkConstants.brandname)
                    UserDefaults.standard.set(imageUrl, forKey: NetworkConstants.brandlogo)
                    self.vieeModel.updatabrandProfile(parameters:  paramerter).subscribe { [weak self] (respond) in
                        if respond.response[0].statues{
                            self?.regisretBtn.isHidden = false
                            self?.loadingRegister.isHidden = true
                            self?.loadingRegister.stopAnimating()
                            self?.showMassage(massage: respond.response[0].message , colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
                        }else{
                            self?.regisretBtn.isHidden = false
                            self?.loadingRegister.isHidden = true
                            self?.loadingRegister.stopAnimating()
                            self?.showMassage(massage: respond.response[0].message , colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
                        }
                    } onError: { [weak self] ( error) in
                        let error = error as NSError
                        if error.code == 13 {
                            self?.regisretBtn.isHidden = false
                            self?.loadingRegister.isHidden = true
                            self?.loadingRegister.stopAnimating()
                            self?.showMassage(massage: "لا يوجد اتصال بالانتزنت", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                        }else{
                            self?.regisretBtn.isHidden = false
                            self?.loadingRegister.isHidden = true
                            self?.loadingRegister.stopAnimating()
                            self?.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                        }
                    }.disposed(by: self.disposePag)

                    
                }else{
                    guard let password = self.passwordTf.text else {return}
                    let paramerters : [String : String] = [
                        "usertype" : "1",
                        "fullname" : name,
                        "description": description,
                        "email": email,
                        "phone":phone,
                        "password": password,
                        "address":address,
                        "longitude": "\(self.location?.longitude  ?? 0)" ,
                        "latitude": "\(self.location?.latitude ?? 0)" ,
                        "worktime": timeOfWork,
                        "categoryid": self.catagoryId ?? "",
                        "categoryname" : catagpry,
                        "brandlogo" : imageUrl,
                        "gender":self.gender,
                        "pics" : Pics,
                        "device_type" : "ios"
                    ]
                    
                    // MARK: call  func of  register  user in view Model
                    self.vieeModel.register(postData: paramerters).subscribe(onNext: { [weak self] (registerDataResulte) in
                        guard let self = self else {return}
                    let data =  registerDataResulte.info[0]
                    if data.status{
                        do {
                            // Create JSON Encoder
                            let encoder = JSONEncoder()
                            // Encode Note
                            let data = try encoder.encode(data)
                            // Write/Set Data
                            UserDefaults.standard.set(data, forKey: NetworkConstants.brandModel)
                        } catch {
                            print("Unable to Encode Note (\(error))")
                        }
                      
                        
                        if let id = data.id, let userType = data.usertype, let Cataid = data.categoryid, let CatName = data.categoryname,  let brandlog = data.brandlogo , let brandname = data.fullname , let userPhone = data.phone {
                            UserDefaults.standard.set(userPhone, forKey: NetworkConstants.userPhone)
                            UserDefaults.standard.set(userType, forKey: NetworkConstants.userType)
                            UserDefaults.standard.set(id, forKey: NetworkConstants.userIdKey)
                            UserDefaults.standard.set(Cataid, forKey: NetworkConstants.catid)
                            UserDefaults.standard.set(CatName, forKey: NetworkConstants.catname)
                            UserDefaults.standard.set(brandname, forKey: NetworkConstants.brandname)
                            UserDefaults.standard.set(brandlog, forKey: NetworkConstants.brandlogo)
                            DispatchQueue.main.async {
                                let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
                                self.navigationController?.pushViewController(HomeView, animated: true)
                            }
                        }
                        
                        
                    }else{
                        self.regisretBtn.isHidden = false
                        self.loadingRegister.isHidden = true
                        self.loadingRegister.stopAnimating()
                        self.showMassage(massage: data.message ?? "", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                    }
                }, onError: { [weak self] (error) in
                        guard let self = self else {return}
                    self.regisretBtn.isHidden = false
                    self.loadingRegister.isHidden = true
                    self.loadingRegister.stopAnimating()

                    let error = error as NSError
                    if error.code == 13 {
                        self.regisretBtn.isHidden = false
                        self.loadingRegister.isHidden = true
                        self.loadingRegister.stopAnimating()
                        self.showMassage(massage: "لا يوجد اتصال بالانتزنت", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                    }else{
                        self.regisretBtn.isHidden = false
                        self.loadingRegister.isHidden = true
                        self.loadingRegister.stopAnimating()
                        self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                    }
                        
                }).disposed(by: self.disposePag)
                
                }
                 
            }
        }).disposed(by: disposePag)
        
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        guard let email = emailTf.text, !email.isEmpty, let phone = phoneTf.text, !phone.isEmpty, let address = addressTf.text, !address.isEmpty,let name = nameOfMarket.text , !name.isEmpty ,
            let catagpry =  selectCatories.text , !catagpry.isEmpty, let description =  descraptionTf.text , !description.isEmpty, let timeOfWork =  timeOfWork.text , !timeOfWork.isEmpty  else {
            self.showMassage(massage: "من فضلك ادخل جميع البيانات مطلوبه  ", colorStyle: #colorLiteral(red: 0.4083364606, green: 0.1163095608, blue: 0.09655132145, alpha: 1))
            return}
        
        guard let password = self.passwordTf.text , !password.isEmpty else {
            self.showMassage(massage: "من فضلك ادخل كلمة السر ", colorStyle: #colorLiteral(red: 0.4083364606, green: 0.1163095608, blue: 0.09655132145, alpha: 1))
            return
        }
        if  userProfileImage.image == #imageLiteral(resourceName: "ic_camera") {
            showMassage(massage:"من  فاضل اختار صورة المنتج", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            return
        }
        
        if isUpdate{
            if isImageUpdataed{
                if arrayOfselectedImage.isEmpty{
                    showMassage(massage: "من فاضلك اختار صوره علي الاقل للمنتج", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                }else{
                    loadingRegister.startAnimating()
                    loadingRegister.isHidden = false
                    regisretBtn.isHidden = true
                    uploadImagesOfProdect()
                }
            }else{
                var picsToSend = arrayOfselectedString.joined(separator: "-")
                if self.arrayOfselectedString.count == 1{
                    picsToSend += "--"
                   self.registerOwner(Pics: picsToSend)
                }else if self.arrayOfselectedString.count == 2{
                    picsToSend += "-"
                    self.registerOwner(Pics: picsToSend)
                } else if self.arrayOfselectedString.count == 3{
                    picsToSend += ""
                    self.registerOwner(Pics: picsToSend)
                }else{
                    self.registerOwner(Pics: picsToSend)
                }
                print(picsToSend)
            }
            
        }else {
            if arrayOfselectedImage.isEmpty{
                showMassage(massage: "من فاضلك اختار صوره علي الاقل للمنتج", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            }else{
                loadingRegister.startAnimating()
                loadingRegister.isHidden = false
                regisretBtn.isHidden = true
                
                // MARK: call func upload Prodect images
                uploadImagesOfProdect()
            }
        }
    }
}

extension RegisterAsOwnerViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfselectedImage.isEmpty , arrayOfselectedString.isEmpty{
            return 4
        }else{
            return isImageUpdataed ? arrayOfselectedImage.count : arrayOfselectedString.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as!
        ImageOfMarketCollectionViewCell
        if isImageUpdataed {
            if arrayOfselectedImage.isEmpty {
                return cell
            }else{
                let image =  arrayOfselectedImage[indexPath.row]
                cell.imageOfMarket.image = image
                return cell
            }
        }else{
            if arrayOfselectedString.isEmpty {
                return cell
            }else{
                let image =  arrayOfselectedString[indexPath.row]
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    cell.imageOfMarket.kf.setImage(with: resource)
                }
                return cell
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let padding: CGFloat = 10
        
        let availableWidth =  width - (padding * 4)
        let itemWidth = availableWidth / 4
        
        let size = CGSize(width: itemWidth, height: itemWidth)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let picker = picker else {return}
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension RegisterAsOwnerViewController  : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userProfileImage.image = chosenimage
            userProfileImage.isCircle = true
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userProfileImage.image = image
            userProfileImage.isCircle = true
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
