import Foundation
import UIKit
import Dispatch
    
func GetNome(tipo: String, url: String) async throws -> String?{
    let dispatchGroup = DispatchGroup()
    guard let url_nome = URL(string: "http://192.168.0.127:8001/NomeVideo/\(tipo)?url=\(url)") else {
        print("Error: doesn't seem to be a valid URL")
        return nil
    }
    dispatchGroup.enter()
    do {
        let content = try String(contentsOf: url_nome, encoding: .ascii)
        let data = Data(content.utf8)
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return "\(json["nomeVideo"] ?? "Error em obter o nome do arquivo")"
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return nil
        }
    } catch let error {
        print("Error: \(error)")
        return nil
    }
    
    
    return nil
}

    
func fetchProducts(tipo: String,key: String , url: String, ViewController_Local: DownloadViewController) async throws -> Data? {
    let ViewCOntroler: DownloadViewController = ViewController_Local
    let url = URL(string: "http://192.168.0.127:8001/Download/\(tipo)?key=\(key)&url=\(url)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    
    //create a new urlRequest passing the url
    let request = URLRequest(url: url!)
    
    //let configuration = URLSessionConfiguration.background(withIdentifier: "Downloader")
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 600 // tempo em segundos, 300segundos / 60segundos = 5 minutos   | 600segundos / 60segundos = 10minutos
    let session = URLSession(configuration: configuration)

    //let (data, _) = try await URLSession.shared.data(for: request)
    let (data, _) = try await session.data(for: request)
    try await ViewCOntroler.PegarInfoDownload()
    
    return data
}
    
    
func SalvarArquivo(data: Data?, Nome: String){
    //pegando o diretorio do projeto
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //print(documentsUrl)
    //inserindo no final do diretorio, o nome do arquivo desejado
    let destinationUrl = documentsUrl.appendingPathComponent(Nome)
    //print(destinationUrl)
    
    //verificando se existe o diretorio/arquivo
    if FileManager().fileExists(atPath: destinationUrl.path)
    {
        //se existir, imprimirar a mensagem que o arquivo ja existe
        //print("File already exists [\(destinationUrl.path)]")
    }
    else {
        if let data = data{
            //escrevendo o data(arquivo recebido) no diretorio do projeto/programa
            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
            {
                //print("Arquivo Salvo")
            }
            else {
                //print("Arquivo não Salvo")
            }
        }
    }
}

