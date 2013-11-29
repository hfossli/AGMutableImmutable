//
//  AGCar.m
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#import "AGCar.h"

@interface AGCar () <AGMutableCar>

@end

@implementation AGCar

@synthesize gotTowBar = _wheelDescription;

@end
