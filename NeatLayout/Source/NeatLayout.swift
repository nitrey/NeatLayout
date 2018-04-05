//
//  NeatLayout.swift
//
//  Using PureLayout syntax, written in Swift
//
//  Created by Antonov Aleksandr on 03/04/2018.
//

import UIKit

/// Extension of UIView providing API for adding constraints with simple syntax (similar to PureLayout) ///

public extension UIView {
    
    // MARK: - Supporting enums
    
    public enum Edge {
        
        case left
        case top
        case right
        case bottom
        
        fileprivate var axis: Axis {
            
            switch self {
                
            case .left, .right:
                return .horizontal
            case .top, .bottom:
                return .vertical
            }
        }
        
    }
    
    public enum Axis {
        
        case horizontal
        case vertical
        case baseline
    }
    
    public enum Dimension {
        
        case width
        case height
    }
    
    
    // MARK: - Center & Align in Superview
    
    @discardableResult
    public func autoAlignAxis(toSuperviewAxis axis: Axis, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        
        guard let superview = self.superview else {
            fatalError(noSuperviewMessage)
        }
        
        return autoAlignAxis(axis, toSameAxisOf: superview, withOffset: offset)
    }
    
    @discardableResult
    public func autoCenterInSuperview() -> [NSLayoutConstraint] {
        
        guard let superview = self.superview else {
            fatalError(noSuperviewMessage)
        }
        
        let xConstraint = autoAlignAxis(.horizontal, toSameAxisOf: superview, withOffset: 0)
        let yConstraint = autoAlignAxis(.vertical, toSameAxisOf: superview, withOffset: 0)
        
        let constraints = [xConstraint, yConstraint]
        
        return constraints
    }
    
    
    // MARK: - Pin Edges to Superview
    
    @discardableResult
    public func autoPinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let edges = allEdges
        return constraintsToSuperview(for: edges, insets: insets)
    }
    
    @discardableResult
    public func autoPinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero, excludingEdge edge: Edge) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let edges = allEdges(except: edge)
        return constraintsToSuperview(for: edges, insets: insets)
    }
    
    @discardableResult
    public func autoPinEdge(toSuperviewEdge edge: Edge, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        return autoPinEdge(toSuperviewEdge: edge, withInset: inset, relation: .equal)
    }
    
    @discardableResult
    public func autoPinEdge(toSuperviewEdge edge: Edge, withInset inset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        guard let superview = self.superview else {
            fatalError(noSuperviewMessage)
        }
        
        let editedInset: CGFloat
        
        switch edge {
        case .bottom, .right:
            editedInset = -inset
        default:
            editedInset = inset
        }
        
        return autoPinEdge(edge, to: edge, of: superview, withOffset: editedInset, relation: relation)
    }
    
    
    // MARK: - Pin edges
    
    @discardableResult
    public func autoPinEdge(_ edge: Edge, to toEdge: Edge, of otherView: UIView, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        return autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: .equal)
    }
    
    @discardableResult
    public func autoPinEdge(_ edge: Edge, to toEdge: Edge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        let axis = edge.axis
        let toAxis = toEdge.axis
        
        guard axis == toAxis else {
            fatalError(incorrectEdges)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        switch axis {
            
        case .horizontal:
            let xAnchor = getXAnchor(of: self, for: edge)
            let xToAnchor = getXAnchor(of: otherView, for: toEdge)
            constraint = xAxisConstraint(anchor: xAnchor, toAnchor: xToAnchor, offset: offset, relation: relation)
        case .vertical:
            let yAnchor = getYAnchor(of: self, for: edge)
            let yToAnchor = getYAnchor(of: otherView, for: toEdge)
            constraint = yAxisConstraint(anchor: yAnchor, toAnchor: yToAnchor, offset: offset, relation: relation)
        case .baseline:
            constraint = baselineConstraint(to: otherView, offset: offset, relation: relation)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    
    // MARK: - Align Axes
    
    @discardableResult
    public func autoAlignAxis(_ axis: Axis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        switch axis {
        case .horizontal:
            constraint = centerYAnchor.constraint(equalTo: otherView.centerYAnchor, constant: offset)
        case .vertical:
            constraint = centerXAnchor.constraint(equalTo: otherView.centerXAnchor, constant: offset)
        case .baseline:
            constraint = lastBaselineAnchor.constraint(equalTo: otherView.lastBaselineAnchor, constant: offset)
        }
        
        constraint.isActive = true
        return constraint
    }
    

    // MARK: - Set Dimensions
    
    @discardableResult
    public func autoSetDimension(_ dimension: Dimension, toSize size: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        let anchor = getDimensionAnchor(of: self, for: dimension)
        
        switch relation {
            
        case .equal:
            constraint = anchor.constraint(equalToConstant: size)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualToConstant: size)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualToConstant: size)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func autoSetDimensions(to size: CGSize) -> [NSLayoutConstraint] {
        
        let widthConstraint = autoSetDimension(.width, toSize: size.width)
        let heightConstraint = autoSetDimension(.height, toSize: size.height)
        
        return [widthConstraint, heightConstraint]
    }
    
    
    // MARK: - Match Dimensions
    
    @discardableResult
    public func autoMatch(_ dimension: Dimension, to toDimension: Dimension, of otherView: UIView, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        return autoMatch(dimension, to: toDimension, of: otherView, withOffset: offset, relation: .equal)
    }
    
    @discardableResult
    public func autoMatch(_ dimension: Dimension, to toDimension: Dimension, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        let anchor = getDimensionAnchor(of: self, for: dimension)
        let toAnchor = getDimensionAnchor(of: otherView, for: toDimension)
        
        switch relation {
        
        case .equal:
            constraint = anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func autoMatch(_ dimension: Dimension, to toDimension: Dimension, of otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        return autoMatch(dimension, to: toDimension, of: otherView, withMultiplier: multiplier, relation: .equal)
    }
    
    @discardableResult
    public func autoMatch(_ dimension: Dimension, to toDimension: Dimension, of otherView: UIView, withMultiplier multiplier: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        let anchor = getDimensionAnchor(of: self, for: dimension)
        let toAnchor = getDimensionAnchor(of: otherView, for: toDimension)
        
        switch relation {
            
        case .equal:
            constraint = anchor.constraint(equalTo: toAnchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualTo: toAnchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualTo: toAnchor, multiplier: multiplier)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    
    // MARK: - Private methods
    
    private var allEdges: [Edge] {
        return [.left, .top, .right, .bottom]
    }
    
    private func allEdges(except edge: Edge) -> [Edge] {
        
        var resultEdges: [Edge] = []
        
        for e in allEdges {
            guard e != edge else { continue }
            resultEdges.append(e)
        }
        
        return resultEdges
    }
    
    private func getInset(from insets: UIEdgeInsets, for edge: Edge) -> CGFloat {
        
        switch edge {
            
        case .top:      return insets.top
        case .left:     return insets.left
        case .bottom:   return insets.bottom
        case .right:    return insets.right
        }
        
    }
    
    private func constraintsToSuperview(for edges: [Edge], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        var constraints: [NSLayoutConstraint] = []
        
        for edge in edges {
            let inset = getInset(from: insets, for: edge)
            let newConstraint = autoPinEdge(toSuperviewEdge: edge, withInset: inset)
            constraints.append(newConstraint)
        }
        
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
    private func getDimensionAnchor(of view: UIView, for dimension: Dimension) -> NSLayoutDimension {
        
        switch dimension {
            
        case .width:        return view.widthAnchor
        case .height:       return view.heightAnchor
        }
    }
    
    private func getXAnchor(of view: UIView, for edge: Edge) -> NSLayoutXAxisAnchor {

        switch edge {

        case .left:     return view.leftAnchor
        case .right:    return view.rightAnchor
        default:        fatalError("Wrong edge provided for X-Anchor")
        }

    }
    
    private func getYAnchor(of view: UIView, for edge: Edge) -> NSLayoutYAxisAnchor {
        
        switch edge {
            
        case .top:      return view.topAnchor
        case .bottom:   return view.bottomAnchor
        default:        fatalError("Wrong edge provided for Y-Anchor")
        }
        
    }
    
    private func xAxisConstraint(anchor: NSLayoutXAxisAnchor, toAnchor: NSLayoutXAxisAnchor, offset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        switch relation {
            
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        }
        
    }
    
    private func yAxisConstraint(anchor: NSLayoutYAxisAnchor, toAnchor: NSLayoutYAxisAnchor, offset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        switch relation {
            
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        }
        
    }
    
    private func baselineConstraint(to otherView: UIView, offset: CGFloat, relation: NSLayoutRelation) -> NSLayoutConstraint {
        
        let anchor = lastBaselineAnchor
        let toAnchor = otherView.lastBaselineAnchor
        
        switch relation {
            
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        }

    }
    
    private func matchingConstraint(view: UIView, edge: Edge, offset: CGFloat = 0) -> NSLayoutConstraint {
        
        switch edge {
            
        case .left:
            return leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset)
        case .top:
            return topAnchor.constraint(equalTo: view.topAnchor, constant: offset)
        case .right:
            return rightAnchor.constraint(equalTo: view.rightAnchor, constant: offset)
        case .bottom:
            return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: offset)
        }
        
    }
    
    private var noSuperviewMessage: String {
        return "Failed to add constraint: Superview doesn't exist"
    }
    
    private var incorrectEdges: String {
        return "Failed to add constraint: Provided edges refer to different axes"
    }
    
}
