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
            width: auto;
            height:300px;
        }
        /*月份的大框*/
        .c2{
            /*float: left;*/
            border: 2px solid green;
        }

        .imgDiv{
            width: auto;
            height:300px;
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

</head>
<body>
<%--${monthsTreeMapListPic}--%>
<%--完美解决 图片的页面显示问题--%>

<c:if test="${not empty justUploadMsg}">
    <h1 style="color: magenta">${justUploadMsg}</h1>
</c:if>
<%--${monthsTreeMapListPic}--%>
<div style="width:100%;height:100%;overflow: scroll;" id = "app">
    <div class="panel-group" id="accordion">
        <c:set var="index" value="0" />
        <c:forEach var="item" items="${monthsTreeMapListPic}">
            <%--月份的div框--%>
            <div class="c2">
                <c:set var="index" value="${index+1}" />
                <%-- 每个月的按钮 --%>
                <c:if test="${not empty item.value}">
                    <button type="button" class="btn btn-primary" data-toggle="collapse"
                            data-target="#${item.key}" style="background: #e3e3e3">
                        <h2 style="color: chocolate">${item.key}</h2>
                    </button>
                </c:if>

                <c:if test="${empty item.value}">
                   <h1 style="color: red">暂无照片</h1>
                </c:if>


                <%--最近一个月份的照片不折叠--%>
                <c:if test="${index.equals(1)}">
                    <div id="${item.key}" class="collapse in">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                        <%--    <div  style="border: 1px solid brown;float: right">
                                                <v-date-picker class="inline-block h-full" v-model="date" mode="time" is24hr :minute-increment="5"  :model-config="modelConfig" is-required>
                                                    <template v-slot="{ inputValue, togglePopover }">
                                                        <div class="flex items-center">
                                                            <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                                                    @click="togglePopover({ placement: 'auto-start' })">
                                                                <span class="glyphicon glyphicon-time" style="color:blue;font-size:10px;"></span>
                                                            </button>
                                                            <input
                                                                    :value="inputValue"
                                                                    class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                                                    style="font-size:15px; width:50px;border: 1px solid #ffe57d"
                                                                    readonly
                                                            />
                                                        </div>
                                                    </template>
                                                </v-date-picker>
                                            </div>
                                            <div  style="border: 1px solid palevioletred;float: right">
                                                <v-date-picker class="inline-block h-full" v-model="date" mode="date" :model-config="modelConfig" is-required>
                                                    <template v-slot="{ inputValue, togglePopover }">
                                                        <div class="flex items-center">
                                                            <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                                                    @click="togglePopover({ placement: 'auto-start' })">
                                                                <span class="glyphicon glyphicon-calendar" style="color:yellowgreen;font-size:10px;"></span>
                                                            </button>
                                                            <input
                                                                    :value="inputValue"
                                                                    class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                                                    style="font-size:15px; width:80px;border: 1px solid #ffe57d"
                                                                    readonly
                                                            />
                                                        </div>
                                                    </template>
                                                </v-date-picker>
                                            </div>
                               --%>
                                <form action="picture/before_edit_picture" method="post" name="${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <div id='v_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}'
                                         @mouseenter="enter()" @mouseleave="left()"
                                        class="imgDiv" path = "${picture.path}"
                                         style="position:relative;border: 1px solid yellow">
                                        <input type="hidden" name="path" value="${picture.path}">

                                        <img id = "myImg${picture.path.replace('\\', '').replace('_', '').replace('.', '')}"
                                             src="${picture.path}"
                                             class="tooltip-show"
                                             data-placement="top"
                                             data-toggle="tooltip"
                                             title="<h5>${picture.pname}</h5>${picture.pcreatime}"
                                             style="height: 100%;width: auto">

                                   <%--     <a href="javascript:document.${picture.path.replace('\\', '').replace('_', '').replace('.', '')}.submit();">


                                        </a>--%>
                                        <button v-show = "buttonShow" @click = "deletePicture()" type="button" class="btn btn-default  btn-sm"
                                                style="position:absolute; left: 48%; top: 90%;"
                                                data-placement="top"
                                                data-toggle="tooltip"
                                                title="点击删除照片">
                                            <span class="glyphicon glyphicon-trash" style="font-size:15px;"></span>
                                        </button>


                                    </div>
                                </form>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${not index.equals(1)}">
                    <div id="${item.key}" class="collapse">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1" id = "${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <%--    <div  style="border: 1px solid brown;float: right">
                                            <v-date-picker class="inline-block h-full" v-model="date" mode="time" is24hr :minute-increment="5"  :model-config="modelConfig" is-required>
                                                <template v-slot="{ inputValue, togglePopover }">
                                                    <div class="flex items-center">
                                                        <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                                                @click="togglePopover({ placement: 'auto-start' })">
                                                            <span class="glyphicon glyphicon-time" style="color:blue;font-size:10px;"></span>
                                                        </button>
                                                        <input
                                                                :value="inputValue"
                                                                class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                                                style="font-size:15px; width:50px;border: 1px solid #ffe57d"
                                                                readonly
                                                        />
                                                    </div>
                                                </template>
                                            </v-date-picker>
                                        </div>
                                        <div  style="border: 1px solid palevioletred;float: right">
                                            <v-date-picker class="inline-block h-full" v-model="date" mode="date" :model-config="modelConfig" is-required>
                                                <template v-slot="{ inputValue, togglePopover }">
                                                    <div class="flex items-center">
                                                        <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                                                @click="togglePopover({ placement: 'auto-start' })">
                                                            <span class="glyphicon glyphicon-calendar" style="color:yellowgreen;font-size:10px;"></span>
                                                        </button>
                                                        <input
                                                                :value="inputValue"
                                                                class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                                                style="font-size:15px; width:80px;border: 1px solid #ffe57d"
                                                                readonly
                                                        />
                                                    </div>
                                                </template>
                                            </v-date-picker>
                                        </div>
                           --%>
                                <form action="picture/before_edit_picture" name="${picture.path.replace('\\', '').replace('_', '').replace('.', '')}">
                                    <div id='v_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}'
                                         @mouseenter="enter()" @mouseleave="left()"
                                         class="imgDiv" style="position:relative;border: 1px solid yellow">
                                        <input type="hidden" name="path" value="${picture.path}">

                                        <a href="javascript:document.${picture.path.replace('\\', '').replace('_', '').replace('.', '')}.submit();">
                                            <img id = "myImg${picture.path.replace('\\', '').replace('_', '').replace('.', '')}"
                                                 src="${picture.path}"
                                                 class="tooltip-show"
                                                 data-placement="top"
                                                 data-toggle="tooltip"
                                                 title="<h5>${picture.pname}</h5>${picture.pcreatime}"
                                                 style="height: 100%;width: auto">

                                        </a>
                                        <button v-show = "buttonShow" @click = "deletePicture()" type="button" class="btn btn-default  btn-sm"
                                                style="position:absolute; left: 48%; top: 90%;"
                                                data-placement="top"
                                                data-toggle="tooltip"
                                                title="点击删除照片">
                                            <span class="glyphicon glyphicon-trash" style="font-size:15px;"></span>
                                        </button>


                                    </div>
                                </form>
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

<script src="https://apps.bdimg.com/libs/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<%-- v-calender 控件 有点冗余--%>
<script>

    $(function () { $("[data-toggle='tooltip']").tooltip({html : true,container: 'body' }); });

    <c:forEach var="item" items="${monthsTreeMapListPic}">
        <c:forEach items="${item.value}" var="picture" >
            var vm = new Vue({
                el: '#v_${picture.path.replace('\\', '').replace('_', '').replace('.', '')}',
                data:{
                    timezone: '',
                    date:  '${picture.pcreatime}',
                    modelConfig: {
                        type: 'string',
                        mask: 'YYYY-MM-DD HH:mm:ss', // Uses 'iso' if missing
                    },
                    buttonShow : false,
                },
                methods: {
                    deletePicture: function () {
                        // 函数传递 特殊字符有bug 故  更换获取方式
                        var existImgPath = $("#myImg${picture.path.replace('\\', '').replace('_', '').replace('.', '')}").attr('src');
                        // 要replaceAll  下面的则不需要 尬
                        var divID = existImgPath.replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                        $.post(
                            "http://localhost:8080/pic/picture/ajaxDeletePic",
                            "existImgPath=" + existImgPath,
                            function (data) {
                                if (data.status == 'success') {
                                    $("#" + divID).remove();
                                    success_prompt(data.msg, 1500);
                                } else if (data.status == 'fail') {
                                    fail_prompt(data.msg, 2500);
                                } else {
                                    warning_prompt("其他未知错误.....please enjoy debug", 2500);
                                }
                            },
                            "json"
                        );
                    },
                    enter: function () {
                        this.buttonShow = true;
                    },
                    left: function () {
                        this.buttonShow = false;
                    },

                }
            });
            vm.$watch('date', function(newValue, oldValue) {
                if(newValue !="" && oldValue!="" && newValue!=oldValue){
                    var picpath = $("#myImg${picture.path.replace('\\', '').replace('_', '').replace('.', '')}").attr("src");
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
        </c:forEach>
    </c:forEach>
</script>
</body>
</html>
