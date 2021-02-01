<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/1
  Time: 16:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<%--
Picture{
pid=14,
path='D:\MyJava\mylifeImg\src\main\webapp\static\0E4A2352.jpg',
pname='0E4A2352.jpg',
pcreatime='2020:10:06 08:08:14',
plocal='null', plabel='null',
pdesc='还未设置'
}
--%>
<%-- 静态包含 base标签、css样式、jQuery文件 --%>
<%@ include file="/WEB-INF/pages/head.jsp"%>
<form action="picture/update" method="post">

    文件名：<input name="pname" value="${picture.pname}"> <br/>
    拍摄时间：<input name="pcreatime" value="${picture.pcreatime}"> <br/>
    地理位置： <input name="plocal" value="${picture.plocal}"> <br/>
    <input name="pid" type="hidden" value="${picture.pid}"> <br/>
    <input name="path" type="hidden" value="${picture.path}"> <br/>
    <img src="/pic/static/${picture.pname}" width="600"><br/>
    描述<textarea name="pdesc"> </textarea><br/>
    <input type="submit" value="提交"/>
</form>
</body>
</html>
