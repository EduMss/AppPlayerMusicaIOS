//
//  MusicasViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 11/11/23.
//

import UIKit
import AVFoundation

class MusicasViewController: UIViewController, UITextFieldDelegate {
    
    var TabBarControl: TabBarController!
    var PlayerMusicaViewControl: PlayerMusicaViewController!
    
    var IndexMusica: Int!
    var IndexInicial: Int!
    
    var alturaViewPlayer: CGFloat = -50
    
    var ListaGlobalDeButton: [UIStackView] = []
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
    
    var BarraPesquisa: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        tf.backgroundColor = UIColor(red: 235, green: 235, blue: 235)
        tf.layer.cornerRadius = 5
        tf.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        return tf
    }()
    
    lazy var ApagarBarraPesquisaButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setImage(UIImage(systemName: "arrowshape.backward.fill"), for: .normal)
        bt.tintColor = UIColor(red: 110, green: 110, blue: 110, a: 1)
        bt.addTarget(self, action: #selector(self.ApagarBarraPesquisaButtonFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    lazy var BotaoPesquisa: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(self.PesquisarFunc), for: .touchUpInside)
        
        bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        bt.tintColor = UIColor(red: 110, green: 110, blue: 110, a: 1)
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
        
        return bt
    }()
    
    lazy var BarraPesquisaView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.BarraPesquisa)
        sv.addArrangedSubview(self.ApagarBarraPesquisaButton)
        sv.addArrangedSubview(self.BotaoPesquisa)
        
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(5, after: self.BarraPesquisa)
        sv.setCustomSpacing(5, after: self.ApagarBarraPesquisaButton)
        
        return sv
    }()
    
    var ScrollAreaMusicas: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        return sv
    }()
    
    var TamanhoTabBar: CGFloat!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 185, green: 185, blue: 185, a: 1)
        
        view.addSubview(self.BarraPesquisaView)
        view.addSubview(self.ScrollAreaMusicas)
        
        
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.BarraPesquisaView.topAnchor.constraint(equalTo: margins.topAnchor),
            self.BarraPesquisaView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.BarraPesquisaView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            self.ApagarBarraPesquisaButton.widthAnchor.constraint(equalToConstant: 40),
            self.ApagarBarraPesquisaButton.heightAnchor.constraint(equalToConstant: 40),
            
            self.BotaoPesquisa.widthAnchor.constraint(equalToConstant: 40),
            self.BotaoPesquisa.heightAnchor.constraint(equalToConstant: 40),
            
            self.ScrollAreaMusicas.topAnchor.constraint(equalTo: self.BarraPesquisaView.bottomAnchor, constant: 10),
            self.ScrollAreaMusicas.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.ScrollAreaMusicas.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.ScrollAreaMusicas.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: self.alturaViewPlayer),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Musicas"
        self.BarraPesquisa.delegate = self
        CriarListaMusicas()
    }
    
    func CriarListaMusicas(){
        let ConteinerMusicasView: UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        self.ScrollAreaMusicas.addSubview(ConteinerMusicasView)
        
        let vConst = ConteinerMusicasView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        vConst.isActive = true
        vConst.priority = UILayoutPriority(50)
        
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            ConteinerMusicasView.topAnchor.constraint(equalTo: self.ScrollAreaMusicas.topAnchor),
            ConteinerMusicasView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            ConteinerMusicasView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            ConteinerMusicasView.bottomAnchor.constraint(equalTo: self.ScrollAreaMusicas.bottomAnchor),
        ])
        
        let ListaDeButton: [UIStackView] = {
            var lista:[UIStackView] = []
            var itemIndex = 0
            for item in self.Arquivos{
                if(item != ".DS_Store" && item != "Playlists"){
                    let ViewStack = UIStackView()
                    
                    let bt = UIButton()
                    bt.translatesAutoresizingMaskIntoConstraints = false
                    bt.tag = itemIndex
                    bt.backgroundColor = UIColor(red: 35, green: 35, blue: 35, a: 0.7)
                    let item_str = item//.prefix(35)
                    bt.setTitle("\(item_str)", for: .normal)
                    bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 14)
                    bt.addTarget(self, action: #selector(BotaoPlayMusica), for: .touchUpInside)
                    bt.layer.cornerRadius = 5
                    
                    let bt_Delet = UIButton()
                    bt_Delet.translatesAutoresizingMaskIntoConstraints = false
                    bt_Delet.tag = itemIndex
                    bt_Delet.backgroundColor = UIColor(red: 200, green: 30, blue: 30, a: 0.5)
                    bt_Delet.setImage(UIImage(systemName: "trash"), for: .normal)
                    bt_Delet.tintColor = UIColor(red: 210, green: 210, blue: 210, a: 1)
                    bt_Delet.addTarget(self, action: #selector(BotaoApagarArquivo), for: .touchUpInside)
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
            ConteinerMusicasView.addSubview(ListaDeButton[x])
            if(x == 0){
                NSLayoutConstraint.activate([
                    ListaDeButton[0].topAnchor.constraint(equalTo: ConteinerMusicasView.topAnchor, constant: 3),
                    ListaDeButton[0].leadingAnchor.constraint(equalTo: ConteinerMusicasView.leadingAnchor),
                    ListaDeButton[0].trailingAnchor.constraint(equalTo: ConteinerMusicasView.trailingAnchor),
                ])
            } else{
                NSLayoutConstraint.activate([
                    ListaDeButton[x].topAnchor.constraint(equalTo: ListaDeButton[x - 1].bottomAnchor, constant: 3),
                    ListaDeButton[x].leadingAnchor.constraint(equalTo: ConteinerMusicasView.leadingAnchor),
                    ListaDeButton[x].trailingAnchor.constraint(equalTo: ConteinerMusicasView.trailingAnchor),
                ])
            }
        }
        
        if(ListaDeButton.count > 0){
            // se eu quiser pegar informações do NovoScrollViewItens durante a inicialização, preciso utilizar esse codigo para conseguir obter informações
            ListaDeButton[0].layoutIfNeeded()
            ScrollAreaMusicas.layoutIfNeeded()
            ConteinerMusicasView.layoutIfNeeded()
            
            let tamanhoAreaScroll = CGFloat(ScrollAreaMusicas.frame.size.height)  - self.TamanhoTabBar
            
            let base = 3
            let QuantosCabemDentroDoScroll = Int(tamanhoAreaScroll/(CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base)))
            let adicionar = CGFloat((ListaDeButton.count - 1) - QuantosCabemDentroDoScroll) * (CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base))
            let porcentagem = (adicionar / tamanhoAreaScroll)
            
            if (self.Arquivos.count * (Int(ListaDeButton[0].frame.size.height) + base) <= Int(tamanhoAreaScroll)) {
                NSLayoutConstraint.activate([
                    ConteinerMusicasView.heightAnchor.constraint(equalTo: ScrollAreaMusicas.heightAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    ConteinerMusicasView.heightAnchor.constraint(equalTo: ScrollAreaMusicas.heightAnchor, multiplier: porcentagem + 1),
                ])
            }
        }
        
        ConteinerMusicasView.layoutIfNeeded()
        ScrollAreaMusicas.layoutIfNeeded()
        
    }
    
    public func setTabBarControl(TabBarControl:TabBarController!){
        self.TabBarControl = TabBarControl
    }
    
    func CriarListaMusicasUpdate(){
        let ConteinerMusicasView: UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        self.ScrollAreaMusicas.addSubview(ConteinerMusicasView)
        
        let vConst = ConteinerMusicasView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
        vConst.isActive = true
        vConst.priority = UILayoutPriority(50)
        
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            ConteinerMusicasView.topAnchor.constraint(equalTo: self.ScrollAreaMusicas.topAnchor),
            ConteinerMusicasView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            ConteinerMusicasView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            ConteinerMusicasView.bottomAnchor.constraint(equalTo: self.ScrollAreaMusicas.bottomAnchor),
        ])
        
        
        let ListaDeButton: [UIStackView] = {
            var lista:[UIStackView] = []
            var itemIndex = 0
            for item in self.Arquivos{
                if(item != ".DS_Store" && item != "Playlists"){
                    let ViewStack = UIStackView()
                    
                    let bt = UIButton()
                    bt.translatesAutoresizingMaskIntoConstraints = false
                    bt.tag = itemIndex
                    bt.backgroundColor = UIColor(red: 35, green: 35, blue: 35, a: 0.7)
                    let item_str = item//.prefix(35)
                    bt.setTitle("\(item_str)", for: .normal)
                    bt.addTarget(self, action: #selector(BotaoPlayMusica), for: .touchUpInside)
                    bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 14)
                    bt.layer.cornerRadius = 5
                    
                    let bt_Delet = UIButton()
                    bt_Delet.translatesAutoresizingMaskIntoConstraints = false
                    bt_Delet.tag = itemIndex
                    bt_Delet.backgroundColor = UIColor(red: 200, green: 30, blue: 30, a: 0.5)
                    bt_Delet.setImage(UIImage(systemName: "trash"), for: .normal)
                    bt_Delet.tintColor = UIColor(red: 210, green: 210, blue: 210, a: 1)
                    bt_Delet.addTarget(self, action: #selector(BotaoApagarArquivo), for: .touchUpInside)
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
            ConteinerMusicasView.addSubview(ListaDeButton[x])
            if(x == 0){
                NSLayoutConstraint.activate([
                    ListaDeButton[0].topAnchor.constraint(equalTo: ConteinerMusicasView.topAnchor, constant: 3),
                    ListaDeButton[0].leadingAnchor.constraint(equalTo: ConteinerMusicasView.leadingAnchor),
                    ListaDeButton[0].trailingAnchor.constraint(equalTo: ConteinerMusicasView.trailingAnchor),
                ])
            } else{
                NSLayoutConstraint.activate([
                    ListaDeButton[x].topAnchor.constraint(equalTo: ListaDeButton[x - 1].bottomAnchor, constant: 3),
                    ListaDeButton[x].leadingAnchor.constraint(equalTo: ConteinerMusicasView.leadingAnchor),
                    ListaDeButton[x].trailingAnchor.constraint(equalTo: ConteinerMusicasView.trailingAnchor),
                ])
            }
        }
        
        if(ListaDeButton.count > 0){
            // se eu quiser pegar informações do NovoScrollViewItens durante a inicialização, preciso utilizar esse codigo para conseguir obter informações
            ListaDeButton[0].layoutIfNeeded()
            ScrollAreaMusicas.layoutIfNeeded()
            ConteinerMusicasView.layoutIfNeeded()
            
            let tamanhoAreaScroll = CGFloat(ScrollAreaMusicas.frame.size.height)
            let base = 3
            let QuantosCabemDentroDoScroll = Int(tamanhoAreaScroll/(CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base)))
            let adicionar = CGFloat((ListaDeButton.count - 1) - QuantosCabemDentroDoScroll) * (CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base))
            let porcentagem = (adicionar / tamanhoAreaScroll)
            
            if (self.Arquivos.count * (Int(ListaDeButton[0].frame.size.height) + base) <= Int(tamanhoAreaScroll)) {
                NSLayoutConstraint.activate([
                    ConteinerMusicasView.heightAnchor.constraint(equalTo: ScrollAreaMusicas.heightAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    ConteinerMusicasView.heightAnchor.constraint(equalTo: ScrollAreaMusicas.heightAnchor, multiplier: porcentagem + 1),
                ])
            }
        }
    }

    @objc func ApagarBarraPesquisaButtonFunc(){
        self.BarraPesquisa.text = ""
        self.AtualizarPagina()
    }
    
    @objc private func PesquisarFunc(){
        self.Arquivos = {
            var arquivoView: [String] = []
            let fm = FileManager.default
            let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                let items = try fm.contentsOfDirectory(atPath: path.path())
                for item in items {
                    if(item != ".DS_Store" && item != "Playlists"){
                        arquivoView.append(item)
                    }
                }
            } catch {
            }
            return arquivoView
        }()
        
        self.BarraPesquisa.resignFirstResponder()//fechar o teclado
        let filterString = "\(self.BarraPesquisa.text!.lowercased())"
        
        
        if filterString != "" {
            var ListaPesquisa: [String]! = []
            
            for str in self.Arquivos{
                if(str.lowercased().contains(filterString))
                {
                    ListaPesquisa.append(str)
                }
            }
            self.Arquivos = ListaPesquisa
        }
        
        for subview in self.ScrollAreaMusicas.subviews{
            subview.removeFromSuperview()
        }
        
        self.CriarListaMusicasUpdate()
    }
    
    func FecharJanelaPlayer(){
        if self.PlayerMusicaViewControl != nil {
            self.PlayerMusicaViewControl.view.transform = .identity
            self.PlayerMusicaViewControl.dismiss(animated: true, completion: nil)
        }

    }
    
    @objc private func BotaoPlayMusica(sender:UIButton){
        
        if(self.PlayerMusicaViewControl == nil){
            self.AtualizarPagina()
        }
        
        self.PlayerMusicaViewControl = PlayerMusicaViewController()
        self.PlayerMusicaViewControl.loadViewIfNeeded()
        self.PlayerMusicaViewControl.modalPresentationStyle = .overFullScreen
        self.present(self.PlayerMusicaViewControl, animated: true, completion: nil)
        
        self.PlayerMusicaViewControl.setTabBarControl(TabBarControl: self.TabBarControl)
        self.PlayerMusicaViewControl.Musica(Musicas: self.Arquivos, index:sender.tag)
        self.PlayerMusicaViewControl.Inicial()
        self.IndexMusica = sender.tag
        
        self.TabBarControl.AdcionarMiniPlayer()
        self.TabBarControl.SetPlayerMusicaViewControl(player: self.PlayerMusicaViewControl)
    }
    
    var PopupConfirmarDeleteViewControl: PopupConfirmarDeleteViewController!
    
    @objc private func BotaoApagarArquivo(sender:UIButton){
        self.PopupConfirmarDeleteViewControl = PopupConfirmarDeleteViewController()
        self.PopupConfirmarDeleteViewControl.loadViewIfNeeded()
        self.PopupConfirmarDeleteViewControl.modalPresentationStyle = .overFullScreen //fica com a tela cheia mas não fecha a tela de tras
        self.PopupConfirmarDeleteViewControl.setMusicaViewControl(musicaViewControl: self)
        self.PopupConfirmarDeleteViewControl.setTag(tag: sender.tag)
        self.present(self.PopupConfirmarDeleteViewControl, animated: true, completion: nil)
    }
    
    func ConfirmarDelete(tag:Int){
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Arquivos[tag]).path
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
            AtualizarPagina()
            self.TabBarControl.vc4.ListaMusica = self.Arquivos
        } catch {
        }
    }

    //ao clicar fora do teclado, ira fechalo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.BarraPesquisa.resignFirstResponder()//fechar o teclado
    }
    
    //quando clicar em "Done" no teclado essa função sera executada, posso colocar aqui tambem para rodar o codigo de baixar o video/musica aqui
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.BarraPesquisa.resignFirstResponder()//fechar o teclado
        return true
    }
    
    func AtualizarPagina(){
        self.Arquivos = {
            var arquivoView: [String] = []
            let fm = FileManager.default
            let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                let items = try fm.contentsOfDirectory(atPath: path.path())

                for item in items {
                    if(item != ".DS_Store" && item != "Playlists"){
                        arquivoView.append(item)
                    } else {
                    }
                }
            } catch {
            }
            return arquivoView
        }()
        
        for subview in self.ScrollAreaMusicas.subviews{
            subview.removeFromSuperview()
        }
        
        self.CriarListaMusicasUpdate()
    }
    

    
    @objc func BotaoPlayMusicaFunc(){
        self.PlayerMusicaViewControl.BotaoPlayMusicaFunc()
    }
    
    @objc func BotaoProximoFunc(){
        self.PlayerMusicaViewControl.BotaoProximoFunc()
    }
    
    @objc func BotaoAreaPlayerMusicaFunc(){
        self.present(self.PlayerMusicaViewControl, animated: true, completion: nil)
    }
}
