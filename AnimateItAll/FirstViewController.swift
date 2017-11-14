//
//  FirstViewController.swift
//  AnimateItAll
//
//  Created by Justin Stanley on 2017-11-11.
//  Copyright © 2017 Justin Stanley. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    //MARK: View Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var winnipegLabel: UILabel!
    @IBOutlet weak var cmhrImageView: UIImageView!
    @IBOutlet weak var skipImageView: UIImageView!
    @IBOutlet weak var dimmedView: UIView!
    //MARK: Constraint Outlets
    @IBOutlet weak var cmhrImageViewHorizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var cmhrImageViewVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var cmhrImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipImageViewHorizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipImageViewVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipImageView3x2AspectRatioConstraint: NSLayoutConstraint!
    //MARK: Properties
    private let normalAnimationDuration: TimeInterval = 0.7
    private var cmhrImageIsFocused = false
    private var skipImageIsFocused = false
    private var winnipegLabelIsWhite = false
    private var skipImageAnimatorDuration: TimeInterval = 0.5
    private var skipImageAnimator: UIViewPropertyAnimator?
    private var skipImageLongPressStartTime: Date?
    private var skipImageLongPressDurationSinceStart: TimeInterval {
        guard let startTime = skipImageLongPressStartTime else { return 0 }
        
        return Date().timeIntervalSince(startTime)
    }
    private var skipImageLongPressProgress: CGFloat {
        guard skipImageLongPressDurationSinceStart != 0 else { return 0 }
        
        // determine the time since long press started to get progress vs animation duration
        return CGFloat(min(100, skipImageLongPressDurationSinceStart / skipImageAnimatorDuration * 100))
    }
    
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSkipImageAnimator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBeforeAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAppearanceAnimations()
    }
    
    //MARK: Initial Setup
    private func setupBeforeAppearance() {
        positionWelcomeLabelOffScreen()
        setupWinnipegLabel()
        setupInitialStateOfCMHRImageView()
        setupInitialStateOfSkipImageView()
        setupDimmedView()
    }
    
    private func setupDimmedView() {
        dimmedView.isHidden = false
        dimmedView.alpha = 0
    }
    
    private func positionWelcomeLabelOffScreen() {
        // welcome label doesn't have position constraints. it respects its placed position in Interface Builder manually position it off screen to the left
        welcomeLabel.center.x -= view.bounds.width
    }
    
    private func setupWinnipegLabel() {
        // make the winnipeg label invisible
        winnipegLabel.alpha = 0
    }
    
    private func setupInitialStateOfCMHRImageView() {
        // change centre constraint to make the image be off-screen to right
        cmhrImageViewHorizontalCenterConstraint.constant += view.bounds.width
        
        // usually need to do a layout call when changing constraint constants otherwise it won't be correct unless iOS does its own layout pass since this is done in view will appear, it's not really necessary because iOS has some draw cycles to do after view will appear and it will move it to the correct place
        view.layoutIfNeeded()
    }
    
    private func setupInitialStateOfSkipImageView() {
        // just changing alpha as we're going to make it grow from tiny later
        skipImageView.alpha = 0
        
        // add rounded corners
        skipImageView.layer.cornerRadius = 15
        skipImageView.clipsToBounds = true
    }
    
    private func setupSkipImageAnimator() {
        // configure the animator with duration, curve, interruptible and allows interaction
        let animator = UIViewPropertyAnimator.init(duration: skipImageAnimatorDuration, curve: .linear)
        animator.isInterruptible = true
        animator.isUserInteractionEnabled = true
        
        skipImageAnimator = animator
    }
    
    //MARK: Appearance Animations
    private func startAppearanceAnimations() {
        animateWelcomeLabelOnScreen(onCompletion: {
            self.showWinnipegLabel()
            self.animateInImageViews(delay: 0.25)
        })
        
        animateBackgroundColorChange()
    }
    
    // Uses the older UIView.animate API
    // Optionally allows you to do something after the animation completes. Defaults to nothing on completion
    private func animateWelcomeLabelOnScreen(onCompletion: (() -> Void)? = nil) {
        // animate its position once the view appeared
        // make the label's center the same as the view's center
        
        UIView.animate(withDuration: normalAnimationDuration, animations: {
            self.welcomeLabel.center.x = self.view.center.x
        }, completion: { _ in
            onCompletion?()
        })
    }
    
    // Uses the older UIView.transition API
    private func showWinnipegLabel() {
        // Can use special transition animation options when using UIView.transition such as flipping the label
        
        UIView.transition(with: winnipegLabel,
                          duration: normalAnimationDuration,
                          options: [.curveLinear, .transitionFlipFromBottom],
                          animations: {
            self.winnipegLabel.alpha = 1
        })
    }
    
    private func animateInImageViews(delay: TimeInterval = 0) {
         animateInCMHRImageView(delay: delay)
         animateInSkipImageView(delay: delay)
    }
    
    // Uses the older UIView.animate API
    private func animateInCMHRImageView(delay: TimeInterval = 0) {
        UIView.animate(withDuration: normalAnimationDuration,
                       delay: delay,
                       animations: {
            // change centre constraint back to 0 so it's centered
            self.cmhrImageViewHorizontalCenterConstraint.constant = 0
            
            // remember this is required to animate the change in the constraint constant. If it is ommitted, the image will immediately be in the new position and iOS won't animate its change in position
            self.view.layoutIfNeeded()
        })
    }
    
    // Uses the older UIView.animate API
    private func animateInSkipImageView(delay: TimeInterval = 0) {
        // start out the image tiny before animating
        skipImageView.transform = CGAffineTransform().scaledBy(x: 0, y: 0)
        
        // Change the image back to it's actual transform identity (how it would look without the transform above applied). Also giving it a bit of springiness
        UIView.animate(withDuration: normalAnimationDuration,
                       delay: delay,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       animations: {
            self.skipImageView.alpha = 1
            self.skipImageView.transform = .identity
        })
    }
    
    // Uses the old UIView.animate API
    // repeatedly animates the background colour of the view between two colours.
    // If you don't put .allowUserInteraction option, your view will NOT respond to any touches
    private func animateBackgroundColorChange() {
        let lightTeal = UIColor(red: 170/255, green: 224/255, blue: 226/255, alpha: 1)
        let lightYellow = UIColor(red: 226/255, green: 226/255, blue: 170/255, alpha: 1)
        
        // animates on repeat, and autoreverses
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut, .allowUserInteraction],
                       animations: {
            self.view.backgroundColor = lightTeal
            self.view.backgroundColor = lightYellow
        })
    }
    
    //MARK: Actions

    // Uses the older UIView animation APIs
    @IBAction private func cmhrImageTapped() {
        // Use iOS 11's new way to animate corner radius
        
        
        positionDimmedViewBehind(cmhrImageView)
        showDimmedView(!cmhrImageIsFocused)
        animateCMHRImageAfterTap(isFocusing: !cmhrImageIsFocused)
        
        cmhrImageIsFocused = !cmhrImageIsFocused
    }
    
    // Uses the older UIView.transition API
    @IBAction private func winnipegLabelTapped() {
        let isWhite = winnipegLabelIsWhite
        
        self.winnipegLabelIsWhite = !isWhite
        
        // To animate text color, UIView.animate doesn't work
        // Instead, you must use UIView.transition and do a cross disolve to transition a snapshot of the label using the old colour to the label with the new colour
        UIView.transition(with: winnipegLabel,
                          duration: 1,
                          options: [.transitionCrossDissolve, .allowUserInteraction],
                          animations: {
            self.winnipegLabel.textColor = isWhite ? .black : .white
        })
    }
    
    // Uses the new UIViewPropertyAnimator API
    // When the Skip image is long-pressed, it grows in size, almost like a 3D Touch Press
    @IBAction private func skipImageLongPressed(recognizer: UILongPressGestureRecognizer) {
        if skipImageIsFocused {
            switch recognizer.state {
                case .began:
                    // we only want this effect if not focused, so just pop it back to unfocused
                    popSkipImageView(toFocused: false)
                case .changed, .ended, .cancelled, .possible, .failed:
                    break
            }
        } else {
            // Switch on the long-press recognizer's state to do different animator actions
            switch recognizer.state {
                case .began:
                    // If long-press starting, prepare our animator, start the animation, and set the long-press start time so we can keep track
                    prepareSkipImageGrowAnimator()
                    skipImageAnimator?.startAnimation()
                    skipImageLongPressStartTime = Date()
                case .changed:
                    // this is just if any fingers move
                    break
                case .ended:
                    // If long-press held long-enough, we'll stop & finish the animation
                    // otherwise we'll reverse the animation so it goes back to before the long-press began
                    let isCompleted = skipImageLongPressProgress == 100
                    
                    if isCompleted {
                        // stop the animation; the false is for "withoutFinishing", but we want it to call the 
                        // completion block of the animator so we pass false.
                        // then finish the animation at the end point which calls the animation completion block.
                        skipImageAnimator?.stopAnimation(false)
                        skipImageAnimator?.finishAnimation(at: .end)
                    } else {
                        // runs the animation in reverse to "undo" what happened thus far
                        skipImageAnimator?.isReversed = true
                    }
                    
                    // Set our start time to nil since it's ended
                    skipImageLongPressStartTime = nil
                case .possible, .cancelled, .failed:
                    // not states for long press recognizer
                    break
                }
        }
    }
    
    // Uses the new UIViewPropertyAnimator API
    @IBAction private func skipImageTapped() {
        positionDimmedViewBehind(skipImageView)
        popSkipImageView(toFocused: !skipImageIsFocused)
    }
    
    //MARK: Animations via Actions
    
    // Uses the older UIView.animate API
    private func animateCMHRImageAfterTap(isFocusing: Bool) {
        UIView.animate(withDuration: normalAnimationDuration / 2,
                       delay: 0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
            // If is focusing, make the center vertically constraint have a higher priority than the top constraint
            self.cmhrImageViewVerticalCenterConstraint.priority = UILayoutPriority(rawValue: isFocusing ? 751 : 250)
                        
            // If focusing, change the image view's width to full screen instead of the smaller width
            self.cmhrImageViewWidthConstraint.constant = isFocusing ? self.view.bounds.width : 192
            
            // required for priority or constant changes on a constraint for animation
            self.view.layoutIfNeeded()
        })
    }
    
    // Uses the older UIView.animate API
    @objc private func showDimmedView(_ show: Bool) {
        UIView.animate(withDuration: normalAnimationDuration / 2) {
            // If showing, dim the background so it's dark behind the image
            self.dimmedView.alpha = show ? 0.8 : 0
        }
    }
    
    // Uses the new UIViewPropertyAnimator API
    // Mimics how a 3D touch press looks on icons, but we're doing it with long-press instead
    // Grows the image to 1.1x it's normal size
    private func prepareSkipImageGrowAnimator() {
        positionDimmedViewBehind(skipImageView)
        
        // These animations will happen when you start the animator
        skipImageAnimator?.addAnimations {
            // grow our imageview to 1.1x it's normal size to mimic the 3D touch look
            self.skipImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        // This block happens if stopAnimation(false) is called before finishAnimation(at:)
        skipImageAnimator?.addCompletion { finalPosition in
            switch finalPosition {
                case .current:
                    break
                case .start:
                    self.skipImageIsFocused = false
                case .end:
                    // check if long press went to required full duration and if so, pop the image view to focused
                    // otherwise, just reset
                    if self.skipImageLongPressProgress == 100 {
                        self.popSkipImageView(toFocused: true)
                    } else {
                        self.skipImageIsFocused = false
                    }
            }
        }
    }
    
    // Uses the new UIViewPropertyAnimator API
    // Creates an animator in-place that either pops the image open, or closes it, depending on the current state of the image
    private func popSkipImageView(toFocused: Bool = true) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: normalAnimationDuration / 2, delay: 0, options: [.curveEaseOut], animations: {
            self.dimmedView.alpha = toFocused ? 0.8 : 0
            
            // As of iOS 11, you can animate corner radius changes
            // You can even animate/add corner radius to only some corners using:
            // .layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
            // which would apply the corner radius only to the bottom right & top left corners
            self.skipImageView.layer.cornerRadius = toFocused ? 0 : 15
            
            self.skipImageViewVerticalCenterConstraint.priority = UILayoutPriority(rawValue: toFocused ? 751 : 250)
            self.skipImageViewWidthConstraint.constant = toFocused ? self.view.bounds.width : 120
            
            // the normal square aspect ratio constraint has priority 752, so if it's coming into focus, make the 3x2 aspect ratio constraint's priority higher so it becomes the active constraint
            self.skipImageView3x2AspectRatioConstraint.priority = UILayoutPriority(rawValue: toFocused ? 753 : 250)
            
            // set the transform back to identity in case a previous transform was applied (which happens if it was long-pressed)
            self.skipImageView.transform = .identity
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.skipImageIsFocused = toFocused
        })
    }
    
    //MARK: Helpers
    
    // brings dimmed view to front, and then the imageView passed in in front of the dimmed view
    private func positionDimmedViewBehind(_ imageView: UIImageView) {
        contentView.bringSubview(toFront: dimmedView)
        contentView.bringSubview(toFront: imageView)
    }
}
