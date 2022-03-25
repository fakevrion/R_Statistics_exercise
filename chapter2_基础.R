##2.1 代码基础

##2.2 对象名称
##对象名称必须以字母开头，并且只能包含字母、数字、_ 和.。

##2.3 函数调用
seq(1, 10)
seq(1, 10, length.out = 5)

library(tidyverse)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

