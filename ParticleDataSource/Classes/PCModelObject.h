//
//  PCModelObject.h
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PCSection;

/*
 This class can be subclassed to add more properties
 - This does mean that the modelObject will need to be casted in the cell
 
 */

@interface PCModelObject : NSObject <NSCopying, NSCoding>

// Type is used to identify a cell's class for dequeuing
@property (nonatomic) NSInteger type;

// Default properties for a cell
@property (nonatomic) id object;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) NSAttributedString *attributedTitle;
@property (nonatomic) UITableViewCellAccessoryType accessoryType;

- (PCSection *)sectionForObject;

- (PCSection *)sectionForObjectWithHeaderHeight:(CGFloat)headerHeight;

- (PCSection *)sectionForObjectWithHeaderHeight:(CGFloat)headerHeight andFooterHeight:(CGFloat)footerHeight;

- (PCSection *)sectionForObjectWithHeaderHeight:(CGFloat)headerHeight andHeaderTitle:(NSString *)title andFooterHeight:(CGFloat)footerHeight;

@end
