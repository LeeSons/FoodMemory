//
//  LoginViewController.h
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "BasePageController.h"
typedef void (^BackHandel)(void);
@interface LoginViewController : BasePageController

@property(nonatomic, copy)BackHandel backhandel;

@end
