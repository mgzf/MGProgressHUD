//
//  MGProgressConfiguration.swift
//  MGProgressHUD
//
//  Created by song on 2017/11/10.
//

import Foundation


public class MGProgressConfiguration {
    
    public static let shared: MGProgressConfiguration = MGProgressConfiguration()
    
    public var animationMHz: Double = 0.03
    
    private var loadingImagesAction: (() -> [UIImage]?)? = nil
    private var successImageAction: (() -> UIImage?)?
    private var failedImageAction: (() -> UIImage?)?

    public func config(_ loadingImages: @escaping () -> [UIImage]?){
        loadingImagesAction = loadingImages
    }
    
    public func configSuccessImage(_ successImage: @escaping () -> UIImage?) {
        successImageAction = successImage
    }
    
    public func configFailedImage(_ failedImage: @escaping () -> UIImage?) {
        failedImageAction = failedImage
    }
    
    public func images() -> [UIImage]? {
        if let `loadingImagesAction` = loadingImagesAction {
            return loadingImagesAction()
        }
        return nil
    }
    
    public func successImage() -> UIImage? {
        if let `successImageAction` = successImageAction, let image = successImageAction() {
            return image
        }
        let image = UIImage(named: "ic_whiteCheck", in: Bundle(for: MGProgressHUD.self), compatibleWith: nil)
        return image
    }
    
    public func failedImage() -> UIImage? {
        if let `failedImageAction` = failedImageAction, let image = failedImageAction() {
            return image
        }
        let image = UIImage(named: "error", in: Bundle(for: MGProgressHUD.self), compatibleWith: nil)
        return image
    }
}

@objc public extension MGProgressHUD {
    
    @discardableResult
    @objc public class func  showLoadingView(_ toView: UIView!, message: String? = nil) -> MGProgressHUD? {
        
        
        let progressView = MGProgressHUD.showView(toView,
                                                  iconImages: loadingImages(),
                                                  message: nil,
                                                  messageColor: nil,
                                                  showBgView: false,
                                                  detailText: nil,
                                                  detailColor: nil,
                                                  loationMode: nil)
        progressView?.contentView.backgroundColor = UIColor.clear
        progressView?.contentView.layer.borderWidth = 0
        progressView?.contentView.layer.shadowColor = UIColor.clear.cgColor
        progressView?.marginEdgeInsets = UIEdgeInsets(top: 5, left: UIScreen.main.bounds.width / 2 - 50, bottom: 5, right: UIScreen.main.bounds.width / 2 - 50)
        
        return progressView
    }
    
    @discardableResult
    @objc public class func showLoadingFillView(_ toView: UIView!, message: String? = nil) -> MGProgressHUD? {
        
        let progressView = MGProgressHUD.showView(
            toView,
            iconImages: loadingImages(),
            message: message,
            messageColor: nil,
            showBgView: true,
            detailText: nil,
            detailColor: nil,
            loationMode: nil)
        progressView?.backgroundColor = toView.backgroundColor
        progressView?.marginEdgeInsets = UIEdgeInsets(top: 5, left: UIScreen.main.bounds.width / 2 - 50, bottom: 5, right: UIScreen.main.bounds.width / 2 - 50)
        return progressView
    }
    
    private class func loadingImages() -> [UIImage]? {
        var images:[UIImage]? = MGProgressConfiguration.shared.images()
        if images == nil {
            images  = [UIImage]()
            var bundle = Bundle(identifier: "org.cocoapods.MGProgressHUD")
            if let imagePath = bundle?.path(forResource: "Resources", ofType: "bundle") {
                bundle = Bundle(path: imagePath)
            }
            
            for index in 1..<10 {
                if let image = UIImage(named: "loading" + String(index), in: bundle, compatibleWith: nil) {
                    images?.append(image)
                }
            }
        }
        return images
    }
}
