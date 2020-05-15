//
//  GetPokemonListTest.swift
//  Pokedex_MatheusTests
//
//  Created by Matheus Cavalcante Teixeira on 14/05/20.
//  Copyright © 2020 Matheus Cavalcante Teixeira. All rights reserved.
//

import XCTest
import Combine

class GetPokemonListTest: XCTestCase {
    
    var cancellableSet: Set<AnyCancellable> = []
    
    func testGetPokemonListSuccess() throws {
        let gateway = PokemonGatewayMock()
        let usecase = GetPokemonList.init(gateway: gateway)
        
        gateway.pokemonList = [PokemonListUntreatedModel(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),PokemonListUntreatedModel(name: "ivybasaur", url: "https://pokeapi.co/api/v2/pokemon/2/")]
        
        let expectation = self.expectation(description: "getting pokemon list")
        
        
        var useCaseList: [PokemonListModel]?
        usecase.execute(0, 20).sink(receiveCompletion: { _ in
        }) { (list) in
            useCaseList = list
            expectation.fulfill()
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        guard let list = useCaseList else {
            XCTFail("useCaseList nil")
            return
        }
        XCTAssertEqual(list.count, gateway.pokemonList?.count)
        XCTAssertEqual(list[0].id, 1)
        XCTAssertEqual(list[0].name, gateway.pokemonList?[0].name)
        XCTAssertEqual(list[0].image, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        
    }
    
    func testGetPokemonListInvalidUrl() throws {
        let gateway = PokemonGatewayMock()
        let usecase = GetPokemonList.init(gateway: gateway)
        
        gateway.pokemonList = [PokemonListUntreatedModel(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/")]
        
        let expectation = self.expectation(description: "getting pokemon list")
        
        
        var useCaseList: [PokemonListModel]?
        usecase.execute(0, 20).sink(receiveCompletion: { _ in
        }) { (list) in
            useCaseList = list
            expectation.fulfill()
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        guard let list = useCaseList else {
            XCTFail("useCaseList nil")
            return
        }
        XCTAssertEqual(list.count, gateway.pokemonList?.count)
        XCTAssertEqual(list[0].id, 0)
        XCTAssertEqual(list[0].name, gateway.pokemonList?[0].name)
        XCTAssertEqual(list[0].image, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png")
        
    }
    
    func testGetPokemonError() throws {
        let gateway = PokemonGatewayMock()
        let usecase = GetPokemonList.init(gateway: gateway)
        
        gateway.pokemonList = nil
        gateway.error = GatewayError.integrationErro("teste")
        
        let expectation = self.expectation(description: "getting pokemon list")
        
        var useCaseError: UseCaseError?
        usecase.execute(0, 20).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                useCaseError = error
                expectation.fulfill()
            case .finished:
                expectation.fulfill()
            }
        }) { (list) in
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(useCaseError, UseCaseError.unexpectedError)
    }

}
