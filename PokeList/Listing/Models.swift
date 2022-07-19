//
//  PokemonModel.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import Foundation

struct PokemonList: Codable {
    var next: String
    var results: [PokemonResult]
}

struct PokemonResult: Codable  {
    var name: String
    var url: String
}

struct PokemonDetail: Codable {
    var id: Int
    var name: String
    var sprites: Sprites
}

struct Sprites: Codable {
    var other: OtherSprites
}

struct OtherSprites: Codable {
    var officialArtwork: OfficialArtworkSprites
    
    enum CodingKeys : String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtworkSprites: Codable {
    var frontDefault: String
    
    enum CodingKeys : String, CodingKey {
        case frontDefault = "front_default"
    }
}
