//
//  JobsViewModel.swift
//  Mahallawy
//
//  Created by jooo on 3/25/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import Foundation
import  RxSwift
import RxCocoa

class JobsViewModel {
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    private var SeccessgetJobs : PublishSubject<[Job]> = .init()
    lazy var  SeccessgetJobsObservable : Observable<[Job]> = SeccessgetJobs.asObservable()
    
    func GetJobs()  {
        
        var para : [String : String] = [:]
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String{
            para =  [
                "user_id" : userId
            ]
        } else {
            guard let id =  UIDevice.current.identifierForVendor?.uuidString else {return}
            para =  [
                "user_id" : id
            ]
        }
        signRepository.GetJobs(parameters: para) { [weak self](resultJobs) in
            guard let self = self else {return}
            switch resultJobs {
            case .success(let data):
                print(resultJobs)
                guard  let categoriesE = data.jobs else {return}
                self.SeccessgetJobs.onNext(categoriesE)
            case .failure(let error):
                self.SeccessgetJobs.onError(error)
                print(error.localizedDescription)
            }
        }
        
    }
}
