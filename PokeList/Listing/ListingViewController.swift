//
//  ListingViewController.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import UIKit
import Imaginary

protocol ListingViewControllerProtocol: AnyObject {
    var presenter: ListingPresenterProtocol? { get set }
    
    func update(with pokemonList: [PokemonDetail])
    func update(with error: ListError)
}

class ListingViewController: UIViewController, ListingViewControllerProtocol {
    var presenter: ListingPresenterProtocol?
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pokemonDetailList: [PokemonDetail] = [] {
        //TODO: Remove this, debug only
        didSet {
            print(pokemonDetailList)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        presenter?.getPokemonDetailList()
    }
    
    func update(with pokemonList: [PokemonDetail]) {
        pokemonDetailList.append(contentsOf: pokemonList)
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func update(with error: ListError) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            
            self?.present(alert, animated: true)
        }
    }
}

extension ListingViewController: UICollectionViewDelegate {
    
}

extension ListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonDetailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let pokemon = pokemonDetailList[indexPath.row]
        
        let label = UILabel()
        label.text = pokemon.name
        
        let imageView = UIImageView()
        let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault)!
        imageView.setImage(url: imageUrl)
        
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .vertical
        
        cell.backgroundView = stackView
        
        return cell
    }
    
    
}
