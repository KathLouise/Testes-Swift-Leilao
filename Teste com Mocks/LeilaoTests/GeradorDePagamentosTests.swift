//
//  GeradorDePagamentosTests.swift
//  LeilaoTests
//
//  Created by Katheryne Graf on 05/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import XCTest
import Cuckoo
@testable import Leilao

class GeradorDePagamentosTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeraPagamentoParaUmLeilaoEncerrado(){
        let leilaoSwitch = CriadorDeLeilao().para(descricao: "Nintendo Switch")
            .lance(Usuario(nome: "Mario"), 2000.0)
            .lance(Usuario(nome: "Luigi"), 2500.0)
            .constroi();
        
        let daoFake = MockLeilaoDao().withEnabledSuperclassSpy();
        stub(daoFake) { (daoFake) in
            when(daoFake.encerrados()).thenReturn([leilaoSwitch]);
        }
        
        let avaliador = Avaliador();
        
        let pagamento = MockRepositorioDePagamentos().withEnabledSuperclassSpy();
        let geradorDePagamentos = GeradorDePagamentos(daoFake, avaliador, pagamento);
        geradorDePagamentos.gera();
        
        let capturadorArgumento = ArgumentCaptor<Pagamentos>();
        verify(pagamento).salva(capturadorArgumento.capture())
        
        let pagamentoGerado = capturadorArgumento.value;
        
        XCTAssertEqual(2500.0, pagamentoGerado?.getValor());
    }

}
