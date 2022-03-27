//
//  addAdvertismentViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import YPImagePicker
import NVActivityIndicatorView
import Toast_Swift
import RxCocoa
import RxSwift
import Kingfisher
class addAdvertismentViewController: BaseWireFrame<addAdvertismentViewModel> {
    @IBOutlet weak var addAdvertismentBtn: UIButton!
    
    @IBOutlet weak var addAdvertisment: TextField!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    
    @IBOutlet weak var priceTf: TextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var selectedImageCollectionView: UICollectionView!
    
    
    var picker : YPImagePicker?
    var arrayOfselectedImage = [UIImage]()
    var arrayOfselectedString = [String]()
    
    var isImageUpdataed = false
    var isUpdate = false
    var AddvertiseId : String?
      
    var pice : PublishSubject<String> = .init()
    let cellIdentifier = "ImageOfMarketCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bind(ViewModel: addAdvertismentViewModel) {
        title = "أضافة أعلان"
        setupUi()
        
        if let AddvertismentData = ViewModel.Addvertise{
            isUpdate = true
            title = "تعديل ألاعلان"
            AddvertiseId = AddvertismentData.id
            addAdvertismentBtn.setTitle("تحديث", for: .normal)
            if let pices = AddvertismentData.pics {
                let array = pices.components(separatedBy: "-")
                self.arrayOfselectedString = array
                self.arrayOfselectedString.removeAll(where: {$0 == ""})
            }
            
            descriptionTV.text = AddvertismentData.adDescription
            addAdvertisment.text = AddvertismentData.title
            priceTf.text = AddvertismentData.cost
            
            
        }
        
        pice.subscribe(onNext: { [weak self] (pics) in
            guard let self = self else {return}
            var picsToSend = pics
            if self.arrayOfselectedImage.count == 1{
                picsToSend += "--"
                self.addAddvertisMent(Pics: picsToSend)
            }else if self.arrayOfselectedImage.count == 2{
                picsToSend += "-"
                self.addAddvertisMent(Pics: picsToSend)
            } else if self.arrayOfselectedImage.count == 3{
                picsToSend += ""
                self.addAddvertisMent(Pics: picsToSend)
            }else{
                self.addAddvertisMent(Pics: picsToSend)
            }
            
            }, onError: { (error) in
                self.showMassage(massage: "خطا في اثناء رفع الصور", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
        }).disposed(by: disposePag)
        
        
    }
    
    func setupUi(){
        selectedImageCollectionView.delegate = self
        selectedImageCollectionView.dataSource = self
        selectedImageCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        /// Allow swipe to select images.
        var config = YPImagePickerConfiguration()
        // [Edit configuration here ...]
        
        config.library.maxNumberOfItems = 4
        // Build a picker with your configuration
        picker = YPImagePicker(configuration: config)
        
        picker?.didFinishPicking { [unowned picker , weak self] items, cancelled in
            guard let self = self else {return}
            self.arrayOfselectedImage.removeAll()
            self.isImageUpdataed = true
            if items.isEmpty {
                self.isImageUpdataed = false
            }
            for item in items {
                switch item {
                case .photo(let photo):
                    self.arrayOfselectedImage.append(photo.image)
                case .video( _):
                    self.showMassage(massage: "من فضلك اختار صور فقد اختيار الفديو غير متاح حاليا", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                }
            }
            self.selectedImageCollectionView.reloadData()
            picker?.dismiss(animated: true, completion: nil)
        }
       
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func addAddvertisMent (Pics: String){
        
        guard let price = priceTf.text, !price.isEmpty, let description = descriptionTV.text, !description.isEmpty, let addName = addAdvertisment.text, !addName.isEmpty, let userid = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String , let brandname = UserDefaults.standard.value(forKey: NetworkConstants.brandname) as? String  else {
            showMassageOfAddvertisment(massage: "من فضلك ادخل كل البيانات المطلوية", colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            return
            
        }
        loadingView.startAnimating()
        if isUpdate{
            guard let advId = AddvertiseId else {return}
            let paramerter : [String : String] = [
                "title" : addName,
                "description" : description,
                "pics" : Pics,
                "cost" : price,
                "adv_id" : advId
            ]
            vieeModel.updateAddvertisment(Paras: paramerter) { [weak self] (resulteData) in
                guard let self = self else {return}
                switch resulteData{
                case .success(let data):
                    if data.response[0].statues {
                        self.showMassageOfAddvertisment(massage: data.response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
                    }else{
                        self.showMassageOfAddvertisment(massage: data.response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
                    }
                    
                case .failure(let error):
                    self.showMassageOfAddvertisment(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
                }
            }
        }else {
            if vieeModel.isFromClient {
                let paramerters : [String : String] = [
                    "title" : addName,
                    "description" : description,
                    "pics" : Pics,
                    "cost" : price,
                    "brandname": brandname,
                    "userid" : userid
                    
                ]
                vieeModel.addAddvertismentForClient(Paras: paramerters) { [weak self] (resulteData) in
                    guard let self = self else {return}
                    switch resulteData{
                    case .success(let data):
                        if data.response[0].status {
                            let myAddvertisment = self.coordinator.mainNavigator.viewController(for: .MyAddvertisment)
                            self.loadingView.stopAnimating()
                            self.arrayOfselectedImage = []
                            self.descriptionTV.text = ""
                            self.priceTf.text = ""
                            self.addAdvertisment.text = ""
                            self.selectedImageCollectionView.reloadData()
                            self.navigationController?.pushViewController(myAddvertisment, animated: true)
                        }else{
                            self.showMassageOfAddvertisment(massage: data.response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
                        }
                        
                    case .failure(let error):
                        self.showMassageOfAddvertisment(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
                    }
                }
            }else{
                guard let catname = UserDefaults.standard.value(forKey: NetworkConstants.catname) as? String,
                let catid = UserDefaults.standard.value(forKey: NetworkConstants.catid) as? String,
                let brandlogo = UserDefaults.standard.value(forKey: NetworkConstants.brandlogo) as? String,
                let brandname = UserDefaults.standard.value(forKey: NetworkConstants.brandname) as? String else {
                    showMassageOfAddvertisment(massage: "من فضلك ادخل كل البيانات المطلوية", colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
                    return
                    
                }
                
                let paramerters : [String : String] = [
                    "title" : addName,
                    "description" : description,
                    "pics" : Pics,
                    "cost" : price,
                    "brandid" : userid,
                    "catname" : catname,
                    "catid" : catid,
                    "brandname": brandname,
                    "brandlogo" : brandlogo
                    
                ]
                
                vieeModel.addAddvertisment(Paras: paramerters) { [weak self] (resulteData) in
                    guard let self = self else {return}
                    switch resulteData{
                    case .success(let data):
                        if data.response[0].status {
                            let myAddvertisment = self.coordinator.mainNavigator.viewController(for: .MyAddvertisment)
                            self.loadingView.stopAnimating()
                            self.arrayOfselectedImage = []
                            self.descriptionTV.text = ""
                            self.priceTf.text = ""
                            self.addAdvertisment.text = ""
                            self.selectedImageCollectionView.reloadData()
                            self.navigationController?.pushViewController(myAddvertisment, animated: true)
                        }else{
                            self.showMassageOfAddvertisment(massage: data.response[0].message, colorStyle: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
                        }
                        
                    case .failure(let error):
                        self.showMassageOfAddvertisment(massage: error.localizedDescription, colorStyle: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
                    }
                }
            }
            
        }
        
       
    }
    
    func showMassageOfAddvertisment(massage : String, colorStyle : UIColor){
        addAdvertismentBtn.isEnabled = true
        loadingView.isHidden = true
        loadingView.stopAnimating()
        descriptionTV.text = ""
        priceTf.text = ""
        addAdvertisment.text = ""
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.showMassage(massage: massage, colorStyle: colorStyle)
        }
    }
    
    @IBAction func addAdvertismentBtn(_ sender: UIButton) {
        
        guard let price = priceTf.text, !price.isEmpty, let description = descriptionTV.text, !description.isEmpty, let addName = addAdvertisment.text, !addName.isEmpty else {
            showMassageOfAddvertisment(massage: "من فضلك ادخل كل البيانات المطلوية", colorStyle: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
            return
        }
        
        addAdvertismentBtn.isEnabled = false
        if isUpdate{
            if isImageUpdataed{
                if arrayOfselectedImage.isEmpty{
                    addAdvertismentBtn.isEnabled = true
                    showMassage(massage: "من فاضلك احتار صوره علي الاقل للمنتج", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
                }else{
                    loadingView.startAnimating()
                    loadingView.isHidden = false
                    uploadImagesOfProdect()
                }
            }else{
                var picsToSend = arrayOfselectedString.joined(separator: "-")
                if self.arrayOfselectedString.count == 1{
                    picsToSend += "--"
                    self.addAddvertisMent(Pics: picsToSend)
                }else if self.arrayOfselectedString.count == 2{
                    picsToSend += "-"
                    self.addAddvertisMent(Pics: picsToSend)
                } else if self.arrayOfselectedString.count == 3{
                    picsToSend += ""
                    self.addAddvertisMent(Pics: picsToSend)
                }else{
                    self.addAddvertisMent(Pics: picsToSend)
                }
                print(picsToSend)
            }
            
        }else {
            if arrayOfselectedImage.isEmpty{
                addAdvertismentBtn.isEnabled = true
                showMassage(massage: "من فاضلك اختار صوره علي الاقل للمنتج", colorStyle: #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1))
            }else{
                loadingView.startAnimating()
                loadingView.isHidden = false
                uploadImagesOfProdect()
            }
        }
        
        
    }
    
    func uploadImagesOfProdect(){
        let group = DispatchGroup()
        var imagesSteing = ""
        for(_,image) in arrayOfselectedImage.enumerated(){
            group.enter()
            vieeModel.uplaodImages(images: image).subscribe(onNext: { (resulteImageUpdata) in
               
                guard let imageurl = resulteImageUpdata.data?[0].imageurl else {return}
                imagesSteing += "\(imageurl)-"
                group.leave()
            }, onError: { (error) in
                self.pice.onError(error)
                return
            }).disposed(by: disposePag)
            
        }
        group.notify(queue: .main) {  [weak self] in
            guard let self = self else {return}
            self.pice.onNext(imagesSteing)
        }
        
    }
    
}



extension addAdvertismentViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfselectedImage.isEmpty , arrayOfselectedString.isEmpty{
            return 4
        }else{
            return isImageUpdataed ? arrayOfselectedImage.count : arrayOfselectedString.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageOfMarketCollectionViewCell
        if isImageUpdataed {
            if arrayOfselectedImage.isEmpty {
                return cell
            }else{
                let image =  arrayOfselectedImage[indexPath.row]
                cell.imageOfMarket.image = image
                return cell
            }
        }else{
            if arrayOfselectedString.isEmpty {
                return cell
            }else{
                let image =  arrayOfselectedString[indexPath.row]
                if let url = URL(string: image) {
                    let resource = ImageResource(downloadURL: url)
                    cell.imageOfMarket.kf.setImage(with: resource)
                }
                return cell
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let padding: CGFloat = 10
        
        let availableWidth =  width - (padding * 2)
        let itemWidth = availableWidth / 2
        
        let size = CGSize(width: itemWidth, height: itemWidth - 20)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isImageUpdataed = true
        guard let picker = picker else {return}
         self.present(picker, animated: true, completion: nil)
    }
    
}
