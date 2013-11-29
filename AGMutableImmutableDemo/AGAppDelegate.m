//
//  AGAppDelegate.m
//  AGMutableImmutableDemo
//
//  Created by Håvard Fossli on 29.11.13.
//  Copyright (c) 2013 Agens AS. All rights reserved.
//

#define AGClassHelperExtendsNSObject 1

#import "AGAppDelegate.h"
#import "AGCar.h"
#import "AGBoat.h"
#import "AGClassHelper.h"

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    AGCar *momsCar = [AGCar new:^(AGCar <AGMutableCar> *car) {
        car.brand = @"Toyota";
        car.weightInKiloGrams = 1200.0f;
        car.gotTowBar = YES;
    }];
    AGCar *granPasCar = [momsCar update:^(AGCar<AGMutableCar> *car) {
        car.gotTowBar = NO;
    }];
    AGBoat *dadsBoat = [AGBoat new:^(AGBoat <AGMutableBoat>* boat) {
        boat.brand = @"Askeladden";
        boat.weightInKiloGrams = 500.0f;
        boat.numberOfLifeJackets = 7.0;
    }];
    AGVeichle *train = [AGVeichle new:^(AGVeichle <AGMutableVeichle> *train) {
        train.brand = @"Turbo3000";
        train.weightInKiloGrams = 980000.0f;
    }];

    NSLog(@"Some train: %@", [train dictionaryRepresentation]);
    NSLog(@"Moms car: %@", [momsCar dictionaryRepresentation]);
    NSLog(@"Granpas car: %@", [granPasCar dictionaryRepresentation]);
    NSLog(@"Dads boat: %@", [dadsBoat dictionaryRepresentation]);

    return YES;
}

- (AGCar *)createMyMomsCar
{
    AGCar *car = [AGCar new:^(AGCar <AGMutableCar> *car) {
        car.weightInKiloGrams = 1200.0f;
        car.gotTowBar = YES;
    }];
    return car;
}

- (AGBoat *)createMyFathersBoat
{
    AGBoat *boat = [AGBoat new:^(AGBoat <AGMutableBoat>* boat) {
        boat.weightInKiloGrams = 500.0f;
        boat.numberOfLifeJackets = 7.0;
    }];
    return boat;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
