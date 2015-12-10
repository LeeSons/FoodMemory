//
//  RegiesterViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/9.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "RegiesterViewController.h"

@interface RegiesterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPwd;
- (IBAction)actionRegiester:(UIButton *)sender;

@end

@implementation RegiesterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (IBAction)actionRegiester:(UIButton *)sender {
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"defualt.jpg"]);
    AVFile *file = [AVFile fileWithData:data];
    [file saveInBackground];
    AVUser *user = [AVUser user];
    user.username = self.txtUserName.text;
    user.password = self.txtPwd.text;
    [user setObject:file forKey:@"userPic"];
    [user setObject:@"F" forKey:@"gender"];
    [user setObject:@"这吃货很懒，什么都没写。" forKey:@"sign"];
    [user setObject:[NSString stringWithFormat:@"U%d",arc4random_uniform(10000)] forKey:@"userNickName"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)[self dismissViewControllerAnimated:YES completion:nil];
        else LCPLog(@"注册失败%@",error);
    }];
}
@end
