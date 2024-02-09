//
//  PlayerViewControll.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 02/11/23.
//

import UIKit


class PlayerViewControll2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //self.view.backgroundColor = .systemRed
        
        //para não fechar a pagina quando arrastar para baixo
        self.isModalInPresentation = true
        
    }
    @IBAction func FecharJanela(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

