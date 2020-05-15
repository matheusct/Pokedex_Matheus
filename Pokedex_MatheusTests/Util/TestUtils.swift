//
//  TestUtils.swift
//  Pokedex_MatheusTests
//
//  Created by Matheus Cavalcante Teixeira on 14/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation

class TestUtils {
    
    func getJson<T>(jsonName: String) -> T? where T: Decodable {
        guard let path = Bundle(for: type(of: self)).path(forResource: jsonName, ofType: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func validateAbilities(resultAbilities: [AbilityModel], clientAbilities: [AbilityResponse]) -> Bool {
        var contains = true
        for ability in clientAbilities {
            if !resultAbilities.contains(where: { (model) -> Bool in
                return model.isHidden == ability.isHidden && model.name == ability.ability.name
            }) {
                contains = false
            }
        }
        return contains
    }
    
    func validateMoves(resultMoves: [String], clientMoves: [MoveResponse]) -> Bool {
        var contains = true
        for move in clientMoves {
            if !resultMoves.contains(move.move.name){
                contains = false
            }
        }
        return contains
    }
    
    func validateSprites(resultSprites: [String], clientSprites: Dictionary<String,String?>) -> Bool {
        var contains = true
        for sprite in clientSprites {
            if sprite.value != nil && !resultSprites.contains(sprite.value!){
                contains = false
            }
        }
        return contains
    }
}
