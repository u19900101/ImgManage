<html>
<head>
    <title>让图片自动适应DIV容器大小</title>
    <style>
        .ShaShiDi{
            width: 100%;
            height:800px;
            /*设置div居中*/
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            margin: auto;
            /* 设置div中的图片居中*/
            display:flex;
            align-items:center;
            justify-content:center;
            /*为了效果明显，可以将如下边框打开，看一下效果*/
             border:5px solid black;
        }

        .ShaShiDi img{
            /*width:100%;*/
            /*height:auto;*/
            width:auto;
            height:100%;
        }

    </style>
</head>
<body>
<div class="ShaShiDi">
    <img src="img/f2/gofree.jpg"/>
</div>
<div class="ShaShiDi">
    <img src="img/f2/k.jpg"/>
</div>
</body>
</html>
