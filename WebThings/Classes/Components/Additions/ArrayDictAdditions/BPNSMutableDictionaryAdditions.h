//
//  BPNSMutableDictionaryAdditions.h
//  BPCommon
//


#import <Foundation/Foundation.h>

@interface NSMutableDictionary (vge)
- (BOOL)expanNSMutableDictionary;

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end

@interface NSDictionary (vge)
- (BOOL)expanNSDictionary;
- (id)stringForKey:(id)aKey;
- (float)floatForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;
- (int)intForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (int)boolForKey:(id)aKey;

@end
