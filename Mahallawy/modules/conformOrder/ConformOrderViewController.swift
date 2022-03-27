//
//  ConformOrderViewController.swift
//  Elsade
//
//  Created by jooo on 5/12/21.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Toast_Swift
import CoreLocation
class ConformOrderViewController: BaseWireFrame<ConformOrderViewModel>{

    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    var userAdddressName  : String?
    var userLocation : CLLocationCoordinate2D?
    var ArrayOfCartData = [Cart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.stopAnimating()
        title = "تاكيد الطالب"
        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: ConformOrderViewModel) {
        addressTf.text = vieeModel.nameOfAddress
        ArrayOfCartData = ViewModel.CartData
    }
    
    @IBAction func editLocation(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func conformOrder(_ sender: Any) {
        guard let address = addressTf.text ,!address.isEmpty else {
            self.showMassage(massage: "من فاضلك ادخل عنوانك", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        
        guard   let userName = nameTf.text , !userName.isEmpty else {
            self.showMassage(massage: "من فاضلك ادخل اسمك بالكامل", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        guard let userphone = phoneTf.text , !userphone.isEmpty else {
            self.showMassage(massage: "من فاضلك ادخل رقم الهاتف", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        
        if userphone.first != "0" || userphone.count < 11{
            self.showMassage(massage: " من فاضلك ادخل رقم هاتف صحيج", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        var shopsId = [String]()
        var counts = [String]()
        var ProdectsId = [String]()
        var ProdectsImage = [String]()
        var ProdectsName = [String]()
        var shopsName = [String]()
        var Descraption = [String]()
        var Costs = [String]()
        ArrayOfCartData.forEach { (Cartitem) in
            shopsId.append(Cartitem.shop_id ?? "")
            counts.append(Cartitem.count ?? "")
            ProdectsId.append(Cartitem.advertiseID ?? "")
            ProdectsImage.append(Cartitem.orderImg ?? "")
            ProdectsName.append(Cartitem.orderName ?? "")
            shopsName.append(Cartitem.shop_name ?? "")
            Descraption.append(Cartitem.userDescription ?? "")
            Costs.append(Cartitem.orderPrice ?? "")
        }
       
        let ShopIds = shopsId.joined(separator: "-")
        let ProdectIds = ProdectsId.joined(separator: "-")
        let ImagesOfProdect = ProdectsImage.joined(separator: "-")
        let count = counts.joined(separator: "-")
        let shopNames = shopsName.joined(separator: "-")
        let Descraptions = Descraption.joined(separator: "-")
        let ProdectNames = ProdectsName.joined(separator: "-")
        let Prices = Costs.joined(separator: "-")
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
      
        
        self.loadingView.startAnimating()
        let params : [String : String] = [
            "customer_id" : userId,
            "customer_name" : userName ,
            "customer_phone" : userphone ,
            "shop_id" : ShopIds,
            "product_id" : ProdectIds,
            "product_name" : ProdectNames,
            "order_description" : Descraptions,
            "product_img" : ImagesOfProdect,
            "shop_name" : shopNames,
            "count" : count,
            "location" : address ,
            "longitude" : "\(vieeModel.AddressLocation.longitude)",
            "latitude" : "\(vieeModel.AddressLocation.latitude)",
            "cost" : Prices,
        ]
        vieeModel.MakeOrder(parameters: params).subscribe(onNext: { [weak self ] (resultData) in
            guard let self = self else {return}
           self.loadingView.isHidden = true
            let message = resultData.response.first?.message
            UserDefaults.standard.removeObject(forKey: NetworkConstants.CounterInCart)
            UserDefaults.standard.synchronize()
           var style = ToastStyle()
           style.messageColor = .white
           style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
           DispatchQueue.main.async { [weak self ] in
                guard let self = self else {return}
               self.view.makeToast(message, duration: 3.0, position: .top, style: style)
           }
            let Home = self.coordinator.mainNavigator.viewController(for: .HomeView)
            self.navigationController?.pushViewController(Home, animated: true)
       },onError: { [weak self ] (error) in
           guard let self = self else {return}
           self.loadingView.isHidden = true
           self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
       }).disposed(by: disposePag)
    }
}
