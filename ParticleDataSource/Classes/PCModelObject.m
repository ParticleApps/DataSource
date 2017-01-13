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
