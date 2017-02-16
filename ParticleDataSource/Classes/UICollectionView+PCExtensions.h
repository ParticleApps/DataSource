//
//  UICollectionView+PCExtensions.h
//  Pods
//
//  Created by Rocco Del Priore on 2/15/17.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (PCExtensions)

- (void)registerClass:(Class)cellClass forCellType:(NSUInteger)cellType;

@end
