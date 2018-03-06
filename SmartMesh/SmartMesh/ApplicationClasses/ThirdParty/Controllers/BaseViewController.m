//  Created by R on 18/3/6.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    if (self.navigationController&&[self.navigationController.viewControllers count] > 1) {
       
        UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        [self.navigationItem setLeftBarButtonItem:aBarButtonItem];
    }
    
    // Do any additional setup after loading the view.
}

- (void)back {
    if (![self isNavigationBack]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  子类化返回事件重写
 *
 *  @return YES则可以返回，NO则不能返回
 */
- (BOOL)isNavigationBack {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
