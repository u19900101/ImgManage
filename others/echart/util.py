import pandas as pd
def classifyByYear(csvPath,desPath):
    # 1.读取文件
    df=pd.read_csv(csvPath,header=0,sep=',') 
    # 2.按照day_date(2018/01/01)  列的前四位  2018进行分表
    # day_date_list = list(df['day_date'])
    day_date_list = [x.split('/')[0] for x in list(df['day_date'])]
    year_list = list(set(day_date_list))
    year_list = [eval(x) for x in list(set(day_date_list))]
    # 3.将年份由小到大进行排序
    year_list.sort()
    # 4.分割年份  年份第一次出现的位置进行
    all_years = [df[day_date_list.index(str(year_list[x])):day_date_list.index(str(year_list[x]+1))] for x in range(len(year_list)-1)]
    # 最后一年
    all_years.append(df[day_date_list.index(str(year_list[-1])):])
    # 3.输出表
    [df_year.to_csv(desPath+'/'+str(year)+"_info.csv",index=False, sep=',')  for (year,df_year) in zip(year_list,all_years)]

csvPath = 'D:\MyJava\mylifeImg\others\info.csv'
desPath = 'D:\MyJava\mylifeImg\others\echart\data'
classifyByYear(csvPath,desPath)
