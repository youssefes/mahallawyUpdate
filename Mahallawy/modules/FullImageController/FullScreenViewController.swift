//
//  FullScreenViewController.swift
//  SLS
//
//  Created by youssef on 2/9/21.
//  Copyright © 2021 HadyOrg. All rights reserved.
//

import UIKit

class FullScreenViewController: BaseWireFrame<FullScreenViewModel> {
    //    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var stack: PageControl!
    private var sliderTimer: Timer?
    private var currentSlide = 0
    
    
    var ArrayOfImage : [String] = []
    @IBOutlet weak var imagesCollectioView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetSliderImage()
        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: FullScreenViewModel) {
        ViewModel.arrayOfImage.asObservable().subscribe(onNext: {[weak self] (arrayOfImage) in
            guard let self = self else {return}
            self.ArrayOfImage = arrayOfImage
            }).disposed(by: disposePag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func SetSliderImage(){
        imagesCollectioView.delegate = self
        imagesCollectioView.dataSource = self
        imagesCollectioView.register(UINib(nibName: "FullImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FullImageCollectionViewCell")
        sliderTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        stack.numberOfPages = ArrayOfImage.count
        stack.spacing = 3
        
    }
    
    @objc func scrollToNextItem(){
        guard ArrayOfImage.count > 0 else { return }
        let nextSlide = currentSlide + 1
        currentSlide = nextSlide % ArrayOfImage.count
        self.imagesCollectioView.scrollToItem(at: IndexPath(row: currentSlide, section: 0), at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension FullScreenViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ArrayOfImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullImageCollectionViewCell", for: indexPath) as! FullImageCollectionViewCell
        if ArrayOfImage.count > 0 {
            if let urlString = ArrayOfImage[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                if let url = URL(string: urlString){
                    cell.fullPhote.kf.setImage(with: url)
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentSlide = Int(scrollView.contentOffset.x / imagesCollectioView.frame.size.width)
        stack.currentPage = currentSlide
    }
    
}


/**
 If adding via storyboard, you should not need to set a width and height constraint for this view,
 just set a placeholder for each so autolayout doesnt complain and this view will size itself once its populated with pages at runtime
 */
class PageControl: UIStackView {
    
    @IBInspectable var currentPageImage: UIImage = #imageLiteral(resourceName: "Line 70")
    @IBInspectable var pageImage: UIImage = #imageLiteral(resourceName: "Line 71")
    /**
     Sets how many page indicators will show
     */
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    /**
     Sets which page indicator will be highlighted with the **currentPageImage**
     */
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        
        layoutIndicators()
    }
    
    private func layoutIndicators() {
        
        for i in 0..<numberOfPages {
            
            let imageView: UIImageView
            
            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView // reuse subview if possible
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }
            
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
        
        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }
    
    private func setCurrentPageIndicator() {
        
        for i in 0..<arrangedSubviews.count {
            
            let imageView = arrangedSubviews[i] as! UIImageView
            
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}


