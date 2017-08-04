//
//  URLRoute.h
//  bearead
//
//  Created by Archy on 2017/7/20.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URLRouteScheme              @"bearead"
#define URLRouteHost                @"www.bearead.com"
#define URLRouteRulePlist           @"Route"
#define URLRouteMappingPlist        @"Mapping"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *RouteErrorDomain;

extern RouteErrorDomain const RouteParseErrorDomain;

NS_ENUM(NSInteger)
{
    RouteErrorURLCantParse                  = -1, // url地址无法解析
    RouteErrorURLUnknownScheme              = -2, // 未知的scheme
    RouteErrorURLUnknownHost                = -3, // 未知的host
    RouteErrorPlistRuleNotFound             = -4, // 无法找到跳转规则的plist文件
    RouteErrorPlistMappingNotFound          = -5, // 无法找到页面规则的plist文件
    RouteErrorPlistCantConvertDictionary    = -6, // plist文件无法转化为字典
    RouteErrorPlistRuleNotContainTarget     = -7, // 跳转规则中不包含跳转目标
    RouteErrorPlistMappingNotContainTarget  = -8, // 页面规则中不包含跳转目标
    RouteErrorArgumentNotFound              = -9, // url中无法找到对应参数
    RouteErrorArgumentNotFoundInRule        = -10,// 跳转规则映射中无法找到对应参数
    RouteErrorArgumentDependentNotFound     = -11,// url中无法找到参数的依赖参数
    RouteErrorArgumentCantConvertModel      = -12,// url中参数无法组成跳转所需对象
};

@interface URLRoute : NSObject

@property (nonatomic, strong, readonly) NSURL       *routeUrl;
@property (nonatomic, strong, readonly) NSError     *routeError;
@property (nonatomic, copy, readonly) NSString      *routeController;
@property (nonatomic, copy, readonly) NSString      *routeStoryboard;
@property (nonatomic, copy, readonly) NSDictionary  *routeArguments;

+ (instancetype)shareRoute;

- (instancetype)genRouteWithUrlString:(NSString *)urlString;
+ (instancetype)routeWithUrlString:(NSString *)urlString;

- (instancetype)genRouteWithTarget:(NSString *)target args:(NSDictionary *)args;
+ (instancetype)routeWithTarget:(NSString *)target args:(NSDictionary *)args;

@end

    
NS_ASSUME_NONNULL_END

    
    
