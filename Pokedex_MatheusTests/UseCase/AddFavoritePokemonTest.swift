//
//  AddFavoritePokemonTest.swift
//  Pokedex_MatheusTests
//
//  Created by Matheus Cavalcante Teixeira on 15/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import XCTest
import Combine

class AddFavoritePokemonTest: XCTestCase {
    
    var cancellableSet: Set<AnyCancellable> = []
    var testUtils = TestUtils()
    
    func testAddPokemonFavoriteSuccess() throws {
        let gateway = PokemonGatewayMock()
        let usecase = AddFavoritePokemon.init(gateway: gateway)
        
        guard let response: PokemonDetailsResponse = testUtils.getJson(jsonName: "PokemonDetails") else {
            return XCTFail("invalid Json")
        }
        gateway.favoriteResponse = ""
        
        let expectation = self.expectation(description: "add pokemon favorite")
        
        var useCaseReturn: Bool = false
        usecase.execute(pokemon: PokemonModel(response: response)).sink(receiveCompletion: { _ in
        }) { value in
            useCaseReturn = value
            expectation.fulfill()
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssert(useCaseReturn)
    }

    func testAddPokemonFavoriteError() throws {
        let gateway = PokemonGatewayMock()
        let usecase = AddFavoritePokemon.init(gateway: gateway)
        
        guard let response: PokemonDetailsResponse = testUtils.getJson(jsonName: "PokemonDetails") else {
            return XCTFail("invalid Json")
        }

        gateway.error = GatewayError.integrationErro("teste")
        
        let expectation = self.expectation(description: "add pokemon favorite")
        
        var useCaseError: UseCaseError?
        usecase.execute(pokemon: PokemonModel(response: response)).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                useCaseError = error
                expectation.fulfill()
            case .finished:
                expectation.fulfill()
            }
        }) { _ in
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(useCaseError, UseCaseError.unexpectedError)
    }
}
