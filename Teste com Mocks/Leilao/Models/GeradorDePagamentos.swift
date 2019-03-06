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
    private var data: Date;
    
    init(_ leiloes: LeilaoDao, _ avaliador: Avaliador, _ repositorioDePagamentos: RepositorioDePagamentos, _ data: Date) {
        self.leiloes = leiloes;
        self.avaliador = avaliador;
        self.repositorioDePagamentos = repositorioDePagamentos;
        self.data = data;
    }
    
    convenience init(_ leiloes: LeilaoDao, _ avaliador: Avaliador, _ repositorioDePagamentos: RepositorioDePagamentos) {
        self.init(leiloes, avaliador, repositorioDePagamentos, Date());
    }
    
    func gera(){
        let leiloesEncerrados = self.leiloes.encerrados();
        
        for leilao in leiloesEncerrados {
            try? avaliador.avalia(leilao: leilao);
            
            let novoPagamento = Pagamentos(avaliador.maiorLance(), proximoDiaUtil());
            repositorioDePagamentos.salva(novoPagamento);
        }
        
    }
    
    func proximoDiaUtil() -> Date{
        var dataAtual = data;
        
        while Calendar.current.isDateInWeekend(dataAtual){
            dataAtual = Calendar.current.date(byAdding: .day, value: 1, to: dataAtual)!
        }
        return dataAtual;
    }
}
