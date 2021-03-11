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
<%--<img src="../face/7.jpg" height="400">
<canvas id="canvas" width="300" height="300" STYLE="border: 1px solid red">

</canvas>
<script type="text/javascript">
    var canvas=document.getElementById("canvas");
    var ctx=canvas.getContext("2d");
    //绘制
    // ctx.fillStyle="#ff00000";
    ctx.strokeStyle="#0000ff";
    ctx.lineWidth=3;
    ctx.rect(20,20,240,240);
    // ctx.fill();//填充
    ctx.stroke();//绘制边框
</script>--%>


<div style="display: flex;">
    <canvas id="myCanvas"  width="800"  height="800" style="border:1px solid red;">
        这是浏览器不支持canvas时展示的信息
    </canvas>
    <img id="img" width="400px" height="400px" />
</div>
<div>
    <input accept=".png,.jpg,.jpeg" type="file" id="file" onchange="myFile(file)" />
    <button onclick="window.close()">关闭窗口</button>
</div>

<script>

    const img = document.getElementById("img")
    // 把图片转base64
    function myFile(file) {
        const imgsize = file.files[0]
        const render = new FileReader()
        render.readAsDataURL(imgsize)
        render.onload = (e) => {
            // console.log(e, 'e')
            // const src = e.target.result
            // console.log(src)
            img.src = src
            srcImg = src
            canvasPart(src)
        }
    }

    function canvasPart(canvasId,srcImgPath,rect,point,text) {
        var c = document.getElementById(canvasId);
        var cW = $("#"+canvasId).width();
        var ctx = c.getContext("2d");

        var img = new Image();
        // 这里可以放 图片路径 "./test.jpg"  || base64图片 || 图片链接
        img.src = srcImgPath;
        img.onload = function () {
            // 设置图片在canvas上 前面两个0,0是边距, 后面是宽高
            // 让绘图自适应 canvas 尺寸
            var img_w = img.width;
            var img_h = img.height;
            // console.log("img_w:",img_w,"img_h:",img_h);
            // console.log("w:",cW,"h:",img_h*cW/img_w);

            ctx.drawImage(img, 0, 0,cW,img_h*cW/img_w);

            // 添加文字 后面两个数字是坐标
            ctx.font  = "30px sans-serif";
            ctx.fillStyle = '#fc0000';
            ctx.fillText(text, rect[0]+rect[2]/2-10, rect[1]-10);

              // 画矩形 前两个数字是坐标, 后面是矩形的宽高 fillRect是填充的
            ctx.lineWidth = 5;
            ctx.strokeStyle = '#64e204';
            ctx.strokeRect(rect[0], rect[1], rect[2], rect[3]);

        //     画圈
            var r = 3;
            for (var i=0;i<point.length;i++){
                ctx.strokeStyle = '#e2d9d9';
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.arc(point[i][0],point[i][1],r,0,Math.PI*2,true);
                ctx.stroke();
            }

        }
    }

    var point = [[1,1],[10,10],[20,20],[30,30]];

    // 画矩形 前两个数字是坐标, 后面是矩形的宽高
    var rect = [100, 100, 200, 200];
    var text = "kkkk";
    var canvasId = "myCanvas";
    var srcImgPath = 'face/7.jpg';
    canvasPart(canvasId,srcImgPath,rect,point,text);

</script>
</body>
</html>
