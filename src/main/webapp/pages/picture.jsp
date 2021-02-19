<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/1
  Time: 16:42
  To change this template use File | Settings | File Templates.
--%>
<%-- 静态包含 base标签、css样式、jQuery文件 --%>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <title>Title</title>
    <meta charset="utf-8">
    <%--/*设置div属性*/--%>
    <style>
        /* 单张图片框 */
        .c1{
            float: left;
            border: 1px solid red;
        }
        /*月份的大框*/
        .c2{
            /*float: left;*/
            border: 2px solid green;
        }

        .imgDiv{
            display:flex;
            align-items:center;
            justify-content:center;
        }
    </style>

    <%-- alter style--%>
    <style>
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
            font-size: xx-large;
        }

        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
            font-size: xx-large;
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
                alert(${not empty justUploadMsg});
                if(${not empty justUploadMsg}){
                    $(window).attr("location","picture/showUploadInfo?page=picture");
                }else {
                    $(window).attr("location","uploadDir.jsp");
                }
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
    <%-- v-calender 控件 有点冗余--%>
    <script>
        $(function () {
            <c:forEach var="item" items="${monthsTreeMapListPic}">
            <c:forEach items="${item.value}" var="picture" >
            new Vue({
                el: '#v_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}',
                data:{
                    timezone: '',
                    date:  '${picture.pcreatime}',
                },
            });
            </c:forEach>
            </c:forEach>
        });
    </script>

    <script>
        $(function () {
            <c:forEach var="item" items="${monthsTreeMapListPic}">
            <c:forEach items="${item.value}" var="picture" >
            var old = $("#changeTime_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}").val();
            var picpath = $("#myImg${picture.path.replace('\\', '').replace('_', '').replace('.', '')}").attr("src");
            var newCreateTimeId = "#changeTime_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}";
            $("#second").val(old);
            myFunction(old,picpath,newCreateTimeId);
            </c:forEach>
            </c:forEach>
        });

        function myFunction(old,picpath,newCreateTimeId){
            setInterval(function(){
                    var newCreateTime = $(newCreateTimeId).val();
                    if(old != newCreateTime){
                        // alert(picpath+"---"+old +"---" + newCreateTime);
                        $.post(
                            "http://localhost:8080/pic/picture/ajaxUpdateInfo",
                            "newCreateTime=" + newCreateTime+
                            "&picpath=" + picpath,
                            function (data) {
                                if (data.status == 'success') {
                                    success_prompt(data.msg, 1500);
                                } else if (data.status == 'fail') {
                                    fail_prompt(data.msg, 2500);
                                } else if (data.status == 'unchange') {
                                    //  当名称没有变化时 不显示
                                } else {
                                    warning_prompt("其他未知错误.....please enjoy debug", 2500);
                                }
                            },
                            "json"
                        );
                        old = newCreateTime;
                    }
                    $("#second").val(newCreateTime);
                }
                ,2000);
        };

    </script>
</head>
<body>

<%--完美解决 图片的页面显示问题--%>

<h1 style="display : inline"><a href="picture/page" >  查看所有照片  </a> </h1>
<h1 style="display : inline"><a href="uploadDir.jsp" >  继续上传照片  </a> </h1>
<c:if test="${not empty justUploadMsg}">
    <h1 style="color: magenta">${justUploadMsg}</h1>
</c:if>
<div style="width:100%;height:100%;overflow: scroll;">
    <div class="panel-group" id="accordion">
        <c:set var="index" value="0" />
        <c:forEach var="item" items="${monthsTreeMapListPic}">
            <%--月份的div框--%>
            <div class="c2">
                <c:set var="index" value="${index+1}" />
                <button type="button" class="btn btn-primary" data-toggle="collapse"
                        data-target="#${item.key}" style="background: #e3e3e3">
                    <h2 style="color: chocolate">${item.key}</h2>
                </button>

                <%--最近一个月份的照片不折叠--%>
                <c:if test="${index.equals(1)}">
                    <div id="${item.key}" class="collapse in">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <%--现实照片拍摄的时间--%>
                                <c:if test="${not empty picture.pcreatime}">
                                    <div id='v_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}' style="float: right">
                                        <v-date-picker class="inline-block h-full" v-model="date" mode="dateTime" :timezone="timezone" is24hr :minute-increment="5" >
                                            <template v-slot="{ inputValue, togglePopover }">
                                                <div class="flex items-center">
                                                        <%--<span style="width:300px;height:30px;font-size:25px;">拍摄时间：</span>--%>
                                                    <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                                            @click="togglePopover({ placement: 'auto-start' })">
                                                            <%--<i class="fi-home"></i>--%>
                                                        <i class="fi-calendar"></i>
                                                    </button>
                                                    <input
                                                            :value="inputValue"
                                                            class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                                            id = "changeTime_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}"
                                                            style="font-weight: bold;width:125px;height:25px;font-size:15px; line-height:30px;border: 1px solid #ffe57d"
                                                            readonly
                                                    />
                                                </div>
                                            </template>
                                        </v-date-picker>
                                    </div>
                                    <input type="hidden" id="second" />
                                    <%--名称--%>
                                    <div class="imgDiv">
                                        <span align="center" style="color: seagreen;font-size:25px">${picture.pname.split("\\.")[0]}</span>
                                    </div>

                                </c:if>
                                <form action="picture/before_edit_picture" method="post" name="${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <div class="imgDiv">
                                        <input type="hidden" name="path" value="${picture.path}">

                                        <a href="javascript:document.${picture.path.replace('\\', '').replace('_', '').replace('.', '')}.submit();">
                                            <img id = "myImg${picture.path.replace('\\', '').replace('_', '').replace('.', '')}" src="${picture.path}" height="300px" >
                                        </a>
                                    </div>
                                </form>

                                  <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                               existImgPath = ${picture.path}>

                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${not index.equals(1)}">
                    <div id="${item.key}" class="collapse">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                <c:if test="${not empty picture.pcreatime}">
                                    <div id='v_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}' style="float: right">
                                        <v-date-picker class="inline-block h-full" v-model="date" mode="dateTime" :timezone="timezone" is24hr :minute-increment="5" >
                                            <template v-slot="{ inputValue, togglePopover }">
                                                <div class="flex items-center">
                                                        <%--<span style="width:300px;height:30px;font-size:25px;">拍摄时间：</span>--%>
                                                    <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                                            @click="togglePopover({ placement: 'auto-start' })">
                                                            <%--<i class="fi-home"></i>--%>
                                                        <i class="fi-calendar"></i>
                                                    </button>
                                                    <input
                                                            :value="inputValue"
                                                            class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                                            id = "changeTime_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}"
                                                            style="font-weight: bold;width:125px;height:25px;font-size:15px; line-height:30px;border: 1px solid #ffe57d"
                                                            readonly
                                                    />
                                                </div>
                                            </template>
                                        </v-date-picker>
                                    </div>
                                    <input type="hidden" id="second" />

                                    <%--<span align="center" style="font-size:18px;color: purple;font-weight:bold">${picture.pcreatime}</span><br/>--%>
                                    <%--名称--%>
                                    <div class="imgDiv">
                                        <span align="center" style="color: seagreen;font-size:25px">${picture.pname.split("\\.")[0]}</span>
                                    </div>

                                </c:if>
                                <form action="picture/before_edit_picture" method="post" name="${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <div class="imgDiv">
                                        <input type="hidden" name="path" value="${picture.path}">

                                        <a href="javascript:document.${picture.path.replace('\\', '').replace('_', '').replace('.', '')}.submit();">
                                            <img src="${picture.path}" height="300px" >
                                        </a>
                                    </div>
                                </form>
                                <input class="myselect" type="button" value="删除" style="font-size: larger;width: 100%;text-align:center"
                                       existImgPath = ${picture.path}>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <%--清除div的格式 以便于每月的图片另起一行显示--%>
                <div style="clear: both"></div>
            </div>
        </c:forEach>
    </div>
</div>

</div>

</body>
</html>
