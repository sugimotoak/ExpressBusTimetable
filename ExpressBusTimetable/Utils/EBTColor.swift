//
//  EBTColor.swift
//  ExpressBusTimetable
//
//  Created by akira on 5/18/17.
//  Copyright © 2017 Spreadcontent G.K. All rights reserved.
//

import UIKit
import ChameleonFramework

/*
 * EBTColor Class
 */
public class EBTColor {

    public enum Theme: String {
        case Default = "Black"
        case White
    }

    static let sharedInstance = EBTColor()

    private init() {}

    var theme: Theme = .Default

    var primaryColor: UIColor {
        switch EBTColor.sharedInstance.theme {
        case .Default :
            return UIColor.flatBlackDark
        case .White:
            return UIColor.flatWhite
        }
    }

    private var _primaryTextColor: UIColor?
    var primaryTextColor: UIColor {
        if let color = _primaryTextColor {
            return color
        }
        _primaryTextColor = ContrastColorOf(primaryColor, returnFlat: true)
        return _primaryTextColor!
    }

    var isPrimaryTextColorBlack: Bool {
        return primaryTextColor == UIColor.flatBlackDark
    }

    private var _secondaryColor: UIColor?
    var secondaryColor: UIColor {
        if let color = _secondaryColor {
            return color
        }
        _secondaryColor = primaryColor.lighten(byPercentage: 0.5)!
        return _secondaryColor!
    }

    private var _secondaryTextColor: UIColor?
    var secondaryTextColor: UIColor {
        if let color = _secondaryTextColor {
            return color
        }
        _secondaryTextColor = ContrastColorOf(_secondaryColor!, returnFlat: true)
        return _secondaryTextColor!
    }

    private var _tintColor: UIColor?
    var tintColor: UIColor {
        if let color = _tintColor {
            return color
        }
        switch EBTColor.sharedInstance.theme {
        case .Default, .White :
            _tintColor = UIColor(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
            return _tintColor!
        }
    }

    private var _sectionIndexBackgroundColor: UIColor?
    var sectionIndexBackgroundColor: UIColor {
        if let color = _sectionIndexBackgroundColor {
            return color
        }
        switch EBTColor.sharedInstance.theme {
        case .Default, .White :
            _sectionIndexBackgroundColor = primaryColor
            return _sectionIndexBackgroundColor!
        }
    }

}
