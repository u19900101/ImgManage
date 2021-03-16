package ppppp.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import ppppp.bean.*;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

import static ppppp.service.PictureService.groupPictureByMonth;

/**
 * @author lppppp
 * @create 2021-02-19 21:51
 */
@Controller
@RequestMapping("/label")
public class LabelController {
    @Autowired
    LabelMapper labelMapper;
    @Autowired
    PictureMapper pictureMapper;
    // 展示所有的标签
    @RequestMapping("/showAllLabel")
    public String showRecentLabel(Model model) {
        LabelExample labelExample = new LabelExample();
        List<Label> allLabels= labelMapper.selectByExample(labelExample);
        if(allLabels!=null && allLabels.size()>0){
            model.addAttribute("labelList", allLabels);

        }
        return "label/drag";
    }
    //修改图片信息
    @ResponseBody
    @RequestMapping("/insert")
    public String ajaxInsertLabel(String newLable) {
        HashMap map = new HashMap();
        List<Label> label =  labelMapper.selectByLabelName(newLable);
        // 标签不存在 进行添加到数据库中
        if(label.size()>0){
            map.put("exist", true);
            map.put("msg", "标签已存在");
            map.put("label", label);
        }else {
            map.put("exist", false);
            Label newLabel = new Label();
            newLabel.setLabelName(newLable);
            newLabel.setTags(0);
            int insert = labelMapper.insert(newLabel);
            if(insert == 1){
                map.put("success", "成功添加标签");
            }else {
                map.put("fail", "插入标签到数据库中失败");
            }
        }
        return new Gson().toJson(map);
    }

    @RequestMapping("/selectByLabel")
    // 根据 标签名称 获取所有的包含该标签的照片 按照月份(不包含二级标签) 装进map中
    public String selectByLabel( String labelName,HttpServletRequest req) {
        TreeMap<String,ArrayList<Picture>> listHashMap = new TreeMap<>();
        ArrayList<Picture> pictureArrayList = new ArrayList<>();
        ArrayList labelidList = new ArrayList();
        if(labelName.equalsIgnoreCase("undefined")){
            pictureArrayList = pictureMapper.selectLabelIsNull();
            pictureArrayList.addAll(pictureMapper.selectByLabelName(""));
        }else {
            // 获取 标签子标签的所有 id 通过 ',{labelName},' 字段来 查询所有
            getAllSonLabelId(labelName,labelidList);//也包含自己
            pictureArrayList = pictureMapper.selectByLabelIdLike(labelidList);
        }

        if(pictureArrayList.size()>0){
            listHashMap.put(labelName, pictureArrayList);
        }
        TreeMap<String,ArrayList<Picture>> map = groupPictureByMonth(pictureArrayList);
        //将map 写进 MonthPic
        req.getSession().setAttribute("monthsTreeMapListPic", map);
        return "picture";
    }

    private void getAllSonLabelId(String labelName,List resLabellist) {
        List<Label> sonLabelList = labelMapper.selectByParentName(labelName);
        if(sonLabelList.size()>0){
            for (Label label : sonLabelList) {
                getAllSonLabelId(label.getLabelName(),resLabellist);
            }
        }
        resLabellist.add(labelMapper.selectByLabelName(labelName).get(0).getLabelid());
    }



    @RequestMapping("/getLabelTree")
    public String init(HttpServletRequest req){

        List<Label> allLabel = labelMapper.getAllLabel();
        List<labelNode> allLabelNode = new ArrayList<>();
        if(allLabel.size()>0){
            for (Label label : allLabel) {
                String id = label.getLabelid().toString();
                String parent = label.getParentid() == null?"#":label.getParentid().toString();
                String tags = label.getTags().toString();
                String text = label.getLabelName()+"("+tags+")";
                String href = label.getHref();
                allLabelNode.add(new labelNode(id, parent, text, tags, href));
            }
        }
        String allLabelJson = new Gson().toJson(allLabelNode);

        req.getSession().setAttribute("allLabelJson", allLabelJson);
        // return "solution";
        return "tree";
    }

    // /*public String getAllLabels(Model model) {
    //     LabelExample labelExample = new LabelExample();
    //     LabelExample.Criteria criteria = labelExample.createCriteria();
    //     criteria.andParentNameIsNull();
    //     // 获取所有以及节点
    //     List<Label> firstLevelLabels= labelMapper.selectByExample(labelExample);
    //
    //
    //     List<Label>  Max7Label = labelMapper.selectMaxNTags(7);
    //     if(labelMapper.getCount() > 7){
    //         List<Label> recentN3IdLabel = labelMapper.selectRecentNId(3);
    //         for (Label label : recentN3IdLabel) {
    //             if(!Max7Label.contains(label)){
    //                 Max7Label.add(label);
    //             }
    //         }
    //     }
    //     model.addAttribute("recent3AndMax7Label", Max7Label);
    //     ArrayList list = getChildLabel(firstLevelLabels);
    //     String json = new Gson().toJson(list);
    //     model.addAttribute("labelTree", json);
    //     return "index";
    // }*/

    public void getChildLabelId( Integer labelId,List<String> labelIdList){

        List<Label> sonLabels= labelMapper.selectByParentId(labelId);
        if(sonLabels.size()>0){
            for (Label label : sonLabels) {
                getChildLabelId(label.getLabelid(),labelIdList);
                labelIdList.add(label.getLabelid().toString());
            }
        }
    }

    public ArrayList getChildLabel( List<Label> father){
        // 标签不存在 进行添加到数据库中
        ArrayList list = new ArrayList();
        for (Label label : father) {
            // 为父标签
            List<Label> sonLabels= labelMapper.selectByParentName(label.getLabelName());
            ArrayList<String> tags = new ArrayList<>();
            tags.add(String.valueOf(label.getTags()));
            if(sonLabels.size()>0){
                ArrayList sonList = getChildLabel(sonLabels);
                list.add(new nodes(label.getLabelid(),label.getLabelName(),"label/selectByLabel?labelName="+label.getLabelName()+"&labelid="+label.getLabelid(), tags, sonList));
            }
            // 为叶子标签
            else {
                list.add(new nodes(label.getLabelid(),label.getLabelName(), "label/selectByLabel?labelName="+label.getLabelName()+"&labelid="+label.getLabelid(), tags));
            }
        }
        return list;
    }

    @ResponseBody
    @RequestMapping(value = "/ajaxGetLabelHref",method = RequestMethod.POST)
    public String ajaxGetLabelHref(HttpServletRequest request,String labelHref) {
        HashMap  map = new HashMap<>();
        request.getSession().setAttribute("labelHref", labelHref);
        if(labelHref != null){
            map.put("status", "success");
            return new Gson().toJson(map);
        }else {
            return null;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/ajaxAddLabelToPic",method = RequestMethod.POST)
    public String ajaxAddLabelToPic(String picId,Integer newLabelId,String newlabelName) {
        HashMap map = new HashMap();
        ArrayList<Integer> changeLabels = new ArrayList<>();
        int addOrDeleteTagsById = 0;
        // 将字符串从 / 转为 \ 以便查询
        Picture picture = pictureMapper.selectByPrimaryKey(picId);
        if(picture.getPlabel()!=null && picture.getPlabel().length()>1){
            String[] labelsId = picture.getPlabel().replace(","," ").trim().split(" ");
            // 判断原 照片是否已经存在 新增的标签
            if(Arrays.asList(labelsId).contains(newLabelId.toString())){
                map.put("exist", true);
                return new Gson().toJson(map);
            }
            addOrDeleteTagsById = addOrDeleteTagsById(picture.getPlabel(), newLabelId, 1, changeLabels);
        }else {
            addOrDeleteTagsById = updateTagsById(newLabelId,null,1,changeLabels);
        }
        // 判断是否从未分类的照片 添加了标签
        if(picture.getPlabel() == null || picture.getPlabel().length()<=1){
            Label undefined = labelMapper.selectByPrimaryKey(-1);
            undefined.setTags(undefined.getTags()-1);
            labelMapper.updateByPrimaryKey(undefined);
        }
        // 2.更新 t_label 更新标签的徽记  本标签 以及 父标签
        picture.setPlabel(picture.getPlabel() == null || picture.getPlabel().length()<=1?","+newLabelId+",":picture.getPlabel()+newLabelId+",");


        // 1.更新 t_pic 表
        // 不存在标签 向数据库中插入该标签

        int updatePic = pictureMapper.updateByPrimaryKeySelective(picture);
        if(updatePic!=1 || addOrDeleteTagsById !=1){
            System.out.println("失败 给照片添加标签");
            map.put("failed", true);
        }else {
            System.out.println("插入 更新 标签 "+ newLabelId +" 到数据库成功");
            map.put("succeed", true);
            map.put("newLabelId", newLabelId);
            // "jimi(111)  --> jimi
            map.put("newlabelName", newlabelName);
            // map.put("changeLabels", changeLabels);
        }

        return new Gson().toJson(map);
    }

    private int addOrDeleteTagsById(String plabel, Integer newLabelId, int num,ArrayList<Integer> changeLabels) {
        //1.若 原标签中已有 新增标签的子类 则 所有的 徽记数量不变
        //2.若 原标签中已有 新增标签的父类 则 徽记数量只更新到父类
        //3.若 无相关子父类 则 更新 新增标签的所有父类

        String[] split = plabel.replace(",", " ").trim().split(" ");
        //  1.判断是否  包含子类
        //  得到所有子类
        List <String>labelList  = new ArrayList();
        getChildLabelId(newLabelId,labelList);

        if(labelList.size()>0){
            for (String s : split) {
                if(labelList.contains(s)){
                    // 包含子类 不作处理
                    return 1;
                }
            }
        }
        //  2.判断是否  包含父类
        // 查找所有的父标签  找到 最近一级的父标签后跳出
        return updateTagsById(plabel, newLabelId, num,changeLabels);
    }

    // 更新到 父标签包含 同样标签的下一级为止
    // 检查新增的标签 与 已经存在的标签是否有 子父类关系 有的话 只更新到 父类的下一级标签
    private int updateTagsById(String plabel, Integer newid, int num,ArrayList<Integer> changeLabels) {
       Integer parentid = newid;
        // 查找所有的父标签  找到 最近一级的父标签后跳出
        // 删除时 原标签中已存在删除的 标签则从原标签的父类开始查找
        if(num == -1){
            parentid = labelMapper.selectByPrimaryKey(newid).getParentid();
        }
        while (parentid != null){
            if(plabel.indexOf(parentid.toString()) != -1){
                break;
            }
            Label label = labelMapper.selectByPrimaryKey(parentid);
            parentid = label.getParentid();
            // 标签组 中包含子标签
        }
        return updateTagsById(newid,parentid,num,changeLabels);
    }

    public int updateTagsById(Integer newLabelId,Integer parentId,int num,ArrayList<Integer> changeLabels) {
        int update =-1;
        // parentid 为null 时 表示 不包含父类 更新 newid 所有的  父类
        Integer t_parentId = newLabelId;
        while (t_parentId != parentId){
            Label label = labelMapper.selectByPrimaryKey(t_parentId);
            label.setTags(label.getTags()+num);
            update = labelMapper.updateByPrimaryKey(label);
            t_parentId = label.getParentid();
            changeLabels.add(label.getLabelid());
        }
        return update;
    }



    //删除照片的标签  同时修改徽记数量
    @ResponseBody
    @RequestMapping(value = "/ajaxDeletePicLabel",method = RequestMethod.POST)
    public String ajaxDeletePicLabel(String pId,Integer deleteLabelId) {
        HashMap map = new HashMap();
        Picture picture = pictureMapper.selectByPrimaryKey(pId);
        Label label = labelMapper.selectByPrimaryKey(deleteLabelId);
        if(label == null || picture.getPlabel().indexOf(label.getLabelid().toString())==-1){
            System.out.println("失败 -- 删除照片标签");
            map.put("isDelete", false);
            return new Gson().toJson(map);
        }

        // 更新 t_label 修改徽记
        // 若 标签同时包含父标签的id 则不进行级联更新
        ArrayList<Integer> changeLabels = new ArrayList<>();
        int updateTags = addOrDeleteTagsById(picture.getPlabel(),deleteLabelId,-1,changeLabels);
        String replace = picture.getPlabel().replace(deleteLabelId + ",", "");
        if(replace.length()==1){
            replace = "";
        }
        picture.setPlabel(replace);

        // 更新 t_pic
        int update = pictureMapper.updateByPrimaryKeySelective(picture);


        if(update!=1 || updateTags!= 1){
            System.out.println("失败 -- 删除照片标签");
            map.put("isDelete", false);
        }else {
            System.out.println("成功 -- 删除照片标签");
            map.put("isDelete", true);
        }
        return new Gson().toJson(map);
    }



    // 删除标签类
    // 1. 删除本身标签以及子类标签
    // 2. 移除 所有照片中的该标签
    @ResponseBody
    @RequestMapping(value = "/ajaxDeleteLabel",method = RequestMethod.POST)
    public String ajaxDeleLabel(Integer labelId) {
        HashMap map = new HashMap();
        if(labelId == null){
            map.put("isDelete", false);
            return new Gson().toJson(map);
        }
        // 先删除标签的 所有子标签
        int deleteLabel = deleteLabel(labelId);
        if(deleteLabel== 0){
            System.out.println("失败 -- 从数据库删除标签  "+labelId);
            map.put("isDelete", false);
        }else {
            System.out.println("成功 -- 从数据库删除标签  "+labelId);
            map.put("isDelete", true);
        }

        return new Gson().toJson(map);
    }

    private int deleteLabel(Integer labelId) {
        int delete = 0;
        // 删除所有子标签
        List<Label> sonlabels = labelMapper.selectByParentId(labelId);
        if(sonlabels.size()>0){
            for (Label sonlabel : sonlabels) {
                delete =deleteLabel(sonlabel.getLabelid());
                if(delete == 0){
                    return 0;
                }
            }
        }
        // 2.移除所有照片中的该标签
        List list = new ArrayList<>();
        list.add(labelId);
        ArrayList<Picture> pictureArrayList = pictureMapper.selectByLabelIdLike(list);
        if(pictureArrayList.size()>0){
            for (Picture picture : pictureArrayList) {
                String newPicLabel = picture.getPlabel().replace(labelId+",","");
                picture.setPlabel(newPicLabel.length()==1?"":newPicLabel);
                int update = pictureMapper.updateByPrimaryKeySelective(picture);
                if(update == 0){
                    return 0;
                }
            }
        }
        // 1.删除标签类
        delete = labelMapper.deleteByPrimaryKey(labelId);
        if(delete == 0){
            return 0;
        }
        return delete;
    }


    @ResponseBody
    @RequestMapping(value = "/ajaxCreateLabel",method = RequestMethod.POST)
    public String ajaxCreateLabel(String labelName,String parentLabelId) {

        int insert = 0;
        if(parentLabelId ==null){
            insert = labelMapper.insert(new Label(labelName, 0, "label/selectByLabel?labelName=" + labelName));
        }else if(parentLabelId !=null){
            Label parentLabel = labelMapper.selectByPrimaryKey(Integer.valueOf(parentLabelId));
            if(parentLabel != null){
                insert = labelMapper.insert(new Label(labelName, parentLabel.getLabelid(),parentLabel.getLabelName(), 0,"label/selectByLabel?labelName=" + labelName));
            }
        }
        HashMap map = new HashMap();
        List<Label> labels = labelMapper.selectByLabelName(labelName);
        Integer labelid = -1;
        if(labels.size()>0){
            labelid = labels.get(0).getLabelid();
        }
        if(insert!=1 || labelid == -1){
            System.out.println("失败 -- 从数据库创建标签");
            map.put("isInsert", false);
        }else {
            System.out.println("成功 -- 从数据库创建标签");
            map.put("isInsert", true);
            map.put("id", labelid);
        }
        return new Gson().toJson(map);
        // 更新 node的值 重新显示
        // return "forward:/pic/label/getLabelTree";
    }

    @ResponseBody
    @RequestMapping(value = "/ajaxEditLabel",method = RequestMethod.POST)
    public String ajaxEditLabel(Integer srclabelId,String newLabelName) {
        HashMap map = new HashMap();

        if(labelMapper.selectByLabelName(newLabelName).size() >0){
            System.out.println("未修改 -- 已存在同名标签");
            map.put("isEdit", false);
            return new Gson().toJson(map);
        }
        Label label = labelMapper.selectByPrimaryKey(srclabelId);
        label.setLabelName(newLabelName);
        String newHref = label.getHref().substring(0,label.getHref().indexOf("=")+1)+newLabelName;
        label.setHref(newHref);
        int update = labelMapper.updateByPrimaryKey(label);

        if(update!= 1){
            System.out.println("失败 -- 从数据库更新标签");
            map.put("isEdit", false);
        }else {
            System.out.println("成功 -- 从数据库更新标签");
            map.put("isEdit", true);
        }
        return new Gson().toJson(map);
    }

    private void getAllLabelId(Integer labelId,List resLabelIdlist) {
        List<Label> sonLabelList = labelMapper.selectByParentId(labelId);
        if(sonLabelList.size()>0){
            for (Label label : sonLabelList) {
                getAllLabelId(label.getLabelid(),resLabelIdlist);
            }
        }
        resLabelIdlist.add(labelId);
    }
    private ArrayList<Picture> getAllLabelPicPath(Integer labelId) {
        List allLabelList = new ArrayList<>();
        getAllLabelId(labelId,allLabelList);
        return pictureMapper.selectByLabelNameLike(allLabelList);
    }

    public int updateMoveTags(Integer labelId,int newParentLabelId) {
        int update = 1;
        ArrayList<Picture> allSrcLabelPicPath = getAllLabelPicPath(labelId);
        ArrayList<Picture> allOldParentPicPath = null;
        ArrayList<Picture> allNewParentPicPath = null;
        Integer oldParentId = -1;

        Label label = labelMapper.selectByPrimaryKey(labelId);
        if(label != null){
               if(allSrcLabelPicPath.size()>0){

                   // 获取 原父标签 排除掉原label 后剩下的label所包含的路径集合
                   if(label.getParentid() != null){
                       oldParentId = label.getParentid();
                       List  allLabelIdList = new ArrayList<>();
                       getAllLabelId(oldParentId,allLabelIdList);
                       allLabelIdList.remove(labelId);
                       allOldParentPicPath = pictureMapper.selectByLabelNameLike(allLabelIdList);
                   }

                   // 获取所有新父节点的路径集合
                   if(newParentLabelId != -1){
                       allNewParentPicPath = getAllLabelPicPath(newParentLabelId);
                   }

                   for (Picture picture : allSrcLabelPicPath) {

                        if(allOldParentPicPath != null && !allOldParentPicPath.contains(picture)){
                            // 修改 本级的tag 直到父标签包含或者为空
                            update = updateMoveTagsById(oldParentId,picture,-1);
                        }

                       if(allNewParentPicPath != null && !allNewParentPicPath.contains(picture)){
                           // 修改 本级的tag 直到父标签包含或者为空
                           update = updateMoveTagsById(newParentLabelId,picture,1);
                       }
                }
            }
        }

        return update;
    }

    private int updateMoveTagsById(Integer labelId,Picture picture,int addOrSub) {
        int moveTagsById =-1;
        // 修改 不包含该照片的 标签类
        Label label = labelMapper.selectByPrimaryKey(labelId);
        label.setTags(label.getTags()+addOrSub);
        moveTagsById = labelMapper.updateByPrimaryKey(label);

        // 查找父类
        Integer parentId = label.getParentid();
        if ( parentId != null){
            List list = new ArrayList<>();
            list.add(parentId);
            ArrayList<Picture> pictures = pictureMapper.selectByLabelIdLike(list);
            // 若 父类中也不包该标签 则继续修改
            if(!pictures.contains(picture)){
                moveTagsById = updateMoveTagsById(parentId, picture, addOrSub);
            }
        }
        return moveTagsById;
    }


    @ResponseBody
    @RequestMapping(value = "/ajaxMoveLabel",method = RequestMethod.POST)
    public String ajaxMoveLabel(Integer labelId,Integer newParentLabelId) {
        HashMap map = new HashMap();

        Label parentLabel = labelMapper.selectByPrimaryKey(newParentLabelId == -1?null:newParentLabelId);
        Label label = labelMapper.selectByPrimaryKey(labelId);
        if( label == null ){
            System.out.println("失败 -- 移动标签 -- 标签不存在");
            map.put("isMove", false);
            return new Gson().toJson(map);
        }

        //减去 节点原所有 parent的tag
        //增加 现 parent 所有父 的 tag

        int updateTags = updateMoveTags(labelId,newParentLabelId);

        if(updateTags == 1){
            label.setParentid(newParentLabelId==-1?null:newParentLabelId);
            label.setParentName(parentLabel == null?null:parentLabel.getLabelName());
            updateTags = labelMapper.updateByPrimaryKey(label);
        }


        if( updateTags!= 1){
            System.out.println("失败 -- 移动标签");
            map.put("isMove", false);
        }else {
            System.out.println("成功 -- 移动标签");
            map.put("isMove", true);
        }
        return new Gson().toJson(map);
    }
}
