<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/11
  Time: 15:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
  <%--  <style type="text/css">
        p img
        {
            position:absolute;
            /*rect (top, right, bottom, left) */
            clip:rect(100px 500px 200px 0px)
        }
    </style>--%>

</head>
<body>

<div style="display: flex;float: left">
    <canvas id="myCanvas" style="border:1px solid red;">
        这是浏览器不支持canvas时展示的信息
    </canvas>
</div>
<div id = "right" style="float: left">
    截取照片 可进行轮播
</div>

<p>clip 属性剪切了一幅图像：</p>
原图：<img style="float: left" src="img\2021\01\2021_01_28T21_06_27.jpeg"  height="500">
裁剪:
        <%--/*rect (top, right, bottom, left) */--%>

        <div style="float: left"><img src="img\2021\01\2021_01_28T21_06_27.jpeg"
                height="500"
                style="position: absolute;clip: rect(400px 500px 600px 0px)">
        </div>

        <div style="float: left"><img src="img\2021\01\2021_01_28T21_06_27.jpeg"
                height="500"
                style="position: absolute;clip: rect(200px 500px 300px 0px)">
        </div>

     <%--   <p><img src="img\2021\01\2021_01_28T21_06_27.jpeg"
                height="500"
                style="position: absolute;
                            clip: rect(400px 500px 200px 0px)">
        </p>
        <p><img src="img\2021\01\2021_01_28T21_06_27.jpeg"
                height="500"
                style="position: absolute;
                            clip: rect(700px 500px 800px 0px)">
        </p>--%>


<%--<script>


        var imgPath = "img\\2021\\01\\2021_01_28T21_06_27.jpeg";
        var pId = "_0110010001000001000001000101111100101000111011001010100100000000";
        // vue的 id不能纯数字开头
        picId = pId.substring(pId.indexOf("_")+1,pId.length);
        console.log(picId);

        $.post(
            "http://localhost:8080/pic/face/getFace",
            "pId="+picId+"&imgPath="+imgPath,
            function (data) {

                if(data.faceNum != 0){
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
            // console.log(rects,"图片高度",img_h,"图片宽度",img_w,);
            // console.log("画布高度",ch,"画布宽度",img_w*scale,"缩放比例：",scale);
            $("#"+canvasId).attr("height",ch);
            $("#"+canvasId).attr("width",img_w*scale);
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
                // console.log("绘制矩形框：",rects[i][0]*scale, rects[i][1]*scale, rects[i][2]*scale, rects[i][3]*scale)
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

</script>--%>
</body>
</html>
