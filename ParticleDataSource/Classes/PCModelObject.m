//
//  PCModelObject.m
//  Pods
//
//  Created by Rocco Del Priore on 1/12/17.
//
//

#import "PCModelObject.h"
#import "PCSection.h"

static NSString *const kObjectEncoder          = @"kObjectEncoder";
static NSString *const kSelectedEncoder        = @"kSelectedEncoder";
static NSString *const kTitleEncoder           = @"kTitleEncoder";
static NSString *const kSubtitleEncoder        = @"kSubtitleEncoder";
static NSString *const kImageEncoder           = @"kImageEncoder";
static NSString *const kSelectedImageEncoder   = @"kSelectedImageEncoder";
static NSString *const kAttributedTitleEncoder = @"kAttributedTitleEncoder";
static NSString *const kAccessoryTypeEncoder   = @"kAccessoryTypeEncoder";

@implementation PCModelObject

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setObject:[self.object copyWithZone:zone]];
        [copy setSelected:self.selected];
        [copy setTitle:[self.title copyWithZone:zone]];
        [copy setSubtitle:[self.subtitle copyWithZone:zone]];
        [copy setImage:[self.image copy]];
        [copy setSelectedImage:[self.selectedImage copy]];
        [copy setAttributedTitle:[self.attributedTitle copyWithZone:zone]];
        [copy setAccessoryType:self.accessoryType];
    }
    
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.object forKey:kObjectEncoder];
    [encoder encodeObject:@(self.selected) forKey:kSelectedEncoder];
    [encoder encodeObject:self.title forKey:kTitleEncoder];
    [encoder encodeObject:self.subtitle forKey:kSubtitleEncoder];
    [encoder encodeObject:self.image forKey:kImageEncoder];
    [encoder encodeObject:self.selectedImage forKey:kSelectedImageEncoder];
    [encoder encodeObject:self.attributedTitle forKey:kAttributedTitleEncoder];
    [encoder encodeObject:@(self.accessoryType) forKey:kAccessoryTypeEncoder];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.object = [decoder decodeObjectForKey:kObjectEncoder];
        self.selected = [[decoder decodeObjectForKey:kSelectedEncoder] boolValue];
        self.title = [decoder decodeObjectForKey:kTitleEncoder];
        self.subtitle = [decoder decodeObjectForKey:kSubtitleEncoder];
        self.image = [decoder decodeObjectForKey:kImageEncoder];
        self.selectedImage = [decoder decodeObjectForKey:kSelectedImageEncoder];
        self.attributedTitle = [decoder decodeObjectForKey:kAttributedTitleEncoder];
        self.accessoryType = [[decoder decodeObjectForKey:kAccessoryTypeEncoder] integerValue];
    }
    return self;
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
