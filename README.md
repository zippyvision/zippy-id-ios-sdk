ZippyId SDK written in Swift.

## Requirements

- iOS 10.0+

## Installation by CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'ZippyIdSDK', :git => 'git@github.com:zippyvision/zippy-id-ios-sdk.git'
```

## Usage

### Initialization

Before using the SDK, you must initialize it by calling 

```Swift
import ZippyIdSDK
...
ZippyIdSDK.initialize(key: "<key>", secret: "<secret>")
```

You can access the `key` and `secret` variables by going to [ZippyID admin panel](https://demo.zippyid.com/#/api_integrations) and creating a new API integration

### Usage

To start using, just instantiate and present a new `ZippyVC` instance

```Swift
import ZippyIdSDK
...
let vc = ZippyVC()
vc.delegate = self
self.present(vc, animated: true, completion: nil)
```

The delegate is required and is defined as

```Swift
public protocol ZippyVCDelegate: class {
    func getSessionConfiguration() -> ZippySessionConfig // Returns a configuration for the document scan session
    func onCompletedSuccessfully(result: ZippyResult)    // Called when the ZippyID has finished (either with success, or with error)
    func onCompletedWithError(error: ZippyError)         // Called when an error (server problems, code errors) has occured during process
}
```
