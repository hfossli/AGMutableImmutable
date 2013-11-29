//
//  AGVeichle.m
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#import "AGVeichle.h"

@interface AGVeichle () <AGMutableVeichle>

@end

@implementation AGVeichle

@synthesize brand = _brand;
@synthesize weightInKiloGrams = _weightInKiloGrams;

@end
