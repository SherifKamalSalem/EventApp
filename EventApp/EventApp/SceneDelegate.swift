//
//  SceneDelegate.swift
//  EventApp
//
//  Created by Sherif Kamal on 10/31/21.
//

import UIKit
import EventsPlatform
import EventsCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let eventTypesLoader = RemoteEventTypesLoader(url: URL(string: "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes")!, client: client)
        EventTypesUIComposer.eventTypesComposedWith(eventTypesLoader: eventTypesLoader) { [weak self] controller in
            guard let self = self else { return }
            self.window?.rootViewController = UINavigationController(rootViewController: controller)
            window.makeKeyAndVisible()
        }
    }
}

