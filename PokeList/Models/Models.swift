//
//  PokemonModel.swift
//  PokeList
//
//  Created by Felipe Gameiro on 18/07/22.
//

import Foundation
import UIKit

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
    var abilities: [AbilityDetail]
    var baseExperience: Int
    var moves: [MoveDetail]
    var stats: [StatDetail]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case sprites
        case abilities
        case baseExperience = "base_experience"
        case moves
        case stats
    }
    
    func valueByPropertyName(key: String) -> String? {
        switch key {
            case "abilities":
                return abilities.map { detail in
                    return detail.ability.name
                }.joined(separator: ", ")
            case "moves":
                return moves.map { detail in
                    return detail.move.name
                }.joined(separator: ", ")
            case "stats":
                return stats.map { detail in
                    return detail.stat.name + ": " + String(detail.baseStat)
                }.joined(separator: "\n")
            default:
                return nil
        }
    }
    
    func getDataForTable() -> [(label: String, value: String)] {
        var result: [(label: String, value: String)] = [(label: "Base Experience", value: String(baseExperience))]
        for key in CodingKeys.allCases {
            guard valueByPropertyName(key: key.stringValue) != nil else {
                continue
            }
            result.append((key.stringValue.capitalized, valueByPropertyName(key: key.stringValue)!.capitalized))
        }
        
        return result
    }
    
    func toString() -> String{
        return """
        name: \(name)
        id: \(id)
        sprites: \(sprites.other.officialArtwork.frontDefault)
        abilities: \(abilities.map({ detail in
        return detail.ability.name
        }))
        base experience: \(baseExperience)
        moves: \(moves.map({ detail in
        return detail.move.name
        }))
        stats: \(stats.map({ detail in
        return detail.stat.name + String(detail.baseStat)
        }))
        """
    }
}

struct AbilityDetail: Codable {
    var ability: Ability
}

struct Ability: Codable {
    var name: String
}

struct MoveDetail: Codable {
    var move: Move
}

struct Move: Codable {
    var name: String
}

struct StatDetail: Codable {
    var stat: Stat
    var baseStat: Int
    
    enum CodingKeys: String, CodingKey {
        case stat
        case baseStat = "base_stat"
    }
}

struct Stat: Codable {
    var name: String
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
