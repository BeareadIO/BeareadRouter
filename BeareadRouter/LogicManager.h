//
//  LogicManager.h
//  BeareadRouter
//
//  Created by Archy on 2017/8/29.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LogicAction)(void);

typedef NS_ENUM(NSUInteger, LogicActionStatus) {
    LogicActionStatusWaiting,
    LogicActionStatusFinish,
};

@interface LogicManager : NSObject

@property (nonatomic, copy, readonly) NSDictionary *map;

+ (LogicManager *)sharedManager;

- (void)registerAction:(LogicAction)action name:(NSString *)name;

@end
