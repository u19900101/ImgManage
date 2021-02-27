
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>

<html>
<head>
   <script>
        $(function () {
          var div = $("#target");
          var divTarget = document.getElementById("target");
          alert(typeof (div));
          alert(typeof (divTarget));

            var node=document.createElement("LI");
            var textnode=document.createTextNode("Water");
            node.appendChild(textnode);
            document.getElementById("myList").appendChild(node);

          var html = ' <div class="alert alert-warning">\n' +
              '        <a href="#" class="close" data-dismiss="alert">\n' +
              '            &times;\n' +
              '        </a>\n' +
              '        <strong>警告！</strong>您的网络连接有问题。\n' +
              '    </div>';
            divTarget.append(html);
            div.append(html);
        });


    </script>
</head>

<body>

<div id="target">
    警告！

</div>



</body>
</html>