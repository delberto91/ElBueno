//
//  Collection+GroupBy.swift
//  Sports World
//
//  Created by Mario Canto on 8/16/18.
//  Copyright © 2018 Touchastic. All rights reserved.
//

extension Collection where Self.Iterator.Element: Comparable {
    public typealias ElementType = Self.Iterator.Element
    public typealias Comparator = (ElementType, ElementType) -> Bool

    func grouped(by comparator: Comparator) -> [[ElementType]] {
        let sortedElements = self.sorted()
        return sortedElements._grouped(by: comparator)
    }

    private func _grouped(by grouper: Comparator) -> [[ElementType]] {

        var result: [[ElementType]] = []

        var group: [ElementType] = [ElementType]()
        var previousItem: ElementType?

        for item in self {
            // Current item will be the next item
            defer {
                previousItem = item
            }

            // Check if it's the first item, if so, then add to the first group
            guard let previous = previousItem else {

                if !group.contains(item) {
                    group.append(item)
                }
                continue
            }

            if grouper(previous, item) {
                // Item in the same group
                if !group.contains(item) {
                    group.append(item)
                }

            } else {
                // New group
                result.append(group)
                group = [ElementType]()
                group.append(item)
            }
        }

        result.append(group)

        return result

    }

}
