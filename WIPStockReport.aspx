<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    End Sub

    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub

    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub



    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

    Sub cmdShowRpt1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim Location as string = trim(cmbLocation.selecteditem.value)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim DateFrom,DateTo as string

            DateFrom = format(cdate(clng(cmbMonthFrom.selecteditem.value) & "/" & clng(txtDayFrom.text) & "/" & clng(txtYearFrom.text)),"dd/MM/yy")
            DateTo = format(cdate(clng(cmbMonthTo.selecteditem.value) & "/" & clng(txtDayTo.text) & "/" & clng(txtYearTo.text)),"dd/MM/yy")

            ReqCOM.executenonquery("TRUNCATE TABLE wip_stock_bal")
            ReqCOM.executenonquery("insert into wip_stock_bal(PART_NO,TRANS_QTY,IN_QTY,OUT_QTY,WAC,REM,REf_No) select part_no,QTY_ISSUED,QTY_ISSUED,0,0,'ISSUING',ISSUING_NO FROM MAT_ISSUING_D WHERE ISSUING_NO IN (select ISSUING_NO from mat_issuing_m where p_level in (select LEVEL_CODE FROM P_level where pd_level = '" & trim(Location) & "'))")
            ReqCOM.executenonquery("UPDATE WIP_STOCK_BAL SET WIP_STOCK_BAL.JO_NO = MAT_ISSUING_M.JO_NO FROM WIP_STOCK_BAL,MAT_ISSUING_M WHERE WIP_STOCK_BAL.Ref_No = MAT_ISSUING_M.ISSUING_NO and WIP_STOCK_BAL.rem = 'ISSUING'")
            ReqCOM.executenonquery("UPDATE WIP_STOCK_BAL SET WIP_STOCK_BAL.TRANS_DATE = MAT_ISSUING_M.APP1_DATE FROM WIP_STOCK_BAL,MAT_ISSUING_M WHERE WIP_STOCK_BAL.REF_NO = MAT_ISSUING_M.ISSUING_NO and WIP_STOCK_BAL.rem = 'ISSUING'")
            ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.lot_no = job_order_m.lot_no from WIP_STOCK_BAL,job_order_m where WIP_STOCK_BAL.jo_no = job_order_m.jo_No and WIP_STOCK_BAL.rem = 'ISSUING'")

            ReqCOM.executenonquery("insert into wip_stock_bal(PART_NO,TRANS_QTY,IN_QTY,OUT_QTY,WAC,REM,REf_No,JO_No) select part_no,-QTY_RETURN,0,QTY_RETURN,0,'MRF',mrf_no,JO_NO FROM mrf_d WHERE mrf_no IN (select mrf_NO from mrf_m where mrf_status = 'APPROVED' and p_level in (select LEVEL_CODE FROM P_level where pd_level = '" & trim(Location) & "'))")
            ReqCOM.executenonquery("UPDATE WIP_STOCK_BAL SET WIP_STOCK_BAL.TRANS_DATE = mrf_m.APP1_DATE FROM WIP_STOCK_BAL,MRF_M WHERE WIP_STOCK_BAL.REF_NO = MRF_M.MRF_NO and WIP_STOCK_BAL.rem = 'MRF'")
            ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.lot_no = job_order_m.lot_no from WIP_STOCK_BAL,job_order_m where WIP_STOCK_BAL.jo_no = job_order_m.jo_No and WIP_STOCK_BAL.rem = 'MRF'")

            ReqCOM.executenonquery("insert into wip_stock_bal(PART_NO,TRANS_QTY,IN_QTY,OUT_QTY,WAC,REM,REf_No,JO_No) select part_no,QTY_REQ,QTY_REQ,0,0,'EXTRA REQ',mErf_no,JO_NO FROM merf_d WHERE merf_no IN (select merf_no from merf_m where MERF_STATUS = 'APPROVED' AND p_level in (select LEVEL_CODE FROM P_level where pd_level = '" & trim(Location) & "'))")
            ReqCOM.executenonquery("UPDATE WIP_STOCK_BAL SET WIP_STOCK_BAL.TRANS_DATE = merf_m.APP1_DATE FROM WIP_STOCK_BAL,MERF_M WHERE WIP_STOCK_BAL.REF_NO = MERF_M.MERF_NO and WIP_STOCK_BAL.rem = 'EXTRA REQ'")
            ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.lot_no = job_order_m.lot_no from WIP_STOCK_BAL,job_order_m where WIP_STOCK_BAL.jo_no = job_order_m.jo_No and WIP_STOCK_BAL.rem = 'EXTRA REQ'")

            ReqCOM.executenonquery("update wip_stock_bal set wip_stock_bal.wac = part_master.wac_cost from wip_stock_bal,part_master where wip_stock_bal.part_no = part_master.part_no")
            ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.model_no = so_models_m.model_no from WIP_STOCK_BAL,so_models_m where WIP_STOCK_BAL.lot_no = so_models_m.lot_no")
            ReqCOM.executenonquery("update WIP_STOCK_BAL set bal_amt = wac * trans_qty")

            ReqCOM.executenonquery("Delete from wip_stock_bal where part_no NOT between '" & trim(txtPartNoFrom.text) & "' and '" & trim(txtPartNoTo.text) & "'")

            if Location = "PD1" then ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.bbf = part_master.PD1_WIP_BAL from WIP_STOCK_BAL,part_master where WIP_STOCK_BAL.part_no = part_master.part_no")
            if Location = "PD2" then ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.bbf = part_master.PD2_WIP_BAL from WIP_STOCK_BAL,part_master where WIP_STOCK_BAL.part_no = part_master.part_no")
            if Location = "PD3" then ReqCOM.executenonquery("update WIP_STOCK_BAL set WIP_STOCK_BAL.bbf = part_master.PD3_WIP_BAL from WIP_STOCK_BAL,part_master where WIP_STOCK_BAL.part_no = part_master.part_no")

            if cmbRptType.selecteditem.value = "SUMMARY" then
                ShowReport("PopupReportViewer.aspx?RptName=WIPStockBalSummary&Location=" & Location & "&PartNoFrom=" & trim(txtPartNoFrom.text) & "&PartNoTo=" & trim(txtPartNoTo.text) & "&DateFrom=" & trim(DateFrom) & "&DateTo=" & trim(DateTo))
                redirectPage("WIPStockReport.aspx")
            elseif cmbRptType.selecteditem.value = "DETAILS" then
                ShowReport("PopupReportViewer.aspx?RptName=WIPLedger&Location=" & Location & "&PartNoFrom=" & trim(txtPartNoFrom.text) & "&PartNoTo=" & trim(txtPartNoTo.text) & "&DateFrom=" & trim(DateFrom) & "&DateTo=" & trim(DateTo))
                redirectPage("WIPStockReport.aspx")
            end if
        End if
    End Sub

    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub

    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim DateStr as string

        if trim(txtDayFrom.text) = "" then e.isvalid = false:Exit sub
        if trim(txtDayTo.text) = "" then e.isvalid = false:Exit sub

        if trim(txtYearFrom.text) = "" then e.isvalid = false:Exit sub
        if trim(txtYearTo.text) = "" then e.isvalid = false:Exit sub

        DateStr = clng(cmbMonthFrom.selecteditem.value) & "/" & clng(txtDayFrom.text) & "/" & clng(txtYearFrom.text)
        if isdate(DateStr) = false then e.isvalid = false:Exit sub




        DateStr = clng(cmbMonthTo.selecteditem.value) & "/" & clng(txtDayTo.text) & "/" & clng(txtYearTo.text)
        if isdate(DateStr) = false then e.isvalid = false:Exit sub

    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <div id="dek">
    </div>
    <script type="text/javascript">

    Xoffset=-60;
    Yoffset= 20;
    var old,skn,iex=(document.all),yyy=-1000;
    var ns4=document.layers
    var ns6=document.getElementById&&!document.all
    var ie4=document.all

    if (ns4)
        skn=document.dek
    else if (ns6)
        skn=document.getElementById("dek").style
    else if (ie4)
        skn=document.all.dek.style

    if(ns4)document.captureEvents(Event.MOUSEMOVE);
    else
    {
        skn.visibility="visible"
        skn.display="none"
    }
    document.onmousemove=get_mouse;

    function popup(msg,bak)
    {
        var content="<TABLE  WIDTH=150 BORDER=1 BORDERCOLOR=black CELLPADDING=2 CELLSPACING=0 "+
        "BGCOLOR="+bak+"><TD ALIGN=center><FONT COLOR=black SIZE=2>"+msg+"</FONT></TD></TABLE>";
        yyy=Yoffset;
        if(ns4){skn.document.write(content);skn.document.close();skn.visibility="visible"}
        if(ns6){document.getElementById("dek").innerHTML=content;skn.display=''}
        if(ie4){document.all("dek").innerHTML=content;skn.display=''}
    }

    function get_mouse(e)
    {
        var x=(ns4||ns6)?e.pageX:event.x+document.body.scrollLeft;
        skn.left=x+Xoffset;
        var y=(ns4||ns6)?e.pageY:event.y+document.body.scrollTop;
        skn.top=y+yyy;
    }

    function kill()
    {
        yyy=-1000;
        if(ns4){skn.visibility="hidden";}
        else if (ns6||ie4)
        skn.display="none"
    }
</script>
    <form runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">WIP
                                STOCK REPORT</asp:Label>&nbsp;
                                <table style="HEIGHT: 19px" width="50%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="ValDateInput" runat="server" CssClass="ErrorText" Width="100%" EnableClientScript="False" OnServerValidate="ValDateInput_ServerValidate" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid date range"></asp:CustomValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Part From." ControlToValidate="txtPartNoFrom"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Part To." ControlToValidate="txtPartNoTo"></asp:RequiredFieldValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Section</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbLocation" runat="server" CssClass="OutputText" Width="197px">
                                                                    <asp:ListItem Value="PD1">PD 1</asp:ListItem>
                                                                    <asp:ListItem Value="PD2">PD 2</asp:ListItem>
                                                                    <asp:ListItem Value="PD3">PD 3</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr width="70%">
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Date From (D/M/Y)</asp:Label></td>
                                                            <td class="OutputText">
                                                                <asp:TextBox id="txtDayFrom" runat="server" CssClass="OutputText" Width="41px"></asp:TextBox>
                                                                &nbsp;/
                                                                <asp:DropDownList id="cmbMonthFrom" runat="server" CssClass="OutputText" Width="99px">
                                                                    <asp:ListItem Value="1">JANUARY</asp:ListItem>
                                                                    <asp:ListItem Value="2">FEBRUARY</asp:ListItem>
                                                                    <asp:ListItem Value="3">MARCH</asp:ListItem>
                                                                    <asp:ListItem Value="4">APRIL</asp:ListItem>
                                                                    <asp:ListItem Value="5">MAY</asp:ListItem>
                                                                    <asp:ListItem Value="6">JUNE</asp:ListItem>
                                                                    <asp:ListItem Value="7">JULY</asp:ListItem>
                                                                    <asp:ListItem Value="8">AUGUST</asp:ListItem>
                                                                    <asp:ListItem Value="9">SEPTEMBER</asp:ListItem>
                                                                    <asp:ListItem Value="10">ACTOBER</asp:ListItem>
                                                                    <asp:ListItem Value="11">NOVEMBER</asp:ListItem>
                                                                    <asp:ListItem Value="12">DECEMBER</asp:ListItem>
                                                                </asp:DropDownList>
                                                                &nbsp;/
                                                                <asp:TextBox id="txtYearFrom" runat="server" CssClass="OutputText" Width="54px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Date To (D/M/Y)</asp:Label></td>
                                                            <td class="outputText">
                                                                <asp:TextBox id="txtDayTo" runat="server" CssClass="OutputText" Width="41px"></asp:TextBox>
                                                                &nbsp;/
                                                                <asp:DropDownList id="cmbMonthTo" runat="server" CssClass="OutputText" Width="99px">
                                                                    <asp:ListItem Value="1">JANUARY</asp:ListItem>
                                                                    <asp:ListItem Value="2">FEBRUARY</asp:ListItem>
                                                                    <asp:ListItem Value="3">MARCH</asp:ListItem>
                                                                    <asp:ListItem Value="4">APRIL</asp:ListItem>
                                                                    <asp:ListItem Value="5">MAY</asp:ListItem>
                                                                    <asp:ListItem Value="6">JUNE</asp:ListItem>
                                                                    <asp:ListItem Value="7">JULY</asp:ListItem>
                                                                    <asp:ListItem Value="8">AUGUST</asp:ListItem>
                                                                    <asp:ListItem Value="9">SEPTEMBER</asp:ListItem>
                                                                    <asp:ListItem Value="10">ACTOBER</asp:ListItem>
                                                                    <asp:ListItem Value="11">NOVEMBER</asp:ListItem>
                                                                    <asp:ListItem Value="12">DECEMBER</asp:ListItem>
                                                                </asp:DropDownList>
                                                                &nbsp;/
                                                                <asp:TextBox id="txtYearTo" runat="server" CssClass="OutputText" Width="54px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Part No From</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPartNoFrom" runat="server" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Part No To</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPartNoTo" runat="server" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Report Type</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbRptType" runat="server" CssClass="OutputText" Width="197px">
                                                                    <asp:ListItem Value="SUMMARY">SUMMARY</asp:ListItem>
                                                                    <asp:ListItem Value="DETAILS">DETAILS</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="center">
                                                                    <asp:Button id="cmdShowRpt1" onclick="cmdShowRpt1_Click" runat="server" Width="123px" Text="Show Report"></asp:Button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
