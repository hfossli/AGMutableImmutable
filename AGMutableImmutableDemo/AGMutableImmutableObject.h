/*
 * Copyright (c) 2012 Agens AS. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface AGMutableImmutableObject : NSObject <NSCopying, NSMutableCopying>

+ (instancetype)new:(void (^)(id mutableInstance))newBlock;
- (instancetype)copyAndModify:(void (^)(id mutableInstance))modificationBlock;

// Subclasses should override this and merge with super
+ (NSArray *)uncodableProperties;

@end
