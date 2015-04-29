//
//  TTAlert.h
//  TrailTap
//
//  Created by Volodymyr Hyrka on 3/12/15.
//  Copyright (c) 2015 Lemberg Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTAlertAction : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic) UIAlertActionStyle style;
@property (copy)void (^actionBlock)(void);

+ (instancetype)actionWithTitle:(NSString*)title style:(UIAlertActionStyle)style actionBlock:(void(^)(void))action;
+ (instancetype)standartCancelButton;

@end


@interface TTAlert : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSArray * actions;
@property (nonatomic) float liveTime;
@property (nonatomic) float appearenceDelay;

+ (instancetype)alertWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions;

@end
