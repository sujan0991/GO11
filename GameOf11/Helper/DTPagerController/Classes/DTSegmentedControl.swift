//
//  DTSegmentedControl.swift
//  Pods
//
//  Created by tungvoduc on 15/09/2017.
//
//

import UIKit

// Protocol
// SegmentedControl
public protocol DTSegmentedControlProtocol {

    var selectedSegmentIndex: Int { get set }

    func setTitle(_ title: String?, forSegmentAt segment: Int)

    func setImage(_ image: UIImage?, forSegmentAt segment: Int)
    
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State)
    
}

open class DTSegmentedControl: UISegmentedControl, DTSegmentedControlProtocol {    

    public override init(items: [Any]?) {
        super.init(items: items)
        commonInit()
        fixBackgroundSegmentControl(self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        fixBackgroundSegmentControl(self)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        fixBackgroundSegmentControl(self)
    }

    func commonInit() {
        setTintColor(.clear)
        setDividerImage(UIImage(), forLeftSegmentState: UIControl.State(), rightSegmentState: UIControl.State.selected, barMetrics: UIBarMetrics.default)
        setDividerImage(UIImage(), forLeftSegmentState: UIControl.State.selected, rightSegmentState: UIControl.State(), barMetrics: UIBarMetrics.default)
    }
    
    // for fucking back shadow removal
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
    
    private func setTintColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = color
        } else {
            tintColor = color
        }
    }
}
