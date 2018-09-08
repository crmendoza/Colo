//
//  Palette.swift
//  Colo
//
//  Created by Christineroanne Mendoza on 2018/09/08.
//  Copyright © 2018 Wongzigii. All rights reserved.
//

import UIKit

struct Palette {
    let id: String
    let title: String
    let username: String
    let colors: [String]
    
    init(id: String, title: String, username: String, colors: [String]) {
        self.id = id
        self.title = title
        self.username = username
        self.colors = colors
    }
}
