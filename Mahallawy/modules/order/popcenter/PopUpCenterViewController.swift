//
//  PopUpCenterViewController.swift
//  easyDriver
//
//  Created by jooo on 5/26/21.
//

import UIKit

class PopUpCenterViewController: BaseWireFrame<PopUpCenterViewModel> {

    @IBOutlet weak var IconOfPop: UIImageView!
    @IBOutlet weak var textLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissbtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    override func bind(ViewModel: PopUpCenterViewModel) {
        switch ViewModel.selectedType {
        case .accept:
            print("acccept")
        case .reject:
            textLbl.text = "Your order has been closed"
            IconOfPop.image = #imageLiteral(resourceName: "applogo")
        case .Refund:
            textLbl.text = "Your order has been closed, and you  will be refunded after review"
            IconOfPop.image = #imageLiteral(resourceName: "applogo")
           
        }
    }
}
