
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



<link rel="stylesheet" href="static/public/bootstrap/bootstrap.min.css" >
<script type="text/javascript" src="static/public/bootstrap/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="static/public/bootstrap/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="static/public/plugins/bootstrap-treeview/bootstrap-treeview.min.css">
<script type="text/javascript" src="static/public/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<link rel="stylesheet" type="text/css" href="static/public/plugins/bootstrap-dialog/bootstrap-dialog.min.css">
<script type="text/javascript" src="static/public/plugins/bootstrap-dialog/bootstrap-dialog.min.js"></script>
<script type="text/javascript" src="static/script/2.6.12.vue.min.js"></script>


<%--<link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.4.1/css/bootstrap.css">--%>
<%--<link rel="stylesheet" href="static/bootstrap-treeview/bootstrap-treeview.css">--%>

<%--<script src="https://cdn.staticfile.org/jquery/2.1.3/jquery.js"></script>--%>
<%--<script src="static/script/jquery-3.5.1.js"></script>--%>
<%--<script src="https://cdn.staticfile.org/jquery/3.4.1/jquery.js"></script>--%>
<%--<script src="https://cdn.staticfile.org/twitter-bootstrap/3.4.1/js/bootstrap.min.js"></script>--%>




<%--<script type="text/javascript" src="static/bootstrap-treeview/bootstrap-treeview.js"></script>--%>
<%--<script type="text/javascript" src="static/script/bootstrap-treeview.js"></script>--%>


<%-- link 标签和 script 标签有重大差别 --%>
<%--<link rel="stylesheet" href="static/bootstrap-3.3.7/css/bootstrap.min.css">--%>

<%--<script type="text/javascript" src="static/script/2.6.12.vue.min.js"></script>--%>
<script type="text/javascript" src="static/script/v-calendar.js"></script>

<%--<script src="static/bootstrap-3.3.7/js/bootstrap.min.js"></script>--%>



<%--图标--%>
<link rel="stylesheet" href="http://static.runoob.com/assets/foundation-icons/foundation-icons.css">

<%--<script src='https://unpkg.com/vue/dist/vue.js'></script>--%>
<%--<script src='https://unpkg.com/v-calendar'></script>--%>











