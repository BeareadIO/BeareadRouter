//
//  ViewController.m
//  BeareadRouter
//
//  Created by Archy on 2017/7/17.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "ViewController.h"
#import "URLRoute.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    URLRoute *route = [URLRoute routeWithUrlString:@"bearead://www.bearead.com/bookdetail"];
    if (route.routeError) {
        NSLog(@"%@",route.routeError);
    } else {
        NSLog(@"%@",route);
    }

}


@end
