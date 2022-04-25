#chapter5_探索性数据分析

library(tidyverse)

##5.3.1 对分布进行可视化表示

##检查分类变量的分布，可使用条形图
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  count(cut)

##数值型和日期时间型变量为连续变量。检查其分布，用直方图
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))

##不同分箱宽度
smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

##折线图
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 0.1)

##直方图+折线图
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_histogram(binwidth = 0.1) +
  geom_freqpoly(binwidth = 0.1)


##5.3.2 典型值
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.25)

##5.3.3 异常值
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
##可见3个异常值，分别位于0、30、60
unusual <- diamonds %>% 
  filter(y < 3 | y > 30) %>% 
  arrange(y)
unusual

##5.3.4 练习
#(1) 研究x、y 和z 变量在diamonds 数据集中的分布。你能发现什么？思考一下，对于一条钻石数据，如何确定表示长、宽和高的变量？

#(2) 研究price 的分布，你能发现不寻常或令人惊奇的事情吗？（提示：仔细考虑一下binwidth 参数，并确定试验了足够多的取值。）
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 2)

#(3) 0.99 克拉的钻石有多少？ 1 克拉的钻石有多少？造成这种区别的原因是什么？
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)

diamonds %>% 
  filter(carat == 1 | carat == 0.99) %>% 
  count(carat)

#(4) 比较并对比coord_cartesina() 和xlim()/ylim() 在放大直方图时的功能。如果不设置binwidth 参数，会发生什么情况？如果将直方图放大到只显示一半的条形，那么又会发生什么情况？
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 3) +
  coord_cartesian(ylim = c(0, 50), xlim = c(0, 10))


##5.4 缺失值
##将带有可疑值的行全部丢弃
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))
##用缺失值代替异常值 mutate()
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y <3 | y > 20, NA, y))

##ggplot2忽略缺失值，通知缺失值被丢弃
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()

##不显示警告
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)

##比较有无缺失值的区别
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) +
    geom_freqpoly(
      mapping = aes(color = cancelled),
      binwidth = 1/4
    )

##练习
#(1) 直方图如何处理缺失值？条形图如何处理缺失值？为什么会有这种区别？
ggplot(data = diamonds2, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.5)

ggplot(data = diamonds2, mapping = aes(x = y)) +
  geom_bar()

#(2) na.rm = TRUE 在mean() 和sum() 函数中的作用是什么？
mean(diamonds2$y)
sum(diamonds2$y)


##5.5 相关变动

##5.5.1 分类变量与连续变量
##y轴默认为计数,难以看出形状上的差别
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

##y轴显示密度
ggplot(
  data = diamonds,
  mapping = aes(x = price, y = ..density..)
) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)#这张图的部分内容非常令人惊讶，其显示出一般钻石（质量最差）的平均价格是最高的！

