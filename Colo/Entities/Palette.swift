//
// Colo
//
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import Foundation

struct Palette {
    let id: Int
    let title: String
    let username: String
    let colors: [String]
    
    init(id: Int, title: String, username: String, colors: [String]) {
        self.id = id
        self.title = title
        self.username = username
        self.colors = colors
    }
}

extension Palette: Decodable {
    enum PaletteStructKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case username = "userName"
        case colors = "colors"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PaletteStructKeys.self)
        let id: Int = try container.decode(Int.self, forKey: .id)
        let title: String = try container.decode(String.self, forKey: .title)
        let username: String = try container.decode(String.self, forKey: .username)
        let colors: [String] = try container.decode([String].self, forKey: .colors)
        
        self.init(id: id, title: title, username: username, colors: colors)
    }
}
