
/** 解锁背景色 */
#define lockViewBgColor DDYRGBA(13, 52, 90, 1)

/** 单个圆背景色 */
#define circleBgColor [UIColor clearColor]

/** 普通状态外空心圆颜色 */
#define outCircleNormalColor DDYRGBA(241, 241, 241, 1)

/** 选中状态外空心圆颜色 */
#define outCircleSelectedColor DDYRGBA(34, 178, 246, 1)

/** 错误状态外空心圆颜色 */
#define outCircleErrorColor DDYRGBA(254, 82, 92, 1)

/** 普通状态内实心圆颜色 */
#define inCircleNormalColor [UIColor clearColor]

/** 选中状态内实心圆颜色 */
#define inCircleSelectedColor DDYRGBA(34, 178, 246, 1)

/** 错误状态内实心圆颜色 */
#define inCircleErrorColor DDYRGBA(254, 82, 92, 1)

/** 普通状态指示三角颜色 */
#define trangleNormalColor [UIColor clearColor]

/** 选中状态指示三角颜色 */
#define trangleSelectedColor DDYRGBA(34, 178, 246, 1)

/** 错误状态指示三角颜色 */
#define trangleErrorColor DDYRGBA(254, 82, 92, 1)

/** 指示三角形的边长 */
#define trangleLength 10.0f

/** 普通状态连线颜色 */
#define LineNormalColor DDYRGBA(34, 178, 246, 1)

/** 错误状态连线颜色 */
#define lineErrorColor DDYRGBA(254, 82, 92, 1)

/** 连线宽度 */
#define lockLineWidth 1.0f

/** 单个圆的半径 */
#define circleRadius 30.0f

/** 单个圆的圆心 */
#define circleCenter CGPointMake(kCircleRadius, kCircleRadius)

/** 空心圆圆环宽度 */
#define outCircleWidth 1.0f

/** 头部infoView 圆的半径 */
#define circleInfoRadius 5

/** 内部实心圆占空心圆的比例系数 */
#define circleRadio 0.4

/** 整个解锁View居中时距离屏幕左边和右边的距离 */
#define lockViewEdgeMargin 30.0f

/** 连接的圆最少条件 */
#define lockCircleLeast 4

/** 错误状态下回显的时间 */
#define lockDisplayTime 1.0f

/** 普通状态下文字提示的颜色 */
#define lockTipNormalColor DDYRGBA(241, 241, 241, 1)

/** 警告状态下文字提示的颜色 */
#define lockTipWarningColor DDYRGBA(254, 82, 92, 1)

/** 绘制解锁界面准备好时提示 多语言可替换 */
#define lockTipBeforeSet @"绘制解锁图案"

/** 设置时连线最少个数提示 多语言可替换 */
#define lockTipConnectLess [NSString stringWithFormat:@"最少连接%d个点，请重新输入", lockCircleLeast]

/** 确认图案，提示再次绘制 */
#define lockTipDrawAgain @"请再次绘制解锁图案"

/** 设置手势密码成功提示 */
#define lockTipSuccess @"设置成功"

/** 再次绘制不一致提示文字 */
#define lockTipDrawAgainError @"与上次绘制不一致，请重新绘制"

/** 验证模式请输入原手势密码提示文字 */
#define lockTipOldGesture @"请输入原手势密码"

/** 登录模式请输入手势密码提示文字 */
#define lockTipLoginTip @"请输入手势密码"

/** 密码错误提示 */
#define lockTipVerifyError @"密码错误"

/** 设置模式title */
#define lockTitleSetting @"设置手势密码"

/** 登录模式title */
#define lockTitleLogin @" "

/** 验证模式title */
#define lockTitleVerify @"验证手势密码"

/** 第一个手势存储偏好设置key */
static NSString *const lockOneKey  = @"lockOneKey";

/** 最终手势存储偏好设置key */
static NSString *const lockEndKey  = @"lockEndKey";



#import "DDYCircleView.h"
#import "DDYLockView.h"



