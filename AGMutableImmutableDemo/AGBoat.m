//
//  AGTruck.m
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#import "AGBoat.h"

@interface AGBoat () <AGMutableBoat>

@end

@implementation AGBoat

@synthesize numberOfLifeJackets = _numberOfLifeJackets;

@end
