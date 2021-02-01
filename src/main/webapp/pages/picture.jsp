<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/1
  Time: 16:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 静态包含 base标签、css样式、jQuery文件 --%>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <title>Title</title>
    <style>
        .left{
            float:left;
            margin-left:50px;
            width:800px;
        }
        .right{
            margin-left:auto;
            text-align: center;

        }
    </style>

    <script type="text/javascript">

        // 页面加载完成之后
        $(function () {
            // 给注册绑定单击事件
            // $("#sub_btn").click(function () {
            //     // 验证用户名：必须由字母，数字下划线组成，并且长度为5到12位
            //     //1 获取用户名输入框里的内容
            //     var usernameText = $("#username").val();
            //     //2 创建正则表达式对象
            //     var usernamePatt = /^\w{5,12}$/;
            //     //3 使用test方法验证
            //     if (!usernamePatt.test(usernameText)) {
            //         //4 提示用户结果
            //         $("span.errorMsg").text("用户名不合法！");
            //
            //         return false;
            //     }
            //
            //     // 验证密码：必须由字母，数字下划线组成，并且长度为5到12位
            //     //1 获取用户名输入框里的内容
            //     var passwordText = $("#password").val();
            //     //2 创建正则表达式对象
            //     var passwordPatt = /^\w{5,12}$/;
            //     //3 使用test方法验证
            //     if (!passwordPatt.test(passwordText)) {
            //         //4 提示用户结果
            //         $("span.errorMsg").text("密码不合法！");
            //
            //         return false;
            //     }
            //
            //     // 验证确认密码：和密码相同
            //     //1 获取确认密码内容
            //     var repwdText = $("#repwd").val();
            //     //2 和密码相比较
            //     if (repwdText != passwordText) {
            //         //3 提示用户
            //         $("span.errorMsg").text("确认密码和密码不一致！");
            //
            //         return false;
            //     }
            //
            //     // 邮箱验证：xxxxx@xxx.com
            //     //1 获取邮箱里的内容
            //     var emailText = $("#email").val();
            //     //2 创建正则表达式对象
            //     var emailPatt = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
            //     //3 使用test方法验证是否合法
            //     if (!emailPatt.test(emailText)) {
            //         //4 提示用户
            //         $("span.errorMsg").text("邮箱格式不合法！");
            //
            //         return false;
            //     }
            //
            //     // 验证码：现在只需要验证用户已输入。因为还没讲到服务器。验证码生成。
            //     var codeText = $("#code").val();
            //
            //     //去掉验证码前后空格
            //     // alert("去空格前：["+codeText+"]")
            //     codeText = $.trim(codeText);
            //     // alert("去空格后：["+codeText+"]")
            //
            //     if (codeText == null || codeText == "") {
            //         //4 提示用户
            //         $("span.errorMsg").text("验证码不能为空！");
            //
            //         return false;
            //     }
            //
            //     // 去掉错误信息
            //     $("span.errorMsg").text("");
            //
            // });
            // 使用ajax给用户名 实时 返回信息
            $("#pname").bind("input propertychange",function(event){
                var pname = this.value;
                var picpath = $(this).attr('picpath');
                $.post(
                    "${basePath}picture/ajaxexistPname",
                    "pname="+pname+"&picpath="+picpath,
                    function (data) {
                    if(data.existpname){
                        $("span.errorMsg").text("照片名称已存在，请重新输入");
                    }else {
                        $("span.errorMsg").text("照片名称可用");
                    }
                },
                    "json"
                );
            })
        });

    </script>
</head>
<body>

<%--
Picture{
pid=14,
path='D:\MyJava\mylifeImg\src\main\webapp\static\0E4A2352.jpg',
pname='0E4A2352.jpg',
pcreatime='2020:10:06 08:08:14',
plocal='null', plabel='null',
pdesc='还未设置'
}
--%>
<div>
    <c:forEach items="${info.list}" var="picture">
        <div class="left">
            <img src="static/${picture.pname}" height="600"><br/><br/>
        </div>

        <div class="right" >
            <br/><br/><br/><br/><br/><br/>
            <form action="picture/update" method="post" >
                文件名：<input name="pname" id="pname" picpath = ${picture.path}
                    value="${picture.pname}">
                <span class="errorMsg" style="color: red">${ requestScope.msg }</span><br/><br/>
                拍摄时间：<input name="pcreatime" value="${picture.pcreatime}"> <br/><br/>
                地理位置： <input name="plocal" value="${picture.plocal}"> <%--<br/>--%>
                <input name="pid" type="hidden" value="${picture.pid}"> <br/><br/>
                <input name="path" type="hidden" value="${picture.path}">

                描述<textarea name="pdesc"> </textarea><br/>
                <input type="submit" value="提交"/>
            </form>
        </div>
    </c:forEach>
    <%@include file="/pages/page_nav.jsp"%>

</div>





</div>

</body>
</html>
