//
//  JobDetailesViewModel.swift
//  Mahallawy
//
//  Created by jooo on 3/25/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class JobDetailesViewModel {
    
   
    var job : Job?
    init(job : Job?) {
        self.job  = job
    }
    
    var signRepository = SignRepository()
    let disposedBag = DisposeBag()
    
    func addJops(Paras : [String : String],completion: @escaping ((Result< AddToCartModel , Error>) -> Void)){
        signRepository.AddJobs(parameters: Paras) { (resuetOfAdd) in
            completion(resuetOfAdd)
        }
    }
    
    func addView(){
        var para : [String : String] = [:]
        if let userId = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String{
            para =  [
                "user_id" : userId,
                "job_id" : "\(job?.id ?? "0")"
            ]
        } else {
            guard let id =  UIDevice.current.identifierForVendor?.uuidString else {return}
            para =  [
                "user_id" : id,
                "job_id" : "\(job?.id ?? "0")"
            ]
        }
        
        signRepository.AddJobView(parameters: para) { (resuetOfAdd) in
           print(resuetOfAdd)
        }
    }
    
    
}
