
#import "collectCuisineTBController.h"
#import "collectCuisineTBViewCell.h"
#import "DataSource.h"
#import "Restaurant.h"
#import "CommunicatorNewWork.h"


@interface collectCuisineTBController ()

@property (nonatomic, strong) NSMutableArray *collections;
@property(nonatomic, strong) DataSource *nantouData;

@end


@implementation collectCuisineTBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _nantouData = [DataSource shared];
    [_nantouData getALllMyLoveRestaurants:^(BOOL completion) {
        if (completion) {
            [self.tableView reloadData];
        }
    }];
}





#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nantouData.myLoveAllRestaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    collectCuisineTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //餐廳區域
    cell.nantouStateLbl.text = [_nantouData.myLoveAllRestaurants[indexPath.row] states];
    //餐廳名稱
    cell.restaurantNameLbl.text = [_nantouData.myLoveAllRestaurants[indexPath.row] name];
    //餐廳距離
    cell.kmLbl.text = @"20km";
    //餐廳圓形照片
    //圖片栽剪成圓形
    cell.storeImageView.layer.cornerRadius = cell.storeImageView.frame.size.width/2;
    cell.storeImageView.clipsToBounds = YES;
    //非同步遠端下載image
    NSString *urlStr = [_nantouData.myLoveAllRestaurants[indexPath.row] imagePath];
    [CommunicatorNewWork fetchImage:urlStr withSetImageView:cell.storeImageView
               withPlaceHolderImage:nil withCompletionImage:^(id returnImage) {
                   cell.storeImageView.image = returnImage;
               }];
    
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




@end
