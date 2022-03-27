//
//  loginViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import NVActivityIndicatorView
import Toast_Swift
import AuthenticationServices

class loginViewController: BaseWireFrame<loginViewModel>{
    
    @IBOutlet weak var containerOfRegister: UIView!
 
    @IBOutlet weak var doNotHaveBtn: UIButton!
    @IBOutlet weak var passwordTx: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var regisretBtn: UIButton!
    @IBOutlet weak var loadingRegister: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func bind(ViewModel: loginViewModel) {
        containerOfRegister.clipsToBounds = false
        containerOfRegister.layer.cornerRadius = 30
        containerOfRegister.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }    
    func showMassageError(massage : String){
        regisretBtn.isHidden = false
        loadingRegister.isHidden = true
        loadingRegister.stopAnimating()
        var style = ToastStyle()
        style.messageColor = .white
        style.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        DispatchQueue.main.async {
            self.view.makeToast(massage, duration: 3.0, position: .bottom, style: style)
        }
    }
    func setupUI(){
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: Font.Light.name, size: 15)! // Note the !
        ] as [NSAttributedString.Key : Any]
        passwordTx.attributedPlaceholder = NSAttributedString(string: "الرقم السري", attributes: attributes)
        emailTf.attributedPlaceholder = NSAttributedString(string: "رقم الهاتف او البريد الالكتروني", attributes: attributes)
        
    }
    @IBAction func doNotHave(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.containerOfRegister.isHidden.toggle()
        }
       
    }

    @IBAction func dliveryBtn(_ sender: Any) {
        let registerAsDelivery = coordinator.mainNavigator.viewController(for: .RegisterAsDelivery(DeliveryData: nil))
        navigationController?.pushViewController(registerAsDelivery, animated: true)
    }
    @IBAction func sellerBtn(_ sender: Any) {
        let registerAsOwner = coordinator.mainNavigator.viewController(for: .RegisterAsOwner(brandData: nil))
        navigationController?.pushViewController(registerAsOwner, animated: true)
    }
    
    @IBAction func clientBtn(_ sender: Any) {
        let register = coordinator.mainNavigator.viewController(for: .register)
        navigationController?.pushViewController(register, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailTf.text, !email.isEmpty, let password = passwordTx.text, !password.isEmpty else{return}
        
        regisretBtn.isHidden = true
        
        
        loadingRegister.isHidden = false
        loadingRegister.startAnimating()
        let paramerter : [String : String] = [
            "email_phone"  : email,
            "password": password,
            "device_type" : "ios"
        ]
        
        
        
        vieeModel.SignIn(parameters: paramerter).subscribe(onNext: { [weak self] (resulte) in
            guard let self = self else {return}
            if resulte.info[0].status {
                let data = resulte.info[0]
                if data.usertype == "1" || data.usertype == "2"{
                    do {
                        // Create JSON Encoder
                        let encoder = JSONEncoder()
                        // Encode brandModel
                        let dataDefode = try encoder.encode(data)
                        // Write/Set Data
                        if data.usertype == "2" {
                            UserDefaults.standard.set(dataDefode, forKey: NetworkConstants.deliveryDate)
                        }else{
                            UserDefaults.standard.set(dataDefode, forKey: NetworkConstants.brandModel)
                        }
                       
                    } catch {
                        print("Unable to Encode Note (\(error))")
                    }
                    
                    if let id = data.id, let userType = data.usertype, let Cataid = data.categoryid, let CatName = data.categoryname,  let brandlog = data.brandlogo , let brandname = data.fullname, let userPhone = data.phone{
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
                    guard let id = data.id else {return}
                    guard  let userType = data.usertype , let username = data.fullname else {return}
                    if let userPhone = data.phone {
                        UserDefaults.standard.set(userPhone, forKey: NetworkConstants.userPhone)
                    }
                    UserDefaults.standard.set(username, forKey: NetworkConstants.brandname)
                    UserDefaults.standard.setValue(id, forKey: NetworkConstants.userIdKey)
                    UserDefaults.standard.setValue(userType, forKey: NetworkConstants.userType)
                  
                    DispatchQueue.main.async {
                        let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
                        self.navigationController?.pushViewController(HomeView, animated: true)
                    }
                }
            }else{
                guard let message = resulte.info[0].message else {return}
                self.showMassageError(massage: message)
            }
            
        }, onError: { [weak self] (error) in
            guard let self = self else {return}
            self.loadingRegister.stopAnimating()
            let error = error as NSError
            if error.code == 13 {
                self.showMassageError(massage: "لا يوجد اتصال بالانتزنت")
            }else{
                print(error)
                self.showMassageError(massage: error.localizedDescription)
            }
            
        }).disposed(by: disposePag)
    }
    
    @IBAction func SkipBtn(_ sender: Any) {
        let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
        self.navigationController?.pushViewController(HomeView, animated: true)
    }
    
    @IBAction func forgettPasswordBtn(_ sender: Any) {
        let forget = coordinator.mainNavigator.viewController(for: .forget)
        navigationController?.pushViewController(forget, animated: true)
    }
}

