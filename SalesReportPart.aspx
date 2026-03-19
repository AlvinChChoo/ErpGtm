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
            Dissql ("Select Part_No from part_master order by part_no asc","Part_No","Part_No",cmbPartFrom)
            Dissql ("Select Part_No from part_master order by part_no asc","Part_No","Part_No",cmbPartTo)
            Dissql ("Select Cust_Code from Cust order by Cust_Code asc","Cust_Code","Cust_Code",cmbCustFrom)
            Dissql ("Select Cust_Code from Cust order by Cust_Code asc","Cust_Code","Cust_Code",cmbCustTo)
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
    
    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        response.redirect("SalesByPartRpt1.aspx?RptType=Part&RptName=SalesReportPart1&PartFrom=" & trim(cmbPartFrom.selecteditem.value) & "&PartTo=" & trim(cmbPartTo.selectedItem.value) & "&DateFrom=" & txtDateFrom1.text & "&DateTo=" & txtDateTo1.text)
    End Sub
    
    
    Sub cmdRptByCust_Click(sender As Object, e As EventArgs)
        response.redirect("SalesByPartRpt1.aspx?RptType=Cust&RptName=SalesReportPart1&CustFrom=" & trim(cmbCustFrom.selecteditem.value) & "&CustTo=" & trim(cmbCustTo.selectedItem.value) & "&DateFrom=" & txtDateFrom2.text & "&DateTo=" & txtDateTo2.text)
    End Sub
    
    Sub cmdRptByDate_Click(sender As Object, e As EventArgs)
        response.redirect("SalesByPartRpt1.aspx?RptType=Date&RptName=SalesReportPart1&DateFrom=" & txtDateFrom3.text & "&DateTo=" & txtDateTo3.text)
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
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
                                <asp:Label id="Label2" runat="server" forecolor="" backcolor="" width="100%" cssclass="FormDesc">SALES
                                REPORT</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 68px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <div align="center"><asp:Label id="Label1" runat="server" width="100%">SALES BY PART
                                                                            RANGE</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <p align="center">
                                                                        <table style="HEIGHT: 38px" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="LotNo" runat="server" width="106px" cssclass="OutputText">Part From</asp:Label>
                                                                                            <asp:DropDownList id="cmbPartFrom" runat="server" Width="194px" CssClass="OutputText"></asp:DropDownList>
                                                                                            <asp:Label id="Label7" runat="server" width="23px" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:DropDownList id="cmbPartTo" runat="server" Width="194px" CssClass="OutputText"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label8" runat="server" width="106px" cssclass="OutputText">Date From</asp:Label>
                                                                                            <asp:TextBox id="txtDateFrom1" runat="server" Width="194px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:Label id="Label3" runat="server" width="23px" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:TextBox id="txtDateTo1" runat="server" Width="194px" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="85px" Text="View Report"></asp:Button>
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
                                                    <table style="HEIGHT: 68px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <div align="center"><asp:Label id="Label4" runat="server" width="100%">SALES BY CUSTOMER
                                                                            RANGE</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <p align="center">
                                                                        <table style="HEIGHT: 38px" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label5" runat="server" width="134px" cssclass="OutputText">Customer
                                                                                            From</asp:Label>
                                                                                            <asp:DropDownList id="cmbCustFrom" runat="server" Width="194px" CssClass="OutputText"></asp:DropDownList>
                                                                                            <asp:Label id="Label6" runat="server" width="23px" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:DropDownList id="cmbCustTo" runat="server" Width="194px" CssClass="OutputText"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label9" runat="server" width="134px" cssclass="OutputText">Date From</asp:Label>
                                                                                            <asp:TextBox id="txtDateFrom2" runat="server" Width="194px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:Label id="Label10" runat="server" width="23px" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:TextBox id="txtDateTo2" runat="server" Width="194px" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <asp:Button id="cmdRptByCust" onclick="cmdRptByCust_Click" runat="server" Width="85px" Text="View Report"></asp:Button>
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
                                                    <table style="HEIGHT: 68px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <div align="center"><asp:Label id="Label12" runat="server" width="100%">SALES BY DATE
                                                                            RANGE</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <p align="center">
                                                                        <table style="HEIGHT: 38px" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label15" runat="server" cssclass="OutputText">Date From</asp:Label>
                                                                                            <asp:TextBox id="txtDateFrom3" runat="server" Width="194px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:Label id="Label16" runat="server" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:TextBox id="txtDateTo3" runat="server" Width="194px" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <asp:Button id="cmdRptByDate" onclick="cmdRptByDate_Click" runat="server" Width="85px" Text="View Report"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
    </form>
</body>
</html>
