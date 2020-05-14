//
//  GetPokemonDetails.swift
//  Pokedex_Matheus
//
//  Created by Matheus Cavalcante Teixeira on 13/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

class GetPokemonDetails {
    private let gateway: PokemonGatewayProtocol
    static let shared: GetPokemonDetailsProtocol = GetPokemonDetails()
    
    init(gateway: PokemonGatewayProtocol = PokemonGateway()) {
        self.gateway = gateway
    }
    
    fileprivate func handleError(_ gatewayError: GatewayError) -> UseCaseErro {
        switch gatewayError {
        case .integrationErro:
            return UseCaseErro.unexpectedError
        }
    }
}

extension GetPokemonDetails: GetPokemonDetailsProtocol {
    func execute(_ id: Int) -> AnyPublisher<PokemonModel, UseCaseErro> {
        return gateway.getPokemonDetails(id).mapError { (error) -> UseCaseErro in
            return self.handleError(error)
        }.eraseToAnyPublisher()
    }
    
    
}
