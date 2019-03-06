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
    private var daoFake:MockLeilaoDao!;
    private var avaliador:Avaliador!;
    private var pagamento:MockRepositorioDePagamentos!;

    override func setUp() {
        super.setUp();
        daoFake = MockLeilaoDao().withEnabledSuperclassSpy();
        avaliador = Avaliador();
        pagamento = MockRepositorioDePagamentos().withEnabledSuperclassSpy();
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeraPagamentoParaUmLeilaoEncerrado(){
        let leilaoSwitch = CriadorDeLeilao().para(descricao: "Nintendo Switch")
            .lance(Usuario(nome: "Mario"), 2000.0)
            .lance(Usuario(nome: "Luigi"), 2500.0)
            .constroi();
        
        stub(daoFake) { (daoFake) in
            when(daoFake.encerrados()).thenReturn([leilaoSwitch]);
        }
        
        let geradorDePagamentos = GeradorDePagamentos(daoFake, avaliador, pagamento);
        geradorDePagamentos.gera();
        
        let capturadorArgumento = ArgumentCaptor<Pagamentos>();
        verify(pagamento).salva(capturadorArgumento.capture())
        
        let pagamentoGerado = capturadorArgumento.value;
        
        XCTAssertEqual(2500.0, pagamentoGerado?.getValor());
    }
    
    func testEmpurraADataParaPrimeiroDiaUtilDaSemanaSeguinte(){
        let leilaoWiiU = CriadorDeLeilao().para(descricao: "Nintendo Wii U")
            .lance(Usuario(nome: "Mario"), 2000.0)
            .lance(Usuario(nome: "Luigi"), 2500.0)
            .constroi();
        
        stub(daoFake) { (daoFake) in
            when(daoFake.encerrados()).thenReturn([leilaoWiiU]);
        }
        
        let formatadorData = DateFormatter();
        formatadorData.dateFormat = "yyyy/MM/dd";
        
        guard let dataAntiga = formatadorData.date(from: "2019/02/23") else { return; }
        
        let geradorDePagamentos = GeradorDePagamentos(daoFake, avaliador, pagamento, dataAntiga);
        geradorDePagamentos.gera();
        
        let capturadorArgumento = ArgumentCaptor<Pagamentos>();
        verify(pagamento).salva(capturadorArgumento.capture())
        
        let pagamentoGerado = capturadorArgumento.value;
        
        let formatadorDiaDaSemana = DateFormatter();
        formatadorDiaDaSemana.dateFormat = "ccc";
        
        guard let dataDoPagamento = pagamentoGerado?.getData() else { return; }
        let diaDaSemana = formatadorDiaDaSemana.string(from: dataDoPagamento);
        
        XCTAssertEqual("Mon", diaDaSemana);
    }

}
