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


##3.3 使用arrange()排列行
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))##desc() 降序

##缺失值总是排在最后：
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

##3.3 练习
##(1) 使用arrange() 将缺失值排在最前面，使用is.na()
arrange(df, desc(is.na(df)))

##(2) 对flights 排序以找出延误时间最长的航班。找出出发时间最早的航班。
head(arrange(flights, desc(arr_delay + dep_delay)), 1)
head(arrange(flights, dep_time), 1)

##(3) 对flights 排序以找出速度最快的航班。
arrange(flights, desc(distance / air_time))

##(4) 哪个航班的飞行时间最长？哪个最短？
arrange(flights, air_time)
arrange(flights, desc(air_time))


##3.4 使用 select() 选择列
select(flights, year, month, day)
select(flights, year:day)##year和day之间的所有列
select(flights, -(year:day))##选择不在“year”和“day”之间的所有列（不包括“year”和“day”）

rename(flights, tail_num = tailnum)##重命名变量

##另一种用法是将select() 函数和everything() 辅助函数结合起来使用。当想要将几个变量移到数据框开头时，这种用法非常奏效：
select(flights, time_hour, air_time, everything())

##3.4 练习
##(1) 从flights 数据集中选择dep_time、dep_delay、arr_time 和arr_delay，通过头脑风暴找出尽可能多的方法。
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, any_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))

##(2) 如果在select() 函数中多次计入一个变量名，那么会发生什么情况？
select(flights, time_hour, time_hour)

select(flights, carrier, everything())##轻松改变列的顺序

##(3) one_of() 函数的作用是什么？为什么它结合以下向量使用时非常有用？
vars <- c(
  "year", "month", "day", "dep_delay", "arr_delay"
)

select(flights, one_of(vars))

##(4) 以下代码的运行结果是否出乎意料？选择辅助函数处理大小写的默认方式是什么？如何改变默认方式？
select(flights, contains("TIME"))##可忽略大小写
select(flights, contains("TIME", ignore.case = FALSE))##区分大小写


##3.5 使用 mutate() 添加新变量
##mutate() 总是将新列添加在数据集的最后
flights_swl <- select(flights,
  year:day,
  ends_with("delay"),
  distance,
  air_time
)
view(flights_swl)
mutate(flights_swl,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60
)

##一旦创建，新列就可以立即使用：
mutate(flights,
  gain = arr_delay - dep_delay,
  hours = air_time /60,
  gain_per_hour = gain / hours
)

##只想保留新变量，使用 tansmute() 函数
transmute(flights,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

##模运算符 %/% 整数除法 %% 求余
transmute(flights,
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100
)

##对数函数：log()、log2() 和log10()

##偏移函数 lead() 和lag() 函数可以返回一个序列的领先值和滞后值。
x <- 1:10
lag(x)
lead(x)

##累加和滚动聚合 R 提供了计算累加和、累加积、累加最小值和累加最大值的函数：cumsum()、cumprod()、commin() 和cummax()；dplyr 还提供了cummean() 函数以计算累加均值
x
cumsum(x)##前n项和
cummean(x)##前n项均值

##排秩 默认的排秩方式是，最小的值获得最前面的名次，使用desc(x) 可以让最大的值获得最前面的名次：
y <- c(1, 2, 2, NA, 3, 4)
z <- c(1, 3, 3, NA, 2, 4)
min_rank(y)
min_rank(desc(y))
min_rank(z)

row_number(y)##通用排名，并列的名次结果按先后顺序不一样，靠前出现的元素排名在前
dense_rank(y)##通用排名，并列的名次结果一样，占用下一名次。
percent_rank(y)##按百分比的排名
cume_dist(y)##累计分布区间的排名

##3.5.2 练习
##(1) dep_time 和 sched_dep_time 转换成从午夜开始的分钟数
view(flights)
mutate(flights,
  min_dep_time = dep_time %/% 100 * 60 + dep_time %% 100,
  min_sched_dep_time = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100
)

##(2) 比较air_time 和arr_time – dep_time
select(flights, air_time)
select(flights, arr_time, dep_time)
transmute(
  flights,
  x_time = arr_time - dep_time
)
##滑行时间、陆地时间

##(3) 比较dep_time、sched_dep_time 和dep_delay。你期望这3 个数值之间具有何种关系？

##(4) 使用排秩函数找出10 个延误时间最长的航班。如何处理名次相同的情况？仔细阅读min_rank() 的帮助文件。
view(head(arrange(mutate(flights, delay_rank = min_rank(dep_delay + arr_delay)), desc(delay_rank)), 10))

##(5) 1:3 + 1:10
1:3 + 1:10

##(6) R提供了哪些三角函数
cos(x)
sin(x)
tan(x)
acos(x)
asin(x)
atan(x)
atan2(y, x)
cospi(x)
sinpi(x)
tanpi(x)


