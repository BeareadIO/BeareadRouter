//
//  BookViewController.m
//  BeareadRouter
//
//  Created by Archy on 2017/8/30.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "BookViewController.h"

@interface BookViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Book Detail";
    self.lblInfo.text = [NSString stringWithFormat:@"%@\n%@",self.fid,self.subscribeItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
