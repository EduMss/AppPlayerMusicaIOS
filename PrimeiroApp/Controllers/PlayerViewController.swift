//
//  PlayerViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 02/11/23.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var ScrollViewItens: UIScrollView!
    @IBOutlet weak var BotaoVoltar: UIButton!
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .systemRed
        return sv
    }()
    
    var ListaGlobalDeButton: [UIStackView] = []
    
    public var Arquivos: [String] = {
        var arquivoView: [String] = []
        let fm = FileManager.default
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let items = try fm.contentsOfDirectory(atPath: path.path())

            for item in items {
                arquivoView.append(item)
            }
        } catch {
        }
        
        return arquivoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        self.CriarListaItens()
        
    }
    @IBAction func FecharJanela(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func CriarListaItens(){
        let NovoScrollViewItens: UIScrollView = {
            let sv = UIScrollView()
            sv.backgroundColor = .systemOrange
            return sv
        }()
        self.view.addSubview(NovoScrollViewItens)
        NovoScrollViewItens.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView: UIView = {
            let s = UIView()
            s.backgroundColor = .systemPurple
            return s
        }()
        
        NovoScrollViewItens.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        //let hConst = contentView.heightAnchor.constraint(equalTo: NovoScrollViewItens.heightAnchor)
        //hConst.isActive = true
        //hConst.priority = UILayoutPriority(50)
        
        let vConst = contentView.widthAnchor.constraint(equalTo: NovoScrollViewItens.widthAnchor)
        vConst.isActive = true
        vConst.priority = UILayoutPriority(50)
        
        NSLayoutConstraint.activate([
            NovoScrollViewItens.topAnchor.constraint(equalTo: ScrollViewItens.topAnchor),
            NovoScrollViewItens.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            NovoScrollViewItens.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            NovoScrollViewItens.bottomAnchor.constraint(equalTo: ScrollViewItens.bottomAnchor),            
            
            contentView.topAnchor.constraint(equalTo: NovoScrollViewItens.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: NovoScrollViewItens.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: NovoScrollViewItens.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: NovoScrollViewItens.bottomAnchor),
        ])
        

        
        let ListaDeButton: [UIStackView] = {
            var lista:[UIStackView] = []
            var itemIndex = 0
            for item in self.Arquivos{
                let ViewStack = UIStackView()
        
                let bt = UIButton()
                bt.translatesAutoresizingMaskIntoConstraints = false
                bt.tag = itemIndex
                bt.backgroundColor = .systemBlue
                let item_str = item.prefix(35)
                bt.setTitle("\(item_str)", for: .normal)
                bt.addTarget(self, action: #selector(ClickButton), for: .touchUpInside)
                
                let bt_Delet = UIButton()
                bt_Delet.translatesAutoresizingMaskIntoConstraints = false
                bt_Delet.tag = itemIndex
                bt_Delet.backgroundColor = .systemRed
                bt_Delet.setTitle("Deletar", for: .normal)
                bt_Delet.addTarget(self, action: #selector(ClickButtonDelete), for: .touchUpInside)
        
                ViewStack.addArrangedSubview(bt)
                ViewStack.addArrangedSubview(bt_Delet)

                ViewStack.translatesAutoresizingMaskIntoConstraints = false
                ViewStack.axis = .horizontal
                ViewStack.distribution = .equalSpacing
                ViewStack.alignment = .fill
        
                lista.append(ViewStack)
                itemIndex = itemIndex + 1
            }
            return lista
        }()
        
        for x in stride(from:0,to: ListaDeButton.count, by: 1){
            contentView.addSubview(ListaDeButton[x])
            if(x == 0){
                NSLayoutConstraint.activate([
                    ListaDeButton[0].topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                    ListaDeButton[0].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    ListaDeButton[0].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
            } else{
                NSLayoutConstraint.activate([
                    ListaDeButton[x].topAnchor.constraint(equalTo: ListaDeButton[x - 1].bottomAnchor, constant:5),
                    ListaDeButton[x].leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    ListaDeButton[x].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
            }

        }
        
        if(ListaDeButton.count > 0){
            
            // se eu quiser pegar informações do NovoScrollViewItens durante a inicialização, preciso utilizar esse codigo para conseguir obter informações
            ListaDeButton[0].layoutIfNeeded()
            NovoScrollViewItens.layoutIfNeeded()
            //print("novo Scroll View Itens height: \(CGFloat(NovoScrollViewItens.frame.size.height))")
            //print("ListaDeButton height: \(CGFloat(ListaDeButton[0].frame.size.height))")
            
            let base = 5
            let QuantosCabemDentroDoScroll = Int(CGFloat(NovoScrollViewItens.frame.size.height)/(CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base)))
            //print("Quantos Cabem Dentro do Scroll \(QuantosCabemDentroDoScroll)")
            //let totalEspaço = QuantosCabemDentroDoScroll * (Int(ListaDeButton[0].frame.size.height) + base)
            //print("total Espaço \(totalEspaço)")
            let adicionar = CGFloat(ListaDeButton.count - QuantosCabemDentroDoScroll) * (CGFloat(ListaDeButton[0].frame.size.height) + CGFloat(base))
            //print("adicionar \(adicionar)")
            let porcentagem = ((adicionar / CGFloat(NovoScrollViewItens.frame.size.height)) * 100.0 ) / 100
            //print("porcentagem \(porcentagem)")
            
            if (self.Arquivos.count * (Int(ListaDeButton[0].frame.size.height) + base) <= Int(NovoScrollViewItens.frame.size.height)) {
                NSLayoutConstraint.activate([
                    contentView.heightAnchor.constraint(equalTo: NovoScrollViewItens.heightAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    contentView.heightAnchor.constraint(equalTo: NovoScrollViewItens.heightAnchor, multiplier: porcentagem + 1),
                ])
            }
        }
    }
    
    @objc private func ClickButton(sender:UIButton){
        let PlayerMusicController = self.storyboard!.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        PlayerMusicController.loadViewIfNeeded()
        PlayerMusicController.modalPresentationStyle = .fullScreen
        self.present(PlayerMusicController, animated: true, completion: nil)
        PlayerMusicController.Inicial()
        PlayerMusicController.Musica(Musicas: Arquivos, index:sender.tag)
    }
    
    @objc private func ClickButtonDelete(sender:UIButton){
        //print("\(Arquivos[sender.tag])")
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Arquivos[sender.tag]).path
        //print("\(path.appendingPathComponent(Arquivos[sender.tag]).path())")
        //print("\(path.appendingPathComponent(Arquivos[sender.tag]).path)")
        //print(path)
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
            self.Arquivos = {
                var arquivoView: [String] = []
                let fm = FileManager.default
                let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                do {
                    let items = try fm.contentsOfDirectory(atPath: path.path())

                    for item in items {
                        arquivoView.append(item)
                    }
                } catch {
                }
                return arquivoView
            }()
            self.CriarListaItens()
            //print("File deleted successfully")
        } catch {
            //print("Error deleting file: \(error)")
        }
        
    }
}
