//
//  MusicasDentroPlaylistViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 15/11/23.
//

import UIKit

class MusicasDentroPlaylistViewController: UIViewController {
    var AdicionarMusicasPlaylistViewControl:AdicionarMusicasPlaylistViewController!
    var PlaylistTag: Int!
    var TabBarControl: TabBarController!
    var PlaylistMusicasViewControl: PlaylistMusicasViewController!
    
    func setTabBarControl(TabBarControl: TabBarController){
        self.TabBarControl = TabBarControl
    }
    
    func setPlaylistMusicasViewControl(PlaylistMusicasViewControl: PlaylistMusicasViewController){
        self.PlaylistMusicasViewControl = PlaylistMusicasViewControl
    }
    
    struct Playlists: Codable { // Codable // Encodable // Decodable
        var Nome : String
        var Musicas : [String]
    }
    
    struct Listas: Codable {
        var Playlists : [Playlists]
    }
    
    lazy var BotaoVoltar: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        bt.tintColor = UIColor(red: 110, green: 110, blue: 110, a: 1)
        bt.addTarget(self, action: #selector(self.BotaoVoltarFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    lazy var LabelNomePlaylist: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        lb.text = ""
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .center
        
        return lb
    }()
    
    lazy var BotaoAdicionarMusica: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(UIImage(systemName: "plus"), for: .normal)
        bt.tintColor = UIColor(red: 110, green: 110, blue: 110, a: 1)
        bt.addTarget(self, action: #selector(self.BotaoAdicionarMusicaFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    //lazy serve para usar o self dentro da variavel
    lazy var AreaNomePlaylist: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.BotaoVoltar)
        sv.addArrangedSubview(self.LabelNomePlaylist)
        sv.addArrangedSubview(self.BotaoAdicionarMusica)
        
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(5, after: BotaoVoltar)
        sv.setCustomSpacing(5, after: LabelNomePlaylist)
        
        return sv
    }()
    
    var ScrollListaMusicas: UIScrollView = {
        let sw = UIScrollView()
        sw.translatesAutoresizingMaskIntoConstraints = false
        
        return sw
    }()

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 185, green: 185, blue: 185, a: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.AreaNomePlaylist)
        view.addSubview(self.ScrollListaMusicas)
        
        let espacamentoPadrao = 10.0
        let tamanhoPadrao = 35.0
        
        let tamanhoPadraoBotoes = 45.0
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.AreaNomePlaylist.topAnchor.constraint(equalTo: margins.topAnchor, constant: espacamentoPadrao ), // ),//
            self.AreaNomePlaylist.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.AreaNomePlaylist.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.AreaNomePlaylist.heightAnchor.constraint(equalToConstant: tamanhoPadrao), //
            
            self.BotaoVoltar.widthAnchor.constraint(equalToConstant: tamanhoPadraoBotoes),
            self.BotaoAdicionarMusica.widthAnchor.constraint(equalToConstant: tamanhoPadraoBotoes),
            
            self.ScrollListaMusicas.topAnchor.constraint(equalTo: self.AreaNomePlaylist.bottomAnchor, constant: espacamentoPadrao), // ),//
            self.ScrollListaMusicas.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.ScrollListaMusicas.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.ScrollListaMusicas.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: espacamentoPadrao * (-1)), // ),//
        ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setLabelNomePlaylist(nome:String){
        self.LabelNomePlaylist.text = nome
    }
    
    public func setPlaylistTag(tag:Int){
        self.PlaylistTag = tag
    }
    
    func CriarListaPlaylists(){
        let ConteinerPlaylistsView: UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
    
        self.ScrollListaMusicas.addSubview(ConteinerPlaylistsView)
    
        let vConst = ConteinerPlaylistsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        vConst.isActive = true
        vConst.priority = UILayoutPriority(50)
    
    
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            ConteinerPlaylistsView.topAnchor.constraint(equalTo: self.ScrollListaMusicas.topAnchor),
            ConteinerPlaylistsView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            ConteinerPlaylistsView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            ConteinerPlaylistsView.bottomAnchor.constraint(equalTo: self.ScrollListaMusicas.bottomAnchor),
        ])
    
        let ListaDeButton: [UIStackView] = {
            var lista:[UIStackView] = []
            var itemIndex = 0

            if self.PlaylistMusicasViewControl.ListaMusicas.count > 0 {
                for item in self.PlaylistMusicasViewControl.ListaMusicas{
                    if(item != ".DS_Store" && item != "Playlists"){
                        let ViewStack = UIStackView()
                        
                        let bt = UIButton()
                        bt.translatesAutoresizingMaskIntoConstraints = false
                        bt.tag = itemIndex
                        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 14)
                        bt.layer.cornerRadius = 5
                        bt.backgroundColor = UIColor(red: 35, green: 35, blue: 35, a: 0.7)
                        let item_str = item//.prefix(35)
                        bt.setTitle("\(item_str)", for: .normal)
                        bt.addTarget(self, action: #selector(self.BotaoTocarMusicaFunc), for: .touchUpInside)
                        
                        ViewStack.addArrangedSubview(bt)
                        
                        ViewStack.translatesAutoresizingMaskIntoConstraints = false
                        ViewStack.axis = .horizontal
                        ViewStack.distribution = .fill
                        ViewStack.alignment = .fill
                        
                        ViewStack.setCustomSpacing(3, after: bt)
                        
                        lista.append(ViewStack)
                        itemIndex = itemIndex + 1
                    }
                }
            }
            return lista
        }()
    
        for x in stride(from:0,to: ListaDeButton.count, by: 1){
            ConteinerPlaylistsView.addSubview(ListaDeButton[x])
            if(x == 0){
                NSLayoutConstraint.activate([
                    ListaDeButton[0].topAnchor.constraint(equalTo: ConteinerPlaylistsView.topAnchor, constant: 3),
                    ListaDeButton[0].leadingAnchor.constraint(equalTo: ConteinerPlaylistsView.leadingAnchor),
                    ListaDeButton[0].trailingAnchor.constraint(equalTo: ConteinerPlaylistsView.trailingAnchor),
                ])
            } else{
                NSLayoutConstraint.activate([
                    ListaDeButton[x].topAnchor.constraint(equalTo: ListaDeButton[x - 1].bottomAnchor, constant: 3),
                    ListaDeButton[x].leadingAnchor.constraint(equalTo: ConteinerPlaylistsView.leadingAnchor),
                    ListaDeButton[x].trailingAnchor.constraint(equalTo: ConteinerPlaylistsView.trailingAnchor),
                ])
            }
        }
    
        if(ListaDeButton.count > 0){
            // se eu quiser pegar informações do NovoScrollViewItens durante a inicialização, preciso utilizar esse codigo para conseguir obter informações
            ListaDeButton[0].layoutIfNeeded()
            self.ScrollListaMusicas.layoutIfNeeded()
            ConteinerPlaylistsView.layoutIfNeeded()
    
            let tamanhoAreaScroll = CGFloat(self.ScrollListaMusicas.frame.size.height)//- self.TamanhoTabBar
    
            let base = 3
            let QuantosCabemDentroDoScroll = Int(tamanhoAreaScroll/(CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base)))
            let adicionar = CGFloat(ListaDeButton.count - QuantosCabemDentroDoScroll) * (CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base))
            let porcentagem = (((adicionar / tamanhoAreaScroll) * 100.0 ) / 100)
    
            if (self.PlaylistMusicasViewControl.ListaMusicas.count * (Int(ListaDeButton[0].frame.size.height) + base) <= Int(tamanhoAreaScroll)) {
                NSLayoutConstraint.activate([
                    ConteinerPlaylistsView.heightAnchor.constraint(equalTo: self.ScrollListaMusicas.heightAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    ConteinerPlaylistsView.heightAnchor.constraint(equalTo: self.ScrollListaMusicas.heightAnchor, multiplier: porcentagem + 1),
                ])
            }
            ConteinerPlaylistsView.layoutIfNeeded()
            self.ScrollListaMusicas.layoutIfNeeded()
        }
    }
    
    var PlayerMusicaViewControl: PlayerMusicaViewController!
    
    @objc func BotaoTocarMusicaFunc(sender:UIButton){
        self.PlayerMusicaViewControl = PlayerMusicaViewController()
        self.PlayerMusicaViewControl.loadViewIfNeeded()
        self.PlayerMusicaViewControl.modalPresentationStyle = .overFullScreen
        self.present(self.PlayerMusicaViewControl, animated: true, completion: nil)
        
        self.PlayerMusicaViewControl.setTabBarControl(TabBarControl: self.TabBarControl)
        self.PlayerMusicaViewControl.Musica(Musicas: self.PlaylistMusicasViewControl.ListaMusicas, index:sender.tag)
        self.PlayerMusicaViewControl.Inicial()
        
        self.TabBarControl.AdcionarMiniPlayer()
        self.TabBarControl.SetPlayerMusicaViewControl(player: self.PlayerMusicaViewControl)        
    }

    @objc func BotaoVoltarFunc(){
        self.dismiss(animated: true, completion: nil)
        //self.PlaylistMusicasViewControl.loadViewIfNeeded()
        //self.PlaylistMusicasViewControl.modalPresentationStyle = .overCurrentContext
        //self.present(self.PlaylistMusicasViewControl, animated: true, completion: nil)
    }
    
    @objc func BotaoAdicionarMusicaFunc(){
        self.AdicionarMusicasPlaylistViewControl = AdicionarMusicasPlaylistViewController()
        self.AdicionarMusicasPlaylistViewControl.loadViewIfNeeded()
        self.AdicionarMusicasPlaylistViewControl.modalPresentationStyle = .overCurrentContext
        self.present(self.AdicionarMusicasPlaylistViewControl, animated: true, completion: nil)
        self.AdicionarMusicasPlaylistViewControl.MusicasDentroPlaylistViewControl = self
        self.AdicionarMusicasPlaylistViewControl.CriarListaMusicas(lista: self.PlaylistMusicasViewControl.ListaMusicas)
        self.AdicionarMusicasPlaylistViewControl.setTabBarControl(TabBarControl: self.TabBarControl)
        self.AdicionarMusicasPlaylistViewControl.CriarListaPlaylists()
    }
}
