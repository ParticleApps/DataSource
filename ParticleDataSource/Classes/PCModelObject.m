//
//  PCModelObject.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCModelObject.h"
#import "PCSection.h"

@implementation PCModelObject

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setObject:[self.object copyWithZone:zone]];
        [copy setTitle:[self.title copyWithZone:zone]];
        [copy setSubtitle:[self.subtitle copyWithZone:zone]];
        [copy setImage:[self.image copy]];
        [copy setSelectedImage:[self.selectedImage copy]];
        [copy setAttributedTitle:[self.attributedTitle copyWithZone:zone]];
        [copy setAccessoryType:self.accessoryType];
    }
    
    return copy;
}

- (PCSection *)sectionForObject {
    return [self sectionForObjectWithHeaderHeight:0 andHeaderTitle:nil andFooterHeight:0];
}

- (PCSection *)sectionForObjectWithHeaderHeight:(CGFloat)headerHeight {
    return [self sectionForObjectWithHeaderHeight:headerHeight andHeaderTitle:nil andFooterHeight:0];
}

- (PCSection *)sectionForObjectWithHeaderHeight:(CGFloat)headerHeight andFooterHeight:(CGFloat)footerHeight {
    return [self sectionForObjectWithHeaderHeight:headerHeight andHeaderTitle:nil andFooterHeight:footerHeight];
}

- (PCSection *)sectionForObjectWithHeaderHeight:(CGFloat)headerHeight andHeaderTitle:(NSString *)title andFooterHeight:(CGFloat)footerHeight {
    PCSection *section = [[PCSection alloc] init];
    section.headerHeight = headerHeight;
    section.headerTitle = title;
    section.footerHeight = footerHeight;
    [section.items addObject:self];
    
    return section;
}


@end
