<%@ Page Language="VB" %>
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
        rbByPart.Attributes.Add("onclick", "checkedChange();")
        rbByDate.Attributes.Add("onclick", "checkedChange();")
        rbByMfg.Attributes.Add("onclick", "checkedChange();")
        rbByModel.Attributes.Add("onclick", "checkedChange();")
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim BOMRev as decimal
    
        If page.isvalid = true then
            if rbByDate.checked = true then
                Dim StartDate,EndDate as string
                StartDate = ReqCOM.FormatDate(txtDateFrom.text) & " 00:00:00.000"
                EndDate = ReqCOM.FormatDate(txtDateTo.text) & " 23:59:59.000"
    
                ReqCOM.executeNonQuery("Update Part_Master set pending_status=null")
                ReqCOM.executeNonQuery("update part_master set ind = 'N'")
                ReqCOM.executeNonQuery("update part_master set ind = 'Y' where conditional_app = -1 and Create_Date between '" & cdate(StartDate) & "' and '" & cdate(EndDate) & "';")
                ReqCOM.ExecuteNonQuery("UPDATE PART_MASTER SET PENDING_STATUS = 'PENDING APPROVAL' WHERE IND = 'Y' AND PART_NO IN (SELECT DISTINCT(PART_NO) FROM SSER_M WHERE sser_stat = 'PENDING APPROVAL')")
                ReqCOM.ExecuteNonQuery("update part_master set pending_status = 'PENDING SUBMISSION' WHERE IND = 'Y' AND pending_status IS NULL")
                ShowReport("ReportViewer.aspx?RptName=PartsPendingSSER&ReturnURL=Default.aspx")
                redirectPage("PartsPendingApproval.aspx")
            elseif rbByPart.checked = true then
                ReqCOM.executeNonQuery("Update Part_Master set pending_status=null")
                ReqCOM.executeNonQuery("update part_master set ind = 'N'")
                ReqCOM.executeNonQuery("update part_master set ind = 'Y' where create_date > '05/15/06' and conditional_app = -1 and Part_No between '" & trim(txtPartFrom.text) & "' and '" & trim(txtPartTo.text) & "';")
                ReqCOM.ExecuteNonQuery("UPDATE PART_MASTER SET PENDING_STATUS = 'PENDING APPROVAL' WHERE IND = 'Y' AND PART_NO IN (SELECT DISTINCT(PART_NO) FROM SSER_M WHERE sser_stat = 'PENDING APPROVAL')")
                ReqCOM.ExecuteNonQuery("update part_master set pending_status = 'PENDING SUBMISSION' WHERE IND = 'Y' AND pending_status IS NULL")
                ShowReport("ReportViewer.aspx?RptName=PartsPendingSSER&ReturnURL=Default.aspx")
                redirectPage("PartsPendingApproval.aspx")
            elseif rbByMFG.checked = true then
                ReqCOM.executeNonQuery("Update Part_Master set pending_status=null")
                ReqCOM.executeNonQuery("Update part_master set ind = 'N'")
                ReqCOM.executeNonQuery("Update part_master set ind = 'Y' where create_date > '05/15/06' and conditional_app = -1 and mfg + M_Part_No like '%" & trim(txtMFG.text) & "%';")
                ReqCOM.ExecuteNonQuery("UPDATE PART_MASTER SET PENDING_STATUS = 'PENDING APPROVAL' WHERE IND = 'Y' AND PART_NO IN (SELECT DISTINCT(PART_NO) FROM SSER_M WHERE sser_stat = 'PENDING APPROVAL')")
                ReqCOM.ExecuteNonQuery("Update part_master set pending_status = 'PENDING SUBMISSION' WHERE IND = 'Y' AND pending_status IS NULL")
                ShowReport("ReportViewer.aspx?RptName=PartsPendingSSER&ReturnURL=Default.aspx")
                redirectPage("PartsPendingApproval.aspx")
            elseif rbByModel.checked = true then
                if ReqCOM.FuncCheckDuplicate("Select top 1 revision from bom_m where model_no = '" & trim(txtModel.text) & "' order by revision desc;","Revision") = true then
                    ReqCOM.executeNonQuery("Update Part_Master set pending_status=null")
                    ReqCOM.executeNonQuery("Update part_master set ind = 'N'")
                    BomRev = ReqCOM.GetFieldVal("Select top 1 revision from bom_m where model_no = '" & trim(txtModel.text) & "' order by revision desc;","Revision")
                    ReqCOM.executeNonQuery("Update part_master set ind = 'Y' where create_date > '05/15/06' and conditional_app = -1 and Part_no in (select distinct(part_no) from bom_d where model_no = '" & trim(txtModel.text) & "' and revision = " & cdec(BOMRev) & ")")
                    ReqCOM.ExecuteNonQuery("UPDATE PART_MASTER SET PENDING_STATUS = 'PENDING APPROVAL' WHERE IND = 'Y' AND PART_NO IN (SELECT DISTINCT(PART_NO) FROM SSER_M WHERE sser_stat = 'PENDING APPROVAL')")
                    ReqCOM.ExecuteNonQuery("Update part_master set pending_status = 'PENDING SUBMISSION' WHERE IND = 'Y' AND pending_status IS NULL")
                    ShowReport("ReportViewer.aspx?RptName=PartsPendingSSER&ReturnURL=Default.aspx")
                    redirectPage("PartsPendingApproval.aspx")
                else
                    'Show message
                end if
            end if
        End if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = true
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if rbByDate.checked = true then
            if Reqcom.Isdate(txtDateFrom.text) = false then e.isvalid = false
            if Reqcom.Isdate(txtDateTo.text) = false then e.isvalid = false
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <div id="dek">
    </div>
    <script language="javascript">

function getObj(name)
    {
        if (document.getElementById) // test if browser supports document.getElementById
            {
                this.obj = document.getElementById(name);
                this.style = document.getElementById(name).style;
            }
        else if (document.all) // test if browser supports document.all
            {
                this.obj = document.all[name];
                this.style = document.all[name].style;
            }
        else if (document.layers) // test if browser supports document.layers
            {
                this.obj = document.layers[name];
                this.style = document.layers[name].style;
            }
    }

function checkedChange()
    {
        var rbByDate = new getObj('rbByDate');
        var rbByPart = new getObj('rbByPart');
        var rbByMfg = new getObj('rbByMfg');
        var rbByModel = new getObj('rbByModel');
        var txtMFG = new getObj('txtMFG');
        var txtPartFrom = new getObj('txtPartFrom');
        var txtPartTo = new getObj('txtPartTo');
        var txtDateFrom = new getObj('txtDateFrom');
        var txtDateTo = new getObj('txtDateTo');
        var txtModel = new getObj('txtModel');

        if (rbByDate.obj.checked == true)
            {
                txtMFG.obj.disabled = true;
                txtPartFrom.obj.disabled = true;
                txtPartTo.obj.disabled = true;
                txtDateFrom.obj.disabled = false;
                txtDateTo.obj.disabled = false;
                txtModel.obj.disabled = true;
                txtModel.obj.value = "";
                txtMFG.obj.value = "";
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";
                txtDateFrom.obj.value = "";
                txtDateTo.obj.value = "";
            }
        else if (rbByPart.obj.checked == true)
            {
                txtMFG.obj.disabled = true;
                txtPartFrom.obj.disabled = false;
                txtPartTo.obj.disabled = false;
                txtDateFrom.obj.disabled = true;
                txtDateTo.obj.disabled = true;
                txtModel.obj.disabled = true;
                txtMFG.obj.value = "";
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";
                txtDateFrom.obj.value = "";
                txtDateTo.obj.value = "";
                txtModel.obj.value = "";
            }
        else if (rbByMfg.obj.checked == true)
            {
                txtMFG.obj.disabled = false;
                txtPartFrom.obj.disabled = true;
                txtPartTo.obj.disabled = true;
                txtDateFrom.obj.disabled = true;
                txtDateTo.obj.disabled = true;
                txtModel.obj.disabled = true;
                txtMFG.obj.value = "";
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";
                txtDateFrom.obj.value = "";
                txtDateTo.obj.value = "";
                txtModel.obj.value = "";
            }
        else if (rbByModel.obj.checked == true)
            {
                txtMFG.obj.disabled = true;
                txtPartFrom.obj.disabled = true;
                txtPartTo.obj.disabled = true;
                txtDateFrom.obj.disabled = true;
                txtDateTo.obj.disabled = true;
                txtModel.obj.disabled = false;
                txtMFG.obj.value = "";
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";
                txtDateFrom.obj.value = "";
                txtDateTo.obj.value = "";
                txtModel.obj.value = "";
            }
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
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">PARTS
                                PENDING SSER</asp:Label>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <asp:CustomValidator id="ValDateInput" runat="server" CssClass="ErrorText" Width="100%" OnServerValidate="ValDateInput_ServerValidate" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid date format." Display="Dynamic" ForeColor=" "></asp:CustomValidator>
                            </div>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 60%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" align="center" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="30%" bgcolor="silver">
                                                <asp:RadioButton id="rbByPart" runat="server" Text="By Part Range" CssClass="OutputText" GroupName="GP1"></asp:RadioButton>
                                            </td>
                                            <td width="70%">
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="left">
                                                                    <asp:TextBox id="txtPartFrom" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                            <td width="10%">
                                                                <div align="center"><asp:Label id="Label2" runat="server" width="" cssclass="OutputText">to</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td width="45%">
                                                                <div align="right">
                                                                    <asp:TextBox id="txtPartTo" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:RadioButton id="rbByDate" runat="server" Text="By Date Range" CssClass="OutputText" GroupName="GP1"></asp:RadioButton>
                                            </td>
                                            <td>
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="45%">
                                                                <div align="left">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtDateFrom" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td width="10%">
                                                                <div align="center"><asp:Label id="Label1" runat="server" width="" cssclass="OutputText">to</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td width="45%">
                                                                <div align="right">
                                                                    <div align="right">
                                                                        <asp:TextBox id="txtDateTo" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:RadioButton id="rbByMfg" runat="server" Text="by Mfg/MPN" CssClass="OutputText" GroupName="GP1"></asp:RadioButton>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtMFG" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:RadioButton id="rbByModel" runat="server" Text="by Model" CssClass="OutputText" GroupName="GP1"></asp:RadioButton>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtModel" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" Width="117px"></asp:Button>
                                            </td>
                                            <td width="50%">
                                                <p align="right">
                                                    <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" Text="Back" Width="117px"></asp:Button>
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
        </p>
    </form>
</body>
</html>
