# 仿写知乎日报 iOS APP

## 编译环境:  
Xcode 7.0以上  
iOS 9.0以上

## 运行效果
![](https://github.com/hshpy/ZhiHuDaily-2.0/blob/master/zhihu.gif)

## 部分实现过程

设计模式：MVVM

***

顶部的轮播视图采用最常见的做法，就是在原数组的前后再插入一个元素，例5,1,2,3,4,5,1,然后通过改变collectionview的contentoffset属性。

***

轮播视图里面有一层渐变图层，如果调用addSubLayer方法把CAGradientLayer的实例加入的话，当我们下拉刷新时会触发景深效果会改变图层的bounds属性(动画属性)，苹果**只对子图层的动画属性改变自动会触发隐式动画**，动画效果造成与我们下拉时不一致不协调；既然添加子图层没办法，那就往根图层想办法了，每个UIView的实例都一个CALayer的实例作为根图层，CAGradientLayer又是CALayer的子类,所以新建一个CoverView继承UIView重写下面方法，这样CoverView的实例的根图层就是渐变图层了，改变bounds也不会触发隐式动画。

	+ (Class)layerClass {
	    return [CAGradientLayer class];
	}

***

为了配合实现景深效果，UITableView加入了一个透明的tableHeaderView，这样导致了后面轮播视图的事件响应都失效了，hitTest视图都是tableview，所以给UITableview写个category添加了个disableTableHeaderView属性来判断是否响应tableviewHeaderView的事件。

	- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	   if (self.disableTableHeaderView) {
	       CGRect frame = self.tableHeaderView.frame;
	       if (CGRectContainsPoint(frame, point)) {
	           return NO;
	       }
	   }
	   return YES;
	}


***

因为官方后台接口给的图像大小是150*150,但是官方app的cell里面的image并非正方形，可见出经过处理的，同时cell里面的subview也不用响应事件，所以项目里的UITableViewCell都是采用直接给cell.contentView.layer.contents赋值一张画好的CGImage，快速滑动时接近60fps。

***

