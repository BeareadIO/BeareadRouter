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
#define URLRouteRulePlist           @"Demo"
#define URLRouteMappingPlist        @"Mapping"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *RouteErrorDomain;

extern RouteErrorDomain const RouteParseErrorDomain;

NS_ENUM(NSInteger)
{
    RouteErrorURLCantParse                  = -1,
    RouteErrorURLUnknownScheme              = -2,
    RouteErrorURLUnknownHost                = -3,
    RouteErrorPlistRuleNotFound             = -4,
    RouteErrorPlistMappingNotFound          = -5,
    RouteErrorPlistCantConvertDictionary    = -6,
    RouteErrorPlistRuleNotContainTarget     = -7,
    RouteErrorPlistMappingNotContainTarget  = -8,
    RouteErrorArgumentNotFound              = -9,
    RouteErrorArgumentNotFoundInMapping     = -10,
    RouteErrorArgumentDependentNotFound     = -11,
};

@interface URLRoute : NSObject

@property (nonatomic, strong, readonly) NSURL       *routeUrl;
@property (nonatomic, strong, readonly) NSError     *routeError;
@property (nonatomic, copy, readonly) NSString      *routeController;
@property (nonatomic, copy, readonly) NSDictionary  *routeArguments;

+ (instancetype)shareRoute;

- (instancetype)genRouteWithUrlString:(NSString *)urlString;
+ (instancetype)routeWithUrlString:(NSString *)urlString;

- (instancetype)genRouteWithTarget:(NSString *)target args:(NSDictionary *)args;
+ (instancetype)routeWithTarget:(NSString *)target args:(NSDictionary *)args;

@end
    
NS_ASSUME_NONNULL_END
    
    
