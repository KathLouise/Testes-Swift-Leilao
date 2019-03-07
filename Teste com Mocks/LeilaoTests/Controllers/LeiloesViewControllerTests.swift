//
//  LeiloesViewControllerTests.swift
//  LeilaoTests
//
//  Created by Katheryne Graf on 06/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

extension LeiloesViewControllerTests{
    class MockTableView: UITableView {
        var celulaReutilizada = false;
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            celulaReutilizada = true;
            return super.dequeueReusableCell(withIdentifier: "LeilaoTableViewCell", for: indexPath);
        }
    }
}

class LeiloesViewControllerTests: XCTestCase {
    private var sut:LeiloesViewController!;
    private var tableView:UITableView!;

    override func setUp() {
        super.setUp();
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? LeiloesViewController;
        _ = sut.view
        tableView = sut.tableView;
        //quem implementa o datasource dela é o sut
        tableView.dataSource = sut;
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableViewNaoPodeEstarVaziaAposViewDidLoad() {
        //Executa o metodo ViewDidLoad
        _ = sut.view
        
        XCTAssertNotNil(sut.tableView);
    }
    
    func testVerificaSeDataSourceDaTableViewNaoENil(){
        _ = sut.view;
        
        //Verifica se o dataSourece da tableView esta sendo implementado
        XCTAssertNotNil(sut.tableView.dataSource);
        //Verifica se quem esta implementsando é a ViewController certa
        XCTAssertNotNil(sut.tableView.dataSource is LeiloesViewController);
    }
    
    func testNumberOfRowsInSectionDeveSerAQuantidadeDeLeiloesDaLista(){
        sut.addLeilao(Leilao(descricao: "Nintendo 64"));
        XCTAssertEqual(1, tableView.numberOfRows(inSection: 0));
        
        sut.addLeilao(Leilao(descricao: "Playstation 2"));
        tableView.reloadData();
        XCTAssertEqual(2, tableView.numberOfRows(inSection: 0));
    }
    
    func testCellForRowDeveRetornarLeilaoTableViewCell(){
        sut.addLeilao(Leilao(descricao: "Playstation 1"));
        
        tableView.reloadData();
        
        let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0));
        XCTAssertTrue(cell is LeilaoTableViewCell)
    }
    
    func testCellForRowDeveReutilizarCelulasComDequeueReusableCell(){
        let mockTableView = MockTableView();
        mockTableView.dataSource = sut;
        
        mockTableView.register(LeilaoTableViewCell.self, forCellReuseIdentifier: "LeilaoTableViewCell");
        
        sut.addLeilao(Leilao(descricao: "PS Vita"));
        mockTableView.reloadData();
        
        _ = mockTableView.cellForRow(at: IndexPath(item: 0, section: 0));
        
        XCTAssertTrue(mockTableView.celulaReutilizada);
    }

}
