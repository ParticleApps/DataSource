//
//  UITableView+PCExtensions.m
//  Pods
//
//  Created by Rocco Del Priore on 10/28/16.
//
//

#import "UITableView+PCExtensions.h"

@implementation UITableView (PCExtensions)

- (void)performUpdates:(dispatch_block_t)updates {
    [self beginUpdates];
    
    if (updates) {
        updates();
    }
    
    [self endUpdates];
}

- (void)registerClass:(Class)cellClass forCellType:(NSUInteger)cellType {
    [self registerClass:cellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%lu", (unsigned long)cellType]];
}

@end
