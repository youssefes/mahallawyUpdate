//
//  HomeViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/20/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import SideMenu
import NVActivityIndicatorView
class HomeViewController: BaseWireFrame<HomeViewModel> {
    @IBOutlet weak var containerOfCollection: UIStackView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var containerOfDeliveryStack: UIStackView!
    @IBOutlet weak var containerOfDeliveryStatus: UIView!
    
    @IBOutlet weak var imageOfScooter: UIImageView!
    @IBOutlet weak var notAcceptedLbl: UILabel!
    @IBOutlet weak var loadingOfStausDelivery: NVActivityIndicatorView!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var noInternetImage: UIImageView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    var label = UILabel(frame: CGRect(x: 10, y: -05, width: 18, height: 18))
    var isAvalable = false
    var catagories : [Category] = []
    var purchasedAds : [PurchasedAd] = []
    var promotedAds : [PromotedAd] = []
    let cellIdentifier = "HeaderCollectionViewCell"
    let catagorieCellIdentifier = "catagoriesCollectionViewViewCell"
    let FooterCollectionViewCell = "FooterCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        imageOfScooter.tintColor = .white
        if let counterIncart = UserDefaults.standard.value(forKey: NetworkConstants.CounterInCart) as? Int {
            label.text = "\(counterIncart)"
        }else{
            label.text = "\(0)"
        }
    }
    
    func setupUI(){
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = label.font.withSize(9)
        label.backgroundColor = .red
        let customBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        customBtn.setBackgroundImage(#imageLiteral(resourceName: "Buy"), for: .normal)
        customBtn.addTarget(self, action: #selector(OpenCart), for: .touchUpInside)
        
     
        customBtn.addSubview(label)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Component 7 – 1"), style: .plain, target: self, action: #selector(menuBtn))
        
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            if userType == "1" {
                containerOfDeliveryStack.isHidden = true
            }else if userType == "2"{
                containerOfDeliveryStack.isHidden = false
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customBtn)
            }
            else{
                containerOfDeliveryStack.isHidden = true
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customBtn)
            }
        }
    
        title = "الرئيسية"
           homeCollectionView.delegate = self
           homeCollectionView.dataSource = self
        
        homeCollectionView.register(UINib(nibName: FooterCollectionViewCell, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionViewCell)
        
        homeCollectionView.register(UINib(nibName: catagorieCellIdentifier, bundle: nil), forCellWithReuseIdentifier: catagorieCellIdentifier.self)
        
        homeCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellIdentifier)
       }
    

    override func bind(ViewModel: HomeViewModel) {
        loadingView.startAnimating()
        getCatagories()
//        homeCollectionView.isHidden = true
        if let deliveryAccaptedOrNot = UserDefaults.standard.value(forKey: NetworkConstants.deliveryAccaptedOrNot) as? String {
            if deliveryAccaptedOrNot == Orderstatus.active.rawValue {
                notAcceptedLbl.isHidden = true
            }else{
                checkAcceptedOrNot()
            }
        }else{
            guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {
                
                notAcceptedLbl.isHidden = true
                return
            }
            print(userId)
            guard let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String else {return}
            if userType == "2"{
                checkAcceptedOrNot()
            }else{
                notAcceptedLbl.isHidden = true
            }
          
        }
       
    }
    
    func checkAcceptedOrNot(){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
    
        let param : [String : String] = [
            "user_id" : userId
        ]
        vieeModel.CheckDeliveryStausAcceptOrNot(parameters: param).subscribe(onNext: { [weak self] (checkreulte) in
            guard let self = self else {return}
            if checkreulte.salaries?.first?.status == true{
                if checkreulte.salaries?.first?.activated_by_admin == Orderstatus.active.rawValue {
                        UserDefaults.standard.setValue(Orderstatus.active.rawValue, forKey: NetworkConstants.deliveryAccaptedOrNot)
                    self.notAcceptedLbl.isHidden = true
                }
            }else{
                self.notAcceptedLbl.isHidden = false
            }
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposePag)
    }
    
    func getCatagories(){
        vieeModel.getCatagories().subscribe(onNext: {[weak self] (catagories) in
            guard let self = self else {return}
            self.purchasedAds = catagories.purchasedAds
            self.catagories = catagories.categories
            self.promotedAds = catagories.promoted_ads
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.reloadBtn.isHidden = true
                self.noInternetImage.isHidden = true
                self.loadingView.stopAnimating()
                self.containerOfCollection.isHidden = false
                self.homeCollectionView.reloadData()
            }
            
            }, onError: { [weak self] (error) in
                guard let self = self else {return}
                print(error)
                self.loadingView.stopAnimating()
                let error = error as NSError
                if error.code == 13 {
                    self.reloadBtn.isHidden = false
                    self.noInternetImage.isHidden = false
                }
        }).disposed(by: disposePag)
    }
    @IBAction func reloadBtn(_ sender: Any) {
        loadingView.startAnimating()
        self.reloadBtn.isHidden = true
        self.noInternetImage.isHidden = true
        getCatagories()
    }
    @IBAction func chnageStatus(_ sender: UIButton) {
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        isAvalable.toggle()
        let avaliableOrNot = isAvalable ? "available" : "not_available"
        sender.setTitle(isAvalable ? "متوفر للعمل"  : "غير متوقر للعمل", for: .normal)
        let param : [String : String] = [
            "user_id" : userId,
            "statues" : avaliableOrNot
        ]
        sender.isHidden = true
        loadingOfStausDelivery.isHidden = false
        loadingOfStausDelivery.startAnimating()
        vieeModel.DeliveryAvaliableornot(parameters: param).subscribe(onNext: { [weak self] (resulte) in
            guard let self = self else {return}
            self.loadingOfStausDelivery.stopAnimating()
            self.loadingOfStausDelivery.isHidden = true
            sender.isHidden = false
            guard let date = resulte.updateStatues.first else {return}
            if date.statues {
                self.containerOfDeliveryStatus.backgroundColor = self.isAvalable ? #colorLiteral(red: 0.1294117719, green: 0.4774317817, blue: 0.06666667014, alpha: 1) : DesignSystem.Colors.MainColor.color
                self.showMassage(massage: date.message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
            }else{
                self.containerOfDeliveryStatus.backgroundColor = DesignSystem.Colors.MainColor.color
                self.showMassage(massage: date.message, colorStyle: DesignSystem.Colors.MainColor.color)
            }
        }, onError: { [weak self]  (error) in
            guard let self = self else {return}
            self.loadingOfStausDelivery.stopAnimating()
            self.loadingOfStausDelivery.isHidden = true
            sender.isHidden = false
            self.containerOfDeliveryStatus.backgroundColor = DesignSystem.Colors.MainColor.color
            self.showMassage(massage: error.localizedDescription, colorStyle: DesignSystem.Colors.MainColor.color)
        }).disposed(by: disposePag)
    }
    
    @objc func menuBtn(_ sender: UIButton) {
        // Define the menu
        
        let menu = SideMenuNavigationController(rootViewController: coordinator.mainNavigator.viewController(for: .menueView))
       
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = view.frame.width - 60
        menu.blurEffectStyle = .extraLight
        present(menu, animated: true, completion: nil)
          
    }
    
    @objc func OpenCart(_ sender: UIButton) {
        // Define the menu
        let Cart = coordinator.mainNavigator.viewController(for: .CartViewController(arrayOfProdect: nil))
        navigationController?.pushViewController(Cart, animated: true)
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate , HeaderCollectionViewProtocal , FooterCollectionViewCellProtocal{
    func openJobs() {
        let jobvc = coordinator.mainNavigator.viewController(for: .JobsVc)
        self.navigationController?.pushViewController(jobvc, animated: true)
    }
    
    func openAdvertisment() {
        print("open addvert")
        let subCatagoriesVc = coordinator.mainNavigator.viewController(for: .supCatagories(cataoryId: "1", catagoryName: "أعلانات محلاوي", isAdvertisment: false))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.navigationController?.pushViewController(subCatagoriesVc, animated: true)
        }
    }
    
    
    func openAdvertiesMent() {
        print("open advertisement")
        let catagoryId = ""
        let catagoryName = "أخر الاعلانات"
        let subCatagoriesVc = coordinator.mainNavigator.viewController(for: .supCatagories(cataoryId: catagoryId, catagoryName: catagoryName, isAdvertisment: true))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.navigationController?.pushViewController(subCatagoriesVc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catagories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellIdentifier, for: indexPath) as! HeaderCollectionViewCell
            header.slides = purchasedAds
            let AdvertesmentText = self.promotedAds.map({$0.text}).joined(separator: " - ")
            header.sliderLbl.text = AdvertesmentText
            header.sliderLbl.type = .continuousReverse
            header.deleget = self
            return header
            
        case UICollectionView.elementKindSectionFooter :
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionViewCell, for: indexPath) as! FooterCollectionViewCell
            footer.deleget = self
            footer.containerOfCell.isHidden = false
            
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: catagorieCellIdentifier, for: indexPath) as! catagoriesCollectionViewViewCell
        cell.CatagoriesName.text = catagories[indexPath.row].catname
        if  let stringUrl = catagories[indexPath.row].categoryPhoto.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let url = URL(string: stringUrl){
                let sourse = ImageResource(downloadURL: url)
                cell.iamgeCatagories.kf.setImage(with: sourse)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhon
            return CGSize(width: collectionView.frame.width, height: 250)
        case .pad:
            return CGSize(width: collectionView.frame.width, height: 300)
        // It's an iPad (or macOS Catalyst)

        @unknown default:
            return CGSize(width: collectionView.frame.width, height: 250)
        // Uh, oh! What could it be?
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let width = collectionView.bounds.width
           let padding: CGFloat = 20
           
           let availableWidth =  width - (padding * 2)
           let itemWidth = availableWidth / 3
           
           let size = CGSize(width: itemWidth, height: itemWidth)
           return size
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let catagoryId = catagories[indexPath.row].id
        let catagoryName = catagories[indexPath.row].catname
        let subCatagoriesVc = coordinator.mainNavigator.viewController(for: .supCatagories(cataoryId: catagoryId, catagoryName: catagoryName, isAdvertisment: false))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.navigationController?.pushViewController(subCatagoriesVc, animated: true)
        }
       
    }
}



