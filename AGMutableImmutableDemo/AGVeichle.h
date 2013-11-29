//
//  AGVeichle.h
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGMutableImmutableObject.h"

@protocol AGVeichle <NSObject>

@property (nonatomic, copy, readonly) NSString *brand;
@property (nonatomic, assign, readonly) CGFloat weightInKiloGrams;

@end

@protocol AGMutableVeichle <NSObject>

@property (nonatomic, copy, readwrite) NSString *brand;
@property (nonatomic, assign, readwrite) CGFloat weightInKiloGrams;

@end

@interface AGVeichle : AGMutableImmutableObject <AGVeichle>
 
@end
