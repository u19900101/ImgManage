
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/2/5
  Time: 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()
            + "://"
            + request.getServerName()
            + ":"
            + request.getServerPort()
            + request.getContextPath()
            + "/";
    pageContext.setAttribute("basePath",basePath);
%>

<!--写base标签，永远固定相对路径跳转的结果-->
<base href="<%=basePath%>">
<link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.4.1/css/bootstrap.css">
<link rel="stylesheet" href="static/bootstrap-treeview/bootstrap-treeview.css">

<script src="https://cdn.staticfile.org/jquery/2.1.3/jquery.js"></script>
<%--<script src="static/script/jquery-3.5.1.js"></script>--%>
<%--<script src="https://cdn.staticfile.org/jquery/3.4.1/jquery.js"></script>--%>
<script src="https://cdn.staticfile.org/twitter-bootstrap/3.4.1/js/bootstrap.min.js"></script>




<script type="text/javascript" src="static/bootstrap-treeview/bootstrap-treeview.js"></script>
<%--<script type="text/javascript" src="static/script/bootstrap-treeview.js"></script>--%>


<%-- link 标签和 script 标签有重大差别 --%>
<%--<link rel="stylesheet" href="static/bootstrap-3.3.7/css/bootstrap.min.css">--%>

<script type="text/javascript" src="static/script/2.6.12.vue.min.js"></script>
<script type="text/javascript" src="static/script/v-calendar.js"></script>

<%--<script src="static/bootstrap-3.3.7/js/bootstrap.min.js"></script>--%>



<%--图标--%>
<link rel="stylesheet" href="http://static.runoob.com/assets/foundation-icons/foundation-icons.css">

<%--<script src='https://unpkg.com/vue/dist/vue.js'></script>--%>
<%--<script src='https://unpkg.com/v-calendar'></script>--%>

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
    }

    .alert-danger {
        color: #a94442;
        background-color: #f2dede;
        border-color: #ebccd1;
    }
</style>
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










