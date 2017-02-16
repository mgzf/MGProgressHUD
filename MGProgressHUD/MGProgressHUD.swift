//
//  MGProgressHUD.swift
//  MGProgressHUD
//
//  Created by song on 16/7/8.
//  Copyright © 2016年 song. All rights reserved.
//

import UIKit

let KScreenWidth = UIScreen.mainScreen().bounds.width

func MGColor(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
}

func MGAttributedString(label:UILabel,text:String?,lineSpacing:CGFloat) -> NSAttributedString?{
    if nil != text {
        let string = NSMutableAttributedString(string: text!)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .ByWordWrapping
        style.alignment = label.textAlignment
        style.lineSpacing = lineSpacing
        style.headIndent = 0.0
        style.paragraphSpacing = 0.0
        style.paragraphSpacingBefore = 0.0
        style.firstLineHeadIndent = 0.0
        string.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text!.characters.count))
        string.addAttribute(NSFontAttributeName, value: label.font, range: NSRange(location: 0, length: text!.characters.count))
        string.addAttribute(NSForegroundColorAttributeName, value: label.textColor, range: NSRange(location: 0, length: text!.characters.count))
        return string
    }
    return nil
}

public enum  MGLocationMode{
    case Top
    case Center
    case Bottom
}

enum  MGCustomMode{
    case Default
    case Progress
}

/**
 外部变量
 labelAlignment：title对齐方式 默认居中对齐
 detailLabelAlignment：detailText对齐方式 默认居中对齐
 labelColor:title的颜色
 */


public class MGProgressHUD: UIView {
    
    /*! title对齐方式 默认居中对齐 */
    var labelAlignment = NSTextAlignment.Center {
        didSet{
            if label != nil {
                label.textAlignment = labelAlignment
            }
        }
    }
    /*! detailText对齐方式 默认居中对齐 */
    var detailLabelAlignment = NSTextAlignment.Center{
        didSet{
            if detailLabel != nil {
                detailLabel.textAlignment = detailLabelAlignment
            }
        }
    }
    /*! title的颜色 */
    var labelColor:UIColor? = MGColor(90, g: 90, b: 90){
        didSet{
            if label != nil {
                label.textColor = labelColor
            }
        }
    }
    /*! detailText的颜色 */
    var detailLabelColor:UIColor? = MGColor(102, g: 102, b: 102){
        didSet{
            if detailLabel != nil {
                detailLabel.textColor = detailLabelColor
            }
        }
    }
    /*! title的字体大小 */
    var labelFont = UIFont.systemFontOfSize(14){
        didSet{
            if label != nil {
                label.font = labelFont
            }
        }
    }
    /*! detailText的颜色 */
    var detailLabelFont = UIFont.systemFontOfSize(12){
        didSet{
            if detailLabel != nil {
                detailLabel.font = detailLabelFont
            }
        }
    }
    
    /*! title */
    var title:String? = ""{
        didSet{
            if label != nil {
                //                label.text = title
                label.attributedText = MGAttributedString(label, text: title, lineSpacing: labelFont.pointSize/5)
            }
        }
    }
    /*! detailText */
    var detailText:String? = ""{
        didSet{
            if detailLabel != nil {
                //                detailLabel.text = detailText
                detailLabel.attributedText = MGAttributedString(detailLabel, text: detailText, lineSpacing: detailLabelFont.pointSize/5)
            }
        }
    }
    
    /*! 设置title上面的View */
    var  customView:UIView?{
        didSet{
            if customView != nil {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectCustomViewTap))
                customView!.userInteractionEnabled = true
                customView!.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    /*! 设置最小边距边缘值() */
    var marginEdgeInsets:UIEdgeInsets = UIEdgeInsets(top: 13, left: 40, bottom: 10, right: 40) {
        didSet{
            layoutSubviews()
        }
    }
    
    /*! content显示出来的位置 */
    var locationMode:MGLocationMode? = MGLocationMode.Center{
        didSet{
            layoutSubviews()
        }
    }
    
    /*! content显示出来的位置 */
    var customMode:MGCustomMode? = MGCustomMode.Default{
        didSet{
            if customMode == MGCustomMode.Progress {
                let view1 = CircleDataView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
                view1.backgroundColor = UIColor.clearColor()
                self.customView = view1;
                self.contentView.addSubview(view1)
                layoutSubviews()
            }
        }
    }
    
    var progress:CGFloat = 0 {
        didSet{
            if let circleDataView = self.customView as? CircleDataView {
                circleDataView.progress = progress*100
            }
        }
    }
    
    /*! 点击背景后的回调 */
    var completionBlock : (() ->())!
    
    /*! 点击背景后的回调 */
    var selectCustomViewBlock : (() ->())!
    
    /*! manualHidden为true时 调用hiddenAllhubToView时不会消失 只有手动调用hiddenHubView*/
    var manualHidden = false
    
    
    /*! 类内使用属性 */
    private var contentView:UIView!
    private var label:UILabel!
    private var detailLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViewsToSelf()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViewsToSelf(){
        /*! 内容View */
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelfAction))
        userInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        contentView = UIView(frame:self.bounds)
        contentView.backgroundColor = MGColor(255, g: 255, b: 255)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        addSubview(contentView)
        
        //        let bgContentView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        //        bgContentView.alpha = 0.9
        //        bgContentView.frame = self.bounds
        //        bgContentView.autoresizingMask =  [.FlexibleWidth, .FlexibleHeight]
        //        bgContentView.layer.cornerRadius = contentView.layer.cornerRadius
        //        bgContentView.clipsToBounds = true;
        //        contentView.addSubview(bgContentView);
        
        /*! 设置自定的View */
        
        /*! titleLabel */
        label = UILabel(frame: CGRectZero)
        contentView.addSubview(label)
        label.textAlignment = labelAlignment
        label.backgroundColor = UIColor.clearColor()
        label.textColor = labelColor
        label.font = labelFont
        label.numberOfLines = 0;
        label.opaque = false;
        /*! detailLabel */
        detailLabel = UILabel(frame: CGRectZero)
        contentView.addSubview(detailLabel)
        detailLabel.textAlignment = detailLabelAlignment
        detailLabel.backgroundColor = UIColor.clearColor()
        detailLabel.textColor = detailLabelColor
        detailLabel.font = detailLabelFont
        detailLabel.numberOfLines = 0;
        detailLabel.opaque = false;
        //        detailText = "几点开始发了康师傅是否速度发货速度来看返回的数据库浪费都十分大方第三方辅导老师开发和大家快来辅导费地方但是"
    }
    
    /**
     点击背景事件回调
     */
    func  tapSelfAction(){
        if (completionBlock != nil) {
            completionBlock()
        }
    }
    
    /**
     点击Icon或customView事件的回调
     */
    func selectCustomViewTap(){
        if (selectCustomViewBlock != nil) {
            selectCustomViewBlock()
        }
    }
    
    /*! 自动识别坐标 */
    override public func layoutSubviews() {
        super.layoutSubviews()
        let maxWidth = bounds.width - marginEdgeInsets.left - marginEdgeInsets.right
        var contentSize:CGSize = CGSize(width: maxWidth, height:marginEdgeInsets.top)
        var  customViewWidth = CGFloat(0)
        if customView != nil {
            var customViewFitSize = CGSize(width: 0, height: 0)
            if let imageView = customView as? UIImageView
            {
                if imageView.animationImages?.count > 0  {
                    customViewFitSize = sizeToFit(imageView.animationImages![0].size, maxWidth: maxWidth - 10)
                }
                else if let image = imageView.image
                {
                    customViewFitSize = sizeToFit(image.size, maxWidth: maxWidth - 40)
                }
                else
                {
                    customViewFitSize = sizeToFit(customView!.bounds.size, maxWidth: maxWidth - 40)
                }
            }
            else
            {
                customViewFitSize = sizeToFit(customView!.bounds.size, maxWidth: maxWidth - 40)
            }
            customViewWidth = customViewFitSize.width
            customView!.frame = CGRectMake(0, marginEdgeInsets.top, customViewFitSize.width, customViewFitSize.height)
            var contentWidth =  customViewFitSize.width + 150  > maxWidth ?  maxWidth: customViewFitSize.width + 150
            contentWidth = contentWidth < maxWidth*2/3 ?  maxWidth*2/3 : contentWidth
            customView!.center = CGPointMake(contentWidth/2, contentSize.height+customViewFitSize.height/2)
            contentSize = CGSize(width: contentWidth, height: contentSize.height + customViewFitSize.height)
        }
        
        if title?.characters.count > 0 {
            let top = contentSize.height == marginEdgeInsets.top ? CGFloat(0.0):CGFloat(10.0)
            let labelFitSize = label.sizeThatFits(CGSize(width: contentSize.width - 40, height: CGFloat.max))
            if labelFitSize.width  <  customViewWidth + 50 && labelFitSize.width < contentSize.width - 30 &&  detailText?.characters.count == 0{
                contentSize = CGSize(width: customViewWidth + 80, height: contentSize.height)
            }
            label.frame = CGRect(origin: CGPointZero, size: labelFitSize)
            label.center = CGPoint(x: contentSize.width/2, y: top + contentSize.height+labelFitSize.height/2)
            contentSize = CGSize(width: contentSize.width, height: top + contentSize.height + labelFitSize.height)
            
            if customView == nil &&  detailText?.characters.count == 0{
                contentSize = CGSize(width: labelFitSize.width + 50, height: contentSize.height)
            }
        }
        if detailText?.characters.count > 0  {
            let top = contentSize.height == marginEdgeInsets.top ? CGFloat(0.0):CGFloat(10.0)
            let detailLabelFitSize = detailLabel.sizeThatFits(CGSize(width: contentSize.width - 40, height: CGFloat.max))
            if detailLabelFitSize.width  <  customViewWidth + 50 && detailLabelFitSize.width < contentSize.width - 30{
                contentSize = CGSize(width: customViewWidth + 80, height: contentSize.height)
            }
            detailLabel.frame = CGRect(origin: CGPointZero, size: detailLabelFitSize)
            detailLabel.center = CGPoint(x: contentSize.width/2, y: top + contentSize.height+detailLabelFitSize.height/2)
            contentSize = CGSize(width: contentSize.width, height:  top + contentSize.height + detailLabelFitSize.height )
            if customView == nil &&  title?.characters.count == 0{
                contentSize = CGSize(width: detailLabelFitSize.width + 50, height: contentSize.height)
            }
        }
        contentSize = CGSize(width: contentSize.width, height:  contentSize.height + marginEdgeInsets.bottom )
        contentView.frame = CGRect(origin: CGPointZero, size: contentSize)
        switch locationMode! {
        case .Top:
            contentView.center = CGPoint(x: self.bounds.width/2,y: contentSize.height/2 + 64)
            break
        case .Center:
            contentView.center = CGPoint(x: self.bounds.width/2,y: self.bounds.height/2 - 20)
            break
        case .Bottom:
            contentView.center = CGPoint(x: self.bounds.width/2,y: self.bounds.height - 64 - contentSize.height/2)
            break
        }
        if customView != nil {
            customView!.center = CGPointMake(contentSize.width/2, customView!.center.y)
        }
        if  title?.characters.count > 0  {
            label.center = CGPointMake(contentSize.width/2, label.center.y)
        }
        if detailText?.characters.count > 0  {
            detailLabel.center = CGPointMake(contentSize.width/2, detailLabel.center.y)
        }
    }
    
    /**
     在一定范围内调整size
     - returns: <#return value description#>
     */
    func sizeToFit(originSize:CGSize,maxWidth:CGFloat)->CGSize{
        let  fitWidth = originSize.width > maxWidth ? maxWidth:originSize.width
        let scale = originSize.height/originSize.width
        let  fitHeight =  originSize.width > maxWidth ? maxWidth*scale:originSize.height
        return CGSize(width: fitWidth, height: fitHeight)
    }
    
    /**
     动画显示
     */
    func doAnimation(){
        //设置动画总时间
        if let imageView = customView as? UIImageView  where imageView.animationImages?.count > 0{
            imageView.animationDuration = Double(imageView.animationImages!.count) * 0.025
            //设置重复次数,0表示不重复
            imageView.animationRepeatCount=0;
            imageView.startAnimating()
        }
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0,0.35,0.55,0.60]
        scaleAnimation.values = [0.1,1.2,0.96,1]
        scaleAnimation.duration = 0.6
        contentView.layer.addAnimation(scaleAnimation, forKey: "")
        
        
        self.alpha = 0
        UIView.animateWithDuration(0.6, animations: {
            self.alpha = 1
        }) { (boo) in
        }
    }
    
    /**
     动画隐藏并移除
     */
    func stopAnimation(){
        if let imageView = customView as? UIImageView where imageView.animationImages?.count > 0{
            UIView.animateWithDuration(0.3, animations: {
                imageView.alpha = 0
            }) { (boo) in
                if boo
                {
                   imageView.stopAnimating()
                }
            }
        }
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0,0.4]
        scaleAnimation.values = [1,0.8]
        scaleAnimation.duration = 0.4
        scaleAnimation.removedOnCompletion = true
        contentView.layer.addAnimation(scaleAnimation, forKey: "")
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0
        }) { (boo) in
            if boo {
                self.removeFromSuperview()
            }
        }
    }
    
    /**
     主要方法  用于显示View
     
     - parameter toView:       加在哪个View上
     - parameter icons:        显示的图片集 比如:["loading1","loading2","loading3"]
     - parameter message:      title显示
     - parameter messageColor: title颜色
     - parameter showBgView:   是否显示背景 默认不显示背景   背景显示就没有了边框
     - parameter detailText:    detailText显示
     - parameter detailColor:  detailText的颜色
     - parameter loationMode:  显示的位置分为上中下
     
     - returns: 返回当前对象
     */
    class func showView(toView:UIView?,
                        icons:[String]?,
                        message:String?,
                        messageColor:UIColor?,
                        showBgView:Bool?,
                        detailText:String?,
                        detailColor:UIColor?,
                        loationMode:MGLocationMode?) -> MGProgressHUD?{
        /*! 如果message为空 或者toView为空  直接返回nil */
        if toView != nil
        {
            MGProgressHUD.hiddenAllhubToView(toView, animated: false, afterDelay: 0)
            var frame:CGRect = CGRect(origin: CGPointZero, size: toView!.bounds.size)
            if let scrollView = toView as? UIScrollView {
                frame.origin = scrollView.contentOffset
            }
            let progressView = MGProgressHUD(frame:frame)
            toView?.addSubview(progressView)
            progressView.autoresizingMask =  [.FlexibleWidth, .FlexibleHeight]
            /*! 显示背景色 就没有框了   没有背景色就会显示框 */
            if showBgView == true
            {
                progressView.backgroundColor = UIColor.clearColor()
                progressView.contentView.backgroundColor = UIColor.clearColor()
                progressView.contentView.layer.cornerRadius = 0
                progressView.contentView.layer.borderWidth = 0
                progressView.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
                progressView.contentView.layer.shadowOpacity = 1
                progressView.contentView.layer.shadowColor = UIColor.clearColor().CGColor
                //                progressView.labelColor = UIColor.whiteColor()
                //                progressView.detailLabelColor = UIColor.whiteColor()
            }
            if icons != nil && icons?.count > 0 {
                let  imageView = UIImageView(image: image((icons?.first)!))
                if icons?.count > 1 {
                    var arr  = [UIImage]()
                    for name in icons! {
                        if let image = image(name) {
                            
                            arr.append(image)
                        }
                    }
                    imageView.animationImages = arr
                }
                imageView.backgroundColor = UIColor.clearColor()
                progressView.contentView.addSubview(imageView)
                progressView.customView = imageView
            }
            if loationMode != nil {
                progressView.locationMode = loationMode
            }
            if messageColor != nil {
                progressView.labelColor = messageColor
            }
            if detailColor != nil {
                progressView.detailLabelColor = detailColor
            }
            if message != nil {
                progressView.title = message
            }
            if detailText != nil {
                progressView.detailText = detailText
            }
            
            progressView.doAnimation()
            return progressView
        }
        return nil
    }
    /**
     主要方法  用于显示View
     
     - parameter toView:       加在哪个View上
     - parameter customView:   自定义的View  实现了完全自定义额
     - parameter message:      title显示
     - parameter messageColor: title颜色
     - parameter showBgView:   是否显示背景 默认不显示背景   背景显示就没有了边框
     - parameter detailText:    detailText显示
     - parameter detailColor:  detailText的颜色
     - parameter loationMode:  显示的位置分为上中下
     
     - returns: 返回当前对象
     */
    class func showCustomView(toView:UIView?,
                              customView:UIView?,
                              message:String?,
                              messageColor:UIColor?,
                              showBgView:Bool?,
                              detailText:String?,
                              detailColor:UIColor?,
                              loationMode:MGLocationMode?) -> MGProgressHUD?{
        /*! 如果message为空 或者toView为空  直接返回nil */
        if toView != nil
        {
            MGProgressHUD.hiddenAllhubToView(toView, animated: false, afterDelay: 0)
            var frame:CGRect = CGRect(origin: CGPointZero, size: toView!.bounds.size)
            if let scrollView = toView as? UIScrollView {
                frame.origin = scrollView.contentOffset
            }
            let progressView = MGProgressHUD(frame:frame)
            toView?.addSubview(progressView)
            if customView != nil {
                progressView.contentView.addSubview(customView!)
                progressView.customView = customView
            }
            progressView.autoresizingMask =  [.FlexibleWidth, .FlexibleHeight]
            /*! 显示背景色 就没有框了   没有背景色就会显示框 */
            if showBgView == true
            {
                progressView.backgroundColor = UIColor.clearColor()
                progressView.contentView.backgroundColor = UIColor.clearColor()
                progressView.contentView.layer.cornerRadius = 0
                progressView.contentView.layer.borderWidth = 0
                progressView.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
                progressView.contentView.layer.shadowOpacity = 1
                progressView.contentView.layer.shadowColor = UIColor.clearColor().CGColor
            }
            if loationMode != nil {
                progressView.locationMode = loationMode
            }
            if messageColor != nil {
                progressView.labelColor = messageColor
            }
            if detailColor != nil {
                progressView.detailLabelColor = detailColor
            }
            if message != nil {
                progressView.title = message
            }
            if detailText != nil {
                progressView.detailText = detailText
            }
            
            progressView.doAnimation()
            return progressView
        }
        return nil
    }
    
    /**
     隐藏
     - parameter animated: 是否有动画
     */
    func hideDelayed(animated:Bool){
        if animated {
            stopAnimation()
        }
        else{
            self.removeFromSuperview()
        }
        
    }
    
    /**
     隐藏
     - parameter animated: 是否有动画
     */
    func hideAfterDelay(animated:Bool, afterDelay:NSTimeInterval){
        if afterDelay == 0 {
            hideDelayed(animated)
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(afterDelay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.hideDelayed(animated)
            })
        }
    }
    
    /**
     隐藏所有的弹出框
     
     - parameter toView:     在哪个页面上加的
     - parameter animated:   是否动画隐藏
     - parameter afterDelay: 几秒后隐藏
     */
    class func hiddenAllhubToView(toView:UIView!,animated:Bool,afterDelay:NSTimeInterval)->Int{
        var count = 0
        if toView != nil {
            for view in toView.subviews {
                if let progressHUD = view as? MGProgressHUD where progressHUD.manualHidden == false {
                    progressHUD.hideAfterDelay(animated, afterDelay: afterDelay)
                    count = count + 1
                }
            }
        }
        return count
    }
    
    class func hubViewsToView(toView:UIView!) -> [MGProgressHUD]
    {
        var views = [MGProgressHUD]()
        if toView != nil {
            for view in toView.subviews {
                if let progressHUD = view as? MGProgressHUD where progressHUD.manualHidden == false {
                    views.append(progressHUD)
                }
            }
        }
        return views
    }
    
    /**
     隐藏所有的弹出框
     
     - parameter toView:     在哪个页面上加的
     - parameter animated:   是否动画隐藏
     */
    class func hiddenAllhubToView(toView:UIView!,animated:Bool)->Int{
        var count = 0
        if toView != nil {
            for view in toView.subviews {
                if let progressHUD = view as? MGProgressHUD where progressHUD.manualHidden == false {
                    progressHUD.hideAfterDelay(animated, afterDelay: 0)
                    count = count + 1
                }
            }
        }
        return count
    }
    
    /**
     类方法调用  隐藏单个弹出框
     
     - parameter progressHUD: 弹出框对象
     - parameter animated:    是否有动画
     - parameter afterDelay:  需不需要延迟
     */
    class func hiddenHubView(progressHUD:MGProgressHUD!,animated:Bool,afterDelay:NSTimeInterval){
        progressHUD.hideAfterDelay(animated, afterDelay: afterDelay)
    }
}

extension MGProgressHUD {
    
    /**
     显示信息,不会自动隐藏 只有手动隐藏额
     
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    public class func  showMessageView(toView:UIView!,message:String?)->MGProgressHUD?{
        if message?.characters.count > 0 {
            let progressView = showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
            progressView?.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
            progressView?.labelColor = UIColor.whiteColor()
            progressView?.contentView.layer.borderColor = UIColor.blackColor().CGColor
            return progressView
        }
        return nil
    }
    /**
     显示信息,不会自动隐藏 只有手动隐藏额
     
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    public class func  showLoadingView(toView:UIView!,message:String?)->MGProgressHUD?{
        var arr  = [String]()
        for index in 1..<10 {
            arr.append("loading" + String(index))
        }
        let progressView = MGProgressHUD.showView(toView, icons: arr, message: nil, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
        progressView?.marginEdgeInsets = UIEdgeInsetsMake(5, KScreenWidth/2 - 50, 5, KScreenWidth/2 - 50)
        return progressView
    }
    
    /**
     显示信息,不会自动隐藏 只有手动隐藏额
     
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    public class func  showProgressLoadingView(toView:UIView!,message:String?)->MGProgressHUD?{
        let progressView = MGProgressHUD.showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
        progressView?.customMode = MGCustomMode.Progress
        return progressView
    }
    
    
    /**
     展示信息  几秒后消失
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     
     - returns: <#return value description#>
     */
    public class func  showTextAndHiddenView(toView:UIView!,message:String?)->MGProgressHUD?{
        if message?.characters.count > 0 {
            let progressView = showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: nil)
            progressView?.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
            progressView?.labelColor = UIColor.whiteColor()
            progressView?.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            let lineNum = ceil(Double(message!.characters.count)/Double(12.0))
            progressView?.hideAfterDelay(true, afterDelay: 0.5*(lineNum - 1.0) + 1.5)
            return progressView
        }
        return nil
    }
    
    /**
     展示信息  几秒后消失
     - parameter toView:  <#toView description#>
     - parameter message: <#message description#>
     - parameter loationMode: <#message description#>
     
     - returns: <#return value description#>
     */
    public class func  showTextAndHiddenView(toView:UIView!,message:String?,loationMode:MGLocationMode?)->MGProgressHUD?{
        if message?.characters.count > 0 {
            let progressView = showView(toView, icons: nil, message: message, messageColor: nil, showBgView: false, detailText: nil, detailColor: nil, loationMode: loationMode)
            progressView?.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
            progressView?.labelColor = UIColor.whiteColor()
            progressView?.contentView.layer.borderColor = UIColor.blackColor().CGColor
            
            let lineNum = ceil(Double(message!.characters.count)/Double(12.0))
            progressView?.hideAfterDelay(true, afterDelay: 0.5*(lineNum - 1.0) + 1.5)
            return progressView
        }
        return nil
    }
    
    /*! 扩展方法 */
    public class func  showView(toView:UIView!,
                         icon:String?,
                         message:String?,
                         messageColor:UIColor?,
                         detailText:String?,
                         detailColor:UIColor?) ->MGProgressHUD? {
        var icons = [String]()
        if icon?.characters.count > 0 {
            icons.append(icon!)
        }
        let progressView = showView(toView, icons: icons, message: message, messageColor: messageColor, showBgView: true, detailText: detailText, detailColor: detailColor, loationMode: nil)
        progressView?.backgroundColor = UIColor.clearColor()
        return progressView
    }
    /*! 扩展方法 */
    public class func  showView(toView:UIView!,
                         customView:UIView?,
                         message:String?,
                         messageColor:UIColor?,
                         detailText:String?,
                         detailColor:UIColor?) ->MGProgressHUD? {
        return showCustomView(toView, customView: customView, message: message, messageColor: messageColor, showBgView: true, detailText: detailText, detailColor: detailColor, loationMode: nil)
    }
    /*! 扩展方法 */
    public class func  showView(toView:UIView!,
                         icon:String?,
                         message:String?,
                         detailText:String?) ->MGProgressHUD? {
        
        return showView(toView, icon: icon, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
    }
    /*! 扩展方法 */
    public class func  showFillView(toView:UIView!,
                               icon:String?,
                            message:String?,
                         detailText:String?) ->MGProgressHUD? {
        let progressView = showView(toView, icon: icon, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
        progressView?.backgroundColor = toView.backgroundColor
        return progressView
    }

    /*! 扩展方法 */
    public class func  showView(toView:UIView!,
                         customView:UIView?,
                         message:String?,
                         detailText:String?) ->MGProgressHUD? {
        return showView(toView, customView: customView, message: message, messageColor: nil, detailText: detailText, detailColor: nil)
    }
    
    public class func showTextAndHiddenView(message:String?)->MGProgressHUD? {
        if message?.characters.count > 0 {
            let progressView = showTextAndHiddenView(lastShowWindow(), message: message)
            return progressView
        }
        return nil
    }
    
    public class func hiddenHUD(animated:Bool)->Int{
        var count = 0
        for view in lastShowWindow().subviews {
            if let progressHUD = view as? MGProgressHUD where progressHUD.manualHidden == false {
                progressHUD.hideAfterDelay(animated, afterDelay: 0)
                count = count + 1
            }
        }
        return count
    }
    
    public class func showSuccessAndHiddenView(toView:UIView!,
                                        icon:String?,
                                        message:String?,
                                        detailText:String?) ->MGProgressHUD? {
        var icons = [String]()
        if icon?.characters.count > 0 {
            icons.append(icon!)
        }
        let progressView = showView(toView, icons: icons, message: message, messageColor: nil, showBgView: false, detailText: detailText, detailColor: nil, loationMode: nil)
        progressView?.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        progressView?.labelColor = UIColor.whiteColor()
        progressView?.contentView.layer.borderColor = UIColor.blackColor().CGColor
        progressView?.hideAfterDelay(true, afterDelay: 1.5)
        return progressView
    }
    
    public class func  showSuccessAndHiddenView(toView:UIView!,message:String?)->MGProgressHUD?{
        return self.showSuccessAndHiddenView(toView, icon: "ic_whiteCheck", message: message, detailText: nil)
    }
    
    public class func  showSuccessAndHiddenView(message:String?)->MGProgressHUD?{

        return self.showSuccessAndHiddenView(lastShowWindow(), icon: "ic_whiteCheck", message: message, detailText: nil)
    }
    
    public class func  showErrorAndHiddenView(toView:UIView!,message:String?)->MGProgressHUD?{
        return self.showSuccessAndHiddenView(toView, icon: "error", message: message, detailText: nil)
    }
    
    public class func  showErrorAndHiddenView(message:String?)->MGProgressHUD?{
        return self.showSuccessAndHiddenView(lastShowWindow(), icon: "error", message: message, detailText: nil)
    }
}

extension MGProgressHUD {
    
    class func image(name: String) -> UIImage? {
        guard name.characters.count > 0 else {
            return nil
        }
        let bundle = NSBundle(forClass: MGProgressHUD.self)
        let image = UIImage(named: "MGHUD.bundle/" + name, inBundle: bundle, compatibleWithTraitCollection: nil)
        return image

    }
    class func lastShowWindow() -> UIWindow{
        var window = UIApplication.sharedApplication().windows.last
        let count = UIApplication.sharedApplication().windows.count
        if window?.bounds.width != KScreenWidth {
            if count > 2 {
                window = UIApplication.sharedApplication().windows[count - 2]
            }
            else
            {
                window = UIApplication.sharedApplication().keyWindow
            }
        }
        if window?.hidden == true {
            window = UIApplication.sharedApplication().keyWindow
        }
        return window!
    }
}
