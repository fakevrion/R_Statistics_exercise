##chapter_3 使用dplyr进行数据转换

##3.1.1 主备工作
library(nycflights13)
library(tidyverse)

flights
View(flights)

##int、dbl、chr、dttm、lgl、fctr、data

##3.1.3 dplyr基础
##按值筛选规则 filter()
##对行进行重新排序 arrange()
##对名称选取变量 select()
##使现有变量的函数创建新变量 mutata()
##将多个值总结为一个摘要统计量 summarize()
##与group_by() 联用

##3.2 使用 filter() 筛选行
filter(flights, month == 1, day == 1)

jan1 <- filter(flights, month == 1, day == 1)

(dec25 <- filter(flights, month == 12, day == 25))

##3.2.1 比较运算符
## >、>=、<、<=、!=（不等于）和==（等于）

##比较浮点数是否相等时，不能使用==，而应该使用near()
near(sqrt(2) ^ 2, 2)
near(1 / 49 * 49, 1)
near(2.1, 2) ##False

##3.2.2 逻辑运算符
##& 表示“与”、| 表示“或”、! 表示“非”。
filter(flights, month == 11 | month == 12)
filter(filghts, month == 11 | 12) ##1月出发的所有航班
nov_dec <- filter(flights, month %in% c(11, 12))

##德摩根定律将复杂的筛选条件进行简化：!(x & y) 等价于!x | !y、!(x | y) 等价于!x & !y

##延误时间（到达或出发）不多于2 小时的航班
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

##3.2.3 缺失值
##NA 表示未知的值，因此缺失值是“可传染的”。如果运算中包含了未知值，那么运算结果一般来说也是个未知值.

NA == NA ##NA

is.na(x) ##是否为NA
##保留缺失值 is.na()
df <- tibble(x = c(1, NA, 3))
df
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

##3.2.4 练习
##(1)
view(flights)
filter(flights, arr_delay >= 120)##到达时间延误2小时或等多的航班
filter(flights, dest %in% c("IAH", "HOU"))##飞往休斯顿（IAH 机场或HOU 机场）的航班
filter(flights, carrier %in% c("UA", "AA", "Dl"))##由联合航空（United）、美利坚航空（American）或三角洲航空（Delta）运营的航班
filter(flights, month %in% c(7, 8, 9))##夏季（7 月、8 月和9 月）出发的航班。
filter(flights, arr_delay >= 120 & dep_delay <= 0)##到达时间延误超过2 小时，但出发时间没有延误的航班。
filter(flights, (arr_delay >= 60) | (dep_delay >= 60) & (dep_delay - arr_delay) == 30)
filter(flights, dep_time ==2400 | dep_time <= 600)

##(2) between() 函数
filter(flights, between(month, 7, 9))

##(3) 有缺失值的航班有多少？其他变量的缺失值情况如何？这样的行表示什么情况？
filter(flights, is.na(dep_time))

##(4)
NA ^ 0
NA | TRUE
FALSE & NA
NA * 0
