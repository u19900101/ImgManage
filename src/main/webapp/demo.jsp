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
            height: 80%;
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
            height:80%;
        }

        .zuiOut{
            float: left;/* 非常重要啊   */
            border: 1px solid red;
            width: 49%;
            height: 80%;
        }
    </style>
</head>
<body>
<h1>文件上传</h1>
<h1 style="color: lightgreen">${successMsg}</h1>

<form action="picture/upload" enctype="multipart/form-data" method="post">
    <%--accept="image/*" ，表示提交的文件只能为图片，若没有添加该内容，则图片、文档等类型的文件都可以提交--%>
    图  像 ：<input type="file" name="img" value="pppp"/><br/>
    <input type="submit" value="上传">
</form>


<c:if test="${not empty successPath}">
    <img src="${successPath}" width="600">
</c:if>


<c:if test="${not empty failedList}">


    <c:forEach items="${failedList}" var="picture">
        <div class="zuiOut" style="border: 3px solid #39987c;width: 100%;height: 100%">


            <h1 style="color: red">${picture.failedMsg}</h1>
            <div class="outdiv" style="height: 100%">
                <h3 style="color: lightgreen;">上传的照片：${picture.uploadImgPath}</h3>
                <h4 style="color: chocolate">图片尺寸： ${picture.uploadPicture.pwidth}*${picture.uploadPicture.pheight}</h4>
                <h4 style="color: gray">图片大小： ${picture.uploadPicture.psize} M</h4>
                <div class="imgdiv">
                    <img src="${picture.uploadImgPath}">
                </div>
            </div>
            <div class="outdiv" style="float: right">
                <h3 style="color: red">本地照片:${picture.failedImgPath}</h3>
                <h4 style="color: chocolate">图片尺寸： ${picture.existPicture.pwidth}*${picture.existPicture.pheight}</h4>
                <h4 style="color: gray">图片大小： ${picture.existPicture.psize} M</h4>
                <div class="imgdiv">
                    <img src="${picture.failedImgPath}">
                </div>
            </div>
        </div>
    </c:forEach>
</c:if>

</body>
</html>