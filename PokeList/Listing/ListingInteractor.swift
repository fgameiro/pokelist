//
//  DetailInteractor.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import Foundation

protocol ListingInteractorProtocol: AnyObject {
    var presenter: ListingPresenterProtocol? { get set }
    
    func fetchPokemonUrlList(for page: String?)
    func fetchPokemonDetail(with url: String) async throws -> PokemonDetail
}

class ListingInteractor: ListingInteractorProtocol {
    weak var presenter: ListingPresenterProtocol?
    
    let baseUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    func fetchPokemonUrlList(for page: String?) {
        guard let url = URL(string: page ?? baseUrl) else {
            fatalError("Coudn't get API URL.")
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard error == nil else {
                self?.presenter?.didFetchPokemonUrlList(with: .failure(.networkError(error: error!.localizedDescription)))
                return
            }
            
            if let data = data {
                do {
                    let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                    self?.presenter?.didFetchPokemonUrlList(with: .success(pokemonList))
                } catch {
                    self?.presenter?.didFetchPokemonUrlList(with: .failure(.encodingError(error: error.localizedDescription)))
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchPokemonDetail(with url: String) async throws -> PokemonDetail {
        guard let detailUrl = URL(string: url) else {
            fatalError("Coudn't get API URL.")
        }
        
        let (data, response) = try await URLSession.shared.data(from: detailUrl)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ListError.networkError(error: "Couldn't download pokemon detail data.")
        }
        
        do {
            let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
            return pokemonDetail
        } catch {
            throw ListError.encodingError(error: "Couldn't decode PokemonDetail data.")
        }
    }
    
    
}
