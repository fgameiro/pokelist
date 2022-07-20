//
//  DetailRouter.swift
//  PokeList
//
//  Created by Felipe Gameiro on 19/07/22.
//

import Foundation
import UIKit

typealias DetailPresentation = DetailViewControllerProtocol & UIViewController

protocol DetailRouterProtocol {
    static func present(with pokemonDetail: PokemonDetail) -> DetailPresentation
}

class DetailRouter: DetailRouterProtocol {
    static func present(with pokemonDetail: PokemonDetail) -> DetailPresentation {
        let storyboard = UIStoryboard.init(name: "DetailView", bundle: Bundle.main)
        guard let detailVC = storyboard.instantiateInitialViewController() as? DetailViewController else {
            fatalError("Couldn't load DetailVC.")
        }
        
        detailVC.pokemonDetail = pokemonDetail
        
        return detailVC
    }
}
