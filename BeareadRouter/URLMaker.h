//
//  URLMaker.h
//  BeareadRouter
//
//  Created by Archy on 2017/8/11.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLMaker : NSObject

@property (nonatomic, copy) NSString *url;

/**
 URL的Scheme（scheme）
 */
- (URLMaker *(^)(NSString *))scheme;

/**
 URL的Scheme（host）
 */
- (URLMaker *(^)(NSString *))host;

/**
 URL的Scheme（path）
 */
- (URLMaker *(^)(NSString *))path;

/**
 URL的Query（key,value）
 */
- (URLMaker *(^)(NSString *,NSString *))query;

@end

@interface NSString (URLMaker)

+ (NSString *)makeUrl:(void (^)(URLMaker *maker))maker;

@end


