//
//  BeareadRouterTests.m
//  BeareadRouterTests
//
//  Created by Archy on 2017/7/17.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URLRoute.h"

@interface BeareadRouterTests : XCTestCase

@end

@implementation BeareadRouterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRouteResult {
    URLRoute *route = [URLRoute routeWithUrlString:@"bearead://bookdetail?bid=123"];
    XCTAssertNil(route.routeError);
    route = [URLRoute routeWithTarget:@"bookdetail" args:@{@"bid":@"123"}];
    XCTAssertNil(route.routeError);
    [route genRouteWithUrlString:@"bearead://bookdetail?bid=123"];
    XCTAssertNil(route.routeError);
    [route genRouteWithTarget:@"bookdetail" args:@{@"bid":@"123"}];
    XCTAssertNil(route.routeError);
}

- (void)testUrlInit {
    URLRoute *route = [URLRoute routeWithUrlString:@"bearead://bookdetail?bid=123"];
    NSLog(@"\nTestURlInit%@",route);
}

- (void)testTargetInit {
    URLRoute *route = [URLRoute routeWithTarget:@"bookdetail" args:@{@"bid":@"123"}];
    NSLog(@"\nTestTargetInit%@",route);
}

- (void)testUrlGeneration {
    URLRoute *route = [URLRoute shareRoute];
    [route genRouteWithUrlString:@"bearead://bookdetail?bid=123"];
    NSLog(@"\nTestUrlGeneration%@",route);
}

- (void)testTargetGeneration {
    URLRoute *route = [URLRoute shareRoute];
    [route genRouteWithTarget:@"bookdetail" args:@{@"bid":@"123"}];
    NSLog(@"\nTestTargetGeneration%@",route);
}

- (void)testTimeCost {
    [self measureBlock:^{
        [URLRoute routeWithUrlString:@"bearead://bookdetail?bid=123"];
    }];
}

@end
