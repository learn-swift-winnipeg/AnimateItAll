# AnimateItAll

## Purpose

A simple iOS app to demonstrate how to do some different types of animations to add some spice to an app!

It was prepared by [Justin Stanley](https://github.com/jstheoriginal) to present at the *Learn Swift Winnipeg* meetup Wed, Nov 15, 2017.

## Appearance Animations

These animations happen when the first tab appears. You can tap on the Reset tab and return to the Animations tab and it will perform the appearance animations again.

- The background colour animates continuously between teal and yellow
- The 'Welcome to' label flies in from the left
- The 'WINNIPEG' label appears and flips into view
- The first image flies in from the right
- The second image pops in in place, with some spring in its step

## Action-Based Animations

- Tap on *WINNIPEG* to make it animate it's text colour change between white and black. Animating colour changes requires diving into Core Animation unless you use the UIView.transition() API. Using the UIView.animate() API will not animate the colour change.
- Tap on the image of Winnipeg's Canadian Museum for Human Rights.
  - This uses the standard UIView.animate API.
  - The background dims and the image moves to the centre of the screen and becomes full width.
  - Tap when expanded and it moves back.
- Tap on the image of Winnipeg's [SkipTheDishes](www.skipthedishes.com) (Option #1)
  - Uses the newer UIViewPropertyAnimator API.
  - The background dims, the image moves to the centre of the screen, its aspect ratio changes from square to 3:2, and becomes full width.
  - Tap when expanded and it moves back.
- Long-press on the SkipTheDishes image (Option #2)
  - Uses the newer UIViewPropertyAnimator API.
  - The thumbnail slowly grows to 1.1x it's normal size, kind of like how iOS mimics 3D touching on a non-3D Touch device.
  - Once it reaches 1.1x its size, it performs the same animation as Option #1 did, popping open.
  - Tap when expanded and it moves back like in Option #1 (it does not respond to long-press the same way it does when not expanded)
  
## Resources

### Animate with UIViewPropertyAnimator
  
Introduced in iOS 10.

A class that animates changes to views and allows the dynamic modification of those animations.

See Apple's official documentation for [UIViewPropertyAnimator](https://developer.apple.com/documentation/uikit/uiviewpropertyanimator).

### Animate with UIView's animate & transition Methods

Introduced in iOS 4.

Apple notes this in its documentation:
> Use of these methods is discouraged. Use the UIViewPropertyAnimator class to perform animations instead.

See Apple's official documentation for some of the more commonly used methods, such as the [animate method, without spring animations](https://developer.apple.com/documentation/uikit/uiview/1622451-animate), the [animate method, with spring animations](https://developer.apple.com/documentation/uikit/uiview/1622594-animate), and the [transition method](https://developer.apple.com/documentation/uikit/uiview/1622574-transition).