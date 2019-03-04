//
//  CriadorDeLeilao.swift
//  Leilao
//
//  Created by Katheryne Graf on 03/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class CriadorDeLeilao: NSObject {
    
    var leilao: Leilao!
    
    func para(_ descricao:String) -> Self{
        leilao = Leilao(descricao);
        return self;
    }
    
    func lance(_ usuario:Usuario, _ valor: Double) -> Self{
        leilao.propoe(lance: Lance(usuario, valor));
        return self;
    }

    func constroi() -> Leilao{
        return leilao;
    }
}
