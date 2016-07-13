# LEMapviewFrameworks
 
[![Version](https://img.shields.io/cocoapods/v/LEMapviewFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEMapviewFrameworks)
[![License](https://img.shields.io/cocoapods/l/LEMapviewFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEMapviewFrameworks)
[![Platform](https://img.shields.io/cocoapods/p/LEMapviewFrameworks.svg?style=flat)](http://cocoapods.org/pods/LEMapviewFrameworks)

## #import "LEMapviewFrameworks.h"
![](https://github.com/LarryEmerson/LEMapviewFrameworks/blob/master/Example/LEMapviewFrameworks.gif)
#### 类说明
```
"LEMapView.h"                       //地图主体部分（需设置）
"LEMapViewAnnotation.h"             //地图主体图钉View对应的Annotation（无需关注）
"LEMapViewSearchAnnotation.h"       //地图搜索图钉View对应的Annotation（无需关注）
"LEMapCallOutViewAnnotation.h"      //地图Callout图钉View对应的Annotation（无需关注）
"LEMapBaseAnnotationView.h"         //地图图钉View的基类（无需关注，用于继承）
"LEMapViewAnnotationView.h"         //地图主体图钉View（无需关注）
"LEMapViewSearchAnnotationView.h"   //地图搜索图钉View（无需关注）
"LEMapCallOutAnnotationView.h"      //地图CallOut图钉View（无需关注）
"LEMapViewUserAnnotationView.h"     //地图用户图钉View（无需关注）
"LEMapViewAnnotationSubView.h"      //地图自定义Callout基类（需继承自定义）
"LEMapSearchBar.h"                  //地图搜索条（无需关注，处理回调即可）
```
#### LEMapview 地图图钉工厂优先级
```
地图图钉工厂优先级（mapView:viewForAnnotation:）
1-LEMapCallOutViewAnnotation->LEMapCallOutAnnotationView->SubViewClass(自定义)
2-MAUserLocation->LEMapViewUserAnnotationView
3-LEMapViewSearchAnnotation->LEMapViewSearchAnnotationView
4-else的情况(可重写:onOverwriteViewForAnnotation:FromMapview:){
    LEMapViewAnnotation->curAnnotationViewClass（自定义）
}
```
#### LEMapview 点击事件处理及优先级说明
```
地图图钉点击事件优先级（）
1-LEMapViewAnnotationView->LEMapCallOutViewAnnotation
2-else的情况（可重写:onOverwriteMapView:didSelectAnnotationView:）
```



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LEMapviewFrameworks is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby 
pod "LEMapviewFrameworks"
```

## Author

LarryEmerson, larryemerson@163.com

## License

LEMapviewFrameworks is available under the MIT license. See the LICENSE file for more info.


