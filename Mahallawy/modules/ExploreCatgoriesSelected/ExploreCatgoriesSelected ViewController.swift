//
//  ExploreCatgoriesSelected ViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class ExploreCatgoriesSelectedViewController: BaseWireFrame<ExploreCatgoriesSelectedViewModel> {
    @IBOutlet weak var selceedCollectionView: UICollectionView!
    
 
    let cellIdentifier = "ExploreCellOfTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func bind(ViewModel: ExploreCatgoriesSelectedViewModel) {
        let barndData : BehaviorSubject<[Brand]> = .init(value: [])
        let brandDataObservable : Observable<[Brand]> =  barndData.asObservable()
     
        selceedCollectionView.rx.setDelegate(self).disposed(by: disposePag)
        setupUI()
    
        ViewModel.getBrands { [weak self](brands) in
            guard let self = self else {return}
            barndData.onNext(brands)
            self.title = brands.first?.categoryname
        }
        
        brandDataObservable.bind(to: selceedCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ExploreCellOfTableViewCell.self)){ (row,  item ,cell) in
            cell.ratingView.rating = Double(item.currentrate ?? 0.0)
            cell.ratingView.text = "(\(item.currentrate ?? 0))"
            cell.brandNameLbl.text =  item.fullname
            if let stringUrl = item.brandlogo {
                if let url = URL(string: stringUrl) {
                    let reefrence = ImageResource(downloadURL: url)
                    cell.imageOfBrand.kf.setImage(with: reefrence,placeholder: #imageLiteral(resourceName: "applogo"))
                }
            }
        }.disposed(by: disposePag)
    Observable.zip(selceedCollectionView.rx.itemSelected,selceedCollectionView.rx.modelSelected(Brand.self))
            .bind{ indexPath, model in
                let brand = model 
                let SelectedExploreVc = self.coordinator.mainNavigator.viewController(for: .brandDetaiels(cataory: brand, catId: ViewModel.catId))
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(SelectedExploreVc, animated: true)
                }
              
                
        }.disposed(by: disposePag)
        
    }
    
    func setupUI(){
        selceedCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    @IBAction func dissmissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ExploreCatgoriesSelectedViewController  : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let padding: CGFloat = 10
        
        let availableWidth =  width - (padding * 2) - 20
        let itemWidth = availableWidth / 2
        
        let size = CGSize(width: itemWidth, height: 250)
        return size
    }
    
}

