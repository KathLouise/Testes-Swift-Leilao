//
//  Pagamentos.swift
//  Leilao
//
//  Created by Katheryne Graf on 05/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import Foundation

class Pagamentos {
    private var valor:Double;
    private var data:Date;
    
    init(_ valor:Double, _ data:Date) {
        self.valor = valor;
        self.data = data;
    }
    
    func getValor() -> Double{
        return valor;
    }
    
    func getData() -> Date{
        return data;
    }
}
