//
//  SceneDelegate.swift
//  ChatApp-iOS
//
//  Created by Leah Joy Ylaya on 9/18/20.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        if (FirebaseAuth.Auth.auth().currentUser == nil) {
            UserData.shared.clear() { [weak self] in
                guard let newSelf = self else {
                    return
                }
                //Make sure to do this else you won't get
                //the windowScene object using UIApplication.shared.connectedScenes
                newSelf.window?.windowScene = windowScene
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "signupLogin")
                let nav = UINavigationController(rootViewController: vc)
                nav.setNavigationBarHidden(true, animated: false)
                newSelf.window?.rootViewController = nav
                newSelf.window?.makeKeyAndVisible()
            }
        } else {
            UserData.shared.setInfoByDefault { [weak self] in
                guard let newSelf = self else {
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "chatVC")
                let nav = UINavigationController(rootViewController: vc)
                nav.setNavigationBarHidden(false, animated: false)
                newSelf.window?.rootViewController = nav
                newSelf.window?.makeKeyAndVisible()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

