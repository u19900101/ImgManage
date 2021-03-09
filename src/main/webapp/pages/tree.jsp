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
            // 右侧页面点击图片时 跳转页面
            console.log("加载了tree.jsp页面...");

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
            // 取消所有选中

            $('.imgDiv').on('click',function(){

                 console.log("点击了图片 即将跳转到 编辑页面....");
                 var href = "picture/before_edit_picture";
                 var picId =$(this).attr("id");
                 $("#rightPage").load(href+"?pId="+picId);

            });

            // 点击时激发
            $('#jstree').on("select_node.jstree", function (e, data) {
                // console.log(data.selected);
                // console.log("id",data.node.original.id);
                // console.log("text",data.node.original.text);
                // console.log("href",data.node.original.href);
                // // console.log("icon",data.node.original.icon);
                // console.log("parent",data.node.original.parent);
                // console.log("tag",data.node.original.tag);
                // var labelHref = "label/selectByLabel?labelName=花花";
                console.log("在tree.jsp中 点击了标签 ",data.node.text);
                // 跳回 列表页面时 悬停再次显示
                // $(".tooltip-show").tooltip({html : true});
                // console.log("设置了 再次显示悬停");
                // $("[data-toggle='tooltip']").tooltip({html : true,container: 'body' });
                var labelHref = data.node.original.href;
                $("#rightPage").load(labelHref);
            })
                .on('rename_node.jstree', function (e, data) {

                // 更新名称和创建 节点合并
                var labelId= data.node.id;
                var labelName = data.node.text;
                // console.log("  labelId ",labelId,"type",typeof labelId);
                // console.log("  Number(labelId) ",Number(labelId),"type",typeof Number(labelId));

                if(isNaN(Number(labelId))){
                    console.log(" 创建节点 ",data.node.text);
                    var parentLabelId = data.node.parent;
                    console.log("labelName ",labelName);
                    console.log("parentLabelId ",parentLabelId);
                    if(parentLabelId == '#') {
                        // 创建 根节点
                        parentLabelId = null;
                    };
                    createLabel(labelName,parentLabelId);
                }else {
                    console.log("  更新节点 ",data.node.text);
                    editLabel(labelId,labelName);
                }

            })
                .on('delete_node.jstree', function (e, data) {
                    console.log("delete_node ",data.node);
                    deleteLabel(data.node.id);
                    reLoadLeftPage();
            }).on('create_node.jstree', function (e, data) {
                // update_item('new', data.node.parent, 0, data.node.text);
                // console.log("create_node ",data.node);
            });
            ;

            // Move inside Tree to inside
            $('#jstree').on("move_node.jstree", function (e, data) {
                // 拖拽后 改写 拖拽节点的父节点信息写进数据库
                /*  console.log("data.node.id",data.node.id);
                  console.log("data.position",data.position);
                  console.log("data.parent",data.parent);
                  console.log("data.old_parent",data.old_parent);*/
                console.log("  移动节点 ",data.node.text);
                var labelId = data.node.id;
                var parentLabelId = data.parent == "#"?-1:data.parent;
                console.log("  labelId ",labelId);
                console.log("  parentLabelId ",parentLabelId);
                moveLabel(labelId,parentLabelId);
            });

            // 将图片拖拽到标签
            $(document).on('mousedown','.imgDiv', function (e) {
                console.log("mousedown to pic", "id" , this.id);
                return $.vakata.dnd.start(e, {
                        'nodes' : [{ id : this.id }] },
                    '<div id="jstree-dnd" class="jstree-default"><i class="jstree-icon jstree-er"></i>' + $(this).text() + '<ins class="jstree-copy" style="display:none;">+</ins></div>');
            });


            $(document).on('dnd_move.vakata', function (e, data) {
                console.log("dnd_move.vakata 执行了");
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

             });
            $(document).on('dnd_start.vakata', function (e, data) {

                console.log("dnd_start 开始拖拽....");

            });


            $(document).on('dnd_stop.vakata', function (e, data) {
                var goToChange = false;
                console.log("dnd_stop  拖拽放下...");
                // 1.拖动标签到照片中
                if(data.event.target.localName == "img"){
                    var labelId = data.data.nodes[0];
                    var labelName=data.element.innerText;
                    console.log("newLabelId",labelId,"newlabelName",labelName);
                    // img 标签 的 src就是
                    var picId = data.event.target.attributes.id.nodeValue;
                    // console.log("picId",picId);
                    // console.log(data);
                    goToChange = true;
                }

                // 2.将照片拖拽到 标签中
                if(data.event.target.id.lastIndexOf("_anchor") != -1){
                    console.log("拖拽图片到标签： ");
                    var labelId = data.event.target.id.substring(0,data.event.target.id.lastIndexOf("_"));
                    var picId = data.data.nodes[0].id;
                    // console.log("picId: ",picId);
                    var labelName = data.event.target.innerText;
                    console.log("labelId: ",labelId,"newlabelName: ",labelName.substring(0,labelName.lastIndexOf("(")));
                    goToChange = true;
                }
                if(goToChange){
                    $.post(
                        "http://localhost:8080/pic/label/ajaxAddLabelToPic",
                        "picId="+picId+"&newLabelId="+labelId+"&newlabelName="+labelName,
                        function(data) {
                            if(data.exist){
                                console.log(" 照片已 存在相同标签不添加");
                            }else if(data.failed){
                                console.log(" 失败 给照片添加标签");
                            }else if(data.succeed)
                            {
                                // 在 右侧页面 添加标签图标
                                var newlabelName = data.newlabelName.substring(0,labelName.lastIndexOf("("));
                                addLabel(data.newLabelId,newlabelName);
                                // // 在 左侧导航栏 进行Tags的更新
                                // 无法做到 tag数量实时更新  使用load加载后 不能修改node
                                reLoadLeftPage();
                            };
                        },
                        "json"
                    );
                }

            });
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
    function createLabel(labelName,parentLabelId){
        $.post(
            "http://localhost:8080/pic/label/ajaxCreateLabel",
            "labelName="+labelName+"&parentLabelId="+parentLabelId,
            function(data) {
                if(!data.isInsert){
                    console.log("失败 -- 创建标签到数据库");
                    return;
                } else {
                    console.log("成功--创建标签",labelName,"到数据库");
                }
                reLoadLeftPage();
            },
            "json"
        );
    };
    function deleteLabel(labelId){
        $.post(
            "http://localhost:8080/pic/label/ajaxDeleteLabel",
            "labelId="+labelId,
            function(data) {
                if(!data.isDelete){
                    console.log("失败 -- 删除标签到数据库");
                    return;
                } else {
                    console.log("成功 -- 删除标签到数据库");
                }
                reLoadLeftPage();
            },
            "json"
        );
    };
    function editLabel(srclabelId,newLabelName){
        $.post(
            "http://localhost:8080/pic/label/ajaxEditLabel",
            "srclabelId="+srclabelId+"&newLabelName="+newLabelName,
            function(data) {
                if(!data.isEdit){
                    console.log(" 失败——修改标签到数据库");
                } else {
                    console.log(" 成功——修改标签到数据库");
                }
                reLoadLeftPage();
            },
            "json"
        );
    };
    function moveLabel(labelId,newParentLabelId){
        $.post(
            "http://localhost:8080/pic/label/ajaxMoveLabel",
            "labelId="+labelId+"&newParentLabelId="+newParentLabelId,
            function(data) {
                if(!data.isMove){
                    console.log(" 失败——移动标签到数据库");
                    return;
                } else {
                    console.log(" 成功——移动标签到数据库");
                }
                reLoadLeftPage();
            },
            "json"
        );
    };
</script>
</body>
</html>
