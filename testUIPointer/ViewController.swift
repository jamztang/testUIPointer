//
//  ViewController.swift
//  testUIPointer
//
//  Created by James Tang on 1/4/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var liftButton: UIButton!
    @IBOutlet weak var highlightButton: UIButton!
    @IBOutlet weak var hoverButton: UIButton!
    @IBOutlet weak var horizontalBeamButton: UIButton!
    @IBOutlet weak var verticalBeamButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(macCatalyst 13.4, iOS 13.4, *) {
            liftButton.pointerStyleProvider = liftProvider
            hoverButton.pointerStyleProvider = hoverProvider
            highlightButton.pointerStyleProvider = highlightProvider
            verticalBeamButton.pointerStyleProvider = verticalBeamProvider
            horizontalBeamButton.pointerStyleProvider = horizontalBeamProvider
        } else {
            // Fallback on earlier versions
        }
    }

}

@available(macCatalyst 13.4, iOS 13.4, *)
extension ViewController {
    func liftProvider(button: UIButton, effect: UIPointerEffect, shape: UIPointerShape) -> UIPointerStyle? {
        let style = UIPointerStyle(effect: .lift(.init(view: button)))
        return style
    }
    func highlightProvider(button: UIButton, effect: UIPointerEffect, shape: UIPointerShape) -> UIPointerStyle? {
        let style = UIPointerStyle(effect: .highlight(.init(view: button)))
        return style
    }
    func hoverProvider(button: UIButton, effect: UIPointerEffect, shape: UIPointerShape) -> UIPointerStyle? {
        let style = UIPointerStyle(effect: .hover(.init(view: button), preferredTintMode: .overlay, prefersShadow: true, prefersScaledContent: true))
        return style
    }
    func horizontalBeamProvider(button: UIButton, effect: UIPointerEffect, shape: UIPointerShape) -> UIPointerStyle? {
        let style = UIPointerStyle(shape: .horizontalBeam(length: button.frame.size.height))
        return style
    }
    func verticalBeamProvider(button: UIButton, effect: UIPointerEffect, shape: UIPointerShape) -> UIPointerStyle? {
        let style = UIPointerStyle(shape: .verticalBeam(length: button.frame.size.height))
        return style
    }
}

