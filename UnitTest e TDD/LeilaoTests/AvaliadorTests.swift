//
//  AvaliadorTests.swift
//  LeilaoTests
//
//  Created by Katheryne Graf on 02/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class AvaliadorTests: XCTestCase {
    
    private var leiloeiro: Avaliador!;
    private var joao: Usuario!;
    private var jose: Usuario!;
    private var maria: Usuario!;

    override func setUp() {
        super.setUp();
        joao = Usuario(nome: "Joao");
        jose = Usuario(nome: "Jose");
        maria = Usuario(nome: "Maria");
        leiloeiro = Avaliador();
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLancesEmOrdemCrescente(){
        // Cenario
        let leilao = CriadorDeLeilao().para("Playstation 4")
                                      .lance(maria, 250.0)
                                      .lance(joao, 300.0)
                                      .lance(jose, 400.0).constroi();
        
        // Acao
        try? leiloeiro.avalia(leilao: leilao);
        
        // Validacao
        //Primeiro paramentro: o valor esperado
        //Segundo parametro: o valor obtido
        XCTAssertEqual(250, leiloeiro.menorLance());
        XCTAssertEqual(400, leiloeiro.maiorLance());
    }
    
    func testUmUnicoLance(){
        // Cenario
        let leilao = CriadorDeLeilao().para("Nintendo Switch")
                                      .lance(joao, 1500.0).constroi();
        
        //Acao
        try? leiloeiro.avalia(leilao: leilao);
        
        //Validacao
        XCTAssertEqual(1500.0, leiloeiro.menorLance());
        XCTAssertEqual(1500.0, leiloeiro.maiorLance());
        
    }
    
    func testListaComTresMaioresLances() {
        //Cenario
        let leilao = CriadorDeLeilao().para("Pokemon")
                                      .lance(joao, 500.0)
                                      .lance(maria, 600.0)
                                      .lance(joao, 550.0)
                                      .lance(maria, 650.0)
                                      .lance(joao, 700.0)
                                      .lance(maria, 710.0).constroi();
        
        //Acao
        try? leiloeiro.avalia(leilao: leilao);
        
        let tresMaioresLances = leiloeiro.listaComTresMaioresLances();
        
        //Validacao
        XCTAssertEqual(3, tresMaioresLances.count);
        XCTAssertEqual(710.0, tresMaioresLances[0].valor);
        XCTAssertEqual(700.0, tresMaioresLances[1].valor);
        XCTAssertEqual(650.0, tresMaioresLances[2].valor);
    }
    
    func testNaoDeveAvaliarLeilaoSemLances() {
        let mensagem = "Não é possivel avaliar um leilão sem Lances!"
        let leilao = CriadorDeLeilao().para("Playstation 4").constroi();
        
        XCTAssertThrowsError(try leiloeiro.avalia(leilao: leilao), mensagem) { (erro) in
            print(erro.localizedDescription);
        }
    }

}
