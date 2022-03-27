//
//  forgetPassViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/16/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
class forgetPassViewModel{
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    func forgetPassword(parameters : [String : String]) -> Observable<ForgetPasswordMainModel> {
        Observable<ForgetPasswordMainModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.ForgetPass(parameters: parameters) { (resulte) in
                print(resulte)
                switch resulte{
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
