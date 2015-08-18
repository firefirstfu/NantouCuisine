
#import "WebViewController.h"
#import "MBProgressHUD.h"

@interface WebViewController ()<UIWebViewDelegate>
//WebView
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //開始轉轉
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //開啟網頁
    NSString *urlString = _webURL;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_theWebView loadRequest:request];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //停止轉轉
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}





@end
