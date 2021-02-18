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
    <link rel="shortcut icon" href="#" />
</head>

<div id='app1'>
    <%--<v-date-picker v-model="date" :model-config="modelConfig" mode="dateTime" :timezone="timezone" is24hr :minute-increment="5">
        <template v-slot="{ inputValue, inputEvents }" >
            <input
                    &lt;%&ndash;class="bg-white border px-1 py-1 rounded"&ndash;%&gt;
                    :value="inputValue"
                    v-on="inputEvents"
                    id = "f1"
                    style="width:125px;height:30px;font-size:10px; line-height:30px;border: 1px solid #ffe57d"
            />
        </template>
    </v-date-picker>--%>
        <template>
            <v-date-picker class="inline-block h-full" v-model="date">
                <template v-slot="{ inputValue, togglePopover }">
                    <div class="flex items-center">
                        <button class="p-2 bg-blue-100 border border-blue-200 hover:bg-blue-200 text-blue-600 rounded-l focus:bg-blue-500 focus:text-white focus:border-blue-500 focus:outline-none"
                                @click="togglePopover({ placement: 'auto-start' })">
                            <%--<i class="fi-home"></i>--%>
                            <i class="fi-calendar"></i>
                        </button>
                        <input
                                :value="inputValue"
                                class="bg-white text-gray-700 w-full py-1 px-2 appearance-none border rounded-r focus:outline-none focus:border-blue-500"
                                readonly
                        />
                    </div>
                </template>
            </v-date-picker>
        </template>
</div>

<script>
    new Vue({
        el: '#app1',
        data:{
            timezone: '',
            // date: '1983-01-21T07:30:00',
            date: new Date(),
        },
    });
</script>
</body>
</html>
