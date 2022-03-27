//
//  forgetPassViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class forgetPassViewController: BaseWireFrame<forgetPassViewModel> {
    @IBOutlet weak var sendPassword: UIButton!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var emailOrPjone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        // Do any additional setup after loading the view.
    }
    
    func setupUi(){
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font : UIFont(name: Font.Regular.name, size: 15)! // Note the !
            ] as [NSAttributedString.Key : Any]
        emailOrPjone.attributedPlaceholder = NSAttributedString(string: "رقم الهاتف او البريد الالكتروني", attributes: attributes)
    }
    
    override func bind(ViewModel: forgetPassViewModel) {
        
    }
    
    
    @IBAction func sendPasswordbtn(_ sender: Any) {
        guard let email = emailOrPjone.text, !email.isEmpty else{return}
        sendPassword.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        let paramerter : [String : String] = [
            "email"  : email,
        ]
        
        vieeModel.forgetPassword(parameters: paramerter).subscribe(onNext: { [weak self](resulte) in
            guard let self = self else {return}
            if resulte.Response[0].statues {
                self.sendPassword.isHidden = false
                self.loadingView.isHidden = true
                self.loadingView.stopAnimating()
                self.emailOrPjone.text = ""
                self.showMassage(massage: resulte.Response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
            }else{
                self.sendPassword.isHidden = false
                self.loadingView.isHidden = true
                self.loadingView.stopAnimating()
                self.showMassage(massage: resulte.Response[0].message, colorStyle: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
            }
        }).disposed(by: disposePag)
    }
    
}
