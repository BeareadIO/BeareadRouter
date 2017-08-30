//
//  BookViewController.h
//  BeareadRouter
//
//  Created by Archy on 2017/8/30.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubscribeItem.h"

@interface BookViewController : UIViewController

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) SubscribeItem *subscribeItem;

@end
