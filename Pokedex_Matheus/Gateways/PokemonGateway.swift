//
//  PokemonGateway.swift
//  Pokedex_Matheus
//
//  Created by Matheus Cavalcante Teixeira on 13/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

public class PokemonGateway {
    
    
    private let client: ApiClientProtocol
    
    init(client: ApiClientProtocol = ApiClient()) {
        self.client = client
    }
    
    fileprivate func handleError(_ apiError: ApiError) -> GatewayError {
        switch apiError {
        case .decodingError, .responseError,.urlError, .unexpectedError:
            return GatewayError.integrationErro(apiError.localizedDescription)
        }
    }
}

extension PokemonGateway: PokemonGatewayProtocol {
    
    func getPokemonList(_ offSet: Int, _ limit: Int) -> AnyPublisher<[PokemonListUntreatedModel], GatewayError> {
        return client.getPokemonList(offSet, limit).mapError{(apiError) -> GatewayError in
            return self.handleError(apiError)
        }.map{ response in
            var list:[PokemonListUntreatedModel] = []
            for item in response.results {
                list.append(PokemonListUntreatedModel(name: item.name, url: item.url))
            }
            return list
        }.eraseToAnyPublisher()
    }
    
    func getPokemonDetails(_ id: Int) -> AnyPublisher<PokemonModel, GatewayError> {
        return client.getPokemonDetails(id).mapError{(apiError) -> GatewayError in
            return self.handleError(apiError)
        }.map{ response in
            return PokemonModel(response: response)
        }.eraseToAnyPublisher()
    }
    
    func addFavoritePokemon(pokemon: PokemonModel) -> AnyPublisher<String, GatewayError> {
        let request = FavoritePokemonResquest.init(id: pokemon.id, name: pokemon.name)
        return client.addFavoritePokemon(pokemon: request).mapError{(apiError) -> GatewayError in
            return self.handleError(apiError)
        }.eraseToAnyPublisher()
    }
    
}
