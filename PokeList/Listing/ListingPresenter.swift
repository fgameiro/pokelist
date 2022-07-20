//
//  ListingPresenter.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import Foundation
import UIKit

enum ListError: Error {
    case networkError(error: String)
    case encodingError(error: String)
    case unexpectedError(error: String)
}

protocol ListingPresenterProtocol: AnyObject {
    var viewController: ListingViewControllerProtocol? { get set }
    var interactor: ListingInteractorProtocol? { get set }
    var listingNextPage: String? { get set }
    
    func getPokemonDetailList()
    func didFetchPokemonUrlList(with result: Result<PokemonList, ListError>)
    func didFetchPokemonDetail(with result: Result<[PokemonDetail], ListError>)
    func presentPokemonDetail(on navController: UINavigationController, with pokemonDetail: PokemonDetail)
}

class ListingPresenter: ListingPresenterProtocol {
    var interactor: ListingInteractorProtocol?
    var router: ListingRouterProtocol?
    weak var viewController: ListingViewControllerProtocol?
    
    private var pokemonDetailUrlList: PokemonList? {
        didSet {
            fetchPokemonDetailList()
        }
    }
    
    private var pokemonDetailList: [PokemonDetail] = []
    var listingNextPage: String?
    
    func getPokemonDetailList() {
        interactor?.fetchPokemonUrlList(for: listingNextPage)
    }
    
    func fetchPokemonDetailList() {
        Task {
            guard let pokemonDetailUrlList = pokemonDetailUrlList else {
                viewController?.update(with: .unexpectedError(error: "Couldn't unwrap pokemonDetailUrlList."))
                return
            }
            var detailList: [PokemonDetail] = []
            
            for result in pokemonDetailUrlList.results {
                do {
                    let pokemonDetail = try await interactor?.fetchPokemonDetail(with: result.url)
                    detailList.append(pokemonDetail!)
                } catch {
                    print("Unable to get pokemon detail for \(result.name)")
                }
            }
            
            didFetchPokemonDetail(with: .success(detailList))
        }
    }
    
    func didFetchPokemonUrlList(with result: Result<PokemonList, ListError>) {
        switch result {
        case .success(let pokemonList):
            pokemonDetailUrlList = pokemonList
            listingNextPage = pokemonList.next
        case .failure(let error):
            viewController?.update(with: error)
        }
    }
    
    func didFetchPokemonDetail(with result: Result<[PokemonDetail], ListError>) {
        switch result {
        case .success(let pokemonDetailList):
            viewController?.update(with: pokemonDetailList)
        case .failure(let error):
            viewController?.update(with: error)
        }
    }
    
    func presentPokemonDetail(on navController: UINavigationController, with pokemonDetail: PokemonDetail) {
        router?.goToPokemonDetail(on: navController, with: pokemonDetail)
    }
    
}
