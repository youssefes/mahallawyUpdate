//
//  MyAddvertismentViewController.swift
//  Mahallawy
//
//  Created by youssef on 4/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import NVActivityIndicatorView

class MyAddvertismentViewController: BaseWireFrame<MyAddvertismentViewModel> {
    @IBOutlet weak var addvertismentCollectionView: UICollectionView!
    @IBOutlet weak var emptyLbl: UIView!
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    let cellIdentifierAddvertismetntCollectionView = "addvertismentCCollectionViewCell"
    var refreshCotroller = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        vieeModel.getMyAddvertisMent(parameters: ["userid" : userId])
    }
    
    func setepUi()  {
        title = "اعلاناتي"
        addvertismentCollectionView.rx.setDelegate(self).disposed(by: disposePag)
         addvertismentCollectionView.register(UINib(nibName: cellIdentifierAddvertismetntCollectionView, bundle: nil), forCellWithReuseIdentifier: cellIdentifierAddvertismetntCollectionView.self)
        addvertismentCollectionView.refreshControl = refreshCotroller
        refreshCotroller.tintColor = DesignSystem.Colors.MainColor.color
        refreshCotroller.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    @objc func refresh(){
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        vieeModel.getMyAddvertisMent(parameters: ["userid" : userId])
    }
    
    override func bind(ViewModel: MyAddvertismentViewModel) {
        setepUi()
        loadingView.startAnimating()
        ViewModel.SeccessGetBrandDverisment.asObservable().subscribe { [weak self] (resulte) in
            if ((resulte.element?.isEmpty) != nil) {
                self?.emptyLbl.isHidden = false
                self?.loadingView.stopAnimating()
                self?.refreshCotroller.endRefreshing()
            }else{
                let arrayOfUnActtive = resulte.element?.map({(($0.activated != nil) == false)})
                if !(arrayOfUnActtive?.isEmpty ?? true){
                    self?.showMassage(massage: "اعلاناتك في انتظار المرجعة", colorStyle: #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.6509803922, alpha: 0.9813784247))
                }
            }
        }.disposed(by: disposePag)
        ViewModel.SeccessGetBrandDverisment.bind(to: addvertismentCollectionView.rx.items(cellIdentifier: cellIdentifierAddvertismetntCollectionView, cellType: addvertismentCCollectionViewCell.self)){ [weak self] (row,  item ,cell) in
            print(item)
            cell.nameOfAddvertisement.text = item.title
            cell.numberOfLikes.text = "\(item.likes) اعجاب"
            cell.nameOfSubCata.text = item.adDescription
            cell.priceLbl.text = "\(item.cost ?? "0") جنية"
            cell.ratingView.isHidden = false
            cell.ratingView.rating = Double(item.nomOfRate ?? 0)
            cell.ratingView.backgroundColor = .clear
            self?.emptyLbl.isHidden = true
            cell.viewOfActiveOrNot.backgroundColor = (item.activated == "0") ? #colorLiteral(red: 0.9529411765, green: 0.4980392157, blue: 0.03137254902, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            if (item.activated == "0"){
                cell.priceLbl.textColor = .white
                cell.nameOfAddvertisement.textColor = .white
                cell.nameOfSubCata.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7452910959)
            }
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
        Observable.zip(addvertismentCollectionView.rx.itemSelected,addvertismentCollectionView.rx.modelSelected(AdSubCatagories.self))
            .bind{ [weak self] indexPath, model in
                guard let self = self else {return}
                let SelectedExploreVc = self.coordinator.mainNavigator.viewController(for: .CatagoriesDetaiels(catagorySub: model, isMyAddverisment: true, CatId: "0"))
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(SelectedExploreVc, animated: true)
                }
        }.disposed(by: disposePag)
    }
    
    
    
}

extension MyAddvertismentViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: 300)
     }
}
