# SMobiLog
SMobiLogger is a logger library, which provides logs, crash reports from iOS device along with email logs facility.

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like 'SMobiLog' in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build SMobiLog 0.1.0+.

#### Podfile

To integrate SMobiLog into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'SMobiLog'
end
```

Then, run the following command:

```bash
$ pod install
```
## Requirements

| SMobiLog Version | Minimum iOS Target  |                                   Notes                                   |
|:--------------------:|:---------------------------:|:-------------------------------------------------------------------------:|
| 0.1.5 | iOS 8 | Few bug fixes. |
| 0.1.4 | iOS 8 | Integrated KSCrash reporting. |
| 0.1.3 | iOS 8 | Handle Uncaught exceptions. |
| 0.1.2 | iOS 8 | Xcode 8+ is required. Minimum iOS version support has been changed. |
| 0.1.0 | iOS 9.3 | Realm support is included. Minimum iOS version support is 9.3 |

## Usage

### SMobiLogger

```objective-c```

In Appdelegate's `didFinishLaunchingWithOptions:` start MobiLogger 

`[[SMobiLogger sharedInterface] startMobiLogger]`

It will clear old logs(currently it stores logs for 2 days, which can be changed from plist), initialise Realm

#### Log Uncaught exception

In Appdelegate's `didFinishLaunchingWithOptions:` call any one of the following method as per your need

```
- (KSCrashInstallation *)installKSCrashWithURL:(NSString *)urlPath;
- (KSCrashInstallation *)installKSCrashWithEmails:(NSArray *)emails;
- (KSCrashInstallation *)installKSCrashWithURL:(NSString *)urlPath withAlert:(BOOL)showAlert;
- (KSCrashInstallation *)installKSCrashWithEmails:(NSArray *)emails withAlert:(BOOL)showAlert;
```

#### Log Types
Following types are available to differentiate log messages.
```
Debug,
Error,
Crash,
Information,
Warning,
Other
```

#### Log messages

Info Type:
```
[[SMobiLogger sharedInterface] info:@"Application Became Active ." withDescription:[NSString stringWithFormat:@"At: %s. \n  \n", __FUNCTION__]];
```

Error Type:
```
[[SMobiLogger sharedInterface] error:@"Network Status:" withDescription:@"Unavailable"];
``` 

You can use any logType as per your need.
    
### Fetch logs

To Fetch all the logs from db
```
NSString *fetchLogString = [[SMobiLogger sharedInterface] fetchLogs];
```

### Send logs via Email

To send logs via email (Pass your `UIViewController` on which you want to present `MFMailComposeViewController`)
``` 
- (void)sendEmailLogs:(id)controller;
``` 

## Credits

SMobiLog is owned and maintained by the [Systango Ltd](http://www.systango.com/).

### Security Disclosure

If you believe you have identified a security vulnerability with SMobiLog, you should report it as soon as possible via email to zoeb@systango.com. Also please post it to a issue tracker.

## License

SMobiLog is released under the MIT license. See LICENSE for details.
