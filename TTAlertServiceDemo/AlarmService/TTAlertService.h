//
//  TTAlertService.h
//  TrailTap
//
//  Created by Volodymyr Hyrka on 3/12/15.
//  Copyright (c) 2015 Lemberg Solutions. All rights reserved.
//

// Service developer for handling queues of popups with messages;
// use UIAlertController instead UIAlertView
// UIAlertController is available from iOS8 only


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTAlert.h"

@interface TTAlertService : NSObject <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * alertsQueue;
@property (nonatomic, strong) UIAlertController * alertController;

+ (TTAlertService*)sharedService;

- (void)addAlert:(TTAlert*)alert;
- (void)insertAlert:(TTAlert*)alert;

@end
