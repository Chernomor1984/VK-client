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
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var doneBarItem: UIBarButtonItem!
    
    var pointAddress = ""
    var inputText = ""
    
    let minZoom: Float = 6.0
    let maxZoom: Float = 19.0
    
    lazy var reverseGeoCoderClosure: GMSReverseGeocodeCallback = { (response, error) in
        if let error = error {
            print("geocoding finished with error:\(error.localizedDescription)")
            return
        }
        
        guard let response = response, let address = response.firstResult() else {
            print("geocoding finished with no address")
            return
        }
        self.constructAddress(from: address)
    }
    
    lazy var geoCoder: GMSGeocoder = {
        let gc = GMSGeocoder()
        return gc
    }()
    
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
        configureTextView()
        mapView.delegate = self
    }
    
    // MARK: - Private
    
    private func configureTextView() {
        let closeBarItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeKeyboard(sender:)))
        let frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 40.0))
        textView.addToolbar(frame: frame, items: [closeBarItem])
        textView.addBorder(colour: .groupTableViewBackground)
        textView.delegate = self
    }
    
    private func constructAddress(from response: GMSAddress) {
        guard let lines = response.lines else {
            return
        }
        pointAddress = lines.reduce("", { line1, line2 in
            return (line1.isEmpty) ? line2 : line2 + ", " + line1
        })
        updateTextView()
    }
    
    private func updateTextView() {
        if !inputText.isEmpty {
            let fullText = inputText + "\r\n" + pointAddress
            textView.text = fullText
            return
        }
        
        self.textView.text = pointAddress
        self.doneBarItem.isEnabled = true
    }
    
    private func configureMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([guide.bottomAnchor.constraintEqualToSystemSpacingBelow(mapView.bottomAnchor, multiplier: 1.0)])
        } else {
            let standardSpacing: CGFloat = 0.0
            NSLayoutConstraint.activate([bottomLayoutGuide.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: standardSpacing)])
        }
        let top = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 8.0);
        let leading = NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: mapView, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        view.addConstraints([top, leading, trailing])
    }
    
    // MARK: - Actions
    
    @objc private func closeKeyboard(sender: Any) {
        textView.endEditing(true)
    }
}

extension AddPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        inputText = textView.text.components(separatedBy: pointAddress).first ?? ""
        let textViewIsEmpty = inputText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        self.doneBarItem.isEnabled = !textViewIsEmpty && !self.pointAddress.isEmpty
    }
}

extension AddPostController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        self.geoCoder.reverseGeocodeCoordinate(coordinate, completionHandler: self.reverseGeoCoderClosure)
    }
}
