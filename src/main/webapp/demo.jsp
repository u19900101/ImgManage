<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
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
        span{
            border: 1px solid #39987c;
            width: 100%;
            font-size: larger;
        }

        span.firstSpan{
            float: left;
            width: 24%;
            align:right;
        }
    </style>
    <script type="text/javascript">
        $(function(){
            $('.myselect').on('click', function(){
                var handleMethod = $(this).attr('handleMethod');
                var uploadImgPath = $(this).attr('uploadImgPath');
                var existImgPath = $(this).attr('existImgPath');
                // 要replaceAll  下面的则不需要 尬
                var divID = $(this).attr('existImgPath').replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                $.post(
                    "http://localhost:8080/pic/picture/ajaxHandleSamePic",
                    "handleMethod="+handleMethod+"&uploadImgPath="+uploadImgPath+"&existImgPath="+existImgPath,
                    function(data) {
                        if(data.status == 'success'){
                            $("#"+divID).remove();
                            // alert(divID);
                            alert(data.msg);
                        }else if(data.status == 'fail'){
                            alert("提交失败");
                        }else {
                            alert("其他未知错误.....please enjoy debug");
                        }
                    },
                    "json"
                );
            });

            // 批量操作
            $('.myselectAll').on('click', function(){
                var handleMethod = $(this).attr('handleMethod');
                $.ajax({
                    type:'post',
                    contentType : 'application/json;charset=utf-8',
                    url:"http://localhost:8080/pic/picture/ajaxHandleSamePicAll?handleMethod="+handleMethod,
                    data:{},
                    success:function(data) {
                        if(data.status == 'success'){
                            alert(data.msg);
                            $("#main").remove();
                        }else if(data.status == 'fail'){
                            alert("提交失败");
                        }else {
                            alert("其他未知错误.....please enjoy debug");
                        }
                    },
                    dataType:"json"
                });
            });
        })

    </script>
</head>
<body>
<%--文件夹上传--%>
<h1 style="color: red">文件夹上传</h1>
<form action="picture/uploadDir" enctype="multipart/form-data" method="post">
    图  像 ：<input type="file" name="imgList" value="pppp" webkitdirectory/><br/>
    <input type="submit" value="上传文件夹">
</form>
<%--文件上传--%>
<%--<h1 style="color: #ffe57d">文件上传</h1>
<h1 style="color: lightgreen">${successMsg}</h1>
<form action="picture/upload" enctype="multipart/form-data" method="post">
    &lt;%&ndash;accept="image/*" ，表示提交的文件只能为图片，若没有添加该内容，则图片、文档等类型的文件都可以提交&ndash;%&gt;
    图  像 ：<input type="file" name="img" value="pppp"/><br/>
    <input type="submit" value="上传">
</form>--%>



<c:if test="${not empty failedList}">

<div id = "main">
    <span class="firstSpan"><input class="myselectAll" handleMethod ="saveBoth" type="button" value="保存全部" style="color:green;font-size: larger;width: 100%;"></span>
    <span class="firstSpan"><input class="myselectAll" handleMethod ="deleteBoth" type="button" value="删除全部" style="color:red;font-size: larger;width:100%;"></span>
    <span class="firstSpan" style="float: right;"><input class="myselectAll" handleMethod ="saveExistOnly" type="button" value="只保存全部本地" style="color:navy;font-size: larger;width: 100%;"></span>
    <span class="firstSpan" style="float: right;"><input class="myselectAll" handleMethod ="saveUploadOnly" type="button" value="只保存全部上传" style="color:firebrick;font-size: larger;width: 100%;"></span>
    <c:forEach items="${failedList}" var="picture">

        <%-- 展示成功上传的信息--%>
        <c:if test="${not empty picture.successMsg}">
        <div  class="zuiOut" style="border: 3px solid #39987c;width: 100%;height: 100%">
            <h1 style="color: red">${picture.successMsg}</h1>
            <img src="${picture.existImgPath}" width="600">
        </div>
        </c:if>

        <%-- 展示 存在相同照片的信息 --%>
        <c:if test="${not empty picture.failedMsg}">

            <div id = ${picture.existPicture.path.replace('\\', '').replace('_', '').replace('.', '')} class="zuiOut" style="border: 3px solid #39987c;width: 100%;height: 100%">
                <h1 style="color: red">${picture.failedMsg}</h1>
                <span align="right" style="float: left;width: 49%">
                    <input class="myselect" value="都保留" type="button" style="color:green;font-size: larger;width: 100%;text-align:right"
                       handleMethod ="saveBoth" uploadImgPath = ${picture.uploadImgPath} existImgPath=${picture.existImgPath}></span>
                <span align="left" style="float: right;width: 49%">
                    <input class="myselect" value="都删除" type="button" style="color: red;font-size: larger;width: 100%;text-align:left"
                        handleMethod ="deleteBoth" uploadImgPath = ${picture.uploadImgPath} existImgPath=${picture.existImgPath}></span>
                    <%--本地照片--%>
                <div class="outdiv" style="float: left">
                    <h3 style="color: red">本地照片:${picture.existImgPath}</h3>
                    <h4 style="color: chocolate">图片尺寸： ${picture.existPicture.pwidth}*${picture.existPicture.pheight}</h4>
                    <h4 style="color: gray">图片大小： ${picture.existPicture.psize} M</h4>
                    <span align="center" style="float: left">
                        <input class="myselect" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center"
                          handleMethod ="saveExistOnly" uploadImgPath = ${picture.uploadImgPath} existImgPath=${picture.existImgPath}></span>
                    <div class="imgdiv">
                        <img src="${picture.existImgPath}" align="莫方,照片已提交">
                    </div>
                </div>
                    <%--上传的照片--%>
                <div class="outdiv" style="height: 100%;float: right">
                    <h3 style="color: lightgreen;">上传的照片：${picture.uploadImgPath}</h3>
                    <h4 style="color: chocolate">图片尺寸： ${picture.uploadPicture.pwidth}*${picture.uploadPicture.pheight}</h4>
                    <h4 style="color: gray">图片大小： ${picture.uploadPicture.psize} M</h4>
                    <span align="center" style="float: left">
                    <input class="myselect" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center"
                           handleMethod ="saveUploadOnly" uploadImgPath = ${picture.uploadImgPath} existImgPath=${picture.existImgPath}></span>

                    <div class="imgdiv">
                        <img src="${picture.uploadImgPath}" alt="莫方,照片已提交">
                    </div>
                </div>
            </div>
        </c:if>

    </c:forEach>
</div>
</c:if>

</body>
</html>