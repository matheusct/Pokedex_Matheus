//
//  PokemonGatewayMock.swift
//  Pokedex_MatheusTests
//
//  Created by Matheus Cavalcante Teixeira on 14/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

class PokemonGatewayMock {
    var pokemonList: [PokemonListUntreatedModel]?
    var pokemonDetails: PokemonModel?
    var favoriteResponse: String?
    var error: GatewayError?
}

extension PokemonGatewayMock: PokemonGatewayProtocol {
    func getPokemonList(_ offSet: Int, _ limit: Int) -> AnyPublisher<[PokemonListUntreatedModel], GatewayError> {
        guard let pokemonList = pokemonList else {
            return Fail(error: error!).eraseToAnyPublisher()
        }
        return Just(pokemonList).mapError({ (error) -> GatewayError in
            GatewayError.integrationErro("teste")
        }).eraseToAnyPublisher()
    }
    
    func getPokemonDetails(_ id: Int) -> AnyPublisher<PokemonModel, GatewayError> {
        guard let pokemonDetails = pokemonDetails else {
            return Fail(error: error!).eraseToAnyPublisher()
        }
        return Just(pokemonDetails).mapError({ (error) -> GatewayError in
            GatewayError.integrationErro("teste")
        }).eraseToAnyPublisher()
    }
    
    func addFavoritePokemon(pokemon: PokemonModel) -> AnyPublisher<String, GatewayError> {
        guard let favoriteResponse = favoriteResponse else {
            return Fail(error: error!).eraseToAnyPublisher()
        }
        return Just(favoriteResponse).mapError({ (error) -> GatewayError in
            GatewayError.integrationErro("teste")
        }).eraseToAnyPublisher()
    }
    
    
}
