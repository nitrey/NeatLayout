//
//  NeatLayoutTests.swift
//  NeatLayoutTests
//
//  Created by Antonov Aleksandr on 04/04/2018.
//  Copyright © 2018 nitrey. All rights reserved.
//

import XCTest
@testable import NeatLayout

class Tests: XCTestCase {
    
    // MARK: - Views for testing
    
    private var containerView: UIView!
    private var testingView: UIView!
    private var otherView: UIView!
    
    
    // MARK: - Initial setup
    
    override func setUp() {
        super.setUp()
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        testingView = UIView()
        otherView = UIView()
        
        containerView.addSubview(testingView)
        containerView.addSubview(otherView)
    }

    
    // MARK: - Test "Center & Align in Superview" section
    
    func testAutoAlignHorizontalAxisToSuperviewAxis_CentersYCoordinateShouldMatch() {
        
        testingView.autoAlignAxis(toSuperviewAxis: .horizontal)
        evaluateLayout()
        
        XCTAssertEqual(testingView.center.y, containerView.center.y, accuracy: allowedDelta)
    }
    
    func testAutoAlignVerticalAxisToSuperviewAxis_CentersXCoordinateShouldMatch() {
        
        testingView.autoAlignAxis(toSuperviewAxis: .vertical)
        evaluateLayout()
        
        XCTAssertEqual(testingView.center.x, containerView.center.x, accuracy: allowedDelta)
    }
    
    func testAutoCenterInSuperview_CentersShouldMatch() {
        
        testingView.autoCenterInSuperview()
        evaluateLayout()
        
        XCTAssertEqual(testingView.center.x, containerView.center.x, accuracy: allowedDelta)
        XCTAssertEqual(testingView.center.y, containerView.center.y, accuracy: allowedDelta)
    }
    
    
    // MARK: - Pin Edges to Superview
    
    func testAutoPinEdgesToSuperviewEdgesWithInsets_FrameShouldMatchCalculatedRect() {
        
        let insets = UIEdgeInsets(top: 100, left: 200, bottom: 250, right: 300)
        testingView.autoPinEdgesToSuperviewEdges(with: insets)
        evaluateLayout()
        
        let calculatedFrame = CGRect(x: 200, y: 100, width: 500, height: 650)
        XCTAssertEqual(testingView.frame.origin.x, calculatedFrame.origin.x, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.origin.y, calculatedFrame.origin.y, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.width, calculatedFrame.width, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.height, calculatedFrame.height, accuracy: allowedDelta)
    }
    
    func testAutoPinEdgesToSuperviewEdgesWithInsetsExcludingEdge_FrameShouldMatchCalculatedRect() {
        
        testingView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 100, left: 200, bottom: 0, right: 300), excludingEdge: .bottom)
        testingView.autoSetDimension(.height, toSize: 123)
        evaluateLayout()
        
        let calculatedFrame = CGRect(x: 200, y: 100, width: 500, height: 123)
        XCTAssertEqual(testingView.frame.origin.x, calculatedFrame.origin.x, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.origin.y, calculatedFrame.origin.y, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.width, calculatedFrame.width, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.height, calculatedFrame.height, accuracy: allowedDelta)
    }
    
    func testAutoPinTopAndLeftEdgesToSuperviewEdgesWithInset_FrameShouldMatchCalculatedRect() {
        
        testingView.autoPinEdgeToSuperviewEdge(.top, withInset: 125)
        testingView.autoPinEdgeToSuperviewEdge(.left, withInset: 200)
        evaluateLayout()
        
        let calculatedFrame = CGRect(x: 200, y: 125, width: 0, height: 0)
        XCTAssertEqual(testingView.frame.origin.x, calculatedFrame.origin.x, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.origin.y, calculatedFrame.origin.y, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.width, calculatedFrame.width, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.height, calculatedFrame.height, accuracy: allowedDelta)
    }
    
    func testAutoPinBottomAndRightEdgesToSuperviewEdgesWithInset_FrameShouldMatchCalculatedRect() {
        
        testingView.autoPinEdgeToSuperviewEdge(.bottom, withInset: 125)
        testingView.autoPinEdgeToSuperviewEdge(.right, withInset: 200)
        testingView.autoSetDimension(.width, toSize: 0)
        testingView.autoSetDimension(.height, toSize: 0)
        evaluateLayout()
        
        let calculatedFrame = CGRect(x: 800, y: 875, width: 0, height: 0)
        XCTAssertEqual(testingView.frame.origin.x, calculatedFrame.origin.x, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.origin.y, calculatedFrame.origin.y, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.width, calculatedFrame.width, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.height, calculatedFrame.height, accuracy: allowedDelta)
    }
    
    
    // MARK: - Pin edges
    
    func testAutoPinLeftAndBottomEdgesWithOffsetToOtherView_OffsetShouldMatchDistanceBetweenFrames() {
        
        testingView.autoSetDimensions(to: CGSize(width: 50, height: 60))
        otherView.autoSetDimensions(to: CGSize(width: 500, height: 500))
        otherView.autoPinEdgeToSuperviewEdge(.left, withInset: 100)
        otherView.autoPinEdgeToSuperviewEdge(.bottom, withInset: 200)
        testingView.autoPinEdge(.left, to: .right, of: otherView, withOffset: 150)
        testingView.autoPinEdge(.bottom, to: .top, of: otherView, withOffset: -170)
        evaluateLayout()
        
        let calculatedFrame = CGRect(x: 750, y: 70, width: 50, height: 60)
        XCTAssertEqual(testingView.frame.origin.x, calculatedFrame.origin.x, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.origin.y, calculatedFrame.origin.y, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.width, calculatedFrame.width, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.height, calculatedFrame.height, accuracy: allowedDelta)
    }
    
    
    // MARK: - Align Axes
    
    func testAutoAlignHorizontalAxisToOtherViewAxis_CenterYCoordinatesShouldMatch() {
        
        testingView.autoSetDimensions(to: CGSize(width: 100, height: 200))
        otherView.autoSetDimensions(to: CGSize(width: 320, height: 450))
        otherView.autoCenterInSuperview()
        testingView.autoAlignAxis(.horizontal, toSameAxisOf: otherView)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.center.y, otherView.frame.center.y, accuracy: allowedDelta)
    }
    
    func testAutoAlignVerticalAxisToOtherViewAxis_CenterXCoordinatesShouldMatch() {
        
        testingView.autoSetDimensions(to: CGSize(width: 100, height: 200))
        otherView.autoSetDimensions(to: CGSize(width: 320, height: 450))
        otherView.autoCenterInSuperview()
        testingView.autoAlignAxis(.vertical, toSameAxisOf: otherView)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.center.x, otherView.frame.center.x, accuracy: allowedDelta)
    }
    
    
    // MARK: - Set Dimensions
    
    func testAutoSetWidthAndHeight_ViewWidthAndHeightShouldMatchSettedValues() {
        
        let widthValue: CGFloat = 128
        let heightValue: CGFloat = 256
        testingView.autoCenterInSuperview()
        testingView.autoSetDimension(.width, toSize: widthValue)
        testingView.autoSetDimension(.height, toSize: heightValue)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.width, widthValue, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.height, heightValue, accuracy: allowedDelta)
    }
    
    func testAutoSetSize_ViewSizeShouldMatchSettedSize() {
        
        let sizeValue = CGSize(width: 128, height: 256)
        testingView.autoCenterInSuperview()
        testingView.autoSetDimensions(to: sizeValue)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.size.width, sizeValue.width, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.size.height, sizeValue.height, accuracy: allowedDelta)
    }
    
    
    // MARK: - Match Dimensions
    
    func testAutoMatchWidthAndHeightWithOffset_ViewDimensionsShouldMatchOtherViewWidthPlusOffset() {
        
        testingView.autoCenterInSuperview()
        otherView.autoCenterInSuperview()
        otherView.autoSetDimensions(to: CGSize(width: 400, height: 250))
        let widthOffset: CGFloat = 125
        let heightOffset: CGFloat = 265
        testingView.autoMatchDimension(.width, to: .width, of: otherView, withOffset: widthOffset)
        testingView.autoMatchDimension(.height, to: .width, of: otherView, withOffset: heightOffset)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.size.width, otherView.frame.size.width + widthOffset, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.size.height, otherView.frame.size.width + heightOffset, accuracy: allowedDelta)
    }
    
    func testAutoMatchWidthAndHeightWithOffset_ViewDimensionsShouldMatchOtherViewHeightPlusOffset() {
        
        testingView.autoCenterInSuperview()
        otherView.autoCenterInSuperview()
        otherView.autoSetDimensions(to: CGSize(width: 400, height: 250))
        let widthOffset: CGFloat = 432
        let heightOffset: CGFloat = 333
        testingView.autoMatchDimension(.width, to: .height, of: otherView, withOffset: widthOffset)
        testingView.autoMatchDimension(.height, to: .height, of: otherView, withOffset: heightOffset)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.size.width, otherView.frame.size.height + widthOffset, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.size.height, otherView.frame.size.height + heightOffset, accuracy: allowedDelta)
    }
    
    func testAutoMatchWidthAndHeightWithMultiplier_ViewDimensionsShouldMatchOtherViewWidthMultiplied() {
        
        testingView.autoCenterInSuperview()
        otherView.autoCenterInSuperview()
        otherView.autoSetDimensions(to: CGSize(width: 400, height: 250))
        let widthMultiplier: CGFloat = 1.75
        let heightMultiplier: CGFloat = 1.55
        testingView.autoMatchDimension(.width, to: .width, of: otherView, withMultiplier: widthMultiplier)
        testingView.autoMatchDimension(.height, to: .width, of: otherView, withMultiplier: heightMultiplier)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.size.width, otherView.frame.size.width * widthMultiplier, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.size.height, otherView.frame.size.width * heightMultiplier, accuracy: allowedDelta)
    }
    
    func testAutoMatchWidthAndHeightWithMultiplier_ViewDimensionsShouldMatchOtherViewHeightMultiplied() {
        
        testingView.autoCenterInSuperview()
        otherView.autoCenterInSuperview()
        otherView.autoSetDimensions(to: CGSize(width: 400, height: 250))
        let widthMultiplier: CGFloat = 1.75
        let heightMultiplier: CGFloat = 1.55
        testingView.autoMatchDimension(.width, to: .height, of: otherView, withMultiplier: widthMultiplier)
        testingView.autoMatchDimension(.height, to: .height, of: otherView, withMultiplier: heightMultiplier)
        evaluateLayout()
        
        XCTAssertEqual(testingView.frame.size.width, otherView.frame.size.height * widthMultiplier, accuracy: allowedDelta)
        XCTAssertEqual(testingView.frame.size.height, otherView.frame.size.height * heightMultiplier, accuracy: allowedDelta)
    }
    
    
    // MARK: - Supporting methods
    
    private var allowedDelta: CGFloat {
        return 1.0
    }
    
    private func evaluateLayout() {
        evaluateLayout(for: containerView)
    }
    
    private func evaluateLayout(for view: UIView) {
        
        for subview in view.subviews {
            evaluateLayout(for: subview)
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
