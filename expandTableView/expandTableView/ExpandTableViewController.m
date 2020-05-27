//
//  ExpandTableViewController.m
//  Service
//
//  Created by 王同学 on 2020/5/25.
//  Copyright © 2020 Simple. All rights reserved.
//

#import "ExpandTableViewController.h"
#import "Config.h"
#import "ExpandTableView.h"

@interface ExpandTableViewController ()<ExpandTableViewDelegate>

@property (nonatomic, strong) ExpandTableView *expandTableView;

@end

@implementation ExpandTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWhite;
    [self.view addSubview:self.expandTableView];
    [self testData];
}

- (void)testData {
    // 模拟网络数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
        NSArray *data = [NSArray arrayWithContentsOfFile:path];
        [self.expandTableView initWithData:data];
    });
}

- (ExpandTableView *)expandTableView {
    if (!_expandTableView) {
        _expandTableView = [[ExpandTableView alloc] initWithFrame:CGRectMake(0, 83, WP_ScreenW, WP_ScreenH-83-49)];
        _expandTableView.delegate = self;
    }
    return _expandTableView;
}

@end
