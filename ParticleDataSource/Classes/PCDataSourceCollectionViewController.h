//
//  PCDataSourceCollectionViewController.h
//  Pods
//
//  Created by Rocco Del Priore on 2/15/17.
//
//

#import <UIKit/UIKit.h>

#import "PCDataSource.h"
#import "PCDataSourceCollectionViewCell.h"

@interface PCDataSourceCollectionViewController : UIViewController <PCReloader, UICollectionViewDelegate, UICollectionViewDataSource>

- (PCDataSource *)dataSource;

@property (nonatomic) UIEdgeInsets collectionInsets;

@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic, readonly) UIRefreshControl *refreshControl;

@property (nonatomic) BOOL canPullToRefresh;

@end

@interface PCDataSourceCollectionViewController (Optional)

- (instancetype)initWithDataSource:(PCDataSource *)dataSource;

- (instancetype)initWithDataSource:(PCDataSource *)dataSource andLayout:(UICollectionViewLayout *)layout;

- (void)registerCells;

- (void)configureCell:(PCDataSourceCollectionViewCell *)cell withType:(NSUInteger)type indexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForCellWithType:(NSUInteger)type;

@end
