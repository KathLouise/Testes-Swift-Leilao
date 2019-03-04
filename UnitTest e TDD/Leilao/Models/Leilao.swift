//
//  Leilao.swift
//  Leilao
//
//  Created by Ândriu Coelho on 27/04/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import Foundation
import UIKit

class Leilao {
    
    let descricao:String
    let imagem:String?
    var lances:[Lance]?
    
    init(_ descricao:String, imagem:String? = nil, lances:[Lance] = []) {
        self.descricao = descricao
        self.imagem = imagem
        self.lances = lances
    }
    
    func propoe(lance:Lance) {
        guard let lancesDoLeilao = lances else { return; }
        
        qtdLancePorUsuario(lancesDoLeilao, lance.usuario);
        
        if((lancesDoLeilao.count == 0) || podeDarLance(lancesDoLeilao, lance.usuario)){
            lances?.append(lance)
        }
    }
    
    private func podeDarLance(_ lances: [Lance], _ usuario: Usuario) -> Bool{
        return lances.last?.usuario != usuario && usuario.qtdLances < 5;
    }
    
    private func qtdLancePorUsuario(_ lances: [Lance], _ usuario: Usuario){
        usuario.qtdLances = 0;
        for lance in lances{
            if(lance.usuario == usuario){
                usuario.qtdLances += 1;
            }
        }
    }
}
