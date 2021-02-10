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
    </style>
</head>
<body>
<h1 style="color: red">文件夹</h1>
<form action="picture/uploadDir" enctype="multipart/form-data" method="post">
    图  像 ：<input type="file" name="imgList" value="pppp" webkitdirectory/><br/>
    <input type="submit" value="上传文件夹">
</form>

<h1 style="color: #ffe57d">文件上传</h1>
<h1 style="color: lightgreen">${successMsg}</h1>
<form action="picture/upload" enctype="multipart/form-data" method="post">
    <%--accept="image/*" ，表示提交的文件只能为图片，若没有添加该内容，则图片、文档等类型的文件都可以提交--%>
    图  像 ：<input type="file" name="img" value="pppp"/><br/>
    <input type="submit" value="上传">
</form>


<c:if test="${not empty successPath}">
    <img src="${successPath}" width="600">
</c:if>

<script type="text/javascript">
    $(function(){
        function c(){
            alert("执行了c函数");
            $("#t1").remove("#t1");
            alert("执行了完毕 c函数");
        };
        $('.saveBoth').on('click', function(){
            var handleMethod = $(this).attr('handleMethod');
            var uploadImgPath = $(this).attr('uploadImgPath');
            var existImgPath = $(this).attr('existImgPath');
            var divID = $(this).attr('divID');
             $.post(
                 "http://localhost:8080/pic/picture/ajaxHandleSamePic",
                  "handleMethod="+handleMethod+"&uploadImgPath="+uploadImgPath+"&existImgPath="+existImgPath,
                 function(data) {
                     if(data.status == 'success'){
                         alert("提交成功");
                         $("#"+divID).remove();
                     }else if(data.status == 'fail'){
                         alert("提交失败");
                     }else {
                         alert("其他未知错误.....please enjoy debug");
                     }
                 },
                 "json"
             );
        });

        $('.deleteBoth').on('click', function(){
            alert("deleteBoth");
            /* $.ajax({
                 cache: false,
                 type: "POST",
                 url:"/org/add_ask/",
                 data:$('#jsStayForm').serialize(),
                 async: true,
                 success: function(data) {
                     if(data.status == 'success'){
                         $('#jsStayForm')[0].reset();
                         alert("提交成功")
                     }else if(data.status == 'fail'){
                         $('#jsCompanyTips').html(data.msg)
                     }
                 },
             });*/
        });
        $('.saveExistOnly').on('click', function(){
            alert("saveExistOnly");
            /* $.ajax({
                 cache: false,
                 type: "POST",
                 url:"/org/add_ask/",
                 data:$('#jsStayForm').serialize(),
                 async: true,
                 success: function(data) {
                     if(data.status == 'success'){
                         $('#jsStayForm')[0].reset();
                         alert("提交成功")
                     }else if(data.status == 'fail'){
                         $('#jsCompanyTips').html(data.msg)
                     }
                 },
             });*/
        });
        $('.saveUploadOnly').on('click', function(){
            alert("saveUploadOnly");
            /* $.ajax({
                 cache: false,
                 type: "POST",
                 url:"/org/add_ask/",
                 data:$('#jsStayForm').serialize(),
                 async: true,
                 success: function(data) {
                     if(data.status == 'success'){
                         $('#jsStayForm')[0].reset();
                         alert("提交成功")
                     }else if(data.status == 'fail'){
                         $('#jsCompanyTips').html(data.msg)
                     }
                 },
             });*/
        });
    })

</script>
<c:if test="${not empty failedList}">


    <c:forEach items="${failedList}" var="picture">
        <div id = ${picture.existPicture.pid} class="zuiOut" style="border: 3px solid #39987c;width: 100%;height: 100%">

            <h1 style="color: red">${picture.failedMsg}</h1>
            <span align="right" style="float: left;width: 49%">
                <input class="saveBoth" value="都保留" type="button" style="color:green;font-size: larger;width: 100%;text-align:right"
                       handleMethod ="saveBoth" uploadImgPath = ${picture.uploadImgPath} existImgPath=${picture.existImgPath} divID = ${picture.existPicture.pid}>
            </span>
            <span align="left" style="float: right;width: 49%">
                 <input class="deleteBoth" value="都删除" type="button" style="color: red;font-size: larger;width: 100%;text-align:left">
            </span>
            <div class="outdiv" style="height: 100%">
                <h3 style="color: lightgreen;">上传的照片：${picture.uploadImgPath}</h3>
                <h4 style="color: chocolate">图片尺寸： ${picture.uploadPicture.pwidth}*${picture.uploadPicture.pheight}</h4>
                <h4 style="color: gray">图片大小： ${picture.uploadPicture.psize} M</h4>
                <span align="center" style="float: left">
                    <input class="saveExistOnly" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center">
                </span>

                <div class="imgdiv">
                    <img src="${picture.uploadImgPath}">
                </div>
            </div>
            <div class="outdiv" style="float: right">
                <h3 style="color: red">本地照片:${picture.existImgPath}</h3>
                <h4 style="color: chocolate">图片尺寸： ${picture.existPicture.pwidth}*${picture.existPicture.pheight}</h4>
                <h4 style="color: gray">图片大小： ${picture.existPicture.psize} M</h4>
                <span align="center" style="float: left">
                   <input class="saveUploadOnly" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center">
                </span>
                <div class="imgdiv">
                    <img src="${picture.existImgPath}">
                </div>
            </div>
        </div>
    </c:forEach>
</c:if>

</body>
</html>