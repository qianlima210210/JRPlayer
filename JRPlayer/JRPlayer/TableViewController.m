//
//  TableViewController.m
//  JRPlayer
//
//  Created by maqianli on 2018/9/21.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@import Masonry;
@interface TableViewController ()

@property (nonatomic, strong) NSArray *urlArray;
@property BOOL isHideStatusBar;

@end

@implementation TableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _urlArray = @[@"http://ohjdda8lm.bkt.clouddn.com/course/sample1.mp4",
                      @"http://v.dansewudao.com/502718a3e0a24673b2afa1c5c27cd301/771b26823ac64631b8977a718610b779-9f4d50aeba651a86d2b45f89f4799f31-sd.mp4",
                  @"http://ohjdda8lm.bkt.clouddn.com/course/sample1.mp4",
                      @"http://v.dansewudao.com/49e9f074e890493fa1f1677ca4f2faec/69e262b1b2014ff3afbb4052b1829d7a-7d56bc62083a11837ece71958f513034-sd.mp4",
                        @"http://ohjdda8lm.bkt.clouddn.com/course/sample1.mp4"
                      ];
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedNotificationOfHideStatusBar:) name:NotificationOfHideStatusBar object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onReceivedNotificationOfShowStatusBar:) name:NotificationOfShowStatusBar object:nil];
}

-(void)onReceivedNotificationOfHideStatusBar:(NSNotification*)notificatiopn {
    _isHideStatusBar = YES;

    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)onReceivedNotificationOfShowStatusBar:(NSNotification*)notificatiopn {
    _isHideStatusBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _urlArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    if (cell.playerView) {
        [cell.playerView removeFromSuperview];
    }
    
    // Configure the cell...
    NSString *urlStr = [_urlArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:urlStr];
    JRPlayerView * playerView = [JRPlayerView playerViewWithURL:url];
    playerView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:playerView];
    
    cell.playerView = playerView;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return _isHideStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}


@end
