//
//  LogicManager.m
//  BeareadRouter
//
//  Created by Archy on 2017/8/29.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "LogicManager.h"

static LogicManager *manager = nil;

@interface LogicManager ()

@property (nonatomic, strong) NSMutableDictionary *logicMap;

@end

@implementation LogicManager

+ (LogicManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LogicManager alloc] init];
        manager.logicMap = @{}.mutableCopy;
    });
    return manager;
}

- (void)registerAction:(LogicAction)action name:(NSString *)name {
    
}

- (NSDictionary *)map {
    return self.logicMap.copy;
}


@end
