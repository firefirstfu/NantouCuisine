
#import "DetailLocalCuisineTBViewCon.h"
#import "DetailLocalCuisineTBViewCell.h"
#import "WebViewController.h"

#import "CommunicatorNewWork.h"
#import <UIImageView+AFNetworking.h>

#import "Restaurant.h"
#import "MapTBViewCon.h"


@interface DetailLocalCuisineTBViewCon ()

@property (nonatomic, strong) DetailLocalCuisineTBViewCell *cell;
@property (nonatomic, assign) CGFloat imageHeight;

@property (nonatomic, strong) NSMutableArray *collections;

@end


@implementation DetailLocalCuisineTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自適化TableViewCell高度
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //取得各別的Cell的Identifier
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    //和cell取得關聯
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //設定文字的粗體和大小
    _cell.restaurantNameLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    _cell.addressLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    _cell.phoneNumberLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    _cell.webSiteLbl.font = [UIFont boldSystemFontOfSize:17.0f];
    _cell.descriptionLbl.font = [UIFont boldSystemFontOfSize:17.0f];


    //餐廳名稱
    _cell.restaurantNameLbl.text = _restaurant.name;
    //餐廳地址
    _cell.addressLbl.text = _restaurant.address;
    //餐廳電話
    _cell.phoneNumberLbl.text = _restaurant.phoneNumber;
    //餐廳網址
    _cell.webSiteLbl.text = _restaurant.webSite;
    //如果沒提供網址，則網址Row隱藏
    if ([_cell.webSiteLbl.text length] == 0) {
        _cell.webSiteLbl.text = @"未提供";
        if (indexPath.row == 5) {
//            _cell.hidden = YES;
        }
    }
    //餐廳簡述
    //不可編輯
    _cell.descriptionLbl.editable = NO;
    _cell.descriptionLbl.text  = [_restaurant.introduction stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    
    //餐廳照片
    _cell.storeImageView.contentMode = UIViewContentModeScaleToFill;
    //圖片網址有中文的字串要先編碼為UTF-8的格式
    NSString *urlStr = [_restaurant.imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak DetailLocalCuisineTBViewCell *weakCell = _cell;
    [ _cell.storeImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"1.jpg"]
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                            weakCell.storeImageView.image = image;
                                            [weakCell setNeedsLayout];
                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                            _cell.storeImageView.image = [UIImage imageNamed:@"1.jpg"];
                                        }];
    //segmented選單增加Method
    [_cell.selectInformationMenu addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    return _cell;
}

//segmented的Method
-(void) segmentedAction:(id) sender{
    switch ([sender selectedSegmentIndex]) {
        case 1:
            //StoryBoard跳轉
            [self gotAnother];
            break;
        case 2:
            break;
        default:
            break;
    }
}

//StoryBoard跳轉
-(void)gotAnother{
    //沒有segue方式的傳值
    MapTBViewCon *viewCtrl2 = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_2"];
    viewCtrl2.restaurant = _restaurant;
    [self.navigationController pushViewController:viewCtrl2 animated:NO];
}


//傳值到下一個ViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotToWeb"]) {
        WebViewController *targeView = segue.destinationViewController;
        //餐廳網址
        targeView.webURL = _restaurant.webSite;
    }
}

@end
