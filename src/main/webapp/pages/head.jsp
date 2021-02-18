
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
<%--<link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">--%>
<%--<script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>--%>
<%--<script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>--%>

<%-- link 标签和 script 标签有重大差别 --%>
<link rel="stylesheet" href="static/bootstrap-3.3.7/css/bootstrap.min.css">
<script type="text/javascript" src="static/script/jquery-3.5.1.js"></script>
<script type="text/javascript" src="test/2.6.12.vue.min.js"></script>
<script type="text/javascript" src="test/v-calendar.js"></script>

<script src="static/bootstrap-3.3.7/js/bootstrap.min.js"></script>

<%--图标--%>
<link rel="stylesheet" href="http://static.runoob.com/assets/foundation-icons/foundation-icons.css">

<%--<script src='https://unpkg.com/vue/dist/vue.js'></script>--%>
<%--<script src='https://unpkg.com/v-calendar'></script>--%>





