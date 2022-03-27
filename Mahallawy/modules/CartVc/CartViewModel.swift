//
//  CartViewModel.swift
//  Mahallawy
//
//  Created by jooo on 7/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class CartViewModel {
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    var isEmptyCart : BehaviorRelay<Bool> = .init(value: false)
    var arrayOfCart : PublishSubject<[Cart]> = .init()
    var arrayOfProdect : [Product]?
    init(prodects : [Product]?) {
        self.arrayOfProdect = prodects
       
    }
    func GetCart (parameters : [String: String]) -> Observable<[Cart]>{
        Observable<[Cart]>.create { [weak self] (items) -> Disposable in
            self?.signRepository.GetCart(parameters: parameters) { (resuletData) in
                switch resuletData {
                case .success(let data):
                    guard let carts = data.carts else {return}
                    self?.arrayOfCart.onNext(carts)
                    if carts.isEmpty {
                        self?.isEmptyCart.accept(true)
                    }
                    items.onNext(carts)
                    items.onCompleted()
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    func GetProdect(Prodect :[Product]) -> Observable<[Product]>{
        Observable<[Product]>.create { (items) -> Disposable in
            items.onNext(Prodect)
            items.onCompleted()
            return Disposables.create()
        }
    }

    func deletedItemFromCart (parameters : [String: String]) -> Observable<ForgetPasswordMainModel>{
        Observable<ForgetPasswordMainModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.DeletedFromCart(parameters: parameters) { (resuletData) in
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
