//
//  TaierOrdersViewController.swift
//  Mahallawy
//
//  Created by jooo on 10/21/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import MOLH
import Toast_Swift
import iOSDropDown
import CoreLocation
class TaierOrdersViewController: BaseWireFrame<TaierOrdersViewModel> {

 
    @IBOutlet weak var countainerOfAcceptOrder: UIView!
    @IBOutlet weak var noOrderView: UIView!
    @IBOutlet weak var Myordertableview: UITableView!
    @IBOutlet weak var Actinityloading: UIActivityIndicatorView!
  
    var arrayOfselectedpresentedString = ["5","10","15","20","25","30","35","40","45","50"]
    @IBOutlet weak var presentOfDelivertTf: DropDown!
    var orderId : String?
    var CallerId : String?
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var phoneNumber: UITextField!
    var cellIdentifier = "MyOrderTableViewCell"
    var arrayOfDeliveryOredrs = [Orders](){
        didSet{
            Myordertableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func bind(ViewModel: TaierOrdersViewModel) {
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrderOfTaier()
    }
    func setupUi(){
        let deliveryPhone = UserDefaults.standard.value(forKey: NetworkConstants.userPhone) as? String
        print(deliveryPhone)
        phoneNumber.text = deliveryPhone
        self.title = "طلبات التوصيل"
        Myordertableview.delegate = self
        Myordertableview.dataSource = self
        Myordertableview.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.self)
        
        Myordertableview.estimatedRowHeight = 1000
        Myordertableview.rowHeight = UITableView.automaticDimension
        Myordertableview.tableFooterView = .none
        
        //        refreshControl.attributedTitle = NSAttributedString(string: "loading...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        Myordertableview.addSubview(refreshControl)
        self.presentOfDelivertTf.optionArray = arrayOfselectedpresentedString.map({$0})
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        presentOfDelivertTf.didSelect{ [weak self](selectedText , index ,id) in
            guard let self = self else {return}
            self.presentOfDelivertTf.text = selectedText
        }
    }
    
    @objc func refresh(){
        Actinityloading.isHidden = true
        getOrderOfTaier()
    }
    @IBAction func hiddenAccept(_ sender: Any) {
        countainerOfAcceptOrder.isHidden  = true
    }
    
    @IBAction func acceptOrderDelivery(_ sender: Any) {
        changeStatus(statues: Orderstatus.active.rawValue)
    }
    
    func changeStatus(statues : String){
    
        
        guard let orderId = orderId , let selery = presentOfDelivertTf.text , !selery.isEmpty , let callerId = CallerId else{return}
        
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String  , let deliveryPhone =  phoneNumber.text , !deliveryPhone.isEmpty ,let  username  = UserDefaults.standard.value(forKey: NetworkConstants.brandname) as? String else {return}
        
        
        Actinityloading.startAnimating()
        let param : [String : String] = [
            "caller_id": callerId,
            "user_id": userId,
            "statues": statues,
            "order_id": orderId,
            "delivery_name": username ,
            "delivery_phone": deliveryPhone,
            "delivery_salary": selery,
        ]
        vieeModel.AcceptOrderByDelivery(parameters: param).subscribe(onNext: { [weak self ] (resultData) in
            guard let self = self else {return}
           self.Actinityloading.isHidden = true
            self.countainerOfAcceptOrder.isHidden = true
            let message = resultData.response[0].message
           var style = ToastStyle()
           style.messageColor = .white
           style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            self.getOrderOfTaier()
           DispatchQueue.main.async { [weak self ] in
                guard let self = self else {return}
               self.view.makeToast(message, duration: 3.0, position: .top, style: style)
           }
       },onError: { [weak self ] (error) in
           guard let self = self else {return}
           self.Actinityloading.isHidden = true
        print(error)
           self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
       }).disposed(by: disposePag)
    }
    
    func getOrderOfTaier(){
  
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String  else {return}
        print(userId)
        let params : [String : String] = [
            "user_id" : userId
        ]
        
        if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "2"{
                vieeModel.TaiarOrders(parameters: params).subscribe(onNext: { [weak self] (myoredr) in
                    guard let self = self else {return}
                    guard let data = myoredr.orders else {return}
                    print(data)
                    self.Actinityloading.stopAnimating()
                    self.refreshControl.endRefreshing()
                    if data.isEmpty{
                        self.noOrderView.isHidden = false
                    }else{
                        self.noOrderView.isHidden = true

                    }
                    self.arrayOfDeliveryOredrs = data
                }, onError: { [weak self] (error) in
                    guard let self = self else {return}
                    self.Actinityloading.stopAnimating()
                    print(error)
                }).disposed(by: disposePag)
            }else{
                vieeModel.UserOrOwnerDeliveryOrders(parameters: params).subscribe(onNext: { [weak self] (myoredr) in
                    guard let self = self else {return}
                    guard let data = myoredr.orders else {return}
                    print(data)
                    self.Actinityloading.stopAnimating()
                    self.refreshControl.endRefreshing()
                    if data.isEmpty{
                        self.noOrderView.isHidden = false
                    }else{
                        self.noOrderView.isHidden = true

                    }
                    self.arrayOfDeliveryOredrs = data
                }, onError: { [weak self] (error) in
                    guard let self = self else {return}
                    self.Actinityloading.stopAnimating()
                    print(error)
                }).disposed(by: disposePag)
            }
        }
       
    }
    func CancelStatusOfOrder(orderId: String, callerId: String?, deliver_statues: String?, nesbet_tawsel: String?, delivery_id: String?) {
        Actinityloading.startAnimating()
        vieeModel.ChangeStatusOforder(order_id : orderId, user_id : callerId ?? "" , statues : deliver_statues ?? "" ,nesbet_tawsel : nesbet_tawsel, delivery_id : delivery_id).subscribe(onNext: { [weak self ] (resultData) in
            guard let self = self else {return}
           self.Actinityloading.isHidden = true
            let message = resultData.response[0].message
           var style = ToastStyle()
           style.messageColor = .white
           style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            self.getOrderOfTaier()
           DispatchQueue.main.async { [weak self ] in
                guard let self = self else {return}
               self.view.makeToast(message, duration: 3.0, position: .top, style: style)
           }
       },onError: { [weak self ] (error) in
           guard let self = self else {return}
        print(error)
           self.Actinityloading.isHidden = true
           self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
       }).disposed(by: disposePag)
    }
    
}
extension TaierOrdersViewController : UITableViewDelegate , UITableViewDataSource , MyOrderCellprotocol{
  
    
    func CancelStatus(orderId: String, callerId: String?, Status: String?, nesbet_tawsel: String?, delivery_id: String?) {
        self.orderId = orderId
        self.CallerId = callerId
        self.orderId = orderId
        self.CallerId = callerId
        CancelStatusOfOrder(orderId: orderId, callerId: callerId, deliver_statues: Status, nesbet_tawsel: nil, delivery_id: nil)
       
    }
    
    func callUser(phone: String) {
        if let url = URL(string:"tel://\(phone)"),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    func callShop(phone: String) {
        if let url = URL(string:"tel://\(phone)"),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    func MpaUser(location: CLLocationCoordinate2D) {
        openGoogleMap(lang: location.longitude, lat: location.latitude)
    }
    
    func MapShop(location: CLLocationCoordinate2D) {
        openGoogleMap(lang: location.longitude, lat: location.latitude)
    }
    func openGoogleMap(lang : Double, lat: Double) {
       
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(String(lat)),\(String(lang))&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(lang)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }

    }
    
    
    func changeStatus(orderId: String, callerId: String?, deliver_statues: String?, nesbet_tawsel: String?, delivery_id: String?, deliveryPhone: String?, delivername: String?) {
        self.orderId = orderId
        self.CallerId = callerId
        if deliver_statues ==  Orderstatus.new.rawValue {
            countainerOfAcceptOrder.isHidden = false
        }else if deliver_statues ==  Orderstatus.active.rawValue{
            Actinityloading.startAnimating()
            vieeModel.ChangeStatusOforder(order_id : orderId, user_id : callerId ?? "" , statues :  Orderstatus.finished.rawValue ,nesbet_tawsel : nesbet_tawsel, delivery_id : delivery_id).subscribe(onNext: { [weak self ] (resultData) in
                guard let self = self else {return}
               self.Actinityloading.isHidden = true
                let message = resultData.response[0].message
               var style = ToastStyle()
               style.messageColor = .white
               style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
                self.getOrderOfTaier()
               DispatchQueue.main.async { [weak self ] in
                    guard let self = self else {return}
                   self.view.makeToast(message, duration: 3.0, position: .top, style: style)
               }
           },onError: { [weak self ] (error) in
               guard let self = self else {return}
            print(error)
               self.Actinityloading.isHidden = true
               self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
           }).disposed(by: disposePag)
        }
    }
    
    func openDetailes(prodects: [Product]) {
        let DetailesVc = coordinator.mainNavigator.viewController(for: .CartViewController(arrayOfProdect: prodects))
        navigationController?.pushViewController(DetailesVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayOfDeliveryOredrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyOrderTableViewCell
        cell.selectionStyle = .none
        
        let activeArray = arrayOfDeliveryOredrs
        cell.TaiarOrders = true
        cell.orderDate = activeArray[indexPath.row]
        cell.prodects = activeArray[indexPath.row].products
        cell.Deleget = self
        cell.orderId = activeArray[indexPath.row].orderid
        cell.deliverySellery = activeArray[indexPath.row].delevery_sallary
        cell.callerId = activeArray[indexPath.row].user_id
        cell.deliver_statues = activeArray[indexPath.row].deliver_statues
        cell.deliveryPhone = activeArray[indexPath.row].deleviry_phone
        cell.delivername = activeArray[indexPath.row].delivery_name
        let prodectNames = activeArray[indexPath.row].products?.map({$0.productName ?? ""})
        cell.prodectLbl.text = prodectNames?.joined(separator:"-")
        cell.prodects = activeArray[indexPath.row].products
        var quantity = 0
        activeArray[indexPath.row].products?.forEach({ (Product) in
            quantity += Int(Product.count ?? "0") ?? 0
        })
        cell.nameOfProdectLbl.text = "\( activeArray[indexPath.row].products?.count ?? 0)"
        
        cell.qauntityInDeliveryLbl.text = "عنوان المستخدام"
        cell.orderNumberLbl.text =  activeArray[indexPath.row].orderid
        cell.orderTimeLbl.text = activeArray[indexPath.row].created_at
        cell.userPhone.isHidden = false
        cell.useraddress.isHidden = false
        cell.adderssShop.isHidden = false
        cell.adderssphone.isHidden = false
        cell.quantityLbl.textAlignment = .right
        cell.presentOfDelivered.text = activeArray[indexPath.row].delevery_sallary
        if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "2"{
                cell.phoneOfShopTopLab.text = activeArray[indexPath.row].shop_phone
                cell.nameOfShopTopLbl.text = activeArray[indexPath.row].shop_name
                cell.addressLbl.text = activeArray[indexPath.row].shop_location
                
                cell.nameOfBrand.text = activeArray[indexPath.row].customer_name
                cell.phoneLbl.text = activeArray[indexPath.row].customer_phone
                cell.quantityLbl.text = activeArray[indexPath.row].customer_location
            }else if userType == "1" {
                cell.phoneOfShopTopLab.text = activeArray[indexPath.row].deleviry_phone
                cell.deliveryNameSetLbl.text = "هاتف مندوب التوصيل"
                
                cell.nameOfShopTopLbl.text = activeArray[indexPath.row].delivery_name
                cell.deliveryNameLbl.text = "اسم مندوب التوصيل"
                cell.deliveryPhone = activeArray[indexPath.row].deleviry_phone
                cell.addressLbl.text = activeArray[indexPath.row].shop_location
                
                cell.nameOfBrand.text = activeArray[indexPath.row].customer_name
                cell.phoneLbl.text = activeArray[indexPath.row].customer_phone
                cell.quantityLbl.text = activeArray[indexPath.row].customer_location
            }else {
                
                cell.phoneOfShopTopLab.text = activeArray[indexPath.row].shop_phone
                cell.nameOfShopTopLbl.text = activeArray[indexPath.row].shop_name
                cell.addressLbl.text = activeArray[indexPath.row].shop_location
                cell.deliveryPhone =  activeArray[indexPath.row].deleviry_phone
                cell.nameOfBrand.text = activeArray[indexPath.row].delivery_name
                cell.naleOfbrandOrShopLbl.text = "اسم مندوب التوصيل"
                cell.phoneLbl.text = activeArray[indexPath.row].deleviry_phone
                cell.phoneCahngeUserOrShop.text = "هاتف مندوب التوصيل"
                cell.quantityLbl.text = activeArray[indexPath.row].customer_location
            }
        }
        if activeArray[indexPath.row].deliver_statues == Orderstatus.new.rawValue {
            cell.orderStatus.text = "انتظار قبول الطلب"
            cell.changeStatusOfOrderBtn.setTitle("قبول الطلب", for: .normal)
           
            if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
                if userType == "2"{
                    cell.changeStatusOfOrderBtn.isHidden = false
                    cell.cancelOrder.isHidden = true
                }else{
                    
                    cell.changeStatusOfOrderBtn.isHidden = true
                }
            }
            
        }else if  activeArray[indexPath.row].deliver_statues == Orderstatus.active.rawValue {
         
            if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
                if userType == "2"{
                    cell.phoneOfShopTopLab.text = activeArray[indexPath.row].shop_phone
                    cell.nameOfShopTopLbl.text = activeArray[indexPath.row].shop_name
                    cell.addressLbl.text = activeArray[indexPath.row].shop_location
                    cell.cancelOrder.isHidden = true
                    cell.nameOfBrand.text = activeArray[indexPath.row].customer_name
                    cell.phoneLbl.text = activeArray[indexPath.row].customer_phone
                    cell.quantityLbl.text = activeArray[indexPath.row].customer_location
                    cell.changeStatusOfOrderBtn.isHidden = true
                    if activeArray[indexPath.row].products?.first?.advID == "0"{
                        cell.orderStatus.text = "تم قبول طلب التوصيل ولم يتم التوصيل بعد"
                        cell.orderStatus.textColor = #colorLiteral(red: 1, green: 0.8943169713, blue: 0, alpha: 1)
                        cell.changeStatusOfOrderBtn.isHidden = false
                        cell.cancelOrder.isHidden = true
                        cell.changeStatusOfOrderBtn.setTitle("تم وصول الطلب", for: .normal)
                    }else{
                        cell.changeStatusOfOrderBtn.isHidden = true
                    }
                }else if userType == "1" {
                    cell.phoneOfShopTopLab.text = activeArray[indexPath.row].deleviry_phone
                    cell.deliveryNameSetLbl.text = "هاتف مندوب التوصيل"
                    
                    cell.nameOfShopTopLbl.text = activeArray[indexPath.row].delivery_name
                    cell.deliveryNameLbl.text = "اسم مندوب التوصيل"
                    
                    cell.addressLbl.text = activeArray[indexPath.row].shop_location
                    
                    cell.nameOfBrand.text = activeArray[indexPath.row].customer_name
                    cell.phoneLbl.text = activeArray[indexPath.row].customer_phone
                    cell.quantityLbl.text = activeArray[indexPath.row].customer_location
                    
                    cell.orderStatus.text = "تم قبول طلب التوصيل ولم يتم التوصيل بعد"
                    cell.orderStatus.textColor = #colorLiteral(red: 1, green: 0.8943169713, blue: 0, alpha: 1)
                    if activeArray[indexPath.row].products?.first?.advID == "0"{
                        cell.changeStatusOfOrderBtn.isHidden = false
                        cell.cancelOrder.isHidden = false
                        cell.changeStatusOfOrderBtn.setTitle("تم وصول الطلب", for: .normal)
                    }else{
                        cell.changeStatusOfOrderBtn.isHidden = true
                    }
                }else {
                    cell.phoneOfShopTopLab.text = activeArray[indexPath.row].shop_phone
                    cell.nameOfShopTopLbl.text = activeArray[indexPath.row].shop_name
                    cell.addressLbl.text = activeArray[indexPath.row].shop_location
                    
                    cell.nameOfBrand.text = activeArray[indexPath.row].delivery_name
                    cell.naleOfbrandOrShopLbl.text = "اسم مندوب التوصيل"
                    cell.phoneLbl.text = activeArray[indexPath.row].deleviry_phone
                    cell.phoneCahngeUserOrShop.text = "هاتف مندوب التوصيل"
                    
                    cell.quantityLbl.text = activeArray[indexPath.row].customer_location
                    
                    cell.orderStatus.text = "تم قبول طلب التوصيل ولم يتم التوصيل بعد"
                    cell.orderStatus.textColor = #colorLiteral(red: 1, green: 0.8943169713, blue: 0, alpha: 1)
                    if activeArray[indexPath.row].products?.first?.advID == "0"{
                        cell.changeStatusOfOrderBtn.isHidden = false
                        cell.cancelOrder.isHidden = false
                        cell.changeStatusOfOrderBtn.setTitle("تم وصول الطلب", for: .normal)
                    }else{
                        cell.changeStatusOfOrderBtn.isHidden = true
                    }
                }
            }
            
        }else {
            cell.orderStatus.text = "تم التوصيل"
            cell.orderStatus.textColor = #colorLiteral(red: 0.262745098, green: 0.9019607843, blue: 0.5843137255, alpha: 1)
            cell.changeStatusOfOrderBtn.isHidden = true
            cell.cancelOrder.isHidden = true
        }
        var Totel : Int = 0
        if let prodects = activeArray[indexPath.row].products{
            prodects.forEach { (prodect) in
                if let cost = Int(prodect.totalCost ?? "0") {
                    Totel = Totel + cost
                }
            }
        }
        cell.priceLbl.text = "\(Totel) جنية"
        if let urlImage =  activeArray[indexPath.row].products?.first?.productImg {
            cell.imageofOrder.getImage(imageUrl: urlImage)
        }
        return cell
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
