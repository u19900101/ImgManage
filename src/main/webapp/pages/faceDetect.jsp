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

<body>

<div style="display: flex;">
    <canvas id="myCanvas"  width="800"  height="1800" style="border:1px solid red;">
        这是浏览器不支持canvas时展示的信息
    </canvas>
</div>


<script>
    function canvasPart(canvasId,srcImgPath,rects,points,text) {
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

            var ch = 800;
            var scale = ch/img_h;
            $("#"+canvasId).attr("height",ch);
            $("#"+canvasId).attr("width",img_w/img_h*800);
            // console.log("cw,ch: ",img_w/img_h*800,ch,"img_w,img_h: ",img_w,img_h);

            ctx.drawImage(img, 0, 0,img_w/img_h*800,ch);

            // 添加文字 后面两个数字是坐标
            ctx.font  = "30px sans-serif";
            ctx.fillStyle = '#fc0000';
            ctx.fillText("face Num :"+text, 10, 50);

            for (var i = 0; i < rects.length; i++) {
                // 画矩形 前两个数字是坐标, 后面是矩形的宽高 fillRect是填充的
                ctx.lineWidth = 3;
                ctx.strokeStyle = '#64e204';
                ctx.strokeRect(rects[i][0]*scale, rects[i][1]*scale, rects[i][2]*scale, rects[i][3]*scale);

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
                    // ctx.closePath();
                }
            }
        }
    }
    var canvasId = "myCanvas";
    var faceNum = "${map.faceNum}";
    var rects = ${map.rects};
    var points = ${map.points};
    // var srcImgPath = 'face/6.jpg';
    var srcImgPath = "${map.imgPath}";

    console.log( srcImgPath);
    canvasPart(canvasId,srcImgPath,rects,points,faceNum);

</script>
</body>
</html>
