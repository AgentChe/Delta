//
//  SplashViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import Roxas
import Harmony
import DeltaCore

final class SplashViewController: RSTLaunchViewController {
    private lazy var mainView = SplashView()
    
    private lazy var didAttemptStartingSyncManager = false
    private lazy var sdkInitialized = false
    private lazy var launchFinished = false
    
    private lazy var sdkInitialize = SplashReceiptValidationObserver()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkInitialize.observe { [weak self] in
            self?.sdkInitialized = true
            self?.waitOrNext()
        }
    }
}

// MARK: Public
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
    
    override var launchConditions: [RSTLaunchCondition] {
        let isDatabaseManagerStarted = RSTLaunchCondition(condition: { DatabaseManager.shared.isStarted }) { completionHandler in
            DatabaseManager.shared.start(completionHandler: completionHandler)
        }
        
        let isSyncingManagerStarted = RSTLaunchCondition(condition: { [weak self] in
            self?.didAttemptStartingSyncManager ?? false
        }, action: { [weak self] completionHandler in
            self?.didAttemptStartingSyncManager = true
            
            SyncManager.shared.start(service: Settings.syncingService) { result in
                switch result {
                case .success:
                    completionHandler(nil)
                case .failure(let error):
                    completionHandler(error)
                }
            }
        })
        
        let isDatabaseRepaired = RSTLaunchCondition(condition: { false }) { completionHandler in
            completionHandler(nil)
        }
        
        return [isDatabaseManagerStarted, isSyncingManagerStarted, isDatabaseRepaired]
    }
    
    override func finishLaunching() {
        super.finishLaunching()
        
        launchFinished = true
        waitOrNext()
    }
}

// MARK: Private
private extension SplashViewController {
    func waitOrNext() {
        if sdkInitialized && launchFinished {
            setPreferredSkins()
        }
    }
    
    func setPreferredSkins() {
        let skinUrls = Set([
            Bundle.main.url(forResource: "GBA", withExtension: "deltaskin")!,
            Bundle.main.url(forResource: "GBC", withExtension: "deltaskin")!,
            Bundle.main.url(forResource: "SNES", withExtension: "deltaskin")!,
            Bundle.main.url(forResource: "N64", withExtension: "deltaskin")!,
            Bundle.main.url(forResource: "NES", withExtension: "deltaskin")!
        ])
        
        DatabaseManager.shared.importControllerSkins(at: skinUrls, completion: { [weak self] skins, errors in
            let traits = DeltaCore.ControllerSkin.Traits(
                device: .iphone,
                displayType: .edgeToEdge,
                orientation: .portrait
            )
            
            skins.forEach { skin in
                if let system = System.init(gameType: skin.gameType) {
                    Settings.setPreferredControllerSkin(skin, for: system, traits: traits)
                }
            }
            
            self?.goNext()
        })
    }
    
    func goNext() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.route()
        }
    }
    
    func route() {
        if !OnboardingViewController.wasViewed() {
            UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
        } else {
            if SessionManager().hasActiveSubscriptions() {
                UIApplication.shared.keyWindow?.rootViewController = NavigationController(rootViewController: MainViewController.make())
            } else {
                let vc = PaygateViewController.make {
                    UIApplication.shared.keyWindow?.rootViewController = NavigationController(rootViewController: MainViewController.make())
                }
                present(vc, animated: true)
            }
        }
    }
}
