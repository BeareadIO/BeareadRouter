//
//  URLRoute.m
//  bearead
//
//  Created by Archy on 2017/7/20.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "URLRoute.h"

RouteErrorDomain const RouteParseErrorDomain = @"com.urlroute.bearead";

static URLRoute *_instance;

@interface URLRoute ()

@property (nonatomic, strong) NSURL       *routeUrl;
@property (nonatomic, strong) NSError     *routeError;
@property (nonatomic, copy) NSString      *routeController;
@property (nonatomic, copy) NSDictionary  *routeArguments;

@property (nonatomic, copy) NSString      *routeTarget;
@property (nonatomic, copy) NSDictionary  *routeRule;
@property (nonatomic, copy) NSDictionary  *routeMapping;
@property (nonatomic, copy) NSDictionary  *routeDic;


@end

@implementation URLRoute

+ (instancetype)shareRoute {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[URLRoute alloc] init];
    });
    return _instance;
}

- (instancetype)genRouteWithUrlString:(NSString *)urlString {
    BOOL canContinueConfig = [self configPlist];
    
    if (canContinueConfig) {
        canContinueConfig = [self configURLWithUrlString:urlString];
    }
    
    if (canContinueConfig) {
        canContinueConfig = [self configTarget];
    }
    
    if (canContinueConfig) {
        canContinueConfig = [self configRouteDic];
    }
    
    if (canContinueConfig) {
        canContinueConfig = [self configViewController];
    }
    if (canContinueConfig) {
        self.routeArguments = [NSMutableDictionary dictionary];
        [self configArguments];
    }
    return self;
}

+ (instancetype)routeWithUrlString:(NSString *)urlString {
    return [[URLRoute shareRoute] genRouteWithUrlString:urlString];
}

- (instancetype)genRouteWithTarget:(NSString *)target args:(NSDictionary *)args {
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%@://",URLRouteScheme];
    [string appendString:target];
    if (args) {
        [string appendString:@"?"];
        for (NSString *key in args.allKeys) {
            [string appendFormat:@"%@=%@&",key,args[key]];
        }
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    return [self genRouteWithUrlString:string];
}

+ (instancetype)routeWithTarget:(NSString *)target args:(NSDictionary *)args {
    return [[URLRoute shareRoute] genRouteWithTarget:target args:args];
}

#pragma mark - Private

- (BOOL)configPlist {
    if (self.routeRule && self.routeMapping) {
        return YES;
    }
    BOOL canConfig = NO;
    NSString *rulePath = [[NSBundle mainBundle] pathForResource:URLRouteRulePlist ofType:@"plist"];
    NSString *mappingPath = [[NSBundle mainBundle] pathForResource:URLRouteMappingPlist ofType:@"plist"];
    if (rulePath && mappingPath) {
        NSDictionary *ruleDic = [[NSDictionary alloc] initWithContentsOfFile:rulePath];
        NSDictionary *mappingDic = [[NSDictionary alloc] initWithContentsOfFile:mappingPath];
        if (ruleDic && mappingDic) {
            canConfig = YES;
            self.routeRule = ruleDic;
            self.routeMapping = mappingDic;
        } else {
            NSString *des = @"Plist Can't Convert To Dictionary";
            NSError *convertError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorPlistCantConvertDictionary userInfo:@{NSLocalizedDescriptionKey:des}];
            self.routeError = convertError;
        }
    } else if (!rulePath) {
        NSString *des = [NSString stringWithFormat:@"Plist (%@) Not Found",URLRouteRulePlist];
        NSError *plistError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorPlistRuleNotFound userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = plistError;
    } else if (!mappingPath) {
        NSString *des = [NSString stringWithFormat:@"Plist (%@) Not Found",URLRouteMappingPlist];
        NSError *plistError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorPlistMappingNotFound userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = plistError;
    }
    return canConfig;
}

- (BOOL)configURLWithUrlString:(NSString *)urlString {
    BOOL canConfig = NO;
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        self.routeUrl = url;
        BOOL knownScheme = [url.scheme isEqualToString:URLRouteScheme] || [url.scheme isEqualToString:@"https"];
        if (knownScheme){
            canConfig = YES;
        }
        else {
            NSString *des = [NSString stringWithFormat:@"Unknown Url Scheme:%@",url.scheme];
            NSError *schemeError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorURLCantParse userInfo:@{NSLocalizedDescriptionKey:des}];
            self.routeError = schemeError;
        }
    } else {
        NSString *des = @"Url String Can't Parse";
        NSError *urlError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorURLCantParse userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = urlError;
    }
    return canConfig;
}

- (BOOL)configTarget {
    BOOL canConfig = NO;
    if ([self.routeUrl.scheme isEqualToString:URLRouteScheme]) {
        if ([self.routeUrl.host isEqualToString:URLRouteHost]) {
            canConfig = YES;
            self.routeTarget = self.routeUrl.lastPathComponent;
        } else {
            canConfig = YES;
            self.routeTarget = self.routeUrl.host;
        }
    } else {
        if ([self.routeUrl.scheme isEqualToString:@"https"]) {
            if ([self.routeUrl.host isEqualToString:URLRouteHost]) {
                canConfig = YES;
                self.routeTarget = self.routeUrl.lastPathComponent;
            } else {
                NSString *des = [NSString stringWithFormat:@"Unknown Url Host:%@",self.routeUrl.host];
                NSError *hostError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorURLUnknownHost userInfo:@{NSLocalizedDescriptionKey:des}];
                self.routeError = hostError;
            }
        }
    }
    return canConfig;
}

- (BOOL)configRouteDic {
    BOOL canConfig = NO;
    NSArray *domainArr = [self.routeRule.allValues valueForKey:@"域名"];
    if (domainArr.count > 0 && [domainArr containsObject:self.routeTarget]) {
        canConfig = YES;
        NSUInteger index = [domainArr indexOfObject:self.routeTarget];
        self.routeDic = [self.routeRule.allValues objectAtIndex:index];
    } else {
        NSString *des = [NSString stringWithFormat:@"Plist Rule Not Contain Domain (%@)",self.routeTarget];
        NSError *containError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorPlistRuleNotContainTarget userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = containError;
    }
    return canConfig;
}

- (BOOL)configViewController {
    BOOL canConfig = NO;
    NSString *viewController = [self.routeMapping objectForKey:self.routeTarget];
    if (viewController) {
        canConfig = YES;
        self.routeController = viewController;
    } else {
        NSString *des = [NSString stringWithFormat:@"Plist Mapping Not Contain Domain (%@)",self.routeTarget];
        NSError *containError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorPlistMappingNotContainTarget userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = containError;
    }
    return canConfig;
}

- (BOOL)configArguments {
    BOOL canConfig = YES;
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    if (!self.routeUrl.query) {
        return canConfig;
    }
    NSDictionary *mapDic = [self.routeDic objectForKey:@"映射"];
    for (NSString *param in [self.routeUrl.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [queryDic setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    for (NSDictionary *arg in [[self.routeDic objectForKey:@"参数"] allValues]) {
        canConfig = [self configSingleArgument:arg withMapping:mapDic withQuery:queryDic isOptional:[arg[@"option"] boolValue]];
        if (canConfig) {
            continue;
        } else {
            break;
        }
    }
    return canConfig;
}

- (BOOL)configSingleArgument:(NSDictionary *)arg withMapping:(NSDictionary *)mapping withQuery:(NSDictionary *)query isOptional:(BOOL)optional {
    NSMutableDictionary *arguments = self.routeArguments.mutableCopy;
    BOOL canConfig = YES;
    NSString *argString;
    if ([mapping.allKeys containsObject:arg[@"name"]]) {
        argString = [mapping.allValues objectAtIndex:[mapping.allKeys indexOfObject:arg[@"name"]]];
    } else {
        canConfig = NO;
        NSString *des =  [NSString stringWithFormat:@"Can't Find Argument(%@) In Mapping(映射)",arg[@"name"]];
        NSError *mapError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentNotFoundInMapping userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = mapError;
        return canConfig;
    }
    if (query[argString]) {
        for (NSString *dArg in arg[@"依赖参数"]) {
            if ([query.allKeys containsObject:mapping[dArg]]) {
                continue;
            } else {
                canConfig = NO;
                NSString *des = [NSString stringWithFormat:@"Argument (%@) Can't Find Dependent Argument (%@) eg:(%@=xxx)",argString,dArg,mapping[dArg]];
                NSError *argError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentDependentNotFound userInfo:@{NSLocalizedDescriptionKey:des}];
                self.routeError = argError;
                break;
            }
        }
        if (canConfig) {
            [arguments setObject:query[argString] forKey:arg[@"name"]];
            self.routeArguments = arguments;
        } else {
            return canConfig;
        }
    } else {
        if (!optional) {
            canConfig = NO;
            NSString *des = [NSString stringWithFormat:@"Argument (%@) Not Found",arg[@"name"]];
            NSError *argError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentNotFound userInfo:@{NSLocalizedDescriptionKey:des}];
            self.routeError = argError;
            return canConfig;
        }
    }
    return canConfig;
}


- (NSString *)description {
    NSMutableString *des = [NSMutableString stringWithString:@"\n------Bearead Url Route------\n"];
    [des appendFormat:@"ViewController:%@\n",self.routeController];
    if (self.routeArguments) {
        [des appendFormat:@"Arguments:%@\n",self.routeArguments];
    }
    [des appendString:@"-----------------------------"];
    return des;
}

@end

#undef URLRouteScheme
#undef URLRouteRulePlist
#undef URLRouteMappingPlist
