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

@interface PCDataSourceTableViewController : UITableViewController <PCReloader>

- (PCDataSource *)dataSource;

@end

@interface PCDataSourceTableViewController (Optional)

@property (nonatomic) BOOL canPullToRefresh;

- (instancetype)initWithDataSource:(PCDataSource *)dataSource;

- (void)registerCells;

- (void)configureCell:(PCDataSourceTableViewCell *)cell withType:(NSUInteger)type indexPath:(NSIndexPath *)indexPath;

// TODO: Implement if we need headers
//- (void)configureHeader:(UIView *)header withType:(NSUInteger)type section:(NSInteger)section;

// TODO: Implement
- (CGFloat)heightForCellWithType:(NSUInteger)type;

@end
