//
//  SubPageViewController.m
//  ADSSegmentedButtonDemo
//
//  Created by Andrew Shen on 2016/10/18.
//  Copyright © 2016年 Mintcode.com. All rights reserved.
//

#import "SubPageViewController.h"
#import <Masonry/Masonry.h>

@interface SubPageViewController ()

@end

@implementation SubPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.page];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)page {
    if (!_page) {
        _page = [UILabel new];
        _page.font = [UIFont systemFontOfSize:30];

    }
    return _page;
}
@end
