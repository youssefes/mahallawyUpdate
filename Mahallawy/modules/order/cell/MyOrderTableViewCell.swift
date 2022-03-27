//
//  MyOrderTableViewCell.swift
//  Elsade
//
//  Created by jooo on 5/16/21.
//

import UIKit
import MOLH
import CoreLocation
protocol MyOrderCellprotocol {
    func changeStatus(orderId : String , callerId : String?, deliver_statues : String? , nesbet_tawsel : String? , delivery_id : String?, deliveryPhone : String?  , delivername : String?)
    func CancelStatus(orderId : String , callerId : String?, Status : String? , nesbet_tawsel : String? , delivery_id : String?)
    func openDetailes(prodects :[Product])
    func callUser(phone : String)
    func callShop(phone : String)
    func MpaUser(location : CLLocationCoordinate2D)
    func MapShop(location : CLLocationCoordinate2D)
}


class MyOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerOfAcceptOrCancellStack: UIStackView!
    @IBOutlet weak var containerOfStatusStack: UIStackView!
    @IBOutlet weak var qauntityInDeliveryLbl: UILabel!
    @IBOutlet weak var containerOfPresentOfDelivered: UIStackView!
    @IBOutlet weak var containerOfShopPhone: UIStackView!
    @IBOutlet weak var containerOfNameOfShop: UIStackView!
    
    @IBOutlet weak var cancelOrder: UIButton!
    @IBOutlet weak var deliveryNameLbl: UILabel!
    @IBOutlet weak var deliveryNameSetLbl: UILabel!
    @IBOutlet weak var naleOfbrandOrShopLbl: UILabel!
    @IBOutlet weak var adderssShop: UIButton!
    @IBOutlet weak var userPhone: UIButton!
    @IBOutlet weak var adderssphone: UIButton!
    @IBOutlet weak var useraddress: UIButton!
    @IBOutlet weak var containerOfProdects: UIStackView!
    
    @IBOutlet weak var presentOfDelivered: UILabel!
    @IBOutlet weak var phoneOfShopTopLab: UILabel!
    @IBOutlet weak var prodectLbl: UILabel!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var changeStatusOfOrderBtn: UIButton!
    @IBOutlet weak var nameOfShopTopLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var nameOfBrand: UILabel!
    @IBOutlet weak var imageofOrder: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var nameOfProdectLbl: UILabel!
    @IBOutlet weak var orderTimeLbl: UILabel!
    
    @IBOutlet weak var phoneCahngeUserOrShop: UILabel!
    @IBOutlet weak var addressChangeUserOrShop: UILabel!
    var orderId : String?
    var callerId : String?
    var deliver_statues : String?
    var Delivery_Id : String?
    var deliverySellery : String?
    var prodects :[Product]?
    var Deleget : MyOrderCellprotocol?
    var orderDate : Orders?
    var deliveryPhone : String?
    var TaiarOrders : Bool =  false
    var delivername : String?
    override func prepareForReuse() {
        changeStatusOfOrderBtn.isHidden = false
        containerOfAcceptOrCancellStack.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeStaustn(_ sender: Any) {
        guard let orderId = orderId  else {
            return
        }
//        print(deliverySellery,Delivery_Id)
        Deleget?.changeStatus(orderId: orderId, callerId: callerId, deliver_statues: deliver_statues , nesbet_tawsel : deliverySellery , delivery_id : Delivery_Id , deliveryPhone : deliveryPhone, delivername : delivername )
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        guard let orderId = orderId  else {
            return
        }
        guard let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String else {return}
        
        if TaiarOrders {
            if prodects?.first?.advID == "0" {
                if userType == "1"{
                    Deleget?.CancelStatus(orderId: orderId, callerId: callerId, Status: "shop_cancel", nesbet_tawsel: nil, delivery_id: nil)
                }else{
                    Deleget?.CancelStatus(orderId: orderId, callerId: callerId, Status: "client_cancel", nesbet_tawsel: nil, delivery_id: nil)
                }
            }else{
                Deleget?.CancelStatus(orderId: orderId, callerId: callerId, Status: Orderstatus.new.rawValue, nesbet_tawsel: nil, delivery_id: nil)
            }
        }else{
            if userType == "1"{
                Deleget?.CancelStatus(orderId: orderId, callerId: callerId, Status: "shop_cancel", nesbet_tawsel: nil, delivery_id: nil)
            }else{
                Deleget?.CancelStatus(orderId: orderId, callerId: callerId, Status: "client_cancel", nesbet_tawsel: nil, delivery_id: nil)
            }
        }
    }
    @IBAction func deatailesOfOrderBtn(_ sender: Any) {
        guard let prodects = prodects else {
            return
        }
        Deleget?.openDetailes(prodects: prodects)
    }
    @IBAction func userAddress(_ sender: Any) {
        let loactionOfUser = CLLocationCoordinate2D(latitude: Double(orderDate?.customer_latitude ?? "0.0") ?? 0.0, longitude: Double(orderDate?.customer_longitude ?? "0.0") ?? 0.0)
        Deleget?.MpaUser(location: loactionOfUser)
    }
    @IBAction func phoneUser(_ sender: Any) {
        if TaiarOrders {
            if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
                if userType == "2"{
                    if let phoneOfuser = orderDate?.customer_phone{
                       Deleget?.callUser(phone: phoneOfuser)
                    }
                } else if userType == "1"{
                    if let phoneOfuser = orderDate?.customer_phone{
                       Deleget?.callUser(phone: phoneOfuser)
                    }
                }else{
                    if let phoneOfuser = deliveryPhone{
                       Deleget?.callUser(phone: phoneOfuser)
                    }
                }
            }
        }else{
            if let phoneOfuser = orderDate?.customer_phone {
                Deleget?.callUser(phone: phoneOfuser)
            } else if let phoneOfuser = deliveryPhone {
                Deleget?.callUser(phone: phoneOfuser)
            }
        }
       
       
    }
    @IBAction func shopAddress(_ sender: Any) {
        let loactionOfShop = CLLocationCoordinate2D(latitude: Double(orderDate?.shop_latitude ?? "0.0") ?? 0.0, longitude: Double(orderDate?.shop_longitde ?? "0.0") ?? 0.0)
        Deleget?.MapShop(location: loactionOfShop)
    }
    @IBAction func phoneOfShop(_ sender: Any) {
        if TaiarOrders {
            if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
                if userType == "2"{
                    if let phoneOfuser = orderDate?.shop_phone{
                        Deleget?.callShop(phone: phoneOfuser)
                    }
                } else if userType == "1"{
                    if let phoneOfuser = deliveryPhone{
                        Deleget?.callShop(phone: phoneOfuser)
                    }
                }else{
                    if let phoneOfuser = deliveryPhone{
                        Deleget?.callShop(phone: phoneOfuser)
                    }
                }
            }
        }else{
            if let phoneOfuser = orderDate?.shop_phone {
                Deleget?.callShop(phone: phoneOfuser)
            } else if let phoneOfuser = deliveryPhone {
                Deleget?.callShop(phone: phoneOfuser)
            }
           
        }
       
    }
}
