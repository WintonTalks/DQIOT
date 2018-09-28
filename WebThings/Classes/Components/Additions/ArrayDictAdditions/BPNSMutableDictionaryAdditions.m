//
//  BPNSMutableDictionaryAdditions.m
//  BPCommon
//
//  Created by wangpeng on 4/2/13.
//
//

#import "BPNSMutableDictionaryAdditions.h"

@implementation NSMutableDictionary (vge)

- (BOOL)expanNSMutableDictionary
{
    if (!self || [self isEqual:[NSNull null]]) {
        return false;
    }
    return true;
}

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject&&aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end


@implementation NSDictionary (vge)

- (BOOL)expanNSDictionary
{
    if (!self || [self isEqual:[NSNull null]]) {
        return false;
    }
    return true;
}

- (id)stringForKey:(id)aKey
{
    return [self convertToString:[self objectForKey:aKey]];
}

- (float)floatForKey:(id)aKey
{
    return [self convertToFloat:[self objectForKey:aKey]];
}

- (double)doubleForKey:(id)aKey
{
    return [self convertToDouble:[self objectForKey:aKey]];
}

- (int)intForKey:(id)aKey
{
    return [self convertToInt:[self objectForKey:aKey]];
}

- (int)boolForKey:(id)aKey
{
    return [self convertToBool:[self objectForKey:aKey]];
}

- (NSInteger)integerForKey:(id)aKey
{
    id source = [self objectForKey:aKey];
    if ([source isKindOfClass:[NSString class]]) {
        return [source integerValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source integerValue];
    } else {
        return 0;
    }
}


- (bool)convertToBool:(id)source {
    if (source == [NSNull null]) {
        return NO;
    }
    return [source boolValue];
}

- (NSString *)convertToString:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return source;
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", source];
    } else {
        return nil;
    }
}

- (float)convertToFloat:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return [source floatValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source floatValue];
    } else {
        return 0;
    }
}

- (double)convertToDouble:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return [(NSString *)source doubleValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)source doubleValue];
    } else {
        return 0;
    }
}


- (int)convertToInt:(id)source {
    if ([source isKindOfClass:[NSString class]]) {
        return [source intValue];
    } else if ([source isKindOfClass:[NSNumber class]]) {
        return [source intValue];
    } else {
        return 0;
    }
}

@end
