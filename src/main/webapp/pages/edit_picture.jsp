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
            width: 60%;
            height: 600px;

            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
            /*为了效果明显，可以将如下边框打开，看一下效果*/
            border:1px solid red;
        }

        .c3{
            float: right;
            border: 1px solid gold;
            display: inline-block;
            width:39%;
            height: 600px;
        }

        span{
            font-size: 25px;
        }
        <%--/* textarea 自适应父容器大小 */--%>
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
        
    </style>
</head>
<body>


<div class="container"  id="app" style="padding-left: 0px; padding-right: 0px;">
    <div class="row">
        <div class="col-md-1" style="padding-left: 0px; padding-right: 0px;border: 1px solid red">
            <%--照片名称--%>
            <span>名称：</span>
        </div>

        <div class="col-md-2" style="padding-left: 0px; padding-right: 0px;">
            <%-- 对input框双重监控 失去焦点 和 按下enter 都可触发修改事件 --%>
            <input class="form-control" @keyup.enter="changeName()"  value="${picture.pname}" pictype=${type}   @blur="changeName()" id="pname" name = "pname" style="font-size:25px;">
        </div>

        <div class="col-md-3" style="padding-left: 0px; padding-right: 0px;">
            <span style="width:300px;height:30px;font-size:25px;">坐标：</span>
            <span v-if = "picture.gpsLongitude=='' || picture.gpsLongitude == '' " style="color: green;width:300px;height:30px;font-size:25px;">神秘未知</span>
            <span v-else style="color: green">
            ${picture.gpsLongitude},${picture.gpsLatitude}
        </div>

        <%--时间和坐标信息--%>
        <div class="col-md-5 pull-right" style="padding-left: 0px; padding-right: 0px;">
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
                                        id = "datePicker"
                                        :value="inputValue"
                                        class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                        style="width:130px;font-size:25px;height:30px;border: 1px solid #ffe57d"
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
                                        id = "timePicker"
                                        :value="inputValue"
                                        class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                        style="width:70px;font-size:25px;height:30px;border: 1px solid #ffe57d"
                                        readonly
                                />
                            </div>
                        </template>
                    </v-date-picker>
                </div>
            </div>
        </div>

        <%-- 照片 标签显示区--%>
        <div id="picTags" class="col-md-2 pull-right" picPath = ${picture.path} style="padding-left: 0px; padding-right: 0px;">

        </div>
    </div>

    <div class="row">
        <%--显示 照片名称  添加描述 --%>
        <div class="c1" name = "div2">
        <div class="c2" @mouseenter="enter()" @mouseleave="left()">
            <%--显示照片--%>
            <img id = "myImg"
                 src="${picture.path}"
                 style="height: 100%;width: auto;position:relative;border: 1px solid yellow">
            <button v-show = "buttonShow" @click = "deletePicture()" type="button" class="btn btn-default  btn-sm"
                    style="position:absolute; left: 50%"
                    data-placement="top"
                    data-toggle="tooltip"
                    title="点击删除照片">
                <span class="glyphicon glyphicon-trash" style="font-size:15px;"></span>
            </button>
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
    </div>
</div>

</body>

<%-- v-calender 控件--%>
<script>
    $(function () {
        $("[data-toggle='tooltip']").tooltip();
        // 删除照片标签
        $('body').on('click','.close',function(){
            var deleteLabel = $(this).next().text();
            var picPath = $("#myImg").attr('src');
            $.post(
                "http://localhost:8080/pic/label/ajaxDeleLabel",
                "deleteLabel=" + deleteLabel+
                "&picPath=" + picPath,
                function (data) {
                    if (!data.isDelete) {
                        alert("失败 -- 从数据库删除标签")
                    };
                },
                "json"
            );

        });
        if('${picture.plabel}'.length>0){
            var labelList = '${picture.plabel}'.split(",");
            alert('${picture.plabel}' + "----"+labelList.length);
            for (var i = 0; i < labelList.length; i++) {
                addLabel(labelList[i]);
            }
        }

        function addLabel(newlabelName){
            var html ='<div id="myAlert" class="alert alert-default" style="float:left;width:fit-content;">' +
                '<span class="close" data-dismiss="alert">&times; </span>' +
                '<strong id = '+newlabelName+'>'
                + newlabelName + '</strong></div>';
            $("#picTags").append(html);

        };
    });
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
            buttonShow : false,
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
            deletePicture: function () {
                // 函数传递 特殊字符有bug 故  更换获取方式
                var existImgPath = $("#myImg").attr('src');
                // 要replaceAll  下面的则不需要 尬
                var divID = existImgPath.replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
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
