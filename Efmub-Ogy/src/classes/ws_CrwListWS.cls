/*******************************************************//**

@class      SOA_CrwListWS

@brief      Web Service - Crew List

    This implements the Crew List Web Service.
    This code was generated from an edited version of the WSDL,
    CrwListWS.wsdl

@author     Glyn Anderson   (LiquidHub.GHA)

@version    2016-01-08  LiquidHub.GHA
    Created.
@version    2016-05-03  LiquidHub.GHA
    Fixed up return value checks.

@see        SOA_CrwListWSTest

    (c)2016 Delta Air Lines, Inc.  All Rights Reserved.  Unauthorized use is prohibited.

    This is a component of Phoenix, Delta's Case Management App for Salesforce.

***********************************************************/

//Generated by wsdl2apex

public class SOA_CrwListWS {
    /*******************************************************
                    getCrwByFltResponse class

    This was modified to extend CWObject.
    *******************************************************/
    public class getCrwByFltResponse extends CWObject {
        public crwListByFltRspn return_x;
        private String[] return_x_type_info = new String[]{'return_x','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','crwListByFltRspn'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class crwListByRotnReq {
        public String bsCd;
        public String mbrTypCd;
        public String rotnBegDt;
        public String rotnDupNb;
        public String rotnNb;
        private String[] bsCd_type_info = new String[]{'bsCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrTypCd_type_info = new String[]{'mbrTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnBegDt_type_info = new String[]{'rotnBegDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnDupNb_type_info = new String[]{'rotnDupNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnNb_type_info = new String[]{'rotnNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'bsCd','mbrTypCd','rotnBegDt','rotnDupNb','rotnNb'};
    }
    /*******************************************************
                    getCrwByRotnResponse class

    This was modified to extend CWObject.
    *******************************************************/
    public class getCrwByRotnResponse extends CWObject {
        public crwListByRotnRspn return_x;
        private String[] return_x_type_info = new String[]{'return_x','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','crwListByRotnRspn'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class crwListByFltReq {
        public String crrCd;
        public String destArptCd;
        public String fltDt;
        public String fltNb;
        public String origArptCd;
        private String[] crrCd_type_info = new String[]{'crrCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] destArptCd_type_info = new String[]{'destArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDt_type_info = new String[]{'fltDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltNb_type_info = new String[]{'fltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] origArptCd_type_info = new String[]{'origArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'crrCd','destArptCd','fltDt','fltNb','origArptCd'};
    }
    public class crwFltVo {
        public String bsCd;
        public String crrnLgTypCd;
        public String ddhdSttCd;
        public String eqpTypCd;
        public String fltCrrCd;
        public String fltDestArptCd;
        public String fltDt;
        public String fltNb;
        public String fltOrigArptCd;
        public ibFltVo ibFlt;
        public String mbrCtrt;
        public String mbrIdNb;
        public String mbrNm;
        public String mbrNwaIdNb;
        public String mbrPsptNm;
        public String mbrTypCd;
        public Boolean originating;
        public prtCrwVo prtCrw;
        public String pstnCd;
        public String rotnBegDt;
        public String rotnDupNb;
        public String rotnNb;
        public String rotnPstnCd;
        public String turnTm;
        private String[] bsCd_type_info = new String[]{'bsCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] crrnLgTypCd_type_info = new String[]{'crrnLgTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] ddhdSttCd_type_info = new String[]{'ddhdSttCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] eqpTypCd_type_info = new String[]{'eqpTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltCrrCd_type_info = new String[]{'fltCrrCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDestArptCd_type_info = new String[]{'fltDestArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDt_type_info = new String[]{'fltDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltNb_type_info = new String[]{'fltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltOrigArptCd_type_info = new String[]{'fltOrigArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] ibFlt_type_info = new String[]{'ibFlt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','ibFltVo'};
        private String[] mbrCtrt_type_info = new String[]{'mbrCtrt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrIdNb_type_info = new String[]{'mbrIdNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrNm_type_info = new String[]{'mbrNm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrNwaIdNb_type_info = new String[]{'mbrNwaIdNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrPsptNm_type_info = new String[]{'mbrPsptNm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrTypCd_type_info = new String[]{'mbrTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] originating_type_info = new String[]{'originating','http://fcm.delta.com/fcm/crwlist',null,'1','1','false','Boolean'};
        private String[] prtCrw_type_info = new String[]{'prtCrw','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','prtCrwVo'};
        private String[] pstnCd_type_info = new String[]{'pstnCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnBegDt_type_info = new String[]{'rotnBegDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnDupNb_type_info = new String[]{'rotnDupNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnNb_type_info = new String[]{'rotnNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnPstnCd_type_info = new String[]{'rotnPstnCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] turnTm_type_info = new String[]{'turnTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'bsCd','crrnLgTypCd','ddhdSttCd','eqpTypCd','fltCrrCd','fltDestArptCd','fltDt','fltNb','fltOrigArptCd','ibFlt','mbrCtrt','mbrIdNb','mbrNm','mbrNwaIdNb','mbrPsptNm','mbrTypCd','originating','prtCrw','pstnCd','rotnBegDt','rotnDupNb','rotnNb','rotnPstnCd','turnTm'};
    }
    /*******************************************************
                    crwListByFltRspn class

    This was modified to extend CWObject.
    *******************************************************/
    public class crwListByFltRspn extends CWObject {
        public String erMg;
        public fltVo flt;
        public String stt;
        private String[] erMg_type_info = new String[]{'erMg','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] flt_type_info = new String[]{'flt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','fltVo'};
        private String[] stt_type_info = new String[]{'stt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'erMg','flt','stt'};
    }
    public class rotnVo {
        public String bsCd;
        public crwRotnVo[] crw;
        public String mbrTypCd;
        public String rotnBegDt;
        public String rotnDupNb;
        public String rotnNb;
        private String[] bsCd_type_info = new String[]{'bsCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] crw_type_info = new String[]{'crw','http://fcm.delta.com/fcm/crwlist',null,'0','-1','true','crwRotnVo'};
        private String[] mbrTypCd_type_info = new String[]{'mbrTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnBegDt_type_info = new String[]{'rotnBegDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnDupNb_type_info = new String[]{'rotnDupNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnNb_type_info = new String[]{'rotnNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'bsCd','crw','mbrTypCd','rotnBegDt','rotnDupNb','rotnNb'};
    }
    public class prtCrwVo {
        public String ddhdSttCd;
        public String ibFltArrDtTm;
        public String ibFltNb;
        public String mbrCtrt;
        public String mbrIdNb;
        public String mbrNm;
        public String mbrNwaIdNb;
        public String mbrPsptNm;
        public String pstnCd;
        private String[] ddhdSttCd_type_info = new String[]{'ddhdSttCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] ibFltArrDtTm_type_info = new String[]{'ibFltArrDtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] ibFltNb_type_info = new String[]{'ibFltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrCtrt_type_info = new String[]{'mbrCtrt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrIdNb_type_info = new String[]{'mbrIdNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrNm_type_info = new String[]{'mbrNm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrNwaIdNb_type_info = new String[]{'mbrNwaIdNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrPsptNm_type_info = new String[]{'mbrPsptNm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] pstnCd_type_info = new String[]{'pstnCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'ddhdSttCd','ibFltArrDtTm','ibFltNb','mbrCtrt','mbrIdNb','mbrNm','mbrNwaIdNb','mbrPsptNm','pstnCd'};
    }
    public class fltVo {
        public String crrCd;
        public crwFltVo[] crw;
        public String destArptCd;
        public String eqpTypCd;
        public String fltArrDt;
        public String fltArrTm;
        public String fltDprtDt;
        public String fltDprtTm;
        public String fltDt;
        public String fltIntlCd;
        public String fltNb;
        public String fltOrigDt;
        public String fltSchdArrDt;
        public String fltSchdArrTm;
        public String fltSchdDprtDt;
        public String fltSchdDprtTm;
        public String fltSchdDprtUtcDt;
        public String incnlFaCt;
        public Boolean isShowPsptNm;
        public Boolean lckd;
        public String minFaRqdCt;
        public String origArptCd;
        public prtFltVo prtFlt;
        public String rqdBrdgTm;
        public String shipNb;
        public String turnTm;
        public String wkgFaCt;
        private String[] crrCd_type_info = new String[]{'crrCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] crw_type_info = new String[]{'crw','http://fcm.delta.com/fcm/crwlist',null,'0','-1','true','crwFltVo'};
        private String[] destArptCd_type_info = new String[]{'destArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] eqpTypCd_type_info = new String[]{'eqpTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrDt_type_info = new String[]{'fltArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrTm_type_info = new String[]{'fltArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDprtDt_type_info = new String[]{'fltDprtDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDprtTm_type_info = new String[]{'fltDprtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDt_type_info = new String[]{'fltDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltIntlCd_type_info = new String[]{'fltIntlCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltNb_type_info = new String[]{'fltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltOrigDt_type_info = new String[]{'fltOrigDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdArrDt_type_info = new String[]{'fltSchdArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdArrTm_type_info = new String[]{'fltSchdArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtDt_type_info = new String[]{'fltSchdDprtDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtTm_type_info = new String[]{'fltSchdDprtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtUtcDt_type_info = new String[]{'fltSchdDprtUtcDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] incnlFaCt_type_info = new String[]{'incnlFaCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] isShowPsptNm_type_info = new String[]{'isShowPsptNm','http://fcm.delta.com/fcm/crwlist',null,'1','1','false','Boolean'};
        private String[] lckd_type_info = new String[]{'lckd','http://fcm.delta.com/fcm/crwlist',null,'1','1','false','Boolean'};
        private String[] minFaRqdCt_type_info = new String[]{'minFaRqdCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] origArptCd_type_info = new String[]{'origArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] prtFlt_type_info = new String[]{'prtFlt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','prtFltVo'};
        private String[] rqdBrdgTm_type_info = new String[]{'rqdBrdgTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] shipNb_type_info = new String[]{'shipNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] turnTm_type_info = new String[]{'turnTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] wkgFaCt_type_info = new String[]{'wkgFaCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'crrCd','crw','destArptCd','eqpTypCd','fltArrDt','fltArrTm','fltDprtDt','fltDprtTm','fltDt','fltIntlCd','fltNb','fltOrigDt','fltSchdArrDt','fltSchdArrTm','fltSchdDprtDt','fltSchdDprtTm','fltSchdDprtUtcDt','incnlFaCt','isShowPsptNm','lckd','minFaRqdCt','origArptCd','prtFlt','rqdBrdgTm','shipNb','turnTm','wkgFaCt'};
    }
    public class ibFltVo {
        public String fltArrDt;
        public String fltArrTm;
        public String fltDestArptCd;
        public String fltDprtDt;
        public String fltDprtTm;
        public String fltDt;
        public String fltNb;
        public String fltOrigArptCd;
        public String fltSchdArrDt;
        public String fltSchdArrTm;
        public String fltSchdDprtDt;
        public String fltSchdDprtTm;
        public String fltTm;
        private String[] fltArrDt_type_info = new String[]{'fltArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrTm_type_info = new String[]{'fltArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDestArptCd_type_info = new String[]{'fltDestArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDprtDt_type_info = new String[]{'fltDprtDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDprtTm_type_info = new String[]{'fltDprtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDt_type_info = new String[]{'fltDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltNb_type_info = new String[]{'fltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltOrigArptCd_type_info = new String[]{'fltOrigArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdArrDt_type_info = new String[]{'fltSchdArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdArrTm_type_info = new String[]{'fltSchdArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtDt_type_info = new String[]{'fltSchdDprtDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtTm_type_info = new String[]{'fltSchdDprtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltTm_type_info = new String[]{'fltTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'fltArrDt','fltArrTm','fltDestArptCd','fltDprtDt','fltDprtTm','fltDt','fltNb','fltOrigArptCd','fltSchdArrDt','fltSchdArrTm','fltSchdDprtDt','fltSchdDprtTm','fltTm'};
    }
    /*******************************************************
                    crwListByRotnRspn class

    This was modified to extend CWObject.
    *******************************************************/
    public class crwListByRotnRspn extends CWObject {
        public String erMg;
        public rotnVo rotn;
        public String stt;
        private String[] erMg_type_info = new String[]{'erMg','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotn_type_info = new String[]{'rotn','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','rotnVo'};
        private String[] stt_type_info = new String[]{'stt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'erMg','rotn','stt'};
    }
    public class crwRotnVo {
        public String bsCd;
        public String ddhdSttCd;
        public String dutyPrdId;
        public String dutyRlsGdt;
        public String dutyRlsGtm;
        public String dutyRptGdt;
        public String dutyRptGtm;
        public String dutyTotMntCt;
        public String fltArrDt;
        public String fltArrTm;
        public String fltCrrCd;
        public String fltDestArptCd;
        public String fltDt;
        public String fltNb;
        public String fltOrigArptCd;
        public String fltSqNb;
        public String fltTm;
        public String mbrIdNb;
        public String mbrNm;
        public String mbrTypCd;
        public String pstnCd;
        public String rotnBegDt;
        public String rotnDupNb;
        public String rotnNb;
        public String rotnPstnCd;
        private String[] bsCd_type_info = new String[]{'bsCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] ddhdSttCd_type_info = new String[]{'ddhdSttCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] dutyPrdId_type_info = new String[]{'dutyPrdId','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] dutyRlsGdt_type_info = new String[]{'dutyRlsGdt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] dutyRlsGtm_type_info = new String[]{'dutyRlsGtm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] dutyRptGdt_type_info = new String[]{'dutyRptGdt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] dutyRptGtm_type_info = new String[]{'dutyRptGtm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] dutyTotMntCt_type_info = new String[]{'dutyTotMntCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrDt_type_info = new String[]{'fltArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrTm_type_info = new String[]{'fltArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltCrrCd_type_info = new String[]{'fltCrrCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDestArptCd_type_info = new String[]{'fltDestArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDt_type_info = new String[]{'fltDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltNb_type_info = new String[]{'fltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltOrigArptCd_type_info = new String[]{'fltOrigArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSqNb_type_info = new String[]{'fltSqNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltTm_type_info = new String[]{'fltTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrIdNb_type_info = new String[]{'mbrIdNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrNm_type_info = new String[]{'mbrNm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] mbrTypCd_type_info = new String[]{'mbrTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] pstnCd_type_info = new String[]{'pstnCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnBegDt_type_info = new String[]{'rotnBegDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnDupNb_type_info = new String[]{'rotnDupNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnNb_type_info = new String[]{'rotnNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rotnPstnCd_type_info = new String[]{'rotnPstnCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'bsCd','ddhdSttCd','dutyPrdId','dutyRlsGdt','dutyRlsGtm','dutyRptGdt','dutyRptGtm','dutyTotMntCt','fltArrDt','fltArrTm','fltCrrCd','fltDestArptCd','fltDt','fltNb','fltOrigArptCd','fltSqNb','fltTm','mbrIdNb','mbrNm','mbrTypCd','pstnCd','rotnBegDt','rotnDupNb','rotnNb','rotnPstnCd'};
    }
    public class getCrwByFlt {
        public crwListByFltReq arg0;
        private String[] arg0_type_info = new String[]{'arg0','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','crwListByFltReq'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'arg0'};
    }
    public class prtFltVo {
        public String crrCd;
        public String destArptCd;
        public String eqpTypCd;
        public String fltArrDt;
        public String fltArrTm;
        public String fltDprtDt;
        public String fltDprtTm;
        public String fltDt;
        public String fltNb;
        public String fltSchdArrDt;
        public String fltSchdArrTm;
        public String fltSchdDprtDt;
        public String fltSchdDprtTm;
        public String incnlFaCt;
        public String minFaRqdCt;
        public String origArptCd;
        public String prtStrng;
        public String prtrAdr;
        public String rqdBrdgTm;
        public String shipNb;
        public String wkgFaCt;
        private String[] crrCd_type_info = new String[]{'crrCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] destArptCd_type_info = new String[]{'destArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] eqpTypCd_type_info = new String[]{'eqpTypCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrDt_type_info = new String[]{'fltArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltArrTm_type_info = new String[]{'fltArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDprtDt_type_info = new String[]{'fltDprtDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDprtTm_type_info = new String[]{'fltDprtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltDt_type_info = new String[]{'fltDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltNb_type_info = new String[]{'fltNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdArrDt_type_info = new String[]{'fltSchdArrDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdArrTm_type_info = new String[]{'fltSchdArrTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtDt_type_info = new String[]{'fltSchdDprtDt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] fltSchdDprtTm_type_info = new String[]{'fltSchdDprtTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] incnlFaCt_type_info = new String[]{'incnlFaCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] minFaRqdCt_type_info = new String[]{'minFaRqdCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] origArptCd_type_info = new String[]{'origArptCd','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] prtStrng_type_info = new String[]{'prtStrng','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] prtrAdr_type_info = new String[]{'prtrAdr','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] rqdBrdgTm_type_info = new String[]{'rqdBrdgTm','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] shipNb_type_info = new String[]{'shipNb','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] wkgFaCt_type_info = new String[]{'wkgFaCt','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','String'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'crrCd','destArptCd','eqpTypCd','fltArrDt','fltArrTm','fltDprtDt','fltDprtTm','fltDt','fltNb','fltSchdArrDt','fltSchdArrTm','fltSchdDprtDt','fltSchdDprtTm','incnlFaCt','minFaRqdCt','origArptCd','prtStrng','prtrAdr','rqdBrdgTm','shipNb','wkgFaCt'};
    }
    public class getCrwByRotn {
        public crwListByRotnReq arg0;
        private String[] arg0_type_info = new String[]{'arg0','http://fcm.delta.com/fcm/crwlist',null,'0','1','false','crwListByRotnReq'};
        private String[] apex_schema_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist','false','false'};
        private String[] field_order_type_info = new String[]{'arg0'};
    }
    public class CrwListServicePort {
        public String endpoint_x;   // 'http://localhost:9080/css/crwlist/CrwListWS';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://fcm.delta.com/fcm/crwlist', 'SOA_CrwListWS'};
        /***************************************************
                    CrwListServicePort constructor

        This was created to initialize the endpoint to SI or
        production based on the User's "SOA Environment" in the
        CWCoreConfiguration custom setting.
        ***************************************************/
        public CrwListServicePort()
        {
            endpoint_x          = ((String) CWCoreConfiguration.get( 'SOA_Endpoint__c', 'https://ws-si.delta.com/eProxy/' )) + 'crewlist';
            clientCertName_x    = (String) CWCoreConfiguration.get( 'SOA_Certificate__c', 'soa_services_si' );
        }
        /***************************************************
                        getCrwByRotn method

        This was modified to call CWSoap.invoke.
        ***************************************************/
        public crwListByRotnRspn getCrwByRotn(crwListByRotnReq arg0) {
            getCrwByRotn request_x = new getCrwByRotn();
            request_x.arg0 = arg0;
            getCrwByRotnResponse response_x;
            Map<String, getCrwByRotnResponse> response_map_x = new Map<String, getCrwByRotnResponse>();
            response_map_x.put('response_x', response_x);
/*
            WebServiceCallout.invoke(
/*/
            CWSoap.invoke(
//*/
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'getCrwByRotn',
              'http://fcm.delta.com/fcm/crwlist',
              'getCrwByRotn',
              'http://fcm.delta.com/fcm/crwlist',
              'getCrwByRotnResponse',
              'SOA_CrwListWS.getCrwByRotnResponse'},
              false
            );
            response_x = response_map_x.get('response_x');
            if ( CWSoap.isSuccessfulResponse( response_x ) ) return response_x.return_x;
            SOA_CrwListWS.crwListByRotnRspn   errorResponse   = new SOA_CrwListWS.crwListByRotnRspn();
            errorResponse.getMembers().putAll( response_x.getMembers() );
            return errorResponse;
        }
        /***************************************************
                        getCrwByFlt method

        This was modified to call CWSoap.invoke.
        ***************************************************/
        public crwListByFltRspn getCrwByFlt(crwListByFltReq arg0) {
            getCrwByFlt request_x = new getCrwByFlt();
            request_x.arg0 = arg0;
            getCrwByFltResponse response_x;
            Map<String, getCrwByFltResponse> response_map_x = new Map<String, getCrwByFltResponse>();
            response_map_x.put('response_x', response_x);
/*
            WebServiceCallout.invoke(
/*/
            CWSoap.invoke(
//*/
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'getCrwByFlt',
              'http://fcm.delta.com/fcm/crwlist',
              'getCrwByFlt',
              'http://fcm.delta.com/fcm/crwlist',
              'getCrwByFltResponse',
              'SOA_CrwListWS.getCrwByFltResponse'},
              false
            );
            response_x = response_map_x.get('response_x');
            if ( CWSoap.isSuccessfulResponse( response_x ) ) return response_x.return_x;
            SOA_CrwListWS.crwListByFltRspn   errorResponse   = new SOA_CrwListWS.crwListByFltRspn();
            errorResponse.getMembers().putAll( response_x.getMembers() );
            return errorResponse;
        }
    }
}