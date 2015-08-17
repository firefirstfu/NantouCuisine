
#import "WebViewController.h"
#import "MBProgressHUD.h"

@interface WebViewController ()<UIWebViewDelegate>
//WebView
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //開啟網頁
    NSString *urlString = _webURL;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_theWebView loadRequest:request];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //開始轉轉
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //停止轉轉
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //產生一個AlertView(打底)
    UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"訊息"
                                                                      message:@"請檢查網路連線..."
                                                               preferredStyle:UIAlertControllerStyleAlert];
    //作1個Alert按鈕物件
    UIAlertAction *alertEnter = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *aciton){
                                                       }];
    //把按鈕加到AlertView上面
    [alertView addAction:alertEnter];
    //把AlertView加到View上面
    [self presentViewController:alertView animated:YES completion:nil];
}




@end
