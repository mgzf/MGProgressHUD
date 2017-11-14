//
//  MGProgressConfiguration.swift
//  MGProgressHUD
//
//  Created by song on 2017/11/10.
//

import Foundation


public class MGProgressConfiguration {
    
    public static let shared: MGProgressConfiguration = MGProgressConfiguration()
    
    private var loadingImagesAction: (() -> [UIImage]?)? = nil

    public func config(_ loadingImages: @escaping () -> [UIImage]?){
        loadingImagesAction = loadingImages
    }
    
    public func images() -> [UIImage]? {
        if let `loadingImagesAction` = loadingImagesAction {
            return loadingImagesAction()
        }
        return nil
    }
}

public extension MGProgressHUD {
    
    @discardableResult
    public class func  showLoadingView(_ toView: UIView!, message: String?) -> MGProgressHUD? {
        
        
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
    public class func showLoadingFillView(_ toView: UIView!, message: String?) -> MGProgressHUD? {
        
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
