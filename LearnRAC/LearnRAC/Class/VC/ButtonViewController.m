//
//  ButtonViewController.m
//  LearnRAC
//
//  Created by lufeng lin on 2017/9/27.
//  Copyright © 2017年 lufeng.lin. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *sv1;
@property (nonatomic, strong) UIView *sv2;
@property (nonatomic, strong) UIView *sv3;
@end

@implementation ButtonViewController

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
- (void)test{
    WS(ws)
    [self.view addSubview:self.sv1];
    [self.sv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    [self.sv1 addSubview:self.sv2];
    [self.sv1 addSubview:self.sv3];
    [self.sv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.sv1.mas_centerY);
        make.left.equalTo(ws.sv1).with.offset(10);
        make.right.equalTo(ws.sv3.mas_left).with.offset(-10);
        make.height.mas_equalTo(@150);
        make.width.equalTo(ws.sv2);
    }];
    
    [self.sv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.sv1.mas_centerY);
        make.left.equalTo(ws.sv2.mas_right).with.offset(10);
        make.right.equalTo(ws.sv1).with.offset(-10);
        make.height.mas_equalTo(@150);
        make.width.equalTo(ws.sv2);
    }];
}

- (UIView *)sv1{
    if (_sv1 == nil) {
        _sv1 = [UIView new];
        _sv1.backgroundColor = [UIColor redColor];
    }
    return _sv1;
}

- (UIView *)sv2{
    if (_sv2 == nil) {
        _sv2 = [UIView new];
        _sv2.backgroundColor = [UIColor greenColor];
    }
    return _sv2;
}

- (UIView *)sv3{
    if (_sv3 == nil) {
        _sv3 = [UIView new];
        _sv3.backgroundColor = [UIColor blueColor];
    }
    return _sv3;
}

- (void)test2{
    WS(ws)
    UIView *sv = ws.view;
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor whiteColor];
    [sv addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).with.insets(UIEdgeInsetsMake(5,5,5,5));
    }];
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    int count = 10;
    UIView *lastView = nil;
    for ( int i = 1 ; i <= count ; ++i )
    {
        UIView *subv = [UIView new];
        [container addSubview:subv];
        subv.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                          saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                               alpha:1];
        
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@(20*i));
            
            if ( lastView )
            {
                make.top.mas_equalTo(lastView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(container.mas_top);
            }
        }];
        
        lastView = subv;
    }
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
}

@end
