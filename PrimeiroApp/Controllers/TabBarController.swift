//
//  TabBarController.swift
//  PrimeiroApp
//
//  Created by Eduardo Matheus on 11/11/23.
//

import UIKit
import AVFoundation

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    lazy var NomeMusicaButton:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Nome Musica", for: .normal)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 12)
        bt.addTarget(self, action: #selector(self.BotaoAreaPlayerMusicaFunc), for: .touchUpInside)
        return bt
    }()
    
    lazy var BotaoPlay:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        //bt.setTitle("Pause", for: .normal)
        bt.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        bt.tintColor = UIColor(red: 255, green: 255, blue: 255, a: 1)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 12)
        bt.backgroundColor = UIColor(red: 55, green: 55, blue: 55, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoPlayMusicaFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var BotaoProxima:UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        //bt.setTitle("Proximo", for: .normal)
        bt.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        bt.tintColor = UIColor(red: 255, green: 255, blue: 255, a: 1)
        bt.titleLabel!.font = UIFont(name: "KohinoorBangla-Semibold" , size: 12)
        bt.backgroundColor = UIColor(red: 55, green: 55, blue: 55, a: 1)
        bt.layer.cornerRadius = 5
        
        bt.addTarget(self, action: #selector(self.BotaoProximoFunc), for: .touchUpInside)
        
        return bt
    }()
    
    lazy var AreaPlayerMusica:UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor(red: 97, green: 97, blue: 97, a: 1.0)
        
        sv.addArrangedSubview(self.NomeMusicaButton)
        sv.addArrangedSubview(self.BotaoPlay)
        sv.addArrangedSubview(self.BotaoProxima)

        sv.axis = .horizontal
        sv.alignment = .fill
        sv.setCustomSpacing(8, after: self.NomeMusicaButton)
        sv.setCustomSpacing(8, after: self.BotaoPlay)
        sv.setCustomSpacing(8, after: self.BotaoProxima)
        
        sv.layer.cornerRadius = 10
        sv.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        sv.isUserInteractionEnabled = true
        sv.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        
        return sv
    }()
    
    var BackgroundAreaPlayerMusica:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 97, green: 97, blue: 97, a: 1.0)

        return v
    }()

    var vc1: DownloadViewController!
    var vc2: MusicasViewController!
    var vc3: PlaylistMusicasViewController!
    var vc4: PlayerMusicaViewController!
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var playerSession: AVAudioSession = AVAudioSession()
    
    override func viewDidLoad() {
        //tamanho padrão do tabBar = 320x49.
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.backgroundColor = UIColor(red: 97, green: 97, blue: 97, a: 1.0)
        self.tabBar.tintColor = UIColor(red: 200, green: 200, blue: 200, a: 1.0)
        
        vc1 = DownloadViewController()
        vc2 = MusicasViewController()
        vc3 = PlaylistMusicasViewController()
        vc4 = PlayerMusicaViewController()
        
        vc2.TamanhoTabBar = self.tabBar.frame.size.width - (self.tabBar.frame.size.height * 3 )
        vc2.setTabBarControl(TabBarControl: self)
        vc3.TamanhoTabBar = self.tabBar.frame.size.width - (self.tabBar.frame.size.height * 3 )
        vc3.setTabBarControl(TabBarControl: self)
        
        vc1.title = "Download"
        vc2.title = "Musicas"
        vc3.title = "Playlists"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Download", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Musicas", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Playlists", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1,nav2,nav3], animated: false)
        
        self.selectedIndex = 1 //Default select in tabBar on inicialize
        //self.selectedIndex = 2
        
        self.tabBar.bringSubviewToFront(tabBar)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        
        if selectedIndex == 2{
            vc3.AtualizarPlaylist()
        } else if selectedIndex != 2{
            vc3.FecharJanelaPlaylist()
        }
        
        if selectedIndex == 1 {
            vc2.AtualizarPagina()
        } else if selectedIndex != 1 {
            vc2.FecharJanelaPlayer()
        }
    }
    
    func AdcionarMiniPlayer(){
        view.addSubview(self.BackgroundAreaPlayerMusica)
        view.addSubview(self.AreaPlayerMusica)
        
        NSLayoutConstraint.activate([
            self.BackgroundAreaPlayerMusica.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            self.BackgroundAreaPlayerMusica.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.BackgroundAreaPlayerMusica.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.BackgroundAreaPlayerMusica.heightAnchor.constraint(equalToConstant:  40.0),
            
            self.AreaPlayerMusica.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            self.AreaPlayerMusica.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.AreaPlayerMusica.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.AreaPlayerMusica.heightAnchor.constraint(equalToConstant:  40.0),
            
            self.BotaoProxima.widthAnchor.constraint(equalToConstant: 50),
            self.BotaoPlay.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func BotaoPlayMusicaFunc(){
        self.vc4.BotaoPlayMusicaFunc()
    }
    
    func SetPlayerMusicaViewControl(player: PlayerMusicaViewController){
        self.vc4 = player
    }
    
    @objc func BotaoProximoFunc(){
        self.vc4.BotaoProximoFunc()
    }
    
    @objc func BotaoAreaPlayerMusicaFunc(){
        self.present(self.vc4, animated: true, completion: nil)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation: CGPoint
        if gesture.state == .began {
        } else if gesture.state == .changed {
            translation = gesture.translation(in: self.view)
            if translation.y >= -40.0 && translation.y <= 5.0{
                self.AreaPlayerMusica.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.4, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseIn , animations: {
                if self.AreaPlayerMusica.transform.ty > 0 || self.AreaPlayerMusica.transform.ty > -30.0 {
                    self.AreaPlayerMusica.transform = .identity
                } else if self.AreaPlayerMusica.transform.ty > -30.0 || self.AreaPlayerMusica.transform.ty > -40.0 {
                    self.AreaPlayerMusica.transform = .identity

                    self.vc4.loadViewIfNeeded()
                    self.vc4.modalPresentationStyle = .currentContext
                    
                    NSLayoutConstraint.activate([
                        self.AreaPlayerMusica.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
                        self.AreaPlayerMusica.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor),
                        self.AreaPlayerMusica.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor),
                        self.AreaPlayerMusica.heightAnchor.constraint(equalToConstant:  40.0),
                    
                        self.BotaoProxima.widthAnchor.constraint(equalToConstant: 50),
                        self.BotaoPlay.widthAnchor.constraint(equalToConstant: 50),
                    ])
                    
                    self.present(self.vc4, animated: true, completion: nil)
                }
            })
        }
    }
}
