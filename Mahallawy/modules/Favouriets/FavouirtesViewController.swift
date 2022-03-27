//
//  FavouirtesViewController.swift
//  Mahallawy
//
//  Created by youssef on 4/8/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import Kingfisher
import SideMenu

class FavouirtesViewController: BaseWireFrame<favouritesViewModel> {
    @IBOutlet weak var loadingiew: NVActivityIndicatorView!
    
    @IBOutlet weak var emptyLbl: UIView!
    @IBOutlet weak var FavoiretCollectionView: UICollectionView!
    let cellidentifier = "ExploreCellOfTableViewCell"
    
    private let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "المفضلة"
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           navigationController?.setNavigationBarHidden(false, animated: true)
       }
    
    override func bind(ViewModel: favouritesViewModel) {
        
        setupUI()
        guard let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {return}
        loadingiew.startAnimating()
        ViewModel.GetFavourite(parameters: ["user_id" : userId])
        ViewModel.barndDataObservable.subscribe { [weak self] (resulte) in
            if ((resulte.element?.isEmpty) != nil) {
                self?.emptyLbl.isHidden = false
                self?.loadingiew.stopAnimating()
            }
        }.disposed(by: disposePag)
      

        ViewModel.barndDataObservable.bind(to: FavoiretCollectionView.rx.items(cellIdentifier: cellidentifier, cellType: ExploreCellOfTableViewCell.self)) { [weak self] (row,item,cell) in
            
            guard let self = self else {return}
            self.emptyLbl.isHidden = true
            self.loadingiew.stopAnimating()
            cell.brandNameLbl.text = item.fullname
            cell.ratingView.rating = Double(item.currentrate ?? 0)
            cell.ratingView.text = "(\(item.currentrate ?? 0))"
            
            if let stringUrl = item.brandlogo {
                if let url = URL(string: stringUrl) {
                    let reefrence = ImageResource(downloadURL: url)
                    cell.imageOfBrand.kf.setImage(with: reefrence,placeholder: #imageLiteral(resourceName: "applogo"))
                }
            }
            
        }.disposed(by: bag)
        
        
     Observable.zip(self.FavoiretCollectionView.rx.itemSelected,self.FavoiretCollectionView.rx.modelSelected(Follower.self))
            .bind{ [weak self] indexPath, model in
                guard let self = self else {return}
                let brand = Brand(id: model.id, fullname: model.fullname, brandDescription: model.followerDescription, email: nil, phone: model.phone, address: model.address, brandlogo: model.brandlogo, longitude: model.longitude, latitude: model.latitude, worktime: model.worktime, categoryname: model.categoryname, pics: model.brandPics, nomOfRaters: model.nomOfRaters, myRate: nil, isFollow: model.isFollow, isRate: model.isRate, currentrate: Float(model.currentrate ?? 0))
                let brandDetailes = self.coordinator.mainNavigator.viewController(for: .brandDetaiels(cataory: brand, catId: "0"))
                self.navigationController?.pushViewController(brandDetailes, animated: true)
        }.disposed(by: self.bag)
        
    }
    
    func setupUI(){
        FavoiretCollectionView.rx.setDelegate(self).disposed(by: bag)
        FavoiretCollectionView.register(UINib(nibName: cellidentifier, bundle: nil), forCellWithReuseIdentifier: cellidentifier)
    }
    
    @IBAction func menueBtn(_ sender: Any) {
        let menu = SideMenuNavigationController(rootViewController: coordinator.mainNavigator.viewController(for: .menueView))
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = view.frame.width - 60
        menu.blurEffectStyle = .extraLight
        present(menu, animated: true, completion: nil)
    }
    
}
extension FavouirtesViewController: UICollectionViewDelegate ,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let padding: CGFloat = 10
        
        let availableWidth =  width - (padding * 2)
        let itemWidth = availableWidth / 2
        
        let size = CGSize(width: itemWidth, height: 250)
        return size
    }
    
    

}

