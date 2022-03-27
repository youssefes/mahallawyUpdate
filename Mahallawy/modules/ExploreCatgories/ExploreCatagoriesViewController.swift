//
//  ExploreCatagoriesViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/27/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import SideMenu
import NVActivityIndicatorView
import RxSwift
class ExploreCatagoriesViewController: BaseWireFrame<ExploreCatagoriesViewModel> {

    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var ExploretableView: UITableView!
    let cellIdentifierOfTable = "ExploreTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "أكتشف"
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func bind(ViewModel: ExploreCatagoriesViewModel) {
        loadingView.startAnimating()
      ExploretableView.rx.setDelegate(self).disposed(by: disposePag)
        ExploretableView.register(UINib(nibName: cellIdentifierOfTable, bundle: nil), forCellReuseIdentifier: cellIdentifierOfTable)
        
        ViewModel.SeccessgetCatagoriesObservable.bind(to: ExploretableView.rx.items(cellIdentifier: cellIdentifierOfTable, cellType: ExploreTableViewCell.self)){ [weak self] (row, item , cell) in
            guard let self = self ,let brands = item.brands else{return}
            self.loadingView.stopAnimating()
            cell.selectionStyle = .none
            cell.delegate = self
            cell.barndData.onNext(brands)
            cell.catagoreiesName.text = item.catName
        }
        .disposed(by: disposePag)
        
        ViewModel.ExploreCatagories()
        Observable.zip(ExploretableView.rx.itemSelected,ExploretableView.rx.modelSelected(CategoriesE.self))
            .bind{ indexPath, model in
                guard let brands = model.brands else {return}
                let SelectedExploreVc = self.coordinator.mainNavigator.viewController(for: .SelectedExplorVC(brands: brands, catId: model.catID ?? "0"))
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(SelectedExploreVc, animated: true)
                }
        }.disposed(by: disposePag)
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        // Define the menu
        let menu = SideMenuNavigationController(rootViewController: coordinator.mainNavigator.viewController(for: .menueView))
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = view.frame.width - 60
        menu.blurEffectStyle = .extraLight
        present(menu, animated: true, completion: nil)
    }
    


}

// MARK:- UITableViewDelegate
extension ExploreCatagoriesViewController : UITableViewDelegate , ExploreTableViewCellProtpcal {
    func selectedItem(With model: Brand) {
        let Selectedbrand = self.coordinator.mainNavigator.viewController(for: .brandDetaiels(cataory: model, catId: "0"))
       
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(Selectedbrand, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
    }

}
