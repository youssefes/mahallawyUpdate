//
//  SearchDelivertyViewModel.swift
//  Mahallawy
//
//  Created by jooo on 10/9/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class SearchDelivertyViewModel {
    
    let signRepository = SignRepository()
    let disposedBag = DisposeBag()
    var orderId : String?
    var OrderTaiarDate : [String : String]?
    var image : UIImage?
    init(orderId : String? , OrderTaiarDate : [String : String]?, image : UIImage?) {
        self.orderId = orderId
        self.OrderTaiarDate = OrderTaiarDate
        self.image  = image
    }
    
    func SerachDelivery(parameters: [String : String]) -> Observable<SearchModel>{
        Observable<SearchModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.searchOfDelivery(parameters: parameters) { (resuletData) in
                switch resuletData {
                case .success(let data):
                    items.onNext(data)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func checkDeliveryOrderStatus(parameters: [String : String]) -> Observable<CheckStatusOfOrderDelivery>{
        Observable<CheckStatusOfOrderDelivery>.create { [weak self] (items) -> Disposable in
            self?.signRepository.checkDeliveryOrderStatus(parameters: parameters) { (resuletData) in
                switch resuletData {
                case .success(let data):
                    items.onNext(data)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    func searchOfDeliveryWithoutOrder(parameters: [String : String]) -> Observable<SearchModel>{
        Observable<SearchModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.searchOfDeliveryWithoutOrder(parameters: parameters) { (resuletData) in
                switch resuletData {
                case .success(let data):
                    items.onNext(data)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
