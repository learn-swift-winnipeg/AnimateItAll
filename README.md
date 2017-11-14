# AnimateItAll

## Purpose

A simple iOS app to demonstrate how to do some different types of animations to add some spice to an app!

It was prepared by [Justin Stanley](https://github.com/jstheoriginal) to present at the *Learn Swift Winnipeg* meetup Wed, Nov 15, 2017.

## Consideration

It would make sense to create an object that handles performing the animations when dealing with the new UIViewPropertyAnimator API. For the purpose of this demo, this all exists within the ViewController itself.

## Appearance Animations

These animations happen when the first tab appears. You can tap on the Reset tab and return to the Animations tab and it will perform the appearance animations again.

- The background colour animates continuously between teal and yellow
- The 'Welcome to' label flies in from the left
- The 'WINNIPEG' label appears and flips into view
- The first image flies in from the right
- The second image pops in in place, with some spring in its step

## Action-Based Animations

### WINNIPEG Label
- Tap on *WINNIPEG* to make it animate it's text colour change between white and black.
- This demonstrates using the UIView.transition method to do what otherwise requires diving into Core Animation. Using the UIView.animate method will not animate the colour change.

### Image #1
- Tap on the image of Winnipeg's Canadian Museum for Human Rights.
  - This uses the standard UIView.animate API.
  - The background dims and the image moves to the centre of the screen and becomes full width.
  - Tap when expanded and it moves back.
  
### Image #2
#### Option #1
- Tap on the image of Winnipeg's [SkipTheDishes](www.skipthedishes.com)
  - Uses the newer UIViewPropertyAnimator API.
  - The background dims, the image moves to the centre of the screen, its aspect ratio changes from square to 3:2, its rounded corners go back to squared, and becomes full width.
  - Tap when expanded and it moves back.
#### Option #2
- Long-press on the SkipTheDishes image
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

## About the Presenter/Developer

[Justin](https://swiftwithjustin.co/about/) works at [SkipTheDishes](www.skipthedishes.com) as a full time React Native/JavaScript mobile developer (recently switched from Swift to React Native). He also designed and created an app called [BB Links](www.bblinksapp.com), which is used by over 21,000 monthly active Beachbody coaches and has over 1,000 ratings averaging 4.9 stars.
