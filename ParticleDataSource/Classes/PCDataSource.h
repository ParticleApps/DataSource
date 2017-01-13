//
//  PCDataSource.h
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PCModelObject.h"
#import "PCSection.h"

@protocol PCReloader <NSObject>

@optional

- (void)reloadData;

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths;

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths;

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths;

- (void)insertSectionAtIndex:(NSIndexSet *)index;

- (void)reloadSectionAtIndex:(NSIndexSet *)index;

- (void)deleteSectionAtIndex:(NSIndexSet *)index;

@end

@interface PCDataSource : NSObject

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, weak) id<PCReloader> reloader;

@property (nonatomic) NSMutableArray <PCSection *> *sections;

@property (nonatomic, readonly) NSMutableArray <NSNumber *> *cellTypes;

- (PCModelObject *)modelObjectForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (NSInteger)typeForIndexPath:(NSIndexPath *)indexPath;

- (NSString *)headerTitleForSection:(NSInteger)section;

- (NSString *)footerTitleForSection:(NSInteger)section;

- (CGFloat)heightForHeaderInSection:(NSInteger)section;

- (CGFloat)heightForFooterInSection:(NSInteger)section;

- (Class)cellClassForType:(NSInteger)type;

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)fetchDataWithCompletion:(void (^)())completion;

@end
