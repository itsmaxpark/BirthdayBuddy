//
//  CropViewController.swift
//  BirthdayBuddy
//
//  Created by Max Park on 4/8/22.
//

import UIKit

/// Subclass of UIView that allows user touch inputs to pass to the view directly below it
class CropAreaView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

protocol CropViewControllerDelegate: AnyObject {
    func didCropImage(image: UIImage?)
}

class CropViewController: UIViewController {
    
    var initialImage: UIImage?
    var finalImage: UIImage?
    weak var delegate: CropViewControllerDelegate?
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = true
        view.maximumZoomScale = 10
        
        return view
    }()
    private let cropImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let overlayImageView: CropAreaView = {
        let view = CropAreaView()
        view.backgroundColor = .black
        
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.alpha = 0.5
        return view
    }()
    
    private let overlayLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        return layer
    }()
    
    private let overlayReferenceView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Crop Image", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapCancel))

        cropImageView.image = initialImage
        
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(cropImageView)
        view.addSubview(overlayImageView)
        
    }
    @objc func didTapDone() {
        self.cropImage()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didTapCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CropViewController: UIScrollViewDelegate {
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.frame
        cropImageView.frame = view.frame
        overlayImageView.frame = scrollView.frame
        overlayReferenceView.frame = CGRect(
            x: scrollView.center.x - 150,
            y: scrollView.center.y - 150,
            width: 300,
            height: 300
        )
        overlayLayer.frame = overlayImageView.bounds
        createOverlay()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cropImageView
    }
}

extension CropViewController {
    private func addContraints() {
        var constraints = [NSLayoutConstraint]()
        // add
        constraints.append(overlayImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor))
        constraints.append(overlayImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor))
        constraints.append(overlayImageView.topAnchor.constraint(equalTo: scrollView.topAnchor))
        constraints.append(overlayImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor))
        //activate
        NSLayoutConstraint.activate(constraints)
    }
    private func createOverlay() {
        let path = UIBezierPath(rect: overlayImageView.bounds)
        path.append(UIBezierPath(rect: overlayReferenceView.frame))
        overlayLayer.path = path.cgPath
        
        overlayImageView.layer.mask = overlayLayer
    }
    private func cropImage() {
        let croppedCGImage = cropImageView.image?.cgImage?.cropping(to: overlayReferenceView.frame)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        self.finalImage = croppedImage
        self.delegate?.didCropImage(image: self.finalImage)
    }
}
