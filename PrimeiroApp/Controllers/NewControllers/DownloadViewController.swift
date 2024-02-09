//
//  DownloadViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 11/11/23.
//

import UIKit

class DownloadViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate {
    
    var Baixando: Bool = false
    var DownloadComcluido: Bool = true
    var Key: String!
    
    var LabelURL: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        lb.text = "URL do Video:"
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        return lb
    }()
    
    var InputURL: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        tf.backgroundColor = UIColor(red: 235, green: 235, blue: 235)
        tf.layer.cornerRadius = 5
        tf.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        return tf
    }()
    
    lazy var ApagarUrlButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setImage(UIImage(systemName: "arrowshape.backward.fill"), for: .normal)
        bt.tintColor = UIColor(red: 110, green: 110, blue: 110, a: 1)
        bt.addTarget(self, action: #selector(ApagarUrlButtonFunc), for: .touchUpInside)//ao usar o addTarget dentro da criação da variavel,tera que colocar o "lazy var" na criação
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
    
        return bt
    }()
    
    //lazy serve para usar o self dentro da variavel
    lazy var AreaURL: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.addArrangedSubview(self.InputURL)
        sv.addArrangedSubview(self.ApagarUrlButton)
        
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(5, after: InputURL)

        return sv
    }()
    
    var InputTipo: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Musica", "Video"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        sc.backgroundColor = UIColor(red: 205, green: 205, blue: 205, a: 1)
        sc.selectedSegmentTintColor = UIColor(red: 235, green: 235, blue: 235)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "KohinoorBangla-Semibold" , size: 18)!, 
                                   NSAttributedString.Key.foregroundColor: UIColor(red: 20, green: 20, blue: 20, a: 1)], for: .normal)
        
        sc.selectedSegmentIndex = 0
        
        return sc
    }()
    
    lazy var BotaoDownload: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.setTitle("Download", for: .normal)
        bt.setTitleColor(UIColor(red: 20, green: 20, blue: 20), for: .normal)
        //bt.titleLabel!.font = UIFont(name: "Helvetica-Bold" , size: 25)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        
        bt.addTarget(self, action: #selector(self.DownloadButtonFunc), for: .touchUpInside)
        
        bt.backgroundColor = UIColor(red: 235, green: 235, blue: 235, a: 1)
        bt.layer.cornerRadius = 5
        
        return bt
    }()
    
    var LabelInfoDownload: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        lb.text = ""
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .center
        
        return lb
    }()
    
    var LabelAguardeDownload: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        lb.text = ""
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .center
        
        return lb
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 185, green: 185, blue: 185, a: 1)
        
        
        
        view.addSubview(self.LabelURL)
        view.addSubview(self.AreaURL)
        view.addSubview(self.InputTipo)
        view.addSubview(self.BotaoDownload)
        view.addSubview(self.LabelInfoDownload)
        view.addSubview(self.LabelAguardeDownload)
        
        let espacamentoPadrao = 12.0
        let tamanhoPadrao = 35.0
        
        NSLayoutConstraint.activate([
            LabelURL.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 150),
            LabelURL.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            LabelURL.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            ApagarUrlButton.widthAnchor.constraint(equalToConstant: tamanhoPadrao),
            ApagarUrlButton.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            
            AreaURL.topAnchor.constraint(equalTo: LabelURL.bottomAnchor, constant: espacamentoPadrao),
            AreaURL.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            AreaURL.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            AreaURL.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            
            InputTipo.topAnchor.constraint(equalTo: AreaURL.bottomAnchor, constant: espacamentoPadrao),
            InputTipo.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            InputTipo.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            InputTipo.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            
            BotaoDownload.topAnchor.constraint(equalTo: InputTipo.bottomAnchor, constant: espacamentoPadrao),
            BotaoDownload.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            BotaoDownload.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            BotaoDownload.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            
            LabelInfoDownload.topAnchor.constraint(equalTo: BotaoDownload.bottomAnchor, constant: espacamentoPadrao),
            LabelInfoDownload.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            LabelInfoDownload.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            LabelInfoDownload.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
            
            LabelAguardeDownload.topAnchor.constraint(equalTo: LabelInfoDownload.bottomAnchor, constant: espacamentoPadrao),
            LabelAguardeDownload.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            LabelAguardeDownload.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            LabelAguardeDownload.heightAnchor.constraint(equalToConstant: tamanhoPadrao),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Key = GerarKey(tamanho: 26)
        self.InputURL.delegate = self
        //TabBarController.delegate = self
    }
    
    
    @objc private func ApagarUrlButtonFunc() {
        self.InputURL.text = ""
    }
    
    func DownloadFunction(tipo: String, url: String) async throws -> Void  {
        do {
            let resultado = try await GetNome(tipo: tipo, url: url)
            let data = try await fetchProducts(tipo: tipo,key: self.Key ,url:url, ViewController_Local: self)
            SalvarArquivo(data: data, Nome: resultado ?? "")
            self.DownloadComcluido = true
        } catch {
            self.LabelInfoDownload.text = "Erro Download"
        }
    }
    
    func PegarInfoDownload() async throws -> Void {
        do {
            let url = URL(string: "http://192.168.0.127:8001/infoDownload/\(self.Key ?? "")")!
            let session = URLSession.shared
            let (data, _) = try await session.data(from: url)
            if let json_info = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let StringKey = (json_info[self.Key] as? String) ?? ""
                self.LabelInfoDownload.text = StringKey
            }
        } catch {
            self.LabelInfoDownload.text = "Baixando..."
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if(self.DownloadComcluido == true){
            } else {
                Task{
                    do{
                        try await self.PegarInfoDownload()
                    } catch {}
                }
            }
        }
    }
    
    @objc private func DownloadButtonFunc(){
        if(self.Baixando == false){
            self.DownloadComcluido = false
            self.Baixando = true
            self.LabelInfoDownload.text = "Iniciando download"
            self.InputURL.resignFirstResponder()//fechar o teclado
            var tipo: String
            if(InputTipo.selectedSegmentIndex == 0){
                tipo = "M"
            } else {
                tipo = "V"
            }
            
            let url = String("\(InputURL.text!)")
            
            Task{
                DispatchQueue.main.async {
                    Task{
                        do{
                            try await self.DownloadFunction(tipo: tipo, url: url)
                            self.Baixando = false
                            self.LabelInfoDownload.text = "Download Finalizado"
                            self.LabelAguardeDownload.text = ""
                            
                        } catch {}
                    }
                }
                do {
                    try await self.PegarInfoDownload()
                } catch {}
            }
        }
        else{
            self.LabelAguardeDownload.text = "Já tem um item baixando.... Agurade"
        }
    }
    
    func GerarKey(tamanho: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<tamanho).map{ _ in letters.randomElement()! })
    }
    
    //ao clicar fora do teclado, ira fechalo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.InputURL.resignFirstResponder()//fechar o teclado
    }
    
    //quando clicar em "Done" no teclado essa função sera executada, posso colocar aqui tambem para rodar o codigo de baixar o video/musica aqui
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.InputURL.resignFirstResponder()//fechar o teclado
        return true
    }
    
    
    
}
