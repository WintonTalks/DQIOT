//
//  BPNSArrayAdditions.m
//  VGEUtil
//


#import "BPNSArrayAdditions.h"

@implementation NSMutableArray (vge)

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
       return [self objectAtIndex:index];
    }
    return nil;
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}

- (BOOL)expanNSMutableArray
{
    if (!self || [self isEqual:[NSNull null]] || self.count < 1) {
        return false;
    }
    return true;
}

@end

@implementation NSArray (vge)

- (NSString *)stringValueSeparatedByComma {
    NSMutableString *mStr = [NSMutableString string];
    for (int i=0; i<[self count]; i++) {
        NSString *str = [self objectAtIndex:i];
        if (i == 0) {
            [mStr appendString:str];
        } else {
            [mStr appendFormat:@",%@", str];
        }
    }
    return mStr;
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < [self count]) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (BOOL)expanNSArray
{
    if (!self || [self isEqual:[NSNull null]] || self.count < 1) {
        return false;
    }
    return true;
}

@end
