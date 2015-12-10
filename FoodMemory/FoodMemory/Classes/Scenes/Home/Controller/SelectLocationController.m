//
//  SelectLocationController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/8.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "SelectLocationController.h"

@interface SelectLocationController ()

@end
static NSString *locationCell = @"locationCell";
@implementation SelectLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:locationCell];
    self.view.backgroundColor = RgbColor(231, 231, 231);
    [self setupView];
}

- (void)setupView{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 80)];
    searchView.backgroundColor = [UIColor whiteColor];
    UITextField *txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(5, 30, kWindowWidth, 30)];
    txtSearch.placeholder = @"查找位置";
    txtSearch.borderStyle = UITextBorderStyleRoundedRect;
    [searchView addSubview:txtSearch];
    self.tableView.tableHeaderView = searchView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCell forIndexPath:indexPath];
    cell.textLabel.text = @"试试";
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
