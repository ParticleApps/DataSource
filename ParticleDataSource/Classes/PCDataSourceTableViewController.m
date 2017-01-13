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

@property (nonatomic) BOOL canPullToRefresh;

@end

@implementation PCDataSourceTableViewController

- (instancetype)initWithDataSource:(PCDataSource *)dataSource {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCells];
}

- (PCDataSource *)dataSource {
    return _dataSource;
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
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.text = [self tableView:tableView titleForFooterInSection:section];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [self.dataSource heightForHeaderInSection:section];
    return height ? : [super tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = [self.dataSource heightForFooterInSection:section];
    return height ? : [super tableView:tableView heightForFooterInSection:section];
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
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[self dataSource] respondsToSelector:@selector(selectItemAtIndexPath:)]) {
        [[self dataSource] selectItemAtIndexPath:indexPath];
    }
}

#pragma mark - PCReloader protocol

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
