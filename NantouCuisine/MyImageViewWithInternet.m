//客制化非同步式下載圖片的ImageView
#import "MyImageViewWithInternet.h"

@interface MyImageViewWithInternet()

{
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation MyImageViewWithInternet

//override原本的Metood
//所有view都會實作的方法

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    //Prepare indicatorView
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    indicatorView.hidesWhenStopped = YES;
    indicatorView.color = [UIColor blueColor];
    [self addSubview:indicatorView];
    return self;
}

//實作主要的功能
//從外面接一個URL
-(void) loadImageWithURL:(NSURL*)url{
    //先開始轉轉轉
    [indicatorView startAnimating];
    //create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:60.0];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    //create 下載的tast
    //有completionHandler的不用自己實作block
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                        //轉成main_queue，因為這裡是在backgroud thread執行
                                                        //可以下中斷點看看是不是background thread
                                                        if (error) {
                                                            NSLog(@"Error: %@", error.description);
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [indicatorView stopAnimating];
                                                            });
                                                        }else{
                                                            //從暫存的locaiton拿出來，then轉成UIImage
                                                            NSLog(@"URL: %@", location.description);
                                                            NSData *data = [NSData dataWithContentsOfURL:location];
                                                            UIImage *image = [UIImage imageWithData:data];
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                self.image = image;
                                                                [indicatorView stopAnimating];
                                                            });
                                                        }}];
    //要下這行code，才會開始跑
    [task resume];
}



@end
