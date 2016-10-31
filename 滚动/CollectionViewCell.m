//
//  CollectionViewCell.m
//  滚动
//
//  Created by qianfeng on 16/9/30.
//  Copyright © 2016年 cz. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation CollectionViewCell

- (void)setModel:(Model *)model
{
    
    _model = model;
//    NSLog(@"设置第%@个Model", model.imageName);
    self.titleLabel.text = model.title;
    self.bgImageView.image = [UIImage imageNamed:model.imageName];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
