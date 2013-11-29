//
//  AGCar.h
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#import "AGVeichle.h"

@protocol AGCar <AGVeichle>
@property (nonatomic, assign, readonly) BOOL gotTowBar;
@end

@protocol AGMutableCar <AGCar, AGMutableVeichle>
@property (nonatomic, assign, readwrite) BOOL gotTowBar;
@end

@interface AGCar : AGVeichle <AGCar>
@end
