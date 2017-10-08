//
//  PCDataSourceTableViewCell.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCDataSourceTableViewCell.h"

@implementation PCDataSourceTableViewCell

- (void)configureWithModelObject:(PCModelObject *)modelObject {
    if (modelObject.attributedTitle) {
        self.textLabel.attributedText = modelObject.attributedTitle;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        self.textLabel.text = modelObject.title;
    }
    
    self.detailTextLabel.text   = modelObject.subtitle;
    self.imageView.image        = modelObject.image;
    
    self.accessoryType = modelObject.accessoryType;
}

@end
