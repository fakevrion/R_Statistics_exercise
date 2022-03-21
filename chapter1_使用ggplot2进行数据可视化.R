##1.2 第一??? 导入tidyverse???
library(tidyverse)


##1.2.1 列出mpg
mpg

##1.2.2 绘制mpg的图形，散点???
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))

##绘图模块
ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPING>))

##1.2.4 练习
##(1) 运行ggplot(data = mpg)，你会看到什么？
ggplot(data = mpg)

##(2) 数据集mpg 中有多少行？多少列？
nrow(mpg)
ncol(mpg)
mpg

##(3) 变量drv 的意义是什么？使用?mpg 命令阅读帮助文件以找出答案???
?mpg

##(4) 使用hwy 和cyl 绘制一张散点图???
ggplot(data = mpg) + geom_point(mapping = aes(x = cyl, y = drv))

##(5) 如果使用class 和drv 绘制散点图，会发生什么情况？为什么这张图没什么用处？
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))

##1.3 图形属性映???
##将class映射为的不同颜色
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

##将class映射为点的不同大小
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

##点的透明度
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

##点的形状
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

##所有点的属性
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), shape = 15)

##1.3练习

##(1) color应为几何对象的图形属性，在geom_point里面

##?mpg

##(3) 变量类型映射
##color渐变
##分类：
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
##连续：
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ))
##size
##分类：
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
##连续：
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = displ))
##shape：
##分类：
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
##连续：
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = displ))
##! A continuous variable can not be mapped to shape

##(4) 同一个变量映射多个属性，见（3）

##(5) stroke: thickness of border
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), shape = 5, stroke = 9)

##
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

##1.5 分面
##facet_wrap() 分类变量
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

##facet_grid() 两个变量
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

##仅进行一个变量分类
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
##效果等同于上述代码
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cyl, ncol = 4)


##1.5练习
##(1) 连续变量分面，会将连续变量看作分类变量
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ hwy)

##(2) 空白单元的意义
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

##(3) .的作用
##仅列分面
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
##仅行分面
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

##(4) 图形属性与分面的优劣势

##(5) ?facet_wrap

##(6) facet_grid() 一般应该将具有更多唯一值的变量放在列上


##1.6 几何对象
##点几何对象
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
##平滑曲线几何对象
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

##不同线型
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

##两种几何对象
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

##group属性
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

##多个几何对象
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

##简化，将映射传递给ggplot()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

##映射放在几何对象中，局部映射
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

##不同图层不同的数据
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"), 
    se = FALSE
  )

##1.6 练习
##(1) 折线图：geom_line; 箱线图：geom__boxplot; 直方图：geom_histogram; 分区图：geom_grid

##(2) 全局颜色分类
ggplot(
  data = mpg,
  mapping = aes(x = displ, y = hwy, color = drv)
) +
  geom_point() +
  geom_smooth(se = FALSE)

##(3) show.legend = FALSE 隐藏图例

##(4) se 可信区间

##(5) 无区别

##(6) 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(
    mapping = aes(group = drv), 
    show.legend = FALSE, 
    se =FALSE
  )

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(
    se = FALSE
  )

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(
    mapping = aes(color = drv)
  ) +
  geom_smooth()

ggplot(data =  mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(
    mapping = aes(linetype = drv),
    se = FALSE
  )

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point()
