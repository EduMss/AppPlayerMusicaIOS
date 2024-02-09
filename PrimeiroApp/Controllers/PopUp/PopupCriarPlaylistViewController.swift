//
//  PopupCriarPlaylistViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 15/11/23.
//

import UIKit

class PopupCriarPlaylistViewController: UIViewController, UITextFieldDelegate {
    var PlaylistMusicasViewControl: PlaylistMusicasViewController!
    
    func setPlaylistMusicasViewControl(PlaylistMusicasViewControl: PlaylistMusicasViewController){
        self.PlaylistMusicasViewControl = PlaylistMusicasViewControl
    }
    
    lazy var BotaoFechar: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(red: 0, green: 0, blue: 0, a: 0.5)
        
        bt.addTarget(self, action: #selector(self.BotaoFecharFunc), for: .touchUpInside)
        
        return bt
    }()
    
    @objc func BotaoFecharFunc(){
        self.dismiss(animated: true, completion: nil)
    }
    
    var LabelNomePlaylist: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        lb.text = "Nome da Playlist:"
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .left
        
        return lb
    }()
    
    var InputNomePlaylist: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        tf.backgroundColor = UIColor(red: 235, green: 235, blue: 235)
        tf.layer.cornerRadius = 5
        tf.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        return tf
    }()
    
    lazy var BotaoApagarNomePlaylist: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setTitle("<-", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20), for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        bt.addTarget(self, action: #selector(BotaoApagarNomePlaylistFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    //lazy serve para usar o self dentro da variavel
    lazy var ApreaNomePlaylist: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.InputNomePlaylist)
        sv.addArrangedSubview(self.BotaoApagarNomePlaylist)
        
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(5, after: InputNomePlaylist)

        return sv
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
    
    lazy var BotaoCriar: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setTitle("Criar", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20), for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        bt.addTarget(self, action: #selector(self.BotaoCriarFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    //lazy serve para usar o self dentro da variavel
    lazy var AreaBotoes: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.BotaoCancelar)
        sv.addArrangedSubview(self.BotaoCriar)
        
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.setCustomSpacing(10, after: BotaoCancelar)

        return sv
    }()
    
    @objc func BotaoCriarFunc(){
        self.PlaylistMusicasViewControl.AdicionarPlaylist(NomePlaylist: String("\(self.InputNomePlaylist.text!)"))
        self.PlaylistMusicasViewControl.AtualizarPlaylist()
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
        
        sv.addArrangedSubview(self.LabelNomePlaylist)
        sv.addArrangedSubview(self.ApreaNomePlaylist)
        sv.addArrangedSubview(self.AreaBotoes)
        
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(15, after: ApreaNomePlaylist)
        return sv
    }()
    
    @objc func BotaoApagarNomePlaylistFunc(){
        self.InputNomePlaylist.text = ""
    }
    
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
        self.InputNomePlaylist.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //ao clicar fora do teclado, ira fechalo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.InputNomePlaylist.resignFirstResponder()//fechar o teclado
    }
    
    //quando clicar em "Done" no teclado essa função sera executada, posso colocar aqui tambem para rodar o codigo de baixar o video/musica aqui
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.InputNomePlaylist.resignFirstResponder()//fechar o teclado
        return true
    }

}
