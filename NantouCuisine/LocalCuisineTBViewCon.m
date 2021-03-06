
#import "LocalCuisineTBViewCon.h"
#import "LocalCuisineTBViewCell.h"
#import "DetailLocalCuisineTBViewCon.h"
#import "DataSource.h"
#import "MBProgressHUD.h"
#import "CommunicatorNewWork.h"
#import "RestaurantCollection.h"
#import "LocationManager.h"
#import "NetConnectCheck.h"



@interface LocalCuisineTBViewCon()

@property(nonatomic, strong) DataSource *nantouData;
@property(nonatomic, strong) LocationManager *location;

@property(nonatomic, strong) NetConnectCheck *netConnectCheck;

@end

@implementation LocalCuisineTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    _nantouData = [DataSource shared];
    
    //開始轉轉
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_nantouData getNantouRestaurants:^(BOOL completion) {
        if (completion) {
            [self.tableView reloadData];
            //停止轉轉
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    //位置管理員
    _location = [[LocationManager alloc] init];
    
    //網路監測管理員
    _netConnectCheck = [[NetConnectCheck alloc] init];
    //網路監測Method call back
    [_netConnectCheck networkConnectCheck:nil breakConnect:^{
        UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"連線錯誤"
                                                                          message:@"連線品質不佳，請稍候再試"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        //Alert按鈕物件
        UIAlertAction *alertEnter = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *aciton){
                                                           }];
        //把按鈕加到AlertView上面
        [alertView addAction:alertEnter];
        //把AlertView加到View上面
        [self presentViewController:alertView animated:YES completion:nil];
        //停止轉轉
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } revertConnect:^{
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_nantouData.allRestaruants count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LocalCuisineTBViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //計算距離及區域
    //取餐廳經緯度
    double latitude = [[_nantouData.allRestaruants[indexPath.row] latitude] doubleValue];
    double longitude = [[_nantouData.allRestaruants[indexPath.row] longitude] doubleValue];
    //calculate
    [_location LocationZipCodeWithLatitude:latitude withLongitude:longitude withCompletion:^(CLPlacemark *placemark) {
        cell.nantouStateLbl.text = placemark.locality;
    }];
    
    //calculate user離餐廳距離
    [_location calculateDistanceWithRestaurantLatitude:latitude withRestaurantLongitude:longitude withCompletion:^(CLLocationDistance meters) {
        if (meters > 300) {
            cell.kmLbl.text = nil;
        }else{
            cell.kmLbl.text = [NSString stringWithFormat:@"%.0f公里", meters];
        }
    }];
    
    //設定文字的斷點
    cell.restaurantNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    //設定文字的粗體和大小
    cell.restaurantNameLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    //設定文字的粗體和大小
    cell.nantouStateLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    //餐廳名稱
    cell.restaurantNameLbl.text = [_nantouData.allRestaruants[indexPath.row] name];
    
    //圖片栽剪成圓形
    cell.storeImageView.layer.cornerRadius = cell.storeImageView.frame.size.width/2;
    cell.storeImageView.clipsToBounds = YES;
    
    //非同步遠端下載image
    NSString *urlStr = [_nantouData.allRestaruants[indexPath.row] imagePath];
    [CommunicatorNewWork fetchImage:urlStr withSetImageView:cell.storeImageView
               withPlaceHolderImage:nil withCompletionImage:^(id returnImage) {
                   cell.storeImageView.image = nil;
                   cell.storeImageView.image = returnImage;
               }];
    return cell;
}


#pragma mark - Navigation
//傳值到下一個ViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detailLocal"]) {
        //選擇的row
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        DetailLocalCuisineTBViewCon *targeView = segue.destinationViewController;
        targeView.restaurantNumber =  path.row;
    }
}

//更新資料
- (IBAction)refresh:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_netConnectCheck networkConnectCheck:nil breakConnect:^{
        UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"連線錯誤"
                                                                          message:@"連線品質不佳，請稍候再試"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        //Alert按鈕物件
        UIAlertAction *alertEnter = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *aciton){
                                                           }];
        //把按鈕加到AlertView上面
        [alertView addAction:alertEnter];
        //把AlertView加到View上面
        [self presentViewController:alertView animated:YES completion:nil];
        //停止轉轉
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } revertConnect:^{
        [_nantouData getNantouRestaurants:^(BOOL completion) {
            if (completion) {
                [self.tableView reloadData];
                //停止轉轉
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
    }];

}

//切換Master(只能往回跳)—>Exit出口方法
-(IBAction) backToMaster:(UIStoryboardSegue*)segue{
}


@end
