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
    
    
    
            Dissql ("Select distinct(Modify_By) as [Modify_By] from Part_Source_Approval_M","Modify_By","Modify_By",cmbBuyer)
    
            Dim oList As ListItemCollection = cmbBuyer.Items
            oList.Add(New ListItem("All"))
    
    
            'if cmbModelNo.selectedindex = 0 then Dissql ("Select Revision, cast(Revision as nvarchar(20)) + '   (' + convert(nvarchar(30),Effective_Date,3) + ')' as [EffDate] from BOM_M where model_no = '" & trim(cmbModelNo.selectedItem.value) & "' order by revision asc","Revision","EffDate",cmbRevision)
            '
        End if
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
    
    Sub cmdView1_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=PartSourceEdit&Sel=Buyer&BuyerCode=" & trim(cmbBuyer.selecteditem.value))
    End Sub
    
    Sub cmdGo1_Click(sender As Object, e As EventArgs)
        cmbPartNo1.items.clear
        Dissql ("Select distinct(Part_No),Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No like '%" & trim(txtSearchPart1.text) & "%';","Part_No","Desc",cmbPartNo1)
        txtSearchPart1.text = "-- Search --"
    End Sub
    
    Sub txtSearchPart2_TextChanged(sender As Object, e As EventArgs)
        cmbPartNo2.items.clear
        Dissql ("Select distinct(Part_No),Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No like '%" & trim(txtSearchPart2.text) & "%';","Part_No","Desc",cmbPartNo2)
        txtSearchPart2.text = "-- Search --"
    End Sub
    
    Sub cmdView2_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=PartSourceEdit&Sel=PartNo&PartNoFrom=" & trim(cmbPartNo1.selecteditem.value) & "&PartNoTo=" & trim(cmbPartNo2.selecteditem.value))
    End Sub
    
    Sub cmdView3_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=PartSourceEdit&Sel=PSANo&PSANoFrom=" & trim(txtPSAFrom.text) & "&PSANoTo=" & trim(txtPSATo.text))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label2" runat="server" forecolor="" backcolor="" width="100%" cssclass="FormDesc">PART
                                SOURCE APPROVAL REPORT</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="Label8" runat="server" width="80%" cssclass="SectionHeader">By Buyer
                                Code</asp:Label> 
                                <table class="sideboxnotop" style="HEIGHT: 9px" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="111px" cssclass="LabelNormal">Buyer</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbBuyer" runat="server" Width="298px" CssClass="OutputText"></asp:DropDownList>
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <div align="center">
                                                                            <asp:Button id="cmdView1" onclick="cmdView1_Click" runat="server" Width="104px" Text="View"></asp:Button>
                                                                        </div>
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
                            <p align="center">
                                <asp:Label id="Label9" runat="server" width="80%" cssclass="SectionHeader">By Part
                                No Range</asp:Label> 
                                <table class="sideboxnotop" style="HEIGHT: 9px" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="111px" cssclass="LabelNormal">Part No
                                                                    From</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearchPart1" onkeydown="KeyDownHandler(cmdGo1)" onclick="GetFocus(txtSearchPart1)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo1" onclick="cmdGo1_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbPartNo1" runat="server" Width="311px" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="111px" cssclass="LabelNormal">Part No
                                                                    To</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearchPart2" onkeydown="KeyDownHandler(cmdGo2)" onclick="GetFocus(txtSearchPart2)" runat="server" Width="78px" CssClass="OutputText" OnTextChanged="txtSearchPart2_TextChanged">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo2" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbPartNo2" runat="server" Width="311px" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdView2" onclick="cmdView2_Click" runat="server" Width="104px" Text="View"></asp:Button>
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
                            <p align="center">
                                <asp:Label id="Label10" runat="server" width="80%" cssclass="SectionHeader">By PSA
                                No Range</asp:Label> 
                                <table class="sideboxnotop" style="HEIGHT: 9px" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="111px" cssclass="LabelNormal">PSA # From</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPSAFrom" runat="server" Width="292px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="111px" cssclass="LabelNormal">PSA # To</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPSATo" runat="server" Width="292px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdView3" onclick="cmdView3_Click" runat="server" Width="104px" Text="View"></asp:Button>
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
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
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
