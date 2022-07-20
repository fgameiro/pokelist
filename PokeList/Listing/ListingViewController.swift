//
//  ListingViewController.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import UIKit
import SDWebImage

protocol ListingViewControllerProtocol: AnyObject {
    var presenter: ListingPresenterProtocol? { get set }
    
    func update(with pokemonList: [PokemonDetail])
    func update(with error: ListError)
    func getNextPage()
}

class ListingViewController: UIViewController, ListingViewControllerProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: ListingPresenterProtocol?
    
    @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView!
    
    var pokemonDetailList: [PokemonDetail] = [] {
        didSet {
            self.loading = false
            DispatchQueue.main.async { [weak self] in
                UIView.performWithoutAnimation {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    var loading: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.mainActivityIndicator.isHidden = !self.loading
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        self.title = "Pokelist"
        
        presenter?.getPokemonDetailList()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setupCollectionViewCompositionalLayout()
    }
    
    func update(with pokemonList: [PokemonDetail]) {
        pokemonDetailList.append(contentsOf: pokemonList)
    }
    
    func update(with error: ListError) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            
            self?.present(alert, animated: true)
        }
    }
    
    func getNextPage() {
        presenter?.getPokemonDetailList()
    }
    
    func setupCollectionView() {
        collectionView.register(ListingCell.nib(), forCellWithReuseIdentifier: ListingCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionViewCompositionalLayout()
    }
    
    func setupCollectionViewCompositionalLayout() {
        collectionView.collectionViewLayout = collectionViewLayout()
    }
    
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let fractionalHeight = UIDevice.current.orientation.isLandscape ? 0.5 : 0.25
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fractionalHeight)), subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let pokemon = pokemonDetailList[indexPath.row]
        
        guard let navController = self.navigationController else {
            return
        }
        
        presenter?.presentPokemonDetail(on: navController, with: pokemon)
    }
}

extension ListingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonDetailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == pokemonDetailList.count - 5, presenter?.listingNextPage != nil {
            self.getNextPage()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingCell.identifier, for: indexPath) as! ListingCell
        
        let pokemon = pokemonDetailList[indexPath.row]
        
        cell.label.text = pokemon.name.capitalized
        cell.imageView.sd_setImage(with: URL(string: pokemon.sprites.other.officialArtwork.frontDefault), placeholderImage: nil)
        
        return cell
    }
}
