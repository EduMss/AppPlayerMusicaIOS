//
//  PlayerMusicaViewController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 12/11/23.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerMusicaViewController: UIViewController, AVAudioPlayerDelegate {
    
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
        bt.setImage(UIImage(systemName: "repeat"), for: .normal)
        bt.tintColor = UIColor(red: 255, green: 255, blue: 255, a: 1)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoLoopFunc), for: .touchUpInside)
        
        bt.tag = 0
        
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
        bt.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        bt.tintColor = UIColor(red: 255, green: 255, blue: 255, a: 1)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoAnteriorFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var BotaoPlay:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(UIImage(systemName: "play.fill"), for: .normal)
        bt.tintColor = UIColor(red: 255, green: 255, blue: 255, a: 1)
        bt.backgroundColor = UIColor(red: 20, green: 20, blue: 20, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoPlayMusicaFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var BotaoProxima:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        bt.tintColor = UIColor(red: 255, green: 255, blue: 255, a: 1)
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
        } else if gesture.state == .changed {
            translation = gesture.translation(in: self.view)
            if translation.y < 0{
            } else {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.4, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn , animations: {
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
        self.TabBarControl = TabBarControl
    }
    
    public func Inicial(){
        self.IniciarAudioControl()
    }
    
    func IniciarAudioControl(){
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        setupRemoteTransportControls()
        setupNowPlaying()
    }
    
    public func Musica(Musicas:[String], index:Int){
        self.TabBarControl.player.stop()
        
        self.ListaMusica = Musicas
        self.IndexMusica = index
        
        self.NomeMusicaLabel.text = self.ListaMusica[IndexMusica]
        let nomeMusica: String = "\(self.ListaMusica[IndexMusica])"
        let NomeCortado = nomeMusica.prefix(40)
        self.TabBarControl.NomeMusicaButton.setTitle(String(NomeCortado), for: .normal)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(self.ListaMusica[IndexMusica])
        let mp3URL3 = URL(string: "\(destinationUrl)")!
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            self.TabBarControl.player = try AVAudioPlayer(contentsOf: mp3URL3, fileTypeHint: AVFileType.mp3.rawValue)
            self.TempoCurrenteMusica.maximumValue = Float(self.TabBarControl.player.duration)
            
            //This is to show and compute current time
            let currentTime1 = Int((self.TabBarControl.player.duration))
            let minutes = currentTime1/60
            let seconds = currentTime1 - minutes * 60
            self.TempoMaximoLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.AtualizarSliderMusica), userInfo: nil, repeats: true)
            
            self.TabBarControl.player.delegate = self
            self.TabBarControl.player.prepareToPlay()
            self.TabBarControl.player.play()
            self.TabBarControl.player.numberOfLoops = 0
            
            self.BotaoPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.TabBarControl.BotaoPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            self.setupNowPlaying()
            
        }
         catch let error as NSError {
             print(error.localizedDescription)
         }
    }
    
    @objc func BotaoPlayMusicaFunc(){
        if self.TabBarControl.player.isPlaying {
            self.BotaoPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.TabBarControl.BotaoPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.TabBarControl.player.pause()
            self.updateNowPlaying(isPause: false)
        } else {
            self.BotaoPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.TabBarControl.BotaoPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.TabBarControl.player.play()
            self.updateNowPlaying(isPause: true)
        }
    }
    
    @objc func BotaoLoopFunc(){
        if(self.BotaoLoop.tag == 0){ // A- Loop
            self.BotaoLoop.tag = 1
            self.BotaoLoop.setImage(UIImage(systemName: "repeat.1"), for: .normal)
            self.TabBarControl.player.numberOfLoops = 0//-1
        } else if (self.BotaoLoop.tag == 1 ) { // Loop
            self.BotaoLoop.tag = 2
            self.BotaoLoop.setImage(UIImage(systemName: "textformat.superscript"), for: .normal) // textformat.superscript  ||   repeat.1.circle
            self.TabBarControl.player.numberOfLoops = 0
        } else { // A-
            self.BotaoLoop.tag = 0
            self.BotaoLoop.setImage(UIImage(systemName: "repeat"), for: .normal)
            self.TabBarControl.player.numberOfLoops = 0
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        
        if(self.BotaoLoop.tag == 2){
            if(self.ListaMusica.count-1 == self.IndexMusica){
                //self.player.stop()
                self.TabBarControl.player.stop()
                //self.BotaoPlay.setTitle("Play", for: .normal)
                self.BotaoPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.TabBarControl.BotaoPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                let ProximoIndex = self.IndexMusica + 1
                self.Musica(Musicas:self.ListaMusica, index:ProximoIndex)
            }
        } else if (self.BotaoLoop.tag == 1) {
            self.Musica(Musicas:self.ListaMusica, index:self.IndexMusica)
            self.setupNowPlaying()
            
        } else if (self.BotaoLoop.tag == 0 ) {
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
        self.TempoCurrenteMusica.value = Float(self.TabBarControl.player.currentTime)
        let currentTime1 = Int((self.TabBarControl.player.currentTime))
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        self.TempoAtualLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    @IBAction @objc func ClickSlider(_ sender: Any) {
        self.TabBarControl.player.stop()
        self.TabBarControl.player.currentTime = TimeInterval(self.TempoCurrenteMusica.value)
        self.TabBarControl.player.prepareToPlay()
        self.TabBarControl.player.play()
    }
    
    //Command Center audio controls
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        //Você precisa ativar ou desativar os botões:
        //commandCenter.skipBackwardCommand.isEnabled = false
        //commandCenter.skipForwardCommand.isEnabled = false
        //commandCenter.playCommand.isEnabled = true
        //commandCenter.pauseCommand.isEnabled = true
        //commandCenter.previousTrackCommand.isEnabled = true
        //commandCenter.nextTrackCommand.isEnabled = true
        //commandCenter.stopCommand.isEnabled = true
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.TabBarControl.player.rate == 1.0 {
                self.BotaoPlayMusicaFunc()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.TabBarControl.player.rate == 1.0 {
                self.BotaoPlayMusicaFunc()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for next Track
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if self.TabBarControl.player.rate == 1.0 {
                self.BotaoProximoFunc()
                return .success
            }
            return .commandFailed
            
        }
        
        // Add handler for Previous Track
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if self.TabBarControl.player.rate == 1.0 {
                self.BotaoAnteriorFunc()
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.ListaMusica[self.IndexMusica]

        //if let image = UIImage(named: "artist") {
        //    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
        //        return image
        //    }
        //}
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.TabBarControl.player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.TabBarControl.player.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.TabBarControl.player.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        

    }
    
    func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.TabBarControl.player.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    func setupNotifications() {
        print("setupNotifications")
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       //name: AVAudioSession.interruptionNotification,
                                       name: AVAudioSession.interruptionNotification,
                                       object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        print("Interruption")
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }

        if type == .began {
            print("Interruption began")
            // Interruption began, take appropriate actions
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    print("Interruption Ended - playback should resume")
                    self.BotaoPlayMusicaFunc()
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("Interruption Ended - playback should NOT resume")
                }
            }
        }
    }
}

