//
//  AddFavoritePokemonProtocol.swift
//  Pokedex_Matheus
//
//  Created by Matheus Cavalcante Teixeira on 13/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

protocol AddFavoritePokemonProtocol {
    func execute(pokemon: PokemonModel) -> AnyPublisher<Bool, UseCaseError>
}
