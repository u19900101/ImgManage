from markdownify import markdownify as md
# 二次转换视频
# 原始  <a href="dirname/v_name.mp4"> </a> 
# 经md转换后  [![1580400084168.mp4](4.11 8 h  声控游戏  刷线程进程基础研究语音控制  小黑屋午睡下不为例 二哥百果_files/07cc80e28ec6357bf86b517536b783e8.png)](4.11 8 h  声控游戏  刷线程进程基础研究语音控制  小黑屋午睡下不为例 二哥百果_files/1580400084168.mp4)
# 二次转化  <video src="dirname/v_name.mp4"></video>
import re
def gen_video_tag(s):
    return re.sub('(?P<value>\[.*?mp4\))', video_match, s)

def video_match(matched):
    value = matched.group('value')
    value = re.sub('(?P<value>\[.*\])', "\n", value)
    if value.endswith(".mp4)"):
        value = value.replace("(","<video src=\"").replace(")","\"></video>")
    return value
# s = "<div><a href=\"4.11 8 h  声控游戏  刷线程进程基础研究语音控制  小黑屋午睡下不为例 二哥百果_files/1580400084168.mp4\"><img src=\"4.11 8 h  声控游戏  刷线程进程基础研究语音控制  小黑屋午睡下不为例 二哥百果_files/07cc80e28ec6357bf86b517536b783e8.png\" alt=\"1580400084168.mp4\"></a></div>"
# s = md(s)
# s +=s
# # 提取 形如此类的字符串 (...)
# print(gen_video_tag(s))
def htmls_to_md(srcpath,descpath):
    res = ""
    # t0 = ""
    for path in srcpath:
        # 读取html格式文件
        with open(path, 'r', encoding='UTF-8') as f:
            htmlpage = f.read()
        # 处理html格式文件中的内容
            text = md(htmlpage)  
            text = text.replace("body, td {\n font-family: 微软雅黑;\n font-size: 10pt;\n }\n","")
            # 1.去除多余的换行
            text = text.replace("\n\n\n\n","")
            # 2.生成换行
            text = text.replace("  \n","  \n\n")
            # 3.去掉特殊字符
            text = text.replace("\xa0"," ")
            # 4.去掉标题  只去掉匹配的第一个
            text = re.sub(r'\n\n.*\n', "", text,1)
            # 5.二次转化视频标签
            text = gen_video_tag(text)
            res +=text
    with open(descpath, 'w', encoding='UTF-8') as f:
        f.write(res)
    # return res
from natsort import natsorted
dir_name = "../我的抗战2.0"
dirList = os.listdir(dir_name)
htmlList = []
for f in dirList:
    if(f.endswith(".html")):
        htmlList.append(f)
# 按照数字开头进行排序 厉害
htmlList = natsorted(htmlList)
h_list = htmlList
year_html_list = [htmlList[0:370],htmlList[370:725],htmlList[725:1071],htmlList[1071:]]
h_lists = []
years = ['2018','2019','2020','2021']

for h_list,year in zip(year_html_list,years):
    h_list = [dir_name + "/" + x for x in h_list]
    h_lists.append(h_list)
    # 将每年的30篇分为一组 
    h_monthes = [h_list[i:i + 30] for i in range(0, len(h_list), 30)]
    num = 1
    for month in h_monthes:
        descpath = dir_name + "/" + year + "_"+str(num) +".md"
        htmls_to_md(month,descpath)
        num +=1
    