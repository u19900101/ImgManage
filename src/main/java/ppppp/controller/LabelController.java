package ppppp.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import ppppp.bean.*;
import ppppp.dao.LabelMapper;
import ppppp.dao.PictureMapper;


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
        Label label= labelMapper.selectByPrimaryKey(newLable);
        // 标签不存在 进行添加到数据库中
        if(label!=null){
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

    //实时模糊匹配 输入的label
    @ResponseBody
    @RequestMapping("/isLabelExist")
    public String ajaxIsLabelExist(String lable) {
        HashMap map = new HashMap();
        LabelExample labelExample = new LabelExample();
        LabelExample.Criteria criteria = labelExample.createCriteria();
        criteria.andLabelNameLike(lable);
        List<Label> labelList = labelMapper.selectByExample(labelExample);
        // 标签不存在 进行添加到数据库中
        if(labelList!=null && labelList.size()>0){
            map.put("exist", true);
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
