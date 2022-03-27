//
//  CartViewController.swift
//  Mahallawy
//
//  Created by jooo on 7/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import NVActivityIndicatorView
import Toast_Swift
import CoreLocation
import MOLH
class CartViewController: BaseWireFrame<CartViewModel> {
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var containerOfMakeOrder: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var CartCollectioView: UICollectionView!
    var userLocation : CLLocationCoordinate2D?
    var userAdddressName  : String?
    var isProdectDate : Bool = true
    var TotalPrics = 0{
        didSet{
            self.totalPrice.text = "\(TotalPrics) جنية"
        }
    }
    var ArrayOfCartData = [Cart](){
        didSet{
            CartCollectioView.reloadData()
        }
    }
    private let bag = DisposeBag()
    
    var arrayOfProdect : [Product] = []{
        didSet{
            CartCollectioView.reloadData()
        }
    }
    let cellidentifier = "CartCollectionViewCell"
    
    var ProdectshaveValue : BehaviorRelay<Bool> = .init(value: false)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func bind(ViewModel: CartViewModel) {
        setupUI()
        
        if let prodects = vieeModel.arrayOfProdect {
            isProdectDate = true
            print(prodects)
            title = "تفاصيل الطلب"
            arrayOfProdect = prodects
            CartCollectioView.reloadData()
            CartCollectioView.isHidden = false
            containerOfMakeOrder.isHidden = true
        }else{
            isProdectDate = false
            GetCart()
            vieeModel.isEmptyCart.subscribe(onNext: { [weak self]  (Empty) in
                guard let self = self else {return}
                if Empty{
                    self.emptyView.isHidden = false
                    self.containerOfMakeOrder.isHidden = true
                }else{
                    self.emptyView.isHidden = true
                    self.containerOfMakeOrder.isHidden = false
                }
            }).disposed(by: disposePag)
            
            vieeModel.arrayOfCart.subscribe(onNext: {[weak self] (ArrayOfData) in
                guard let self = self else {return}
                self.ArrayOfCartData = ArrayOfData
            }).disposed(by: disposePag)
        }
    }
    
    func GetCart(){
        
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        loadingView.startAnimating()
        TotalPrics = 0
        vieeModel.GetCart(parameters: ["user_id" : userId]).subscribe(onNext: {[weak self] (carts) in
            guard let self = self else {return}
            carts.forEach { (cart) in
                self.TotalPrics = self.TotalPrics +  (Int(cart.orderPrice ?? "0") ?? 0)
                self.emptyView.isHidden = true
                self.containerOfMakeOrder.isHidden = false
                self.loadingView.stopAnimating()
            }
        }, onError: { [weak self] (error) in
            guard let self = self else {return}
            self.loadingView.stopAnimating()
            self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
        }).disposed(by: disposePag)
        
    }
    func setupUI(){
        
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        self.title = "السلة"
        CartCollectioView.dataSource = self
        CartCollectioView.delegate = self
        CartCollectioView.register(UINib(nibName: "CartCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CartCollectionViewCell".self)
    }
    
    @IBAction func makeOrder(_ sender: Any) {
        print(ArrayOfCartData)
        let conform =  coordinator.mainNavigator.viewController(for: .mapView(cartDate: ArrayOfCartData))
        navigationController?.pushViewController(conform, animated: true)
    }
    
    @IBAction func GoToMain(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension CartViewController: UICollectionViewDelegate ,  UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, CartCollectionViewProtocal{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isProdectDate ? arrayOfProdect.count : ArrayOfCartData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CartCollectionViewCell", for: indexPath) as! CartCollectionViewCell
        if isProdectDate {
            let activeArray = arrayOfProdect
            let item = activeArray[indexPath.row]
            cell.nameOfProdect.text = item.productName
            cell.priceLbl.text = "\(item.totalCost ?? "") جنية"
            cell.nameOfBrandOrQuantity.text = "الكمية"
            cell.nameOfBrand.text = item.count
            cell.deleteBtn.isHidden = true
            cell.notes.text = item.orderDescription?.isEmpty ?? true ? "لا يوجد ملاحظات" : item.orderDescription
            let image = item.productImg?.components(separatedBy: "-").first
            cell.Deleget = self
            if let stringUrl = image {
                print(stringUrl)
                if let url = URL(string: stringUrl) {
                    let reefrence = ImageResource(downloadURL: url)
                    cell.imageOfProdecgt.kf.setImage(with: reefrence,placeholder: #imageLiteral(resourceName: "applogo"))
                }
            }
        }else{
            let activeArray = ArrayOfCartData
            let item = activeArray[indexPath.row]
            cell.CartId = item.cartID
            cell.nameOfProdect.text = item.orderName
            cell.priceLbl.text = "\(item.orderPrice ?? "") جنية"
            cell.nameOfBrand.text = item.shop_name
            cell.notes.text = item.userDescription?.isEmpty ?? true ? "لا يوجد ملاحظات" : item.userDescription
            cell.nameOfBrandOrQuantity.text = "اسم المحل"
            let image = item.orderImg?.components(separatedBy: "-").first
            cell.Deleget = self
            if let stringUrl = image {
                print(stringUrl)
                if let url = URL(string: stringUrl) {
                    let reefrence = ImageResource(downloadURL: url)
                    cell.imageOfProdecgt.kf.setImage(with: reefrence,placeholder: #imageLiteral(resourceName: "applogo"))
                }
            }
        }
        
        return cell
    }
    
    func DeleteProdect(cartId: String) {
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        let params : [String : String] = [
            "user_id" : userId,
            "cartid" : cartId
        ]
        loadingView.startAnimating()
        vieeModel.deletedItemFromCart(parameters: params).subscribe(onNext: { [weak self ] (resultData) in
            guard let self = self else {return}
           self.loadingView.isHidden = true
           let message = resultData.Response[0].message
            if var counterIncart = UserDefaults.standard.value(forKey: NetworkConstants.CounterInCart) as? Int {
                counterIncart -= 1
                UserDefaults.standard.setValue(counterIncart, forKey: NetworkConstants.CounterInCart)
                UserDefaults.standard.synchronize()
            }
           var style = ToastStyle()
           style.messageColor = .white
           style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            self.GetCart()
           DispatchQueue.main.async { [weak self ] in
                guard let self = self else {return}
               self.view.makeToast(message, duration: 3.0, position: .top, style: style)
           }
       },onError: { [weak self ] (error) in
           guard let self = self else {return}
           self.loadingView.isHidden = true
           self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
       }).disposed(by: disposePag)
        print(cartId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isProdectDate {
            let size = CGSize(width: collectionView.frame.width, height: 300)
            return size
        }else{
            let width = collectionView.bounds.width
            let padding: CGFloat = 10
            
            let availableWidth =  width - (padding * 2)
            let itemWidth = availableWidth / 2
            
            let size = CGSize(width: itemWidth, height: 300)
            return size
        }
        
    }
    
    

}
