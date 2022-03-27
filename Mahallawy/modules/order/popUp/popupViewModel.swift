//
//  popupViewModel.swift
//  easyDriver
//
//  Created by jooo on 5/24/21.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import UIKit


enum popSelectedType  : String {
    case accept
    case reject
    case Refund
}
class popupViewModel {
    var bookingId : String
    var selectedType : popSelectedType
    init(selectedType : popSelectedType, bookingid: String) {
        self.selectedType = selectedType
        self.bookingId =  bookingid
    }
//    var signRepository = MainRepository()
//   let disposedBag = DisposeBag()
//    
//    func notAttendBooking(url : URL) -> Observable<bookingModel>{
//        return signRepository.notAttendBooking(Url: url)
//    }
//    
//    func finishBooking(url : URL) -> Observable<bookingModel>{
//        return signRepository.finishBooking(Url: url)
//    }
}
