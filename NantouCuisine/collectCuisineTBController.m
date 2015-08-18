
#import "collectCuisineTBController.h"
#import "collectCuisineTBViewCell.h"
#import "DataSource.h"
#import "Restaurant.h"
#import "CommunicatorNewWork.h"
#import "LocationManager.h"
#import "DetailLocalCuisineTBViewCon.h"


@interface collectCuisineTBController ()

@property (nonatomic, strong) NSMutableArray *collections;
@property(nonatomic, strong) DataSource *nantouData;
@property(nonatomic, strong) LocationManager *location;
@end


@implementation collectCuisineTBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //初始化地理位置管理員
    //位置管理員
    _location = [[LocationManager alloc] init];
    //初始DataSource singleTon
    _nantouData = [DataSource shared];
    [_nantouData getALllMyLoveRestaurants:^(BOOL completion) {
        if (completion) {
            [self.tableView reloadData];
        }}];
}
//為了取得我的最愛，所以放在這裡
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_nantouData getALllMyLoveRestaurants:^(BOOL completion) {
    if (completion) {
        [self.tableView reloadData];
    }}];
     [self.tabBarController.tabBar setHidden:NO];
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
    //餐廳名稱
    cell.restaurantNameLbl.text = nil;
    cell.restaurantNameLbl.text = [_nantouData.myLoveAllRestaurants[indexPath.row] name];
    
    //設定文字的斷點
    cell.restaurantNameLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    //設定文字的粗體和大小
    cell.restaurantNameLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    //設定文字的粗體和大小
    cell.nantouStateLbl.font = [UIFont boldSystemFontOfSize:17.0f];

    
    //計算距離及區域
    //取餐廳經緯度
    double latitude = [[_nantouData.myLoveAllRestaurants[indexPath.row] latitude] doubleValue];
    double longitude = [[_nantouData.myLoveAllRestaurants[indexPath.row] longitude] doubleValue];
    //calculate
    [_location LocationZipCodeWithLatitude:latitude withLongitude:longitude withCompletion:^(CLPlacemark *placemark) {
        cell.nantouStateLbl.text = nil;
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



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailLocalCuisineTBViewCon *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_1"];
    //為何加星號??
    vc.restaurantNumber = [_nantouData.myLoveAllRestaurants[indexPath.row] resNumber];
    [self.navigationController pushViewController:vc animated:nil];
}




@end
