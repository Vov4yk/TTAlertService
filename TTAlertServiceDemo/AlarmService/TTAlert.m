//
//  TTAlert.m
//  TrailTap
//
//  Created by Volodymyr Hyrka on 3/12/15.
//  Copyright (c) 2015 Lemberg Solutions. All rights reserved.
//

#import "TTAlert.h"

@implementation TTAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style actionBlock:(void (^)(void))action
{
    TTAlertAction * actionObj = [[TTAlertAction alloc] init];
    actionObj.title = title;
    actionObj.style = style;
    actionObj.actionBlock = (action?action:^{});
    
    return actionObj;
}

+ (instancetype)standartCancelButton
{
    return [TTAlertAction actionWithTitle:@"OK"
                                    style:UIAlertActionStyleCancel
                              actionBlock:nil];
}

@end


@implementation TTAlert

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions
{
    TTAlert * alarm = [[TTAlert alloc] init];
    alarm.title = title;
    alarm.message = message;
    alarm.actions = actions;
    
    return alarm;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@:%@",self.title, self.message];
}

@end
