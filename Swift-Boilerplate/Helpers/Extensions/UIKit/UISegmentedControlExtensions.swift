//
//  UISegmentedControlExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 9/28/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit


// MARK: - Properties
public extension UISegmentedControl {
	
	/// SwifterSwift: Segments titles.
    var segmentTitles: [String] {
		get {
            let range = 0..<numberOfSegments
            return range.compactMap { titleForSegment(at: $0) }
		}
		set {
			removeAllSegments()
			for (index, title) in newValue.enumerated() {
				insertSegment(withTitle: title, at: index, animated: false)
			}
		}
	}
	
	/// SwifterSwift: Segments images.
    var segmentImages: [UIImage] {
		get {
            let range = 0..<numberOfSegments
            return range.compactMap { imageForSegment(at: $0) }
		}
		set {
			removeAllSegments()
			for (index, image) in newValue.enumerated() {
				insertSegment(with: image, at: index, animated: false)
			}
		}
	}
}
#endif
