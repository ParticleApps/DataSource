//
//  PCSection.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCSection.h"

@implementation PCSection

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setItems:[self.items copyWithZone:zone]];
        [copy setHeaderHeight:self.headerHeight];
        [copy setHeaderTitle:[self.headerTitle copyWithZone:zone]];
        [copy setFooterHeight:self.footerHeight];
        [copy setFooterTitle:[self.footerTitle copyWithZone:zone]];
    }
    
    return copy;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] initWithArray:items];
    }
    return self;
}

@end
