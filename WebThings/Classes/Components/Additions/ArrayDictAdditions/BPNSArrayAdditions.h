//
//  BPNSArrayAdditions.h
//  VGEUtil
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (vge)

- (void)safeAddObject:(id)anObject;

- (id)safeObjectAtIndex:(NSUInteger)index;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

- (BOOL)expanNSMutableArray;

@end

@interface NSArray (vge)

- (BOOL)expanNSArray;

- (NSString *)stringValueSeparatedByComma;

- (id)safeObjectAtIndex:(NSUInteger)index;

@end
