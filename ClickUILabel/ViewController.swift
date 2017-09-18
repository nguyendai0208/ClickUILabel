//
//  ViewController.swift
//  ClickUILabel
//
//  Created by Neo Nguyen on 9/14/17.
//  Copyright © 2017 Neo Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var lbText : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }

    fileprivate func initView(){
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapText(_:)))
        self.lbText.addGestureRecognizer(tap)
        self.lbText.isUserInteractionEnabled = true
    }
    
    func tapText(_ gesture : UITapGestureRecognizer) {
        print("tap abc")
        if gesture.didTapAttributedTextInLabel(self.lbText, inrange: NSRange.init(location: 0, length: 3)){
            print("Ranger 1")
        }else if gesture.didTapAttributedTextInLabel(self.lbText, inrange: NSRange.init(location: 4, length: 4)){
            print("Ranger 2")
        }
    }

}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(_ label : UILabel, inrange targetRange : NSRange) -> Bool {
        var isTap = false
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let xTemp = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let yTemp = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint.init(x: xTemp, y:yTemp)
        
        let locationOfTouchInTextContainer = CGPoint.init(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y )
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        isTap = NSLocationInRange(indexOfCharacter, targetRange)
        return isTap
    }
}
