//
//  LaunchViewController.swift
//  Delta
//
//  Created by Riley Testut on 8/8/16.
//  Copyright © 2016 Riley Testut. All rights reserved.
//

import UIKit
import Roxas

import Harmony

class LaunchViewController: RSTLaunchViewController
{
    static func make(game: Game) -> LaunchViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! LaunchViewController
        vc.game = game
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    var deepLinkGame: Game?
    var game: Game!
    
    @IBOutlet private var gameViewContainerView: UIView!
    private(set) var gameViewController: GameViewController!
    
    private var presentedGameViewController: Bool = false
    
    private var didAttemptStartingSyncManager = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.gameViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.gameViewController?.prefersStatusBarHidden ?? false
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.gameViewController
    }
    
    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.gameViewController
    }
    
    override var shouldAutorotate: Bool {
        return self.gameViewController?.shouldAutorotate ?? true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.gameViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard segue.identifier == "embedGameViewController" else { return }
        
        self.gameViewController = segue.destination as? GameViewController
        gameViewController.menuTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

extension LaunchViewController
{
    override var launchConditions: [RSTLaunchCondition] {
        let isDatabaseManagerStarted = RSTLaunchCondition(condition: { DatabaseManager.shared.isStarted }) { (completionHandler) in
            DatabaseManager.shared.start(completionHandler: completionHandler)
        }
        
        let isSyncingManagerStarted = RSTLaunchCondition(condition: { self.didAttemptStartingSyncManager }) { (completionHandler) in
            self.didAttemptStartingSyncManager = true
            
            SyncManager.shared.start(service: Settings.syncingService) { (result) in
                switch result
                {
                case .success: completionHandler(nil)
                case .failure(let error): completionHandler(error)
                }
            }
        }
        
        // Repair database _after_ starting SyncManager so we can access RecordController.
        let isDatabaseRepaired = RSTLaunchCondition(condition: { !UserDefaults.standard.shouldRepairDatabase }) { completionHandler in
            let repairViewController = RepairDatabaseViewController()
            repairViewController.completionHandler = { [weak repairViewController] in
                repairViewController?.dismiss(animated: true)
                
                UserDefaults.standard.shouldRepairDatabase = false
                completionHandler(nil)
            }
            
            let navigationController = UINavigationController(rootViewController: repairViewController)
            self.present(navigationController, animated: true)
        }
        
        return [isDatabaseManagerStarted, isSyncingManagerStarted, isDatabaseRepaired]
    }
    
    override func handleLaunchError(_ error: Error)
    {
        do
        {
            throw error
        }
        catch is HarmonyError
        {
            // Ignore
            self.handleLaunchConditions()
        }
        catch
        {
            let alertController = UIAlertController(title: NSLocalizedString("Unable to Launch Delta", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default, handler: { (action) in
                self.handleLaunchConditions()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func finishLaunching()
    {
        super.finishLaunching()
        
        guard !self.presentedGameViewController else { return }
        self.presentedGameViewController = true
        
        PatreonAPI.shared.refreshPatreonAccount()
        
        if #available(iOS 17.5, *)
        {
            FriendZoneManager.shared.updatePatronsIfNeeded()
        }
        
        func showGameViewController()
        {
            self.view.bringSubviewToFront(self.gameViewContainerView)
            
            self.setNeedsStatusBarAppearanceUpdate()
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
        
        if let deepLinkGame, deepLinkGame != (self.gameViewController.game as? Game)
        {
            // Set GameViewController's game to deepLinkGame only if it's a different game.
            self.gameViewController.game = deepLinkGame
        }
        //self.gameViewController.game = game
        if self.gameViewController.game != nil
        {
            // self.deepLinkGame may be nil, but if gameViewController.game isn't then show it anyway.
            
            UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                showGameViewController()
               
                
            }) { (finished) in
                self.gameViewController.viewDidAppear(true)
                
                self.gameViewController.startEmulation()
            }
        }
        else
        {
            if game.type.rawValue == "com.rileytestut.delta.game.nes" {
                showGameViewController()
                self.gameViewController.view.subviews.map { $0.alpha = 0 }
                self.gameViewController.performSegue(withIdentifier: "showInitialGamesViewController", sender: nil)
                self.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (context) in
                    
                    var gameCollectionViewController: GameCollectionViewController?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            for window in windowScene.windows {
                                print("🔹 Window: \(window)")
                                self.printViewHierarchy(of: window, gameCollectionViewController: &gameCollectionViewController)
                            }
                        }
                        if let gameCVC = gameCollectionViewController {
                            print("Found: \(gameCVC)")
                            print("Nav: \(gameCVC.navigationController)")
                            if let navigationController = gameCVC.navigationController {
                                for vc in navigationController.viewControllers {
                                    //    vc.view.alpha = 0
                                }
                            }
                            gameCVC.game = self.game
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.gameViewController.view.subviews.map { $0.alpha = 1 }
                            }
                        }
                    }
                    
                    
                    
                    
                })
            } else {
                self.gameViewController.game = self.game
                self.gameViewController.viewDidAppear(true)
                showGameViewController()
                self.gameViewController.startEmulation()
            }
        }
    }
    func printViewHierarchy(of view: UIView, level: Int = 0, gameCollectionViewController: inout GameCollectionViewController?) {
        let indentation = String(repeating: "  ", count: level)
        print("\(indentation)- \(type(of: view))")

        // If the view is a UIViewController's root view, print its associated view controller
        if let viewController = findViewController(for: view) {
            if viewController is GameCollectionViewController {
                gameCollectionViewController = viewController as? GameCollectionViewController
            }
            print("\(indentation)  🎮 View Controller: \(type(of: viewController))")
        }

        for subview in view.subviews {
            printViewHierarchy(of: subview, level: level + 1, gameCollectionViewController: &gameCollectionViewController)
        }
    }

    // Function to find the ViewController associated with a UIView
    func findViewController(for view: UIView) -> UIViewController? {
        var responder: UIResponder? = view
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

class CustomNavigationController: UINavigationController {
    func locateGameCollectionViewController() -> GameCollectionViewController? {
        // Start the search from the navigation controller's root view
        return findGameCollectionViewController(in: self.view)
    }
    func findGameCollectionViewController(in view: UIView) -> GameCollectionViewController? {
        // Check if the current view is associated with a GameCollectionViewController
        if let viewController = view.findViewController() as? GameCollectionViewController {
            return viewController
        }
        
        // Recursively inspect subviews
        for subview in view.subviews {
            if let found = findGameCollectionViewController(in: subview) {
                return found
            }
        }
        
        // If not found in this branch, return nil
        return nil
    }
}
import UIKit

extension UIView {
    /// Recursively traverses the responder chain to find the view controller responsible for this view.
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
