
#import "WebViewController.h"

@interface WebViewController ()

//WebView
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"http://goo.gl/Edo9wH";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_theWebView loadRequest:request];
    
}



/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
