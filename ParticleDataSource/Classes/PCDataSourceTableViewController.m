//
//  PCDataSourceTableViewController.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCDataSourceTableViewController.h"
#import "UITableView+PCExtensions.h"

@interface PCDataSourceTableViewController ()

@property (nonatomic) PCDataSource *dataSource;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation PCDataSourceTableViewController

- (instancetype)initWithDataSource:(PCDataSource *)dataSource {
    return [self initWithDataSource:dataSource andStyle:UITableViewStylePlain];
}

- (instancetype)initWithDataSource:(PCDataSource *)dataSource andStyle:(UITableViewStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.clipsToBounds = NO;
        
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

- (UIEdgeInsets)tableInsets {
    return UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.tableView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:self.tableInsets.top],
                                
                                [NSLayoutConstraint constraintWithItem:self.tableView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:self.tableInsets.left],
                                
                                [NSLayoutConstraint constraintWithItem:self.tableView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:-self.tableInsets.bottom],
                                
                                [NSLayoutConstraint constraintWithItem:self.tableView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:-self.tableInsets.right],
                                
                                ]];
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -self.tableInsets.right);
    
    [self registerCells];
}

- (void)setCanPullToRefresh:(BOOL)canPullToRefresh {
    _canPullToRefresh = canPullToRefresh;
    
    if (canPullToRefresh && ![self.tableView.subviews containsObject:self.refreshControl]) {
        [self.tableView addSubview:self.refreshControl];
    }
    else if (!canPullToRefresh && [self.tableView.subviews containsObject:self.refreshControl]) {
        [self.refreshControl removeFromSuperview];
    }
}

- (void)reloadDataSource {
    [self.dataSource fetchDataWithCompletion:^{ [self.refreshControl endRefreshing]; }];
}

- (PCDataSource *)dataSource {
    return _dataSource;
}

- (void)configureCell:(PCDataSourceTableViewCell *)cell withType:(NSUInteger)type indexPath:(NSIndexPath *)indexPath {
    // Subclasses can configure cells here
}

- (void)registerCells {
    for (NSNumber *type in [[self dataSource] cellTypes]) {
        [self.tableView registerClass:[[self dataSource] cellClassForType:type.integerValue] forCellType:type.integerValue];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self dataSource] numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataSource] numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger type = [[self dataSource] typeForIndexPath:indexPath];
    
    NSString *identifier = [NSString stringWithFormat:@"%lu", (unsigned long)type];
    
    PCDataSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    NSString *title = [self tableView:tableView titleForFooterInSection:section];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self dataSource] headerTitleForSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self dataSource] footerTitleForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(heightForCellWithType:)]) {
        return [self heightForCellWithType:[[self dataSource] typeForIndexPath:indexPath]];
    } else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[self dataSource] respondsToSelector:@selector(selectItemAtIndexPath:)]) {
        [[self dataSource] selectItemAtIndexPath:indexPath];
    }
}

#pragma mark - HMReloader protocol

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)reloadSectionAtIndex:(NSIndexSet *)index {
    [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths {
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths {
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths {
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)insertSectionAtIndex:(NSIndexSet *)index {
    [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteSectionAtIndex:(NSIndexSet *)index {
    [self.tableView deleteSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
