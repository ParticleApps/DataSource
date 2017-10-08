//
//  PCSection.h
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class  PCModelObject;

@interface PCSection : NSObject <NSCopying>

@property (nonatomic) NSMutableArray<PCModelObject *> *items;

@property (nonatomic) CGFloat headerHeight;

@property (nonatomic) NSString *headerTitle;

@property (nonatomic) CGFloat footerHeight;

@property (nonatomic) NSString *footerTitle;

- (instancetype)initWithItems:(NSArray *)items;

@end
