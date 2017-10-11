//
//  PCDataSource.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCDataSource.h"
#import "PCDataSourceTableViewCell.h"

@interface PCDataSource ()

@property (nonatomic) NSMutableArray <NSNumber *> *cellTypes;

@property (nonatomic) NSString *title;

@end

@implementation PCDataSource

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setTitle:[self.title copyWithZone:zone]];
        [copy setReloader:self.reloader];
        [copy setSections:[self.sections copyWithZone:zone]];
        [copy setCellTypes:[self.cellTypes copyWithZone:zone]];
    }
    
    return copy;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.sections  = [NSMutableArray array];
        self.cellTypes = [NSMutableArray arrayWithObject:@(0)];
    }
    return self ;
}

- (NSInteger)numberOfSections {
    return _sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return _sections[section].items.count;
}

- (NSInteger)typeForIndexPath:(NSIndexPath *)indexPath {
    return [self modelObjectForIndexPath:indexPath].type;
}

- (PCModelObject *)modelObjectForIndexPath:(NSIndexPath *)indexPath {
    return _sections[indexPath.section].items[indexPath.row];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return _sections[section].headerHeight;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    return _sections[section].footerHeight;
}

- (NSString *)headerTitleForSection:(NSInteger)section {
    return _sections[section].headerTitle;
}

- (NSString *)footerTitleForSection:(NSInteger)section {
    return _sections[section].footerTitle;
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath {
    //Placeholder to remove warning
}

- (void)fetchDataWithCompletion:(void (^)(void))completion {
    //Implement in subclass for things like pull to refresh
    if (completion) completion();
}

- (Class)cellClassForType:(NSInteger)type {
    return [PCDataSourceTableViewCell class];
}

@end
