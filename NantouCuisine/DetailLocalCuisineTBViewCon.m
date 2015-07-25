
#import "DetailLocalCuisineTBViewCon.h"
#import "DetailLocalCuisineTBViewCell.h"
#import <UIImageView+AFNetworking.h>

#import "Restaurant.h"

@interface DetailLocalCuisineTBViewCon ()

@property(nonatomic, strong) DetailLocalCuisineTBViewCell *cell;
@property(nonatomic, assign) CGFloat imageHeight;

@end


@implementation DetailLocalCuisineTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
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
    //餐廳簡述
    _cell.descriptionLbl.text  = _restaurant.introduction;
    
    
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
    UITableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_2"];
    [self.navigationController pushViewController:vc animated:NO];
}


//自訂TableViewCell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        if (_imageHeight <= 10) {
             _imageHeight = _cell.storeImageView.frame.size.height - 1.0;
        }
        return _imageHeight;
    }else if (indexPath.row == 1){
        return 35.0f;
    }else if (indexPath.row == 6){
        return 200.0f;
    }else{
        return 50.0f;
    }
}



/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
