//
//  ListingPresenter.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import Foundation

enum ListError: Error {
    case networkError(error: String)
    case encodingError(error: String)
    case unexpectedError(error: String)
}

protocol ListingPresenterProtocol: AnyObject {
    var viewController: ListingViewControllerProtocol? { get set }
    var interactor: ListingInteractorProtocol? { get set }
    
    func getPokemonDetailList()
    func didFetchPokemonUrlList(with result: Result<PokemonList, ListError>)
}

class ListingPresenter: ListingPresenterProtocol {
    var interactor: ListingInteractorProtocol?
    weak var viewController: ListingViewControllerProtocol?
    
    private var pokemonDetailUrlList: PokemonList? {
        didSet {
            fetchPokemonDetailList()
        }
    }
    
    private var pokemonDetailList: [PokemonDetail] = []
    
    func getPokemonDetailList() {
        // we should get a list of pokemon, each of them will have a url
        // we then must fetch the url to get pokemon details (which will include the image)
        interactor?.fetchPokemonUrlList()
    }
    
    func fetchPokemonDetailList() {
        Task {
            guard let pokemonDetailUrlList = pokemonDetailUrlList else {
                viewController?.update(with: .unexpectedError(error: "Coudn't unwrap pokemonDetailUrlList."))
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
    
    
    
}
