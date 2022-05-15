# JDModuleManager

[![CI Status](https://img.shields.io/travis/Hello-World/JDModuleManager.svg?style=flat)](https://travis-ci.org/Hello-World/JDModuleManager)
[![Version](https://img.shields.io/cocoapods/v/JDModuleManager.svg?style=flat)](https://cocoapods.org/pods/JDModuleManager)
[![License](https://img.shields.io/cocoapods/l/JDModuleManager.svg?style=flat)](https://cocoapods.org/pods/JDModuleManager)
[![Platform](https://img.shields.io/cocoapods/p/JDModuleManager.svg?style=flat)](https://cocoapods.org/pods/JDModuleManager)

## Example

JDModule Show为demo其中

```yaml
├── JDModuleShow.xcworkspace
├── JDModuleShow.xcodeproj
├── AppDelegate.m
├── AModule
|   ├── AModuleDemo
├── BModule
|   ├── BModuleDemo
|   ├── BModuleTask
├── Router
|   ├── Router.h
├── Service
|   ├── AmoduleProtocol
|   ├── BmoduleProtocol
├── Pods
└── podfile
└── podfile.lock
```



Amodule, Bmodule 表示2个独立模块

Router.h 管理路由

Service 下面管理模块服务


## Requirements

## Installation

JDModuleManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JDModuleManager'
```

## Author

Hello-World, jackincitibank@gmail.com

## License

JDModuleManager is available under the MIT license. See the LICENSE file for more info.
