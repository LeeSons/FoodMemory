//
//  EditViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "EditViewController.h"
#import "LCPImageView.h"
@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewForUPic;
@property (weak, nonatomic) IBOutlet UITextField *txtSign;
@property (weak, nonatomic) IBOutlet UIImageView *imgEditSign;
@property (nonatomic, strong) LCPImageView *imgUPic;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgUPic = [[LCPImageView alloc] initWithFrame:CGRectMake((kWindowWidth - 100) / 2.0, 10, 100, 100)];
    [self.viewForUPic addSubview:_imgUPic];
    AVUser *user = [AVUser currentUser];
    self.txtSign.text = [user objectForKey:@"sign"];
    AVFile *file = [user objectForKey:@"userPic"];
    [self.imgUPic sd_setImageWithURL:[NSURL URLWithString:file.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
