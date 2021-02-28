package ppppp.controller;

import com.google.gson.Gson;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import ppppp.bean.*;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;
import ppppp.util.MyUtils;


import javax.servlet.http.HttpServletRequest;
import java.util.*;

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
    public String selectByLabel(Integer labelid, String labelName,HttpServletRequest req) {
        TreeMap<String,ArrayList<Picture>> listHashMap = new TreeMap<>();

        // 获取 标签子标签的所有 id 通过 ',{labelName},' 字段来 查询所有
        ArrayList labelNameList = new ArrayList();
        getAllSonLabelId(labelName,labelNameList);//也包含自己

        ArrayList<Picture> pictureArrayList = pictureMapper.selectByLabelNameLike(labelNameList);
        if(pictureArrayList.size()>0){
            listHashMap.put(labelName, pictureArrayList);
        }

        //将map 写进 MonthPic
        req.getSession().setAttribute("monthsTreeMapListPic", listHashMap);
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
    public String getAllLabels(Model model) {
        LabelExample labelExample = new LabelExample();
        LabelExample.Criteria criteria = labelExample.createCriteria();
        criteria.andParentNameIsNull();
        // 获取所有以及节点
        List<Label> firstLevelLabels= labelMapper.selectByExample(labelExample);

        ArrayList list = getChildLabel(firstLevelLabels);
        String json = new Gson().toJson(list);
        model.addAttribute("labelTree", json);
        return "index";
    }


    public ArrayList getChildLabel( List<Label> father){
        // 标签不存在 进行添加到数据库中
        ArrayList list = new ArrayList();
        for (Label label : father) {
            // 为父标签
            LabelExample cExample = new LabelExample();
            LabelExample.Criteria ccriteria = cExample.createCriteria();
            ccriteria.andParentNameEqualTo(label.getLabelName());
            List<Label> sonLabels= labelMapper.selectByExample(cExample);
            ArrayList<String> times = new ArrayList<>();
            times.add(String.valueOf(label.getTags()));
            if(sonLabels!=null && sonLabels.size()>0){
                ArrayList sonList = getChildLabel(sonLabels);
                list.add(new nodes(label.getLabelid(),label.getLabelName(),"label/selectByLabel?labelName="+label.getLabelName()+"&labelid="+label.getLabelid(), times, sonList));
            }
            // 为叶子标签
            else {
                list.add(new nodes(label.getLabelid(),label.getLabelName(), "label/selectByLabel?labelName="+label.getLabelName()+"&labelid="+label.getLabelid(), times));
            }
        }
        return list;
    }


    @ResponseBody
    @RequestMapping(value = "/ajaxAddLabelToPic",method = RequestMethod.POST)
    public String ajaxAddLabelToPic(String picPath,Integer newLabelId) {

        Picture picture = pictureMapper.selectByPrimaryKey(picPath);
        String[] labelsId = picture.getPlabel().split(",");
        HashMap map = new HashMap();
        // 判断原 照片是否已经存在 新增的标签
        if(Arrays.asList(labelsId).contains(newLabelId)){
            map.put("exist", true);
            return new Gson().toJson(map);
        }
        // 1.更新 t_pic 表
        // 不存在标签 向数据库中插入该标签
        picture.setPlabel(picture.getPlabel().length()==0?","+newLabelId+",":picture.getPlabel()+newLabelId+",");
        int updatePic = pictureMapper.updateByPrimaryKeySelective(picture);
        // 2.更新 t_label 更新标签的徽记  本标签 以及 父标签
        int updateLabel = updateTagsById(newLabelId,1);

        if(updatePic!=1 || updateLabel !=1){
            System.out.println("插入标签到数据库失败");
            map.put("exist", "failed");
        }else {
            System.out.println("插入 更新 标签 "+ newLabelId +" 到数据库成功");
            map.put("exist", false);
            map.put("success", true);
        }

        return new Gson().toJson(map);
    }

    private int updateTagsById(Integer newLabelId,int num) {
        int update = 0;
        Label label = labelMapper.selectByPrimaryKey(newLabelId);
        if(label.getParentName()!=null){
            List<Label> parentLabel = labelMapper.selectByLabelName(label.getParentName());
            update = updateTagsById(parentLabel.get(0).getLabelid(),num);
            if(update == 0){
                return 0;
            }
        }
        label.setTags(label.getTags()+num);
        update = labelMapper.updateByPrimaryKey(label);
        return update;
    }


    //删除照片的标签  同时修改徽记数量
    @ResponseBody
    @RequestMapping(value = "/ajaxDeletePicLabel",method = RequestMethod.POST)
    public String ajaxDeletePicLabel(String picPath,String deleteLabelName) {
        HashMap map = new HashMap();
        Picture picture = pictureMapper.selectByPrimaryKey(picPath);
        Label label = labelMapper.selectByLabelName(deleteLabelName).get(0);
        if(label == null || picture.getPlabel().indexOf(label.getLabelid().toString())==-1){
            System.out.println("失败 -- 删除照片标签");
            map.put("isDelete", false);
            return new Gson().toJson(map);
        }

        picture.setPlabel(picture.getPlabel().replace(label.getLabelid()+",", ""));
        // 更新 t_pic
        int update = pictureMapper.updateByPrimaryKeySelective(picture);

        // 更新 t_label 修改徽记
        int updateTags = updateTagsById(label.getLabelid(),-1);
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
    @ResponseBody
    @RequestMapping(value = "/ajaxDeleteLabel",method = RequestMethod.POST)
    public String ajaxDeleLabel(String labelName) {
        HashMap map = new HashMap();
        if(labelName == null){
            map.put("isDelete", false);
            return new Gson().toJson(map);
        }
        // 先删除标签的 所有子标签

        int deleteLabel = deleteLabel(labelName);
        if(deleteLabel== 0){
            System.out.println("失败 -- 从数据库删除标签  "+labelName);
            map.put("isDelete", false);
        }else {
            System.out.println("成功 -- 从数据库删除标签  "+labelName);
            map.put("isDelete", true);
        }

        return new Gson().toJson(map);
    }

    private int deleteLabel(String labelName) {
        int delete = 0;
        List<Label> labels = labelMapper.selectByLabelName(labelName);
        for (Label label : labels) {
            // 删除所有子标签
            List<Label> sonlabels = labelMapper.selectByParentName(label.getLabelName());
            if(sonlabels.size()>0){
                for (Label sonlabel : sonlabels) {
                    delete =deleteLabel(sonlabel.getLabelName());
                    if(delete == 0){
                        return 0;
                    }
                }
            }
            delete = labelMapper.deleteByLabelName(label.getLabelName());
            if(delete == 0){
                return 0;
            }

        }
        return delete;
    }


    @ResponseBody
    @RequestMapping(value = "/ajaxCreateLabel",method = RequestMethod.POST)
    public String ajaxCreateLabel(String labelName,String parentLabelName) {

        int insert = 0;
        if(parentLabelName.equalsIgnoreCase("null")){
            insert = labelMapper.insert(new Label(labelName, 0, "label/selectByLabel?labelName=" + labelName));

        }else if(parentLabelName !=null){
            List<Label> labels = labelMapper.selectByLabelName(parentLabelName);
            if(labels.size()==1){
                Label parentLabel = labels.get(0);
                insert = labelMapper.insert(new Label(labelName, parentLabel.getLabelid(),parentLabelName, 0,"label/selectByLabel?labelName=" + labelName));
            }
        }
        HashMap map = new HashMap();
        if(insert!=1){
            System.out.println("失败 -- 从数据库创建标签");
            map.put("isInsert", false);
        }else {
            System.out.println("成功 -- 从数据库创建标签");
            map.put("isInsert", true);
        }
        return new Gson().toJson(map);
        // 更新 node的值 重新显示
        // return "forward:/pic/label/getLabelTree";
    }

    @ResponseBody
    @RequestMapping(value = "/ajaxEditLabel",method = RequestMethod.POST)
    public String ajaxEditLabel(String srclabelName,String newLabelName) {
        HashMap map = new HashMap();

        if(labelMapper.selectByLabelName(newLabelName).size() >0){
            System.out.println("失败 -- 从数据库更新标签  已存在同名标签");
            map.put("isEdit", false);
            return new Gson().toJson(map);
        }
        Label label = labelMapper.selectByLabelName(srclabelName).get(0);
        label.setLabelName(newLabelName);
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




}
