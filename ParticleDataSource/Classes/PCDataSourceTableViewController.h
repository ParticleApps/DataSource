//
//  PCDataSourceTableViewController.h
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import <UIKit/UIKit.h>
#import "PCDataSource.h"
#import "PCDataSourceTableViewCell.h"

@interface PCDataSourceTableViewController : UIViewController <PCReloader, UITableViewDelegate, UITableViewDataSource>

- (PCDataSource *)dataSource;

@property (nonatomic) UIEdgeInsets tableInsets;

@property (nonatomic, readonly) UITableView *tableView;

@end

@interface PCDataSourceTableViewController (Optional)

- (instancetype)initWithDataSource:(PCDataSource *)dataSource;

- (instancetype)initWithDataSource:(PCDataSource *)dataSource andStyle:(UITableViewStyle)style;

- (void)registerCells;

- (void)configureCell:(PCDataSourceTableViewCell *)cell withType:(NSUInteger)type indexPath:(NSIndexPath *)indexPath;

// TODO: Implement if we need headers
//- (void)configureHeader:(UIView *)header withType:(NSUInteger)type section:(NSInteger)section;

// TODO: Implement
- (CGFloat)heightForCellWithType:(NSUInteger)type;
@end
