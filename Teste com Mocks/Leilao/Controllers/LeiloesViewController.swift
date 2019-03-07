//
//  LeiloesViewController.swift
//  Leilao
//
//  Created by Katheryne Graf on 06/03/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class LeiloesViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Atributos
    
    private var listaDeLeilores:[Leilao] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - TableView Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDeLeilores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeilaoTableViewCell", for: indexPath);
        return cell;
    }
    
    // MARK: - Metodos
    
    func addLeilao(_ leilao: Leilao){
        listaDeLeilores.append(leilao);
    }
}
