//
//  BaseWireFrame.swift
//  Opportunities
//
//  Created by youssef on 12/14/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Kingfisher
import Toast_Swift
import MOLH
//import NVActivityIndicatorView

class BaseWireFrame <T>: UIViewController {
    var vieeModel : T!
    var coordinator : Coordinator!
  lazy var disposePag : DisposeBag = {
        return DisposeBag()
    }()
    init(ViewModel : T, coordinator : Coordinator) {
        self.vieeModel = ViewModel
        self.coordinator = coordinator
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        bind(ViewModel: vieeModel)
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(ViewModel : T) {
        fatalError("please Override the bind Function")
        
    }

    func showAlertTologein(massage : String){
        let alert = UIAlertController(title: "خطا", message: massage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "تم", style: UIAlertAction.Style.cancel) { [weak self] UIAlertAction in
            guard let self = self else {return}
            let sign = self.coordinator.mainNavigator.viewController(for: .login)
            let navi = UINavigationController(rootViewController: sign)
            navi.modalPresentationStyle = .overFullScreen
            self.present(navi, animated: true, completion: nil)
            }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showMassage(massage : String, colorStyle : UIColor){
        var style = ToastStyle()
        style.messageColor = .white
        
        style.backgroundColor = colorStyle
        DispatchQueue.main.async {
            self.view.makeToast(massage, duration: 5.0, position: .top, style: style)
        }
    }
    
}
