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
<div class="wrapper">
    <div class="left">
        <div id="jstree" class="jstree">
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
    <div class="right">
        <jsp:include page="iframe.jsp"/>
        <%--<jsp:include page="/picture/page"/>--%>
    </div>
</div>


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
                        // $('#jstree_log').html("Drop target: #"+node_parent.id+' Move target from OUTSIDE tree: #'+node.id+'');
                        return false;
                    } else {
                        // $('#jstree_log').html("Drop target: #"+node_parent.id+' Move target from inside the tree: #'+node.id+'');
                        return true;
                    }//eof inside or outside
                }//eof check callback
            }//eof core
            //plugins
            , "plugins" : [ "contextmenu", "dnd"]
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

        var $content;
        $("#Iframe").on('load', function() {
            console.log('loaded');
            $content = $(this).contents();
            test($content);
        });
        //Activate droppable zones
        function test(x) {
            $(x).find('body').children('*').droppable({
                accept: '*',
                greedy: true,
                drop: function(event, ui) {
                    console.log('came in');
                    $(this).append(ui.draggable.clone());
                    $('Iframe').trigger('load');
                }
            });
        }
    });//eof document ready


</script>
</body>
</html>