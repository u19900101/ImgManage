<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <%-- 单独引入 为了tooltip正常显示--%>
    <link rel="stylesheet" href="static/bootstrap-3.3.7/css/bootstrap.min.css">
    <script src="static/bootstrap-3.3.7/js/bootstrap.min.js"></script>
</head>
<head>

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
                    <button class="btn btn-primary"  data-target="#${item.key}" style="background: #e3e3e3"> <h2 style="color: chocolate">${item.key}</h2> </button>
                </c:if>


                <c:if test="${empty item.value}">
                   <h1 style="color: red">暂无照片</h1>
                </c:if>


                <%--最近一个月份的照片不折叠--%>
                <c:if test="${index.equals(1)}">
                    <div id="${item.key}" class="collapse in">
                        <c:forEach items="${item.value}" var="picture" >
                            <div class="c1"  id='v_${picture.pid}'>
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

                                    <div id='labelDown_${picture.pid}'
                                         @mouseenter="enter()" @mouseleave="left()"
                                         class="labelDown"
                                         path = "${picture.path}"
                                         style="position:relative;border: 1px solid yellow">
                                        <input type="hidden" name="path" value="${picture.path}">

                                        <img
                                             id='img_${picture.pid}'
                                             src="${picture.path}"
                                             class="tooltip-show"
                                             data-placement="top"
                                             data-toggle="tooltip"
                                             title="<h5>${picture.pname}</h5>${picture.pcreatime}"
                                             style="height: 100%;width: auto">

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
                            <div class="c1" id='v_${picture.pid}'>
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
                                    <div id='labelDown_${picture.pid}'
                                         @mouseenter="enter()" @mouseleave="left()"
                                         class="labelDown" path = "${picture.path}" style="position:relative;border: 1px solid yellow">
                                        <input type="hidden" name="path" value="${picture.path}">

                                        <img
                                            id='img_${picture.pid}'
                                             src="${picture.path}"
                                             class="tooltip-show"
                                             data-placement="top"
                                             data-toggle="tooltip"
                                             title="<h5>${picture.pname}</h5>${picture.pcreatime}"
                                             style="height: 100%;width: auto">
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

<%-- v-calender 控件 有点冗余--%>

<script>


</script>
<script>
    $(function () {
        console.log("picture 页面加载了！");
        <c:forEach var="item" items="${monthsTreeMapListPic}">
            <c:forEach items="${item.value}" var="picture" >
                var vm = new Vue({
                    // 纯数字id容易出错
                    el: '#v_${picture.pid}',
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
                            var pId = '${picture.pid}';
                            $.post(
                                "http://localhost:8080/pic/picture/ajaxDeletePic",
                                "pId=" + pId,
                                function (data) {
                                    if (data.status == 'success') {
                                        $("#" + pId).remove();
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
        $("[data-toggle='tooltip']").tooltip({html : true});

        $(".btn").on("click",function () {

            var targetId  = $(this).attr("data-target");
            console.log(targetId);
            $(targetId).collapse('toggle');
        })
    });
    function reLoadLeftPage(){
        var labelHref = "label/getLabelTree";
        $("#jstree").load(labelHref);
    }
    $(document).ready(function(){
        reLoadLeftPage();
    });
</script>
</html>
