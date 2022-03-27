//
//  MainNavigator.swift
//  Opportunities
//
//  Created by youssef on 12/9/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class MainNavigator : Navigator {
    
    var coordinator: Coordinator
    
    enum Destination {
        case login
        case register
        case RegisterAsOwner(brandData : Info?)
        case mapView(cartDate : [Cart])
        case forget
        case HomeView
        case menueView
        case explorVC
        case supCatagories(cataoryId : String, catagoryName : String , isAdvertisment : Bool)
        case SelectedExplorVC(brands : [Brand], catId : String)
        case addAdvertisment(Addvertise : AdSubCatagories? , isFromClient : Bool)
        case ContectUs
        case whoAreView
        case CatagoriesDetaiels(catagorySub:  AdSubCatagories?,isMyAddverisment : Bool , CatId : String)
        case brandDetaiels(cataory : Brand? , catId : String)
        case Favourites
        case MyAddvertisment
        case FullScreenImage(arratOfImage : [String])
        case CartViewController(arrayOfProdect : [Product]?)
        case OrdersViewController
        case ConformOrderViewController(Caratdate : [Cart], nameOfAddress: String, AddressLocation: CLLocationCoordinate2D)
        case RegisterAsDelivery(DeliveryData : Info?)
        case SearchDelivertyViewController(orderId : String? ,  OrderTaiarDate: [String : String]?, image : UIImage?)
        case ordersOftaiar
        case OrderTaierViewController
        case MyWalletViewController
        case JobsVc
        case JobDetailesVc(job : Job?)
        
    }
    required init(coordintor: Coordinator) {
        self.coordinator = coordintor
    }
    
    func viewController(for destination: MainNavigator.Destination) -> UIViewController {
        
        switch destination {
        case .login:
            let LoginModel = loginViewModel()
            let view = loginViewController(ViewModel: LoginModel, coordinator: coordinator)
            return view
        case .register:
            let registerModel = registerViewModel(BarndData: nil)
            let view = RegisterViewController(ViewModel: registerModel, coordinator: coordinator)
            return view
        case .RegisterAsOwner(let brandData):
            let registerModel = registerViewModel(BarndData: brandData)
            let view = RegisterAsOwnerViewController(ViewModel: registerModel, coordinator: coordinator)
            return view
        case .mapView(cartDate: let cart):
            let mapViewM = mapViewModel(CartData: cart)
            let view = mapViewController(ViewModel: mapViewM, coordinator: coordinator)
            return view
        case .forget:
            let mapViewM = forgetPassViewModel()
            let view = forgetPassViewController(ViewModel: mapViewM, coordinator: coordinator)
            return view
        case .HomeView:
            let homeViewM = HomeViewModel()
            let view = HomeViewController(ViewModel: homeViewM, coordinator: coordinator)
            return view
        case .menueView:
            let menueView = MyAddvertismentViewModel()
            let view = menueViewController(ViewModel: menueView, coordinator: coordinator)
            return view
        case .supCatagories(let catagoryId, let catagoryName , isAdvertisment : let  isAdvertisment):
            let CatogoryView = CatogoryViewModel(catagoryId: catagoryId, catagoryName: catagoryName, isAdvertisment: isAdvertisment)
            let view = CatogoryViewController(ViewModel: CatogoryView, coordinator: coordinator)
            return view
        case .explorVC:
            let ExplorView = ExploreCatagoriesViewModel()
            let view = ExploreCatagoriesViewController(ViewModel: ExplorView, coordinator: coordinator)
            return view
        case .SelectedExplorVC(brands: let brands, catId: let catId):
            let SelectedExplorView = ExploreCatgoriesSelectedViewModel(brands: brands, catId: catId)
            let view = ExploreCatgoriesSelectedViewController(ViewModel: SelectedExplorView, coordinator: coordinator)
            return view
        case .addAdvertisment(let Addvertise , let isFromClient):
            let addAdvertisment = addAdvertismentViewModel(Addvertise: Addvertise, isFromClient: isFromClient)
            let view = addAdvertismentViewController(ViewModel: addAdvertisment, coordinator: coordinator)
            return view
        case .ContectUs:
            let ContectUsView = ContectUsViewModel()
            let view = ContectUsViewController(ViewModel: ContectUsView, coordinator: coordinator)
            return view
        case .whoAreView:
            let HowAreView = HowAreViewModel()
            let view = HowAreViewController(ViewModel: HowAreView, coordinator: coordinator)
            return view
        case .CatagoriesDetaiels(let SubCatagories, let isMyAddverisment, let catId):
            let CatagoriesDetaielmodel = CatagoriesDetaielsViewModels(catagorie: nil, catagorySub: SubCatagories, isMyAddverisment: isMyAddverisment, catId: catId)
            let view = CatagoriesDetaielsViewController(ViewModel: CatagoriesDetaielmodel, coordinator: coordinator)
            return view
        case .brandDetaiels(let cataory, let catId):
            let BrandDetaielmodel = CatagoriesDetaielsViewModels(catagorie: cataory, catagorySub: nil, isMyAddverisment: false, catId: catId)
            let view = BrandDetailsViewController(ViewModel: BrandDetaielmodel, coordinator: coordinator)
            return view
        case .Favourites:
            let favouritesModel = favouritesViewModel()
            let view = FavouirtesViewController(ViewModel: favouritesModel, coordinator: coordinator)
            return view
        case .MyAddvertisment:
            let myAddvertismentViewModel = MyAddvertismentViewModel()
            let view = MyAddvertismentViewController(ViewModel: myAddvertismentViewModel, coordinator: coordinator)
            return view
        case .FullScreenImage(let arratOfImage):
            let FullScreenImageModel = FullScreenViewModel(arrayOfImage: arratOfImage)
            let view = FullScreenViewController(ViewModel: FullScreenImageModel, coordinator: coordinator)
            return view
        case .CartViewController(arrayOfProdect: let prodect):
            let CartModel = CartViewModel(prodects: prodect)
            let view = CartViewController(ViewModel: CartModel, coordinator: coordinator)
            return view
        case .OrdersViewController:
            let OrdersModel = OrdersViewModel()
            let view = OrdersViewController(ViewModel: OrdersModel, coordinator: coordinator)
            return view
        case .ConformOrderViewController(Caratdate : let Cart, nameOfAddress : let nameOfAddress , AddressLocation : let AddressLocation) :
            let ConformModel = ConformOrderViewModel(CartData: Cart, nameOfAddress: nameOfAddress, AddressLocation: AddressLocation)
            let view = ConformOrderViewController(ViewModel: ConformModel, coordinator: coordinator)
            return view
        case .RegisterAsDelivery(DeliveryData: let date):
            let RegisterAsDeliveryModel = registerViewModel(BarndData: date)
            let view = RegisterAsDelivery(ViewModel: RegisterAsDeliveryModel, coordinator: coordinator)
            return view

        case .ordersOftaiar:
            let ordersOftaiarModel = TaierOrdersViewModel()
            let view = TaierOrdersViewController(ViewModel: ordersOftaiarModel, coordinator: coordinator)
            return view
        case .OrderTaierViewController:
            let OrderTaiermodel = OrderTaierViewModel()
            let view = OrderTaierViewController(ViewModel: OrderTaiermodel, coordinator: coordinator)
            return view
        case .SearchDelivertyViewController(orderId: let orderId, OrderTaiarDate: let OrderTaiarDate, image: let image):
            let SearchDelivertModel = SearchDelivertyViewModel(orderId: orderId, OrderTaiarDate: OrderTaiarDate, image: image)
            let view = SearchDelivertyViewController(ViewModel: SearchDelivertModel, coordinator: coordinator)
            return view
        case .MyWalletViewController:
            let homeViewM = HomeViewModel()
            let view = MyWalletViewController(ViewModel: homeViewM, coordinator: coordinator)
            return view
        case .JobsVc:
            let jobViewM = JobsViewModel()
            let view = JobsVc(ViewModel: jobViewM, coordinator: coordinator)
            return view
        case .JobDetailesVc(job: let job):
            let jobetailesViewM = JobDetailesViewModel(job: job)
            let view = JobDetailesVc(ViewModel: jobetailesViewM, coordinator: coordinator)
            return view
        }
    }
    
}
