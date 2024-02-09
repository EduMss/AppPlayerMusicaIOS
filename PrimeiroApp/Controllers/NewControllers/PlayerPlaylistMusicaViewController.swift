//
//  PlayerPlaylistMusicaViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 16/11/23.
//

import UIKit
import AVFoundation

class PlayerPlaylistMusicaViewController: UIViewController , AVAudioPlayerDelegate{
    
    var PlaylistMusicasViewControl: PlaylistMusicasViewController!
    var TabBarControl: TabBarController!
    var ListaMusica: [String]!
    var IndexMusica: Int!
    var IndexInicial: Int!
    
    var NomeMusicaLabel:UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "OBAAA"
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .center
        
        return lb
    }()
    
    var TempoAtualLabel:UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "00:00"
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var BotaoLoop: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("A- Loop", for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoLoopFunc), for: .touchUpInside)
        
        return bt
    }()
    
    var TempoMaximoLabel:UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "00:00"
        lb.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        lb.textAlignment = .center
        
        return lb
    }()
    
    lazy var AreaTempoLoop: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(self.TempoAtualLabel)
        sv.addArrangedSubview(self.BotaoLoop)
        sv.addArrangedSubview(self.TempoMaximoLabel)
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        
        
        return sv
    }()
    
    lazy var TempoCurrenteMusica:UISlider = {
        let sd = UISlider()
        sd.translatesAutoresizingMaskIntoConstraints = false
        
        sd.addTarget(self, action: #selector(self.ClickSlider), for: .valueChanged)
        
        return sd
    }()
    
    lazy var BotaoAnterior:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Anterior", for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoAnteriorFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var BotaoPlay:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Play", for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoPlayMusicaFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var BotaoProxima:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Proximo", for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 18)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoProximoFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var AreaBotoes: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(self.BotaoAnterior)
        sv.addArrangedSubview(self.BotaoPlay)
        sv.addArrangedSubview(self.BotaoProxima)
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        
        
        return sv
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor(red: 97, green: 97, blue: 97, a: 1.0)

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation: CGPoint
        if gesture.state == .began {
            //print("Began")
        } else if gesture.state == .changed {
            translation = gesture.translation(in: self.view)
            if translation.y < 0{
                
            } else {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            //print(translation)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.4, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn , animations: {
                //self.view.transform = .identity
                //print(self.view.transform.ty)
                if self.view.transform.ty < 150.0 {
                    self.view.transform = .identity
                } else {
                    self.view.transform = .identity
                    self.dismiss(animated: true, completion: nil)

                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.NomeMusicaLabel)
        view.addSubview(self.AreaTempoLoop)
        view.addSubview(self.TempoCurrenteMusica)
        view.addSubview(self.AreaBotoes)
        
        let TamanhoLarguraBotoes = CGFloat(75)
        let TamanhoAlturaBotoes = CGFloat(50)
        NSLayoutConstraint.activate([
            self.NomeMusicaLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 400),
            self.NomeMusicaLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            self.NomeMusicaLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            self.AreaTempoLoop.topAnchor.constraint(equalTo: NomeMusicaLabel.bottomAnchor, constant: 20),
            self.AreaTempoLoop.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            self.AreaTempoLoop.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            self.TempoCurrenteMusica.topAnchor.constraint(equalTo: AreaTempoLoop.bottomAnchor, constant: 20),
            self.TempoCurrenteMusica.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            self.TempoCurrenteMusica.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            self.BotaoAnterior.widthAnchor.constraint(equalToConstant: TamanhoLarguraBotoes),
            self.BotaoAnterior.heightAnchor.constraint(equalToConstant: TamanhoAlturaBotoes),
            
            self.BotaoPlay.widthAnchor.constraint(equalToConstant: TamanhoLarguraBotoes),
            self.BotaoPlay.heightAnchor.constraint(equalToConstant: TamanhoAlturaBotoes),
            
            self.BotaoProxima.widthAnchor.constraint(equalToConstant: TamanhoLarguraBotoes),
            self.BotaoProxima.heightAnchor.constraint(equalToConstant: TamanhoAlturaBotoes),
            
            self.AreaBotoes.topAnchor.constraint(equalTo: TempoCurrenteMusica.bottomAnchor, constant: 20),
            self.AreaBotoes.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            self.AreaBotoes.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
    }
    
    public func setTabBarControl(TabBarControl:TabBarController!){
        self.PlaylistMusicasViewControl.tabBarControl = TabBarControl
    }
    
    
    public func Inicial(PlaylistMusicasViewControl: PlaylistMusicasViewController){
        BotaoLoop.setTitle("A- Loop", for: .normal)
        self.PlaylistMusicasViewControl = PlaylistMusicasViewControl
    }
    
    public func Musica(Musicas:[String], index:Int){
        //self.PlaylistMusicasViewControl.tabBarControl.player.stop()
        self.PlaylistMusicasViewControl.tabBarControl.player.stop()
        
        self.ListaMusica = Musicas
        self.IndexMusica = index
        
        self.NomeMusicaLabel.text = self.ListaMusica[IndexMusica]
        //let nomeMusica: String = "\(self.ListaMusica[IndexMusica])"
        //let NomeCortado = nomeMusica.prefix(40)
        //self.PlaylistMusicasViewControl.NomeMusicaButton.setTitle(String(NomeCortado), for: .normal)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(self.ListaMusica[IndexMusica])
        let mp3URL3 = URL(string: "\(destinationUrl)")!
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            self.PlaylistMusicasViewControl.tabBarControl.player = try AVAudioPlayer(contentsOf: mp3URL3, fileTypeHint: AVFileType.mp3.rawValue)
            self.TempoCurrenteMusica.maximumValue = Float(self.PlaylistMusicasViewControl.tabBarControl.player.duration)
            
            
            //This is to show and compute current time
            let currentTime1 = Int((self.PlaylistMusicasViewControl.tabBarControl.player.duration))
            let minutes = currentTime1/60
            let seconds = currentTime1 - minutes * 60
            self.TempoMaximoLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.AtualizarSliderMusica), userInfo: nil, repeats: true)
            
            self.PlaylistMusicasViewControl.tabBarControl.player.delegate = self
            self.PlaylistMusicasViewControl.tabBarControl.player.prepareToPlay()
            self.PlaylistMusicasViewControl.tabBarControl.player.play()
            self.PlaylistMusicasViewControl.tabBarControl.player.numberOfLoops = 0
            
            self.BotaoPlay.setTitle("Pause", for: .normal)
            //self.PlaylistMusicasViewControl.BotaoPlay.setTitle("Pause", for: .normal)
            
        }
         catch let error as NSError {
             print(error.localizedDescription)
         }
    }
    
    @objc func BotaoPlayMusicaFunc(){
        if self.PlaylistMusicasViewControl.tabBarControl.player.isPlaying {
            self.BotaoPlay.setTitle("Play", for: .normal)
            //self.PlaylistMusicasViewControl.BotaoPlay.setTitle("Play", for: .normal)
            self.PlaylistMusicasViewControl.tabBarControl.player.pause()
        } else {
            self.BotaoPlay.setTitle("Pause", for: .normal)
            //self.PlaylistMusicasViewControl.BotaoPlay.setTitle("Pause", for: .normal)
            self.PlaylistMusicasViewControl.tabBarControl.player.play()
        }
    }
    
    @objc func BotaoLoopFunc(){
        if(self.BotaoLoop.currentTitle == "A- Loop"){
            self.BotaoLoop.setTitle("Loop", for: .normal)
            self.PlaylistMusicasViewControl.tabBarControl.player.numberOfLoops = -1
        } else if (self.BotaoLoop.currentTitle == "Loop" ) {
            self.BotaoLoop.setTitle("A-", for: .normal)
            self.PlaylistMusicasViewControl.tabBarControl.player.numberOfLoops = 0
        } else {
            self.BotaoLoop.setTitle("A- Loop", for: .normal)
            self.PlaylistMusicasViewControl.tabBarControl.player.numberOfLoops = 0
        }
    }
    
    @objc func BotaoProximoFunc(){
        if(self.ListaMusica.count-1 == self.IndexMusica){
            let ProximoIndex = 0
            self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
        } else {
            let ProximoIndex = self.IndexMusica + 1
            self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
        }
    }
    
    @objc func BotaoAnteriorFunc(){
        //colocar para se a musica estiver + do que 15 segundos, ele vai ir para musica anterior, se estiver mais doq 15s, ele vai voltar para o inicio da musica atual
        
        if(self.IndexMusica == 0){
            let ProximoIndex = self.ListaMusica.count - 1
            self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
        } else {
            let ProximoIndex = self.IndexMusica - 1
            self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        if(self.BotaoLoop.currentTitle == "A-"){
            if(self.ListaMusica.count-1 == self.IndexMusica){
                //self.player.stop()
                self.PlaylistMusicasViewControl.tabBarControl.player.stop()
                self.BotaoPlay.setTitle("Play", for: .normal)
            } else {
                let ProximoIndex = self.IndexMusica + 1
                self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
            }
        } else if (self.BotaoLoop.currentTitle == "A- Loop" ) {
            if(self.ListaMusica.count-1 == self.IndexMusica){
                let ProximoIndex = 0
                self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
            } else {
                let ProximoIndex = self.IndexMusica + 1
                self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
            }
        } else {
        }
        
    }
    
    @objc func AtualizarSliderMusica(){
        self.TempoCurrenteMusica.value = Float(self.PlaylistMusicasViewControl.tabBarControl.player.currentTime)
        let currentTime1 = Int((self.PlaylistMusicasViewControl.tabBarControl.player.currentTime))
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        self.TempoAtualLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    @IBAction @objc func ClickSlider(_ sender: Any) {
        self.PlaylistMusicasViewControl.tabBarControl.player.stop()
        self.PlaylistMusicasViewControl.tabBarControl.player.currentTime = TimeInterval(self.TempoCurrenteMusica.value)
        self.PlaylistMusicasViewControl.tabBarControl.player.prepareToPlay()
        self.PlaylistMusicasViewControl.tabBarControl.player.play()
    }
    
}
