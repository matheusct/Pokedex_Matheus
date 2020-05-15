//
//  PokemonGatewayTest.swift
//  Pokedex_MatheusTests
//
//  Created by Matheus Cavalcante Teixeira on 13/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import Foundation
import Combine

import XCTest
@testable import Pokedex_Matheus

class PokemonGatewayTest: XCTestCase {
    
    var cancellableSet: Set<AnyCancellable> = []
    let testUtils = TestUtils()
    
    func testGetPokemonDetailsSuccess() throws {
        let clientMock = ApiClientMock()
        guard let response: PokemonDetailsResponse = testUtils.getJson(jsonName: "PokemonDetails") else {
            return XCTFail("invalid Json")
        }
        clientMock.pokemonDetailsResponse = response
        
        let gateway = PokemonGateway(client: clientMock)
        
        let expectation = self.expectation(description: "getting pokemon details")
        
        var gatewayReturn: PokemonModel? = nil
        gateway.getPokemonDetails(1).sink(receiveCompletion: { _ in
        }, receiveValue: { result in
            gatewayReturn = result
            expectation.fulfill()
        }).store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        guard let details = gatewayReturn  else {
            XCTFail("gatewayReturn nil")
            return
        }
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
        let clientMock = ApiClientMock()

        clientMock.pokemonDetailsResponse = nil
        for apiError:ApiError in [.decodingError, .responseError(10), .unexpectedError("teste"), .urlError] {
        
        clientMock.error = apiError
        
        let gateway = PokemonGateway(client: clientMock)
        
        let expectation = self.expectation(description: "getting pokemon details")
        
        var gatewayReturn: GatewayError? = nil
        gateway.getPokemonDetails(1).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                gatewayReturn = error
                expectation.fulfill()
            case .finished:
                expectation.fulfill()
            }
        }, receiveValue: { result in
            
        }).store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
            XCTAssertEqual(gatewayReturn, GatewayError.integrationErro(apiError.localizedDescription))
        }
    }
    
    func testListPokemonSuccess() throws {
        let clientMock = ApiClientMock()
        guard let response: ListResponse = testUtils.getJson(jsonName: "ListPokemon") else {
            return XCTFail("invalid Json")
        }
        clientMock.listResponse = response
        
        let gateway = PokemonGateway(client: clientMock)
        
        let expectation = self.expectation(description: "getting pokemon list")
        
        var gatewayReturn: [PokemonListUntreatedModel]? = nil
        gateway.getPokemonList(0, 20).sink(receiveCompletion: { _ in
        }, receiveValue: { result in
            gatewayReturn = result
            expectation.fulfill()
        }).store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        guard let list = gatewayReturn  else {
            XCTFail("gatewayReturn nil")
            return
        }
        
        XCTAssertEqual(list.count, response.results.count)
        XCTAssert(validateList(list: list, clientResult: response))
    }
    
    func testListPokemonError() throws {
        let clientMock = ApiClientMock()

        clientMock.pokemonDetailsResponse = nil
        for apiError:ApiError in [.decodingError, .responseError(10), .unexpectedError("teste"), .urlError] {
        
            clientMock.error = apiError
            
            let gateway = PokemonGateway(client: clientMock)
            
            let expectation = self.expectation(description: "getting pokemon list")
            
            var gatewayReturn: GatewayError? = nil
                gateway.getPokemonList(0, 10).sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    gatewayReturn = error
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                
            }).store(in: &cancellableSet)
            
            waitForExpectations(timeout: 3, handler: nil)
            XCTAssertEqual(gatewayReturn, GatewayError.integrationErro(apiError.localizedDescription))
        }
    }
    
    func validateList(list: [PokemonListUntreatedModel], clientResult: ListResponse) -> Bool {
        var contains = true
        for item in clientResult.results {
            if !list.contains(where: { (model) -> Bool in
                return model.name == item.name && model.url == item.url
            }){
                contains = false
            }
        }
        return contains
    }
    
    func testAddPokemonFavoriteSuccess() throws {
        let clientMock = ApiClientMock()
        guard let response: PokemonDetailsResponse = testUtils.getJson(jsonName: "PokemonDetails") else {
            return XCTFail("invalid Json")
        }
        clientMock.favoriteResponse = ""
        
        let gateway = PokemonGateway(client: clientMock)
        
        let expectation = self.expectation(description: "add pokemon favorite")
        
        var gatewayReturn: String? = nil
        gateway.addFavoritePokemon(pokemon: PokemonModel(response: response)).sink(receiveCompletion: { _ in
        }, receiveValue: { result in
            gatewayReturn = result
            expectation.fulfill()
        }).store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        guard gatewayReturn != nil  else {
            XCTFail("gatewayReturn nil")
            return
        }
        
        XCTAssertEqual(gatewayReturn, "")
        
    }
    
    func testAddPokemonFavoriteError() throws {
        let clientMock = ApiClientMock()

        clientMock.pokemonDetailsResponse = nil
        guard let response: PokemonDetailsResponse = testUtils.getJson(jsonName: "PokemonDetails") else {
            return XCTFail("invalid Json")
        }
        for apiError:ApiError in [.decodingError, .responseError(10), .unexpectedError("teste"), .urlError] {
        
            clientMock.error = apiError
            
            let gateway = PokemonGateway(client: clientMock)
            
            let expectation = self.expectation(description: "add pokemon favorite")
            
            var gatewayReturn: GatewayError? = nil
                gateway.addFavoritePokemon(pokemon: PokemonModel(response: response)).sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    gatewayReturn = error
                    expectation.fulfill()
                case .finished:
                    expectation.fulfill()
                }
            }, receiveValue: { result in
                
            }).store(in: &cancellableSet)
        
            waitForExpectations(timeout: 3, handler: nil)
            XCTAssertEqual(gatewayReturn, GatewayError.integrationErro(apiError.localizedDescription))
        }
    }
}
