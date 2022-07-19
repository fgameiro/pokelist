//
//  DetailRouter.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import Foundation
import UIKit

typealias ListingPresentation = ListingViewControllerProtocol & UIViewController

protocol ListingRouterProtocol {
    static func present() -> ListingPresentation
}

class ListingRouter: ListingRouterProtocol {
    static func present() -> ListingPresentation {
        let storyboard = UIStoryboard.init(name: "ListingView", bundle: Bundle.main)
        guard let listingVC = storyboard.instantiateInitialViewController() as? ListingViewController else {
            fatalError("Couldn't load ListingVC.")
        }
        
        let presenter = ListingPresenter()
        let interactor = ListingInteractor()
        
        presenter.interactor = interactor
        presenter.viewController = listingVC
        listingVC.presenter = presenter
        interactor.presenter = presenter
        
        return listingVC
    }
    
    
}
