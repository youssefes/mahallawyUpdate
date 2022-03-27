//
//  ContectUsViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import SideMenu
import NVActivityIndicatorView
class ContectUsViewController: BaseWireFrame<ContectUsViewModel> {

    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var massageTV: UITextView!
    @IBOutlet weak var whatsAppBtn: UITextField!
    @IBOutlet weak var fullNameTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: ContectUsViewModel) {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Component 7 – 1"), style: .plain, target: self, action: #selector(menuBtn))
        title = "تواصل معنا"
        
        ViewModel.SeccessgetContectObservable.subscribe(onNext: { (respondData) in
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            self.fullNameTf.text = ""
            self.whatsAppBtn.text = ""
            self.massageTV.text = ""
             self.showMassage(massage: respondData.Response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
        }, onError: { (error) in
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            print(error)
            self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
        }).disposed(by: disposePag)
    }
    @IBAction func sendBtn(_ sender: Any) {
        guard let massage = massageTV.text, !massage.isEmpty,let fullName = fullNameTf.text, !massage.isEmpty, let whatsAppNumber = whatsAppBtn.text, !whatsAppNumber.isEmpty, let userid = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else{
            self.showMassage(massage: "من فضلك ادخل كل البيانات المطلوبه", colorStyle: UIColor.red)
            return
            
        }
        
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        let parameters : [String : String] = [
            "user_id" : userid,
            "name" : fullName,
            "whatsapp" : whatsAppNumber,
            "content" : massage
            
        ]
        vieeModel.ContectUS(Paras: parameters)
        
    }
    @IBAction func SendTowhatsAppBtn(_ sender: Any) {
        
        guard let massage = massageTV.text, !massage.isEmpty,let fullName = fullNameTf.text, !massage.isEmpty, let whatsAppNumber = whatsAppBtn.text, !whatsAppNumber.isEmpty else{
            self.showMassage(massage: "من فضلك ادخل كل البيانات المطلوبه", colorStyle: UIColor.red)
            return
        }
        print(fullName)
        let originalString = massage
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let phone = "+2001064290486"
        if let whatsAppURL = URL(string: "https://wa.me/\(phone)?text=\(escapedString ?? "")"){
            if UIApplication.shared.canOpenURL(whatsAppURL)
            {
                UIApplication.shared.open(whatsAppURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func menuBtn(_ sender: Any) {
        let menu = SideMenuNavigationController(rootViewController: coordinator.mainNavigator.viewController(for: .menueView))
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = view.frame.width - 60
        menu.blurEffectStyle = .extraLight
        present(menu, animated: true, completion: nil)
    }
    
}
