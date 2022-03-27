//
//  SearchDelivertyViewController.swift
//  Mahallawy
//
//  Created by jooo on 10/9/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class SearchDelivertyViewController: BaseWireFrame<SearchDelivertyViewModel> {
    @IBOutlet weak var nameOfDelivery: UILabel!
    
    @IBOutlet weak var lsearchImage: UIImageView!
    @IBOutlet weak var loadingActivityIndictore: UIActivityIndicatorView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var imageOfDelivery: UIImageView!
    @IBOutlet weak var statusOfOrderlbl: UILabel!
    @IBOutlet weak var phoneOfDelivery: UILabel!
    @IBOutlet weak var containerOfDeliveryDate: UIStackView!
    var time_request : Int = 0
    var timerDelivery : Timer?
    var showTimer : Timer?
    var orderId : String?
   var runCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        lsearchImage.loadGif(name: "delivery2-1")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTimer?.fire()
        requestDelivery()
    }
    
    override func bind(ViewModel: SearchDelivertyViewModel) {
        setupUi()
    }
    
    func setupUi(){
        
        timerDelivery = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(requestDelivery), userInfo: nil, repeats: true)
        showTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ShowTimerDate), userInfo: nil, repeats: true)
        
     
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func callBtn(_ sender: Any) {
        guard let phone = phoneOfDelivery.text , !phone.isEmpty else {return}
        if let url = URL(string:"tel://\(phone)"),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    @objc func ShowTimerDate() {
        runCount += 1
        let (h,m,s)  = secondsToHoursMinutesSeconds(seconds: runCount)
        timerLbl.text = "\(h):\(m):\(s)"
        print("\(h):\(m):\(s)")
        if runCount % 30 == 0 {
            print("check agin")
            checkStatusOfAcceptorNot()
        }
    }
    
    @objc func checkStatusOfAcceptorNot(){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String ,let orderId = vieeModel.orderId else  {return}
        let param : [String : String ] = [
            "user_id": userId,
            "order_id": orderId,
        ]
        vieeModel.checkDeliveryOrderStatus(parameters: param).subscribe(onNext: { [weak self] (checkresulte) in
            guard let self = self else {return}
            guard let inf = checkresulte.info?.first else {return}
            
            if inf.status {
                self.showTimer?.invalidate()
                self.timerDelivery?.invalidate()
                self.statusOfOrderlbl.text = inf.message
            }else{
                self.statusOfOrderlbl.text = inf.message
            }
        }, onError: { [weak self] (error) in
            guard let self = self else {return}
            print(error)
           
        }).disposed(by: disposePag)
    }
    
    @objc func requestDelivery(){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else  {return}
        print(userId)
        if let orderId = vieeModel.orderId {

            loadingActivityIndictore.startAnimating()
            let param : [String : String ] = [
                "caller_id": userId,
                "order_id":orderId,
                "time_request": "\(time_request)"
            ]
            vieeModel.SerachDelivery(parameters: param).subscribe(onNext: { [weak self] (DeliveryRedurn) in
                guard let self = self else {return}
               
                guard let delivery =  DeliveryRedurn.response?.first else {return}
                self.loadingActivityIndictore.stopAnimating()
                if delivery.status ?? false {
                    self.showMassage(massage: delivery.message ?? "", colorStyle: #colorLiteral(red: 0, green: 0.5, blue: 0.2007743038, alpha: 1))
                    self.containerOfDeliveryDate.isHidden = false
                    self.imageOfDelivery.isHidden = false
                    self.nameOfDelivery.text = delivery.delivery_name
                    self.phoneOfDelivery.text = delivery.deliveryphone
                    if let imageOfDelivery = delivery.delivery_img {
                        self.imageOfDelivery.getImage(imageUrl: imageOfDelivery)
                    }
                }else{
                    self.containerOfDeliveryDate.isHidden = true
                    self.imageOfDelivery.isHidden = true
                    self.statusOfOrderlbl.text = delivery.message
                    self.showTimer?.invalidate()
                    self.showMassage(massage: delivery.message ?? "", colorStyle: DesignSystem.Colors.MainColor.color)
                }
            }, onError: { [weak self] (error) in
                guard let self = self else {return}
                self.requestDelivery()
                print(error)
                self.loadingActivityIndictore.stopAnimating()
            }).disposed(by: disposePag)
            time_request += 1
        }else if var param = vieeModel.OrderTaiarDate{
            
            loadingActivityIndictore.startAnimating()
           param["time_request"] = "\(time_request)"
            vieeModel.searchOfDeliveryWithoutOrder(parameters: param).subscribe(onNext: { [weak self] (DeliveryRedurn) in
                guard let self = self else {return}
                guard let delivery =  DeliveryRedurn.response?.first else {return}
                self.loadingActivityIndictore.stopAnimating()
                if delivery.status ?? false {
                    self.showMassage(massage: delivery.message ?? "", colorStyle: #colorLiteral(red: 0, green: 0.5, blue: 0.2007743038, alpha: 1))
                    self.containerOfDeliveryDate.isHidden = false
                    self.imageOfDelivery.isHidden = false
                    self.nameOfDelivery.text = delivery.delivery_name
                    self.phoneOfDelivery.text = delivery.deliveryphone
                    if let imageOfDelivery = delivery.delivery_img {
                        self.imageOfDelivery.getImage(imageUrl: imageOfDelivery)
                    }
                   
                }else{
                    self.containerOfDeliveryDate.isHidden = true
                    self.imageOfDelivery.isHidden = true
                    self.statusOfOrderlbl.text = delivery.message
                    self.showTimer?.invalidate()
                    self.showMassage(massage: delivery.message ?? "", colorStyle: DesignSystem.Colors.MainColor.color)
                }
            }, onError: { [weak self] (error) in
                guard let self = self else {return}
                print(error)
                self.requestDelivery()
                self.loadingActivityIndictore.stopAnimating()
            }).disposed(by: disposePag)
            time_request += 1
        }
       
       
    }

}
