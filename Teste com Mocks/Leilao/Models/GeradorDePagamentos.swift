//
//  GeradorDePagamentos.swift
//  Leilao
//
//  Created by Katheryne Graf on 05/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import Foundation

class GeradorDePagamentos {
    private var leiloes: LeilaoDao;
    private var avaliador: Avaliador;
    private var repositorioDePagamentos: RepositorioDePagamentos;
    
    init(_ leiloes: LeilaoDao, _ avaliador: Avaliador, _ repositorioDePagamentos: RepositorioDePagamentos) {
        self.leiloes = leiloes;
        self.avaliador = avaliador;
        self.repositorioDePagamentos = repositorioDePagamentos;
    }
    
    func gera(){
        let leiloesEncerrados = self.leiloes.encerrados();
        
        for leilao in leiloesEncerrados {
            try? avaliador.avalia(leilao: leilao);
            
            let novoPagamento = Pagamentos(avaliador.maiorLance(), Date());
            repositorioDePagamentos.salva(novoPagamento);
        }
        
    }
}
