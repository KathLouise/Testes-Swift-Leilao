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
    private var encerradorDeLeilao: EncerradorDeLeilao!;
    private var fakeDao: MockLeilaoDao!;
    private var carteiroFake: MockCarteiro!;
    
    override func setUp() {
        super.setUp();
        //cria um formatador
        formatador = DateFormatter();
        //atribui o formato esperado
        formatador.dateFormat = "yyyy/MM/dd";
        //Cria um mock do banco de dados
        fakeDao = MockLeilaoDao().withEnabledSuperclassSpy();
        carteiroFake = MockCarteiro().withEnabledSuperclassSpy();
        encerradorDeLeilao = EncerradorDeLeilao(fakeDao, carteiroFake);
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
        
        //Ensina o mock a responder pelo metodo concorrentes
        stub(fakeDao) { (fakeDao) in
            when(fakeDao.correntes()).thenReturn(leiloes);
        }
        
        //Encerra os Leiloes
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

        stub(fakeDao) { (fakeDao) in
            when(fakeDao.correntes()).thenReturn([leilao3Ds])
        }
        
        encerradorDeLeilao.encerra();
        
        verify(fakeDao).atualiza(leilao: leilao3Ds);
    }
    
    func testContiaAExecucaoDepoisDeFalhaDoDanco(){
        guard let dataAntiga = formatador.date(from: "2019/02/01") else { return; }
        
        let leilaoPsVita = CriadorDeLeilao().para(descricao: "PS Vita").naData(data: dataAntiga).constroi();
        let leilaoPSP = CriadorDeLeilao().para(descricao: "PSP").naData(data: dataAntiga).constroi();
        
        let error = NSError(domain: "Error", code: 0, userInfo: nil);
        
        stub(fakeDao) { (fakeDao) in
            when(fakeDao.correntes()).thenReturn([leilaoPsVita, leilaoPSP]);
            when(fakeDao.atualiza(leilao: leilaoPsVita)).thenThrow(error);
        }
        
        encerradorDeLeilao.encerra();
        
        verify(fakeDao).atualiza(leilao: leilaoPSP);
        verify(carteiroFake).envia(leilaoPSP);
    }
}
