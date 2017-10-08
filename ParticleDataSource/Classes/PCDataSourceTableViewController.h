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

@property (nonatomic, readonly) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL canPullToRefresh;

@end

@interface PCDataSourceTableViewController (Optional)

- (instancetype)initWithDataSource:(PCDataSource *)dataSource;

- (instancetype)initWithDataSource:(PCDataSource *)dataSource andStyle:(UITableViewStyle)style;

- (void)registerCells;

- (void)configureCell:(PCDataSourceTableViewCell *)cell withType:(NSUInteger)type indexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForCellWithType:(NSUInteger)type;

@end
