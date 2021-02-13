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

        .imgdiv img {
            height:80%;
            width:100%;
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

        .alert {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            min-width: 200px;
            margin-left: -100px;
            z-index: 99999;
            padding: 15px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .alert-success {
            color: #3c763d;
            background-color: #dff0d8;
            border-color: #d6e9c6;
            font-size: xx-large;
        }

        .alert-info {
            color: #31708f;
            background-color: #d9edf7;
            border-color: #bce8f1;
        }

        .alert-warning {
            color: #8a6d3b;
            background-color: #fcf8e3;
            border-color: #faebcc;
        }

        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
        }

    </style>
    <script type="text/javascript">
        $(function(){
            $('.myselect').on('click', function(){
                var handleMethod = $(this).attr('handleMethod');
                var uploadImgPath = $(this).attr('uploadImgPath');
                var existImgPath = $(this).attr('existImgPath');
                // 要replaceAll  下面的则不需要 尬
                var divID = $(this).attr('uploadImgPath').replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                $.post(
                    "http://localhost:8080/pic/picture/ajaxHandleSamePic",
                    "handleMethod="+handleMethod+"&uploadImgPath="+uploadImgPath+"&existImgPath="+existImgPath,
                    function(data) {
                        if(data.status == 'success'){
                            $("#"+divID).remove();
                            success_prompt(data.msg,1500);
                        }else if(data.status == 'fail'){
                            fail_prompt(data.msg,2500);
                        }else {
                            warning_prompt("其他未知错误.....please enjoy debug",2500);
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
                            success_prompt(data.msg,2500);
                            $("#main").remove();
                            countDown(3);

                        }else if(data.status == 'fail'){
                            fail_prompt(data.msg,2500);
                        }else {
                            warning_prompt("其他未知错误.....please enjoy debug",2500);
                        }
                    },
                    dataType:"json"
                });
            });
        });

        function countDown(secs){
            if(--secs>0){
                setTimeout("countDown("+secs+")",1000);
            }else{
                $(window).attr("location","picture/showUploadInfo");
            }
        }


    </script>
    <%--alert自动消失--%>
    <script type="text/javascript">
        var prompt = function (message, style, time)
        {
            style = (style === undefined) ? 'alert-success' : style;
            time = (time === undefined) ? 1200 : time;
            $('<div>')
                .appendTo('body')
                .addClass('alert ' + style)
                .html(message)
                .show()
                .delay(time)
                .fadeOut();
        };
        var success_prompt = function(message, time)
        {
            prompt(message, 'alert-success', time);
        };

        // 失败提示
        var fail_prompt = function(message, time)
        {
            prompt(message, 'alert-danger', time);
        };

        // 提醒
        var warning_prompt = function(message, time)
        {
            prompt(message, 'alert-warning', time);
        }
        // 信息提示
        var info_prompt = function(message, time)
        {
            prompt(message, 'alert-info', time);
        };
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
<c:if test="${not empty successMapList or not empty failedMapList}">
  <div id = "main">
    <span class="firstSpan"><input class="myselectAll" handleMethod ="saveBoth" type="button" value="保存全部" style="color:green;font-size: larger;width: 100%;"></span>
    <span class="firstSpan"><input class="myselectAll" handleMethod ="deleteBoth" type="button" value="删除全部" style="color:red;font-size: larger;width:100%;"></span>
    <span class="firstSpan" style="float: right;"><input class="myselectAll" handleMethod ="saveExistOnly" type="button" value="只保存全部本地" style="color:navy;font-size: larger;width: 100%;"></span>
    <span class="firstSpan" style="float: right;"><input class="myselectAll" handleMethod ="saveUploadOnly" type="button" value="只保存全部上传" style="color:firebrick;font-size: larger;width: 100%;"></span>

    <%-- 展示成功上传的信息--%>
    <c:if test="${not empty successMapList}">
        <c:forEach items="${successMapList}" var="picture">
            <c:if test="${not empty picture.successMsg}">
            <div id = ${picture.uploadPicture.path.replace('\\', '').replace('_', '').replace('.', '')} class="zuiOut" >
                    <h1 style="color: red">${picture.successMsg}</h1>
                    <h3 style="color: red">本地照片:${picture.uploadPicture.path}</h3>
                    <h4 style="color: chocolate">图片尺寸： ${picture.uploadPicture.pwidth}*${picture.uploadPicture.pheight}</h4>
                    <h4 style="color: gray">图片大小： ${picture.uploadPicture.psize} M</h4>
                    <span align="center" style="float: left;width: 25%;">
                        <input class="myselect" type="button" value="保存" style="font-size: larger;width: 100%;text-align:center"
                               handleMethod ="saveSingle" uploadImgPath = ${picture.uploadPicture.path}></span>
                    <span align="center" style="float: right;width: 25%;">
                        <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                               handleMethod ="deleteSingle" uploadImgPath = ${picture.uploadPicture.path}></span>
                    <div class="imgdiv">
                        <img src="${picture.uploadPicture.path}">
                    </div>
            </div>
            </c:if>
        </c:forEach>
    </c:if>

    <%-- 显示疑似可能重复的照片信息 --%>
    <c:if test="${not empty failedMapList}">
       <c:forEach items="${failedMapList}" var="picture">
        <%-- 展示 存在相同照片的信息 --%>
        <c:if test="${not empty picture.failedMsg}">
            <div id = ${picture.uploadPicture.path.replace('\\', '').replace('_', '').replace('.', '')} class="zuiOut" style="border: 3px solid #39987c;width: 100%;height: 100%">
                <h1 style="color: red">${picture.failedMsg}</h1>
                <span align="right" style="float: left;width: 49%">
                    <input class="myselect" value="都保留" type="button" style="color:green;font-size: larger;width: 100%;text-align:right"
                       handleMethod ="saveBoth" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
                <span align="left" style="float: right;width: 49%">
                    <input class="myselect" value="都删除" type="button" style="color: red;font-size: larger;width: 100%;text-align:left"
                        handleMethod ="deleteBoth" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
                    <%--本地照片--%>
                <div class="outdiv" style="float: left">
                    <h3 style="color: red">本地照片:${picture.existPicture.path}</h3>
                    <h4 style="color: chocolate">图片尺寸： ${picture.existPicture.pwidth}*${picture.existPicture.pheight}</h4>
                    <h4 style="color: gray">图片大小： ${picture.existPicture.psize} M</h4>
                    <span align="center" style="float: left">
                        <input class="myselect" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center"
                          handleMethod ="saveExistOnly" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
                    <c:if test="${not empty picture.existPicture.path}">
                        <div class="imgdiv">
                            <img src="${picture.existPicture.path}" align="莫方,照片已提交">
                        </div>
                    </c:if>
                </div>
                    <%--上传的照片--%>
                <div class="outdiv" style="height: 100%;float: right">
                    <h3 style="color: lightgreen;">上传的照片：${picture.uploadPicture.path}</h3>
                    <h4 style="color: chocolate">图片尺寸： ${picture.uploadPicture.pwidth}*${picture.uploadPicture.pheight}</h4>
                    <h4 style="color: gray">图片大小： ${picture.uploadPicture.psize} M</h4>
                    <span align="center" style="float: left">
                    <input class="myselect" type="button" value="只保留我" style="font-size: larger;width: 100%;text-align:center"
                           handleMethod ="saveUploadOnly" uploadImgPath = ${picture.uploadPicture.path} existImgPath=${picture.existPicture.path}></span>
            <c:if test="${not empty picture.uploadPicture.path}">
                <div class="imgdiv">
                    <img src="${picture.uploadPicture.path}" align="莫方,照片已提交">
                </div>
            </c:if>
            </div>
        </c:if>
    </c:forEach>
    </c:if>
</div>
</c:if>

</body>
</html>