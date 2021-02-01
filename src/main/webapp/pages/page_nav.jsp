<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/2/8
  Time: 14:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--分页条的开始--%>
<div id="page_nav">
        <a href="${url}pageNum=1">首页</a>
        <c:if test="${info.pageNum > 1}">
            <a href="${url}pageNum=${info.prePage}">上一页</a>
        </c:if>

        <c:forEach items="${info.navigatepageNums}" var="pn">
            <c:if test="${pn == info.pageNum}">
                【${pn}】
            </c:if>
            <c:if test="${pn != info.pageNum}">
                <a href="${url}pageNum=${pn}">${pn}</a>
            </c:if>
        </c:forEach>
        <c:if test="${info.pageNum < info.pages}">
            <a href="${url}pageNum=${info.nextPage}">下一页</a>
        </c:if>

        <a href="${url}pageNum=${info.pages}">尾页</a>
    共${info.pages}页，${info.total }条记录
    到第<input value="${info.pageNum}" name="pn" id="pn_input"/>页
    <input id="searchPageBtn" type="button" value="确定">

    <script type="text/javascript">

        $(function () {
            // 跳到指定的页码
            $("#searchPageBtn").click(function () {

                var pageNum = $("#pn_input").val();
                var pageTotal = ${info.pages};
                // alert(Number(+5));
                // javaScript语言中提供了一个location地址栏对象
                // 它有一个属性叫href.它可以获取浏览器地址栏中的地址
                // href属性可读，可写
                if($.isNumeric(pageNum)){
                    //强转  排除 +5  这种bug
                    pageNum = Number(pageNum);
                    if(pageNum<=pageTotal&&pageNum>0){
                        location.href = "${pageScope.basePath}${url}pageNum=" + pageNum;
                    }else {
                        alert("页码输入错误,请从新输入");
                    }
                }
                else {
                    alert("页码输入错误,请从新输入");
                }
                $("#pn_input").val(${info.pageNum});
            });
        });
    </script>
</div>
<%--分页条的结束--%>