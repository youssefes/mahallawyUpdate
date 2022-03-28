//
//  JobsVc.swift
//  Mahallawy
//
//  Created by jooo on 3/25/22.
//  Copyright © 2022 youssef. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GoogleUtilities
import Kingfisher
import NVActivityIndicatorView
class JobsVc: BaseWireFrame<JobsViewModel> {

    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var jobsTableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let cellIdentifier = "JobTableViewCell"
    var arrayOfJobs : [Job] = []{
        didSet{
            jobsTableView.reloadData()
        }
    }
    var filterOfJobs : [Job] = []{
        didSet{
            jobsTableView.reloadData()
        }
    }
  
    var isSearch = false
    var showSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind(ViewModel: JobsViewModel) {
        setUpUi()
        title = "وظائف محلاوي"
    }
    
    func setUpUi(){
        bannerView.adUnitID = NetworkConstants.GoogelAdId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        jobsTableView.tableFooterView = UIView()
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_search_white_24dp"), style: .plain, target: self, action: #selector(searchInCata))

        navigationItem.rightBarButtonItems = [searchButton]

        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        jobsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier.self)
    
        vieeModel.SeccessgetJobsObservable.subscribe(onNext: { [weak self] (jobsResulte) in
            guard let self = self else {return}
            self.loadingView.stopAnimating()
            self.arrayOfJobs = jobsResulte
        },onError: { [weak self ] (error) in
            guard let self = self else {return}
            self.loadingView.stopAnimating()
        }).disposed(by: disposePag)
        loadingView.startAnimating()
        vieeModel.GetJobs()
    }
    
    @objc func searchInCata(){
        showSearch.toggle()
        let searchBar = UISearchBar()
        searchBar.compatibleSearchTextField.backgroundColor = .white
        searchBar.sizeToFit()
        searchBar.placeholder = "اسم الوظيفة"
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(12)
        navigationItem.titleView = searchBar
        if showSearch {
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.topItem?.titleView = searchBar
            }
            
            searchBar.rx.text.skip(2).bind { (filterText) in
                guard let filterText = filterText , !filterText.isEmpty else {
                    self.isSearch = false
                    return
                }
                self.isSearch = true
                self.filterOfJobs = self.arrayOfJobs.filter({ $0.title!.lowercased().contains(filterText.lowercased())})
            }.disposed(by: self.disposePag)
            
            
        }else{
            UIView.animate(withDuration: 0.5) {
                self.navigationController?.navigationBar.topItem?.titleView = nil
            }
        }
  
    }
    
    
    @IBAction func addJobs(_ sender: Any) {
        guard  let userid = UserDefaults.standard.value(forKey: NetworkConstants.userIdKey) as? String else {
            showAlertTologein(massage: "من فضلك سجل الدخول ")
            return
        }
       print(userid)
        let jobDatilesVc = coordinator.mainNavigator.viewController(for: .JobDetailesVc(job: nil))
      navigationController?.pushViewController(jobDatilesVc, animated: true)
    }
}


extension JobsVc: UITableViewDelegate, UITableViewDataSource , GADBannerViewDelegate{
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? filterOfJobs.count : arrayOfJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! JobTableViewCell
        cell.selectionStyle = .none
        let activeJob = isSearch ? filterOfJobs : arrayOfJobs
        cell.nameOfJob.text = activeJob[indexPath.row].title
        cell.nameOfJob.textAlignment = .right
        cell.describtionOfJob.text = activeJob[indexPath.row].jobDescription
        if activeJob[indexPath.row].activated == "1" {
            cell.statusOfJob.text =  "متاح"
            cell.statusOfJob.textColor = .green
            
        }else{
            cell.statusOfJob.text =  "مغلق"
            cell.statusOfJob.textColor = DesignSystem.Colors.MainColor.color
        }
        
        cell.numberOfViews.text =  "\(activeJob[indexPath.row].viewers ?? "") " + "مشاهدة"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeJob = isSearch ? filterOfJobs : arrayOfJobs
        let selectedJop = activeJob[indexPath.row]
        let jobDatilesVc = coordinator.mainNavigator.viewController(for: .JobDetailesVc(job: selectedJop))
      navigationController?.pushViewController(jobDatilesVc, animated: true)
       
    }
    
}
