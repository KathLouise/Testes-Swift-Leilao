//
//  Avaliador.swift
//  Leilao
//
//  Created by Katheryne Graf on 02/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import Foundation

enum ErroAvaliador: Error{
    case LeilaoSemLances(String);
}

class Avaliador {
    
    // MARK: - Private variables
    private var maiorLanceDeTodos = Double.leastNonzeroMagnitude;
    private var menorLanceDeTodos = Double.greatestFiniteMagnitude;
    private var maioresValoresDeLances: [Lance] = [];
    
    // MARK: - Methods
    
    func avalia(leilao: Leilao) throws {
        let mensagem = "Não é possivel avaliar um leilão sem Lances!"
        if leilao.lances?.count == 0 {
            throw ErroAvaliador.LeilaoSemLances(mensagem);
        }
        
        guard let lances = leilao.lances else { return; }
        for lance in lances {
            if(lance.valor > maiorLanceDeTodos){
                maiorLanceDeTodos = lance.valor;
            }
            if(lance.valor < menorLanceDeTodos){
                menorLanceDeTodos = lance.valor;
            }
        }
        pegaMaioresLancesDoLeilao(leilao);
    }
    
    private func pegaMaioresLancesDoLeilao (_ leilao: Leilao){
        guard let lances = leilao.lances else { return; }
        
        maioresValoresDeLances = lances.sorted { (listaLances1, listaLances2) -> Bool in
            return listaLances1.valor > listaLances2.valor;
        }
        
        let maioresLances = maioresValoresDeLances.prefix(3);
        maioresValoresDeLances = Array(maioresLances);
    }
    
    // MARK: - Get Values
    
    func maiorLance() -> Double {
        return maiorLanceDeTodos;
    }
    
    func menorLance() -> Double{
        return menorLanceDeTodos;
    }
    
    func listaComTresMaioresLances() -> [Lance]{
        return maioresValoresDeLances
    }
    
}
