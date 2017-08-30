//
//  ViewController.m
//  BeareadRouter
//
//  Created by Archy on 2017/7/17.
//  Copyright © 2017年 bearead. All rights reserved.
//

#import "ViewController.h"
#import "URLRoute.h"
#import "URLMaker.h"
#import "URLRoute+Transfer.h"

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textUrl;
@property (nonatomic, weak) IBOutlet UITextView *textInfo;
@property (nonatomic, strong) URLRoute *route;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *urlHeightConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *book = [NSString makeUrl:^(URLMaker *maker) {
        maker.scheme(@"bearead").host(@"www.bearead.com").path(@"bookdetail");
        maker.query(@"bid"  ,@"123");
        maker.query(@"fid"  ,@"234");
        maker.query(@"name" ,@"text");
        maker.query(@"types",@"role");
    }];
    self.textUrl.text = book;
    self.route = [URLRoute routeWithUrlString:book];
    
    if (self.route.routeError) {
        self.textInfo.text = self.route.routeError.description;
    } else {
        self.textInfo.text = self.route.description;
    }
}

- (IBAction)clickAction:(id)sender {
    [self.route mountResult:^(UIViewController *vc, NSError *error) {
        if (error) {
            NSLog(@"\n%@",error.description);
        }
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.urlHeightConstraint.constant = textView.contentSize.height;
    [self changeInfoWithText:textView.text];
}

- (void)changeInfoWithText:(NSString *)text {
    self.route = [URLRoute routeWithUrlString:text];
    if (self.route.routeError) {
        self.textInfo.text = self.route.routeError.description;
    } else {
        self.textInfo.text = self.route.description;
    }
}
@end
