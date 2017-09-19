//
//  Utils.swift
//  FoodCamera
//
//  Created by DavidTran on 8/27/17.
//  Copyright © 2017 DavidTran. All rights reserved.
//

import UIKit

class Utils:UIViewController{
    func resizeImage(image:UIImage,width:Float,height:Float)->UIImage{
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = height
        let maxWidth:Float = width
        
        var imgRatio:Float = actualWidth/actualHeight
        
        let maxRatio:Float = maxWidth/maxHeight
        
        if(actualHeight>maxHeight||actualWidth>maxWidth){
            if(imgRatio<maxRatio){
                imgRatio = maxHeight/actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio>maxRatio){
                imgRatio = maxWidth/actualWidth
                actualHeight = imgRatio*actualHeight
                actualWidth = maxWidth
            }
            else{
                actualWidth = maxWidth
                actualHeight = maxHeight
            }
        }
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imgData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imgData as Data)!
    }
    
    
  
}
