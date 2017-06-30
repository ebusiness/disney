//
//  ImageBrowserController.swift
//  disney
//
//  Created by ebuser on 2017/6/26.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Kingfisher
import Photos
import UIKit

class ImageBrowserController: UIViewController, FileLocalizable {

    let localizeFileName = "Homepage"

    let scrollView: ImageScrollView
    let container: UIView
    let imageView: UIImageView
    let contentFrame: CGRect
    let imageURL: URL?
    let ratio: CGFloat
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var photoSaveAssistant: PhotoSaveAssistant?

    private var imageDownloaded = false

    init(contentFrame: CGRect, imageURL: URL?) {
        scrollView = ImageScrollView()
        container = UIView(frame: .zero)
        imageView = UIImageView(frame: .zero)
        self.contentFrame = contentFrame
        self.imageURL = imageURL
        ratio = contentFrame.size.height / contentFrame.size.width
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = UIColor.black

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        view.addGestureRecognizer(tapGesture)

        addSubScrollView()
        addSubContainer()
        addSubImageView()

        scrollView.clipsToBounds = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Image browser deinited")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        transitionAnimate()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func transitionAnimate() {
        let transitionView = UIImageView(frame: contentFrame)
        transitionView.contentMode = .scaleAspectFill
        transitionView.kf.setImage(with: imageURL)
        view.addSubview(transitionView)
        var targetFrame = CGRect.zero
        targetFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
        targetFrame.origin.y = (screenHeight - screenWidth * ratio) / 2
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        transitionView.frame = targetFrame
        }, completion: {[weak self] _ in
            self?.imageView.isHidden = false
            transitionView.removeFromSuperview()
            self?.addOrientationListener()
        })
    }

    private func addOrientationListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    private func addSubScrollView() {
        scrollView.zoomView = container
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func addSubContainer() {
        scrollView.addSubview(container)
        var containerFrame = CGRect.zero
        containerFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
        containerFrame.origin.y = (screenHeight - screenWidth * ratio) / 2
        container.frame = containerFrame
        scrollView.contentSize = container.bounds.size

        scrollView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:)))
        scrollView.addGestureRecognizer(longPress)
    }

    private func addSubImageView() {
        var imageFrame = CGRect.zero
        imageFrame.size = CGSize(width: screenWidth, height: screenWidth * ratio)
        imageView.frame = imageFrame
        imageView.contentMode = .scaleAspectFill
        imageView.kf.setImage(with: imageURL,
                              placeholder: nil,
                              options: nil,
                              progressBlock: nil,
                              completionHandler: { [weak self] image, _, _, _ in
                                if image != nil {
                                    self?.imageDownloaded = true
                                }
        })
        container.addSubview(imageView)
        imageView.isHidden = true
    }

    @objc
    private func tapHandler(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }

    @objc
    private func longPressHandler(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            showMenu()
        }
    }

    private func showMenu() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: localize(for: "Edit Menu Save"),
                                       style: .default,
                                       handler: { [weak self] _ in
                                        self?.saveImage()
        })
        let cancelAction = UIAlertAction(title: localize(for: "Edit Menu Cancel"),
                                         style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func saveImage() {
        guard imageDownloaded else { return }
        guard let image = imageView.image else { return }

        photoSaveAssistant = PhotoSaveAssistant(image: image)
        photoSaveAssistant?.save()
    }

    @objc
    private func orientationChange(_ sender: Any) {
        let currentOrientation = UIDevice.current.orientation
        switch currentOrientation {
        case .landscapeLeft:
            changeToLandscapeLeft()
        case .landscapeRight:
            changeToLandscapeRight()
        case .portrait:
            changeToLandscapePortrait()
        default:
            break
        }
    }

    private func changeToLandscapeRight() {
        let scale = 1 / ratio
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let transform = scaleTransform.rotated(by: -CGFloat.pi / 2)

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.transform = transform
        }, completion: { _ in
            self.scrollView.contentSize = self.container.bounds.size
        })
    }

    private func changeToLandscapeLeft() {
        let scale = 1 / ratio
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let transform = scaleTransform.rotated(by: CGFloat.pi / 2)

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.transform = transform
        }, completion: { _ in
            self.scrollView.contentSize = self.container.bounds.size
        })
    }

    private func changeToLandscapePortrait() {
        let transform = CGAffineTransform.identity

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.transform = transform
        }, completion: { _ in
            self.scrollView.contentSize = self.container.bounds.size
        })
    }
}

class ImageScrollView: UIScrollView, UIScrollViewDelegate {

    var zoomView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        minimumZoomScale = 1
        maximumZoomScale = 2
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollViewDecelerationRateFast
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // center the zoom view as it becomes smaller than the size of the screen
        guard let zoomView = zoomView else { return }
        let boundsSize = bounds.size
        var frameToCenter = zoomView.frame

        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        zoomView.frame = frameToCenter
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
}
