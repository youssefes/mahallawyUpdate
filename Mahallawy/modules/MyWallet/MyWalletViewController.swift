//
//  MyWalletViewController.swift
//  Mahallawy
//
//  Created by jooo on 11/1/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit

class MyWalletViewController: BaseWireFrame<HomeViewModel> {
    @IBOutlet weak var totalSalaries: UILabel!
    
    @IBOutlet weak var ordersCount: UILabel!
    @IBOutlet weak var orders_count_today: UILabel!
    @IBOutlet weak var totalOrders: UILabel!
    @IBOutlet weak var mahallwyPresent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func bind(ViewModel: HomeViewModel) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAcceptedOrNot()
    }
    
    func checkAcceptedOrNot(){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
    
        let param : [String : String] = [
            "user_id" : userId
        ]
        vieeModel.CheckDeliveryStausAcceptOrNot(parameters: param).subscribe(onNext: { [weak self] (checkreulte) in
            guard let self = self else {return}
            guard let deliveryDate = checkreulte.salaries?.first else {return}
            if deliveryDate.status == true{
                self.mahallwyPresent.text = "يتم خصم نسبة محلاوي للتوصيل وهي \(deliveryDate.mahallawy_ratio ?? "0") اثناء عملية التوريد"
                self.totalOrders.text = "\(deliveryDate.orders_count_today ?? "0") طلب"
                self.totalSalaries.text = "\(deliveryDate.wallet ??  "0") جنية"
                self.ordersCount.text = "\(deliveryDate.total_salaries ?? "0") جنية"
                self.orders_count_today.text = "\(deliveryDate.total_orders ?? "") طلب"
            }else{
               
            }
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposePag)
    }


}
