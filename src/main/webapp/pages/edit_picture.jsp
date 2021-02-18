<html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<head>
    <style>
        .app{
            width:100%;
            height:100%;
            overflow: scroll;
        }
        .c1{
            border: 1px solid red;
        }

        .c2{
            float: left;
            overflow: auto;
            height:100%;
            width: 60%;;
            /*border: 2px solid green;
            height:100%;
            width: 60%;;
            display: inline-block;

            top: 10px;
            left: 0;
            right: 0;
            bottom: 0;
            margin: auto;*/
            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
            /*为了效果明显，可以将如下边框打开，看一下效果*/
            border:1px solid red;
        }
        .c2 img{
            width:auto;
            height:100%;
          /*  width:100%;
            height:auto;*/
        }


        .c3{
            float: right;
            border: 1px solid gold;
            display: inline-block;
            width:39%;
            height: 100%;
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
        }

        .alert-danger {
            color: #a94442;
            background-color: #f2dede;
            border-color: #ebccd1;
        }
    </style>
    <%--/* textarea 自适应父容器大小 */--%>
    <style>

        .comments {
            width: 100%; /*自动适应父布局宽度*/
            height: 100%; /*自动适应父布局宽度*/
            overflow: auto;
            word-break: break-all;
            /*background-color: yellow;*/
            font-size: 2em;
            font-weight: bold;
            font-family: Verdana, Arial, Helvetica, sans-serif;
            border: 1px solid black;"
        }

        span,input{
            font-size: 2em;
            font-weight: bold;
            font-family: Verdana, Arial, Helvetica, sans-serif;
        }
    </style>
    <script type="text/javascript">
        // 页面加载完成之后
        $(function () {
            // 使用ajax给用户名 实时 返回信息
            // 不重名就直接进行修改
            $("#pname").on('blur',function(){
                var pname = $("#pname").val();
                var pictype = $("#pname").attr('pictype');
                var picpath = $("#myImg").attr('src');
                $.post(
                    "http://localhost:8080/pic/picture/ajaxUpdateInfo",
                    "pname=" + pname+
                    "&pictype=" + pictype+
                    "&picpath=" + picpath,
                    function (data) {
                        if (data.status == 'success') {
                            success_prompt(data.msg, 1500);
                            $("#myImg").attr("src",data.newPath);
                            $("span.errorMsg").text("");
                        } else if (data.status == 'fail') {
                            fail_prompt(data.msg, 2500);
                            $("span.errorMsg").text("照片名称已存在，请重新输入");
                        } else if (data.status == 'unchange') {
                        //  当名称没有变化时 不显示
                        } else {
                            warning_prompt("其他未知错误.....please enjoy debug", 2500);
                        }
                    },
                    "json"
                );
            });
            $("#pdesc").on('blur',function(){
                var pictype = $("#pname").attr('pictype');
                var picpath = $("#myImg").attr('src');
                var pdesc = $("#pdesc").val();
                $.post(
                    "http://localhost:8080/pic/picture/ajaxUpdateInfo",
                    "pictype=" + pictype+
                    "&picpath=" + picpath+
                    "&pdesc=" + pdesc,
                    function (data) {
                        if (data.status == 'success') {
                            success_prompt(data.msg, 1500);
                            $("span.errorMsg").text("");
                        } else if (data.status == 'fail') {
                            fail_prompt(data.msg, 2500);
                            $("span.errorMsg").text("照片名称已存在，请重新输入");
                        } else if (data.status == 'unchange') {

                        } else{
                            warning_prompt("其他未知错误.....please enjoy debug", 2500);
                        }
                    },
                    "json"
                );
            });
            $('.myselect').on('click', function () {
                var existImgPath = $(this).attr('existImgPath');
                // 要replaceAll  下面的则不需要 尬
                var divID = $(this).attr('existImgPath').replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                $.post(
                    "http://localhost:8080/pic/picture/ajaxDeletePic",
                    "existImgPath=" + existImgPath,
                    function (data) {
                        if (data.status == 'success') {
                            $("#" + divID).remove();
                            success_prompt(data.msg, 1500);
                            countDown(2);
                        } else if (data.status == 'fail') {
                            fail_prompt(data.msg, 2500);
                        } else {
                            warning_prompt("其他未知错误.....please enjoy debug", 2500);
                        }
                    },
                    "json"
                );
            });
        });
    </script>


    <%--alert自动消失--%>
    <script type="text/javascript">
        var countDown = function (secs){
            if(--secs>0){
                setTimeout("countDown("+secs+")",1000);
            }else{
                $(window).attr("location","pages/picture.jsp");
            }
        };
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
<h1 style="display : inline"><a href="picture/page" >  查看所有照片  </a> </h1>
<%--显示大图--%>
<div class="app" name = "div1">
        <%--显示 照片名称  拍摄时间 地点--%>
        <div class="c1" name = "div2">
            <span style="width:300px;height:30px;font-size:25px;">照片名称：</span>
            <input style="width:300px;height:30px;font-size:25px; line-height:40px;border: 1px solid #ffe57d" id="pname" name = "pname" value="${picture.pname}" pictype=${type} >

            <%--提示是否有重名的信息  错误信息  跟上面对应起来要写class--%>
            <span class="errorMsg" style="color: red;"></span>


            <c:if test="${empty picture.pcreatime}">
                <span tyle="color: darksalmon">神秘时间</span>
            </c:if>
            <c:if test="${not empty picture.pcreatime}">
                <div id='myTimeChangeDemo' style="float: right">
                    <v-date-picker v-model="date" mode="dateTime" :timezone="timezone" is24hr :minute-increment="5">
                        <template v-slot="{ inputValue, inputEvents }" >
                            <span style="width:300px;height:30px;font-size:25px;">拍摄时间：</span>
                            <input
                                    class="bg-white border px-1 py-1 rounded"
                                    :value="inputValue"
                                    v-on="inputEvents"
                                    id = "changeCreateTime"
                                    style="width:300px;height:30px;font-size:25px; line-height:30px;border: 1px solid #ffe57d"
                            />
                        </template>
                    </v-date-picker>
                </div>
                <input type="hidden" id="second" />
                <%--<span style="color: darksalmon">${picture.pcreatime}</span>--%>
            </c:if>

            <span style="width:300px;height:30px;font-size:25px;">坐标：</span>
            <c:if test="${empty picture.gpsLongitude}">
                <span style="color: green;width:300px;height:30px;font-size:25px;">神秘未知</span>
            </c:if>
            <c:if test="${not empty picture.gpsLongitude}">
                <span style="color: green">${picture.gpsLongitude}</span>
                <span style="color: green">${picture.gpsLatitude}</span>
            </c:if>

            <%--显示照片--%>

            <div class="c2">
                <input class="myselect" type="button" value="删除" style="font-size: larger;width: 10%;text-align:center"
                       handleMethod ="deleteSingle" existImgPath = ${picture.path}>
                <img id = "myImg" src="${picture.path}" width="800">
            </div>
        </div>


        <%--添加描述--%>
        <div class="c3" >
            <c:if test="${empty picture.pdesc}">
                  <textarea class="comments" rows="4" cols="50"
                            placeholder="从我这里可以添加描述鸟..."
                            id = "pdesc"
                            name = "pdesc"
                  ></textarea>
            </c:if>
            <c:if test="${not empty picture.pdesc}">
                  <textarea class="comments" rows="4" cols="50"
                            id = "pdesc"
                            name = "pdesc"
                  >${picture.pdesc}</textarea>
            </c:if>
        </div>

</div>
<%-- v-calender 控件--%>
<script>
    $(function () {
        var old = $("#changeCreateTime").val();
        var picpath = $("#myImg").attr("src");
        $("#second").val(old);
        myFunction(old,picpath);

    });
    function myFunction(old,picpath){
        setInterval(function(){
                var newCreateTime = $("#changeCreateTime").val();
                if(old != newCreateTime){
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
                    // alert(vue);
                    old = newCreateTime;
                }
                $("#second").val(newCreateTime);
            }
            ,2000);
    }
</script>
<script>
    new Vue({
        el: '#myTimeChangeDemo',
        data:{
            timezone: '',
            // date: '1983-01-21T07:30:00',
            date:  '${picture.pcreatime}',
        },
    });
</script>
</html>
