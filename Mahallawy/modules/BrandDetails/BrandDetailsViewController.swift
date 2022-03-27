//
//  BrandDetailsViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/6/18.
//  Copyright © 2018 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos
import Toast_Swift
import RxSwift
import RxCocoa
import CoreLocation
class BrandDetailsViewController: BaseWireFrame<CatagoriesDetaielsViewModels> {
    
    @IBOutlet weak var containerOfRatingOfBrand: UIView!
    @IBOutlet weak var containerOfDetilesOfBrand: UIStackView!
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var addvertiseMentCollectionView: UICollectionView!
    
    @IBOutlet weak var heightOfCollectionRalted: NSLayoutConstraint!
    
    @IBOutlet weak var nameOfBrand: UILabel!
    
    @IBOutlet weak var addratingBtn: UIButton!
    @IBOutlet weak var addratingView: CosmosView!
    @IBOutlet weak var catagoriesLbl: UILabel!

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var addreatingStack: UIStackView!
    @IBOutlet weak var WorkTimeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addToFavouirtBtn: UIButton!
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var paginagtionController: UIPageControl!
    
    var lang : String?
    var late : String?
    var isFavuiret = false
    var slides: [String] = []{
        didSet{
            paginagtionController.numberOfPages = slides.count
            sliderCollectionView.reloadData()
        }
    }
    private var currentSlide = 0
    private var sliderTimer: Timer?
    private var slideToItem = 0
    
    private var phone : String?
    var subCatagoriesId : BehaviorRelay<String?> = .init(value: "")
    let cellIdentifier  = "SliderCell"
    let cellIdentifierAddvertismetntCollectionView = "addvertismentCCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addTofavourit(_ sender: UIButton) {
        
        isFavuiret.toggle()
        if isFavuiret{
            sender.setImage(#imageLiteral(resourceName: "added_to_fav"), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "add_to_fav"), for: .normal)
        }
        
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String, let catId = subCatagoriesId.value else{
            showMassage(massage: "يجب تسجيل الدخول لكي تستطيع الاضافة للمفضلة", colorStyle: #colorLiteral(red: 0.5058823529, green: 0.1254901961, blue: 0.1215686275, alpha: 1))
            return}
        let Paras : [String: String] = [
            "brandid" : catId,
            "user_id" : userId,
        ]
        
        vieeModel.addToFavourit(parameters: Paras)
    }
    @IBAction func findUs(_ sender: Any) {
        let lat = Double(late ?? "0")
        let lon = Double(lang ?? "0")
        openGoogleMap(lang: lon ?? 0, lat: lat ?? 0)
    }
    
    @IBAction func callUs(_ sender: Any) {
        guard let phone = phone , !phone.isEmpty else {return}
        if let url = URL(string:"tel://\(phone)"),UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: CatagoriesDetaielsViewModels) {
        setupUI()
        
      
        ViewModel.getBrands { (brand, subcatagroies,isMyAddvertisment)  in
            if brand != nil{
                print(brand)
                self.subCatagoriesId.accept(brand?.id)
                  self.title  = brand?.fullname
                self.phone = brand?.phone
                self.isFavuiret = brand?.isFollow ?? false
                self.addressLbl.text = brand?.address
                self.nameOfBrand.text = brand?.fullname
                self.ratingView.rating = Double(brand?.currentrate ?? 0)
                self.WorkTimeLbl.text = brand?.worktime
                self.catagoriesLbl.text = brand?.categoryname
                self.ratingView.text = "(\(brand?.nomOfRaters ?? 0))"
             
                self.late =  brand?.latitude
                self.lang = brand?.longitude
                if  let rating = brand?.currentrate {
                    self.ratingView.rating = Double(rating)
                }
                self.addToFavouirtBtn.setImage(brand?.isFollow ?? false ? #imageLiteral(resourceName: "added_to_fav") : #imageLiteral(resourceName: "add_to_fav")  , for: .normal)
                let myRate = brand?.myRate ?? 0
                if myRate != 0{
                    self.addratingBtn.setTitle("\(myRate) تقيمي", for: .normal)
                }
                
                if let urlstring =  brand?.brandlogo {
                    if let url = URL(string:urlstring) {
                        let resourse = ImageResource(downloadURL: url)
                        self.brandLogo.kf.setImage(with: resourse)
                    }
                }
                
              
                if let pices = brand?.pics {
                    let array = pices.components(separatedBy: "-")
                    var arrayOnNotEmpty : [String] = []
                    array.forEach { (imageString) in
                        if !imageString.isEmpty{
                            arrayOnNotEmpty.append(imageString)
                           
                        }
                        self.slides = arrayOnNotEmpty
                    }
                }
            }
            
            if self.vieeModel.catId == "1" {
                self.containerOfRatingOfBrand.isHidden = true
                self.containerOfDetilesOfBrand.isHidden = true
                self.nameOfBrand.text = ""
                self.nameOfBrand.isHidden = true
            
            }else{
                self.containerOfRatingOfBrand.isHidden = false
                self.containerOfDetilesOfBrand.isHidden = false
                self.nameOfBrand.isHidden = false
            }
        }
        ViewModel.SeccessRequestAddRatingObservable.subscribe(onNext: { [weak self] (resultData) in
            guard let self = self else {return}
            let message = resultData.response[0].message
            var style = ToastStyle()
            style.messageColor = .white
            style.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            DispatchQueue.main.async {
                self.view.makeToast(message, duration: 3.0, position: .top, style: style)
            }
        }).disposed(by: disposePag)
        
        
        ViewModel.SeccessRequestAddToFavObservable.subscribe(onNext: { [weak self] (resultData) in
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
    
        vieeModel.SeccessGetBrandDverismentObservable.subscribe(onNext: {[weak self] arrayofdata in
            guard let self = self else {return}
            if arrayofdata.isEmpty{
                self.addvertiseMentCollectionView.isHidden  = true
            }else{
                self.addvertiseMentCollectionView.isHidden  = false
            }
            
        }).disposed(by: disposePag)
        ViewModel.SeccessGetBrandDverismentObservable.bind(to: addvertiseMentCollectionView.rx.items(cellIdentifier: cellIdentifierAddvertismetntCollectionView, cellType: addvertismentCCollectionViewCell.self)){  (row,  item ,cell) in
            cell.nameOfAddvertisement.text = item.title
            cell.numberOfLikes.text = "\(item.likes) أعجاب"
            cell.nameOfSubCata.text = item.adDescription
            cell.priceLbl.text = "\(item.cost ?? "0") جنية"
            let pices = item.pics
            var array = pices?.components(separatedBy: "-")
            array?.removeAll(where: {$0 == ""})
            if let imageString = array?.first?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                print(imageString)
                if let url = URL(string: imageString) {
                    let placeHolder = #imageLiteral(resourceName: "applogo")
                    let reefrence = ImageResource(downloadURL: url)
                    cell.imageOfSubCatagores.kf.setImage(with: reefrence, placeholder: placeHolder)
                }
            }
        }.disposed(by: disposePag)
        
        Observable.zip(addvertiseMentCollectionView.rx.itemSelected,addvertiseMentCollectionView.rx.modelSelected(AdSubCatagories.self))
            .bind{ [weak self] indexPath, model in
                guard let self = self else {return}
                let SelectedExploreVc = self.coordinator.mainNavigator.viewController(for: .CatagoriesDetaiels(catagorySub: model, isMyAddverisment: false, CatId: ViewModel.catId))
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(SelectedExploreVc, animated: true)
                }
                
                
        }.disposed(by: disposePag)
        
    }
    
    func setupUI(){
        
        sliderTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier.self)
        
        addvertiseMentCollectionView.register(UINib(nibName: cellIdentifierAddvertismetntCollectionView, bundle: nil), forCellWithReuseIdentifier: cellIdentifierAddvertismetntCollectionView.self)
        
        addvertiseMentCollectionView.rx.setDelegate(self).disposed(by: disposePag)
        subCatagoriesId.subscribe(onNext: { [weak self]  (brandId) in
            
            guard let self = self else {return}
            guard let brandId = brandId , !brandId.isEmpty else {return}
            if let id = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String {
                self.vieeModel.getBrandAddvertisment(parameters: ["brandid" : brandId, "userid" : id])
            }else {
                guard let id =  UIDevice.current.identifierForVendor?.uuidString else {return}
                self.vieeModel.getBrandAddvertisment(parameters: ["brandid" : brandId, "userid" : id])
            }
           
        }).disposed(by: disposePag)
    }
    
    @objc func scrollToNextItem(){
        guard slides.count > 0 else { return }
        let nextSlide = currentSlide + 1
        currentSlide = nextSlide % slides.count
        slideToItem = currentSlide
        sliderCollectionView.scrollToItem(at: IndexPath(row: slideToItem, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
    
    
    @IBAction func addRatebtn(_ sender: UIButton) {
           addreatingStack.isHidden = false
       }
    
    @IBAction func addRateingBtn(_ sender: UIButton) {
        let rating = Int(addratingView.rating)
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String, let catId = subCatagoriesId.value else{
            showMassage(massage: "يجب تسجيل الدخول لكي تستطيع اضافة تقيم", colorStyle: #colorLiteral(red: 0.5058823529, green: 0.1254901961, blue: 0.1215686275, alpha: 1))
            return}
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

extension BrandDetailsViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SliderCell
        if  let stringUrl = slides[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let url = URL(string: stringUrl){
               
                let resurce = ImageResource(downloadURL: url)
                let imagePlaceHolder = #imageLiteral(resourceName: "applogo")
                cell.sliderImage.kf.setImage(with: resurce, placeholder: imagePlaceHolder)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == addvertiseMentCollectionView {
            
            return CGSize(width: collectionView.frame.width - 30, height: collectionView.frame.height + 80 )
        }else{
          return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentSlide = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
        paginagtionController.currentPage = currentSlide
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == addvertiseMentCollectionView {
            
        }else{
            guard !slides.isEmpty else {return}
            let fullSccren = coordinator.mainNavigator.viewController(for: .FullScreenImage(arratOfImage: slides))
            navigationController?.pushViewController(fullSccren, animated: true)
        }
       
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
    
    
}
