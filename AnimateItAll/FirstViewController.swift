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
    //MARK: Constraint Outlets
    @IBOutlet weak var cmhrImageViewHorizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipImageViewHorizontalCenterConstraint: NSLayoutConstraint!
    //MARK: Properties
    private static let appearanceDuration: TimeInterval = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    private func positionWelcomeLabelOffScreen() {
        // welcome label doesn't have position constraints.
        // it respects its placed position in Interface Builder
        // manually position it off screen to the left
        welcomeLabel.center.x -= view.bounds.width
    }
    
    private func setupWinnipegLabel() {
        // make the winnipeg label invisible
        winnipegLabel.alpha = 0
    }
    
    private func setupInitialStateOfCMHRImageView() {
        // change centre constraint to make the image be off-screen to right
        cmhrImageViewHorizontalCenterConstraint.constant += view.bounds.width
        
        // usually need to do a layout call when changing constraint constants
        // otherwise it won't be correct unless iOS does its own layout pass
        // since this is done in view will appear, it's not really necessary
        // because iOS has some draw cycles to do after view will appear and
        // it will move it to the correct place
        view.layoutIfNeeded()
    }
    
    private func setupInitialStateOfSkipImageView() {
        // just changing alpha as we're going to make it grow from tiny later
        skipImageView.alpha = 0
    }
    
    //MARK: Appearance Animations
    private func startAppearanceAnimations() {
        animateWelcomeLabelOnScreen(onCompletion: {
            self.showWinnipegLabel()
            self.animateInImageViews(delay: 0.25)
        })
        
        animateBackgroundColorChange()
    }
    
    // Optionally allows you to do something after the animation completes
    // Defaults to nothing on completion
    private func animateWelcomeLabelOnScreen(onCompletion: (() -> Void)? = nil) {
        // animate its position once the view appeared
        // make the label's center the same as the view's center
        
        UIView.animate(withDuration: FirstViewController.appearanceDuration, animations: {
            self.welcomeLabel.center.x = self.view.center.x
        }, completion: { _ in
            onCompletion?()
        })
    }
    
    private func showWinnipegLabel() {
        // Can use special transition animation options when using UIView.transition
        
        UIView.transition(with: winnipegLabel,
                          duration: FirstViewController.appearanceDuration,
                          options: [.curveLinear, .transitionFlipFromBottom],
                          animations: {
            self.winnipegLabel.alpha = 1
        })
    }
    
    private func animateInImageViews(delay: TimeInterval = 0) {
         animateInCMHRImageView(delay: delay)
         animateInSkipImageView(delay: delay)
    }
    
    private func animateInCMHRImageView(delay: TimeInterval = 0) {
        UIView.animate(withDuration: FirstViewController.appearanceDuration,
                       delay: delay,
                       animations: {
            // change centre constraint back to 0 so it's centered
            self.cmhrImageViewHorizontalCenterConstraint.constant = 0
            
            // remember this is required to animate the change in the 
            // constraint constant. If it is ommitted, the image will
            // immediately be in the new position and iOS won't animate
            // it's change in position
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateInSkipImageView(delay: TimeInterval = 0) {
        // start out the image tiny before animating
        skipImageView.transform = CGAffineTransform().scaledBy(x: 0, y: 0)
        
        // Change the image back to it's actual transform identity (how it would look without the transform above applied)
        // Also giving it a bit of springiness
        UIView.animate(withDuration: FirstViewController.appearanceDuration,
                       delay: delay,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       animations: {
            self.skipImageView.alpha = 1
            self.skipImageView.transform = .identity
        })
    }
    
    private func animateBackgroundColorChange() {
        let lightTeal = UIColor(red: 170/255, green: 224/255, blue: 226/255, alpha: 1)
        let lightYellow = UIColor(red: 226/255, green: 226/255, blue: 170/255, alpha: 1)
        
        // animates on repeat, and autoreverses
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
            self.contentView.backgroundColor = lightTeal
            self.contentView.backgroundColor = lightYellow
        })
    }
}

