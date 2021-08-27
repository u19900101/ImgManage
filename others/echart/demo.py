# 配置相关库
import os
from urllib.request import urlopen  # 获取请求打开网页的库
from bs4 import BeautifulSoup  # 获取解析网页的库
import re
from numpy.core.records import fromstring
import pandas as pd
import numpy as np
import datetime
import time
# 目标 值
# 输出到文件中,格式如下
# [日期,标题,经度，纬度,贡献度]
# day,title,longitude,latitude,num
# 2021/8/1 18:24,title1,1,101,1
# 2021/8/2,title2,2,102,2

# 原始值
# <h1>5.168  做核酸  自助早餐  暴雨  两个芒果</h1>
# <div>
# <table bgcolor="#D4DDE5" border="0">
# <tr><td><b>创建时间：</b></td><td><i>2021/7/6 23:01</i></td></tr>
# <tr><td><b>更新时间：</b></td><td><i>2021/7/6 23:17</i></td></tr>
# <tr><td><b>位置：</b></td><td><a href="http://maps.google.com/maps?z=6&q=20.023900,110.269000"><i>20°1'26 N  110°16'8 E</i></a></td></tr>


# 正则匹配  20°1'25 N  110°16'23 E
def getNE(s):
    pattern = re.compile(r'\d+\°\d+\'\d+')
    return pattern.findall(s)

def getInfo(fileName, path):
    with open(path, 'r', encoding='utf-8') as f:
        Soup = BeautifulSoup(f.read(), 'html.parser')
    # 获取创建时间 和坐标
    tagBList_i = Soup.findAll({"i"})  # 返回一个包含HTML文档h1标题标签的列表
    if(len(tagBList_i) == 0):
        return []
    longitude, latitude = 0, 0
    if(len(tagBList_i) >= 3):

        if(len(getNE(tagBList_i[2].text)) == 2):
            longitude = getNE(tagBList_i[2].text)[0]
            latitude = getNE(tagBList_i[2].text)[1]
    try:
        day = tagBList_i[0].text
        title = Soup.findAll({"title"})[0].text  # 查找标题对应的内容
    except IndexError:
        print(fileName)
    # print(day,title,longitude,latitude,len(title))
    return [day,title,longitude,latitude,len(title)]
   # 字典中的key值即为csv中列名

def add_absent_days(day_timestramp,day_start,day_end):
    # 3.提取出 day列  将其转化为 yyyy/mm/dd的格式  将 str=2017/1/27 23:06  转化为   str 2017/01/27
   
    #转换成localtime   减去6小时  早上6点的都算是前一天写的日记  因为发现有一天是4点写的
    d_2017 = [time.strftime("%Y/%m/%d",time_local) for time_local in [time.localtime(x -3600*6) for x in day_timestramp]]
    # 只获取小时和分钟
    day_time = [time.strftime(" %H:%M",time_local) for time_local in [time.localtime(x) for x in day_timestramp]]
    clean_day = [x+y  for (x,y) in zip(d_2017,day_time)]
    # 4.创建全年的日子
    all_2017=[datetime.datetime.strftime(x,'%Y/%m/%d') for x in list(pd.date_range(start=day_start,  end=day_end))]
    # 5.将上两项做差求出没有记录的日子
    absent_2017 = [i for i in all_2017 if i not in d_2017]
      # 给所有时间 加上当天 12点的时间
    absent_2017 = [x +" 12:00" for x in absent_2017]

    absent_2017_timestramp = [time.mktime(time.strptime(x, '%Y/%m/%d %H:%M')) for x in absent_2017]
  
    # absent_2017_timestramp = [ x + 12*3600 for x in absent_2017_timestramp]
    day =clean_day + absent_2017
    day_timestramp+=absent_2017_timestramp
    return len(absent_2017),day_timestramp,day
    # 6.将没有记录的日子进行补充  [day:当天,title:空,longitude,latitude,num:0]

# 对日期进行优化操作   删掉  8/19整行   将第一个8/20改为 8/19
# 2019/08/19 12:00,,,,0,1566187200.0
# 2019/08/20 15:02,3.196  转文全部被拒  心情失落  又开始考虑复原,0,0,28,1566284520.0
# 2019/08/20 15:04,3.197  第一天便无法做到自律 
# 存在bug 不能直接进行操作 非要先存再读
def edit_info(res_path):
    # 手动修改 日期  
    # 截取day的date————2017/02/02 12:26  -->  2017/02/02  是否唯一进行检查
   
    df=pd.read_csv(res_path,header=0,sep=',') 
    M = [x.split(" ")[0] for x in df["day"].tolist()]
    # 给原 df加一列 date
    df['day_date'] = M
    # 得到date重复的行  保留出现第一次的值  duplicated(keep=False)
    day_date = df[df['day_date'].duplicated(keep=False)]
    M = day_date[['day','title','day_date']]
    print("重复的天数为：",len(M))
   
    all_index = M.index.tolist() 
      # 剔除 0 元素
    if 0 in all_index:
        all_index.remove(0)
    # 2.判断 index-1 是否为系统自动生成的 (num值是否为0)
    del_index = []

    for x in all_index:
        if ((df[x:x+1].day_date == '2020/02/13').bool()):
            print("2020/02/13")
        if ((df[x-1:x].num == 0).bool()):
            print("删除行",df[x-1:x].day)
            del_index.append(x-1)
            # df = df.drop([x-1])
        # 3.是——删掉 index-1这一行 
        # 4.修改 df[index] 的 date-1
            temp = df[x:x+1]
            dt = datetime.datetime.strptime(temp.at[temp.index.values[0],'day'],'%Y/%m/%d %H:%M')
            out_date = (dt + datetime.timedelta(days=-1)).strftime('%Y/%m/%d %H:%M')
            temp.day[x] = out_date
    # 5.更新csv文件
    df = df.drop(del_index)
    df.to_csv(res_path,index=False, sep=',')
def gen_Year_csv(dir,day_start,day_end,res_path):
    # dir = 'D:/MyJava/19_mogu_blog_v2-Nacos/others/我的抗战1.0/'
    result = []
    # 遍历输出每一个文件的名字和类型
    for item in os.listdir(dir):
        # 输出指定后缀类型的文件
        if(item.endswith('.html')):
            res = getInfo(item, dir+item)
            if(len(getInfo(item, dir+item))>0):
                result.append(res)
            
    # print(result)
    result = np.array(result)

    day = result[:,0].tolist()
    title = result[:,1].tolist()
    longitude = result[:,2].tolist()
    latitude = result[:,3].tolist()
    num = result[:,4].tolist()

    # 添加缺少的日期
    day_timestramp =  [time.mktime(time.strptime(x, '%Y/%m/%d %H:%M')) for x in day]

    # clean_day 为 修改类似凌晨写文章后的day
    absent_days_len,day_timestramp,day = add_absent_days(day_timestramp,day_start,day_end)
   
    title+=[None]*absent_days_len
    longitude+=[None]*absent_days_len
    latitude+=[None]*absent_days_len
    num+=[0]*absent_days_len

    dataframe = pd.DataFrame({'day': day,
                                'title': title,
                                'longitude': longitude,
                                'latitude': latitude,
                                'num': num,
                                'day_timestramp':day_timestramp})
    dataframe.sort_values(by='day_timestramp').to_csv(res_path,index=False, sep=',')
    edit_info(res_path)
    
dir = 'D:/MyJava/19_mogu_blog_v2-Nacos/others/我的抗战2.0/'  
day_start='2018/1/1'
day_end='2021/12/31'
res_path = "./info.csv"
# df=pd.read_csv(res_path,header=0,sep=',') 
# df = edit_info(df)
# df.to_csv(res_path,index=False, sep=',')
gen_Year_csv(dir,day_start,day_end,res_path)