//
//  GetPokemonDetailsTest.swift
//  Pokedex_MatheusTests
//
//  Created by Matheus Cavalcante Teixeira on 15/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import XCTest
import Combine

class GetPokemonDetailsTest: XCTestCase {
    
    var cancellableSet: Set<AnyCancellable> = []
    var testUtils = TestUtils()

    func testGetPokemonDetailsSuccess() throws {
        let gateway = PokemonGatewayMock()
        let usecase = GetPokemonDetails.init(gateway: gateway)
        
        guard let response: PokemonDetailsResponse = testUtils.getJson(jsonName: "PokemonDetails") else {
            return XCTFail("invalid Json")
        }
        
        gateway.pokemonDetails = PokemonModel.init(response: response)
        gateway.error = GatewayError.integrationErro("teste")
        
        let expectation = self.expectation(description: "getting pokemon details")
        
        var useCaseReturn: PokemonModel?
        usecase.execute(1).sink(receiveCompletion: { _ in
        }) { value in
            useCaseReturn = value
            expectation.fulfill()
        }.store(in: &cancellableSet)
        guard let details = useCaseReturn else {
            XCTFail("useCaseReturn nil")
            return
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(details.id, response.id)
        XCTAssertEqual(details.name, response.name)
        XCTAssertEqual(details.baseExperience, response.baseExperience)
        XCTAssertEqual(details.height, response.height)
        XCTAssertEqual(details.id, response.id)
        XCTAssertEqual(details.name, response.name)
        XCTAssertEqual(details.weight, response.weight)
        XCTAssertEqual(details.abilities.count, response.abilities.count)
        XCTAssertEqual(details.moves.count, response.moves.count)
        XCTAssertEqual(details.stats.count, response.stats.count)
        XCTAssert(testUtils.validateMoves(resultMoves: details.moves, clientMoves: response.moves))
        XCTAssert(testUtils.validateSprites(resultSprites: details.sprites, clientSprites: response.sprites))
        XCTAssert(testUtils.validateAbilities(resultAbilities: details.abilities, clientAbilities: response.abilities))
    }
    
    func testGetPokemonDetailsError() throws {
        let gateway = PokemonGatewayMock()
        let usecase = GetPokemonDetails.init(gateway: gateway)
        
        gateway.pokemonDetails = nil
        gateway.error = GatewayError.integrationErro("teste")
        
        let expectation = self.expectation(description: "getting pokemon details")
        
        var useCaseError: UseCaseError?
        usecase.execute(1).sink(receiveCompletion: { completion in
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
