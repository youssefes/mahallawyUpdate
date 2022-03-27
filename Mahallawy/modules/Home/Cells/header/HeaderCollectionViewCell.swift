//
//  HeaderCollectionViewCell.swift
//  Mahallawy
//
//  Created by youssef on 3/20/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import UIKit
import Kingfisher
import MarqueeLabel

protocol HeaderCollectionViewProtocal {
    func openAdvertiesMent()
}

class HeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderLbl: MarqueeLabel!
    @IBOutlet weak var paginagtionController: UIPageControl!
    var slides: [PurchasedAd]? {
        didSet{
            guard let slider = slides else {return}
            paginagtionController.numberOfPages = slider.count
            sliderCollectionView.reloadData()
        }
    }
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    private var currentSlide = 0
    private var sliderTimer: Timer?
    private var slideToItem = 0
    let cellIdentifier  = "SliderCell"
    
    var deleget : HeaderCollectionViewProtocal?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI(){
        
        sliderTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier.self)
        sliderLbl.speed = .rate(50)
        
    }
    
    @objc func scrollToNextItem(){
        guard let slides = slides else {return}
        guard slides.count > 0 else { return }
        let nextSlide = currentSlide + 1
        currentSlide = nextSlide % slides.count
        slideToItem = currentSlide
       sliderCollectionView.scrollToItem(at: IndexPath(row: slideToItem, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
    }

    @IBAction func openAddvertismemt(_ sender: Any) {
        deleget?.openAdvertiesMent()
    }
}

extension HeaderCollectionViewCell : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides?.count ?? 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SliderCell
        if  let stringUrl = slides?[indexPath.row].bannerurl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let url = URL(string: stringUrl){
               
                let resurce = ImageResource(downloadURL: url)
                cell.sliderImage.kf.setImage(with: resurce)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentSlide = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
        paginagtionController.currentPage = currentSlide
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let banerUrl =  slides?[indexPath.row].url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            
            if banerUrl.contains("https"){
                if let url = URL(string: banerUrl){
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }else{
                if let url = URL(string:"tel://\(banerUrl)"),UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url)
                }
            }
        }
       
        
    }
    
    
}

