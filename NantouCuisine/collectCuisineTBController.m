
#import "collectCuisineTBController.h"
#import "collectCuisineTBViewCell.h"


@interface collectCuisineTBController ()

@end

@interface collectCuisineTBController ()

@end

@implementation collectCuisineTBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    collectCuisineTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //餐廳區域
    cell.nantouStateLbl.text = @"埔里鎮";
    //餐廳名稱
    cell.restaurantNameLbl.text = @"有田日本料理";
    //餐廳距離
    cell.kmLbl.text = @"20km";
    //餐廳圓形照片
    //圖片栽剪成圓形
    cell.storeImageView.layer.cornerRadius = cell.storeImageView.frame.size.width/2;
    cell.storeImageView.clipsToBounds = YES;
    cell.storeImageView.image = [UIImage imageNamed:@"7.jpg"];
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
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
