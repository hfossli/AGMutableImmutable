/*
 * Copyright (c) 2012 Agens AS. All rights reserved.
 */

#import "AGMutableImmutableObject.h"
#import "AGClassHelper.h"

typedef enum {
    AGMutabilityNone,
    AGMutabilityTemporary,
    AGMutabilityPermanent
} AGMutabilityState;

@interface AGMutableImmutableObject ()

@end

@implementation AGMutableImmutableObject {
    AGMutabilityState _mutabilityState;
}

#pragma mark - Construct and destruct

- (id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
} 

+ (instancetype)new:(void (^)(id mutableInstance))block
{
    AGMutableImmutableObject *instance = [self new];
    instance->_mutabilityState = AGMutabilityTemporary;
    block(instance);
    instance->_mutabilityState = AGMutabilityNone;
    return instance;
}

- (instancetype)update:(void (^)(id mutableInstance))block
{
    AGMutableImmutableObject *instance = [self copy];
    instance->_mutabilityState = AGMutabilityTemporary;
    block(instance);
    instance->_mutabilityState = AGMutabilityNone;
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    AGMutableImmutableObject *instance = [[self class] new];
    instance->_mutabilityState = AGMutabilityTemporary;
    NSDictionary *properties = [AGClassHelper codablePropertiesForInheritanceOfClass:[self class] omit:[[self class] uncodableProperties]];
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = [self valueForKey:key];
        if (object) [instance setValue:object forKey:key];
    }];
    instance->_mutabilityState = AGMutabilityNone;
    return instance;
}

+ (NSArray *)uncodableProperties
{
    NSArray *omit = nil;
    if([[self superclass] instancesRespondToSelector:@selector(uncodableProperties)])
    {
        omit = [super performSelector:@selector(uncodableProperties)];
    }
    return omit;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    AGMutableImmutableObject *instance = [[self class] new];
    instance->_mutabilityState = AGMutabilityPermanent;
    NSDictionary *properties = [AGClassHelper codablePropertiesForInheritanceOfClass:[self class] omit:[[self class] uncodableProperties]];
    [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id object = [self valueForKey:key];
        if (object) [instance setValue:object forKey:key];
    }];
    return instance;
}

@end
