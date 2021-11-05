//
//  EventDetailsViewController.swift
//  EventsPlatform
//
//  Created by Sherif Kamal on 11/5/21.
//

import UIKit
import MapKit
import CoreLocation
import EventsCore

public final class EventDetailsViewController: UIViewController {
    @IBOutlet weak private(set) var backBtn: UIButton!
    @IBOutlet weak private(set) var eventNameLabel: UILabel!
    @IBOutlet weak private(set) var eventDescriptionLabel: UILabel!
    @IBOutlet weak private(set) var mapView: MKMapView!
    @IBOutlet weak private(set) var eventStartDateLabel: UILabel!
    @IBOutlet weak private(set) var eventImage: UIImageView!

    //Here I assigned the event directly just for simplicity even if it's considered a violates of MVP design pattern (the best practice it to declare view protocol like eventsview and create presenter ... the same as event listing feature)
    public var event: Event?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupMapCameraPosition()
        setupView()
    }
    
    private func setupView() {
        eventNameLabel.text = event?.name
        eventDescriptionLabel.text = event?.description
        eventStartDateLabel.text = event?.startDate
        // This is incorrect and violation of MVP design pattern but it considered a tradoffs 
        if let url = event?.cover {
            eventImage.downloaded(from: url)
        }
    }
    
    private func setupMapCameraPosition() {
        guard let event = event, let latitude = Double(event.latitude),
              let longitude = Double(event.longitude) else { return }
        let userCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: userCoordinate, eyeAltitude: 100000.0)

        let annotation = MKPointAnnotation()
        annotation.coordinate = userCoordinate
        mapView.addAnnotation(annotation)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    @IBAction private func backButtonAction(_ sender: Any) {
        //Also here the navigation is not the responsibilty of view controller but just for simplicity I make it like that
        self.navigationController?.popViewController(animated: true)
    }
}
