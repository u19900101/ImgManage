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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeMap;

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


    @ResponseBody
    @RequestMapping(value = "/ajaxAddLabel",method = RequestMethod.POST)
    public String ajaxAddLabel(String picPath,String newlabel) {

        Picture picture = pictureMapper.selectByPrimaryKey(picPath);
        String[] labels = picture.getPlabel().split(",");
        HashMap map = new HashMap();
        if(labels.length>0){
            for (String label : labels) {
                if(newlabel.equalsIgnoreCase(label)){
                    map.put("exist", true);
                    return new Gson().toJson(map);
                }
            }
        }
        // 不存在标签 向数据库中插入该标签
        picture.setPlabel(picture.getPlabel().length()==0?newlabel:picture.getPlabel()+","+newlabel);
        int update = pictureMapper.updateByPrimaryKeySelective(picture);
        if(update!=1){
            System.out.println("插入标签到数据库失败");
            map.put("exist", "failed");
        }
        map.put("exist", false);
        map.put("success", true);
        return new Gson().toJson(map);
    }


    //删除照片的标签
    @ResponseBody
    @RequestMapping(value = "/ajaxDeletePicLabel",method = RequestMethod.POST)
    public String ajaxDeletePicLabel(String picPath,String deleteLabel) {
        Picture picture = pictureMapper.selectByPrimaryKey(picPath);
        String newLabelStr = MyUtils.trimSubStr(picture.getPlabel(),deleteLabel);
        HashMap map = new HashMap();
        picture.setPlabel(newLabelStr);
        int update = pictureMapper.updateByPrimaryKeySelective(picture);
        if(update!=1){
            System.out.println("失败 -- 从数据库删除标签");
            map.put("isDelete", false);
        }else {
            System.out.println("成功 -- 从数据库删除标签失败");
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
            insert = labelMapper.insert(new Label(labelName, 0, "label/selectByLabel?" + labelName));

        }else if(parentLabelName !=null){
            List<Label> labels = labelMapper.selectByLabelName(parentLabelName);
            if(labels.size()==1){
                Label parentLabel = labels.get(0);
                insert = labelMapper.insert(new Label(labelName, parentLabel.getLabelid(),parentLabelName, 0,"label/selectByLabel?" + labelName));
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


    // @ResponseBody
    @RequestMapping("/selectByLabel")
    public String selectByLabel(String labelName, HttpServletRequest req) {
        TreeMap<String,ArrayList<Picture>> listHashMap = new TreeMap<>();
        // 添加标签本身的照片
        PictureExample fexample = new PictureExample();
        PictureExample.Criteria fexampleCriteria = fexample.createCriteria();
        fexampleCriteria.andPlabelEqualTo(labelName);
        ArrayList<Picture> flabelPictures = (ArrayList<Picture>) pictureMapper.selectByExample(fexample);
        if(flabelPictures!=null){
            listHashMap.put(labelName, flabelPictures);
        }


        LabelExample labelExample = new LabelExample();
        LabelExample.Criteria criteria = labelExample.createCriteria();
        criteria.andLabelNameEqualTo(labelName);
        // 获取所有 节点 label
        List<Label> firstLevelLabels= labelMapper.selectByExample(labelExample);
        ArrayList list = getChildLabel(firstLevelLabels);
        nodes nodes = (nodes) list.get(0);
        ArrayList<ppppp.bean.nodes> nodesArrayList = nodes.getNodes();
        if(nodesArrayList != null){
            for (ppppp.bean.nodes sonNode : nodesArrayList) {
                String sonLabelName = sonNode.getText();
                PictureExample pexample = new PictureExample();
                PictureExample.Criteria pexampleCriteria = pexample.createCriteria();
                pexampleCriteria.andPlabelEqualTo(sonLabelName);
                ArrayList<Picture> labelPictures = (ArrayList<Picture>) pictureMapper.selectByExample(pexample);
                listHashMap.put(sonLabelName, labelPictures);
            }
        }else {
            String sonLabelName = labelName;
            PictureExample pexample = new PictureExample();
            PictureExample.Criteria pexampleCriteria = pexample.createCriteria();
            pexampleCriteria.andPlabelEqualTo(sonLabelName);
            List<Picture> labelPictures = pictureMapper.selectByExample(pexample);
            listHashMap.put(sonLabelName, (ArrayList<Picture>) labelPictures);
        }

        //将map 写进 MonthPic
        req.getSession().setAttribute("monthsTreeMapListPic", listHashMap);
        // return new Gson().toJson(listHashMap);
        return "picture";
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
        // return "label/treeDemo";
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
                list.add(new nodes(label.getLabelName(),"label/selectByLabel?labelName="+label.getLabelName(), times, sonList));
            }
            // 为叶子标签
            else {
                list.add(new nodes(label.getLabelName(), "label/selectByLabel?labelName="+label.getLabelName(), times));
            }
        }
        return list;
    }

}
