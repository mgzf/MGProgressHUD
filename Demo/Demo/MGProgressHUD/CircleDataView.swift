//
//  CircleDataView.swift
//  MGProgressHUD
//
//  Created by song on 16/7/14.
//  Copyright © 2016年 song. All rights reserved.
//

import UIKit

class CircleDataView: UIView {
    var fontSize:CGFloat = 14
    var lineSize:CGFloat = 3
    var process:CGFloat = 0
    @IBInspectable var  progress:CGFloat{
        get{
            return process
        }
        set(newval) {
            let val = newval*3.6
            self.process = val
            setNeedsDisplay()
        }
    }
    override func drawRect(rect: CGRect) {
        
        // println("开始画画.........")
        
        
        //获取画图上下文
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        
        
        //移动坐标
        let x = frame.size.width/2
        let y = frame.size.height/2
        
        
        //第一段文本
        let font:UIFont! = UIFont.systemFontOfSize(fontSize)
        let textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName:font
        ]
        
        
        // println("\(process)...............")
        
        let showp = process/3.6
        
        let str = NSAttributedString(string: "\(Int(showp))%", attributes: textAttributes)
        
        let size:CGSize = str.size()
        
        let stry:CGFloat = y-(size.height/2)
        
        
        str.drawAtPoint(CGPointMake(x-(size.width/2),stry))
        
        //灰色圆圈
        let radius = frame.size.width/2-lineSize
        CGContextSetLineWidth(context, 1)
        
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextAddArc(context, x, y, radius-lineSize + 1, 0, 360, 0)
        CGContextDrawPath(context, .Stroke)
        
        
        //两个圆圈
        CGContextSetLineWidth(context, lineSize)
        
        CGContextSetStrokeColorWithColor(context, MGColor(125, g: 125, b: 125).CGColor)
        CGContextAddArc(context, x, y, radius, 0, 360, 0)
        CGContextDrawPath(context, .Stroke)
        
        //
        CGContextSetStrokeColorWithColor(context,  MGColor(246, g: 80, b: 0).CGColor)
        process  = process * CGFloat(M_PI/180.0)
        CGContextAddArc(context, x, y, radius,CGFloat(-M_PI/2), process - CGFloat(M_PI/2), 0)
        
        CGContextDrawPath(context, .Stroke)
        
        
        // println("结束画画........")
        
        
    }
    
}
