package ppppp.controller;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ppppp.bean.Label;
import ppppp.bean.LabelExample;
import ppppp.dao.LabelMapper;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

/**
 * @author lppppp
 * @create 2021-02-19 21:51
 */
@Controller
@RequestMapping("/label")
public class LabelController {
    @Autowired
    LabelMapper labelMapper;
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
            newLabel.setTimes(0);
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
        criteria.andLabelNameLike("%"+lable+"%");
        List<Label> labelList = labelMapper.selectByExample(labelExample);
        // 标签不存在 进行添加到数据库中
        if(labelList!=null && labelList.size()>0){
            map.put("exist", true);
            map.put("msg", "存在类似标签");
            map.put("labelList", labelList);
        }
        return new Gson().toJson(map);
    }

}
