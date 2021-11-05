//
//  SceneDelegate.swift
//  EventApp
//
//  Created by Sherif Kamal on 10/31/21.
//

import UIKit
import EventsPlatform
import EventsCore
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let store = try! CoreDataEventStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("events-store.sqlite"))
        let localEventsLoader = EventTypesLocalLoader(store: store)
        let eventTypesLoader = RemoteEventTypesLoader(url: URL(string: "http://private-7466b-eventtuschanllengeapis.apiary-mock.com/eventtypes")!, client: client)
        EventTypesUIComposer.eventTypesComposedWith(
            eventTypesLoader: EventTypesLoaderWithFallbackComposite(
                primary: EventTypesLoaderCacheDecorator(
                    decoratee: eventTypesLoader, cache: localEventsLoader)
                , fallback: localEventsLoader),
            selection: showEventDetails,
            completion: ({ [weak self] viewController in
                guard let self = self else { return }
                self.window?.rootViewController = UINavigationController(rootViewController: viewController)
                window.makeKeyAndVisible()
            })
        )
    }
    
    private func showEventDetails(for event: Event) {
        guard let eventDetailsViewController = UIStoryboard(name: "EventDetails", bundle: Bundle(for: EventDetailsViewController.self))
                .instantiateViewController(withIdentifier: "EventDetailsViewController")
                as? EventDetailsViewController,
              let navigationController = self.window?.rootViewController as? UINavigationController else { return }
        eventDetailsViewController.event = event
        navigationController.pushViewController(eventDetailsViewController, animated: true)
    }
}

