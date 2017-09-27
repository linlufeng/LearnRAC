//
//  ViewController.m
//  LearnRAC
//
//  Created by lufeng lin on 2017/9/26.
//  Copyright © 2017年 lufeng.lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contents;

@end

@implementation ViewController

- (id)init{
    self = [super init];
    if (self) {
        self.contents = [NSMutableArray arrayWithObject:@[@"Button", @"TextField", @"Gesture"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initInterface];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adTextField{
    
}

- (void)initInterface{
    WS(ws)
    [self.view addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple * x) {
        
        NSLog(@"点击了");
        
        NSLog(@"%@,%@",x.first,x.second);
        
    }];
    // 这里是个坑,必须将代理最后设置,否则信号是无法订阅到的
    self.contentTableView.delegate = self;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] init];
    }
    return _contentTableView;
}

@end
