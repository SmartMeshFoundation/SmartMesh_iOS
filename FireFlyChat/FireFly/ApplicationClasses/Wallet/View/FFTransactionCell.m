//
//  FFTransactionCell.m
//  SmartMesh
//
//  Created by Megan on 2017/10/17.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFTransactionCell.h"

@interface FFTransactionCell ()

@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *recordLbl;
@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation FFTransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    _addressLbl = [[UILabel alloc] init];
    _addressLbl.frame = CGRectMake(20, 10, DDYSCREENW - 40, 20);
    _addressLbl.font = NA_FONT(14);
    _addressLbl.textColor = LC_RGB(151,151,151);
    _addressLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _addressLbl.text = @"12345";
    
    _recordLbl = [[UILabel alloc] init];
    _recordLbl.frame = CGRectMake(20, _addressLbl.ddy_bottom + 12, DDYSCREENW - 40, 20);
    _recordLbl.font = NA_FONT(14);
    _recordLbl.textColor = LC_RGB(151,151,151);
    _recordLbl.text = @"12345";
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.frame = CGRectMake(20, _recordLbl.ddy_bottom + 12, DDYSCREENW - 40, 20);
    _timeLbl.font = NA_FONT(14);
    _timeLbl.textColor = LC_RGB(151,151,151);
    _timeLbl.text = @"12345";
    
    [self.contentView addSubview:_addressLbl];
    [self.contentView addSubview:_recordLbl];
    [self.contentView addSubview:_timeLbl];
    
}

//- (void)setTransactionItem:(NATransactionItem *)transactionItem
//{
//    NSString *addressStr = transactionItem.address;
//    _addressLbl.attributedText = [self setWithText:addressStr regexText:@"地址:"];
//
//    _recordLbl.attributedText =[self setWithText:LC_NSSTRING_FORMAT(@"%@ %@", transactionItem.value, (_type == 0 ? @"ETH" : @"FFT")) regexText:@"金额:"];
//
//    NSString *timeLine = [self dateStringByTimeStamp:transactionItem.dateline];
//    _timeLbl.attributedText = [self setWithText:timeLine regexText:@"时间:"];
//
//}

- (void)setType:(NSInteger)type
{
    _type = type;
}

- (NSString *) dateStringByTimeStamp:(NSString *)timeStamp
{
    if ([timeStamp isEqualToString:@""]) {
        return @"";
    }
    
    NSTimeInterval time = [timeStamp doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

- (NSMutableAttributedString *)setWithText:(NSString *)text regexText:(NSString *)regex
{
    NSString *addressOrg = LC_NSSTRING_FORMAT(@"%@ %@",regex, text);
    
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:addressOrg];
    [attributeText addAttribute:NSForegroundColorAttributeName value:APP_MAIN_COLOR range:[addressOrg rangeOfString:regex]];
    
    return attributeText;
    
}

- (void)updateFrame
{
    [_recordLbl sizeToFit];
    
    _addressLbl.ddy_w = DDYSCREENW - 3 * 10 - _recordLbl.ddy_w;
    
}


@end
