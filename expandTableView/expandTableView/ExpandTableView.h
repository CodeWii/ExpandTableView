//
//  ExpandTableView.h
//  expandTableView
//
//  Created by 王同学 on 2020/5/27.
//  Copyright © 2020 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExpandTableViewDelegate <NSObject>

@optional
- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ExpandTableView : UIView

- (void)initWithData:(NSArray *)data;

/** 是否多选 default 单选 */
@property (nonatomic, assign) BOOL isMultiple;

@property (nonatomic, weak) id<ExpandTableViewDelegate> delegate;

@end

@interface ExpandTableHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView  *view;
@property (nonatomic, strong) UILabel *indicator;
@property (nonatomic, strong) UILabel *titleLab;

@end

NS_ASSUME_NONNULL_END
