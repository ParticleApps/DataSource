//
//  PCTestDataSource.m
//  ParticleDataSource
//
//  Created by Rocco Del Priore on 1/13/17.
//  Copyright © 2017 Rocco Del Priore. All rights reserved.
//

#import "PCTestDataSource.h"

@implementation PCTestDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        PCModelObject *object = [[PCModelObject alloc] init];
        object.title = @"Title";
        object.subtitle = @"Subtitle";
        
        PCModelObject *object2 = [[PCModelObject alloc] init];
        object2.title = @"Mall";
        object2.subtitle = @"rats";
        
        PCSection *section = [[PCSection alloc] initWithItems:@[object, object2]];
        [self.sections addObject:section];
    }
    return self;
}

@end
