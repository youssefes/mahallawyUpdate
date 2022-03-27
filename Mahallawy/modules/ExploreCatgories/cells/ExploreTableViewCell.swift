//
//  ExploreTableViewCell.swift
//  Mahallawy
//
//  Created by youssef on 3/28/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

protocol ExploreTableViewCellProtpcal {
    func selectedItem (With model : Brand)
}

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var catagoreiesName: UILabel!
    
    var delegate : ExploreTableViewCellProtpcal?
    
    @IBOutlet weak var collectionViewBrand: UICollectionView!
    private let bag = DisposeBag()
    var barndData : PublishSubject<[Brand]> = .init()
    let cellidentifier = "ExploreCellOfTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        collectionViewBrand.rx.setDelegate(self).disposed(by: bag)
        collectionViewBrand.register(UINib(nibName: cellidentifier, bundle: nil), forCellWithReuseIdentifier: cellidentifier)
        
        barndData.asObservable().bind(to: collectionViewBrand.rx.items(cellIdentifier: cellidentifier, cellType: ExploreCellOfTableViewCell.self)) { (row,item,cell) in
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

    Observable.zip(collectionViewBrand.rx.itemSelected,collectionViewBrand.rx.modelSelected(Brand.self))
            .bind{ indexPath, model in
                self.delegate?.selectedItem(With: model)
        }.disposed(by: bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension ExploreTableViewCell  : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let padding: CGFloat = 10
        
        let availableWidth =  width - (padding * 2) - 20
        let itemWidth = availableWidth / 2
        
        let size = CGSize(width: itemWidth, height: collectionView.frame.height)
        return size
    }
    
}
