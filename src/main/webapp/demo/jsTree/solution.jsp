<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>

<html>
<head>

    <style media="screen">
     .wrapper {
         display: flex;
         width: 100%;
     }

    .left {
        width: 30%;
        height: 100vh;
        overflow: auto;
    }
     .right {
        width: 70%;
        height: 100vh;
        overflow: auto;
    }

    </style>
</head>
<body>
<div class="wrapper" id="page">
    <div class="left">
        <div id="jstree">
            <ul >
                <li id="Root-1" class="jstree-open">Root node 1
                    <ul>
                        <li id="Child-1">Child-1</li>
                        <li id="Child-2">Child-2</li>
                        <li id="Child-3">Child-3</li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
    <div class="right" id = "rightPage">
        <div id="p1">
       <%-- 右侧页面显示区域 --%>
        </div>
    </div>
</div>


<script>
    $(function () {
        onload();
        function onload() {
            $("#p1").load("label/selectByLabel?labelName=花花");
        }
    });

    $(document).ready(function() {

        $(document).on('click','.imgDiv',function(){
            console.log($(this).attr("id"));
            console.log("原path",$(this).attr("path"));
            var href = "picture/before_edit_picture";
            var path = $(this).attr("path").replaceAll("\\","/");
            $("#p1").load(href+"?path="+path);
        });
        $('#jstree').on("changed.jstree", function (e, data) {
            // console.log(data.selected);
            // console.log("id",data.node.original.id);
            // console.log("text",data.node.original.text);
            // console.log("href",data.node.original.href);
            // // console.log("icon",data.node.original.icon);
            // console.log("parent",data.node.original.parent);
            // console.log("tag",data.node.original.tag);
            // var labelHref = "label/selectByLabel?labelName=花花";
            var labelHref = data.node.original.href;
            $("#p1").load(labelHref);

        });

        $('#jstree').jstree({
            'core' : {
                'check_callback' : function (operation, node, node_parent, node_position, more) {
                    return true;
                },//eof check callback
                'data' : [
                    { "id" : "labelID_1", "parent" : "#", "text" : "jimi" ,"icon": "glyphicon glyphicon-leaf" ,"tag":1,"href":"label/selectByLabel?labelName=jimi"},
                    { "id" : "labelID_2", "parent" : "#", "text" : "jingjing" ,"icon": "glyphicon glyphicon-tag", "tag":2,"href":"label/selectByLabel?labelName=jingjing"},
                    { "id" : "labelID_3", "parent" : "labelID_4", "text" : "rose","tag":3,"href":"label/selectByLabel?labelName=rose"},
                    { "id" : "labelID_4", "parent" : "#", "text" : "花花","tag":4,"href":"label/selectByLabel?labelName=花花"},
                ],
            }  ,//eof core

            "plugins" : [ "contextmenu", "dnd"]
        });//eof jstree

        // Move inside Tree to inside
        $('#jstree').on("move_node.jstree", function (e, data) {

            my_form_vals = 'admin_funcs=tree_fact_funcs&action=move';
            my_form_vals += '&id='+data.node.id;
            my_form_vals += '&pos='+data.position;
            my_form_vals += '&new_parent='+data.parent;
            my_form_vals += '&old_parent='+data.old_parent;
            // alert(my_form_vals);
        });

        $(document).on('dnd_move.vakata', function (e, data) {

            data.helper.find('.jstree-icon').removeClass('jstree-er').addClass('jstree-ok');

            var t = $(data.event.target);
            if(!t.closest('.jstree').length) {
                if(t.closest('.picdiv').length) {
                    data.helper.find('.jstree-icon').removeClass('jstree-er').addClass('jstree-ok');
                }
                else {
                    data.helper.find('.jstree-icon').removeClass('jstree-ok').addClass('jstree-er');
                }
            }

        }).on('dnd_stop.vakata', function (e, data) {

            console.log(data.event.target.id);
            // console.log(data);
            if(data.event.target.className =="picdiv"){
                var labelName = data.data.nodes[0];
                var targetId =data.event.target.id;
                var picpath = data.event.target.attributes.picpath.nodeValue;
                // console.log(picpath);
                $("#"+targetId).append(labelName+"<br>");
            }
        });
    });//eof document ready

</script>
</body>
</html>