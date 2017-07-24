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
    URLRoute *route = [URLRoute routeWithUrlString:@"bearead://www.bearead.com/bookdetai?fid=123"];
    [route genRouteWithUrlString:@"bearead://bookdetail?bid=234"];
    [route genRouteWithTarget:@"bookdetail" args:@{@"bid":@"456",@"test":@"444",@"show":@"1"}];
    if (route.routeError) {
        NSLog(@"%@",route.routeError);
    } else {
        NSLog(@"%@",route);
    }

}


@end
