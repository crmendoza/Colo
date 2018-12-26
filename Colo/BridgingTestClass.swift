// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import UIKit

class BridgingTestClass: NSObject {
    var interactor: PaletteListInteractor!

    func fetchPalette() {
        interactor = PaletteListInteractor(networkGateway: NetworkGateway())
        interactor.fetchPaletteList()
    }
}
