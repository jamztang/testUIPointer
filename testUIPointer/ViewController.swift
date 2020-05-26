//
//  ViewController.swift
//  testUIPointer
//
//  Created by James Tang on 1/4/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

@available(iOS 13.4, *)
enum InteractionStyle {
    case disabled
    case highlight
    case lift
    case hover(UIPointerEffect.TintMode, Bool, Bool)
}

@available(iOS 13.4, *)
class InteractableView: UIView, UIPointerInteractionDelegate {

    var interactionStyle: InteractionStyle = .highlight

    func enablePointerInteraction() {
        addInteraction(UIPointerInteraction(delegate: self))
    }

    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        var style: UIPointerStyle?
        switch interactionStyle {
        case .disabled:
            style = nil
        case .highlight:
            style = UIPointerStyle(effect: .highlight(.init(view: self)))
        case .lift:
            style = UIPointerStyle(effect: .lift(.init(view: self)))
        case let .hover(tintMode, shadow, scale):
            style = UIPointerStyle(effect: .hover(.init(view: self), preferredTintMode: tintMode, prefersShadow: shadow, prefersScaledContent: scale))
        }
        return style
    }
}

@available(iOS 13.4, *)
class ViewController: UIViewController {

    @IBOutlet weak var disabledButton: UIButton!
    @IBOutlet weak var liftButton: UIButton!
    @IBOutlet weak var highlightButton: UIButton!
    @IBOutlet weak var hoverButton: UIButton!
    @IBOutlet weak var horizontalBeamButton: UIButton!
    @IBOutlet weak var verticalBeamButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var interactableView: InteractableView!
    @IBOutlet weak var hoverModeSegment: UISegmentedControl!
    @IBOutlet weak var shadowToggle: UISwitch!
    @IBOutlet weak var scaleToggle: UISwitch!

    private let panGestureRecognizer: UIPanGestureRecognizer = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(macCatalyst 13.4, iOS 13.4, *) {
            liftButton.pointerStyleProvider = liftProvider
            hoverButton.pointerStyleProvider = hoverProvider
            highlightButton.pointerStyleProvider = highlightProvider
            verticalBeamButton.pointerStyleProvider = verticalBeamProvider
            horizontalBeamButton.pointerStyleProvider = horizontalBeamProvider
            textView.addInteraction(UIPointerInteraction(delegate: self))
            interactableView.enablePointerInteraction()

            panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
            panGestureRecognizer.allowedScrollTypesMask = .all
            panGestureRecognizer.minimumNumberOfTouches = 2

            view.addGestureRecognizer(panGestureRecognizer)
        } else {
            // Fallback on earlier versions
        }
    }

    @IBAction func buttonDidPress(_ sender: UIButton) {
        switch sender {
        case liftButton:
            interactableView.interactionStyle = .lift
        case hoverButton:
            reloadHoverState()
        case highlightButton:
            interactableView.interactionStyle = .highlight
        case disabledButton:
            interactableView.interactionStyle = .disabled
        default:
            break
        }
    }

    private func reloadHoverState() {
        let tintModes: [UIPointerEffect.TintMode] = [
            .overlay,
            .underlay
        ]
        interactableView.interactionStyle = .hover(tintModes[hoverModeSegment.selectedSegmentIndex], shadowToggle.isOn, scaleToggle.isOn)
    }
    @IBAction func hoverModeControlsValueDidChange(_ sender: Any) {
        reloadHoverState()
    }

    @IBAction func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if #available(macCatalyst 13.4, iOS 13.4, *) {
            Swift.print("TTT panning \(gesture.state) \(String(describing: gesture.allowedScrollTypesMask)) \(String(describing: gesture.state))")
        }
    }

}

@available(macCatalyst 13.4, iOS 13.4, *)
extension ViewController: UIPointerInteractionDelegate {
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
    func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        let style = UIPointerStyle(effect: .highlight(.init(view: textView)))
        return style
    }
}

