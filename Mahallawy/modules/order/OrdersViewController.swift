//
//  OrdersViewController.swift
//  easyDriver
//
//  Created by jooo on 5/19/21.
//

import UIKit
import Kingfisher
import RxCocoa
import Alamofire
import RxSwift
import Toast_Swift
import MOLH
import CoreLocation
class OrdersViewController: BaseWireFrame<OrdersViewModel> {
    
    @IBOutlet weak var wantDeliveryContainer: UIView!
    
    @IBOutlet weak var deliveryActionContainer: WantDeliveryorNot!
    @IBOutlet weak var noOrderSLabel: UILabel!
    @IBOutlet weak var Actinityloading: UIActivityIndicatorView!
    @IBOutlet weak var stackOfCatagories: UIStackView!
    @IBOutlet weak var noOrderView: UIView!
    @IBOutlet weak var Myordertableview: UITableView!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var newBtn: UIButton!
    let refreshControl = UIRefreshControl()
    var isfilter = false
    var typeOfUser = ""
    var OrderidToDelivery : String?
//    var filterArrayOfDeliverystatus =  [Orders](){
//        didSet{
//            if filterArrayOfDeliverystatus.isEmpty{
//                self.noOrderView.isHidden = false
//            }else{
//                self.noOrderView.isHidden = true
//            }
//        }
//    }
    var filterArrayOfstatus =  [Order](){
        didSet{
            if filterArrayOfstatus.isEmpty{
                self.noOrderView.isHidden = false
            }else{
                self.noOrderView.isHidden = true
            }
        }
    }
    var cellIdentifier = "MyOrderTableViewCell"
    var arrayOfOredrs = [Order](){
        didSet{
            self.isfilter = true
            filterArrayOfstatus = arrayOfOredrs.filter({($0.statues == Orderstatus.new.rawValue)})
            Myordertableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String else {return}
        print(userType)
        wantDeliveryContainer.isHidden = true
        getMyOrders(fromRefrach: false)
    }
    
    override func bind(ViewModel: OrdersViewModel) {
        setupUi()
        setButtonConfegration(sender: newBtn)
       

    }
    
    func getMyOrders(fromRefrach : Bool) {
        setButtonConfegrationUnselected(sender: finishBtn)
        setButtonConfegrationUnselected(sender: activeBtn)
        setButtonConfegration(sender: newBtn)
        
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String  else {return}
        print(userId)
        if fromRefrach {
            Actinityloading.stopAnimating()
        }else{
            Actinityloading.startAnimating()
        }
        let params : [String : String] = [
            "userid" : userId
        ]
        vieeModel.Myorder(parameters: params).subscribe(onNext: { [weak self] (myoredr) in
            guard let self = self else {return}
            guard let data = myoredr.orders else {return}
            print(data)
            self.Actinityloading.stopAnimating()
            self.refreshControl.endRefreshing()
            if data.isEmpty{
                self.noOrderView.isHidden = false
            }else{
                self.noOrderView.isHidden = true
                self.stackOfCatagories.isHidden = false
            }
            self.arrayOfOredrs = data
        }, onError: { [weak self] (error) in
            guard let self = self else {return}
            self.Actinityloading.stopAnimating()
            print(error)
        }).disposed(by: disposePag)
    }
        
        
    
    
    func setupUi(){
        wantDeliveryContainer.isHidden = true
        deliveryActionContainer.needDeliveryBtn.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return}
            guard let orderId = self.OrderidToDelivery else {return}
            let searchDelivery = self.coordinator.mainNavigator.viewController(for: .SearchDelivertyViewController(orderId: orderId, OrderTaiarDate: nil, image: nil))
            self.navigationController?.pushViewController(searchDelivery, animated: true)
        }).disposed(by: disposePag)
        
       
        self.title = "طلباتي"
        Myordertableview.delegate = self
        Myordertableview.dataSource = self
        Myordertableview.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.self)
        
        Myordertableview.estimatedRowHeight = 1000
        Myordertableview.rowHeight = UITableView.automaticDimension
        Myordertableview.tableFooterView = .none
        
        //        refreshControl.attributedTitle = NSAttributedString(string: "loading...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        Myordertableview.addSubview(refreshControl)
        
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @objc func refresh(){
        Actinityloading.isHidden = true
        getMyOrders(fromRefrach: true)
    }
    
    @IBAction func activeBtn(_ sender: UIButton) {
        isfilter = true
        filterArrayOfstatus = arrayOfOredrs.filter({$0.statues == Orderstatus.active.rawValue})
        setButtonConfegrationUnselected(sender: finishBtn)
        setButtonConfegrationUnselected(sender: newBtn)
        setButtonConfegration(sender: activeBtn)
        
        Myordertableview.reloadData()
    }
    @IBAction func NEWBTN(_ sender: UIButton) {
        isfilter = true
        setButtonConfegrationUnselected(sender: finishBtn)
        setButtonConfegrationUnselected(sender: activeBtn)
        setButtonConfegration(sender: newBtn)
        filterArrayOfstatus = arrayOfOredrs.filter({$0.statues  == Orderstatus.new.rawValue})
        Myordertableview.reloadData()
    }
    @IBAction func finished(_ sender: UIButton) {
        isfilter = true
        filterArrayOfstatus = arrayOfOredrs.filter({$0.statues == Orderstatus.finished.rawValue || $0.statues == Orderstatus.shop_cancel.rawValue || $0.statues == Orderstatus.client_cancel.rawValue})
        print(filterArrayOfstatus)
        setButtonConfegrationUnselected(sender: newBtn)
        setButtonConfegrationUnselected(sender: activeBtn)
        setButtonConfegration(sender: finishBtn)
        Myordertableview.reloadData()
    }
    
    
    func setButtonConfegration(sender : UIButton){
        let mySelectedAttributedTitle = NSAttributedString(string:sender.currentTitle ?? "ee",attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5098039216, green: 0.1450980392, blue: 0.1176470588, alpha: 1) , NSAttributedString.Key.font : UIFont(name: Font.Regular.name, size: 22)!])
        sender.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
    }
    
    func setButtonConfegrationUnselected(sender : UIButton){
        let mySelectedAttributedTitle = NSAttributedString(string:sender.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1333333333, alpha: 0.5) , NSAttributedString.Key.font : UIFont(name: Font.Light.name, size: 20)!])
        sender.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
    }
}

extension OrdersViewController  : MyOrderCellprotocol{
   
    
    func CancelStatus(orderId: String, callerId: String?, Status: String?, nesbet_tawsel: String?, delivery_id: String?) {
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        self.changeStatusOfOrder(orderId: orderId, callerId: userId, deliver_statues: Status, nesbet_tawsel: nesbet_tawsel, delivery_id: delivery_id)
    }
    
    func changeStatus(orderId: String, callerId: String?, deliver_statues: String?, nesbet_tawsel: String?, delivery_id: String?, deliveryPhone: String?, delivername: String?) {
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        
        guard let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String else {return}
        
        print(delivery_id,nesbet_tawsel)
        var status = ""
        if userType == "1"{
            wantDeliveryContainer.isHidden = false
            OrderidToDelivery = orderId
            deliveryActionContainer.notNeedDelivery.rx.tap.subscribe(onNext: { [weak self] (_) in
                guard let self = self else {return}
                self.wantDeliveryContainer.isHidden = true
                self.changeStatusOfOrder(orderId: orderId, callerId: userId, deliver_statues: status, nesbet_tawsel: nesbet_tawsel, delivery_id: delivery_id)
            }).disposed(by: disposePag)
            status = Orderstatus.active.rawValue
        }else{
            status = Orderstatus.finished.rawValue
            self.changeStatusOfOrder(orderId: orderId, callerId: userId, deliver_statues: status, nesbet_tawsel: nesbet_tawsel, delivery_id: delivery_id)
        }
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
        
    }
    
    func MapShop(location: CLLocationCoordinate2D) {
        
    }
    
    func openDetailes(prodects: [Product]) {
        let DetailesVc = coordinator.mainNavigator.viewController(for: .CartViewController(arrayOfProdect: prodects))
        navigationController?.pushViewController(DetailesVc, animated: true)
    }
    
    func changeStatusOfOrder(orderId: String, callerId: String?, deliver_statues: String?, nesbet_tawsel: String?, delivery_id: String?) {
        Actinityloading.startAnimating()
        vieeModel.ChangeStatusOforder(order_id : orderId, user_id : callerId ?? "" , statues : deliver_statues ?? "" ,nesbet_tawsel : nesbet_tawsel, delivery_id : delivery_id).subscribe(onNext: { [weak self ] (resultData) in
            guard let self = self else {return}
           self.Actinityloading.isHidden = true
            let message = resultData.response[0].message
           var style = ToastStyle()
           style.messageColor = .white
           style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            self.getMyOrders(fromRefrach: false)
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

    func notAttented(bookingData: Order) {
        if bookingData.statues ==  "" {
            
            guard let id = bookingData.orderID else {
                return
            }
            let popviewModel = popupViewModel(selectedType: .Refund, bookingid: id)
            let pop = popUpViewController(ViewModel: popviewModel, coordinator: coordinator)
            present(pop, animated: true, completion: nil)
        }else {
            
        }
        
    }
    
    func accceptBtn(bookingData: Order) {
        guard let id = bookingData.orderID else {
            return
        }
        let popviewModel = popupViewModel(selectedType: .accept, bookingid: id)
        let pop = popUpViewController(ViewModel: popviewModel, coordinator: coordinator)
        pop.isSeccessAcceptOrRject.subscribe(onNext: { [weak self] (isseccess) in
            if isseccess {
                guard let self = self else {return}
                let popviewModel = PopUpCenterViewModel(selectedType: .accept)
                let pop = PopUpCenterViewController(ViewModel: popviewModel, coordinator: self.coordinator)
                self.present(pop, animated: true, completion: nil)
            }
        }).disposed(by: disposePag)
        present(pop, animated: true, completion: nil)
    }
    
    func canselClick(bookingData: Order) {
        guard let id = bookingData.orderID else {
            return
        }
        let popviewModel = popupViewModel(selectedType: .reject, bookingid: id)
        let pop = popUpViewController(ViewModel: popviewModel, coordinator: coordinator)
        pop.isSeccessAcceptOrRject.subscribe(onNext: { [weak self] (isseccess) in
            if isseccess {
                guard let self = self else {return}
                let popviewModel = PopUpCenterViewModel(selectedType: .reject)
                let pop = PopUpCenterViewController(ViewModel: popviewModel, coordinator: self.coordinator)
                self.present(pop, animated: true, completion: nil)
            }
        }).disposed(by: disposePag)
        present(pop, animated: true, completion: nil)
    }
    
    
}


extension OrdersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isfilter ? filterArrayOfstatus.count : arrayOfOredrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyOrderTableViewCell
        cell.selectionStyle = .none
        let activeArray = isfilter ? filterArrayOfstatus : arrayOfOredrs
        cell.Deleget = self
        cell.orderId = activeArray[indexPath.row].orderID
        cell.Delivery_Id = activeArray[indexPath.row].deleviry_id
        cell.deliverySellery = activeArray[indexPath.row].delevery_sallary
        cell.prodects = activeArray[indexPath.row].products
      
        var Quantity : Int = 0
        activeArray[indexPath.row].products?.forEach({ (prodect) in
            Quantity += Int(prodect.count ?? "0") ?? 0
            
        })
        
        cell.quantityLbl.text = "\(Quantity)"
        cell.orderNumberLbl.text =  activeArray[indexPath.row].orderID
        cell.orderTimeLbl.text = activeArray[indexPath.row].createdAt
        cell.containerOfProdects.isHidden = true
        cell.containerOfShopPhone.isHidden = true
        cell.containerOfNameOfShop.isHidden = true
        cell.containerOfPresentOfDelivered.isHidden = true
        var Totel : Int = 0
        if let prodects = activeArray[indexPath.row].products{
            prodects.forEach { (prodect) in
                if let cost = Int(prodect.totalCost ?? "0") {
                    Totel = Totel + cost
                }
            }
        }
        
        cell.priceLbl.text = "\(Totel) جنية"
        if let urlImage =  activeArray[indexPath.row].shopLogo {
            cell.imageofOrder.getImage(imageUrl: urlImage)
        }
        
        if activeArray[indexPath.row].deleviry_name == "0"{
            
        }else{
            cell.containerOfPresentOfDelivered.isHidden = false
            cell.containerOfShopPhone.isHidden = false
            cell.containerOfNameOfShop.isHidden = false
            cell.presentOfDelivered.text = "\(activeArray[indexPath.row].delevery_sallary ?? "0")"
            cell.phoneOfShopTopLab.text = activeArray[indexPath.row].deleviry_phone
            cell.deliveryPhone = activeArray[indexPath.row].deleviry_phone
            cell.nameOfShopTopLbl.text = activeArray[indexPath.row].deleviry_name
            cell.deliveryNameSetLbl.text = "رقم مندوب التوصيل"
            cell.deliveryNameLbl.text = "مندوب التوصيل"
            cell.adderssphone.isHidden = false
        }
        if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "0" || userType == "2"  {
                
                cell.nameOfBrand.text = activeArray[indexPath.row].shopName
                cell.naleOfbrandOrShopLbl.text = "اسم المحل :"
                cell.phoneCahngeUserOrShop.text = "رقم الهاتف للمحل:"
                cell.addressChangeUserOrShop.text = "عنوان المحل :"
                cell.nameOfProdectLbl.text = "\(activeArray[indexPath.row].products?.count ?? 0)"
                cell.addressLbl.text = activeArray[indexPath.row].shopAddress
                cell.phoneLbl.text = activeArray[indexPath.row].shopPhone
                
                if activeArray[indexPath.row].statues == Orderstatus.new.rawValue {
                    cell.orderStatus.text = "انتظار قبول الطلب"
                    cell.changeStatusOfOrderBtn.isHidden = true
                    
                }else if  activeArray[indexPath.row].statues == Orderstatus.active.rawValue {
                    cell.orderStatus.text = "تم قبول الطلب"
                    cell.changeStatusOfOrderBtn.setTitle("تم وصول الطلب", for: .normal)
                    cell.orderStatus.textColor = #colorLiteral(red: 0.262745098, green: 0.9019607843, blue: 0.5843137255, alpha: 1)
                    cell.changeStatusOfOrderBtn.isHidden = false
                }else if  activeArray[indexPath.row].statues == Orderstatus.shop_cancel.rawValue {
                    cell.orderStatus.text = "تم الالغاء من قبل التاجر"
                    cell.containerOfAcceptOrCancellStack.isHidden = true
                }else if  activeArray[indexPath.row].statues == Orderstatus.client_cancel.rawValue {
                    cell.orderStatus.text = "تم الالغاء من قبل العميل"
                    cell.containerOfAcceptOrCancellStack.isHidden = true
                }else {
                    cell.orderStatus.text = "تم التوصيل"
                    cell.orderStatus.textColor = #colorLiteral(red: 0.262745098, green: 0.9019607843, blue: 0.5843137255, alpha: 1)
                    cell.containerOfAcceptOrCancellStack.isHidden = true
                    
                }
            }else{
                cell.phoneCahngeUserOrShop.text = "رقم الهاتف للمستخدام:"
                cell.addressChangeUserOrShop.text = "عنوان المستخدام :"
                cell.nameOfBrand.text = activeArray[indexPath.row].customerName
                cell.nameOfProdectLbl.text = "\(activeArray[indexPath.row].products?.count ?? 0)"
                cell.addressLbl.text = activeArray[indexPath.row].location
                cell.phoneLbl.text = activeArray[indexPath.row].customerPhone
                
                if activeArray[indexPath.row].statues == Orderstatus.new.rawValue {
                    cell.orderStatus.text = "انتظار قبول الطلب"
                    cell.changeStatusOfOrderBtn.isHidden = false
                    cell.changeStatusOfOrderBtn.setTitle("قبول الطلب", for: .normal)
                }else if  activeArray[indexPath.row].statues == Orderstatus.active.rawValue {
                    cell.orderStatus.text = "تم قبول الطلب"
                    cell.orderStatus.textColor = #colorLiteral(red: 0.262745098, green: 0.9019607843, blue: 0.5843137255, alpha: 1)
                    cell.changeStatusOfOrderBtn.isHidden = true
                }else if  activeArray[indexPath.row].statues == Orderstatus.shop_cancel.rawValue {
                    cell.orderStatus.text = "تم الالغاء من قبل التاجر"
                    cell.containerOfAcceptOrCancellStack.isHidden = true
                }else if  activeArray[indexPath.row].statues == Orderstatus.client_cancel.rawValue {
                    cell.orderStatus.text = "تم الالغاء من قبل العميل"
                    cell.containerOfAcceptOrCancellStack.isHidden = true
                }else {
                    cell.orderStatus.text = "تم التوصيل"
                    cell.orderStatus.textColor = #colorLiteral(red: 0.262745098, green: 0.9019607843, blue: 0.5843137255, alpha: 1)
                    cell.containerOfAcceptOrCancellStack.isHidden = true
                    
                }
            }
        }
        
        return cell
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
