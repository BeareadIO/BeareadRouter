# BeareadRouter
BeareadRouter 是白熊阅读针对Url链接跳转的一套路由方案
## 导入
BeareadRouter 主要由UrlRoute.h .m 以及规则对应plist文件和页面对应plist文件组成。

```c
#import "UrlRoute.h"
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
}
```


