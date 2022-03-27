//
//  OrdersViewModel.swift
//  easyDriver
//
//  Created by jooo on 5/19/21.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import UIKit


enum Orderstatus  : String{
    case new = "waiting"
    case active = "accepted" 
    case finished = "delivered"
    case admin_cancel = "admin_cancel"
    case client_cancel = "client_cancel"
    case shop_cancel = "shop_cancel"
}
class OrdersViewModel {
    var signRepository = SignRepository()
   let disposedBag = DisposeBag()
    
    func Myorder(parameters: [String : String]) -> Observable<myOrderModel>{
        Observable<myOrderModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.getMyBooking(parameters: parameters) { (resuletData) in
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
//    
//    func notAttendBooking(url : URL) -> Observable<Order>{
//        return signRepository.notAttendBooking(Url: url)
//    }
//    
//    func finishBooking(url : URL) -> Observable<Order>{
//        return signRepository.finishBooking(Url: url)
//    }

