<html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <style>
        .app{
            width:100%;
            height:100%;
            overflow: scroll;
        }
        .c1{
            border: 1px solid red;
        }

        .editImgDiv{
            float: left;

            height: 500px;
            width: 500px;
            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
            /*为了效果明显，可以将如下边框打开，看一下效果*/
            border:1px solid red;
        }

       /* .editImgDiv img{
            !*width: 100%;*!
            height: 600px;

        }*/
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
<div class="container"  id="app" style="width:100%;height:100%;overflow: scroll;padding-left: 20px; padding-right: 20px;">
    <%-- 照片基本信息显示区 --%>
    <div class="row">
        <%--照片名称--%>
        <div class="col-md-2" style="padding-left: 0px; padding-right: 0px;border: 1px solid red">
            <span >名称：</span>
        </div>
        <%--照片名称 修改框--%>
        <div class="col-md-2" style="padding-left: 0px; padding-right: 0px;border: 1px solid pink">
            <%-- 对input框双重监控 失去焦点 和 按下enter 都可触发修改事件 --%>
            <input class="form-control" @keyup.enter="changeName()"  value="${picture.pname}" pictype=${type}   @blur="changeName()" id="pname" name = "pname" style="font-size:25px;">
        </div>
        <%--坐标信息显示--%>
        <div class="col-md-3" style="padding-left: 0px; padding-right: 0px;border: 1px solid peru">
            <span style="width:300px;height:30px;font-size:25px;">坐标：</span>
            <span v-if = "picture.gpsLongitude=='' || picture.gpsLongitude == '' " style="color: green;width:300px;height:30px;font-size:25px;">神秘未知</span>
            <span v-else style="color: green">
            ${picture.gpsLongitude},${picture.gpsLatitude}
        </div>

        <%--时间信息--%>
        <div class="col-md-5 pull-right" style="padding-left: 0px; padding-right: 0px;border: 1px solid darkred">
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
    </div>

    <%-- 照片 标签显示区--%>
    <div class="row">
        <div id="picTags" class="col-md-10" style="padding-left: 0px; padding-right: 0px;" picPath = ${picture.path} ></div>
    </div>

    <%--显示 照片  添加描述 --%>
    <div class="row">
        <%--显示 照片名称 --%>
        <div class="col-md-8" name = "div2">
            <%--显示照片--%>
            <div class="editImgDiv" id='${picture.pid}' @mouseenter="enter()" @mouseleave="left()">
                <img id = "v_${picture.pid}"
                     src="${picture.path}"
                     class="labelDown"
                     onload="loadImage(this)">
                <button v-show = "buttonShow" @click = "deletePicture()" type="button" class="btn btn-default  btn-sm"
                        style="position:absolute; left: 90%;top: 45%"
                        data-placement="top"
                        data-toggle="tooltip"
                        title="点击删除照片">
                    <span class="glyphicon glyphicon-trash" style="font-size:15px;"></span>
                </button>
                <button v-show = "buttonShow" @click = "regFace()" type="button" class="btn btn-default  btn-sm"
                        style="position:absolute; left: 90%;top: 55%"
                        data-placement="top"
                        data-toggle="tooltip"
                        title="识别人脸">
                    <span class="glyphicon glyphicon-user" style="font-size:15px;"></span>
                </button>
            </div>
        </div>
        <%--添加描述--%>
        <div class="col-md-4">
          <textarea v-if = "picture.pdesc == '' "
                    @keyup.enter="changeDesc()" @blur = "changeDesc()"
                    class="comments" rows="4" cols="50"
                    placeholder="从我这里可以添加描述鸟..."
                    id = "pdesc"
                    name = "pdesc"></textarea>
            <textarea v-else class="comments" rows="4" cols="50"
                      @keyup.enter="changeDesc()" @blur = "changeDesc()"
                      id = "pdesc"
                      name = "pdesc">${picture.pdesc}</textarea>
        </div>

    </div>
    </div>
</div>

</body>

<%-- v-calender 控件--%>
<script>

    function loadImage(imgD){
        var div_width = document.getElementById("${picture.pid}").offsetWidth;
        var div_height = document.getElementById("${picture.pid}").offsetHeight;

        // 图片地址
        var img = new Image();
        img.src = imgD.src;

        var img_w = img.width;
        var img_h = img.height;

        var scale_w = div_width/img_w;

        var flag = false;
        if(img_w>div_width){
            img_w = div_width;
            img_h = img_h*scale_w;
            flag = true;
        }

        var scale_h = div_height/img_h;
        if(img_h>div_height){
            img_w = img_w*scale_h;
            img_h = div_height;
            flag = true;
        }
        if(flag){
            imgD.height=img_h;
            imgD.width = img_w;
        }

    }

    $(function () {
        console.log("edit 页面加载了...");
        // 删除照片标签
        $('#picTags').on('click','.close',function(){
            var deleteLabelId = $(this).next().attr("id");
            var deleteLabelName = $(this).next().text();
            var pId = '${picture.pid}';
            var picName = '${picture.pname}';
            console.log("点击x 标签","picName--",picName,"deleteLabelName--",
                deleteLabelName,"deleteLabelId--",deleteLabelId);
            $.post(
                "http://localhost:8080/pic/label/ajaxDeletePicLabel",
                "deleteLabelId=" + deleteLabelId+
                "&pId=" + pId,
                function (data) {
                    if (!data.isDelete) {
                        alert("失败 -- 从数据库删除标签")
                    }else {
                        console.log("成功 -- 从数据库删除标签")
                        reLoadLeftPage();
                    }
                },
                "json"
            );
        });
        if('${picture.plabel}'.length>0){
            var labelNameList = '${picture.plabel}'.split(" ");
            var labelIdList = '${labelIds}'.split(" ");
            console.log("picture.plabel",'${picture.plabel}',"labelList.length",labelNameList.length);
            // 解决 添加后出现多个标签的bug 先清空再添加
            $("#picTags").empty();
            for (var i = 0; i < labelNameList.length; i++) {
                addLabel(labelIdList[i],labelNameList[i]);
            }
        }
        function addLabel(newLabelId,newlabelName){
            var html ='<div id="myAlert" class="alert alert-default" style="float:left;width:fit-content;">' +
                '<span class="close" data-dismiss="alert">&times; </span>' +
                '<strong id = '+newLabelId+'>'
                + newlabelName + '</strong></div>';
            $("#picTags").append(html);

        };
        $("[data-toggle='tooltip']").tooltip({html : true});
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
                var picpath = '${picture.path}';
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
                var picpath = '${picture.path}';
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
                var existImgPath = '${picture.path}';
                var pId = '${picture.pid}';
                // 要replaceAll  下面的则不需要 尬
                // var divID = existImgPath.replaceAll('\\', '').replaceAll('\_', '').replaceAll('\.', '');
                $.post(
                    "http://localhost:8080/pic/picture/ajaxDeletePic",
                    "pId="+pId,
                    function (data) {
                        if (data.status == 'success') {
                            $("#rightPage").load("picture/page");
                            // $("#" + divID).remove();
                            // success_prompt(data.msg, 1500);
                            // countDown(2);
                            console.log("成功-- 删除照片")
                        } else if (data.status == 'fail') {
                            // fail_prompt(data.msg, 2500);
                            console.log("失败-- 删除照片")
                        } else {
                            // warning_prompt("其他未知错误.....please enjoy debug", 2500);
                        }
                    },
                    "json"
                );
            },
            regFace: function () {
                // 函数传递 特殊字符有bug 故  更换获取方式
                // 直接取值时会有字符错误
                var imgPath = $("#v_${picture.pid}").attr("src");
                var pId = "${picture.pid}";
                console.log("regFace",imgPath);
                $.post(
                    "http://localhost:8080/pic/face/getFace",
                    "pId="+pId+"&imgPath="+imgPath,
                    function (data) {

                        if(data.faceNum != 0){
                            console.log("进入跳转");
                            var html = "  <canvas id=\"myCanvas\"  width=\"800\"  height=\"1800\" style=\"border:1px solid red;\">\n" +
                                "        这是浏览器不支持canvas时展示的信息\n" +
                                "    </canvas>";
                            $("#${picture.pid}").html(html);

                            var canvasId = "myCanvas";
                            var faceNum = data.faceNum;
                            var rects = JSON.parse(data.face_locations);
                            var points = JSON.parse(data.face_landmarks);
                            var faceNamesList = data.faceNamesList;
                            var srcImgPath = data.srcImgPath;
                            canvasPart(canvasId,srcImgPath,rects,points,faceNum,faceNamesList);
                        }else {
                            console.log("未检测到人脸");
                            alert("未检测到人脸");
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

    $(document).ready(function(){
        reLoadLeftPage();
    });
</script>

<script>
    function canvasPart(canvasId,srcImgPath,rects,points,faceNum,faceNamesList) {
        var c = document.getElementById(canvasId);

        var ctx = c.getContext("2d");
        var img = new Image();
        // 这里可以放 图片路径 "./test.jpg"  || base64图片 || 图片链接
        img.src = srcImgPath;
        img.onload = function () {
            // 设置图片在canvas上 前面两个0,0是边距, 后面是宽高
            // 让绘图自适应 canvas 尺寸
            var img_w = img.width;
            var img_h = img.height;

            var ch = 500;
            var scale = ch/img_h;
            $("#"+canvasId).attr("height",ch);
            $("#"+canvasId).attr("width",img_w/img_h*ch);
            // console.log("cw,ch: ",img_w/img_h*800,ch,"img_w,img_h: ",img_w,img_h);

            ctx.drawImage(img, 0, 0,img_w/img_h*ch,ch);

            // 添加文字 后面两个数字是坐标
            ctx.font  = "30px sans-serif";
            ctx.fillStyle = '#fc0000';
            ctx.fillText("face Num :"+faceNum, 10, 50);

            for (var i = 0; i < rects.length; i++) {
                // 画矩形 前两个数字是坐标, 后面是矩形的宽高 fillRect是填充的
                ctx.lineWidth = 3;
                ctx.strokeStyle = '#64e204';
                ctx.strokeRect(rects[i][0]*scale, rects[i][1]*scale, rects[i][2]*scale, rects[i][3]*scale);
                // 显示人名
                ctx.font  = "20px sans-serif";
                ctx.fillStyle = '#000000';
                ctx.fillText(faceNamesList[i], rects[i][0]*scale, rects[i][1]*scale-10);
                //  画圈
                var r = 1;
                for (var j = 0; j < points[0].length; j++) {
                    // ctx.strokeStyle = '#03e2db';
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.arc(points[i][j][0]*scale,points[i][j][1]*scale,r,0,Math.PI*2,true);
                    // ctx.stroke();// 空心圆
                    ctx.fillStyle="#69fcd5";
                    ctx.fill();//画实心圆

                }
            }
        }
    }

</script>

</html>
