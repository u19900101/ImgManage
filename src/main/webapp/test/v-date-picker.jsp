<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/2/18
  Time: 10:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
</head>

<div id='app1'>
    <v-date-picker v-model="date" :model-config="modelConfig" mode="dateTime" :timezone="timezone" is24hr :minute-increment="5">
        <template v-slot="{ inputValue, inputEvents }" >
            <input
                    <%--class="bg-white border px-1 py-1 rounded"--%>
                    :value="inputValue"
                    v-on="inputEvents"
                    id = "f1"
                    style="width:125px;height:30px;font-size:10px; line-height:30px;border: 1px solid #ffe57d"
            />
        </template>
    </v-date-picker>
</div>
<input type="text" id="second" />
<div>
    <button type="button" id="m1" style="width: 200px;height: 50px">取值</button>
</div>

<input type="text" id="input1" />
<script>
    $(function () {
        var old = $("#f1").val();
        $("#second").val(old);
        myFunction(old);
        $("#m1").on("click",function(){
            var vue = $("#f1").val();
            $("#second").val(vue);
        });
        $("#second").bind("input propertychange",function(event){
            alert($("#f1").val());
        });
    });
    function myFunction(old){
        setInterval(function(){
                var vue = $("#f1").val();
                if(old != vue){
                    alert(vue);
                    old = vue;
                }
                $("#second").val(vue);
            }
            ,2000);
    }
</script>
<%--2020_12_13T11_53_22--%>
<% request.setAttribute("time", "2020_12_13T11_53_22");%>
 <%--后台传递的值： ${time.split("T")[0].replace("_","-")+"T"+time.split("T")[1].replace("_",":")}--%>
 拆分1： ${time.split("T")[0].replace("_","-")}
 拆分2： ${time.split("T")[1].replace("_",":")}

<script>
    new Vue({
        el: '#app1',
        data:{
            timezone: '',
            // date: '1983-01-21T07:30:00',
            date:  '${time.split("T")[0].replace("_","-")}T${time.split("T")[1].replace("_",":")}',
            modelConfig: {
                type: 'string',
                masks: {
                    input: 'YYYY-MM-DD',
                },
                timeAdjust: '15:00:02',
            },
        },
    });
</script>
</body>
</html>
