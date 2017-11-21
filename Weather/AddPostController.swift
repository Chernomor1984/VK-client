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
import Photos

class AddPostController: UIViewController {
    @IBOutlet var textView: UITextView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var doneBarItem: UIBarButtonItem!
    
    var pointAddress = ""
    var inputText = ""
    
    let minZoom: Float = 8.0
    let defaultZoom: Float = 14.0
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
        let cm = GMSCameraPosition.camera(withTarget: coordinate, zoom: defaultZoom)
        return cm
    }()
    
    private lazy var mapView: GMSMapView = {
        let mv = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mv.isMyLocationEnabled = true
        return mv
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(mapView)
        configureMapViewConstraints()
        configureTextView()
        configureMapView()
        LocationService.sharedInstance.delegete = self
        LocationService.sharedInstance.startUpdateLocations()
    }
    
    // MARK: - Private
    
    private func configureTextView() {
        let closeBarItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeKeyboard(sender:)))
        let frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 40.0))
        textView.addToolbar(frame: frame, items: [closeBarItem])
        textView.addBorder(colour: .groupTableViewBackground)
        textView.delegate = self
    }
    
    private func configureMapView() {
        /**
         2. фотогалерея
         3. Отправка пост-запроса в вк
         */
        mapView.delegate = self
        mapView.setMinZoom(minZoom, maxZoom: maxZoom)
        addUserLocationButton()
    }
    
    private func addUserLocationButton() {
        let userLocationButton = UIButton(type: .roundedRect)
        mapView.addSubview(userLocationButton)
        let image = UIImage(named: "user_location_button")
        userLocationButton.setBackgroundImage(image, for: .normal)
        userLocationButton.addTarget(self, action: #selector(updateLocations), for: .touchUpInside)
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        userLocationButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        userLocationButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        let bottom = NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: userLocationButton, attribute: .bottom, multiplier: 1.0, constant: 8.0);
        let trailing = NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: userLocationButton, attribute: .trailing, multiplier: 1.0, constant: 8.0)
        mapView.addConstraints([bottom, trailing])
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
    
    private func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showImageGallery() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        present(imagePicker, animated: true) {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func closeKeyboard(sender: Any) {
        textView.endEditing(true)
    }
    
    @objc private func updateLocations() {
        LocationService.sharedInstance.startUpdateLocations()
    }
    
    @IBAction func imageGalleryTapHandler(sender: UIBarButtonItem) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .restricted:
                self?.showAlert(title: "Ууупс!", message: "Доступ к фотогалерее ограничен")
            case . denied:
                self?.showAlert(title: "Ууупс!", message: "Доступ к фотогалерее запрещён")
            default:
                self?.showImageGallery()
                break
            }
        }
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

extension AddPostController: LocationServiceDelegate {
    func didUpdateLocations(locationService: LocationService, coordinates: CLLocationCoordinate2D) {
        let position = GMSCameraPosition.camera(withTarget: coordinates, zoom: defaultZoom)
        mapView.animate(to: position)
        locationService.stopUpdateLocations()
    }
}

extension AddPostController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    }
}

extension AddPostController: UINavigationControllerDelegate {}
