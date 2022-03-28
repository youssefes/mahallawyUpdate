//
//  menueViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/20/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import SideMenu
class menueViewController: BaseWireFrame<MyAddvertismentViewModel> {

    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var imageOfUser: UIImageView!
    @IBOutlet weak var numberOfAdds: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    let cellIdentifier = "menuTableViewCell"
    
var arrayOfElementInMenuOfNormal : [String] = ["طلبات التوصيل","طلباتي","السلة","أعلاناتي","المفضلة","نشر وظيفة","أكتشف","طلب مندوب توصيل","طلبات التوصيل", "تواصل معنا","من نحن"]
    var arrayOfElementInMenuOfOwner : [String] = ["طلباتي","المفضلة","أكتشف","أعلاناتي","نشر وظيفة","اضافة اعلان", "طلب مندوب توصيل","طلبات التوصيل","تواصل معنا","من نحن"]
    
    var arrayOfElementInMenuOfNormalimages : [UIImage] = [#imageLiteral(resourceName: "delivery-man"),#imageLiteral(resourceName: "home_icon_nav"),#imageLiteral(resourceName: "Buy"), #imageLiteral(resourceName: "myads"),#imageLiteral(resourceName: "favurite"),#imageLiteral(resourceName: "add ads"),#imageLiteral(resourceName: "ic_search_white_24dp"),#imageLiteral(resourceName: "delivery-man"),#imageLiteral(resourceName: "delivery-man"),#imageLiteral(resourceName: "contact-us"),#imageLiteral(resourceName: "aboutus"),#imageLiteral(resourceName: "login_icon")]
    
    var arrayOfElementInMenuOfOwnerimages : [UIImage] = [#imageLiteral(resourceName: "home_icon_nav"),#imageLiteral(resourceName: "favurite"),#imageLiteral(resourceName: "ic_search_white_24dp"),#imageLiteral(resourceName: "myads"),#imageLiteral(resourceName: "add ads"),#imageLiteral(resourceName: "add ads"),#imageLiteral(resourceName: "delivery-man"),#imageLiteral(resourceName: "delivery-man"),#imageLiteral(resourceName: "contact-us"),#imageLiteral(resourceName: "aboutus"),#imageLiteral(resourceName: "login_icon")]
    
  
    var ArrayOfVC : [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
        
        // Do any additional setup after loading the view.
    }

    override func bind(ViewModel: MyAddvertismentViewModel) {
        ViewModel.SeccessGetBrandDverisment.asObservable().subscribe(onNext: { [weak self] (adds) in
            guard let self = self else {return}
            self.numberOfAdds.text = "\(adds.count) اعلان"
        }).disposed(by: disposePag)
        
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "1"{
                ViewModel.getMyAddvertisMent(parameters: ["userid" : userId])
            }
        }
      
    }
    
    func setUpUi(){
        
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String {
            print(userId)
            arrayOfElementInMenuOfOwner.append("تسجيل الخروج")
            arrayOfElementInMenuOfNormal.append("تسجيل الخروج")
        }else{
            arrayOfElementInMenuOfOwner.append("تسجيل الدخول")
            arrayOfElementInMenuOfNormal.append("تسجيل الدخول")
        }
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.self)
        let explorVc = coordinator.mainNavigator.viewController(for: .explorVC)
        let Orders = coordinator.mainNavigator.viewController(for: .OrdersViewController)
        let loginVc = coordinator.mainNavigator.viewController(for: .login)
        let addAdvertisment = coordinator.mainNavigator.viewController(for: .addAdvertisment(Addvertise: nil, isFromClient: false))
        let contectUs = coordinator.mainNavigator.viewController(for: .ContectUs)
         let whoAreView = coordinator.mainNavigator.viewController(for: .whoAreView)
        let favorites = coordinator.mainNavigator.viewController(for: .Favourites)
        let myAddvertisment = coordinator.mainNavigator.viewController(for: .MyAddvertisment)
        let Cart = coordinator.mainNavigator.viewController(for: .CartViewController(arrayOfProdect: nil))
        let taiarOrders = coordinator.mainNavigator.viewController(for: .ordersOftaiar)
        let OrderTaierViewController = coordinator.mainNavigator.viewController(for: .OrderTaierViewController)
        let mywallet = coordinator.mainNavigator.viewController(for: .MyWalletViewController)
        let addJob = coordinator.mainNavigator.viewController(for: .JobDetailesVc(job: nil))
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            let name = UserDefaults.standard.value(forKey: NetworkConstants.brandname) as? String
            nameLbl.text = name
            if userType == "1" {
                ArrayOfVC = [Orders,favorites,explorVc,myAddvertisment,addJob,addAdvertisment,OrderTaierViewController, taiarOrders ,contectUs,whoAreView,loginVc]
                editProfileBtn.isHidden = false
                editProfileBtn.isHidden = false
                numberOfAdds.isHidden = false
                if let logo =  UserDefaults.standard.value(forKey: NetworkConstants.brandlogo) as? String  {
                    if let url = URL(string: logo){
                        print(url)
                        let resourc = ImageResource(downloadURL: url)
                        self.imageOfUser.kf.setImage(with: resourc)
                    }
                }
            }else if userType == "2"{
                ArrayOfVC =  [taiarOrders,Orders,Cart,myAddvertisment,favorites,addJob,explorVc, mywallet,contectUs ,whoAreView,loginVc]
                arrayOfElementInMenuOfNormal.remove(at: 7)
                arrayOfElementInMenuOfNormalimages.remove(at: 7)
                arrayOfElementInMenuOfNormalimages.insert(#imageLiteral(resourceName: "wallet"), at: 7)
                arrayOfElementInMenuOfNormal.insert("محفظتي", at: 7)
                
                arrayOfElementInMenuOfNormal.remove(at: 8)
                arrayOfElementInMenuOfNormalimages.remove(at: 8)
                editProfileBtn.isHidden = false
                editProfileBtn.isHidden = false
                numberOfAdds.isHidden = true
                if let deliveryImage =  UserDefaults.standard.value(forKey: NetworkConstants.deliveryImage) as? String  {
                    if let url = URL(string: deliveryImage){
                        print(url)
                        let resourc = ImageResource(downloadURL: url)
                        self.imageOfUser.kf.setImage(with: resourc)
                    }
                }
            }else{
                let tairOrdersImage = arrayOfElementInMenuOfNormalimages.removeFirst()
                let tairOrdersTitle = arrayOfElementInMenuOfNormal.removeFirst()
                editProfileBtn.isHidden = true
                numberOfAdds.isHidden = true
//                arrayOfElementInMenuOfNormal.insert(tairOrdersTitle, at: 5)
//                arrayOfElementInMenuOfNormalimages.insert(tairOrdersImage, at: 5)
                ArrayOfVC = [Orders,Cart,myAddvertisment,favorites,addJob,explorVc,OrderTaierViewController,taiarOrders,contectUs,whoAreView,loginVc]
            }
        }else{
//            editProfileBtn.isHidden = true
//            numberOfAdds.isHidden = true
//            ArrayOfVC = [Orders,favorites,explorVc,contectUs,whoAreView,loginVc]
            
            let tairOrdersImage = arrayOfElementInMenuOfNormalimages.removeFirst()
            let tairOrdersTitle = arrayOfElementInMenuOfNormal.removeFirst()
            editProfileBtn.isHidden = true
            numberOfAdds.isHidden = true
//            arrayOfElementInMenuOfNormal.insert(tairOrdersTitle, at: 5)
//            arrayOfElementInMenuOfNormalimages.insert(tairOrdersImage, at: 5)
            ArrayOfVC = [Orders,Cart,myAddvertisment,favorites, addJob,explorVc,OrderTaierViewController,taiarOrders,contectUs,whoAreView,loginVc]
           print("User Type Unkown")
        }
        
        
    }
    
    @IBAction func editProfile(_ sender: Any) {
        // Read/Get Data
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "1" {
                if let data = UserDefaults.standard.data(forKey: NetworkConstants.brandModel) {
                    do {
                        // Create JSON Decoder
                        let decoder = JSONDecoder()
                        // Decode Note
                        let note = try decoder.decode(Info.self, from: data)
                        let profile = coordinator.mainNavigator.viewController(for: .RegisterAsOwner(brandData: note))
                        navigationController?.pushViewController(profile, animated: true)
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
            }else{
                if let data = UserDefaults.standard.data(forKey: NetworkConstants.deliveryDate) {
                    do {
                        // Create JSON Decoder
                        let decoder = JSONDecoder()
                        // Decode Note
                        let note = try decoder.decode(Info.self, from: data)
                        let profile = coordinator.mainNavigator.viewController(for: .RegisterAsDelivery(DeliveryData: note))
                        navigationController?.pushViewController(profile, animated: true)
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
            }
        }
        
    }
    
}

extension menueViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "1"{
                 return arrayOfElementInMenuOfOwner.count
            }else{
                 return arrayOfElementInMenuOfNormal.count
            }
        }else{
            return arrayOfElementInMenuOfNormal.count
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! menuTableViewCell
        cell.selectionStyle = .none
        
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "1"{
                 cell.nameLbl.text = arrayOfElementInMenuOfOwner[indexPath.row]
                 cell.imageIcon?.image = arrayOfElementInMenuOfOwnerimages[indexPath.row]
                cell.imageIcon.tintColor = .white
            }else{
                 cell.nameLbl.text = arrayOfElementInMenuOfNormal[indexPath.row]
                cell.imageIcon?.image = arrayOfElementInMenuOfNormalimages[indexPath.row]
                cell.imageIcon.tintColor = .white
            }
        }else{
            cell.nameLbl.text = arrayOfElementInMenuOfNormal[indexPath.row]
           cell.imageIcon?.image = arrayOfElementInMenuOfNormalimages[indexPath.row]
            cell.imageIcon.tintColor = .white
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArrayOfVC[indexPath.row]
        vc.modalPresentationStyle = .overFullScreen
        
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String{
            if ArrayOfVC.last == ArrayOfVC[indexPath.row]{
                UserDefaults.standard.removeObject(forKey: NetworkConstants.userIdKey)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.userType)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.catname)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.brandid)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.brandModel)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.brandlogo)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.deliveryAccaptedOrNot)
                UserDefaults.standard.removeObject(forKey: NetworkConstants.userPhone)
                UserDefaults.standard.synchronize()
                coordinator.isLogIn = false
            }else{
                DispatchQueue.main.async { [weak self] in
                     guard let self = self else {return}
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
           
        }else{
            print(indexPath.row)
            if ArrayOfVC.last == ArrayOfVC[indexPath.row]{
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if indexPath.row == 9 {
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    showAlertTologein(massage: "من فضلك سجل الدخول ")
                }
               
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
