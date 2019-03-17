// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import UIKit

struct RGBColor {
    let hex: String
    let red: Float
    let green: Float
    let blue: Float
    
    init(hexString: String) {
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        self.hex = hexString
        self.red = Float((rgbValue & 0xff0000) >> 16)
        self.green = Float((rgbValue & 0xff00) >> 8)
        self.blue = Float(rgbValue & 0xff)
    }
    
    var uicolor: UIColor {
        return UIColor(red: CGFloat(self.red/255.0), green: CGFloat(self.green/255.0), blue: CGFloat(self.blue/255.0), alpha: 1.0)
    }
    
    var foregroundColor: UIColor {
        let brightness = sqrtf(powf(self.red, 2.0) * 0.241 + powf(self.green, 2.0) * 0.691 + powf(self.blue, 2.0) * 0.068)
        return brightness > 130 ? .black : .white
    }
}
