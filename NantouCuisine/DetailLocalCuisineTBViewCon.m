
#import "DetailLocalCuisineTBViewCon.h"
#import "DetailLocalCuisineTBViewCell.h"
#import "WebViewController.h"

#import "CommunicatorNewWork.h"
#import "MapViewCon.h"
#import "DataSource.h"
#import <Social/Social.h>



@interface DetailLocalCuisineTBViewCon ()

@property (nonatomic, strong) DetailLocalCuisineTBViewCell *cell;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) NSMutableArray *collections;
@property(nonatomic, strong) DataSource *nantouData;
@property (weak, nonatomic) IBOutlet UISwitch *myLoveChoice;
@property(nonatomic, strong) Restaurant *tmpRestaurant;

@end


@implementation DetailLocalCuisineTBViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    //自適化TableViewCell高度
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //SingleTon物件
    _nantouData = [DataSource shared];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tmpRestaurant = [[Restaurant alloc] init];
    _tmpRestaurant = _nantouData.allRestaruants[_restaurantNumber];
    if (_tmpRestaurant.collected == YES) {
        [_myLoveChoice setOn:YES];
    }else{
        [_myLoveChoice setOn:NO];
    }
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
    _cell.restaurantNameLbl.text = [_nantouData.allRestaruants[_restaurantNumber] name];
    //餐廳地址
    _cell.addressLbl.text = [_nantouData.allRestaruants[_restaurantNumber] address];
    //餐廳電話
     _cell.phoneNumberLbl.text = [_nantouData.allRestaruants[_restaurantNumber] phoneNumber];
    //餐廳網址
    _cell.webSiteLbl.text = [_nantouData.allRestaruants[_restaurantNumber] webSite];

    //如果沒提供網址，則網址Row隱藏
    if ([_cell.webSiteLbl.text length] == 0) {
        _cell.webSiteLbl.text = @"未提供";
        if (indexPath.row == 5) {
        }
    }
    
    //餐廳簡述
    _cell.descriptionLbl.editable = NO;
    _cell.descriptionLbl.text  = [[_nantouData.allRestaruants[_restaurantNumber] introduction] stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    //餐廳照片
    _cell.storeImageView.contentMode = UIViewContentModeScaleToFill;
    //非同步遠端下載image
    NSString *urlStr = [_nantouData.allRestaruants[_restaurantNumber] imagePath];
    [CommunicatorNewWork fetchImage:urlStr withSetImageView:_cell.storeImageView
               withPlaceHolderImage:nil withCompletionImage:^(id returnImage) {
                   _cell.storeImageView.image = returnImage;
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
            [self shareMyLove];
            break;
        default:
            break;
    }
}

//分享到Facebook?????
-(void) shareMyLove{
    //好像一次只能跳出一個分享-->這裡是Facebook
    SLComposeViewController *socialControl = [SLComposeViewController
                                              composeViewControllerForServiceType:SLServiceTypeFacebook];
    // add initial text
    [socialControl setInitialText:[_nantouData.allRestaruants[_restaurantNumber] address]];
    // add an image
    //非同步遠端下載image
    NSString *urlStr = [_nantouData.allRestaruants[_restaurantNumber] imagePath];
    [CommunicatorNewWork fetchImage:urlStr withSetImageView:_cell.storeImageView
               withPlaceHolderImage:nil withCompletionImage:^(id returnImage) {
                   [socialControl addImage:returnImage];
               }];
    // add a URL
    [socialControl addURL:[NSURL URLWithString:[_nantouData.allRestaruants[_restaurantNumber] webSite]]];
    // present controller
    [self presentViewController:socialControl animated:YES completion:nil];
    
  
}


//StoryBoard跳轉
-(void)gotAnother{
    //沒有segue方式的傳值
    MapViewCon *mapViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"mapViewCon"];
    mapViewCon.restaurantNumber = _restaurantNumber;
    [self.navigationController pushViewController:mapViewCon animated:NO];
}


//傳值到下一個ViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotToWeb"]) {
        WebViewController *targeView = segue.destinationViewController;
        //餐廳網址
        targeView.webURL = [_nantouData.allRestaruants[_restaurantNumber] webSite];
    }
}

- (IBAction)choiceMyLoveButton:(id)sender {
    _tmpRestaurant = _nantouData.allRestaruants[_restaurantNumber];
    if (_myLoveChoice.isOn == YES) {
        _tmpRestaurant.collected = YES;
        [_nantouData saveMyLoveToPlsit:[_tmpRestaurant name] choiceOfBool:YES];
        
    }else{
        _tmpRestaurant.collected = NO;
        [_nantouData saveMyLoveToPlsit:[_tmpRestaurant name] choiceOfBool:NO];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
