//
//  URLMaker.m
//  BeareadRouter
//
//  Created by Archy on 2017/8/11.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "URLMaker.h"

@interface URLMaker ()

@property (nonatomic, copy) NSString *strScheme;
@property (nonatomic, copy) NSString *strHost;
@property (nonatomic, copy) NSString *strPath;
@property (nonatomic, copy) NSString *strQuery;

@end

@implementation URLMaker

- (URLMaker *(^)(NSString *))scheme {
    return ^(NSString *scheme){
        self.strScheme = [NSString stringWithFormat:@"%@://",scheme];
        return self;
    };
}

- (URLMaker *(^)(NSString *))host {
    return ^(NSString *host) {
        self.strHost = [NSString stringWithFormat:@"%@/",host];
        return self;
    };
}

- (URLMaker *(^)(NSString *))path {
    return ^(NSString *path) {
        if (self.strPath.length > 0) {
            self.strPath = [self.strPath stringByAppendingFormat:@"/%@",path];
        } else {
            self.strPath = path;
        }
        return self;
    };
}

- (URLMaker *(^)(NSString *,NSString *))query{
    return ^(NSString *key,NSString *value){
        if (self.strQuery.length > 0) {
            self.strQuery = [self.strQuery stringByAppendingFormat:@"&%@=%@",key,value];
        } else {
            self.strQuery = [NSString stringWithFormat:@"?%@=%@",key,value];
        }
        return self;
    };
}

- (NSString *)url {
    NSMutableString *result = [NSMutableString string];
    if (self.strScheme.length > 0) {
        [result appendString:self.strScheme];
    } else {
        [result appendString:@"https://"];
    }
    if (self.strHost.length > 0) {
        [result appendString:self.strHost];
    }
    if (self.strPath) {
        [result appendString:self.strPath];
    }
    if (self.strQuery) {
        [result appendString:self.strQuery];
    }
    return result;
}

@end

@implementation NSString (URLMaker)

+ (NSString *)makeUrl:(void (^)(URLMaker *))maker {
    URLMaker *urlMaker = [[URLMaker alloc] init];
    maker(urlMaker);
    return urlMaker.url;
}
@end
