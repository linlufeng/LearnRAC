//
//  ViewController.m
//  LearnRAC
//
//  Created by lufeng lin on 2017/9/26.
//  Copyright © 2017年 lufeng.lin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contents;

@property (nonatomic, strong) UITextField *tf1;
@property (nonatomic, strong) UITextField *tf2;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UILabel *lb;
@property (nonatomic, strong) NSString *name;
@end

@implementation ViewController

- (id)init{
    self = [super init];
    if (self) {
        self.contents = [NSMutableArray arrayWithObject:@[@"Target", @"Delegate", @"Notification", @"KVO", @"Timer", @"Net"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initInterface2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initInterface{
    WS(ws)
    [self.view addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    // UITableViewCell 点击
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple * x) {
        NSLog(@"点击了");
        NSLog(@"%@,%@",x.first,x.second);
    }];
    // 这里是个坑,必须将代理最后设置,否则信号是无法订阅到的
    self.contentTableView.delegate = self;
}

#pragma mark - UITableViewDataSource


- (void)initInterface2{
    WS(ws)
    [self.view addSubview:self.tf1];
    [self.view addSubview:self.tf2];
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.lb];
    
    [self.tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@110);
        make.top.equalTo(@110);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    [self.tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@110);
        make.top.equalTo(@210);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@110);
        make.top.equalTo(@270);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
//    [self signal1];
//    [self signal2];
//    [self signal3];
//    [self signal4];
//    [self signal5];
//    [self signal6];
//    [self signal7];
//    [self signal8];
//    [self signal9];
//    [self signal10];
//    [self signal11];
//    [self signal12];
//    [self signal13];
//    [self signal14];
    [self signal15];
}

- (void)signal1{
    WS(ws)
    RACSignal * nameSignal = [self.tf1 rac_textSignal];
    RACSignal * ageSignal = [self.tf2 rac_textSignal];
    //先组合再聚合
    //reduce后的参数需要自己添加,添加以前方传来的信号的数据为准
    //return类似映射,可以对数据进行处理再发送给订阅者
    RACSignal * reduceSignal = [RACSignal combineLatest:@[nameSignal,ageSignal] reduce:^id(NSString * name,NSString * age){
        return [NSString stringWithFormat:@"姓名:%@,年龄:%@",name,age];
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        ws.lb.text = x;
        //        NSLog(@"%@",x);
    }];
}

// 过滤
- (void)signal2{
    RACSignal * nameSignal = [self.tf1 rac_textSignal];
    [[nameSignal filter:^BOOL(NSString * value) {
        return value.length>3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// 即时搜索的优化
- (void)signal3{
    RACSignal * nameSignal = [self.tf1 rac_textSignal];
    //这段代码的意思是若0.3秒内无新信号(tf无输入),并且输入框内不为空那么将会执行,这对服务器的压力减少有巨大帮助同时提高了用户体验
    [[[[[[nameSignal throttle:0.3]distinctUntilChanged]ignore:@"1"] map:^id(id value) {
        //这里使用的是信号中的信号这个概念
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //  network request
            //  这里可将请求到的信息发送出去
            [subscriber sendNext:value];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                //  cancel request
                // 这里可以将取消请求写在这里,若输入框有新输入信息那么将会发送一个新的请求,原来那个没执行完的请求将会执行这个取消请求的代码
            }];
        }];
    }]switchToLatest] subscribeNext:^(id x) {
        //这里获取信息
        NSLog(@"%@", x);
    }];
}

- (void)signal4{
    // 获取前n个信号
    RACSignal * nameSignal = [self.tf1 rac_textSignal];
    RACSignal * ageSignal = [self.tf2 rac_textSignal];
    [[nameSignal take:3] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 获取后n个信号
    [[ageSignal takeLast:3] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

// map返回的是对象
- (void)signal5{
    WS(ws)
    RACSignal * nameSignal = [self.tf1 rac_textSignal];
    [[nameSignal map:^id(id value) {
        return [NSString stringWithFormat:@"name is %@", value];
    }] subscribeNext:^(id x) {
        ws.lb.text = x;
    }];
}

// FlatternMap 返回的是一个信号
- (void)signal6{
    WS(ws)
    RACSignal * nameSignal = [self.tf1 rac_textSignal];
    [[nameSignal flattenMap:^RACStream *(id value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"年龄是:%@",value]];
    }] subscribeNext:^(id x) {
        ws.lb.text = x;
    }];
}

- (void)signal7{
    [[_tf1 rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"signal7-%@", x);
    }];
}

- (void)signal8{
    [[_tf1 rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
        NSLog(@"signal8-%@", [(UITextField *)x text]);
    }];
}

- (void)signal9{
    [[[_tf1 rac_textSignal] filter:^BOOL(NSString *value) {
        return value.length>3;
    }]subscribeNext:^(id x) {
        NSLog(@"signal9-%@", x);
    }];
}

- (void)signal10{
    [[_btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)signal11{
    [[_tf1 rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"signal9-%@", x);
        self.name = x;
    }];
    
    [RACObserve(self, name) subscribeNext:^(id x) {
        NSLog(@"name=%@", x);
    }];
}

- (void)signal12{
    RAC(_lb,text) = _tf1.rac_textSignal;
}

// 数组遍历
- (void)signal13{
    NSArray *arr = @[@"1", @"2", @"3"];
    [arr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"--%@", x);
    }];
}

// 监听 Notification 通知事件
- (void)signal14{
    [_tf1.rac_textSignal subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hahahah" object:nil];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"hahahah" object:nil] subscribeNext:^(id x) {
        NSLog(@"收到通知%@", x);
    }];
}

// 代替代理
- (void)signal15{
    [_tf1.rac_textSignal subscribeNext:^(id x) {
        [self testSignal15];
    }];
    [[self rac_signalForSelector:@selector(testSignal15)] subscribeNext:^(id x) {
        NSLog(@"testSignal15 被调用 收到相关订阅消息");
    }];
}

- (void)testSignal15{
    
}

- (UITextField *)tf1{
    if (_tf1 == nil) {
        _tf1 = [[UITextField alloc] init];
        _tf1.borderStyle = UITextBorderStyleRoundedRect;
        _tf1.tintColor = [UIColor redColor];
        _tf1.placeholder = @"tf1";
    }
    return _tf1;
}

- (UITextField *)tf2{
    if (_tf2 == nil) {
        _tf2 = [[UITextField alloc] init];
        _tf2.borderStyle = UITextBorderStyleRoundedRect;
        _tf2.tintColor = [UIColor redColor];
        _tf2.placeholder = @"tf2";  
    }
    return _tf2;
}

- (UIButton *)btn1{
    if (_btn1 == nil) {
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn1 setBackgroundColor:[UIColor redColor]];
        [_btn1 setTitle:@"hhh" forState:UIControlStateNormal];
    }
    return _btn1;;
}

- (UILabel *)lb{
    if (_lb == nil) {
        _lb = [[UILabel alloc] init];
        _lb.textColor = [UIColor redColor];
        _lb.textAlignment = NSTextAlignmentCenter;
        _lb.backgroundColor = [UIColor blueColor];
    }
    return _lb;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] init];
    }
    return _contentTableView;
}

@end
