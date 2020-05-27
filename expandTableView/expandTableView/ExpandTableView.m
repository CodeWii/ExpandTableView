//
//  ExpandTableView.m
//  expandTableView
//
//  Created by 王同学 on 2020/5/27.
//  Copyright © 2020 Simple. All rights reserved.
//

#import "ExpandTableView.h"
#import "Config.h"

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";

@interface ExpandTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *expandDic;
@property (nonatomic, strong) NSString *lastIndex;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ExpandTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        
        self.isMultiple = NO; // 默认单选
    }
    return self;
}

- (void)initWithData:(NSArray *)data {
    self.dataArray = data;
    
    // 组标题
    for (NSDictionary *dic in data) {
        [self.sectionArr addObject:dic[@"title"]];
    }
    
    // 设置默认选中某一组
    NSString *defaultSel = @"3";
    [self.expandDic setObject:@"1" forKey:defaultSel];
    self.lastIndex = defaultSel;
    
    [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return self.sectionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ExpandTableHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"h%ld",section]];
    if (header == nil) {
        header = [[ExpandTableHeader alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"h%ld",section]];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
    header.tag = 999 + section;
    [header addGestureRecognizer:tap];
    header.titleLab.text = [NSString stringWithFormat:@"%@",self.sectionArr[section]];
    
    // 刷新控件
    if ([self.expandDic[[NSString stringWithFormat:@"%ld",section]] integerValue] == 1) {
        header.view.backgroundColor = [UIColor whiteColor];
        header.indicator.hidden = NO;
        header.titleLab.textColor = [UIColor orangeColor];
    }else {
        header.view.backgroundColor = ThemeBG;
        header.indicator.hidden = YES;
        header.titleLab.textColor = [UIColor blackColor];
    }
    
    return header;
}

- (void)action_tap:(UIGestureRecognizer *)tap{
    NSString *index = [NSString stringWithFormat:@"%ld",tap.view.tag - 999];

    // 单选/多选
    if (!self.isMultiple) {
        // 如果重复点击，返回
        if (index == self.lastIndex) return;
        
        // 如果上次有点击，关闭上次section并刷新
        if (self.lastIndex) {
            [self.expandDic setObject:@"0" forKey:self.lastIndex];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.lastIndex integerValue]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    //如果是0，就把1赋给字典,打开cell
    if ([self.expandDic[index] integerValue] == 0) {
        [self.expandDic setObject:@"1" forKey:index];
    }else{
        [self.expandDic setObject:@"0" forKey:index];
    }
    
    // 记录上次index
    self.lastIndex = index;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[index integerValue]]withRowAnimation:UITableViewRowAnimationFade];
    
    /** 滚动到选中组
    NSArray *arr = self.dataArray[[index integerValue]][@"sub"];
    if (arr.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[index integerValue]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    if ([self.expandDic[string] integerValue] == 1 ) {
        NSArray *arr = self.dataArray[section][@"sub"];
        return arr.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.backgroundColor = ColorWhite;
    cell.textLabel.textColor = UIColor.lightGrayColor;
    cell.textLabel.text = self.dataArray[indexPath.section][@"sub"][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableViewDidSelectRowAtIndexPath:)]) {
        [self.delegate tableViewDidSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - lazy

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = ColorRGB(240, 240, 240);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)expandDic {
    if (!_expandDic) {
        _expandDic = [NSMutableDictionary dictionary];
    }
    return _expandDic;
}

@end


@implementation ExpandTableHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WP_ScreenW, 50)];
    self.view.backgroundColor = ThemeBG;
    
    self.indicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 5, 20)];
    self.indicator.backgroundColor = [UIColor orangeColor];
    self.indicator.hidden = YES;
    [self.view addSubview:self.indicator];

    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.userInteractionEnabled = true;
    [self.view addSubview:self.titleLab];
    
    [self.contentView addSubview:self.view];
}

@end
