//
//  TargetViewController.m
//  LearnRAC
//
//  Created by lufeng lin on 2017/9/27.
//  Copyright © 2017年 lufeng.lin. All rights reserved.
//

#import "TargetViewController.h"

@interface TargetViewController ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation TargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initInterface{
    WS(ws)
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (UIButton *)button{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor blueColor];
        [_button setTitle:@"log" forState:UIControlStateNormal];
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"hahaha");
        }];
    }
    return _button;
}


@end
