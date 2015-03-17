

//
//  TTAlertService.m
//  TrailTap
//
//  Created by Volodymyr Hyrka on 3/12/15.
//  Copyright (c) 2015 Lemberg Solutions. All rights reserved.
//

#import "TTAlertService.h"
#import "TTCore.h"

static TTAlertService * sharedInstance;

static float const C_ALERTS_DELAY = 0.1;

@implementation TTAlertService

+ (TTAlertService*)sharedService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.alertsQueue = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

- (void)addAlert:(TTAlert *)alert
{
    if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        UIAlertView * alertView = [self alertViewFor:alert];
        if (alertView)
        {
            [self.alertsQueue addObject:alert];
            [alertView show];
            
            if (alert.liveTime)
            {
                [self performSelector:@selector(dismissAlert:) withObject:alertView afterDelay:alert.liveTime];
            }
        }
    }
    else
    {
        [self.alertsQueue addObject:alert];
        if (self.alertsQueue.count == 1)
        {
            [self showNextAlert];
        }
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TTAlert * alert = [self alertForTitle:alertView.title message:alertView.message];
    if (alert)
    {
        @try {
            [alert.actions[buttonIndex] actionBlock]();
        }
        @catch (NSException *exception) {
            NSLog(@"can't run action block");
        }
        @finally {}
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    TTAlert * alert = [self alertForTitle:alertView.title message:alertView.message];
    [self.alertsQueue removeObject:alert];
}


#pragma mark - private

- (void)showNextAlert
{
    if (!self.alertsQueue.count)
        return;
    
    TTAlert * alert = self.alertsQueue.firstObject;
    
    _alertController = [UIAlertController alertControllerWithTitle:alert.title
                                                                              message:alert.message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    for (TTAlertAction * ourAction in alert.actions)
    {
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:ourAction.title
                                                               style:ourAction.style
                                                             handler:^(UIAlertAction *action) {
                                                                 [self alertControllerDidDissmissed];
                                                                 @try {
                                                                     ourAction.actionBlock();
                                                                 }
                                                                 @catch (NSException *exception) {
                                                                     NSLog(@"can't run action block");
                                                                 }
                                                                 @finally {}
                                                             }];
        [_alertController addAction:alertAction];
    }

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:_alertController
                                                                                     animated:YES
                                                                                   completion:nil];
    if (alert.liveTime)
    {
        [self performSelector:@selector(dismissAlert:) withObject:_alertController afterDelay:alert.liveTime];
    }
}

- (void)alertControllerDidDissmissed
{
    TTAlert * firstObj = self.alertsQueue.firstObject;
    [self.alertsQueue removeObject:firstObj];
    [self performSelector:@selector(showNextAlert)
               withObject:nil
               afterDelay:C_ALERTS_DELAY];
}

- (UIAlertView*)alertViewFor:(TTAlert*)alert
{
    if ([self alertForTitle:alert.title message:alert.message]) // search for alert duplications
        return nil;
    
    NSString * cancelButtonName = (alert.actions.count?[alert.actions.firstObject title]:@"Ok");
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:alert.title
                                                         message:alert.message
                                                        delegate:self
                                               cancelButtonTitle:cancelButtonName
                                               otherButtonTitles:nil];
    if (alert.actions.count>1)
    {
        for (int i = 1; i<alert.actions.count; i++)
        {
            [alertView addButtonWithTitle:[alert.actions[i] title]];
        }
    }
    return alertView;
}

- (TTAlert*)alertForTitle:(NSString*)title message:(NSString*)message
{
    for (TTAlert * alert in self.alertsQueue)
    {
        BOOL equalTitle = [alert.title isEqualToString:title] || (alert.title == nil && title==nil);
        BOOL equalMsg = [alert.message isEqualToString:message] || (alert.message == nil && message == nil);
        if (equalTitle && equalMsg)
        {
            return alert;
        }
    }
    return nil;
}

#pragma mark - 

- (void)dismissAlert:(id)alertWrapper
{
    if ([alertWrapper isKindOfClass:[UIAlertController class]])
    {
        [(UIAlertController*)alertWrapper dismissViewControllerAnimated:NO completion:nil];
        [self alertControllerDidDissmissed];
    }
    else if ([alertWrapper isKindOfClass:[UIAlertView class]])
    {
        [(UIAlertView*)alertWrapper dismissWithClickedButtonIndex:-1 animated:NO];
    }
}

@end
