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
            Dissql ("Select Ven_Code, Ven_Code + '   (' + Ven_Name + ')' as [Desc] from vendor order by Ven_Code asc","Ven_Code","Desc",cmbSupplierFrom)
            Dissql ("Select Ven_Code, Ven_Code + '   (' + Ven_Name + ')' as [Desc] from vendor order by Ven_Code asc","Ven_Code","Desc",cmbSupplierTo)
        End if
    End Sub
    
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
    
    Sub cmdViewByPart_Click(sender As Object, e As EventArgs)
        if (trim(txtPartNoFrom.text) = "" and trim(txtPartNoTo.text) = "") then
            ShowAlert("You don't seem to have supplied a valid Part No range.")
            Exit sub
        end if
    
        if trim(txtPartNoFrom.text) = "" then
            txtPartNoFrom.text = trim(txtPartNoTo.text)
        end if
    
        if trim(txtPartNoTo.text) = "" then
            txtPartNoTo.text = trim(txtPartNoFrom.text)
        end if
    
        ShowReport("PopupReportViewer.aspx?RptName=PartPrice&PartNoFrom=" & trim(txtPartNoFrom.text) & "&RptType=Part&PartNoTo=" & trim(txtPartNoTo.text))
        redirectPage("PartPriceReport.aspx")
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdViewBySupplier_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=PartPrice&SupplierFrom=" & trim(cmbSupplierFrom.selecteditem.value) & "&RptType=Supplier&SupplierTo=" & trim(cmbSupplierTo.selecteditem.value))
        redirectPage("PartPriceReport.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub

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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">Part
                                Source Report</asp:Label>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="70%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center"><asp:Label id="Label4" runat="server" cssclass="Instruction" width="100%">By
                                                                        Part No Range</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <table style="HEIGHT: 31px" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server">Part No From</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:TextBox id="txtPartNoFrom" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server">Part No To</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:TextBox id="txtPartNoTo" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdViewByPart" onclick="cmdViewByPart_Click" runat="server" Text="Show Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center"><asp:Label id="Label5" runat="server" cssclass="Instruction" width="100%">By
                                                                        Supplier Range</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <table style="HEIGHT: 31px" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server">Supplier From</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:DropDownList id="cmbSupplierFrom" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server">Supplier To</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:DropDownList id="cmbSupplierTo" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdViewBySupplier" onclick="cmdViewBySupplier_Click" runat="server" Text="Show Report"></asp:Button>
                                                                    </div>
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
                            <p>
                            </p>
                            <p>
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
