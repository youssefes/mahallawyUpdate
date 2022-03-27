//
//  JobDetailesVc.swift
//  Mahallawy
//
//  Created by jooo on 3/25/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import UIKit
import GoogleMobileAds
import NVActivityIndicatorView
class JobDetailesVc: BaseWireFrame<JobDetailesViewModel> {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var titelOfJop: UILabel!
    @IBOutlet weak var address: TextField!
    @IBOutlet weak var price: TextField!
    @IBOutlet weak var phoneOfOwner: TextField!
    @IBOutlet weak var descriptionOfJop: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: JobDetailesViewModel) {
        
        bannerView.adUnitID = NetworkConstants.GoogelAdId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        if ViewModel.job != nil {
            title = "تفاصيل الوظيفة"
            publishBtn.isHidden = true
            reportBtn.isHidden = false
            titelOfJop.text = "تم النشر بواسطة \(ViewModel.job?.username ?? "")"
            price.text = ViewModel.job?.sallary
            phoneOfOwner.text = ViewModel.job?.phone
            descriptionOfJop.text = ViewModel.job?.jobDescription
            address.text  = ViewModel.job?.title
            
            price.isEnabled = false
            phoneOfOwner.isEnabled = false
            descriptionOfJop.isEditable = false
            address.isEnabled = false
        }else{
            title = "نشر الوظيفة"
            publishBtn.isHidden = false
            reportBtn.isHidden = true
        }
        ViewModel.addView()
    }
    @IBAction func reportBtn(_ sender: Any) {
        guard let url = URL(string: "https://mahallawy.net/mahallawy/website/Contact.aspx")  else {return}
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func publishBtn(_ sender: Any) {
        addJop()
    }
    
    func addJop(){
        guard let titelOfJob = address.text  , !titelOfJob.isEmpty , let descriptionOfJop = descriptionOfJop.text , !descriptionOfJop.isEmpty , let price = price.text , !price.isEmpty, let userid = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String , let brandname = UserDefaults.standard.value(forKey: NetworkConstants.brandname) as? String , let phone =  phoneOfOwner.text, !phone.isEmpty else {
            self.showMassage(massage: "من فضلك ادخل كل البيانات المطلوية", colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            return
        }
        publishBtn.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        let param : [String : String] = [
            "title": titelOfJob,
            "description": descriptionOfJop,
            "phone": phone,
            "sallary": price,
            "userid": userid,
            "username": brandname,
        ]
        vieeModel.addJops(Paras: param) { [weak self ] (resulte) in
            guard let self = self else {return}
            switch resulte {
            case .success(let rersulte):
                print(rersulte)
                self.publishBtn.isHidden = false
                self.loadingView.isHidden = true
                self.showMassage(massage: rersulte.response.first?.message ?? "", colorStyle: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))
                self.price.text = ""
                self.phoneOfOwner.text = ""
                self.descriptionOfJop.text = ""
                self.address.text  = ""
            case .failure(let error):
                self.publishBtn.isHidden = false
                self.loadingView.isHidden = true
                
                self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
                print(error)
            }
            
        }
    }

}


extension JobDetailesVc: GADBannerViewDelegate{
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
 
    
}
