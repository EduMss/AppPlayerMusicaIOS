//
//  PlaylistMusicasViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 11/11/23.
//

import UIKit
import Foundation

class PlaylistMusicasViewController: UIViewController {
    
    var ListaMusicas: [String]!
    var TamanhoTabBar: CGFloat!
    
    var tabBarControl: TabBarController!
    public func setTabBarControl(TabBarControl:TabBarController!){
        self.tabBarControl = TabBarControl
    }
    
    func setListaMusicas(Lista:[String]){
        self.ListaMusicas = Lista
    }
    
    struct Playlists: Codable { // Codable // Encodable // Decodable
        var Nome : String
        var Musicas : [String]
    }
    
    struct Listas: Codable {
        var Playlists : [Playlists]
    }
    
    
    lazy var BotaoCriarPlaylist: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Criar Playlist", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20, a: 1), for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 16)
        bt.addTarget(self, action: #selector(self.BotaoCriarPlaylistFunc), for: .touchUpInside)
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
        
        return bt
    }()
    
    var ScrollPlayList: UIScrollView = {
        let sw = UIScrollView()
        sw.translatesAutoresizingMaskIntoConstraints = false
        
        return sw
    }()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.BotaoCriarPlaylist)
        self.view.addSubview(self.ScrollPlayList)
        
        self.CriarPastaPlaylist()
        self.CriarArquivoPlaylist()
        
        let margins = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.BotaoCriarPlaylist.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            self.BotaoCriarPlaylist.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.BotaoCriarPlaylist.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            self.ScrollPlayList.topAnchor.constraint(equalTo: self.BotaoCriarPlaylist.bottomAnchor, constant: 10),
            self.ScrollPlayList.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.ScrollPlayList.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.ScrollPlayList.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 185, green: 185, blue: 185, a: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func AtualizarPlaylist(){
        for subview in self.ScrollPlayList.subviews{
            subview.removeFromSuperview()
        }
        
        CriarListaPlaylists()
    }
    
    func CriarListaPlaylists(){
        let ConteinerPlaylistsView: UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        let Lista: Listas = ObterPlaylist()
        
        self.ScrollPlayList.addSubview(ConteinerPlaylistsView)
        
        let vConst = ConteinerPlaylistsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        vConst.isActive = true
        vConst.priority = UILayoutPriority(50)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            ConteinerPlaylistsView.topAnchor.constraint(equalTo: self.ScrollPlayList.topAnchor),
            ConteinerPlaylistsView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            ConteinerPlaylistsView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            ConteinerPlaylistsView.bottomAnchor.constraint(equalTo: self.ScrollPlayList.bottomAnchor),
        ])
        
        let ListaDeButton: [UIStackView] = {
            var lista:[UIStackView] = []
            var itemIndex = 0
            for item in Lista.Playlists{
                if(item.Nome != ".DS_Store" && item.Nome != "Playlists"){
                    let ViewStack = UIStackView()
                    
                    let bt = UIButton()
                    bt.translatesAutoresizingMaskIntoConstraints = false
                    bt.tag = itemIndex
                    let item_str = item.Nome//.prefix(35)
                    bt.setTitle("\(item_str)", for: .normal)
                    bt.addTarget(self, action: #selector(self.BotaoAbrirPlaylistFunc), for: .touchUpInside)
                    bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 14)
                    bt.layer.cornerRadius = 5
                    bt.backgroundColor = UIColor(red: 35, green: 35, blue: 35, a: 0.7)
                    
                    let bt_Delet = UIButton()
                    bt_Delet.translatesAutoresizingMaskIntoConstraints = false
                    bt_Delet.tag = itemIndex
                    bt_Delet.setImage(UIImage(systemName: "trash"), for: .normal)
                    bt_Delet.tintColor = UIColor(red: 210, green: 210, blue: 210, a: 1)
                    bt_Delet.addTarget(self, action: #selector(self.BotaoApagarPlaylistFunc), for: .touchUpInside)
                    bt_Delet.backgroundColor = UIColor(red: 200, green: 30, blue: 30, a: 0.5)
                    bt_Delet.layer.cornerRadius = 5
                    
                    NSLayoutConstraint.activate([
                        bt_Delet.widthAnchor.constraint(equalToConstant: 40)
                    ])
                    
                    ViewStack.addArrangedSubview(bt)
                    ViewStack.addArrangedSubview(bt_Delet)
                    
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
            ScrollPlayList.layoutIfNeeded()
            ConteinerPlaylistsView.layoutIfNeeded()
            
            let tamanhoAreaScroll = CGFloat(ScrollPlayList.frame.size.height)//- self.TamanhoTabBar
            
            let base = 3
            let QuantosCabemDentroDoScroll = Int(tamanhoAreaScroll/(CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base)))
            let adicionar = CGFloat(ListaDeButton.count - QuantosCabemDentroDoScroll) * (CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base))
            let porcentagem = (((adicionar / tamanhoAreaScroll) * 100.0 ) / 100)
            
            if (Lista.Playlists.count * (Int(ListaDeButton[0].frame.size.height) + base) <= Int(tamanhoAreaScroll)) {
                NSLayoutConstraint.activate([
                    ConteinerPlaylistsView.heightAnchor.constraint(equalTo: ScrollPlayList.heightAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    ConteinerPlaylistsView.heightAnchor.constraint(equalTo: ScrollPlayList.heightAnchor, multiplier: porcentagem + 1),
                ])
            }
            
            ConteinerPlaylistsView.layoutIfNeeded()
            ScrollPlayList.layoutIfNeeded()
            
        }
    }

    var MusicasDentroPlaylistViewControl: MusicasDentroPlaylistViewController!
    
    @objc func BotaoAbrirPlaylistFunc(sender:UIButton) {
        let Lista: Listas = ObterPlaylist()
        self.ListaMusicas = Lista.Playlists[sender.tag].Musicas
        
        self.MusicasDentroPlaylistViewControl = MusicasDentroPlaylistViewController()
        self.MusicasDentroPlaylistViewControl.loadViewIfNeeded()
        self.MusicasDentroPlaylistViewControl.modalPresentationStyle = .overCurrentContext
        self.present(self.MusicasDentroPlaylistViewControl, animated: true, completion: nil)
        
        self.MusicasDentroPlaylistViewControl.setPlaylistTag(tag: sender.tag)
        self.MusicasDentroPlaylistViewControl.setLabelNomePlaylist(nome: Lista.Playlists[sender.tag].Nome)
        self.MusicasDentroPlaylistViewControl.setPlaylistMusicasViewControl(PlaylistMusicasViewControl: self)
        self.MusicasDentroPlaylistViewControl.CriarListaPlaylists()
        self.MusicasDentroPlaylistViewControl.setTabBarControl(TabBarControl: self.tabBarControl)
        
    }
    
    var PopupConfirmarDeletePlaylistViewControl: PopupConfirmarDeletePlaylistViewController!
    
    @objc func BotaoApagarPlaylistFunc(sender:UIButton) {
        self.PopupConfirmarDeletePlaylistViewControl = PopupConfirmarDeletePlaylistViewController()
        self.PopupConfirmarDeletePlaylistViewControl.loadViewIfNeeded()
        self.PopupConfirmarDeletePlaylistViewControl.modalPresentationStyle = .overFullScreen //fica com a tela cheia mas não fecha a tela de tras
        self.PopupConfirmarDeletePlaylistViewControl.setPlaylistMusicaViewControl(playlistMusicaViewControl: self)
        self.PopupConfirmarDeletePlaylistViewControl.setTag(tag: sender.tag)
        self.present(self.PopupConfirmarDeletePlaylistViewControl, animated: true, completion: nil)
    }
    
    func ConfirmarDeletePlaylist(Tag:Int){
        self.RemoverPlaylist(index:Tag)
        self.AtualizarPlaylist()
    }

    var PopupCriarPlaylistViewControl :PopupCriarPlaylistViewController!
    
    @objc func BotaoCriarPlaylistFunc(){
        self.PopupCriarPlaylistViewControl = PopupCriarPlaylistViewController()
        self.PopupCriarPlaylistViewControl.loadViewIfNeeded()
        self.PopupCriarPlaylistViewControl.modalPresentationStyle = .overFullScreen //fica com a tela cheia mas não fecha a tela de tras
        self.PopupCriarPlaylistViewControl.setPlaylistMusicasViewControl(PlaylistMusicasViewControl: self)
        self.present(self.PopupCriarPlaylistViewControl, animated: true, completion: nil)
    
        
    }
    
    func CriarPastaPlaylist(){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        
        //criar a pasta da PlayList caso não exista
        if !FileManager.default.fileExists(atPath: PlaylistFolderPath.path) {
            try! FileManager.default.createDirectory(at: PlaylistFolderPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func CriarArquivoPlaylist(){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        if !FileManager.default.fileExists(atPath: PlaylistFilePath.path) {
            
            let jsonText: [String : Any] = [
                "Playlists": [
                ]
            ]
            let jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: jsonText, options: .init(rawValue: 0))
                    do {
                        try jsonData.write(to: PlaylistFilePath)
                    } catch {
                    }
            } catch {
            }
        }
    }
    
    func AdicionarPlaylist(NomePlaylist: String){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
                var decodedData = try decoder.decode(Listas.self, from: data)
                let NovaPlayList: Playlists = Playlists(Nome: NomePlaylist, Musicas: [])
                decodedData.Playlists.append(NovaPlayList)
                let data = try encoder.encode(decodedData)
                try data.write(to: PlaylistFilePath)
                
            } catch {
            }
        } catch {
        }
    }

    
    func RemoverPlaylist(index:Int){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
                var decodedData = try decoder.decode(Listas.self, from: data)
                //decodedData.Playlists[0].Musicas.removeAll(where: { $0 == "Musica7" } )
                //ou
                decodedData.Playlists.remove(at: index) // index da musica
                let data = try encoder.encode(decodedData)
                try data.write(to: PlaylistFilePath)
            } catch {
            }
        } catch {
        }
        
    }
    
    func EditarNomePlaylist(){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
                var decodedData = try decoder.decode(Listas.self, from: data)
                //let decodedData = try decoder.decode(Listas.self, from: data)
                
                //adicionando informações na playlist
                decodedData.Playlists[0].Nome = "NovoNomeee"
                
                //print(decodedData.Playlists[0].Musicas)
                
                let data = try encoder.encode(decodedData)
                
                try data.write(to: PlaylistFilePath)
            } catch {
            }
        } catch {
        }
    }
    
    func SalvarMusicasPlaylist(PlaylistTag:Int, Musicas:[String]){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
                var decodedData = try decoder.decode(Listas.self, from: data)
                //adicionando informações na playlist
                decodedData.Playlists[PlaylistTag].Musicas = Musicas
                let data = try encoder.encode(decodedData)
                try data.write(to: PlaylistFilePath)
            } catch {
            }
        } catch {
        }
    }
    
    func AdicionarMusicaPlaylist(){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
                var decodedData = try decoder.decode(Listas.self, from: data)
                //let decodedData = try decoder.decode(Listas.self, from: data)
                
                //adicionando informações na playlist
                //decodedData.Playlists[0].Musicas.append("Musica7")
                decodedData.Playlists[0].Musicas.append("Musica7")
                   
                
                print(decodedData.Playlists[0].Musicas)
                
                let data = try encoder.encode(decodedData)
                
                try data.write(to: PlaylistFilePath)
            } catch {
            }
        } catch {
        }
    }
    
    func RemoverMusicaPlaylist(){
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            
            do {
                var decodedData = try decoder.decode(Listas.self, from: data)
                //let decodedData = try decoder.decode(Listas.self, from: data)
                
                //adicionando informações na playlist
                //decodedData.Playlists[0].Musicas.removeAll(where: { $0 == "Musica7" } )
                //ou
                decodedData.Playlists[0].Musicas.remove(at: 0) // index da musica
                let data = try encoder.encode(decodedData)
                try data.write(to: PlaylistFilePath)
                
            } catch {
            }
        } catch {
        }
    }
    
    func ObterPlaylist() -> Listas{
        //pegando o diretorio da playlist
        let PlaylistFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Playlists")
        //pegando o diretorio do arquivo playlist.json
        let PlaylistFilePath = PlaylistFolderPath.appendingPathComponent("Playlists.json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: PlaylistFilePath.path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(Listas.self, from: data)
                return decodedData
            } catch {
            }
        } catch {
        }
        let lista: Listas = Listas(Playlists: [])
        return lista
    }
    
    func AtualizarLista(PlaylistTag:Int){
        let Lista: Listas = ObterPlaylist()
        self.ListaMusicas = Lista.Playlists[PlaylistTag].Musicas
    }
    
    func FecharJanelaPlaylist(){
        if self.MusicasDentroPlaylistViewControl != nil {
            if self.MusicasDentroPlaylistViewControl.AdicionarMusicasPlaylistViewControl != nil {
                self.MusicasDentroPlaylistViewControl.AdicionarMusicasPlaylistViewControl.dismiss(animated: true, completion: nil)
            }
            self.MusicasDentroPlaylistViewControl.dismiss(animated: true, completion: nil)
            
        }
    }    
}
