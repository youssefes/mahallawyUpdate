//
//  TaierOrdersViewModel.swift
//  Mahallawy
//
//  Created by jooo on 10/21/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TaierOrdersViewModel {
    
    var signRepository = SignRepository()
   let disposedBag = DisposeBag()
    
    func UserOrOwnerDeliveryOrders(parameters: [String : String]) -> Observable<TaiarModel>{
        Observable<TaiarModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.UserOrOwnerDeliveryOrders(parameters: parameters) { (resuletData) in
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
    func TaiarOrders(parameters: [String : String]) -> Observable<TaiarModel>{
        Observable<TaiarModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.DeliveryOrders(parameters: parameters) { (resuletData) in
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
    
    
    func AcceptOrderByDelivery(parameters: [String : String]) -> Observable<ForgetPasswordModel>{
        Observable<ForgetPasswordModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.AcceptOrderByDelivery(parameters: parameters) { (resuletData) in
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
    
    func ChangeStatusOforder(order_id : String, user_id : String , statues : String, nesbet_tawsel : String? , delivery_id : String?) -> Observable<ForgetPasswordModel>{
        return signRepository.ChangeOrderStatus(order_id: order_id, user_id: user_id, statues: statues, nesbet_tawsel : nesbet_tawsel , delivery_id : delivery_id)
    }
}
