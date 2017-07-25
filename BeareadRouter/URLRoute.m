//
//  URLRoute.m
//  bearead
//
//  Created by Archy on 2017/7/20.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "URLRoute.h"
#import "YYModel.h"

RouteErrorDomain const RouteParseErrorDomain = @"com.urlroute.bearead";

static URLRoute *_instance;

@interface URLRoute ()

@property (nonatomic, strong) NSURL       *routeUrl;
@property (nonatomic, strong) NSError     *routeError;
@property (nonatomic, copy) NSString      *routeController;
@property (nonatomic, copy) NSString      *routeStoryboard;
@property (nonatomic, copy) NSDictionary  *routeArguments;

@property (nonatomic, copy) NSString      *routeTarget;
@property (nonatomic, copy) NSDictionary  *routeRule;
@property (nonatomic, copy) NSDictionary  *routeMapping;
@property (nonatomic, copy) NSDictionary  *routeRuleDic;
@property (nonatomic, copy) NSDictionary  *routeMapDic;

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
    [self resetRoute];
    [[[[[[self config:^BOOL{
        return [self configPlist];
    }] config:^BOOL{
        return [self configURLWithUrlString:urlString];
    }] config:^BOOL{
        return [self configTarget];
    }] config:^BOOL{
        return [self configRouteDic];
    }] config:^BOOL{
        return [self configViewController];
    }] config:^BOOL{
        return [self configArguments];
    }];
    return self;
}

- (void)resetRoute {
    self.routeArguments = @{}.mutableCopy;
    self.routeError = nil;
    self.routeController = nil;
    self.routeUrl = nil;
}

- (URLRoute *)config:(BOOL (^)(void))doConfig {
    BOOL result = doConfig();
    if (result) {
        return self;
    } else {
        return nil;
    }
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
        self.routeRuleDic = [self.routeRule.allValues objectAtIndex:index];
    } else {
        NSString *des = [NSString stringWithFormat:@"Plist Rule Not Contain Domain (%@)",self.routeTarget];
        NSError *containError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorPlistRuleNotContainTarget userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = containError;
    }
    return canConfig;
}

- (BOOL)configViewController {
    BOOL canConfig = NO;
    NSDictionary *mapDic = [self.routeMapping objectForKey:self.routeTarget];
    if (mapDic) {
        canConfig = YES;
        self.routeMapDic = mapDic;
        self.routeController = mapDic[@"ViewController"];
        self.routeStoryboard = mapDic[@"StoryboardName"];
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
    NSDictionary *mapDic = [self.routeRuleDic objectForKey:@"映射"];
    NSMutableArray *mappingKeys = [NSMutableArray array];
    NSMutableArray *mappingValues = [NSMutableArray array];
    for (NSString *key in mapDic.allKeys) {
        if ([mapDic[key] isKindOfClass:[NSString class]]) {
            [mappingKeys addObject:key];
            [mappingValues addObject:mapDic[key]];
        } else if ([mapDic[key] isKindOfClass:[NSDictionary class]]) {
            [mappingKeys addObjectsFromArray:[mapDic[key] allKeys]];
            [mappingValues addObjectsFromArray:[mapDic[key] allValues]];
        }
    }
    for (NSString *param in [self.routeUrl.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        if ([mappingValues containsObject:[elts firstObject]]) {
            NSString *key = [mappingKeys objectAtIndex:[mappingValues indexOfObject:[elts firstObject]]];
            [queryDic setObject:[elts lastObject] forKey:key];
        } 
    }
    for (NSString *key in mapDic.allKeys) {
        canConfig = [self configSingleArgumentWithName:key withQuery:queryDic mapValue:mapDic[key]];
        if (canConfig) {
            continue;
        } else {
            break;
        }
    }
    return canConfig;
}

- (BOOL)configSingleArgumentWithName:(NSString *)name withQuery:(NSDictionary *)query mapValue:(id)mapValue {
    BOOL canConfig = YES;
    NSDictionary *ruleArgDic = [self dicInMappingForName:name];
    NSMutableDictionary *arguments = self.routeArguments.mutableCopy;
    if ([mapValue isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        canConfig = [self checkArgumentExist:name query:query];
        for (NSString *key in [mapValue allKeys]) {
            NSDictionary *keyDic = [self dicInMappingForName:key];
            canConfig = [self checkArgumentExist:key query:query];
            if (canConfig) {
                canConfig = [self checkDependentWithDic:keyDic query:query name:key];
            }
            if (canConfig) {
                self.routeError = nil;
                if (query[key]) {
                    [dictionary setObject:query[key] forKey:key];
                }
            } else {
                break;
            }
        }
        if (canConfig) {
            NSString *className = [self.routeMapDic objectForKey:name];
            Class itemClass = NSClassFromString(className);
            NSObject *item = [itemClass yy_modelWithDictionary:dictionary];
            if (item) {
                if (dictionary.allKeys.count > 0) {
                    [arguments setObject:item forKey:name];
                }
            } else {
                canConfig = NO;
                NSString *des = [NSString stringWithFormat:@"Arguments Can't Convert To item Of Class (%@)",className];
                NSError *convertError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentCantConvertModel userInfo:@{NSLocalizedDescriptionKey:des}];
                self.routeError = convertError;
                return canConfig;
            }
            self.routeArguments = arguments;
        } else {
            BOOL isOption = [[[self dicInMappingForName:name] objectForKey:@"option"] boolValue];
            if (isOption) {
                self.routeError = nil;
                canConfig = YES;
            } 
        }
    } else if ([mapValue isKindOfClass:[NSString class]]) {
        canConfig = [self checkArgumentExist:name query:query];
        if (canConfig) {
            canConfig = [self checkDependentWithDic:ruleArgDic query:query name:name];
        }
        if (canConfig) {
            if (query[name]) {
                [arguments setObject:query[name] forKey:name];
                self.routeArguments = arguments;
            }
        }
    }
    return canConfig;
}

- (BOOL)checkArgumentExist:(NSString *)name query:(NSDictionary *)query {
    BOOL canConfig = YES;
    NSDictionary *ruleArgDic = [self dicInMappingForName:name];
    BOOL isOption = [ruleArgDic[@"option"] boolValue];
    BOOL isContain = [query.allKeys containsObject:name];
    if (!isOption && !isContain) {
        canConfig = NO;
        NSString *des = [NSString stringWithFormat:@"Argument (%@) Not Found",name];
        NSError *argError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentNotFound userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = argError;
        return canConfig;
    }
    if (!isContain) {
        return canConfig;
    }
    return canConfig;
}

- (BOOL)checkDependentWithDic:(NSDictionary *)dic query:(NSDictionary *)query name:(NSString *)name {
    BOOL canConfig = YES;
    if (!dic) {
        canConfig = NO;
        NSString *des =  [NSString stringWithFormat:@"Can't Find Argument(%@) In 参数",name];
        NSError *mapError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentNotFoundInRule userInfo:@{NSLocalizedDescriptionKey:des}];
        self.routeError = mapError;
        return canConfig;
    }
    for (NSString *dArg in dic[@"依赖参数"]) {
        if ([query.allKeys containsObject:dArg]) {
            continue;
        } else {
            canConfig = NO;
            NSString *des = [NSString stringWithFormat:@"Argument (%@) Can't Find Dependent Argument (%@)",dic[@"name"],dArg];
            NSError *argError = [NSError errorWithDomain:RouteParseErrorDomain code:RouteErrorArgumentDependentNotFound userInfo:@{NSLocalizedDescriptionKey:des}];
            self.routeError = argError;
            break;
        }
    }
    return YES;
}

- (NSDictionary *)dicInMappingForName:(NSString *)name {
    NSArray *arguments = [self.routeRuleDic[@"参数"] allValues];
    NSUInteger index = [[arguments valueForKey:@"name"] indexOfObject:name];
    if (index == NSNotFound) {
        return nil;
    } else {
        return arguments[index];
    }
}


- (NSString *)description {
    NSMutableString *des = [NSMutableString stringWithString:@"\n------Bearead Url Route------\n"];
    if (self.routeStoryboard) {
        [des appendFormat:@"Storyboard:%@\n",self.routeStoryboard];
    }
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
