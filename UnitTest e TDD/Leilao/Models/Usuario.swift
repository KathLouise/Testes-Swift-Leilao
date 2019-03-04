//
//  Usuario.swift
//  Leilao
//
//  Created by Ândriu Coelho on 27/04/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import Foundation

class Usuario: Equatable {
    
    let id:Int?
    let nome:String
    var qtdLances: Int
    
    init(id:Int? = nil, nome:String) {
        self.id = id
        self.nome = nome
        self.qtdLances = 0;
    }

}

func == (lhs: Usuario, rhs: Usuario) -> Bool {
    if ((lhs.id != rhs.id) || (lhs.nome != rhs.nome)){
        return false;
    }
    return true;
}
