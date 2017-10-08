//
//  PCDataSourceCollectionViewController.m
//  Pods
//
//  Created by Rocco Del Priore on 2/15/17.
//
//

#import <ParticleCategories/UICollectionView+PCCategories.h>

#import "PCDataSourceCollectionViewController.h"

@interface PCDataSourceCollectionViewController ()

@property (nonatomic) PCDataSource *dataSource;

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) UIRefreshControl *refreshControl;

@end


@implementation PCDataSourceCollectionViewController

- (instancetype)initWithDataSource:(PCDataSource *)dataSource {
    UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
    return [self initWithDataSource:dataSource andLayout:layout];
}

- (instancetype)initWithDataSource:(PCDataSource *)dataSource andLayout:(UICollectionViewLayout *)layout {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.clipsToBounds = NO;
        
        self.dataSource = dataSource;
        self.dataSource.reloader = self;
        
        if (self.dataSource.title) {
            [self setTitle:self.dataSource.title];
        }
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(reloadDataSource) forControlEvents:UIControlEventValueChanged];
        
        self.canPullToRefresh = NO;
    }
    
    return self;
}

- (UIEdgeInsets)collectionInsets {
    return UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:self.collectionInsets.top],
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:self.collectionInsets.left],
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:-self.collectionInsets.bottom],
                                
                                [NSLayoutConstraint constraintWithItem:self.collectionView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:-self.collectionInsets.right],
                                
                                ]];
    
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -self.collectionInsets.right);
    
    [self registerCells];
}

- (void)setCanPullToRefresh:(BOOL)canPullToRefresh {
    _canPullToRefresh = canPullToRefresh;
    
    if (canPullToRefresh && ![self.collectionView.subviews containsObject:self.refreshControl]) {
        [self.collectionView addSubview:self.refreshControl];
    }
    else if (!canPullToRefresh && [self.collectionView.subviews containsObject:self.refreshControl]) {
        [self.refreshControl removeFromSuperview];
    }
}

- (void)reloadDataSource {
    [self.dataSource fetchDataWithCompletion:^{ [self.refreshControl endRefreshing]; }];
}

- (PCDataSource *)dataSource {
    return _dataSource;
}

- (void)configureCell:(PCDataSourceCollectionViewCell *)cell withType:(NSUInteger)type indexPath:(NSIndexPath *)indexPath {
    // Subclasses can configure cells here
}

- (void)registerCells {
    for (NSNumber *type in [[self dataSource] cellTypes]) {
        [self.collectionView registerClass:[[self dataSource] cellClassForType:type.integerValue] forCellType:type.integerValue];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[self dataSource] numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self dataSource] numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger type = [[self dataSource] typeForIndexPath:indexPath];
    
    NSString *identifier = [NSString stringWithFormat:@"%lu", (unsigned long)type];
    
    PCDataSourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Pass our model object to the cell so it can configure itself
    if ([cell respondsToSelector:@selector(configureWithModelObject:)]) {
        [cell configureWithModelObject:[[self dataSource] modelObjectForIndexPath:indexPath]];
    }
    
    // Call configureCell: for further subclass configuration
    if ([self respondsToSelector:@selector(configureCell:withType:indexPath:)]) {
        [self configureCell:cell withType:type indexPath:indexPath];
    }
    
    return cell;
}

- (NSString *)collectionView:(UICollectionView *)collectionView titleForHeaderInSection:(NSInteger)section {
    return [[self dataSource] headerTitleForSection:section];
}

- (NSString *)collectionView:(UICollectionView *)collectionView titleForFooterInSection:(NSInteger)section {
    return [[self dataSource] footerTitleForSection:section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self collectionView:collectionView viewForHeaderInSection:indexPath.section];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [self collectionView:collectionView viewForFooterInSection:indexPath.section];
    }
    return [[UICollectionReusableView alloc] init];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForHeaderInSection:(NSInteger)section {
    UICollectionReusableView *header = [[UICollectionReusableView alloc] init];
    NSString *title = [self collectionView:collectionView titleForHeaderInSection:section];
    
    if (title) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:12];
        
        [header addSubview:label];
        [header addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:header
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:header
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:header
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0],
                                 ]];
    }
    
    return header;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForFooterInSection:(NSInteger)section {
    UICollectionReusableView *footer = [[UICollectionReusableView alloc] init];
    NSString *title = [self collectionView:collectionView titleForFooterInSection:section];
    
    if (title) {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:12];
        
        [footer addSubview:label];
        [footer addConstraints:@[
                                 [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:footer
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:footer
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:footer
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0],
                                 ]];
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [self.dataSource heightForHeaderInSection:section];
    return height ? : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = [self.dataSource heightForFooterInSection:section];
    return height ? : 0;
}

#pragma mark - HMReloader protocol

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)reloadSectionAtIndex:(NSIndexSet *)index {
    [self.collectionView reloadSections:index];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths {
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths {
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths {
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

- (void)insertSectionAtIndex:(NSIndexSet *)indices {
    [self.collectionView insertSections:indices];
}

- (void)deleteSectionAtIndex:(NSIndexSet *)indices {
    [self.collectionView deleteSections:indices];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([[self dataSource] respondsToSelector:@selector(selectItemAtIndexPath:)]) {
        [[self dataSource] selectItemAtIndexPath:indexPath];
    }
}

@end
