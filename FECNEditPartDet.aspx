<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If not IsPostBack  Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
            lblFECNNo.text = ReqCOM.GetFieldVal("Select FECN_NO from FECN_M where SEQ_NO = " & Request.params("ID") & ";","FECN_NO")
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,VName as string,FName as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = VName
            .DataTextField = FName
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim RsPart as SqlDataReader = ReqCOM.ExeDataReader("Select Part_Spec,Part_Desc,M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
        do while RsPart.read
            lblPartDesc.text = trim(RsPart("Part_Desc").ToString)
            lblPartSpec.text = trim(RsPart("Part_Spec").ToString)
            lblMfgPartNo.text = trim(RsPart("M_Part_No").ToString)
            txtPartSpec.text = trim(RsPart("Part_Spec").ToString)
            txtMfgPartNo.text = trim(RsPart("M_Part_No").ToString)
        loop
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim StrSql as string
    
            StrSql = "Insert into FECN_D(FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,"
            StrSql = StrSql + "M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,"
            StrSql = StrSql + "part_desc,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,REASON_CHANGE,Imp_Type,TYPE_CHANGE) "
            StrSql = StrSql + "Select '" & trim(lblFECNNo.text) & "','" & trim(cmbPartNo.selectedItem.Value) & "','-','" & trim(lblPartDesc.text) & "','" & trim(lblPartSpec.text) & "',"
            StrSql = StrSql + "'" & lblMfgPartNo.text & "',0,'N/A','N/A','" & trim(lblPartNo.text) & "','N/A',"
            StrSql = StrSql + "'" & trim(lblPartDesc.text) & "','" & trim(txtPartSpec.text) & "','" & trim(txtMfgPartNo.text) & "',0,"
            StrSql = StrSql + "'N/A',"
            StrSql = StrSql + "'N/A','" & trim(replace(txtRem.text,"'","`")) & "','Immediate','Edit Part Details'"
            ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        response.redirect("FECNDet.aspx?ID=" & ReqCOM.GetFIeldVal("Select Seq_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc,MfgPartNo as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        Dissql ("Select Part_No from Part_Master where Part_No like '%" & trim(txtSearchPart.text) & "%';","Part_No","Part_No",cmbPartNo)
        if cmbPartNo.selectedindex = 0 then
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Desc")
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_Part_No")
            txtSearchPart.text = "-- Search --"
            lblPartNo.text = cmbpartno.selecteditem.value
            txtPartSpec.text = trim(lblPartSpec.text)
            txtMfgPartNo.text = trim(lblMfgPartNo.text)
        Elseif cmbPartNo.selectedindex <> 0 then
            lblPartDesc.text = ""
            lblPartSpec.text = ""
            lblMfgPartNo.text = ""
            txtSearchPart.text = "-- Search --"
            lblPartNo.text = ""
            txtPartSpec.text = ""
            txtMfgPartNo.text = ""
        End if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">FECN - EDIT
                                BOM MAIN PART</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No (before change)" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartNo" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part Specification." ForeColor=" " Display="Dynamic" ControlToValidate="txtPartSpec" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                              