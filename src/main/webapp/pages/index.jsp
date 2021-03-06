<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>
<head>
    <script type="text/javascript">
        $(function(){
            //全局变量  用于记录二次点击
            var isUpdateStatu = false;
            onLoad();
            //页面加载
            function onLoad() {
                //渲染树
                $('#left-tree').treeview({
                    data: ${labelTree},
                    levels:4,
                    color: "#000000",
                    backColor: "#FFFFFF",
                    // enableLinks: true,
                    expandIcon: "glyphicon glyphicon-chevron-right",
                    collapseIcon: "glyphicon glyphicon-chevron-down",
                    nodeIcon: "glyphicon glyphicon-bookmark",
                    showTags: true,
                    //
                    allowReselect:true,
                    preventUnselect:true,
                    onNodeSelected:function(event, node){
                        // alert("点击： lastSelectNode——"+lastSelectNode.text +" ***  node——"+ node.text);
                        // alert("进入选中： selectStatu——"+selectStatu);
                        $('#updateName').val(node.text);
                        // 当操作 标签时 左边页面不栋
                        if($("#tagHandleStatu").text() == "false"){
                            // alert("判断 check");
                            if($("#isAddLable").is(':checked')){
                                // alert("check 选中 开始添加");
                                var picPath = $("#iframepage").contents().find("#picTags").attr("picPath");
                                var newlabelName = node.text;
                                var newLabelId = node.id;
                                // alert(picPath+"---"+newLabelId+"---"+newlabelName);
                                // alert(JSON.stringify(node));
                                // alert(picPath);
                                if(picPath != undefined){
                                    addLabelAjax(picPath,newLabelId,newlabelName);
                                }
                            }else {
                                // 点击后  访问后台的路径  后台处理完数据后直接渲染 到指定的页面去
                                document.getElementById("iframepage").src="/pic/" + node.href;
                            }
                        }
                    },
                    showCheckbox:false//是否显示多选
                });
               // 添加 recentLabelBar
                <c:forEach items="${recent3AndMax7Label}" var="bar" >
                    <%--alert('${bar.labelName}');--%>
                    var newlabelId = '${bar.labelid}';
                    var newlabelName = '${bar.labelName}';
                    var html ='<div id='+newlabelId+' draggable="true" ondragstart="drag(event,id)" class="alert alert-default" style="float:left;width:fit-content;">' +
                        '<span class="close" data-dismiss="alert">&times; </span>' +
                        '<strong id = '+newlabelId+'>'
                        + newlabelName + '</strong></div>';
                    $("#recentLabelBar").append(html);
                </c:forEach>
            };
            // 在数据库中查询 照片是否已经存在了 请求添加的标签
            var addLabelAjax = function (picPath,newLabelId,newlabelName){
                // 将信息写进数据库中
                $.post(
                    "http://localhost:8080/pic/label/ajaxAddLabelToPic",
                    "picPath="+picPath+"&newLabelId="+newLabelId+"&newlabelName="+newlabelName,
                    function(data) {
                        if(data.exist){
                            showDialog(" 照片已 存在相同标签不添加");
                        }else if(data.failed){
                            showDialog(" 失败 给照片添加标签");
                        }else if(data.succeed)
                        {
                            // 在 右侧页面 添加标签图标
                            addLabel(data.newLabelId,data.newlabelName);
                            // 在 左侧导航栏 进行Tags的更新
                            updateTags(data.changeLabels,1);
                        };
                    },
                    "json"
                );

            };

            // 由于删除标签时 的Tags更新
            $("#updateTags").on('click',function () {
                var changeLabels = $("#iframepage").contents().find("#changeLabels").val();
                var list = changeLabels.split(",");
                updateTags(list,-1);
            });
            var updateTags  = function(changeLabels,num){
                isUpdateStatu = true;
                for (var i = 0; i < changeLabels.length; i++) {
                    // alert(changeLabels[i]);
                    var resNodes = $('#left-tree').treeview('search', [ changeLabels[i], {
                        ignoreCase: true,
                        exactMatch: true,
                        revealResults: false,
                    }]);
                    // 更新涉及到的所有徽记
                    if(resNodes.length>0){
                        var newNode = resNodes[0];
                        newNode.tags = [(parseInt(newNode.tags)+num).toString()];
                        // alert(i + "newNode.tags: "+newNode.tags);
                        $('#left-tree').treeview('updateNode', [ resNodes[0], newNode ]);
                    }
                }
                isUpdateStatu = false;
            };
            //显示-添加
            $("#btnAdd").click(function(){
                $('#addName').val('');
                $('#addOperation-dialog').modal('show');
            });
            $("#btnEdit").click(function(){
                var node=$('#left-tree').treeview('getSelected');
                if (node.length == 0) {
                    showDialog( '请选中要修改的标签' );
                    return;
                }
                $('#alterOperation-dialog').modal('show');
            });
            //删除
            $("#btnDel").click(function(){
                var node = $('#left-tree').treeview('getSelected');
                if (node.length == 0) {
                    showDialog( '请选择标签' );
                    return;
                }

                BootstrapDialog.confirm({
                    title: '提示',
                    message: '确定删除此标签?',
                    size: BootstrapDialog.SIZE_SMALL,
                    type: BootstrapDialog.TYPE_DEFAULT,
                    closable: true,
                    btnCancelLabel: '取消',
                    btnOKLabel: '确定',
                    btnsOrder: BootstrapDialog.BUTTONS_ORDER_OK_CANCEL,   // 确定键在左侧
                    callback: function (result) {
                        if(result)
                        {
                            deleteLabel(node);
                        }
                    }
                });
            });
            $("#showAllPic").click(function(){
                document.getElementById("iframepage").src="/pic/picture/page";
            });
            $("#uploadPic").click(function(){
                document.getElementById("iframepage").src="uploadDir.jsp";
            });
            // 点击图标 选中单选框
            $("#clickAddLabel").click(function(){
                if($("input[type='checkbox']").prop('checked')){
                    $("input[type='checkbox']").prop("checked",false);
                }else {
                    $("input[type='checkbox']").prop("checked",true);
                }
            });
            /*-----页面pannel内容区高度自适应 -----*/
            $(window).resize(function () {
                setCenterHeight();
            });
            setCenterHeight();
            function setCenterHeight() {
                var height = $(window).height();
                var centerHight = height - 240;
                $(".right_centent").height(centerHight).css("overflow", "auto");
            }

        });

        function addLabel(newlabelId,newlabelName){
            // alert("kkk");
            var html ='<div id="myAlert" class="alert alert-default" style="float:left;width:fit-content;">' +
                '<span class="close" data-dismiss="alert">&times; </span>' +
                '<strong id = '+newlabelId+'>'
                + newlabelName + '</strong></div>';
            // 获取子页面 并追加标签 样式
            $("#iframepage").contents().find("#picTags").append(html);
        };
        function showDialog( msg ) {
            BootstrapDialog.show({
                title: '提示',
                message: msg,
                size: BootstrapDialog.SIZE_SMALL,
                type: BootstrapDialog.TYPE_DEFAULT,
                buttons: [ {
                    label: '确定',
                    action: function ( dialog ) {
                        dialog.close();
                    }
                } ]
            });
        };

    </script>

    <%-- 拖拽框 --%>
    <script>
        function allowDrop(ev)
        {
            ev.preventDefault();
        }

        function drag(ev,id)
        {
            // ev.dataTransfer.setData("Text",ev.target.id);
            ev.dataTransfer.setData("label",id);
        }

        function drop(ev)
        {
            ev.preventDefault();
            // var data=ev.dataTransfer.getData("Text");
            var label=ev.dataTransfer.getData("label");
            // ev.target.appendChild(document.getElementById(data));
            $("#picArea").append(label);
        //    写进数据库
        }
    </script>

</head>
<body >
<div id = "app">

<header class="container-fluid" >
   <div class="row">
       <div class="col-md-3" style="border: 1px solid greenyellow">
           <div class="row">
               <%-- 标签搜索框--%>
               <div class="col-md-6" style="padding-left: 0px;padding-right: 0px">
                   <input id="searchNode"  @keyup.enter="searchNode()" type="text" class="form-control"  placeholder="搜索标签">
               </div>

               <%--给照片添加标签--%>
               <div class="col-md-1" >
                   <input type="checkbox"  checked = "checked" style="float: left" id="isAddLable" data-placement="right" data-toggle="tooltip" title="<h5>给照片添加标签</h5>" class="tooltip-show">
                   <button id = "clickAddLabel">
                     <span data-placement="right" data-toggle="tooltip" title="<h5>给照片添加标签</h5>" class="tooltip-show">
                        <span class="glyphicon glyphicon-tags" style="font-size: large"></span>
                    </span>
                   </button>
               </div>

               <div class="col-md-1" ></div>
               <%-- 查看所有照片 --%>
               <div class="col-md-1" >
                   <button id = "showAllPic" style="float: left">
                     <span data-placement="right" data-toggle="tooltip" title="<h5>查看所有照片</h5>" class="tooltip-show">
                        <span class="glyphicon glyphicon-picture" style="font-size: large"></span>
                    </span>
                   </button>
               </div>
               <div class="col-md-1" ></div>

               <%--上传照片--%>
               <div class="col-md-1" style="padding-left: 0px;padding-right: 0px">
                   <button id = "uploadPic">
                        <span data-placement="right" data-toggle="tooltip" title="<h5>上传照片</h5>" class="tooltip-show">
                                <span class="glyphicon glyphicon-upload" style="font-size: large"></span>
                        </span>
                   </button>
               </div>
           </div>
           <div class="row">
               <div class="panel panel-primary ">
                   <div class="panel-heading">
                       <h3 class="panel-title">
                            <span data-placement="top" data-toggle="tooltip" title="<h5>点击管理标签</h5>" class="tooltip-show">
                                <span id = "tag" @click = "showTagHandle()"   class="glyphicon glyphicon-tag"></span>
                            </span>
                           <p id ="tagHandleStatu" hidden >{{tagHandleStatu}}</p>
                           <span id="btnAdd" v-show = "tagHandleStatu"   class="glyphicon glyphicon-plus"></span>
                           <span id="btnDel" v-show = "tagHandleStatu"   class="glyphicon glyphicon-trash"></span>
                           <span id="btnEdit" v-show = "tagHandleStatu"  class="glyphicon glyphicon-edit"></span>
                       </h3>
                   </div>
                   <div class="panel-body right_centent" style="">
                       <div id="left-tree"></div>
                   </div>
               </div>
           </div>
       </div>
       <div class="col-md-9 pull-right" >
           <div id = "recentLabelBar" class="row" style="border: 1px solid red;padding-left: 0px;padding-right: 0px">

           </div>
           <div id = "picArea" class="row"  style="border: 1px solid red;padding-left: 0px;padding-right: 0px"
                ondragover="allowDrop(event)"
                ondrop="drop(event)" >
                    <span>拖到此处</span>
           </div>
           <div class="row" style="border: 1px solid red;padding-left: 0px;padding-right: 0px">
       <%--         <iframe src="picture/page" name='main' id="iframepage" frameborder="0" width="100%" height="100%" scrolling="no" marginheight="0" marginwidth="0" ></iframe>--%>
           </div>
       </div> 
   </div>

</header>
<div class="container-fluid" style="padding-left: 0px">

</div>
<div>

    <!--弹出框 新增权限 start-->
    <div class="modal fade" id="addOperation-dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content radius_5">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">新增</h4>
                </div>
                <div class="modal-body">
                    <div group="" item="add">
                        <div>
                            <div class="input-group margin-t-5">
                                <span class="input-group-addon">名称:</span>
                                <input id="addName" type="text"  @keyup.enter="add_comfirm()"  placeholder="请输入新标签" class="form-control" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="Save" type="button" @click = "add_comfirm()" class="btn btn-primary">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>
    <!--弹出框 新增权限 end-->

    <!--弹出框 新增权限 start-->
    <div class="modal fade" id="alterOperation-dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content radius_5">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel2">修改</h4>
                </div>
                <div class="modal-body">
                    <div group="" item="add">
                        <div>
                            <div class="input-group margin-t-5">
                                <span class="input-group-addon">名称:</span>
                                <input id="updateName" type="text" @keyup.enter="edit_comfirm()" class="form-control" />
                            </div>

                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button id="SaveAlter" type="button" @click = "edit_comfirm()" class="btn btn-primary">保存</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>

                </div>
            </div>


        </div>
    </div>
    <!--弹出框 新增权限 end-->
</div>
</div>
<input type="hidden" id="updateTags">
</body>
<script>
    $(function () {
        $("[data-toggle='tooltip']").tooltip({html : true,container: 'body'});
    });
    function createLabel(node,parentNode){
        var labelName = node.text;
        // alert(parentNode.length);
        if(parentNode.length != 0){
            var parentLabelName = parentNode[0].text;
        }else {
            var parentLabelName = null;
        }

        $.post(
            "http://localhost:8080/pic/label/ajaxCreateLabel",
            "labelName="+labelName+"&parentLabelName="+parentLabelName,
            function(data) {
                if(!data.isInsert){
                    showDialog("创建标签到数据库失败");
                    return;
                } else {
                    node.id = data.id;
                    node.tags = ["0"];
                    // alert(typeof data.id);
                    // alert(typeof node.text);
                    $('#left-tree').treeview('addNode', [node, parentNode]);
                }
            },
            "json"
        );
    };
    function deleteLabel(node){
        $.post(
            "http://localhost:8080/pic/label/ajaxDeleteLabel",
            "labelId="+node[0].id,
            function(data) {
                if(!data.isDelete){
                    showDialog(" 删除标签到数据库失败");
                    return;
                } else {
                    $('#left-tree').treeview('removeNode', [ node, { silent: true } ]);
                }
            },
            "json"
        );
    };
    function editLabel(node,newNode){
        $.post(
            "http://localhost:8080/pic/label/ajaxEditLabel",
            "srclabelId="+node[0].id+"&newLabelName="+newNode.text,
            function(data) {
                if(!data.isEdit){
                    showDialog(" 失败——修改标签到数据库");
                    return;
                } else {
                    $('#left-tree').treeview('updateNode', [ node, newNode]);
                }
            },
            "json"
        );
    };

    var vm = new Vue({
        el: '#app',
        data:{
            tagHandleStatu:false,
        },
        methods: {
            edit_comfirm: function () {
                $('#alterOperation-dialog').modal('hide');
                var node = $('#left-tree').treeview('getSelected');
                var newNode={
                    text:$('#updateName').val()
                };
                var resNodes = $('#left-tree').treeview('search', [ newNode.text, {
                    ignoreCase: true,
                    exactMatch: true,
                    revealResults: true,
                }]);
                if(resNodes.length>0){
                    showDialog( "存在重复同名标签，请重新命名！" );
                }else {
                    // 先写进数据库 成功后再在页面显示
                    editLabel(node,newNode);
                }
            },
            add_comfirm: function () {
                $('#addOperation-dialog').modal('hide');
                //静态添加标签

                var parentNode = $('#left-tree').treeview('getSelected');
                var node = {
                    text: $('#addName').val()
                };

                var resNodes = $('#left-tree').treeview('search', [ $('#addName').val(), {
                    ignoreCase: true,     // case insensitive
                    exactMatch: true,    // like or equals
                    revealResults: true,  // reveal matching nodes
                }]);
                if(resNodes.length>0){
                    showDialog( "存在重复同名标签，请重新命名！" );
                }else {
                    // 先写进数据库 成功后再在页面显示
                    createLabel(node, parentNode);
                }

            },

            searchNode: function () {
                if($('#searchNode').val().trim() == ""){
                    showDialog( "请输入标签名后按回车键搜索..." );
                    return;
                }
                var resNodes = $('#left-tree').treeview('search', [ $('#searchNode').val(), {
                    ignoreCase: true,     // case insensitive
                    exactMatch: false,    // like or equals
                    revealResults: true,  // reveal matching nodes
                }]);
                if(resNodes.length == 0) {
                    BootstrapDialog.confirm({
                        title: '提示',
                        message: '标签不存在，是否创建?',
                        size: BootstrapDialog.SIZE_SMALL,
                        type: BootstrapDialog.TYPE_DEFAULT,
                        closable: true,
                        btnCancelLabel: '取消',
                        btnOKLabel: '确定',
                        btnsOrder: BootstrapDialog.BUTTONS_ORDER_OK_CANCEL,   // 确定键在左侧
                        callback: function (result) {
                            if (result) {
                                var node = {
                                    text: $('#searchNode').val()
                                };
                                $('#left-tree').treeview('addNode', [node, false]);
                            }
                        }
                    })
                };

            },
            // 切换状态
            showTagHandle: function () {
                this.tagHandleStatu = !this.tagHandleStatu;
            },
        },
    });
</script>
</html>
