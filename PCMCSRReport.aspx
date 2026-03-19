<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            txtSRDateFrom.text = format(cdate(now),"dd/MM/yy")
            txtSRDateTo.text = format(cdate(now),"dd/MM/yy")
        End if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim srDateFrom,SRDateTo as date
            Dim CMonth,CDay,CYear as integer
            Dim CDt as string
    
            CDt = txtSRDateFrom.text
            Cmonth = CDt.substring(3,2)
            CDay = CDt.substring(0,2)
            CYear = CDt.substring(6,2)
            srDateFrom = CMonth & "/" & Cday & "/" & CYear
    
            CDt = txtSRDateTo.text
            Cmonth = CDt.substring(3,2)
            CDay = CDt.substring(0,2)
            CYear = CDt.substring(6,2)
            SRDateTo = CMonth & "/" & Cday & "/" & CYear
    
    
            ShowReport("PopupReportViewer.aspx?RptName=PCMCSRRpt&PartNoFrom=" & trim(txtPartNoFrom.text) & "&PartNoTo=" & trim(txtPartNoTo.text) & "&SRDateFrom=" & cdate(SRDateFrom) & "&SRDateTo=" & cdate(SRDateTo))
        end if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = trim(FValue)
            .DataTextField = trim(FText)
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ValDuplicateDate(sender As Object, e As ServerValidateEventArgs)
        Dim CMonth,CDay,CYear as integer
        Dim CDt as string
        Dim ReschProdDate As Textbox
        Dim i as integer
    
        if len(txtSRDateFrom.text) <> 8 then CustomValidator1.text = "You don't seem to have supplied a valid SR Date From" : e.isvalid = false :Exit sub
        if len(txtSRDateTo.text) <> 8 then CustomValidator1.text = "You don't seem to have supplied a valid SR Date To" : e.isvalid = false :Exit sub
    
        CDt = txtSRDateFrom.text
    
        if isnumeric(CDt.substring(3,2)) = true then
            Cmonth = CDt.substring(3,2)
        else
            CustomValidator1.text = "You don't seem to have supplied a valid SR Date From" : e.isvalid = false :Exit sub
        end if
    
        if isnumeric(CDt.substring(0,2)) = true then
            CDay = CDt.substring(0,2)
        else
            CustomValidator1.text = "You don't seem to have supplied a valid SR Date From" : e.isvalid = false :Exit sub
        end if
    
        if isnumeric(CDt.substring(6,2)) = true then
            CYear = CDt.substring(6,2)
        else
            CustomValidator1.text = "You don't seem to have supplied a valid SR Date From" : e.isvalid = false :Exit sub
        end if
    
        Cdt = CMonth & "/" & Cday & "/" & CYear
        if isdate(cdt) = false then CustomValidator1.text = "You don't seem to have supplied a valid SR Date From" : e.isvalid = false :Exit sub
    
        CDt = txtSRDateTo.text
    
        if isnumeric(CDt.substring(3,2)) = true then
            Cmonth = CDt.substring(3,2)
        else
            CustomValidator1.text = "You don't seem to have supplied a valid SR Date To" : e.isvalid = false :Exit sub
        end if
    
        if isnumeric(CDt.substring(0,2)) = true then
            CDay = CDt.substring(0,2)
        else
            CustomValidator1.text = "You don't seem to have supplied a valid SR Date To" : e.isvalid = false :Exit sub
        end if
    
        if isnumeric(CDt.substring(6,2)) = true then
            CYear = CDt.substring(6,2)
        else
            CustomValidator1.text = "You don't seem to have supplied a valid SR Date To" : e.isvalid = false :Exit sub
        end if
    
        Cdt = CMonth & "/" & Cday & "/" & CYear
        if isdate(cdt) = false then CustomValidator1.text = "You don't seem to have supplied a valid SR Date To" : e.isvalid = false :Exit sub
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <font color="red"><strong>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </strong></font></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">PCMC
                                SPECIAL REQUEST REPORT</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="CustomValidator1" runat="server" Display="Dynamic" OnServerValidate="ValDuplicateDate" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Part No From." ControlToValidate="txtPartNoFrom"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Part No To" ControlToValidate="txtPartNoTo"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid SR Date From" ControlToValidate="txtSRDateFrom"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid SR Date To" ControlToValidate="txtSRDateTo"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="159px">Part No
                                                                        From / To</asp:Label>&nbsp; 
                                                                        <asp:TextBox id="txtPartNoFrom" runat="server" Width="151px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp;/ &nbsp;<asp:TextBox id="txtPartNoTo" runat="server" Width="151px" CssClass="OutputText"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="159px">SR Date
                                                                        From / To</asp:Label>&nbsp; 
                                                                        <asp:TextBox id="txtSRDateFrom" runat="server" Width="151px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp;/ &nbsp;<asp:TextBox id="txtSRDateTo" runat="server" Width="151px" CssClass="OutputText"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="85px" Text="View Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="97px" Text="Back"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
    </form>
</body>
</html>
