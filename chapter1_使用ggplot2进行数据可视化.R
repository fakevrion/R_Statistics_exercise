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
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

