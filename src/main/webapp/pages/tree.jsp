<%--
  Created by IntelliJ IDEA.
  User: liupannnnnnnnnn
  Date: 2021/3/6
  Time: 22:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div id="jstree">

</div>

<script>

    $(document).ready(function() {
        $(document).on('click','.imgDiv',function(){
            console.log($(this).attr("id"));
            console.log("原path",$(this).attr("path"));
            var href = "picture/before_edit_picture";
            var path = $(this).attr("path").replaceAll("\\","/");
            $("#rightPage").load(href+"?path="+path);
            console.log(href+"?path="+path);
        });
        // 点击时激发
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
            $("#rightPage").load(labelHref);
        });


        $('#jstree').jstree({
            'core' : {
                'check_callback' : function (operation, node, node_parent, node_position, more) {
                    return true;
                },//eof check callback
                /* 'data' : [
                     { "id" : "labelID_1", "parent" : "#", "text" : "jimi" ,"icon": "glyphicon glyphicon-leaf" ,"tag":1,"href":"label/selectByLabel?labelName=jimi"},
                     { "id" : "labelID_2", "parent" : "#", "text" : "jingjing" ,"icon": "glyphicon glyphicon-tag", "tag":2,"href":"label/selectByLabel?labelName=jingjing"},
                     { "id" : "labelID_3", "parent" : "labelID_4", "text" : "rose","tag":3,"href":"label/selectByLabel?labelName=rose"},
                     { "id" : "labelID_4", "parent" : "#", "text" : "花花","tag":4,"href":"label/selectByLabel?labelName=花花"},
                 ],*/
                'data' :${allLabelJson},
            } ,
            "plugins" : [ "contextmenu", "dnd"]
        }).on('ready.jstree',function(){
            $('#jstree').jstree('open_all');
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
                if(t.closest('.imgDiv').length) {
                    data.helper.find('.jstree-icon').removeClass('jstree-er').addClass('jstree-ok');
                }
                else {
                    data.helper.find('.jstree-icon').removeClass('jstree-ok').addClass('jstree-er');
                }
            }

        }).on('dnd_stop.vakata', function (e, data) {
            // console.log(data.event.target.id);
            console.log(data);
            // 判断是否是 拖动到了 <img>标签中
            if(data.event.target.localName == "img"){
                var newLabelId = data.data.nodes[0];
                var  newlabelName=data.element.innerText;
                console.log(newLabelId);
                console.log(newlabelName);
                // img 标签 的 src就是
                var picPath = data.event.target.attributes.src.nodeValue.replaceAll("\\","/");
                // console.log(data);
                console.log(picPath);
                $.post(
                    "http://localhost:8080/pic/label/ajaxAddLabelToPic",
                    "picPath="+picPath+"&newLabelId="+newLabelId+"&newlabelName="+newlabelName,
                    function(data) {
                        if(data.exist){
                            console.log(" 照片已 存在相同标签不添加");
                        }else if(data.failed){
                            console.log(" 失败 给照片添加标签");
                        }else if(data.succeed)
                        {
                            // 在 右侧页面 添加标签图标
                            addLabel(data.newLabelId,data.newlabelName);
                            // // 在 左侧导航栏 进行Tags的更新
                            // 无法做到 tag数量实时更新  使用load加载后 不能修改node
                            var changeLabels = data.changeLabels;
                             for (var i = 0; i < changeLabels.length; i++) {
                                 // var node = $('#jstree').jstree("get_node", changeLabels[i].toString());
                                 // var node = $('#jstree').jstree("get_node","44");

                                 // var node = $('#jstree').jstree(true).get_node('44');

                                 // console.log("node: ",node);
                                 // var text = "("+(Number(node.tags)+1)+")";
                                 // console.log("node: ",node[0].innerText);
                                 // // console.log("node: ",node.text);
                                 console.log("node: ");

                                var node =  { "id" : "44", "parent" : "#", "text" : "Child 1" };
                                $("#jstree").jstree('rename_node', node , "text_NodeName" );
                             }
                            var labelHref = "label/getLabelTree";
                            $("#leftPage").load(labelHref);
                            // console.log("changeLabels: ",);
                            // updateTags(data.changeLabels,1);
                        };
                    },
                    "json"
                );
            }

        });

        ///eof document ready
        function addLabel(newlabelId,newlabelName){
            // alert("kkk");
            var html ='<div id="myAlert" class="alert alert-default" style="float:left;width:fit-content;">' +
                '<span class="close" data-dismiss="alert">&times; </span>' +
                '<strong id = '+newlabelId+'>'
                + newlabelName + '</strong></div>';
            // 获取子页面 并追加标签 样式
            $("#picTags").append(html);
        };
    });

</script>
</body>
</html>
