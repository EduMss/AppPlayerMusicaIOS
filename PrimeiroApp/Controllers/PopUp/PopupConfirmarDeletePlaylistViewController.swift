//
//  PopupConfirmarDeletePlaylistViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 22/11/23.
//

import UIKit

class PopupConfirmarDeletePlaylistViewController: UIViewController {
    
    var Tag: Int!
    
    func setTag(tag:Int){
        self.Tag = tag
    }
    
    var PlaylistMusicaViewControl: PlaylistMusicasViewController!
    
    func setPlaylistMusicaViewControl(playlistMusicaViewControl:PlaylistMusicasViewController){
        self.PlaylistMusicaViewControl = playlistMusicaViewControl
    }
    
    lazy var BotaoFechar: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(red: 0, green: 0, blue: 0, a: 0.5)
        
        bt.addTarget(self, action: #selector(self.BotaoFecharFunc), for: .touchUpInside)
        
        return bt
    }()
    
    
    
    var LabelTexto: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Deseja realmente apagar?"
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textColor = UIColor(red: 20, green: 20, blue: 20)
        
        return lb
    }()

    lazy var BotaoCancelar: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setTitle("Cancelar", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20), for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        bt.addTarget(self, action: #selector(self.BotaoFecharFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    lazy var BotaoDeletar: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setTitle("Deletar", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20), for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        bt.addTarget(self, action: #selector(self.BotaoDeletarFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
        bt.backgroundColor = UIColor(red: 255, green: 30, blue: 30)
    
        return bt
    }()
    
    //lazy serve para usar o self dentro da variavel
    lazy var AreaBotoes: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.BotaoCancelar)
        sv.addArrangedSubview(self.BotaoDeletar)
        
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.setCustomSpacing(10, after: BotaoCancelar)

        return sv
    }()
    
    @objc func BotaoDeletarFunc(){
        self.PlaylistMusicaViewControl.ConfirmarDeletePlaylist(Tag: self.Tag)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var ViewBase: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor(red: 200, green: 200, blue: 200, a: 1.0)
        
        return v
    }()
    
    lazy var ItensDentroDoView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor(red: 200, green: 200, blue: 200, a: 1.0)
        sv.layer.cornerRadius = 5
        
        sv.addArrangedSubview(self.LabelTexto)
        sv.addArrangedSubview(self.AreaBotoes)
        
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(15, after: self.LabelTexto)
        return sv
    }()
    
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .clear
        
        view.addSubview(self.BotaoFechar)
        view.addSubview(self.ViewBase)
        view.addSubview(self.ItensDentroDoView)
        
        
       NSLayoutConstraint.activate([
           self.BotaoFechar.topAnchor.constraint(equalTo: view.topAnchor),
           self.BotaoFechar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           self.BotaoFechar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           self.BotaoFechar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           
           self.ItensDentroDoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           self.ItensDentroDoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           self.ItensDentroDoView.widthAnchor.constraint(equalToConstant: 230),
           self.ItensDentroDoView.heightAnchor.constraint(equalToConstant: 130),
           
           self.ViewBase.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           self.ViewBase.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           self.ViewBase.widthAnchor.constraint(equalToConstant: 250),
           self.ViewBase.heightAnchor.constraint(equalToConstant: 150),
        ])
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc func BotaoFecharFunc(){
        self.dismiss(animated: true, completion: nil)
    }
}
