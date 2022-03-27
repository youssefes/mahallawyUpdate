//
//  CatogoryViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class CatogoryViewController: BaseWireFrame<CatogoryViewModel> {

    @IBOutlet weak var addAddvertismentBtn: UIButton!
    @IBOutlet weak var modernBtn: UIButton!
    @IBOutlet weak var moreViewerBtn: UIButton!
    @IBOutlet weak var MoreLikeBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var subCatagoriesTableView: UITableView!
    let cellIdentifier = "subCatagoriesCellTableViewCell"
    var addsOfCatagories : [AdSubCatagories] = []
    var filterOfCatagories : [AdSubCatagories] = []
  
    var isSearch = false
  
//    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func setUpUi(){
        
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_search_white_24dp"), style: .plain, target: self, action: #selector(searchInCata))
        let filter =  UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(FilterData))

        navigationItem.rightBarButtonItems = [searchButton , filter]
        
        subCatagoriesTableView.delegate = self
        subCatagoriesTableView.dataSource = self
        subCatagoriesTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.self)
        
        if  let userType = UserDefaults.standard.value(forKey: NetworkConstants.userType) as? String {
            print(userType)
            if userType == "0"{
                addAddvertismentBtn.isHidden = false
            }
        }
    }
    
    override func bind(ViewModel: CatogoryViewModel) {
        loadingView.startAnimating()
        ViewModel.catagoryName.subscribe(onNext: { (title) in
            DispatchQueue.main.async {
                self.title = title
            }
        }).disposed(by: disposePag)
        setUpUi()
        
        if vieeModel.isAdvertisment {
            ViewModel.getLatestAdvertises{ [weak self] (resulte) in
                guard let self = self else {return}
                guard let resulteData = resulte else {return}
                self.addsOfCatagories = resulteData
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.subCatagoriesTableView.reloadData()
                    
                }
            }
        }else{
            ViewModel.getSubCatagories { [weak self] (resulte) in
                guard let self = self else {return}
                guard let resulteData = resulte else {return}
                self.addsOfCatagories = resulteData
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.subCatagoriesTableView.reloadData()
                    
                }
            }
        }
    
    }
    
    var showSearch = false
    
    @objc func FilterData() {
        filterView.isHidden.toggle()
    }
    
    @IBAction func OrderBtn(_ sender: UIButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.subCatagoriesTableView.reloadData()
            self.filterView.isHidden = true
        }

    }
    @IBAction func modernBtn(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1)
        moreViewerBtn.backgroundColor = .white
        MoreLikeBtn.backgroundColor = .white
        if isSearch{
            self.filterOfCatagories.sort { (AdSubCate1, AdSubCate12) -> Bool in
                AdSubCate1.createdAt > AdSubCate12.createdAt
            }
        }else{
            self.addsOfCatagories.sort { (AdSubCate1, AdSubCate12) -> Bool in
                AdSubCate1.createdAt > AdSubCate12.createdAt
            }
        }
        
    }
    @IBAction func moreLike(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.1254901961, blue: 0.1215686275, alpha: 1)
        moreViewerBtn.backgroundColor = .white
        modernBtn.backgroundColor = .white
        if isSearch{
            self.filterOfCatagories.sort { (AdSubCate1, AdSubCate12) -> Bool in
                AdSubCate1.likes > AdSubCate12.likes
            }
        }else{
            self.addsOfCatagories.sort { (AdSubCate1, AdSubCate12) -> Bool in
                AdSubCate1.likes > AdSubCate12.likes
            }
        }
        
        
    }
    @IBAction func moreViewerBtn(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.504394114, green: 0.1247402504, blue: 0.1224453226, alpha: 1)
        MoreLikeBtn.backgroundColor = .white
        modernBtn.backgroundColor = .white
        
        if isSearch{
            self.filterOfCatagories.sort { (AdSubCate1, AdSubCate12) -> Bool in
                AdSubCate1.viewers > AdSubCate12.viewers
            }
        }else{
            self.addsOfCatagories.sort { (AdSubCate1, AdSubCate12) -> Bool in
                AdSubCate1.viewers > AdSubCate12.viewers
            }
        }
        
    }
    @objc func searchInCata(){
        showSearch.toggle()
        let searchBar = UISearchBar()
        searchBar.compatibleSearchTextField.backgroundColor = .white
        searchBar.sizeToFit()
        searchBar.placeholder = "اسم المنتج او المحل"
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(12)
        navigationItem.titleView = searchBar
        if showSearch {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.topItem?.titleView = searchBar
            }
            
            searchBar.rx.text.skip(2).bind { (filterText) in
                guard let filterText = filterText , !filterText.isEmpty else {
                    self.isSearch = false
                    self.subCatagoriesTableView.reloadData()
                    return
                }
                self.filterOfCatagories = self.addsOfCatagories.filter({ $0.title!.lowercased().contains(filterText.lowercased())})
                
                DispatchQueue.main.async {
                    self.isSearch = true
                    self.subCatagoriesTableView.reloadData()
                }
            }.disposed(by: self.disposePag)
            
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.topItem?.titleView = nil
            }
            
        }
  
    }

    @IBAction func addAddvertisemetBtn(_ sender: Any) {
        guard  let userid = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {
            showAlertTologein(massage: "من فضلك سجل الدخول ")
            return
        }
        print(userid)
        let addAdvertisment = coordinator.mainNavigator.viewController(for: .addAdvertisment(Addvertise: nil, isFromClient: true))
        navigationController?.pushViewController(addAdvertisment, animated: true)
    }
}

extension CatogoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? filterOfCatagories.count : addsOfCatagories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! subCatagoriesCellTableViewCell
        cell.selectionStyle = .none
        let activeFollwer = isSearch ? filterOfCatagories : addsOfCatagories
        
        if let pices = activeFollwer[indexPath.row].pics {
            var array = pices.components(separatedBy: "-")
            array.removeAll(where: {$0 == ""})
            if let imageString = array.first?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let url = URL(string: imageString) {
                    let placeHolder = #imageLiteral(resourceName: "applogo")
                    let reefrence = ImageResource(downloadURL: url)
                    cell.imageOfSubCatagores.kf.setImage(with: reefrence, placeholder: placeHolder)
                }
            }
        }
        cell.pricseLbl.text = "\(activeFollwer[indexPath.row].cost ?? "") جنية "
        cell.pricseLbl.textAlignment = .left
        cell.nameOfSubCata.text = activeFollwer[indexPath.row].title
        cell.numberOfLikes.text = " \(activeFollwer[indexPath.row].likes) اعجاب "
        if  let rating = activeFollwer[indexPath.row].currentRate {
            cell.ratingView.text = "(\(rating))"
            cell.ratingView.rating = Double(rating)
        }
        cell.nameOfRating.text = activeFollwer[indexPath.row].brandname
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeFollwer = isSearch ? filterOfCatagories : addsOfCatagories
        let subcatagories = activeFollwer[indexPath.row]
        let catagoryDetailes = coordinator.mainNavigator.viewController(for: .CatagoriesDetaiels(catagorySub: subcatagories, isMyAddverisment: false, CatId: vieeModel.catagoryId))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.navigationController?.pushViewController(catagoryDetailes, animated: true)
        }
       
    }
    
}





