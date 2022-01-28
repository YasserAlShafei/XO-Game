# SwiftyCodeView

[![Version](https://img.shields.io/cocoapods/v/SwiftyCodeView.svg?style=flat)](https://cocoapods.org/pods/SwiftyCodeView)
[![License](https://img.shields.io/cocoapods/l/SwiftyCodeView.svg?style=flat)](https://cocoapods.org/pods/SwiftyCodeView)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyCodeView.svg?style=flat)](https://cocoapods.org/pods/SwiftyCodeView)

SwiftyCodeView is an elegant and customizable UI component which can be used as input field for verification codes, password, etc...

<img src="https://raw.githubusercontent.com/arturdev/SwiftyCodeView/master/demo.gif">

## Usage
Drag a UIView object into storyboard and set it's class to SwiftCodeView.
<br>Implement SwiftyCodeViewDelegate protocol.
<br>Thats it!

```Swift
extension ViewController: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) {
        print("Entered code: ", code)
    }
}
```

## Customization
Things you can customize - Everything! (See example project)

## Requirements

iOS >= 9.3
<br>Xcode >= 9.0

## Installation

SwiftyCodeView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyCodeView'

# or 

pod 'SwiftyCodeView/RxSwift'

```

## Author

arturdev, mkrtarturdev@gmail.com

Feel free to open issues, feature requests and point bugs/mistakes!

## License

SwiftyCodeView is available under the MIT license. See the LICENSE file for more info.
