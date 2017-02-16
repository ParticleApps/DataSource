//
//  PCDataSourceCollectionViewCell.h
//  Pods
//
//  Created by Rocco Del Priore on 2/15/17.
//
//

#import <UIKit/UIKit.h>
#import "PCDataSource.h"

@interface PCDataSourceCollectionViewCell : UICollectionViewCell

- (void)configureWithModelObject:(PCModelObject *)modelObject;

@end
