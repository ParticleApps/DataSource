//
//  UICollectionView+PCExtensions.m
//  Pods
//
//  Created by Rocco Del Priore on 2/15/17.
//
//

#import "UICollectionView+PCExtensions.h"

@implementation UICollectionView (PCExtensions)

- (void)registerClass:(Class)cellClass forCellType:(NSUInteger)cellType {
    [self registerClass:cellClass forCellWithReuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)cellType]];
}

@end
