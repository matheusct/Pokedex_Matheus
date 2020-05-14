//
//  PokemonGatewayProtocol.swift
//  Pokedex_Matheus
//
//  Created by Matheus Cavalcante Teixeira on 13/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

protocol PokemonGatewayProtocol {
    func getPokemonList(_ offSet: Int, _ limit: Int) -> AnyPublisher<[PokemonListUntreatedModel], GatewayError>
    func getPokemonDetails(_ id: Int) -> AnyPublisher<PokemonModel, GatewayError>
    func addFavoritePokemon(pokemon: PokemonModel) -> AnyPublisher<String, GatewayError>
}
