package ppppp.bean;

import java.util.ArrayList;
import java.util.List;

public class PictureExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public PictureExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    public String getOrderByClause() {
        return orderByClause;
    }

    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    public boolean isDistinct() {
        return distinct;
    }

    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andPidIsNull() {
            addCriterion("pid is null");
            return (Criteria) this;
        }

        public Criteria andPidIsNotNull() {
            addCriterion("pid is not null");
            return (Criteria) this;
        }

        public Criteria andPidEqualTo(String value) {
            addCriterion("pid =", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidNotEqualTo(String value) {
            addCriterion("pid <>", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidGreaterThan(String value) {
            addCriterion("pid >", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidGreaterThanOrEqualTo(String value) {
            addCriterion("pid >=", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidLessThan(String value) {
            addCriterion("pid <", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidLessThanOrEqualTo(String value) {
            addCriterion("pid <=", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidLike(String value) {
            addCriterion("pid like", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidNotLike(String value) {
            addCriterion("pid not like", value, "pid");
            return (Criteria) this;
        }

        public Criteria andPidIn(List<String> values) {
            addCriterion("pid in", values, "pid");
            return (Criteria) this;
        }

        public Criteria andPidNotIn(List<String> values) {
            addCriterion("pid not in", values, "pid");
            return (Criteria) this;
        }

        public Criteria andPidBetween(String value1, String value2) {
            addCriterion("pid between", value1, value2, "pid");
            return (Criteria) this;
        }

        public Criteria andPidNotBetween(String value1, String value2) {
            addCriterion("pid not between", value1, value2, "pid");
            return (Criteria) this;
        }

        public Criteria andPathIsNull() {
            addCriterion("path is null");
            return (Criteria) this;
        }

        public Criteria andPathIsNotNull() {
            addCriterion("path is not null");
            return (Criteria) this;
        }

        public Criteria andPathEqualTo(String value) {
            addCriterion("path =", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathNotEqualTo(String value) {
            addCriterion("path <>", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathGreaterThan(String value) {
            addCriterion("path >", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathGreaterThanOrEqualTo(String value) {
            addCriterion("path >=", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathLessThan(String value) {
            addCriterion("path <", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathLessThanOrEqualTo(String value) {
            addCriterion("path <=", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathLike(String value) {
            addCriterion("path like", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathNotLike(String value) {
            addCriterion("path not like", value, "path");
            return (Criteria) this;
        }

        public Criteria andPathIn(List<String> values) {
            addCriterion("path in", values, "path");
            return (Criteria) this;
        }

        public Criteria andPathNotIn(List<String> values) {
            addCriterion("path not in", values, "path");
            return (Criteria) this;
        }

        public Criteria andPathBetween(String value1, String value2) {
            addCriterion("path between", value1, value2, "path");
            return (Criteria) this;
        }

        public Criteria andPathNotBetween(String value1, String value2) {
            addCriterion("path not between", value1, value2, "path");
            return (Criteria) this;
        }

        public Criteria andPnameIsNull() {
            addCriterion("pname is null");
            return (Criteria) this;
        }

        public Criteria andPnameIsNotNull() {
            addCriterion("pname is not null");
            return (Criteria) this;
        }

        public Criteria andPnameEqualTo(String value) {
            addCriterion("pname =", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameNotEqualTo(String value) {
            addCriterion("pname <>", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameGreaterThan(String value) {
            addCriterion("pname >", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameGreaterThanOrEqualTo(String value) {
            addCriterion("pname >=", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameLessThan(String value) {
            addCriterion("pname <", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameLessThanOrEqualTo(String value) {
            addCriterion("pname <=", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameLike(String value) {
            addCriterion("pname like", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameNotLike(String value) {
            addCriterion("pname not like", value, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameIn(List<String> values) {
            addCriterion("pname in", values, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameNotIn(List<String> values) {
            addCriterion("pname not in", values, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameBetween(String value1, String value2) {
            addCriterion("pname between", value1, value2, "pname");
            return (Criteria) this;
        }

        public Criteria andPnameNotBetween(String value1, String value2) {
            addCriterion("pname not between", value1, value2, "pname");
            return (Criteria) this;
        }

        public Criteria andPcreatimeIsNull() {
            addCriterion("pcreatime is null");
            return (Criteria) this;
        }

        public Criteria andPcreatimeIsNotNull() {
            addCriterion("pcreatime is not null");
            return (Criteria) this;
        }

        public Criteria andPcreatimeEqualTo(String value) {
            addCriterion("pcreatime =", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeNotEqualTo(String value) {
            addCriterion("pcreatime <>", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeGreaterThan(String value) {
            addCriterion("pcreatime >", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeGreaterThanOrEqualTo(String value) {
            addCriterion("pcreatime >=", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeLessThan(String value) {
            addCriterion("pcreatime <", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeLessThanOrEqualTo(String value) {
            addCriterion("pcreatime <=", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeLike(String value) {
            addCriterion("pcreatime like", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeNotLike(String value) {
            addCriterion("pcreatime not like", value, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeIn(List<String> values) {
            addCriterion("pcreatime in", values, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeNotIn(List<String> values) {
            addCriterion("pcreatime not in", values, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeBetween(String value1, String value2) {
            addCriterion("pcreatime between", value1, value2, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andPcreatimeNotBetween(String value1, String value2) {
            addCriterion("pcreatime not between", value1, value2, "pcreatime");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeIsNull() {
            addCriterion("GPS_Longitude is null");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeIsNotNull() {
            addCriterion("GPS_Longitude is not null");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeEqualTo(String value) {
            addCriterion("GPS_Longitude =", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeNotEqualTo(String value) {
            addCriterion("GPS_Longitude <>", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeGreaterThan(String value) {
            addCriterion("GPS_Longitude >", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeGreaterThanOrEqualTo(String value) {
            addCriterion("GPS_Longitude >=", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeLessThan(String value) {
            addCriterion("GPS_Longitude <", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeLessThanOrEqualTo(String value) {
            addCriterion("GPS_Longitude <=", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeLike(String value) {
            addCriterion("GPS_Longitude like", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeNotLike(String value) {
            addCriterion("GPS_Longitude not like", value, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeIn(List<String> values) {
            addCriterion("GPS_Longitude in", values, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeNotIn(List<String> values) {
            addCriterion("GPS_Longitude not in", values, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeBetween(String value1, String value2) {
            addCriterion("GPS_Longitude between", value1, value2, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLongitudeNotBetween(String value1, String value2) {
            addCriterion("GPS_Longitude not between", value1, value2, "gpsLongitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeIsNull() {
            addCriterion("GPS_Latitude is null");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeIsNotNull() {
            addCriterion("GPS_Latitude is not null");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeEqualTo(String value) {
            addCriterion("GPS_Latitude =", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeNotEqualTo(String value) {
            addCriterion("GPS_Latitude <>", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeGreaterThan(String value) {
            addCriterion("GPS_Latitude >", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeGreaterThanOrEqualTo(String value) {
            addCriterion("GPS_Latitude >=", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeLessThan(String value) {
            addCriterion("GPS_Latitude <", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeLessThanOrEqualTo(String value) {
            addCriterion("GPS_Latitude <=", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeLike(String value) {
            addCriterion("GPS_Latitude like", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeNotLike(String value) {
            addCriterion("GPS_Latitude not like", value, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeIn(List<String> values) {
            addCriterion("GPS_Latitude in", values, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeNotIn(List<String> values) {
            addCriterion("GPS_Latitude not in", values, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeBetween(String value1, String value2) {
            addCriterion("GPS_Latitude between", value1, value2, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andGpsLatitudeNotBetween(String value1, String value2) {
            addCriterion("GPS_Latitude not between", value1, value2, "gpsLatitude");
            return (Criteria) this;
        }

        public Criteria andPwidthIsNull() {
            addCriterion("pwidth is null");
            return (Criteria) this;
        }

        public Criteria andPwidthIsNotNull() {
            addCriterion("pwidth is not null");
            return (Criteria) this;
        }

        public Criteria andPwidthEqualTo(Integer value) {
            addCriterion("pwidth =", value, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthNotEqualTo(Integer value) {
            addCriterion("pwidth <>", value, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthGreaterThan(Integer value) {
            addCriterion("pwidth >", value, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthGreaterThanOrEqualTo(Integer value) {
            addCriterion("pwidth >=", value, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthLessThan(Integer value) {
            addCriterion("pwidth <", value, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthLessThanOrEqualTo(Integer value) {
            addCriterion("pwidth <=", value, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthIn(List<Integer> values) {
            addCriterion("pwidth in", values, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthNotIn(List<Integer> values) {
            addCriterion("pwidth not in", values, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthBetween(Integer value1, Integer value2) {
            addCriterion("pwidth between", value1, value2, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPwidthNotBetween(Integer value1, Integer value2) {
            addCriterion("pwidth not between", value1, value2, "pwidth");
            return (Criteria) this;
        }

        public Criteria andPheightIsNull() {
            addCriterion("pheight is null");
            return (Criteria) this;
        }

        public Criteria andPheightIsNotNull() {
            addCriterion("pheight is not null");
            return (Criteria) this;
        }

        public Criteria andPheightEqualTo(Integer value) {
            addCriterion("pheight =", value, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightNotEqualTo(Integer value) {
            addCriterion("pheight <>", value, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightGreaterThan(Integer value) {
            addCriterion("pheight >", value, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightGreaterThanOrEqualTo(Integer value) {
            addCriterion("pheight >=", value, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightLessThan(Integer value) {
            addCriterion("pheight <", value, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightLessThanOrEqualTo(Integer value) {
            addCriterion("pheight <=", value, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightIn(List<Integer> values) {
            addCriterion("pheight in", values, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightNotIn(List<Integer> values) {
            addCriterion("pheight not in", values, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightBetween(Integer value1, Integer value2) {
            addCriterion("pheight between", value1, value2, "pheight");
            return (Criteria) this;
        }

        public Criteria andPheightNotBetween(Integer value1, Integer value2) {
            addCriterion("pheight not between", value1, value2, "pheight");
            return (Criteria) this;
        }

        public Criteria andPsizeIsNull() {
            addCriterion("psize is null");
            return (Criteria) this;
        }

        public Criteria andPsizeIsNotNull() {
            addCriterion("psize is not null");
            return (Criteria) this;
        }

        public Criteria andPsizeEqualTo(Double value) {
            addCriterion("psize =", value, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeNotEqualTo(Double value) {
            addCriterion("psize <>", value, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeGreaterThan(Double value) {
            addCriterion("psize >", value, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeGreaterThanOrEqualTo(Double value) {
            addCriterion("psize >=", value, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeLessThan(Double value) {
            addCriterion("psize <", value, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeLessThanOrEqualTo(Double value) {
            addCriterion("psize <=", value, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeIn(List<Double> values) {
            addCriterion("psize in", values, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeNotIn(List<Double> values) {
            addCriterion("psize not in", values, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeBetween(Double value1, Double value2) {
            addCriterion("psize between", value1, value2, "psize");
            return (Criteria) this;
        }

        public Criteria andPsizeNotBetween(Double value1, Double value2) {
            addCriterion("psize not between", value1, value2, "psize");
            return (Criteria) this;
        }

        public Criteria andPlabelIsNull() {
            addCriterion("plabel is null");
            return (Criteria) this;
        }

        public Criteria andPlabelIsNotNull() {
            addCriterion("plabel is not null");
            return (Criteria) this;
        }

        public Criteria andPlabelEqualTo(String value) {
            addCriterion("plabel =", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelNotEqualTo(String value) {
            addCriterion("plabel <>", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelGreaterThan(String value) {
            addCriterion("plabel >", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelGreaterThanOrEqualTo(String value) {
            addCriterion("plabel >=", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelLessThan(String value) {
            addCriterion("plabel <", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelLessThanOrEqualTo(String value) {
            addCriterion("plabel <=", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelLike(String value) {
            addCriterion("plabel like", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelNotLike(String value) {
            addCriterion("plabel not like", value, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelIn(List<String> values) {
            addCriterion("plabel in", values, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelNotIn(List<String> values) {
            addCriterion("plabel not in", values, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelBetween(String value1, String value2) {
            addCriterion("plabel between", value1, value2, "plabel");
            return (Criteria) this;
        }

        public Criteria andPlabelNotBetween(String value1, String value2) {
            addCriterion("plabel not between", value1, value2, "plabel");
            return (Criteria) this;
        }
    }

    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}