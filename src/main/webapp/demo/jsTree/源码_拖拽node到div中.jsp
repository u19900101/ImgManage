<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/pages/head.jsp"%>
<html>

<body>
    <div id="jstree" class="jstree" style="width: 300px; border: 1px solid navy">
        <ul>
            <li id="1">Root node 1
                <ul>
                    <li id="2">Child node 1</li>
                 <%--   <li id="3"><a href="#">Child node 2</a></li>
                    <li id="4"><a href="#">Child node 3</a></li>
                    <li id="5"><a href="#">Child node 4</a></li>
                    <li id="6"><a href="#">Child node 5</a></li>
                    <li id="7"><a href="#">Child node 6</a></li>
                    <li id="8"><a href="#">Child node 7</a></li>
                    <li id="9"><a href="#">Child node 8</a>--%>
                    <%--    <ul>
                            <li id="11">Child node x1</li>
                            <li id="12"><a href="#">Child node x2</a></li>
                            <li id="13"><a href="#">Child node x3</a></li>
                            <li id="14"><a href="#">Child node x4</a></li>
                            <li id="15"><a href="#">Child node x5</a></li>
                            <li id="16"><a href="#">Child node x6</a></li>
                            <li id="17"><a href="#">Child node x7</a></li>
                            <li id="18"><a href="#">Child node x8</a></li>
                            <li id="19"><a href="#">Child node x9</a></li>
                        </ul></li>--%>
                    <li id="112"><a href="#">Child node 9</a></li>
                </ul>
            </li>
        </ul>
    </div>


    <div id="drag0" class="dragme" style="width=200px; height:50px; border: 1px solid black; cursor:pointer;">move me 0</div>


    <div id="drop0" class="drop" style="width=200px; height:200px; border: 1px solid green;">drop to me</div>


    <div id="jstree_log">jstree_log</div>
</body>
<script>

    $(document).ready(function() {
        $('#jstree').jstree({
            //
            'core' : {
                //
                'check_callback' : function (operation, node, node_parent, node_position, more) {
                    //
                    // Outside or inside
                    if ($('#'+node.id).hasClass('dragme')) {
                        // from outside
                        $('#jstree_log').html("Drop target: #"+node_parent.id+' Move target from OUTSIDE tree: #'+node.id+'');
                        return false;
                    } else {
                        $('#jstree_log').html("Drop target: #"+node_parent.id+' Move target from inside the tree: #'+node.id+'');
                        return true;
                    }//eof inside or outside
                },//eof check callback
                'data' : [
                    { "id" : "labelID_1", "parent" : "#", "text" : "jimi" ,"icon": "glyphicon glyphicon-leaf" ,"tag":1,"href":"label/selectByLabel?labelName=jimi"},
                    { "id" : "labelID_2", "parent" : "#", "text" : "jingjing" ,"icon": "glyphicon glyphicon-tag", "tag":2,"href":"label/selectByLabel?labelName=jingjing"},
                    { "id" : "labelID_3", "parent" : "labelID_4", "text" : "rose","tag":3,"href":"label/selectByLabel?labelName=rose"},
                    { "id" : "labelID_4", "parent" : "#", "text" : "花花","tag":4,"href":"label/selectByLabel?labelName=花花"},
                ],
                }//eof core
            //plugins
            , "plugins" : [ "contextmenu", "dnd"]
        });//eof jstree


        // element you want to be able to drop on the tree
        $('.dragme').on('mousedown', function (e) {
            console.log("开始拖拽....", "id" , this.id, "text", $(this).text() );
            return $.vakata.dnd.start(e, {
                'jstree' : true,
                'obj' : $(this),
                'nodes' : [{ id : this.id/*, text: $(this).text()*/ }] },
                '<div id="jstree-dnd" class="jstree-default"><i class="jstree-icon jstree-er"></i>' + $(this).text() + '<ins class="jstree-copy" style="display:none;">+</ins></div>');
        });



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
                if(t.closest('.drop').length) {
                    data.helper.find('.jstree-icon').removeClass('jstree-er').addClass('jstree-ok');
                }
                else {
                    data.helper.find('.jstree-icon').removeClass('jstree-ok').addClass('jstree-er');
                }
            }

        }).on('dnd_stop.vakata', function (e, data) {

            target_id = parseInt(data.event.target.id,10) || 0;
            //drag_id = ??;
            // alert(target_id);
            console.log("结束拖拽。from",data.data.nodes[0]);
            var labelId = data.event.target.id.substring(0,data.event.target.id.lastIndexOf("_"));
            console.log("labelId: ",labelId);
            console.log("picId: ",data.data.nodes[0].id);


        });

        $('#jstree').jstree(true).open_all('1');

        // $('#jstree').jstree(true).close_node('9');
    });//eof document ready


</script>
</html>