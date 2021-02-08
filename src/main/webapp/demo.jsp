<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/pages/head.jsp"></jsp:include>
<html>
<head>
    <style>
        .outdiv{
            float: left;
            border: 1px solid red;
            width: 49%;
        }

        .imgdiv{
             float: left;
             border: 1px solid red;
            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
         }

        .imgdiv img{
            width:80%;
            height:50%;
        }
    </style>
</head>
<body>
<h1>文件上传</h1>
<h1 style="color: lightgreen">${successMsg}</h1>
<h1 style="color: red">${failedMsg}</h1>
<form action="picture/upload" enctype="multipart/form-data" method="post">
    图  像 ：<input type="file" name="img" value="pppp"/><br/>
    <input type="submit" value="上传">
</form>


<c:if test="${not empty successPath}">
    <img src="${successPath}" width="600">
</c:if>


<c:if test="${not empty failedImgPath}">
<%--<div class="c1">

    <div class="c2">
        <h1 style="color: lightgreen;border: 1px solid gold;">上传的照片：${uploadImgPath}</h1><br/>
        <img src="${uploadImgPath}">
    </div>

    <div class="c2" style="float: right">
        <h1 style="color: red">本地照片:${failedImgPath}</h1><br/>
        <img src="${failedImgPath}">
    </div>
</div>--%>
    <div class="outdiv">
        <h1 style="color: lightgreen;">上传的照片：${uploadImgPath}</h1>
        <div class="imgdiv">
            <img src="${uploadImgPath}" height="600px">
        </div>
    </div>
    <div class="outdiv" style="float: right">
        <h1 style="color: red">本地照片:${failedImgPath}</h1>
        <div class="imgdiv">
            <img src="${failedImgPath}" height="600px">
        </div>

    </div>


</c:if>


</body>
</html>