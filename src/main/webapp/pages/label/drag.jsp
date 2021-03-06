<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/19
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="/pages/head.jsp"%>
</head>
<%-- 拖拽框 --%>
<script>
    function allowDrop(ev)
    {
        ev.preventDefault();
    }

    function drag(ev,id)
    {
        ev.dataTransfer.setData("Text",ev.target.id);
        ev.dataTransfer.setData("label",id);
    }

    function drop(ev)
    {
        ev.preventDefault();
        var data=ev.dataTransfer.getData("Text");
        var label=ev.dataTransfer.getData("label");
        ev.target.appendChild(document.getElementById(data));
        $("#msg").append(label);
    }
</script>

<script>
    $(function () {
        // 实时模糊匹配数据库中的标签
        $("#lableInput").on('input propertychange',function() {
            var lable = $("#lableInput").val();
            $.ajax({
                type:'post',
                contentType : 'application/json;charset=utf-8',
                url:"http://localhost:8080/pic/label/isLabelExist?lable="+lable,
                data:{},
                success:function(data) {
                    if(data.exist){
                        //    显示模糊匹配的所有标签
                        var labelList = data.labelList;
                        $("#existLabel").empty();
                        for(var i=0;i<labelList.length;i++){
                            //访问每一个的属性，根据属性拿到值
                            var newLable = labelList[i].labelName;
                            // alert(labelList[i].labelName);
                            // //将拿到的值显示到jsp页面
                            $("#existLabel").prepend(
                                '<span draggable="true"\n' +
                                '          ondragstart="drag(event,id)"\n' +
                                '          id = ' +
                                '"temp" style="border: 2px solid #ffe57d;background: lightgreen;font-size: larger;font-weight: bolder">\n' +
                                '    ' +
                                newLable +
                                '</span>'
                            );
                            $("#temp").attr("id",newLable);
                        }
                    }else {
                        info_prompt("暂无匹配",2500);
                        $("#existLabel").empty();
                    }
                },
                dataType:"json"
            });
        });

    });
    //enter键-响应  input框按下回车后提交新标签
    function keyDown(e){
        var keycode = e.which;;
        if (keycode == 13 ) //回车键是13
        {
            // 在数据库中查询显示模糊匹配的标签
            // 有  点击就添加到 照片数据库中
            // 无  按下回车键后 添加到照片数据库中
            var newLable = $("#lableInput").val();
            $.ajax({
                type:'post',
                contentType : 'application/json;charset=utf-8',
                url:"http://localhost:8080/pic/label/insert?newLable="+newLable,
                data:{},
                success:function(data) {
                    if(!data.exist){
                        if(data.success!=null){
                            success_prompt(data.success,2500);
                        }else {
                            fail_prompt(data.fail,2500);
                        }
                    }else {
                        fail_prompt(data.msg,2500);
                    }
                },
                dataType:"json"
            });
            $("#imgDiv").prepend(
                '<span draggable="true"\n' +
                '          ondragstart="drag(event,id)"\n' +
                '          id = ' +
                '"temp" style="border: 2px solid #ffe57d;background: lightgreen;font-size: larger;font-weight: bolder">\n' +
                '    ' +
                newLable +
                '</span>'
            );
            $("#temp").attr("id",newLable);
            $("#lableInput").val("");
        }
    }
</script>
</head>
<body>

<%-- 左侧 标签栏 --%>
<div id="div1" style="margin-left: 10%;float: left;border:1px solid red;height: 100%"
     ondragover="allowDrop(event)"
     ondrop="drop(event)" style="border:1px solid #aaaaaa;height: 80%;float: left">

    <h2><span id = "msg"></span></h2>

    <i class="fi-pencil"><input id = "lableInput" onkeydown="keyDown(event)" placeholder="新增标签"></i>
    <%-- 显示所有已存在的标签 --%>
    <div id="existLabel">

    </div>
</div>

<div id = "labels" >
    <div draggable="true"
          ondragstart="drag(event,id)"
          id = "person" style="width:fit-content;border: 2px solid #ffe57d;background: lightgreen;font-size: larger;font-weight: bolder">
    人物</div>
    <span draggable="true"
          ondragstart="drag(event,id)"
          id = "flower" style="color:red;border: 2px solid #ffe57d;background: lightgreen;font-size: larger;font-weight: bolder">
    花草</span>
</div>

<div id = "imgDiv" style="border: 1px solid #39987c;width: 40%;float: right" >
    <h1>照片框</h1>
    <img id = "myImg" src="img/2021/01/花发.jpg" height="400px">
    <%--<img loading="lazy" src="label/icons.jpg" height="100">--%>
</div>



<br>



<%--图标1：<img loading="lazy" id="lable_1" src="test/icons.jpg"
     draggable="true"
     ondragstart="drag(event,id)" height="100">

图标2：<img loading="lazy" id="lable_2" src="test/icons.jpg"
     draggable="true"
     ondragstart="drag(event,id)" height="100">--%>

</body>
</html>
