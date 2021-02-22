<html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<head>
    <title>Bootstrap 实例 - 工具提示（Tooltip）插件</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        .imgDiv{
            width: auto;
            height:300px;
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .c1{
            float: left;
            border: 1px solid red;
            width: auto;
            height:300px;
        }
        .c2{
            /*float: left;*/
            border: 2px solid green;
        }

    </style>
</head>
<body>
<div style="width:100%;height:100%;overflow: scroll;" >
    <div class="panel-group" id="accordion">
        <div class="c2">
            <button type="button" class="btn btn-primary" data-toggle="collapse in"
                    data-target="#ddddd" style="background: #e3e3e3">
                <h2 style="color: chocolate">ddddd</h2>
            </button>

            <div id="ddddd" class="collapse in">
                <div class="c1">
                <div  id = "app1" style="position:relative;width: 200px;height: 300px;border: 1px solid yellow"
                      @mouseenter="enter()"
                      @mouseleave="left()"
                      class="imgDiv"
                      style="position:relative;border: 1px solid yellow">
                    <img src="img/2021/01/2021_01_01T07_56_11.jpg"
                         style="height: 100%;width: auto"
                         data-placement="top" data-toggle="tooltip"
                         title="<h1>显示方法方法fff图片名称</h1>"
                         class="tooltip-show"
                    >
                    <button v-show = "buttonShow" @click = "deletePicture()" type="button" class="btn btn-default"
                            style="position:absolute; left: 80%; top: 30%;">
                        <span class="glyphicon glyphicon-trash" style="font-size:15px;"></span>
                    </button>
                </div>
            </div>
                <div class="c1">
                    <div  id = "app2" style="position:relative;width: 200px;height: 300px;border: 1px solid yellow"
                          @mouseenter="enter()"
                          @mouseleave="left()"
                          class="imgDiv"
                          style="position:relative;border: 1px solid yellow">
                        <img src="img/2021/01/2021_01_01T07_56_11.jpg"
                             style="height: 100%;width: auto"
                             data-placement="top" data-toggle="tooltip"
                             title="<h1>显示方法方法fff图片名称</h1>"
                             class="tooltip-show"
                        >
                        <button v-show = "buttonShow" @click = "deletePicture()" type="button" class="btn btn-default"
                                style="position:absolute; left: 80%; top: 30%;">
                            <span class="glyphicon glyphicon-trash" style="font-size:15px;"></span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
    $(function () { $("[data-toggle='tooltip']").tooltip({html : true,container: 'body'}); });
   /* var vm = new Vue({
        el: '#app',
        data:{
            buttonShow : false,
        },
        methods: {
            deletePicture: function () {
                alert("0-delete");
            },
            enter: function () {
                this.buttonShow = true;
            },
            left: function () {
                this.buttonShow = false;
            },

        }
    });*/
    var vm = new Vue({
        el: '#app1',
        data:{
            buttonShow : false,
        },
        methods: {
            deletePicture: function () {
                alert("1-delete");
            },
            enter: function () {
                this.buttonShow = true;
            },
            left: function () {
                this.buttonShow = false;
            },

        }
    });
    var vm = new Vue({
        el: '#app2',
        data:{
            buttonShow : false,
        },
        methods: {
            deletePicture: function () {
                alert("2-delete");
            },
            enter: function () {
                this.buttonShow = true;
            },
            left: function () {
                this.buttonShow = false;
            },

        }
    });

</script>

</body>
</html>