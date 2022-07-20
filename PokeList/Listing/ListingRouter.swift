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
    func present() -> ListingPresentation
    
    func goToPokemonDetail(on navController: UINavigationController, with pokemonDetail: PokemonDetail)
}

class ListingRouter: ListingRouterProtocol {
    var storyboard: UIStoryboard  {
        return UIStoryboard.init(name: "ListingView", bundle: Bundle.main)
    }
    
    func present() -> ListingPresentation {
        
        guard let listingVC = storyboard.instantiateInitialViewController() as? ListingPresentation else {
            fatalError("Couldn't load listing view.")
        }
        let presenter = ListingPresenter()
        let interactor = ListingInteractor()
        
        presenter.interactor = interactor
        presenter.viewController = listingVC
        presenter.router = self
        listingVC.presenter = presenter
        interactor.presenter = presenter
        
        return listingVC
    }
    
    func goToPokemonDetail(on navController: UINavigationController, with pokemonDetail: PokemonDetail) {
        let detailVC = DetailRouter.present(with: pokemonDetail)
        
        navController.pushViewController(detailVC, animated: true)
    }
}
