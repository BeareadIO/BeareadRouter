//
//  URLRoute+Transfer.m
//  BeareadRouter
//
//  Created by Archy on 2017/8/30.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "URLRoute+Transfer.h"

@implementation URLRoute (Transfer)

- (void)mountResult:(MountResult)result {
    NSDictionary *params = self.routeArguments;
    NSError *error = nil;
    Class vcClass = NSClassFromString(self.routeController);
    id to;
    if (self.routeStoryboard.length > 0) {
        to = [[UIStoryboard storyboardWithName:self.routeStoryboard bundle:nil] instantiateViewControllerWithIdentifier:self.routeController];
    } else {
        to = [[vcClass alloc] init];
    }
    for (NSString *argument in params) {
        if (![to respondsToSelector:NSSelectorFromString(argument)]) {
            NSString *des = [NSString stringWithFormat:@"%@ Not exist property (%@)", NSStringFromClass([to class]), argument];
            error = [NSError errorWithDomain:RouteParseErrorDomain code:URLRouteTransferErrorPropertyNotExist userInfo:@{NSLocalizedDescriptionKey: des}];
            break;
        }
        else {
            [to setValue:params[argument] forKey:argument];
        }
        
    }
    
    result(error ? nil : to, error);
}


@end
