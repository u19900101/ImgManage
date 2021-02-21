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

    <%--ajax--%>
    <script type="text/javascript">
        // 页面加载完成之后
        $(function () {
            // 使用ajax给用户名 实时 返回信息
            // 不重名就直接进行修改
            $("#pdesc").on('blur',function(){

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
</head>
<body>
<h1 style="display : inline"><a href="picture/page" >  查看所有照片  </a> </h1>
<%--显示大图--%>
<div id="app">
        <%--显示 照片名称  拍摄时间 地点--%>
        <div class="c1" name = "div2">
            <span style="width:300px;height:30px;font-size:25px;">名称：</span>
            <%-- 对input框双重监控 失去焦点 和 按下enter 都可触发修改事件 --%>
            <input @keyup.enter="changeName()" @blur = "changeName()" style=" border-radius: 8px;width:300px;height:30px;font-size:25px; line-height:40px;border: 1px solid #ffe57d" id="pname" name = "pname" value="${picture.pname}" pictype=${type} >

            <%--提示是否有重名的信息  错误信息  跟上面对应起来要写class--%>
            <span class="errorMsg" style="color: red;"></span>
            <span v-if = "picture.pcreatetime==''" style="color: darksalmon">神秘时间</span>

            <div v-if = "picture.pcreatetime!=''" style="float: right;border: 1px solid rebeccapurple">
                <div id = "dateDiv" style="border: 1px solid palevioletred;float: left;height:30px;">
                    <v-date-picker class="inline-block h-full" v-model="date" mode="date" :model-config="modelConfig" is-required>
                        <template v-slot="{ inputValue, togglePopover }">
                            <div class="flex items-center">
                                <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                        @click="togglePopover({ placement: 'auto-start' })">
                                    <span class="glyphicon glyphicon-calendar" style="color:yellowgreen;font-size:15px;"></span>
                                </button>
                                <input
                                        :value="inputValue"
                                        class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                        style="width:200px;font-size:25px;height:30px;border: 1px solid #ffe57d"
                                        readonly
                                />
                            </div>
                        </template>
                    </v-date-picker>
                </div>
                <div id = "timeDiv" style="border: 1px solid brown;float: right;height:30px;">
                    <v-date-picker class="inline-block h-full" v-model="date" mode="time" is24hr :minute-increment="5"  :model-config="modelConfig" is-required>
                        <template v-slot="{ inputValue, togglePopover }">
                            <div class="flex items-center">
                                <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                        @click="togglePopover({ placement: 'auto-start' })">
                                    <span class="glyphicon glyphicon-time" style="color:blue;font-size:15px;"></span>
                                </button>
                                <input
                                        :value="inputValue"
                                        class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                        style="width:100px;font-size:25px;height:30px;border: 1px solid #ffe57d"
                                        readonly
                                />
                            </div>
                        </template>
                    </v-date-picker>
                </div>
            </div>


            <span style="width:300px;height:30px;font-size:25px;">坐标：</span>
            <span v-if = "picture.gpsLongitude=='' || picture.gpsLongitude == '' " style="color: green;width:300px;height:30px;font-size:25px;">神秘未知</span>
            <span v-else style="color: green">
                ${picture.gpsLongitude},${picture.gpsLatitude}
            </span>

            <%--显示照片--%>

            <div class="c2">
                <input class="myselect" type="button" value="删除" style="font-size: larger;width: 10%;text-align:center"
                       handleMethod ="deleteSingle" existImgPath = ${picture.path}>
                <img id = "myImg" src="${picture.path}" width="800">
            </div>
        </div>

        <%--添加描述--%>
        <div class="c3" >

              <textarea v-if = "picture.pdesc == '' "
                        @keyup.enter="changeDesc()" @blur = "changeDesc()"
                        class="comments" rows="4" cols="50"
                        placeholder="从我这里可以添加描述鸟..."
                        id = "pdesc"
                        name = "pdesc"
              ></textarea>
              <textarea v-else class="comments" rows="4" cols="50"
                        @keyup.enter="changeDesc()" @blur = "changeDesc()"
                        id = "pdesc"
                        name = "pdesc"
              >${picture.pdesc}</textarea>

        </div>

</div>
<%-- v-calender 控件--%>
<script>
    var vm = new Vue({
        el: '#app',
        data:{
            timezone: '',
            date:'${picture.pcreatime}',
            picture:{
                pcreatetime:'${picture.pcreatime}',
                gpsLongitude:'${picture.gpsLongitude}',
                gpsLatitude:'${picture.gpsLatitude}',
                pdesc : '${picture.pdesc}',
            },
            modelConfig: {
                type: 'string',
                mask: 'YYYY-MM-DD HH:mm:ss', // Uses 'iso' if missing
            },
        },
        methods: {
            changeName: function () {
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
            },
            changeDesc: function () {
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
            },
        }
    });
    vm.$watch('date', function(newValue, oldValue) {
        if(newValue !="" && oldValue!="" && newValue!=oldValue){
            var picpath = $("#myImg").attr("src");
            // alert('old is ---' + oldValue + '--- new is ---' + newValue + '---!'+"path is  --"+picpath);
            $.post(
                "http://localhost:8080/pic/picture/ajaxUpdateInfo",
                "newCreateTime=" + newValue+
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
        }
    });
</script>
</html>
