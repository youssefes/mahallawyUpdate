//
//  SignUpRepoitory.swift
//  delivery
//
//  Created by youssef on 3/13/21.
//  Copyright © 2021 youssef. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class SignRepository {
    let networkClient : NetworkClient
    init(networkClient : NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func register(parameters : [String : String],completion: @escaping ((Result< RegisterAsUserModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/register.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            
            switch respond.result{
            
            case .success(_):
                let data = respond.data
                do {
                    print(String(data: data!, encoding: .utf8)!)
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(RegisterAsUserModel.self, from: data!)
                    completion(.success(models))
                } catch let error {
                    print(error as Any)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func RgisterAsDelivery(parameters : [String : String], completion: @escaping ((Result< LoginModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/RegisterTaiar.php") else{return}
        
        MainRequestToAddToFavAndRate(LoginModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func DeliveryOrders(parameters : [String : String], completion: @escaping ((Result< TaiarModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getTaiarOrders.php") else{return}
        
        MainRequestToAddToFavAndRate(TaiarModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func UserOrOwnerDeliveryOrders(parameters : [String : String], completion: @escaping ((Result< TaiarModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getMyDelivering.php") else{return}
        
        MainRequestToAddToFavAndRate(TaiarModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    
    

    func CheckStatusOfDelivery(parameters : [String : String], completion: @escaping ((Result< CheckStausOfDeliveryModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getTaiarData.php") else{return}
        
        MainRequestToAddToFavAndRate(CheckStausOfDeliveryModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    func uplaodImages(images : UIImage) -> Observable<UploadImageModel>{
        Observable<UploadImageModel>.create {(items) -> Disposable in
            let url = URL(string: "\(NetworkConstants.baseUrl)upload.php")
            let header = HTTPHeaders([HTTPHeader(name: "Content-Type", value: "multipart/form-data")])
            AF.upload(multipartFormData: { (multipartFormData) in
                guard let profileImage = images.jpegData(compressionQuality: 0.5) else{
                    print("erroer in data convert")
                    return}
                multipartFormData.append(profileImage, withName: "uploaded_file",fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                
            }, to: url!, method: .post, headers: header).responseJSON { (respod) in
                
                switch respod.result{
                case .success(_):
                    do {
                        guard let data = respod.data else {return}
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .useDefaultKeys
                        let models = try decoder.decode(UploadImageModel.self, from: data)
                        print(models)
                        items.onNext(models)
                        items.onCompleted()
                    } catch let error {
                        items.onError(error)
                    }
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    
    
    func LogIn(parameters : [String : String], completion: @escaping ((Result< LoginModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/login.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            case .success(_):
                let data = respond.data
                do {
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(LoginModel.self, from: data!)
                    print(models)
                    completion(.success(models))
                } catch let error {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func ForgetPass(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordMainModel , Error>) -> Void)){
        
        guard let url = URL(string: "https://mahalawy.com/dashboard/services/sendPasswordToEmail.php") else {return}
        MainRequestToAddToFavAndRate(ForgetPasswordMainModel.self, parameters: parameters, Url: url) { (resulte) in
            completion(resulte)
        }
    }
    
    
    func addLikeAndUnlike(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordMainModel , Error>) -> Void)){
        
        guard let url = URL(string: "https://mahalawy.com/dashboard/services/EditLike.php") else {return}
        MainRequestToAddToFavAndRate(ForgetPasswordMainModel.self, parameters: parameters, Url: url) { (resulte) in
            completion(resulte)
        }
    }
    
    
    func getCatagories() -> Observable<CatagoriesModels>{
        Observable<CatagoriesModels>.create { [weak self] (items) -> Disposable in
            self?.networkClient.performRequest(CatagoriesModels.self, router: SignRouter.getCategories) { (resulte) in
                switch resulte{
                case .success(let data):
                    items.onNext(data)
                    items.onCompleted()
                case .failure(let error):
                    items.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func SubCatagories(parameters : [String : String], completion: @escaping ((Result< SubCatagoriesModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/getAdvertises.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            case .success(_):
                let data = respond.data
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let models = try decoder.decode(SubCatagoriesModel.self, from: data!)
                    completion(.success(models))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getLatestAdvertises(parameters : [String : String], completion: @escaping ((Result< SubCatagoriesModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/getLatestAdvertises.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            case .success(_):
                let data = respond.data
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let models = try decoder.decode(SubCatagoriesModel.self, from: data!)
                    completion(.success(models))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    func ExploreCatagories(parameters : [String : String], completion: @escaping ((Result< CategoriesExplore , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/getAllBrands.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            case .success(_):
                let data = respond.data
                do {
                    print(String(data: data!, encoding: .utf8)!)
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(CategoriesExplore.self, from: data!)
                    print(models)
                    completion(.success(models))
                } catch let error {
                    print(error as Any)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func GetJobs(parameters : [String : String], completion: @escaping ((Result< JobsModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/getJobs.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            case .success(_):
                let data = respond.data
                do {
                    print(String(data: data!, encoding: .utf8)!)
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(JobsModel.self, from: data!)
                    print(models)
                    completion(.success(models))
                } catch let error {
                    print(error as Any)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    func DeleteAddvertisment(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/deleteAdvertise.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    
    func AddtoCart(parameters : [String : String], completion: @escaping ((Result< AddToCartModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/addItemToCart.php") else{return}
        
        MainRequestToAddToFavAndRate(AddToCartModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func DeletedFromCart(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordMainModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/deleteItemCart.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordMainModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func GetCart(parameters : [String : String], completion: @escaping ((Result< GetMyCartModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getMyCart.php") else{return}
        
        MainRequestToAddToFavAndRate(GetMyCartModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func MakeOrder(parameters : [String : String], completion: @escaping ((Result< AddToCartModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/makeOrder.php") else{return}
        
        MainRequestToAddToFavAndRate(AddToCartModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func ChangeOrderStatus(order_id : String,user_id : String , statues : String , nesbet_tawsel : String? = nil , delivery_id : String? = nil) -> Observable<ForgetPasswordModel>{
       
        Observable<ForgetPasswordModel>.create { (items) -> Disposable in
            let url = "https://mahalawy.com/dashboard/services/changeOrderStatues.php"
            let hearderS: HTTPHeaders  = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
           
            var parameters = [
                "order_id": order_id,
                "user_id": user_id,
                "statues": statues
            ]
            
            if statues  == Orderstatus.finished.rawValue {
                parameters["nesbet_tawsel"] =  nesbet_tawsel ?? "0"
                parameters["delivery_id"] =  delivery_id ?? "0"
            }
            
            print(parameters)
            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: hearderS).responseJSON { (response) in
                switch response.result{
                case .failure(let error):
                    items.onError(error)
                    print("Error while fetching ProductList: \(error.localizedDescription)")
                case .success(_):
                    guard let data = response.data else {
                        print("Error whiles fetching data: didn't get any data from API")
                        return
                    }
                    do{
                        let userData = try JSONDecoder().decode(ForgetPasswordModel.self, from: data)
                        items.onNext(userData)
                    }catch(let error){
                        print("Error trying to decode response: \(error.localizedDescription)")
                        print("In Filters")
                        items.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func  getMyBooking(parameters : [String : String], completion: @escaping ((Result< myOrderModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getMyOrders.php") else{return}
        
        MainRequestToAddToFavAndRate(myOrderModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    
    
    
    func updateAddvertisment(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/updateAdvertise.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func updateBrand(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/updateBrandProfile.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    
    func addToFavouirts(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/addToFavourit.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    
    
    func addRate(parameters : [String : String], completion: @escaping ((Result< RatingModel , Error>) -> Void)){
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/SendRate.php") else{return}
        
        MainRequestToAddToFavAndRate(RatingModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func GetFavourite(parameters : [String : String], completion: @escaping ((Result< Favorites , Error>) -> Void)){
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/getFollowers.php") else{return}
        
        
        
        MainRequestToAddToFavAndRate(Favorites.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func GetBrandAddvertisment(parameters : [String : String], completion: @escaping ((Result< SubCatagoriesModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getSelectedBrandAdvertises.php") else{return}
        
        MainRequestToAddToFavAndRate(SubCatagoriesModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func MyAddvertisment(parameters : [String : String], completion: @escaping ((Result< SubCatagoriesModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/getMyAdvertises.php") else{return}
        
        MainRequestToAddToFavAndRate(SubCatagoriesModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func SendFCMToken(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/updateFCMToken.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func DeliveryAvaliableornot(parameters : [String : String], completion: @escaping ((Result< DelivaeryStatusModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/updateDeliveryStatues.php") else{return}
        
        MainRequestToAddToFavAndRate(DelivaeryStatusModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func searchOfDelivery(parameters : [String : String], completion: @escaping ((Result< SearchModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/callDeliveryShopOwner.php") else{return}
        
        MainRequestToAddToFavAndRate(SearchModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func checkDeliveryOrderStatus(parameters : [String : String], completion: @escaping ((Result< CheckStatusOfOrderDelivery , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/checkDeliverOrderStatues.php") else{return}
        
        MainRequestToAddToFavAndRate(CheckStatusOfOrderDelivery.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func searchOfDeliveryWithoutOrder(parameters : [String : String], completion: @escaping ((Result< SearchModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/callDeleviry.php") else{return}
        
        MainRequestToAddToFavAndRate(SearchModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func AcceptOrderByDelivery(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel, Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/acceptOrderByDelivery.php") else{return}
        
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func addView(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel , Error>) -> Void)){
        guard  let URl = URL(string:"https://mahalawy.com/dashboard/services/addView.php") else{return}
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func addAdvertisment(parameters : [String : String],completion: @escaping ((Result< UploadAddvertismentModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/addAdvertise.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            
            case .success(_):
                let data = respond.data
                do {
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(UploadAddvertismentModel.self, from: data!)
                    print(models)
                    completion(.success(models))
                } catch let error {
                    print(error as Any)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addAdvertismentForClient(parameters : [String : String],completion: @escaping ((Result< UploadAddvertismentModel , Error>) -> Void)){
        
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/addPersonalAdvertise.php") else{return}
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: URl,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            
            case .success(_):
                let data = respond.data
                do {
                    let decoder = JSONDecoder()
                    let models = try decoder.decode(UploadAddvertismentModel.self, from: data!)
                    print(models)
                    completion(.success(models))
                } catch let error {
                    print(error as Any)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func contecUs(parameters : [String : String], completion: @escaping ((Result< contectUsModel ,Error>) -> Void)){
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/SendContact.php") else{return}
        MainRequestToAddToFavAndRate(contectUsModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func AddJobs(parameters : [String : String], completion: @escaping ((Result< AddToCartModel ,Error>) -> Void)){
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/addJob.php") else{return}
        MainRequestToAddToFavAndRate(AddToCartModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
    func AddJobView(parameters : [String : String], completion: @escaping ((Result< ForgetPasswordModel ,Error>) -> Void)){
        guard  let URl = URL(string: "https://mahalawy.com/dashboard/services/addJobView.php") else{return}
        MainRequestToAddToFavAndRate(ForgetPasswordModel.self, parameters: parameters, Url: URl) { (ResulteData) in
            completion(ResulteData)
        }
        
    }
    
}

extension SignRepository{
    private func MainRequestToAddToFavAndRate<T : Decodable>(_ object: T.Type, parameters : [String : String], Url : URL, completion: @escaping ((Result< T , Error>) -> Void)){
        print(parameters)
        let header = HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        let headers = HTTPHeaders([header])
        AF.upload(multipartFormData: { (MultipartForm) in
            for (key, value) in parameters {
                
                MultipartForm.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: Url,method: .post, headers: headers).responseJSON { (respond) in
            switch respond.result{
            case .success(_):
                let data = respond.data
                print(String(data: data!, encoding: .utf8))
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let models = try decoder.decode(T.self, from: data!)
                    completion(.success(models))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
