
#import "WebViewController.h"

@interface WebViewController ()

//WebView
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = _webURL;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_theWebView loadRequest:request];
    
}


@end
