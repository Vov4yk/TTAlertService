//
//  ViewController.m
//  TTAlertServiceDemo
//
//  Created by Volodymyr Hyrka on 3/17/15.
//  Copyright (c) 2015 Volodymyr Hyrka. All rights reserved.
//

#import "ViewController.h"
#import "AlarmService/TTAlertService.h"


@interface ViewController ()

@end

@implementation ViewController

- (IBAction)onAlertWithDelay:(id)sender
{
    TTAlert * alert = [TTAlert alertWithTitle:@"alert"
                                      message:@"with 2 sec delay"
                                      actions:@[[TTAlertAction standartCancelButton]]];
    alert.appearenceDelay = 2.0;
    [[TTAlertService sharedService] insertAlert:alert];
}

- (IBAction)onAlertWithLimitTimelife:(id)sender
{
    TTAlert * alert = [TTAlert alertWithTitle:@"alert"
                                      message:@"wait for 4 sec"
                                      actions:nil];
    alert.liveTime = 4.0;
    [[TTAlertService sharedService] addAlert:alert];
}

- (IBAction)onMultipleAlerts:(id)sender
{
    TTAlertAction * doneAction = [TTAlertAction actionWithTitle:@"Done"
                                                          style:UIAlertActionStyleDefault
                                                    actionBlock:^{
                                                        TTAlert * alert = [TTAlert alertWithTitle:@"action"
                                                                                          message:@"Done pressed"
                                                                                          actions:nil];
                                                        alert.liveTime = 2.0;
                                                        [[TTAlertService sharedService] insertAlert:alert];
                                                    }];
    TTAlertAction * cancelAction = [TTAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                  actionBlock:nil];
    
    [[TTAlertService sharedService] addAlert:[TTAlert alertWithTitle:@"alert"
                                                             message:@"msg1"
                                                             actions:@[cancelAction, doneAction]]];
    [[TTAlertService sharedService] addAlert:[TTAlert alertWithTitle:@"alert"
                                                             message:@"msg2"
                                                             actions:@[cancelAction, doneAction]]];
    [[TTAlertService sharedService] addAlert:[TTAlert alertWithTitle:@"alert"
                                                             message:@"msg3"
                                                             actions:@[cancelAction, doneAction]]];
}

@end
