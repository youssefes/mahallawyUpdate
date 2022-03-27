//
//  HowAreViewController.swift
//  Mahallawy
//
//  Created by youssef on 3/29/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import SideMenu
import FBSDKShareKit
class HowAreViewController: BaseWireFrame<HowAreViewModel> {

    let definition = "موقع وتطبيق محلاوي فكرة خدمية لاهل المحلة الكبري جمعنالك كل المحلات والصنايعية الى محتاجهم في مكان واحد يلا حمل التطبيق دلوقت  او زور موقعنا"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: true)
      }
    
    override func bind(ViewModel: HowAreViewModel) {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Component 7 – 1"), style: .plain, target: self, action: #selector(menuBtn))
        title = "من نحن"
    }
    
    @IBAction func menuBtn(_ sender: Any) {
           let menu = SideMenuNavigationController(rootViewController: coordinator.mainNavigator.viewController(for: .menueView))
           menu.presentationStyle = .menuSlideIn
           menu.menuWidth = view.frame.width - 60
           menu.blurEffectStyle = .extraLight
           present(menu, animated: true, completion: nil)
       }
    @IBAction func googrlBTN(_ sender: Any) {
        guard let url = URL(string: "https://mahalawy.com/") else {return}
        let UIActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(UIActivity, animated: true, completion: nil)
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        guard let url = URL(string: "https://mahalawy.com/") else {return}
        let UIActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(UIActivity, animated: true, completion: nil)
        
    }
    
    @IBAction func faceBackshareBtn(_ sender: Any) {
        let content = ShareLinkContent()
       
        guard let url = URL(string: "https://mahalawy.com/") else {return}
        content.contentURL = url
      
        let shareDialog = ShareDialog(fromViewController: self, content: content, delegate: nil)
        
        shareDialog.show()
    }
    
    @IBAction func twitterBtn(_ sender: Any) {
        guard let url = URL(string: "https://mahalawy.com/") else {return}
        let UIActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(UIActivity, animated: true, completion: nil)
    }
    
    @IBAction func instagremBtn(_ sender: Any) {
        guard let url = URL(string: "https://mahalawy.com/") else {return}
        let UIActivity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(UIActivity, animated: true, completion: nil)
    }
    
}
