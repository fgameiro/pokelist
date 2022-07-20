//
//  DetailViewController.swift
//  PokeList
//
//  Created by Felipe Gameiro on 19/07/22.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    var presenter: ListingPresenterProtocol? { get set }
    var pokemonDetail: PokemonDetail? { get set }
}

class DetailViewController: UIViewController, DetailViewControllerProtocol {
    var pokemonDetail: PokemonDetail?
    
    var presenter: ListingPresenterProtocol?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.register(DetailCell.nib(), forCellReuseIdentifier: DetailCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        title = pokemonDetail?.name.capitalized
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier) as? DetailCell else {
            return UITableViewCell()
        }
        
        let pokemonData = pokemonDetail!.getDataForTable()[indexPath.row]
        
        cell.title.text = pokemonData.label.uppercased()
        cell.content.text = pokemonData.value
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonDetail!.getDataForTable().count
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: pokemonDetail!.sprites.other.officialArtwork.frontDefault), placeholderImage: nil)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.bounds.height / 4
    }
}


