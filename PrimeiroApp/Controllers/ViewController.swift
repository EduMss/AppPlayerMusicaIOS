//
//  ViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 02/11/23.
//

import UIKit



class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var URLVideoText: UILabel!
    @IBOutlet weak var InputURL: UITextField!
    @IBOutlet weak var InputTipo: UISegmentedControl!
    @IBOutlet weak var BotaoBaixar: UIButton!
    
    @IBOutlet weak var ListaArquivos: UITextView!
    @IBOutlet weak var AtualizarLista: UIButton!
    
    @IBOutlet weak var TextoInfo1: UILabel!
    @IBOutlet weak var TextoInfo2: UILabel!
    var Baixando: Bool = false
    var DownloadComcluido: Bool = true
    
    var Key: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.Key = randomString(length: 26)
        
        print(self.Key ?? "")
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //quando clicar em "Done" no teclado essa função sera executada, posso colocar aqui tambem para rodar o codigo de baixar o video/musica aqui
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        InputURL.resignFirstResponder()//fechar o teclado
        return true
    }
    
    @IBAction func ProximaPagin(_ sender: Any) {
        let secondController = self.storyboard!.instantiateViewController(withIdentifier: "PlayerViewControll")
        
        secondController.loadViewIfNeeded()
        secondController.modalPresentationStyle = .fullScreen
        self.present(secondController, animated: true, completion: nil)
    }
    
    //ao clicar fora do teclado, ira fechalo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        InputURL.resignFirstResponder()//fechar o teclado
    }
 
    
    @IBAction func AtualizarListaDeArquivos(_ sender: Any) {
        InputURL.resignFirstResponder()//fechar o teclado
        let fm = FileManager.default
        let path =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        ListaArquivos.text = ""
        do {
            let items = try fm.contentsOfDirectory(atPath: path.path())

            for item in items {
                ListaArquivos.text += item + "\n"
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        
    }
    
    @IBAction func SetText(_ sender: Any) {
        if(self.Baixando == false){
            self.DownloadComcluido = false
            self.Baixando = true
            print("Baixando...")
            TextoInfo1.text = "Iniciando download"
            InputURL.resignFirstResponder()//fechar o teclado
            var tipo: String
            if(InputTipo.selectedSegmentIndex == 0){
                tipo = "M"
            } else {
                tipo = "V"
            }
            
            let url = String("\(InputURL.text!)")
            //let url_getNome = "192.168.0.127:8001/NomeVideo/\(tipo)?url=\(url)"
            //let url_Download = "192.168.0.127:8001/Download/\(tipo)?url=\(url)"
            //print(url_getNome)
            //print(url_Download)
            
            
            
            //var resultado: String?
            //var data: Data?
            
            Task{
                //do{
                //    resultado = try await GetNome(tipo: tipo, url: url)
                //    data = try await fetchProducts(tipo: tipo,url:url)
                //    SalvarArquivo(data: data, Nome: resultado ?? "")
                //}catch{
                //    //print(error)
                //}
                await self.loadRecommendations(tipo: tipo, url: url)
            }
        }
        else{
            //print("Ja tem um item baixando")
            TextoInfo2.text = "Já tem um item baixando.... Agurade"
        
        }
    }
    
    func DownloadFunction(tipo: String, url: String) async throws -> Void  {
        do {
            //let resultado = try await GetNome(tipo: tipo, url: url)
            //let data = try await fetchProducts(tipo: tipo,key: self.Key ,url:url, ViewController_Local: self)
            //SalvarArquivo(data: data, Nome: resultado ?? "")
            self.DownloadComcluido = true
        } catch {
            print("Erro Download")
        }
    }
    
    func PrintInfo() async throws -> Void {
        //do {
        //    let url = URL(string: "http://192.168.0.127:8001/info")!
        //    let session = URLSession.shared
        //    let (data, _) = try await session.data(from: url)
        //    if let json_info = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        //        print("\(json_info["CPU"] ?? "Error em obter o nome do arquivo")")
        //    }
        //} catch {
        //    print("Errorrrrr")
        //}
        
        do {
            let url = URL(string: "http://192.168.0.127:8001/infoDownload/\(self.Key ?? "")")!
            let session = URLSession.shared
            //let (data, response) = try await session.data(from: url)
            let (data, _) = try await session.data(from: url)
            //print(data)
            if let json_info = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                //print("\(json_info["CPU"] ?? "Error em obter o nome do arquivo")")
                print(json_info)
                let StringKey = (json_info[self.Key] as? String) ?? ""
                self.TextoInfo1.text = StringKey
            }
        } catch {
            self.TextoInfo1.text = "Baixando..."
        }
        
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if(self.DownloadComcluido == true){
                print("Pode Parar\nParando...")
            } else {
                print("Continuando...")
                Task{
                    do{
                        try await self.PrintInfo()
                    } catch {}
                }
            }
        }
    }
    
    func loadRecommendations(tipo: String, url: String) async {
        DispatchQueue.main.async {
            Task{
                do{
                    try await self.DownloadFunction(tipo: tipo, url: url)
                    self.Baixando = false
                    self.TextoInfo1.text = "Download Finalizado"
                    self.TextoInfo2.text = ""
                    
                } catch {}
            }
        }
        do {
            try await self.PrintInfo()
        } catch {}
        
    }
    
}

