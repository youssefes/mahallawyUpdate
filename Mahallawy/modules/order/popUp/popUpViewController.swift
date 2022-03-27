//
//  popUpViewController.swift
//  easyDriver
//
//  Created by jooo on 5/24/21.
//

import UIKit
import RxCocoa
import RxSwift
class popUpViewController: BaseWireFrame<popupViewModel> {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var PopBtn: UIButton!
    
    var isSeccessAcceptOrRject : BehaviorRelay<Bool> = .init(value: false)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: popupViewModel) {
        
        switch ViewModel.selectedType {
        case .accept:
            print("acccept")
        case .reject:
            descriptionLbl.text = "Do you sure you want to close this order because your trainer not attend?"
            iconImage.image = #imageLiteral(resourceName: "Group 5541")
            PopBtn.setTitle("Reject", for: .normal)
            PopBtn.borderColor = #colorLiteral(red: 0.8901960784, green: 0.03529411765, blue: 0.03529411765, alpha: 1)
            PopBtn.borderWidth = 1
            PopBtn.setTitleColor(#colorLiteral(red: 0.8901960784, green: 0.03529411765, blue: 0.03529411765, alpha: 1), for: .normal)
            PopBtn.backgroundColor = .white
        case .Refund:
            descriptionLbl.text = "Do you sure you want to reject  this service finishing?"
            iconImage.image = #imageLiteral(resourceName: "Page-1")
            PopBtn.setTitle("Close & Refund", for: .normal)
            PopBtn.borderColor = #colorLiteral(red: 1, green: 0.5960784314, blue: 0.003921568627, alpha: 1)
            PopBtn.borderWidth = 1
            PopBtn.setTitleColor(#colorLiteral(red: 1, green: 0.5960784314, blue: 0.003921568627, alpha: 1), for: .normal)
            PopBtn.backgroundColor = .white
        }
        
        
    }
    @IBAction func canselBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func acceptOrRigictBtn(_ sender: Any) {
       
        switch vieeModel.selectedType {
        case .accept:
//            guard let token = UserDefaults.standard.value(forKey: NetworkConstants.token) as? String else{
//                return
//            }
            guard let url = URL(string: "https://pomac.info/easydrive/public/api/users/bookings/finish?token=&booking_id=\(vieeModel.bookingId)&status_id=5") else {return}
//            vieeModel.finishBooking(url: url).subscribe(onNext: {[weak self] (resulte) in
//                guard let self = self else {return}
//                self.dismiss(animated: true, completion: nil)
//                self.isSeccessAcceptOrRject.accept(true)
//
//            }, onError: { [weak self] (error) in
//                guard let self = self else {return}
//                self.dismiss(animated: true, completion: nil)
//                self.isSeccessAcceptOrRject.accept(true)
//            }).disposed(by: disposePag)
        case .reject:
//            guard let token = UserDefaults.standard.value(forKey: NetworkConstants.token) as? String else{
//                return
//            }
            guard let url = URL(string: "https://pomac.info/easydrive/public/api/users/bookings/finish?token=&booking_id=\(vieeModel.bookingId)&status_id=5") else {return}
//            vieeModel.finishBooking(url: url).subscribe(onNext: { (resulte) in
//                print(resulte)
//            }, onError: { (error) in
//                print(error)
//            }).disposed(by: disposePag)
        case .Refund:
            print("Refund")
        }
        print(vieeModel.selectedType.rawValue)
    }
}
