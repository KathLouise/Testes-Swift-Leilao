//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Katheryne Graf on 04/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import XCTest
import Cuckoo
@testable import Leilao

extension Leilao: Matchable {
    public var matcher: ParameterMatcher<Leilao>{
        return equal(to: self);
    }
}

class EncerradorDeLeilaoTests: XCTestCase {
    
    private var formatador: DateFormatter!;
    
    override func setUp() {
        super.setUp();
        //cria um formatador
        formatador = DateFormatter();
        //atribui o formato esperado
        formatador.dateFormat = "yyyy/MM/dd";
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncerrarLeilaoAbertoAMaisDeUmaSemana(){
        //cria a data
        guard let dataAntiga = formatador.date(from: "2019/02/11") else { return; }
        
        let leilaoPlay4 = CriadorDeLeilao().para(descricao: "Playstation 4").naData(data: dataAntiga).constroi();
        let leilaoSwitch = CriadorDeLeilao().para(descricao: "Nintendo Switch").naData(data: dataAntiga).constroi();
        
        let leiloes = [leilaoPlay4, leilaoSwitch];
        
        //Cria um mock do banco de dados
        let fakeDao = MockLeilaoDao().withEnabledSuperclassSpy();
        //Ensina o mock a responder pelo metodo concorrentes
        stub(fakeDao) { (fakeDao) in
            when(fakeDao.correntes()).thenReturn(leiloes);
        }
        
        //Encerra os Leiloes
        let encerradorDeLeilao = EncerradorDeLeilao(fakeDao);
        encerradorDeLeilao.encerra();
        
        guard let statusLeilaoPlay4 = leilaoPlay4.isEncerrado() else { return; }
        guard let statuLeilaoSwitch = leilaoSwitch.isEncerrado() else { return; }
        
        //Verifica se estão mesmo encerrados
        XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados());
        XCTAssertTrue(statusLeilaoPlay4);
        XCTAssertTrue(statuLeilaoSwitch);
        
    }
    
    func testAtualizaLeiloesEncerrados(){
        guard let dataAntiga = formatador.date(from: "2019/02/11") else { return; }

        let leilao3Ds = CriadorDeLeilao().para(descricao: "Nintendo 3DS").naData(data: dataAntiga).constroi();
        
        let fakeDao = MockLeilaoDao().withEnabledSuperclassSpy();
        stub(fakeDao) { (fakeDao) in
            when(fakeDao.correntes()).thenReturn([leilao3Ds])
        }
        
        let encerradorDeLeilao = EncerradorDeLeilao(fakeDao);
        encerradorDeLeilao.encerra();
        
        verify(fakeDao).atualiza(leilao: leilao3Ds);
    }
}
