## Features

A Flutter plugin which generating the recurrence rules.


## Installation

Add this to your pubspec.yaml dependencies:

```dart

    rrules_generator: ^0.0.1

```

## How to use

Add the widget to your app like this:

```dart

    RRuleGenerator(
        onChanged: (String rrule) => print(rrule),
    );
    
```

see example : [example/](https://github.com/TejasAnghan/rrules_generator/tree/main/example)

## Screeen Shot

![demo 1](https://user-images.githubusercontent.com/68332277/137262729-ec4c68f3-414e-4391-abea-45374bcf787a.png)

## Thanks

   This package is use [rrule](https://pub.dev/packages/rrule) pakage for calculate the recurrence rule from user input.
