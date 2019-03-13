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

You can also pass an integer value for  `customer_uid` adding it's argument in the initialization as follows

```Swift
ZippyIdSDK.initialize(key: "<key>", secret: "<secret>", customerUid: "<customer_uid>")
```

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

### Results

To receive the user's results, create a `ZippyVCDelegate` extension using methods `onCompletedSuccessfully(result: ZippyResult)` and `onCompletedWithError(error: ZippyError)`

```Swift
extension ViewController: ZippyVCDelegate {
    func onCompletedSuccessfully(result: ZippyResult) {
        print(result)
    }

    func onCompletedWithError(error: ZippyError) {
        print(error.localizedDescription)
        ...
    }
}
```

If the session was successful `onCompletedSuccessfully` is called which contains the sessions result in `result`

If there was an error `onCompletedWithError` is called which contains the error message in `error`

### Optional callback

If you want you can use 3 additional functions by adding a `ZippyCallback` extension

```Swift
extension ViewController: ZippyCallback {
    func onSubmit() {
        // called when all images are sent
    }
    func onTextExtracted() {
        // called when API receives a result
    }
    func onFinished() {
        // called when all is finished
    }
}
```

and passing it to `ZippyVC()` as 

```
vc.zippyCallback = self
```
