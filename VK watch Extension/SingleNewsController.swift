//
//  SingleNewsController.swift
//  VK watch Extension
//
//  Created by Eugene Khizhnyak on 06.12.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import WatchKit

class SingleNewsController: WKInterfaceController {
    @IBOutlet weak var image: WKInterfaceImage!
    @IBOutlet weak var text: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let news = context as? WatchAppNews else {
            text.setText("No data available")
            return
        }
        
        text.setText(news.text)
        image.imageFromUrl(news.url)
    }
    
}
