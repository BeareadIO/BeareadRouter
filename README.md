# BeareadRouter
version: 0.1
BeareadRouter 是白熊阅读针对Url链接跳转的一套路由方案
## 导入
BeareadRouter 主要由UrlRoute.h .m 以及规则对应plist文件和页面对应plist文件组成。

```c
#import "UrlRoute.h"

// 在UrlRoute.h文件定义相关宏
#define URLRouteScheme              @"test"
#define URLRouteHost                @"www.test.com"
#define URLRouteRulePlist           @"Route"
#define URLRouteMappingPlist        @"Mapping"
```
## UrlRoute使用
UrlRoute提供了两种创建路由的方式，并提供了类方法，和实例方法

```objective-c
//类方法
UrlRoute *route = [URLRoute routeWithUrlString:@"bearead://www.bearead.com/book?bid=b001"];
UrlRoute *route = [URLRoute routeWithTarget:@"book" args:@{@"bid":@"b001"}];

//实例方法
UrlRoute *route = [UrlRoute shareRoute];
[route genRouteWithUrlString:@"bearead://book?bid=b001"];
[route genRouteWithTarget:@"book" args:@{@"bid":@"b001"}];
```

UrlRoute通过对应routeError来判断是否路由创建并解析成功

```objective-c
if (route.routeError) {
    NSLog(@"%@",route.routeError);
} else {
    NSLog(@"%@",route);
    //路由有效参数 route.routeArguments
    //路由有效页面 route.routeController
    //路由有效故事板 route.routeStoryboard
}
```
## 功能
* [x] 类与实例化方法生成路由
* [x] 字符串&字典两种传递参数方式
* [x] 通过参数组合生成对象传递
* [x] 丰富的错误类型

## 错误类型

| 错误名 | 错误码 | 错误描述 |
| :----: | :----: | -----:|
|RouteErrorURLCantParse|-1|url地址无法解析|
|RouteErrorURLUnknownScheme|-2|未知的scheme|
|RouteErrorURLUnknownHost|-3| 未知的host|
|RouteErrorPlistRuleNotFound| -4|无法找到跳转规则的plist文件|
|RouteErrorPlistMappingNotFound |-5| 无法找到页面规则的plist文件|
|RouteErrorPlistCantConvertDictionary|-6| plist文件无法转化为字典|
|RouteErrorPlistRuleNotContainTarget|-7| 跳转规则中不包含跳转目标|
|RouteErrorPlistMappingNotContainTarget|-8|页面规则中不包含跳转目标|
|RouteErrorArgumentNotFound| -9|url中无法找到对应参数|
|RouteErrorArgumentNotFoundInRule|-10| 跳转规则映射中无法找到对应参数|
|RouteErrorArgumentDependentNotFound|-11|url中无法找到参数的依赖参数|
|RouteErrorArgumentCantConvertModel|-12|url中参数无法组成跳转所需对象|



