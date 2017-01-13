//
//  PCDataSourceTableViewCell.h
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import <UIKit/UIKit.h>
#import "PCDataSource.h"

@interface PCDataSourceTableViewCell : UITableViewCell

- (void)configureWithModelObject:(PCModelObject *)modelObject;

@end
