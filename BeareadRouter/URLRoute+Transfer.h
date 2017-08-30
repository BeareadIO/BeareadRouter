//
//  URLRoute+Transfer.h
//  BeareadRouter
//
//  Created by Archy on 2017/8/30.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLRoute.h"

typedef NS_ENUM(NSUInteger, URLRouteTransferError) {
    URLRouteTransferErrorPropertyNotExist,
};

typedef void (^MountResult)(UIViewController *, NSError*);

@interface URLRoute (Transfer)

- (void)mountResult:(MountResult)result;

@end
