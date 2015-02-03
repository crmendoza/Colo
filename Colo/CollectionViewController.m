//
//  CollectionViewController.m
//  Colo
//
//  Created by Wongzigii on 11/25/14.
//  Copyright (c) 2014 Wongzigii. All rights reserved.
//

#import "CollectionViewController.h"
#import "ColorCell.h"
#import "Parser.h"
#import <QuartzCore/QuartzCore.h>
#import "BouncePresentAnimation.h"
#import "NormalDismissAnimation.h"
#import "SwipeUpInteractionTransition.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#import "BaseNavigationController.h"
#import "MMPickerView.h"

#define kDeviceWidth  self.view.frame.size.width
#define kDeviceHeight self.view.frame.size.height
#define CocoaJSHandler       @"mpAjaxHandler"
static NSString *JSHandler;
static NSString *CellIdentifier = @"ColorCell";

@interface CollectionViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, ModalViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic)  UITableView    *tableView;
@property (strong, nonatomic)  UIView         *bottomView;
@property (strong, nonatomic)  UIButton       *settingsButton;
@property (strong, nonatomic)  UIButton       *chooseButton;

@property (copy, nonatomic)    NSMutableArray *objectArray;
@property (copy, nonatomic)    NSMutableArray *titleArray;
@property (copy, nonatomic)    NSMutableArray *likesArray;
@property (copy, nonatomic)    NSArray        *pickerArray;
@property (copy, nonatomic)    NSString       *selectedString;

@property (strong, nonatomic) BouncePresentAnimation *presentAnimation;
@property (strong, nonatomic) NormalDismissAnimation *dismissAnimation;
@property (strong, nonatomic) SwipeUpInteractionTransition *transitionController;

@property (nonatomic, strong)  UIWebView *webView;
@property (nonatomic, strong)  NSString *HTML;
@property (nonatomic, strong)  UIButton *parseButton;
@property (nonatomic, strong)  UIButton *reloadButton;
@property (nonatomic, strong)  UIActivityIndicatorView *activityView;
@property (nonatomic, strong)  UIView *dimBackgroundView;

@end

@implementation CollectionViewController
#pragma mark - LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _presentAnimation     = [BouncePresentAnimation new];
        _dismissAnimation     = [NormalDismissAnimation new];
        _transitionController = [SwipeUpInteractionTransition new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //inner

    
    //outer
    self.tableView = [UITableView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 144.0;
    self.tableView.bounces = YES;
    [self.tableView registerClass:[ColorCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.dimBackgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.dimBackgroundView.backgroundColor = [UIColor blackColor];
    self.dimBackgroundView.layer.opacity = 0.3;
    [self.tableView addSubview:self.dimBackgroundView];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView addSubview:self.activityView];
    [self.activityView startAnimating];
    
    self.bottomView = [UIView new];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    self.settingsButton = [UIButton new];
    [self.settingsButton setImage:[UIImage imageNamed:@"gear.png"] forState:UIControlStateNormal];
    self.settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomView addSubview:self.settingsButton];
    [self.settingsButton addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    
    self.chooseButton = [UIButton new];
    [self.chooseButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    self.chooseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomView addSubview:self.chooseButton];
    [self.chooseButton addTarget:self action:@selector(triggerUIPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraints];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, kDeviceWidth, kDeviceHeight - 49)];
    self.webView.backgroundColor = [UIColor yellowColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://color.adobe.com/zh/explore/most-popular/?time=all"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
}

- (void)settings
{
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    vc.delegate = self;
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.transitionController wireToViewController:vc];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)triggerUIPickerView
{
    self.pickerArray = @[@"Dansk", @"Deutsch", @"English", @"Español", @"Français", @"Italiano", @"Nederlands", @"Norsk", @"Polski", @"Português", @"Suomi", @"Svenska", @"Türkçe", @"Pусский", @"繁體中文", @"日本語", @"한국어"];
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:self.pickerArray
                           withOptions:@{MMbackgroundColor: [UIColor blackColor],
                                         MMtextColor: [UIColor whiteColor],
                                         MMtoolbarColor: [UIColor blackColor],
                                         MMbuttonColor: [UIColor whiteColor],
                                         MMfont: [UIFont systemFontOfSize:18],
                                         MMvalueY: @3,
                                         MMselectedObject:_selectedString}
                            completion:^(NSString *selectedString) {
                                
                                //_label.text = selectedString;
                                _selectedString = selectedString;
                            }];
}

- (void)addConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView, _bottomView, _settingsButton, _chooseButton, _activityView);
    
    NSString *format;
    NSArray *constraintsArray;
    
    format = @"V:|[_tableView][_bottomView(49)]|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
    
    format = @"H:|[_tableView]|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
    
    format = @"H:|[_bottomView]|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
    
    [_tableView addConstraint:[NSLayoutConstraint constraintWithItem:_activityView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_tableView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f
                                                            constant:0.0f]];
    
    [_tableView addConstraint:[NSLayoutConstraint constraintWithItem:_activityView
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_tableView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f
                                                            constant:0.0f]];

    
    
    //settings button
    format = @"V:[_settingsButton(20)]";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
    
    [_bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_settingsButton
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_bottomView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    //choose button
    format = @"V:[_chooseButton(17)]";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
    
    [_bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_chooseButton
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_bottomView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0f
                                                             constant:0.0f]];
    
    format = @"H:|-[_chooseButton(17)]";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [_bottomView addConstraints:constraintsArray];
    
    format = @"H:[_settingsButton(20)]-|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [_bottomView addConstraints:constraintsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.tableView setDelegate:nil];
    [self.tableView setDataSource:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_objectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //http://objccn.io/issue-1-2/#separatingconcerns
    [cell configureForColor:[_objectArray objectAtIndex:indexPath.row]];
    
    //Auto Layout
    [cell setNeedsUpdateConstraints];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell.contentView layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.delegate = self;
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.transitionController wireToViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}

#pragma mark - ModalViewControllerDelegate
-(void)modalViewControllerDidClickedDismissButton:(ModalViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
//statusBar animation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0 && scrollView.tracking == YES){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.f;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int number = 0;
    switch (component) {
        case 0:
            number = 17;
            break;
        case 1:
            number = 3;
            break;
    }
    return number;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string;
    NSArray *titleArray = @[@"Dansk", @"Deutsch", @"English", @"Español", @"Français", @"Italiano", @"Nederlands", @"Norsk", @"Polski", @"Português", @"Suomi", @"Svenska", @"Türkçe", @"Pусский", @"繁體中文", @"日本語", @"한국어"];
    NSArray *popularityArray = @[@"周", @"月", @"全部"];
    switch (component) {
        //Country
        case 0:
            string = [titleArray objectAtIndex:row];
            break;
        //Popularity
        case 1:
            string = [popularityArray objectAtIndex:row];
            break;
    }
    return string;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    JSHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"parser"
                                                                          withExtension:@"js"]
                                         encoding:NSUTF8StringEncoding
                                            error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:JSHandler];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[[request URL] scheme] lowercaseString] isEqual:@"mpajaxhandler"]) {
        NSString *htmlString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        self.HTML = htmlString;
        //[self saveDataToUserDefault:htmlString];
        //NSLog(@"self.html : %@",self.HTML);

        _objectArray = [[NSMutableArray alloc] initWithArray:[Parser groupedTheArray:[Parser parseWithHTMLString:self.HTML]
                                                                       andTitleArray:[Parser parsewithTitle:self.HTML]
                                                                        andLikeArray:[Parser parsewithLikes:self.HTML]]];
        
        
        [self.tableView reloadData];
        [self.dimBackgroundView removeFromSuperview];
        [self.activityView stopAnimating];
        return NO;
    }
    return YES;
}


@end