//
//  ConformOrderViewModel.swift
//  Elsade
//
//  Created by jooo on 5/12/21.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreLocation
class ConformOrderViewModel {
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    var CartData : [Cart]
    var nameOfAddress : String
    var AddressLocation : CLLocationCoordinate2D
    init(CartData : [Cart] , nameOfAddress : String , AddressLocation : CLLocationCoordinate2D) {
        self.CartData = CartData
        self.nameOfAddress = nameOfAddress
        self.AddressLocation = AddressLocation
    }
    
    func MakeOrder (parameters : [String: String]) -> Observable<AddToCartModel>{
        Observable<AddToCartModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.MakeOrder(parameters: parameters) { (resuletData) in
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
    
  
