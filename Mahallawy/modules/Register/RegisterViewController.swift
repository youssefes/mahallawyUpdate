//
//  RegisterViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/12/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import NVActivityIndicatorView
import Toast_Swift
import AuthenticationServices
import RxSwift
import RxCocoa
class RegisterViewController: BaseWireFrame<registerViewModel> {
    
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var loadingRegister: NVActivityIndicatorView!
    @IBOutlet weak var famaleView: UIView!
    @IBOutlet weak var manView: UIView!
    @IBOutlet weak var bassword: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var man: UIButton!
    @IBOutlet weak var famalbtn: UIButton!
    @IBOutlet weak var addresstf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    
    @IBOutlet weak var regisretBtn: UIButton!
    
    let loginMangerOfFaceBook = LoginManager()
    var gender : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "تسجيل  حساب عادي"
        setupAppleSignIn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: registerViewModel) {
        checkFBLogin()
    }
    
    func checkFBLogin(){
        if let token = AccessToken.current,
           !token.isExpired {
            loginMangerOfFaceBook.logOut()
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email , name"], tokenString: token.tokenString, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
                print(result.debugDescription)
            }
        }else{
            
        }
    }
    
    
    func setupAppleSignIn(){
        if #available(iOS 13.0, *) {
            let signInBtn = ASAuthorizationAppleIDButton()
            signInBtn.addTarget(self, action: #selector(signInWithapple), for: .touchUpInside)
            self.containerStackView.addArrangedSubview(signInBtn)
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func signInWithapple(){
        if #available(iOS 13.0, *) {
            let appleProvider = ASAuthorizationAppleIDProvider()
            let request = appleProvider.createRequest()
            request.requestedScopes = [.email , .fullName ]
            let authenticationController = ASAuthorizationController(authorizationRequests: [request])
            authenticationController.delegate = self
            authenticationController.presentationContextProvider = self
            authenticationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
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
    
    
    @IBAction func dismissbtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func man(_ sender: UIButton) {
        gender = "male"
        print(gender)
        famalbtn.backgroundColor = .white
        man.borderColor = #colorLiteral(red: 0.003181875916, green: 0.6280581355, blue: 1, alpha: 1)
        man.backgroundColor = #colorLiteral(red: 0.003181875916, green: 0.6280581355, blue: 1, alpha: 1)
        famalbtn.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        famaleView.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        manView.borderColor = #colorLiteral(red: 0.003181875916, green: 0.6280581355, blue: 1, alpha: 1)
        
    }
    
    @IBAction func famelbtn(_ sender: UIButton) {
        gender = "famale"
        famalbtn.borderColor = #colorLiteral(red: 0.003181875916, green: 0.6280581355, blue: 1, alpha: 1)
        famalbtn.backgroundColor = #colorLiteral(red: 0.003181875916, green: 0.6280581355, blue: 1, alpha: 1)
        man.backgroundColor = .white
        man.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        famaleView.borderColor = #colorLiteral(red: 0.003181875916, green: 0.6280581355, blue: 1, alpha: 1)
        manView.borderColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
    }
    @IBAction func register(_ sender: Any) {
        guard let email = emailtf.text, !email.isEmpty, let password = bassword.text, !password.isEmpty, let phone = phoneTf.text, !phone.isEmpty,let name = username.text , !name.isEmpty  else{return}
        if phone.first != "0" || phone.count < 11{
            self.showMassage(massage: " من فاضلك ادخل رقم هاتف صحيج", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        regisretBtn.isHidden = true
        loadingRegister.isHidden = false
        loadingRegister.startAnimating()
        
        let paramerters : [String : String] = [
            "usertype" : "0",
            "fullname" : name,
            "description": "",
            "email": email,
            "phone":phone,
            "password": password,
            "gender": gender,
            "address": addresstf.text ?? "",
            "longitude": "",
            "latitude": "",
            "worktime": "",
            "categoryid": "",
            "categoryname" : "",
            "brandlogo" : "",
            "pics" : "",
            "device_type" : "ios"
        ]
        vieeModel.register(postData: paramerters).subscribe(onNext: {[weak self] (registerDataResulte) in
            guard let self = self else {return}
            let data =  registerDataResulte.info[0]
            if data.status{
                DispatchQueue.main.async {
                    guard let Id = data.id , let userType = data.usertype , let userPhone = data.phone  else {return}
                    if let name = data.fullname  {
                        UserDefaults.standard.set(name, forKey: NetworkConstants.brandname)
                    }
                    self.regisretBtn.isHidden = false
                    self.loadingRegister.isHidden = true
                    self.loadingRegister.startAnimating()
                    UserDefaults.standard.set(userType, forKey: NetworkConstants.userType)
                    UserDefaults.standard.set(userPhone, forKey: NetworkConstants.userPhone)
                    UserDefaults.standard.set(userType, forKey: NetworkConstants.userType)
                    UserDefaults.standard.set(Id, forKey: NetworkConstants.userIdKey)
                    
                    let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
                    self.navigationController?.pushViewController(HomeView, animated: true)
                }
            }else{
                guard let msg = data.message else {return}
                
                var style = ToastStyle()
                style.messageColor = .white
                style.backgroundColor = .red
                DispatchQueue.main.async {
                    self.view.makeToast(msg, duration: 3.0, position: .bottom, style: style)
                    self.regisretBtn.isHidden = false
                    self.loadingRegister.isHidden = true
                    self.loadingRegister.startAnimating()
                }
                
            }
        }, onError: { [weak self] (error) in
            guard let self = self else {return}
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = .red
            DispatchQueue.main.async {
                let error = error as NSError
                if error.code == 13 {
                    self.view.makeToast("لا يوجد اتصال بالانتزنت", duration: 3.0, position: .bottom, style: style)
                }else{
                    self.view.makeToast(error.localizedDescription, duration: 3.0, position: .bottom, style: style)
                    self.regisretBtn.isHidden = false
                    self.loadingRegister.isHidden = true
                    self.loadingRegister.startAnimating()
                }
                
            }
            
        }).disposed(by: disposePag)
        
        
    }
    
    @IBAction func faceBookLogin(_ sender: Any) {
        
        loginMangerOfFaceBook.logIn(permissions: ["name"], from: self) { (resulte, error) in
            //           [weak self] guard let self = self else {return}
            if error != nil{
                print(error)
            }else{
                if resulte!.isCancelled {
                    
                }else{
                    guard  let acccestokenString = AccessToken.current?.tokenString else {return}
                    let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email , name"], tokenString: acccestokenString, version: nil, httpMethod: .get)
                    request.start { (connection, result, error) in
                        if error != nil{
                            print(error.debugDescription)
                        }else{
                            
                            var genderData = "0"
                            var Locationdata = "0"
                            guard let userData = result as? [String : Any] else{return}
                            
                            print(userData)
                            guard let name = userData["name"]  as? String else {return}
                            guard let userId = userData["id"] as? String else {return}
                            
                            if let Location = userData["location"]  as? [String : Any] {
                                if let nameOfLocation = Location["name"] as? String {
                                    Locationdata = nameOfLocation
                                }
                            }
                            
                            if let gender = userData["gender"]  as? String {
                                genderData = gender
                            }
                            
                            
                            let paramerters : [String : String] = [
                                "usertype" : "0",
                                "fullname" : name,
                                "description": "social",
                                "email": userId,
                                "phone": userId,
                                "password": userId,
                                "gender": genderData,
                                "address": Locationdata,
                                "longitude": "0",
                                "latitude": "0",
                                "worktime": "0",
                                "categoryid": "0",
                                "categoryname" : "0",
                                "brandlogo" : "0",
                                "pics" : "0",
                                "device_type" : "ios"
                            ]
                            self.regisretBtn.isHidden = true
                            self.loadingRegister.isHidden = false
                            self.loadingRegister.startAnimating()
                            self.vieeModel.loginUsigFaceBooke(postData: paramerters).subscribe(onNext: { [weak self] (resulte) in
                                guard let self = self else {return}
                                if resulte.info[0].status {
                                    let data = resulte.info[0]
                                    if resulte.info[0].usertype == "1"{
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
                                        guard  let userType = data.usertype else {return}
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
                                let error = error as NSError
                                if error.code == 13 {
                                    self.showMassageError(massage: "لا يوجد اتصال بالانتزنت")
                                }else{
                                    self.showMassageError(massage: error.localizedDescription)
                                }
                                
                                
                            }).disposed(by: self.disposePag)
                            
                        }
                        
                    }
                }
                
                
            }
            
        }
    }
    
    
}
extension RegisterViewController : LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email , name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            print(result.debugDescription)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}

extension RegisterViewController : ASAuthorizationControllerPresentationContextProviding , ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        showMassageError(massage: "من فضلك تاكد من وجود حساب ")
    }
    
    @available(iOS 13.0, *) // sign in with apple is not available below iOS13
    private func getCredentialState(fullname: String, email: String, userID: String ) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { [weak self] credentialState, _ in
            guard let self = self else { return }
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                self.LogInWithAppleOrFaceBook(fullname: fullname, email: email, userID: userID)
                break
            case .revoked:
                self.showMassageError(massage:"The Apple ID credential is revoked")
                break
            case .notFound:
                self.showMassageError(massage: "No Account Found")
                break
                
            default:
                self.showMassageError(massage: "samething went wrong with apple sign in")
            }
            
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credential as ASPasswordCredential :
            let password = credential.password
            print(password)
        case let credential as ASAuthorizationAppleIDCredential:
            let userIdentifier = credential.user
            let fullName = "\(credential.fullName?.givenName ?? "")\(credential.fullName?.familyName ?? "")"
            let email = credential.email
            getCredentialState(fullname: fullName, email: email ?? "", userID: userIdentifier)
        default:
            break
        }
        
    }
    
    func LogInWithAppleOrFaceBook(fullname: String, email: String, userID: String ){
        
        let paramerters : [String : String] = [
            "usertype" : "0",
            "fullname" : fullname,
            "description": "social",
            "email": email,
            "phone": userID,
            "password": userID,
            "gender": "0",
            "address": "0",
            "longitude": "0",
            "latitude": "0",
            "worktime": "0",
            "categoryid": "0",
            "categoryname" : "0",
            "brandlogo" : "0",
            "pics" : "0",
            "device_type" : "ios"
        ]
        
        self.vieeModel.loginUsigFaceBooke(postData: paramerters).subscribe(onNext: { [weak self] (resulte) in
            guard let self = self else {return}
            if resulte.info[0].status {
                let data = resulte.info[0]
                print(resulte.info[0].usertype)
                if resulte.info[0].usertype == "1" {
                    if let id = data.id, let userType = data.usertype, let Cataid = data.categoryid, let CatName = data.categoryname,  let brandlog = data.brandlogo , let brandname = data.fullname , let userPhone = data.phone{
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
                        UserDefaults.standard.set(userPhone, forKey: NetworkConstants.userPhone)
                        UserDefaults.standard.set(userType, forKey: NetworkConstants.userType)
                        UserDefaults.standard.set(id, forKey: NetworkConstants.userIdKey)
                        UserDefaults.standard.set(Cataid, forKey: NetworkConstants.catid)
                        UserDefaults.standard.set(CatName, forKey: NetworkConstants.catname)
                        UserDefaults.standard.set(brandname, forKey: NetworkConstants.brandname)
                        UserDefaults.standard.set(brandlog, forKey: NetworkConstants.brandlogo)
                        UserDefaults.standard.synchronize()
                        DispatchQueue.main.async {
                            let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
                            self.navigationController?.pushViewController(HomeView, animated: true)
                        }
                    }
                }else if resulte.info[0].usertype == "2"{
                    if let id = data.id, let userType = data.usertype, let deliveryname = data.fullname , let profileimage = data.profile_img{
                        UserDefaults.standard.set(deliveryname, forKey: NetworkConstants.brandname)
                        UserDefaults.standard.set(userType, forKey: NetworkConstants.userType)
                        UserDefaults.standard.set(id, forKey: NetworkConstants.userIdKey)
                        UserDefaults.standard.set(profileimage, forKey: NetworkConstants.deliveryImage)
                        UserDefaults.standard.synchronize()
                        do {
                            // Create JSON Encoder
                            let encoder = JSONEncoder()
                            // Encode Note
                            let data = try encoder.encode(data)
                            // Write/Set Data
                            UserDefaults.standard.set(data, forKey: NetworkConstants.deliveryDate)
                            UserDefaults.standard.synchronize()
                        } catch {
                            print("Unable to Encode Note (\(error))")
                        }
                        DispatchQueue.main.async {
                            let HomeView = self.coordinator.mainNavigator.viewController(for: .HomeView)
                            self.navigationController?.pushViewController(HomeView, animated: true)
                        }
                    }
                }else{
                    guard let id = data.id else {return}
                    guard  let userType = data.usertype else {return}
                    UserDefaults.standard.setValue(id, forKey: NetworkConstants.userIdKey)
                    UserDefaults.standard.setValue(userType, forKey: NetworkConstants.userType)
                    UserDefaults.standard.synchronize()
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
            let error = error as NSError
            if error.code == 13 {
                self.showMassageError(massage: "لا يوجد اتصال بالانتزنت")
            }else{
                self.showMassageError(massage: error.localizedDescription)
            }
            
            
        }).disposed(by: self.disposePag)
        
        
        
    }
    
}

