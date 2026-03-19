<%@ Page Language="VB" Debug="true" %>
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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rs as sqldatareader = ReqCOm.ExeDataReader("Select * from SFAS_D where seq_no = " & request.params("ID") & ";")
    
            do while rs.read
                lblSFASNo.text = rs("SFAS_NO")
                lblModelCode.text = rs("Model_No")
                lblForecastDateTemp.text = rs("Forecast_Date")
                txtQty.text = rs("Forecast_Qty")
                txtUP.text = rs("UP")
                txtRem.text = rs("Rem").tostring
                cmbForecastType.Items.FindByValue(trim(rs("Forecast_Type"))).Selected = True
                lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelCode.text) & "';","Model_Desc")
                lblCustCode.text = ReqCOM.GetFieldVal("Select Cust_Code from Model_Master where Model_Code = '" & trim(lblModelCode.text) & "';","Cust_Code")
                lblCustName.text = ReqCOM.GetFieldVal("Select Cust_name from Cust where cust_code = '" & trim(lblCustCode.text) & "';","Cust_Name")
                lblCurrCode.text = ReqCom.getfieldval("Select Curr_Code from Cust where Cust_Code = '" & trim(lblCustCode.text) & "';","Curr_Code")
    
                select case month(rs("Forecast_Date"))
                    case 1 : lblForecastDate.text = "Jan, " & year(cdate(rs("Forecast_Date")))
                    case 2 : lblForecastDate.text = "Feb, " & year(cdate(rs("Forecast_Date")))
                    case 3 : lblForecastDate.text = "Mar, " & year(cdate(rs("Forecast_Date")))
                    case 4 : lblForecastDate.text = "Apr, " & year(cdate(rs("Forecast_Date")))
                    case 5 : lblForecastDate.text = "May, " & year(cdate(rs("Forecast_Date")))
                    case 6 : lblForecastDate.text = "June, " & year(cdate(rs("Forecast_Date")))
                    case 7 : lblForecastDate.text = "July, " & year(cdate(rs("Forecast_Date")))
                    case 8 : lblForecastDate.text = "Aug, " & year(cdate(rs("Forecast_Date")))
                    case 9 : lblForecastDate.text = "Sep, " & year(cdate(rs("Forecast_Date")))
                    case 10 : lblForecastDate.text = "Oct, " & year(cdate(rs("Forecast_Date")))
                    case 11 : lblForecastDate.text = "Nov, " & year(cdate(rs("Forecast_Date")))
                    case 12 : lblForecastDate.text = "Dec, " & year(cdate(rs("Forecast_Date")))
                end select
            loop
            rs.close()
        end if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub DropDownList1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdexit_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        StrSql = "Update SFAS_D set Forecast_Qty = " & txtQty.text & ",UP = " & txtUP.text & ",Amt = " & txtQty.text * txtUP.text & " where seq_no = " & request.params("ID") & ";"
        ReqCom.executeNonQuery(StrSql)
        ShowAlert("Record updated.")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SALES FORECAST
                                APPROVAL SHEET ITEM</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid forecast qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtQty"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid forecast forecast U/P." ForeColor=" " Display="Dynamic" ControlToValidate="txtUP"></asp:RequiredFieldValidator>
                                <asp:CompareValidator id="CompareValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid forecast Quantity" ForeColor=" " Display="Dynamic" ControlToValidate="txtQty" Operator="GreaterThan" ValueToCompare="0" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator2" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid forecast U/P" ForeColor=" " Display="Dynamic" ControlToValidate="txtUP" Operator="GreaterThan" ValueToCompare="0" Type="Double"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator3" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid forecast Quantity" ForeColor=" " Display="Dynamic" ControlToValidate="txtQty" Operator="DataTypeCheck" ValueToCompare="0" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator4" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid forecast U/P" ForeColor=" " Display="Dynamic" ControlToValidate="txtUP" Operator="DataTypeCheck" ValueToCompare="0" Type="Double"></asp:CompareValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">SFAS No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSFASNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Model No / Description</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblModelCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Forcast Month/Year</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblForecastDate" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="lblForecastDateTemp" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Customer</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label15" runat="server" cssclass="LabelNormal">Currency</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCurrCode" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Forecast Type</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbForecastType" runat="server" Width="233px" CssClass="OutputText">
                                                                        <asp:ListItem Value="SF">SALES FORECAST</asp:ListItem>
                                                                        <asp:ListItem Value="CF">CUSTOMER FORECAST</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top" bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" Width="502px" CssClass="OutputText" TextMode="MultiLine" Height="72px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Forecast Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtQty" runat="server" Width="221px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">U/P</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUP" runat="server" Width="221px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="91px" Text="Update"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdexit" onclick="cmdexit_Click" runat="server" Width="102px" Text="Exit" CausesValidation="False"></asp:Button>
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
        </p>
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
