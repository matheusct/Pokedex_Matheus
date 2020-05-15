//
//  GatewayError.swift
//  Pokedex_Matheus
//
//  Created by Matheus Cavalcante Teixeira on 14/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation

enum GatewayError: Error, LocalizedError, Equatable {
    case integrationErro(String)
}
