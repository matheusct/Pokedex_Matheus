//
//  AddFavoritePokemon.swift
//  Pokedex_Matheus
//
//  Created by Matheus Cavalcante Teixeira on 13/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

class AddFavoritePokemon {
    public static let shared = AddFavoritePokemon()
    private let gateway:PokemonGatewayProtocol;
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(gateway: PokemonGatewayProtocol = PokemonGateway()) {
        self.gateway = gateway
    }
    
    fileprivate func handleError(_ gatewayError: GatewayError) -> UseCaseError {
        switch gatewayError {
        case .integrationErro:
            return UseCaseError.unexpectedError
        }
    }

}

extension AddFavoritePokemon: AddFavoritePokemonProtocol {
    func execute(pokemon: PokemonModel) -> AnyPublisher<Bool, UseCaseError> {
        return gateway.addFavoritePokemon(pokemon: pokemon).mapError{ (gatewayError) -> UseCaseError in
            return self.handleError(gatewayError)
        }.map { (value) -> Bool in
            return value == ""
        }.eraseToAnyPublisher()
    }
}
