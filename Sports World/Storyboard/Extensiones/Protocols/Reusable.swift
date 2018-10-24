//
//  Reusable.swift
//  Pets
//
//  Created by Mario Canto on 1/31/18.
//  Copyright © 2018 Mario Canto. All rights reserved.
//

import UIKit

public protocol Reusable {
	static var reuseId: String { get }
}

extension Reusable {
	public static var reuseId: String {
		return String(describing: self)
	}
}

public protocol StoryboardRepresentable: RawRepresentable {
    var filename: String { get }
}

public extension StoryboardRepresentable where Self.RawValue == String {
    var filename: String {
        
        let range = Range(uncheckedBounds: (lower: rawValue.startIndex,
                                            upper: rawValue.endIndex))
        let string = rawValue.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2",
                                                   options: .regularExpression, range: range).capitalized.components(separatedBy: .whitespaces).joined()
        return string
    }
}

public extension UIStoryboard {
    
    private class StoryboardBundle {}
    
    public convenience init<T: StoryboardRepresentable>(storyboard: T, bundle: Bundle? = nil) where T.RawValue == String {
        self.init(name: storyboard.filename, bundle: bundle ?? Bundle(for: StoryboardBundle.self))
    }
    
    class func storyboard<T: StoryboardRepresentable>(_ storyboard: T, bundle: Bundle? = nil) -> UIStoryboard where T.RawValue == String {
        return UIStoryboard(storyboard: storyboard, bundle: bundle)
    }
    
}
