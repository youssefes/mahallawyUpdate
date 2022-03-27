//
//  CatagoriesDetaielsViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/30/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
import Toast_Swift
import MOLH
import NVActivityIndicatorView
class CatagoriesDetaielsViewController: BaseWireFrame<CatagoriesDetaielsViewModels>{
    @IBOutlet weak var descriptionatbleView: UITableView!
    @IBOutlet weak var notesTv: UITextView!
    
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var QunitiyView: QuantityView!
    
    @IBOutlet weak var containerOFScrollView: UIView!
    @IBOutlet weak var DeleteViewContainer: UIView!
    @IBOutlet weak var addLikeBtn: UIButton!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var paginagtionController: UIPageControl!
 
    @IBOutlet weak var describtionLbl: UILabel!
    
      @IBOutlet weak var moreThanAddvertise: UIButton!
    
    @IBOutlet weak var addratingBtn: UIButton!
    @IBOutlet weak var addratingView: CosmosView!
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
  
    @IBOutlet weak var addreatingStack: UIStackView!
    private var currentSlide = 0
    private var sliderTimer: Timer?
    private var slideToItem = 0
    var BrandId : String?
    var QuentityOfProdect = 1
    var AddvertismentId : String?
    var AddvertismentData : AdSubCatagories?
    let cellIdentifier  = "SliderCell"
  
    @IBOutlet weak var addToCartContainer: UIView!
    let cellIdentifierOftable = "DescriptionTableViewCell"
    var isFavuiret : Bool = false
    var brand : Brand?
    var numberofLike : Int = 0
    var ArrayOfDescriptionData : [String] = ["اسم المنتج", "سعر المنتج", "العنوان", "رقم المحمول" ,"الاعجابات","تاريخ النشر", "القسم"]
    var ArrayOfDescriptionvalue : [String] = []
    
    
    var slides: [String]? {
        didSet{
            guard let slider = slides else {return}
            paginagtionController.numberOfPages = slider.count
            sliderCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            MOLH.setLanguageTo("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupUI(){
        
        if vieeModel.catId == "16" || vieeModel.catId ==  "17" || vieeModel.catId == "18" || vieeModel.catId == "15" || vieeModel.catId == "9" {
            self.addToCartContainer.isHidden = true
        }
        sliderTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier.self)
        descriptionatbleView.register(UINib(nibName: cellIdentifierOftable, bundle: nil), forCellReuseIdentifier: cellIdentifierOftable.self)
        descriptionatbleView.delegate = self
        descriptionatbleView.dataSource = self
        
    }

    override func bind(ViewModel: CatagoriesDetaielsViewModels) {
        setupUI()
       
        if let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "1"{
                addToCartContainer.isHidden = true
            }
           
        }
        
        QunitiyView.currentValue.subscribe(onNext: { [weak self ] (value) in
            guard let self = self else {return}
            self.QuentityOfProdect = value
        }).disposed(by: disposePag)
        
        ViewModel.getBrands { [weak self] (brand, subcatagroies, isMyAddvertisment)  in
            guard let self = self else {return}
            if subcatagroies != nil{
                
               
                self.AddvertismentData = subcatagroies
                
                self.AddvertismentId = subcatagroies?.id
                self.BrandId = subcatagroies?.id
                self.title = subcatagroies?.title
                self.addLikeBtn.setImage(subcatagroies?.islike ?? false ? #imageLiteral(resourceName: "when_like") : #imageLiteral(resourceName: "when_unlike") , for: .normal)
                self.describtionLbl.text = subcatagroies?.adDescription
              
                self.ArrayOfDescriptionvalue.append(subcatagroies?.title ?? "")
                self.ArrayOfDescriptionvalue.append("\(subcatagroies?.cost ??  "") جنية")
                self.ArrayOfDescriptionvalue.append(subcatagroies?.adress ?? "")
                self.ArrayOfDescriptionvalue.append(subcatagroies?.phone ?? "")
                self.ArrayOfDescriptionvalue.append("\(subcatagroies?.likes ?? "0") اعجبهم المنتج")
                self.ArrayOfDescriptionvalue.append(subcatagroies?.updatedAt ?? "")
                self.ArrayOfDescriptionvalue.append(subcatagroies?.categoryname ?? "")
            
                self.ratingView.rating = Double(subcatagroies?.currentRate ?? 0)
                self.ratingView.text = "(\(subcatagroies?.nomOfRate ?? 0))"
                self.numberOfViews.text = "\(subcatagroies?.viewers ?? "0") مشاعدة"
                self.numberofLike = Int(subcatagroies?.likes ?? "0") ?? 0
                self.moreThanAddvertise.setTitle("  المزيد من اعلانات \(subcatagroies?.brandname ?? "")", for: .normal)

                let myRate = subcatagroies?.myRate ?? 0
                if myRate != 0{
                    self.addratingBtn.setTitle("\(myRate) تقيمي", for: .normal)
                }
                
                if let pices = subcatagroies?.pics {
                    let array = pices.components(separatedBy: "-")
                    self.slides = array
                    self.slides?.removeAll(where: {$0 == ""})
                }
                
                let brand = Brand(id: subcatagroies?.brandid, fullname: subcatagroies?.brandname, brandDescription: subcatagroies?.brandDescription, email: nil, phone: subcatagroies?.phone, address: subcatagroies?.adress, brandlogo: subcatagroies?.brandlogo, longitude: subcatagroies?.longitude, latitude: subcatagroies?.latitude, worktime: subcatagroies?.worktime, categoryname: subcatagroies?.categoryname, pics: subcatagroies?.brandpics, nomOfRaters: subcatagroies?.nomOfRate, myRate: subcatagroies?.myRate, isFollow: subcatagroies?.isFollow, isRate: subcatagroies?.isRate, currentrate: subcatagroies?.currentRate)
                self.brand = brand
                if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String  {
                    guard let catId = subcatagroies?.id else {return}
                    let Paras : [String: String] = [
                        "ad_id" : catId,
                        "user_id" : userId
                    ]
                    ViewModel.addView(parameters: Paras)
                }else {
                    guard let catId = subcatagroies?.id , let userId = UIDevice.current.identifierForVendor?.uuidString else {return}
                    let Paras : [String: String] = [
                        "ad_id" : catId,
                        "user_id" : userId
                    ]
                    ViewModel.addView(parameters: Paras)
                }
                
                if isMyAddvertisment{

                    if #available(iOS 13.0, *) {
                        if ((subcatagroies?.activated) != nil) {
                            let EditeButton = UIBarButtonItem(image: UIImage(systemName: "doc.badge.gearshape"), style: .plain, target: self, action: #selector(self.EditeCatagorie))
                            let DeletedButton =  UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(self.DeletedCatagorie))
                            self.navigationItem.rightBarButtonItems = [EditeButton , DeletedButton]
                        }else{
                            let DeletedButton =  UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(self.DeletedCatagorie))
                            self.navigationItem.rightBarButtonItems = [DeletedButton]
                        }
                       
                    } else {
                        
                        if ((subcatagroies?.activated) != nil) {
                            let EditeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.EditeCatagorie))
                            let DeletedButton =  UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.DeletedCatagorie))
                            self.navigationItem.rightBarButtonItems = [EditeButton , DeletedButton]
                        }else{
                            let DeletedButton =  UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(self.DeletedCatagorie))
                            self.navigationItem.rightBarButtonItems = [DeletedButton]
                        }
                        
                    }
                }
            }
        }
        
        
        ViewModel.SeccessDeleteAddvertisment.asObservable().subscribe(onNext: { [weak self] (DeleteResulte) in
            guard let self = self else {return}
            if DeleteResulte.response[0].statues{
                self.DeleteViewContainer.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }else{
                self.DeleteViewContainer.isHidden = true
            }
        }, onError: {[weak self] (error) in
                guard let self = self else {return}
                self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
        }).disposed(by: disposePag)
        
        ViewModel.SeccessRequestAddRatingObservable.subscribe(onNext: { [weak self ] (resultData) in
             guard let self = self else {return}
            let message = resultData.response[0].message
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            DispatchQueue.main.async { [weak self ] in
                 guard let self = self else {return}
                self.view.makeToast(message, duration: 3.0, position: .top, style: style)
            }
        }).disposed(by: disposePag)
    }
    
  
    
    @objc func EditeCatagorie(){
        guard let addcertismentdata = self.AddvertismentData else {return}
        let AddaddvertismentViewController = coordinator.mainNavigator.viewController(for: .addAdvertisment(Addvertise: addcertismentdata, isFromClient: false))
        navigationController?.pushViewController(AddaddvertismentViewController, animated: true)
    }
    
    @objc func DeletedCatagorie(){
        
        DeleteViewContainer.isHidden = false
        
    }
    
    @IBAction func addToCartBtn(_ sender: Any) {
        
        
        
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String, let catId = BrandId else{
            showAlertTologein(massage: "يجب تسجيل الدخول  للاضافة في السلة")
            return
            
        }
        guard let notes =  notesTv.text , !notes.isEmpty else {
            self.showMassage(massage: "من فضلك ضيف بعض الملاحظات", colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
            return
        }
        guard let AddvertismentData = self.AddvertismentData else {return}
        
        loadingView.isHidden = false
        loadingView.startAnimating()
        addToCartBtn.isHidden = true
        
        let image = slides?.first
        print(image)
      
        let Price = (Int(AddvertismentData.cost ?? "0") ?? 0) * QuentityOfProdect
        print(Price)
        let params : [String : String] = [
            "userid" : userId,
            "order_name" : AddvertismentData.title ?? "",
            "order_price" : "\(Price)",
            "order_img" : image ?? "",
            "user_description" : notes,
            "count" : "\(QuentityOfProdect)",
            "advertise_id": catId,
            "shopid" : AddvertismentData.brandid ?? "",
            "shopname" : AddvertismentData.brandname ?? "",
        ]
        
        print(params)
        vieeModel.addToCart(parameters: params).subscribe(onNext: { [weak self ] (resultData) in
             guard let self = self else {return}
            self.loadingView.isHidden = true
            self.addToCartBtn.isHidden = false
            if var counterIncart = UserDefaults.standard.value(forKey: NetworkConstants.CounterInCart) as? Int {
                counterIncart += 1
                UserDefaults.standard.setValue(counterIncart, forKey: NetworkConstants.CounterInCart)
                UserDefaults.standard.synchronize()
            }else{
                UserDefaults.standard.setValue(1, forKey: NetworkConstants.CounterInCart)
                UserDefaults.standard.synchronize()
            }
            let message = resultData.response[0].message
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            DispatchQueue.main.async { [weak self ] in
                 guard let self = self else {return}
                self.view.makeToast(message, duration: 3.0, position: .top, style: style)
            }
        },onError: { [weak self ] (error) in
            guard let self = self else {return}
            self.loadingView.isHidden = true
            self.addToCartBtn.isHidden = false
            self.showMassage(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
        }).disposed(by: disposePag)
    }
    @IBAction func notConformDelete(_ sender: Any) {
        DeleteViewContainer.isHidden = true
    }
    @IBAction func conformDeleteBtn(_ sender: Any) {
        guard  let AddvertismentId = AddvertismentId else{return}
        vieeModel.DeleteAddvertisment(addvertiseId: AddvertismentId)
    }
    @objc func scrollToNextItem(){
        guard let slides = slides else {return}
        guard slides.count > 0 else { return }
        let nextSlide = currentSlide + 1
        currentSlide = nextSlide % slides.count
        slideToItem = currentSlide
        sliderCollectionView.scrollToItem(at: IndexPath(row: slideToItem, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
    
    @IBAction func moreThanAddvertise(_ sender: Any) {
        
        guard let brand = brand else {return}
        let brandDetailesVc  = coordinator.mainNavigator.viewController(for: .brandDetaiels(cataory: brand, catId: vieeModel.catId))
        navigationController?.pushViewController(brandDetailesVc, animated: true)
        
    }
   
    
    @IBAction func addRatebtn(_ sender: UIButton) {
        addreatingStack.isHidden = false
    }
    
    @IBAction func addLikeBtn(_ sender: UIButton) {
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String, let catId = BrandId else{
            showMassage(massage: "يجب تسجيل الدخول لتسجيل الاعجاب", colorStyle: #colorLiteral(red: 0.5058823529, green: 0.1254901961, blue: 0.1215686275, alpha: 1))
            return
            
        }
        isFavuiret.toggle()
        if isFavuiret{
            sender.setImage(#imageLiteral(resourceName: "when_like"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "when_unlike"), for: .normal)
        }
        
        let Paras : [String: String] = [
            "ad_id" : catId,
            "user_id" : userId
        ]
        
        vieeModel.addLikeAndUnlike(parameters: Paras).subscribe(onNext: { [weak self] (resultData) in
            guard let self = self else {return}
            let message = resultData.Response[0].message
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            DispatchQueue.main.async { [weak self ] in
                guard let self = self else {return}
                if self.isFavuiret{
                    self.numberofLike  += 1
                    self.ArrayOfDescriptionvalue.remove(at: 4)
                    self.ArrayOfDescriptionvalue.insert("\(self.numberofLike) اعجبهم المنتج", at: 4)
                    self.descriptionatbleView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
                }else{
                    self.numberofLike  -= 1
                    self.ArrayOfDescriptionvalue.remove(at: 4)
                    self.ArrayOfDescriptionvalue.insert("\(self.numberofLike) اعجبهم المنتج", at: 4)
                    self.descriptionatbleView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
                }
                self.view.makeToast(message, duration: 3.0, position: .top, style: style)
            }
        }).disposed(by: disposePag)
    }
    
    @IBAction func addRateingBtn(_ sender: UIButton) {
        let rating = Int(addratingView.rating)
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String, let catId = BrandId else{
            showMassage(massage: "يجب تسجيل الدخول لكي تستطيع اضافة تقيم", colorStyle: #colorLiteral(red: 0.5058823529, green: 0.1254901961, blue: 0.1215686275, alpha: 1))
            return
            
        }
        let Paras : [String: String] = [
            "brand_id" : catId,
            "user_id" : userId,
            "value" : "\(rating)"
        ]
        
        vieeModel.addRating(parameters: Paras)
        addratingBtn.setTitle(" \(rating) تقيمي", for: .normal)
        addreatingStack.isHidden = true
        
    }
}

extension CatagoriesDetaielsViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides?.count ?? 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SliderCell
        if  let stringUrl = slides?[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let url = URL(string: stringUrl){
                print(url)
                let placeHolder = #imageLiteral(resourceName: "applogo")
                let resurce = ImageResource(downloadURL: url)
                cell.sliderImage.kf.setImage(with: resurce,placeholder: placeHolder)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentSlide = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
        paginagtionController.currentPage = currentSlide
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let arrayOfImageInSlider = self.slides else {return}
        let fullSccren = coordinator.mainNavigator.viewController(for: .FullScreenImage(arratOfImage: arrayOfImageInSlider))
        navigationController?.pushViewController(fullSccren, animated: true)
    }
    
    
}
extension CatagoriesDetaielsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ArrayOfDescriptionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierOftable, for: indexPath) as! DescriptionTableViewCell
        cell.selectionStyle = .none
            cell.nameOfDescription.text = ArrayOfDescriptionData[indexPath.row]
            cell.valueOfDescription.text = ArrayOfDescriptionvalue[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}

