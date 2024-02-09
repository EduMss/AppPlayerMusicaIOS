//
//  AdicionarMusicasPlaylistViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 15/11/23.
//

import UIKit

class AdicionarMusicasPlaylistViewController: UIViewController {
    var ListaMusicas: [String]!
    var MusicasDentroPlaylistViewControl: MusicasDentroPlaylistViewController!
    
    var TabBarControl: TabBarController!
    func setTabBarControl(TabBarControl: TabBarController){
        self.TabBarControl = TabBarControl
    }
    
    struct Playlists: Codable { // Codable // Encodable // Decodable
        var Nome : String
        var Musicas : [String]
    }
    
    struct Listas: Codable {
        var Playlists : [Playlists]
    }
    
    var LabelInfo: UILabel = {
        let lb = UILabel()
        
        return lb
    }()
    
    var Arquivos: [String] = {
        var arquivoView: [String] = []
        let fm = FileManager.default
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let items = try fm.contentsOfDirectory(atPath: path.path())
            print()
            for item in items {
                if(item != ".DS_Store" && item != "Playlists"){
                    arquivoView.append(item)
                }
            }
        } catch {
        }
        
        return arquivoView
    }()
    
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
    
    //lazy serve para usar o self dentro da variavel
    lazy var AreaNomePlaylist: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.BotaoVoltar)
        sv.addArrangedSubview(self.LabelNomePlaylist)
        
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
    
    lazy var BotaoSalvar:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Salvar", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20, a: 1), for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 16)
        bt.addTarget(self, action: #selector(self.BotaoSalvarFunc), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
        
        return bt
    }()

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 185, green: 185, blue: 185, a: 1)
        
        view.addSubview(self.AreaNomePlaylist)
        view.addSubview(self.ScrollListaMusicas)
        view.addSubview(self.BotaoSalvar)
        
        let espacamentoPadrao = 10.0
        let tamanhoPadrao = 35.0
        
        let tamanhoPadraoBotoes = 45.0
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.AreaNomePlaylist.topAnchor.constraint(equalTo: margins.topAnchor, constant: espacamentoPadrao),
            self.AreaNomePlaylist.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.AreaNomePlaylist.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.AreaNomePlaylist.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            
            self.BotaoVoltar.widthAnchor.constraint(equalToConstant: tamanhoPadraoBotoes),
            
            self.BotaoSalvar.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            self.BotaoSalvar.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.BotaoSalvar.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.BotaoSalvar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50),
            
            self.ScrollListaMusicas.topAnchor.constraint(equalTo: self.AreaNomePlaylist.bottomAnchor, constant: espacamentoPadrao),
            self.ScrollListaMusicas.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.ScrollListaMusicas.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.ScrollListaMusicas.bottomAnchor.constraint(equalTo: self.BotaoSalvar.topAnchor),
        ])
        //ScrollListaMusicas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func CriarListaMusicas(lista: [String]){
        self.ListaMusicas = lista
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
            for item in Arquivos{
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
                    
                    let bt_func = UIButton()
                    bt_func.translatesAutoresizingMaskIntoConstraints = false
                    bt_func.tag = itemIndex
                    bt_func.tintColor = UIColor(red: 210, green: 210, blue: 210, a: 1)
                    bt_func.layer.cornerRadius = 5
                    
                    
                    NSLayoutConstraint.activate([
                        bt_func.widthAnchor.constraint(equalToConstant: 40)
                    ])
                    
                    ViewStack.addArrangedSubview(bt)
                    if self.ListaMusicas.contains(item) {
                        bt_func.setImage(UIImage(systemName: "trash"), for: .normal)
                        bt_func.addTarget(self, action: #selector(self.BotaoRemoverMusicaFunc), for: .touchUpInside)
                        bt_func.backgroundColor = UIColor(red: 200, green: 30, blue: 30, a: 0.5)
                    } else {
                        bt_func.setImage(UIImage(systemName: "plus"), for: .normal)
                        bt_func.addTarget(self, action: #selector(self.BotaoAdicionarMusicaFunc), for: .touchUpInside)
                        bt_func.backgroundColor = UIColor(red: 30, green: 200, blue: 30, a: 0.5)
                    }
                    
                    ViewStack.addArrangedSubview(bt_func)
                    
                    ViewStack.translatesAutoresizingMaskIntoConstraints = false
                    ViewStack.axis = .horizontal
                    ViewStack.distribution = .fill
                    ViewStack.alignment = .fill
                    
                    ViewStack.setCustomSpacing(3, after: bt)
                    
                    lista.append(ViewStack)
                    itemIndex = itemIndex + 1
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
            
            let tamanhoAreaScroll = CGFloat(self.ScrollListaMusicas.frame.size.height) - (self.MusicasDentroPlaylistViewControl.PlaylistMusicasViewControl.TamanhoTabBar/2) - 20
            
            let base = 3
            let QuantosCabemDentroDoScroll = Int(tamanhoAreaScroll/(CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base)))
            let adicionar = CGFloat(ListaDeButton.count - QuantosCabemDentroDoScroll) * (CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base))
            let porcentagem = (((adicionar / tamanhoAreaScroll) * 100.0 ) / 100)
            
            if (Arquivos.count * (Int(ListaDeButton[0].frame.size.height) + base) <= Int(tamanhoAreaScroll)) {
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
    
    @objc func BotaoRemoverMusicaFunc(sender:UIButton){
        self.ListaMusicas.removeAll(where: { $0 == Arquivos[sender.tag] } )
        
        sender.setImage(UIImage(systemName: "plus"), for: .normal)
        sender.addTarget(self, action: #selector(self.BotaoAdicionarMusicaFunc), for: .touchUpInside)
        sender.backgroundColor = UIColor(red: 30, green: 200, blue: 30, a: 0.5)
    }
    
    @objc func BotaoAdicionarMusicaFunc(sender:UIButton){
        self.ListaMusicas.append(Arquivos[sender.tag])
        
        sender.setImage(UIImage(systemName: "trash"), for: .normal)
        sender.addTarget(self, action: #selector(self.BotaoRemoverMusicaFunc), for: .touchUpInside)
        sender.backgroundColor = UIColor(red: 200, green: 30, blue: 30, a: 0.5)
    }

    @objc func BotaoVoltarFunc(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func BotaoSalvarFunc(){
        self.MusicasDentroPlaylistViewControl.PlaylistMusicasViewControl.SalvarMusicasPlaylist(PlaylistTag:self.MusicasDentroPlaylistViewControl.PlaylistTag, Musicas:self.ListaMusicas)
        self.MusicasDentroPlaylistViewControl.PlaylistMusicasViewControl.AtualizarLista(PlaylistTag:self.MusicasDentroPlaylistViewControl.PlaylistTag)
        self.dismiss(animated: true, completion: nil)
        
        for subview in self.MusicasDentroPlaylistViewControl.ScrollListaMusicas.subviews{
            subview.removeFromSuperview()
        }
        
        self.TabBarControl.vc4.ListaMusica = self.ListaMusicas
        
        self.MusicasDentroPlaylistViewControl.CriarListaPlaylists()
    }
    
    
}
