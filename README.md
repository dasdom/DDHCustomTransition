# DDHCustomTransition
Helper classes to make basic view controller transitions easier 

## Installation
Add **CustomTransition.swift** to your project.

## Usage
1. Create an instance of `NavigationControllerDelegate` and set to the delegate property of an `UINavigationController`.
1. Make the view controllers participating in the transition conforming to the `TransitionInfoProtocol` protocol.
1. There is no step three.

## TransitionInfoProtocol
The `TransitionInfoProtocol` defines two required and one optional methods:

```swift
/* Return the views which shoud be animated in the transition
 */
func viewsToAnimate() -> [UIView]

/* Return a copy of the view which is passed in
   The passed in view is one of the views to animate
 */
func copyForView(subView: UIView) -> UIView

/* Optionally return the frames for the views which should be
   animated. This is needed sometimes because for example
   with custom container view contrllers the transitioning code
   can't figure out where on screen the view is actually visible
   when loaded.
 */
optional func frameForView(subView: UIView) -> CGRect
```

Let's say you want to animate a image view from the first view controller to the position of the second view controller (see the gif and the demo project). In the first view controller the protocol conformance could look like this:

```swift
import UIKit

class ViewController: UIViewController, TransitionInfoProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func viewsToAnimate() -> [UIView] {
        return [imageView, label]
    }
    
    func copyForView(subView: UIView) -> UIView {
        if subView == imageView {
            let imageViewCopy = UIImageView(image: imageView.image)
            imageViewCopy.contentMode = imageView.contentMode
            imageViewCopy.clipsToBounds = true
            return imageViewCopy
        } else if subView == label {
            let labelCopy = UILabel()
            labelCopy.text = label.text
            labelCopy.font = label.font
            labelCopy.backgroundColor = view.backgroundColor
            return labelCopy
        }
        return UIView()
    }
}
```

In the second view controller it could look like this:

```swift
import UIKit

class DetailViewController: UIViewController, TransitionInfoProtocol {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func viewsToAnimate() -> [UIView] {
        return [imageView, label]
    }
    
    func copyForView(subView: UIView) -> UIView {
        if subView == imageView {
            let imageViewCopy = UIImageView(image: imageView.image)
            imageViewCopy.contentMode = imageView.contentMode
            imageViewCopy.clipsToBounds = true
            return imageViewCopy
        } else if subView == label {
            let labelCopy = UILabel()
            labelCopy.text = label.text
            labelCopy.font = label.font
            labelCopy.backgroundColor = label.backgroundColor
            return labelCopy
        }
        return UIView()
    }
}
```

## Author

Dominik Hauser

[App.net: @dasdom](https://alpha.app.net/dasdom)

[Twitter: @dasdom](https://twitter.com/dasdom)

[swiftandpainless.com](http://swiftandpainless.com)

## Licence

MIT
