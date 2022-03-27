//
//  loginViewModel.swift
//  Mahallawy
//
//  Created by youssef on 3/11/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class loginViewModel {
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
  
    func SignIn(parameters : [String : String])->  Observable<LoginModel> {
        Observable<LoginModel>.create { [weak self] (items) -> Disposable in
            self?.signRepository.LogIn(parameters: parameters) { (resulte) in
                switch resulte {
                case .success(let loginModel):
                    items.onNext(loginModel)
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
  
}
