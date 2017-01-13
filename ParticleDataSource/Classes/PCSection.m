//
//  PCSection.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCSection.h"

@implementation PCSection

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
