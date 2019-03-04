//
//  LeilaoTests.swift
//  LeilaoTests
//
//  Created by Ândriu Coelho on 27/04/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class LeilaoTests: XCTestCase {
    private var mario: Usuario!;
    private var luigi: Usuario!;
    
    override func setUp() {
        super.setUp()
        mario = Usuario(nome: "Mario");
        luigi = Usuario(nome: "Luigi");
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLeilaoComUmUnicoLance() {
        let leilao = CriadorDeLeilao().para("Playstation 4").constroi();
        XCTAssertEqual(0, leilao.lances?.count);
        
        leilao.propoe(lance: Lance(mario, 1000.0));
        
        XCTAssertEqual(1, leilao.lances?.count);
        XCTAssertEqual(1000.0, leilao.lances?[0].valor);
    }
    
    func testLeilaoComVariosLances(){
        let leilao = CriadorDeLeilao().para("Nintendo Wii")
            .lance(mario, 1000.0)
            .lance(luigi, 1500.0).constroi();
        
        XCTAssertEqual(2, leilao.lances?.count);
        XCTAssertEqual(1000.0, leilao.lances?[0].valor);
        XCTAssertEqual(1500.0, leilao.lances?[1].valor);
    }
    
    func testErroAoAdicionarDoisLancesSeguidosDoMesmoUsuario(){
        let leilao = CriadorDeLeilao().para("Nintendo WiiU")
            .lance(mario, 1000.0)
            .lance(mario, 1500.0).constroi();
        
        XCTAssertEqual(1, leilao.lances?.count);
        XCTAssertEqual(1000.0, leilao.lances?[0].valor);
    }
    
    func testErroAoAdicionarMaisdeCincoLancesPorUsuario(){
        let leilao = CriadorDeLeilao().para("Nintendo 3DS")
            .lance(mario, 1000.0)
            .lance(luigi, 1500.0)
            .lance(mario, 2000.0)
            .lance(luigi, 2500.0)
            .lance(mario, 3000.0)
            .lance(luigi, 3500.0)
            .lance(mario, 4000.0)
            .lance(luigi, 4500.0)
            .lance(mario, 5000.0)
            .lance(luigi, 5500.0)
            .lance(mario, 6000.0).constroi();
        
        XCTAssertEqual(10, leilao.lances?.count);
        XCTAssertEqual(5500.0, leilao.lances?.last?.valor);
    }
}
