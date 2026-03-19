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
        if page.ispostback = false then
            rbOthers.Attributes.Add("onclick", "checkedChange();")
            rbPartNo.Attributes.Add("onclick", "checkedChange();")
        End if
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            if rbPartNo.checked = true then
                ReqCom.ExecuteNonQuery("UPDATE PART_MASTER SET PART_MASTER.LOCATION = PART_LOC.LOC FROM PART_MASTER,PART_LOC WHERE PART_MASTER.PART_NO = PART_LOC.PART_NO")
                ShowReport("PopupReportViewer.aspx?RptName=PartList&ReturnURL=PartListRpt.aspx&Type=PartRange&PartNoFrom=" & trim(txtPartNoFrom.text) & "&PartNoTo=" & trim(txtPartNoTo.text))
                redirectPage("PartListRpt.aspx")
            elseif rbOthers.checked = true then
                ReqCom.ExecuteNonQuery("UPDATE PART_MASTER SET PART_MASTER.LOCATION = PART_LOC.LOC FROM PART_MASTER,PART_LOC WHERE PART_MASTER.PART_NO = PART_LOC.PART_NO")
                if trim(cmbSearchBy.selecteditem.value) = "Part_Spec" then ShowReport("PopupReportViewer.aspx?RptName=PartList&ReturnURL=PartListRpt.aspx&Type=Part_Spec&Keyword=" & trim(txtKeyword.text))
                if trim(cmbSearchBy.selecteditem.value) = "Part_Desc" then ShowReport("PopupReportViewer.aspx?RptName=PartList&ReturnURL=PartListRpt.aspx&Type=Part_Desc&Keyword=" & trim(txtKeyword.text))
                if trim(cmbSearchBy.selecteditem.value) = "M_Part_No" then ShowReport("PopupReportViewer.aspx?RptName=PartList&ReturnURL=PartListRpt.aspx&Type=M_Part_No&Keyword=" & trim(txtKeyword.text))
                if trim(cmbSearchBy.selecteditem.value) = "MFG" then ShowReport("PopupReportViewer.aspx?RptName=PartList&ReturnURL=PartListRpt.aspx&Type=MFG&Keyword=" & trim(txtKeyword.text))
                redirectPage("PartListRpt.aspx")
            end if
        End If
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body>
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

        var rbPartNo = new getObj('rbPartNo');
        var rbOthers = new getObj('rbOthers');

        var txtPartNoFrom = new getObj('txtPartNoFrom');
        var txtPartNoTo = new getObj('txtPartNoTo');

        var txtKeyword = new getObj('txtKeyword');
        var cmbSearchBy = new getObj('cmbSearchBy');



        if (rbPartNo.obj.checked == true)
            {
                txtPartNoFrom.obj.disabled = false;
                txtPartNoTo.obj.disabled = false;
                txtPartNoFrom.obj.value = "";
                txtPartNoTo.obj.value = "";

                txtKeyword.obj.disabled = true;
                cmbSearchBy.obj.disabled = true;
                txtKeyword.obj.value = "";
                cmbSearchBy.obj.value = "";

            }
        else if (rbOthers.obj.checked == true)
            {
                txtPartNoFrom.obj.disabled = true;
                txtPartNoTo.obj.disabled = true;
                txtPartNoFrom.obj.value = "";
                txtPartNoTo.obj.value = "";

                txtKeyword.obj.disabled = false;
                cmbSearchBy.obj.disabled = false;
                txtKeyword.obj.value = "";
                cmbSearchBy.obj.value = "";
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
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">PART
                                LIST REPORT</asp:Label>
                            </div>
                            <p>
                                <table style="HEIGHT: 9px" width="70%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:RadioButton id="rbPartNo" runat="server" CssClass="OutputText" Text="Part No" GroupName="optSelection" Checked="True"></asp:RadioButton>
                                                                </td>
                                                                <td width="75%">
                                                                    <p>
                                                                        <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txtPartNoFrom" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label2" runat="server" width="" cssclass="OutputText">To</asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txtPartNoTo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:RadioButton id="rbOthers" runat="server" CssClass="OutputText" Text="Others" GroupName="optSelection"></asp:RadioButton>
                                                                </td>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txtKeyword" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <div align="center"><asp:Label id="Label5" runat="server" width="" cssclass="OutputText">From</asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td width="40%">
                                                                                        <p>
                                                                                            <asp:DropDownList id="cmbSearchBy" runat="server" CssClass="OutputText" Width="100%" Enabled="False">
                                                                                                <asp:ListItem Value="Part_Spec">Part Specification</asp:ListItem>
                                                                                                <asp:ListItem Value="Part_Desc">Part Description</asp:ListItem>
                                                                                                <asp:ListItem Value="M_Part_No">Mfg Part No</asp:ListItem>
                                                                                                <asp:ListItem Value="MFG">Manufacturer</asp:ListItem>
                                                                                            </asp:DropDownList>
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
                                                <p align="right">
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Text="Quick Search"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" Text="Back" Width="120px"></asp:Button>
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
                            <p>
                            </p>
                            <p>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
