[![Latest Version](https://img.shields.io/github/v/tag/ChristianFox/EventTracker?sort=semver&label=Version&color=orange)](https://github.com/ChristianFox/EventTracker/)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange)](https://img.shields.io/badge/Swift-5.7-orange)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-orange)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-orange)

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-yes-green)](https://img.shields.io/badge/Swift_Package_Manager-yes-green)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-no-red)](https://img.shields.io/badge/Cocoapods-no-red)
[![Cathage](https://img.shields.io/badge/Cathage-no-red)](https://img.shields.io/badge/Cathage-no-red)
[![Manually](https://img.shields.io/badge/Manual_Import-yes-green)](https://img.shields.io/badge/Manually_Added-sure-green)

[![CodeCoverage](https://img.shields.io/badge/Code%20Coverage-98.2%25-green)](https://img.shields.io/badge/Code%20Coverage-98.2%25-green)
[![License](https://img.shields.io/badge/license-mit-blue.svg)](https://github.com/ChristianFox/EventTracker/blob/master/LICENSE)
[![Contribution](https://img.shields.io/badge/Contributions-Welcome-blue)](https://github.com/ChristianFox/EventTracker/labels/contribute)
[![First Timers Friendly](https://img.shields.io/badge/First_Timers-Welcome-blue)](https://github.com/ChristianFox/EventTracker/labels/contribute)

[![Size](https://img.shields.io/github/repo-size/ChristianFox/EventTracker?color=orange)](https://img.shields.io/github/repo-size/ChristianFox/EventTracker?color=orange)
[![Files](https://img.shields.io/github/directory-file-count/ChristianFox/EventTracker?color=orange)](https://img.shields.io/github/directory-file-count/ChristianFox/EventTracker?color=orange)

# EventTracker

EventTracker is an open-source Swift library that allows you to easily track and monitor multiple named events and their occurrences. The library provides a simple interface to register, update, reset, and evaluate events based on customizable conditions. It also includes support for logging and persistence through UserDefaults.


## Use Cases

I use this in another library [ReviewPrompter](https://github.com/ChristianFox/ReviewPrompter) but it can be used to track any number of things when you want to perform some action when the user has done some event x number of times, e.g. Prompting them to purchase a premium subscription after they have used a feature three times.

## Features

- Track multiple named events with unique identifiers
- Set custom conditions to evaluate events
- Increase and reset event counts
- Evaluate whether an event has met its condition
- Check if an event is being tracked
- Retrieve event count and condition values
- Enable or disable logging
- Persist tracked events and their conditions using UserDefaults

## Tests

The library is basically fully tested with 98.2% code coverage


## Installation

### Swift Package Manager
To add EventTracker to your project using Swift Package Manager, add the following dependency in your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/ChristianFox/EventTracker.git", from: "1.0.0")
]
```

Don't forget to add EventTracker to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["EventTracker"]),
]
```

## Usage

Initialise an instance

```swift
import EventTracker

let eventTracker = EventTracker(isLoggingEnabled: true)
```

Begin tracking an event

```swift
eventTracker.trackEvent(forIdentifier: "event1", withCondition: 3)
```

Stop tracking an event

```swift
eventTracker.stopTrackingEvent(forIdentifier: "event1")
```

Change the condition for an event

```swift
do {
    try eventTracker.changeCondition(5, forIdentifier: "event1")
} catch {
    print("Error updating event condition: \(error)")
}
```

Increase the event count

```swift
do {
    try eventTracker.increaseEventCount(forIdentifier: "event1")
} catch {
    print("Error increasing event count: \(error)")
}
```

Reset the event count

```swift
do {
    try eventTracker.resetEventCount(forIdentifier: "event1")
} catch {
    print("Error resetting event count: \(error)")
}
```

Check if an event's condition has been met

```swift
if eventTracker.hasEventMetCondition(forIdentifier: "event1") {
    print("Event met condition!")
}
```

Check an event is being tracked

```swift
if eventTracker.isTrackingEvent(forIdentifier: "event1") {
    print("Event is being tracked!")
}
```

Check the number of times an event has occured

```swift
let eventCount = eventTracker.eventCount(forIdentifier: "event1")
print("Event count: \(eventCount)")
```

Check the current condition of an event

```swift
let eventCondition = eventTracker.condition(forIdentifier: "event1")
print("Event condition: \(eventCondition)")
```


## Contributing

Pull requests are welcome. I welcome developers of all skill levels to help improve the library, fix bugs, or add new features. 

For major changes, please open an issue first to discuss what you would like to change.

Before submitting a pull request, please ensure that your code adheres to the existing code style and conventions, and that all tests pass. Additionally, if you're adding new functionality, please make sure to include unit tests to verify the behavior.

If you have any questions or need assistance, feel free to open an issue, and I'll do my best to help you out. 


## Licence

EventTracker is released under the MIT Licence. See the LICENSE file for more information.
