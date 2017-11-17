//
//  AddPostController.swift
//  VK
//
//  Created by Eugene Khizhnyak on 17.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class AddPostController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    let minZoom: Float = 6.0
    let maxZoom: Float = 19.0
    
    private lazy var camera: GMSCameraPosition = {
        let coordinate = CLLocationCoordinate2D()
        let cm = GMSCameraPosition.camera(withTarget: coordinate, zoom: minZoom)
        return cm
    }()
    
    private lazy var mapView: GMSMapView = {
        let mv = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mv.isMyLocationEnabled = true
        return mv
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(mapView)
        configureMapViewConstraints()
    }
    
    // MARK: - Private
    
    private func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([guide.bottomAnchor.constraintEqualToSystemSpacingBelow(mapView.bottomAnchor, multiplier: 1.0)])
        } else {
            let standardSpacing: CGFloat = 0.0
            NSLayoutConstraint.activate([bottomLayoutGuide.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: standardSpacing)])
        }
        let top = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1.0, constant: 0.0);
        let leading = NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: mapView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        view.addConstraints([top, leading, trailing])
    }
}
