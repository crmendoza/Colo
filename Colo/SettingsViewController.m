//
//  SettingsViewController.m
//  Colo
//
//  Created by Wongzigii on 1/27/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import "SettingsViewController.h"
#import <UIKit/UIKit.h>

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self addConstraints];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(done)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:14.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [rightButton setTintColor:[UIColor redColor]];
    self.navigationItem.title = @"帮助";
}

- (void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addConstraints
{
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);
    NSString *format;
    NSArray *constraintsArray;
    
    format = @"V:|[_tableView]|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
    
    format = @"H:|[_tableView]|";
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraintsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    //常见问题
                    break;
                case 1:
                    //联系我
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:wongzigii@outlook.com"]];

                    break;
                case 2:
                    //优酷演示视频
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.weibo.com/wongzigii"]];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            
            break;
        case 3:
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 3;
            break;
        case 2:
            number = 2;
            break;
        case 3:
            number = 1;
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"请前往系统设置";
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"常见问题";
                    break;
                case 1:
                    cell.textLabel.text = @"联系我";
                    break;
                case 2:
                    cell.textLabel.text = @"演示视频";
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"微博关注我";
                    break;
                case 1:
                    cell.textLabel.text = @"在App Store给Colo评分";
                    break;
                default:
                    break;
            }
            break;
        case 3:
            cell.textLabel.text = @"献给曾经帮助我和支持我的人";
            break;
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleString;
    switch (section) {
        case 0:
            titleString = @"设置";
            break;
        case 1:
            titleString = @"支持";
            break;
        case 2:
            titleString = @"关于";
            break;
        case 3:
            titleString = @"特别鸣谢";
            break;
        default:
            break;
    }
    return titleString;
}

@end
