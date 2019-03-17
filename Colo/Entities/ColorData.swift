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

    var rgbDescription: String {
        return String(format: "R: %.0f, G: %.0f, B: %.0f", red, green, blue)
    }
}

struct HSVColor {
    let hue: Float
    let saturation: Float
    let value: Float
    
    init(rgb: RGBColor) {
        let min = Float.minimum(Float.minimum(rgb.red, rgb.blue), rgb.green)
        let max = Float.maximum(Float.maximum(rgb.red, rgb.blue), rgb.green)
        let delta = max - min
        
        self.value = max / 255.0
        if max != 0 {
            self.saturation = delta / max
        } else {
            self.saturation = 0
            self.hue = -1.0
            return
        }
        
        var h: Float
        if rgb.red == max {
            h = (rgb.green - rgb.blue) / delta
        } else if rgb.green == max {
            h = (2 + rgb.blue - rgb.red ) / delta
        } else {
            h = (4 + rgb.red - rgb.green) / delta
        }
        h *= 60
        if h < 0 {
            h += 360
        }
        self.hue = h
    }
    
    var hsvDescription: String {
        return String(format: "H: %.2f  S: %.2f%  V: %.2f%", hue, saturation * 100, value * 100)
    }
}
