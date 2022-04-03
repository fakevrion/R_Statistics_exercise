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


##3.6 使用summarize() 进行分组摘要
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

view(flights)
by_day <- group_by(flights, year, month, day)
view(by_day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

##测试group_by() 函数含义 按月分类
by_month <- group_by(flights, year, month)
summarize(by_month, delay = mean(dep_delay, na.rm = TRUE))
##按年分类
by_year <- group_by(flights, year)
summarize(by_year, delay = mean(dep_delay, na.rm = TRUE))


##3.6.1 使用管道组合多种操作
##研究每个目的地的距离和平均延误时间之间的关系。使用已经了解的dplyr
by_dest <- group_by(flights, dest)
by_dest
delay <- summarize(by_dest, 
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
)
delay
delay <- filter(delay, count > 20, dest != "HNL")
delay
##750英里内，平均延误时间会随着距离的增加而增加，接着会随着距离的增加而减少。
ggplot(data= delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

##使用管道
delays <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "NHL")
delays


##3.6.2 缺失值
##聚合函数都有一个na.rm 参数，去除缺失值
flights %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>%
  group_by(year, month ,day) %>%
  summarize(mean = mean(dep_delay))


##3.6.3 计数
##根据机尾编号，最长平均延误时间的飞机
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )
ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)

##散点图
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y =delay)) +
  geom_point(alpha = 1/10)


##筛选掉观测数量少的分组
delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
    geom_point(alpha = 1/10)

##棒球击打率
#转换成tibble
library("Lahman")
batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point() +
    geom_smooth(se = FALSE)

##3.6.4 常用的摘要函数
##位置度量 mean(x) median(x) 结合逻辑筛选
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

##分散程度度量 sd(x) IQR(x) mad(x)
not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

##秩的度量 min(x) quantile(x, 0.25) max(x)
#每天最早和最晚的航班何时出发？
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first = min(dep_time),
    last = max(dep_time)
  )

##定位度量 first(x) nth(x, 2) last(x)
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    fisrt_dep = first(dep_time),
    last_dep = last(dep_time)
  )

#这些函数对筛选操作进行了排秩方面的补充。筛选会返回所有变量，每个观测在单独的一行中：
not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

##计数 n() 计算非缺失值的数量：sum(!is.na(x))；计算唯一值的数量 n_distinct(x)
#哪个目的地具有最多的航空公司？
not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

#因为计数太常用了，所以dplyr 提供了一个简单的辅助函数，用于只需要计数的情况：
not_cancelled %>%
  count(dest)

#提供一个加权变量
#计算每架飞机总里程数
not_cancelled %>%
  count(tailnum, wt = distance)

##逻辑值的计数和比例 sum(x > 10) mean(y == 0)
#多少架航班是在早上5点前出发的？
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

#延误超过1小时的航班比例是多少？
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))


##3.6.5 按多个变量分组
#当使用多个变量进行分组时，每次的摘要统计会用掉一个分组变量。
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))

(per_month <- summarize(per_day, flights = sum(flights)))

(per_year <- summarize(per_month, flights = sum(flights)))

##3.6.6 取消分组
daily %>%
  ungroup() %>%
  summarize(flights = n())

##3.6.7 练习
#(1)通过头脑风暴，至少找出5 种方法来确定一组航班的典型延误特征。思考以下场景。
#一架航班50% 的时间会提前15 分钟，50% 的时间会延误15 分钟。
flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  group_by(tailnum) %>%
  summarize(pri_15 = mean(arr_delay <= -15), del_15 = mean(arr_delay >= 15)) %>%
  filter(pri_15 >= 0.5)
#一架航班总是会延误10 分钟。
flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  group_by(tailnum) %>%
  arrange(dep_delay >= 10)
#一架航班50% 的时间会提前30 分钟，50% 的时间会延误30 分钟。
#一架航班99% 的时间会准时，1% 的时间会延误2 个小时。

##(2) 找出另外一种方法，这种方法要可以给出与not_cancelled %>% count(dest) 和not_cancelled %>% count(tailnum, wt = distance) 同样的输出（不能使用count()）。
not_cancelled %>%
  count(dest)
not_cancelled %>%
  group_by(dest) %>%
  summarize(n())

not_cancelled %>%
  count(tailnum, wt = distance)

not_cancelled %>%
  group_by(tailnum) %>%
  summarize(m = sum(distance))

##(3) 我们对已取消航班的定义(is.na(dep_delay)) | (is.na(arr_delay)) 稍有欠佳。为什么？哪一列才是最重要的？

##(4) 查看每天取消的航班数量。其中存在模式吗？已取消航班的比例与平均延误时间有关系吗？
cancelled_per_day <- 
  flights %>%
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
  group_by(year, month, day) %>%
  summarize(
    cancelled_num = sum(cancelled),
    flights_num = n()
  )
cancelled_per_day
ggplot(data = cancelled_per_day, mapping = aes(x = flights_num, y = cancelled_num)) +
  geom_point()


cancelled_and_delays <- 
  flights %>%
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
  group_by(year, month, day) %>%
  summarise(
    cancelled_prop = mean(cancelled),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  ungroup()
ggplot(cancelled_and_delays) +
  geom_point(aes(x = avg_dep_delay, y = cancelled_prop))
                        
##(5) 哪个航空公司的延误情况最严重？挑战：你能否分清这是由于糟糕的机场设备，还是航空公司的问题？为什么能？为什么不能？（提示：考虑一下flights %>% group_by(carrier, dest) %>% summarize(n())。）
flights %>%
  group_by(carrier) %>%
  summarize(arr_delays = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(arr_delays))

flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(origin, dest, carrier) %>%
  summarise(
    arr_delay = sum(arr_delay),
    flights = n()
  ) %>%
  group_by(origin, dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    flights_total = sum(flights)
  ) %>%
  ungroup() %>%
  mutate(
    arr_delay_others = (arr_delay_total - arr_delay) /
      (flights_total - flights),
    arr_delay_mean = arr_delay / flights,
    arr_delay_diff = arr_delay_mean - arr_delay_others
  ) %>%
  filter(is.finite(arr_delay_diff)) %>%
  group_by(carrier) %>%
  summarise(arr_delay_diff = mean(arr_delay_diff)) %>%
  arrange(desc(arr_delay_diff))

##(6) 计算每架飞机在第一次延误超过1 小时前的飞行次数。
delay_60 <- flights %>%
  filter(!is.na(arr_delay)) %>%
  mutate(delay_60 = arr_delay > 60)

view(delay_60)

#(7) count() 函数中的sort 参数的作用是什么？何时应该使用这个参数？


##3.7 分组新变量和筛选器
#找出每个分组中最差的成员：
flights_sml <- flights %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
view(flights_sml)

#找出大于某个阈值的所有分组：
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)

#对数据进行标准化以计算分组指标：
popular_dests %>% 
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)

##练习
#(1) 查看常用的新变量函数和筛选函数的列表。当它们与分组操作结合使用时，功能有哪些变化？


#(2) 哪一架飞机（用机尾编号来识别，tailnum）具有最差的准点记录？
flights %>%
  group_by(tailnum) %>%
  summarize(
    prop_delay = mean(arr_delay > 0)
  ) %>%
  arrange(desc(prop_delay))

#(3) 如果想要尽量避免航班延误，那么应该在一天中的哪个时间搭乘飞机？
flights %>%
  filter(!is.na(arr_delay)) %>%
  group_by(hour) %>%
  summarize(
    delay_prop = mean(arr_delay > 0)
  ) %>%
  arrange(desc(delay_prop))

#(4) 计算每个目的地的延误总时间的分钟数，以及每架航班到每个目的地的延误时间比例。
flights %>%
  filter(!is.na(arr_delay), arr_delay > 0) %>%
  group_by(dest, tailnum) %>%
  mutate(delay_prop = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, tailnum, arr_delay, delay_prop)

#(5) 延误通常是由临时原因造成的：即使最初引起延误的问题已经解决，但因为要让前面的航班先起飞，所以后面的航班也会延误。使用lag() 函数探究一架航班延误与前一架航班延误之间的关系。

#(6) 查看每个目的地。你能否发现有些航班的速度快得可疑？（也就是说，这些航班的数据可能是错误的。）计算出到目的地的最短航线的飞行时间。哪架航班在空中的延误时间最长？

#(7) 找出至少有两个航空公司的所有目的地。使用数据集中的信息对航空公司进行排名。
flights %>%
  group_by(carrier, dest) %>%
  summarize(dest_flight_num = n()) %>%
  summarize(dest_num = n()) %>%
  arrange(desc(dest_num))

