//
//  PlayViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 02/11/23.
//
import AVFoundation
import UIKit

class PlayViewController: UIViewController, AVAudioPlayerDelegate {

    var player: AVAudioPlayer = AVAudioPlayer()
    
    var ListaMusica: [String]!
    var IndexMusica: Int!
    var IndexInicial: Int!
    
    @IBOutlet weak var NomeMusica: UILabel!
    @IBOutlet weak var BotaoLoop: UIButton!
    @IBOutlet weak var BotaoPlay: UIButton!
    @IBOutlet weak var SliderMusica: UISlider!
    @IBOutlet weak var tempoAtual: UILabel!
    @IBOutlet weak var TempoTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func Musica(Musicas:[String], index:Int){
        ListaMusica = Musicas
        IndexMusica = index
        
        NomeMusica.text = ListaMusica[IndexMusica]
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(ListaMusica[IndexMusica])
        let mp3URL3 = URL(string: "\(destinationUrl)")!
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: mp3URL3, fileTypeHint: AVFileType.mp3.rawValue)
            SliderMusica.maximumValue = Float(player.duration)
            
            
            //This is to show and compute current time
            let currentTime1 = Int((player.duration))
            let minutes = currentTime1/60
            let seconds = currentTime1 - minutes * 60
            TempoTotal.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMusicSlider), userInfo: nil, repeats: true)
            
            
            player.delegate = self
            player.prepareToPlay()
            player.play()
            //loop infinito = -1 | rodar 1x so = 0
            player.numberOfLoops = 0
            
        }
         catch let error as NSError {
             print(error.localizedDescription)
         }
    }
    
    public func Inicial(){
        BotaoLoop.setTitle("A- Loop", for: .normal)
    }
    
    @objc func updateMusicSlider(){
        SliderMusica.value = Float(player.currentTime)
        let currentTime1 = Int((player.currentTime))
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        tempoAtual.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if(BotaoLoop.currentTitle == "A-"){
            //print("A-")
            if(ListaMusica.count-1 == IndexMusica){
                player.stop()
                BotaoPlay.setTitle("Play", for: .normal)
            } else {
                let ProximoIndex = IndexMusica + 1
                Musica(Musicas:ListaMusica, index:ProximoIndex)
            }
        } else if (BotaoLoop.currentTitle == "A- Loop" ) {
            //print("A- Loop")
            if(ListaMusica.count-1 == IndexMusica){
                let ProximoIndex = 0
                Musica(Musicas:ListaMusica, index:ProximoIndex)
            } else {
                let ProximoIndex = IndexMusica + 1
                Musica(Musicas:ListaMusica, index:ProximoIndex)
            }
        } else {
            //print("Loop")
        }
        
    }
    
    @IBAction func PaginaAnterior(_ sender: Any) {
        player.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ClickButtonPlay(_ sender: Any) {
        if(BotaoPlay.currentTitle == "Play"){
            BotaoPlay.setTitle("Pause", for: .normal)
            player.play()
        } else {
            BotaoPlay.setTitle("Play", for: .normal)
            player.pause()
        }
    }
    
    @IBAction func MusicaAnterior(_ sender: Any) {
        //colocar para se a musica estiver + do que 15 segundos, ele vai ir para musica anterior, se estiver mais doq 15s, ele vai voltar para o inicio da musica atual
        
        if(IndexMusica == 0){
            let ProximoIndex = ListaMusica.count - 1
            Musica(Musicas:ListaMusica, index:ProximoIndex)
        } else {
            let ProximoIndex = IndexMusica - 1
            Musica(Musicas:ListaMusica, index:ProximoIndex)
        }
        
    }
    
    @IBAction func ProximaMusica(_ sender: Any) {
        if(ListaMusica.count-1 == IndexMusica){
            let ProximoIndex = 0
            Musica(Musicas:ListaMusica, index:ProximoIndex)
        } else {
            let ProximoIndex = IndexMusica + 1
            Musica(Musicas:ListaMusica, index:ProximoIndex)
        }
    }
    
    @IBAction func ClickBotaoLoop(_ sender: Any) {
        if(BotaoLoop.currentTitle == "A- Loop"){
            BotaoLoop.setTitle("Loop", for: .normal)
            player.numberOfLoops = -1
        } else if (BotaoLoop.currentTitle == "Loop" ) {
            BotaoLoop.setTitle("A-", for: .normal)
            player.numberOfLoops = 0
        } else {
            BotaoLoop.setTitle("A- Loop", for: .normal)
            player.numberOfLoops = 0
        }
        
    }
    
    @IBAction func ClickSlider(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(SliderMusica.value)
        player.prepareToPlay()
        player.play()
    }

}
