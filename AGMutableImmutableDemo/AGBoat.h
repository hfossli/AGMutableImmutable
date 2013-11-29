//
//  AGTruck.h
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#import "AGVeichle.h"

@protocol AGBoat <NSObject>
@property (nonatomic, assign, readonly) NSUInteger numberOfLifeJackets;
@end

@protocol AGMutableBoat <AGBoat, AGMutableVeichle>
@property (nonatomic, assign, readwrite) NSUInteger numberOfLifeJackets;
@end

@interface AGBoat : AGVeichle <AGBoat>
@end
