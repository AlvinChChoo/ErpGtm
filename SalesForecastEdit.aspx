<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    public PreviousUP as decimal
    public PreviousQty as long
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
             if page.ispostback = false then
                 'Dissql("Select Model_Code,Model_Code + '-' + model_Desc as [Desc] from model_Master order by Model_Code asc","Model_Code","Desc",cmbModelNo)
                 Dissql("Select Model_Code from model_Master order by Model_Code asc","Model_Code","Model_Code",cmbModelNo)
                 txtYear.text = Year(now)
             end if
         End Sub
    
         Sub cmdEdit_Click(sender As Object, e As EventArgs)
             Response.redirect("SalesForecastEdit.aspx")
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
             if page.isvalid = true then
                    Dim Forecastno as string
                    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                    Dim ForecastDate as date = cint(cmbMonth.selecteditem.value) & "/1/" & cint(txtYear.text)
                    Dim PreviousQty as long
                    if ReqCOM.FuncCheckDuplicate("Select Top 1 Model_No  from Sales_Forecast where model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","Model_No") = true then
                        ReqCOM.ExecuteNonQuery("Insert into Sales_Forecast_History(Model_No,Forecast_Date,Forecast_Qty,UP) Select '" & trim(cmbModelNo.selectedItem.value) & "','" & ForecastDate & "'," & PreviousQty & "," & PreviousUp & "")
                        ReqCOM.ExecuteNonQuery("Update Sales_Forecast set Forecast_Qty = " & cint(txtQty.text) & ",UP=" & txtUP.text & " where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and ForecasT_Date = '" & ForecastDate & "';")
                    else
                        ForecastNo = Reqcom.GetDocumentNo("Forecast_No")
                        ReqCOM.ExecuteNonQuery("Insert into Sales_Forecast(Model_No,Forecast_Date,Forecast_Qty,UP,Ref_No,Curr_Code) Select '" & trim(cmbModelNo.selectedItem.value) & "','" & ForecastDate & "'," & txtQty.text & "," & txtUP.text & ",'" & trim(ForecastNo) & "','" & trim(lblCurrCode.text) & "';")
                        ReqCOM.ExecuteNonQuery("Update Main set Forecast_No = Forecast_No + 1")
                    end if
             end if
         End Sub
    
         Sub LinkButton1_Click(sender As Object, e As EventArgs)
         Response.redirect("SalesForecast.aspx")
    End Sub
    
    Sub LinkButton4_Click(sender As Object, e As EventArgs)
         Response.redirect("SalesForecastEdit.aspx")
    End Sub
    
    Sub ValForecastYear(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = false
        if isdate(cmbmonth.selectedItem.value & "/1/" & txtYear.text) = true then e.isvalid =true
    End Sub
    
    Sub CustomValidator1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = true
        if txtQty.text < 0 then e.isvalid = false
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmbModelNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if isdate(cmbmonth.selectedItem.value & "/1/" & txtYear.text) = false then exit sub
        dim ForecastDate as date = cmbmonth.selectedItem.value & "/1/" & txtYear.text
        lblCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where cust_Code in(Select Cust_Code from Model_Master where Model_Code = '" & trim(cmbModelNo.selecteditem.value) & "')","Cust_Name")
        lblCurrCode.text = ReqCOM.GetFieldVal("Select Curr_Code from Cust where cust_Code in(Select Cust_Code from Model_Master where Model_Code = '" & trim(cmbModelNo.selecteditem.value) & "')","curr_Code")
    
        if Reqcom.FuncCheckDuplicate("Select UP from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","UP") = true then
            PreviousQty  = ReqCOM.GetFieldVal("Select top 1 Forecast_Qty from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "' order by seq_no desc","Forecast_Qty")
            PreviousUP = ReqCOM.GetFieldVal("Select top 1 UP from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "' order by seq_no desc","UP")
            lblRefNo.text = ReqCOM.GetFieldVal("Select Ref_No from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","Ref_No")
            txtUP.text  = PreviousUP
            txtQty.text = PreviousQty
    
        else
            PreviousUP = ReqCOM.GetFieldVal("Select top 1 up from Model_Master where Model_Code = '" & trim(cmbModelNo.selecteditem.value) & "'","UP")
            txtUP.text = PreviousUP
    
            lblRefNo.text = ""
            PreviousUP = 0
            PreviousQty = 0
            txtQty.text = PreviousQty
        end if
    
    End Sub
    
    Sub cmbMonth_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if isdate(cmbmonth.selectedItem.value & "/1/" & txtYear.text) = false then exit sub
        dim ForecastDate as date = cmbmonth.selectedItem.value & "/1/" & txtYear.text
        lblCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where cust_Code in(Select Cust_Code from Model_Master where Model_Code = '" & trim(cmbModelNo.selecteditem.value) & "')","Cust_Name")
        lblCurrCode.text = ReqCOM.GetFieldVal("Select Curr_Code from Cust where cust_Code in(Select Cust_Code from Model_Master where Model_Code = '" & trim(cmbModelNo.selecteditem.value) & "')","curr_Code")
            if Reqcom.FuncCheckDuplicate("Select UP from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","UP") = true then
                PreviousQty  = ReqCOM.GetFieldVal("Select Forecast_Qty from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","Forecast_Qty")
                txtQty.text = PreviousQty
                PreviousUP = ReqCOM.GetFieldVal("Select UP from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","UP")
                txtUP.text  = PreviousUP
                lblRefNo.text = ReqCOM.GetFieldVal("Select Ref_No from Sales_Forecast where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' and Forecast_Date = '" & ForecastDate & "';","Ref_No")
    
    
            else
                lblRefNo.text = ""
                txtQty.text = 0
                PreviousQty = 0
                PreviousUP = ReqCOM.GetFieldVal("Select top 1 up from Model_Master where Model_Code = '" & trim(cmbModelNo.selecteditem.value) & "'","up")
            end if
    End Sub
    
    Sub LinkButton5_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesForecast1.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SALES FORECAST </asp:Label> 
                                <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server" Width="100%" ForeColor="White" Font-Bold="True" CausesValidation="False">VIEW FORECAST</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="50%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton4" onclick="LinkButton4_Click" runat="server" Width="100%" ForeColor="WhiteSmoke" Font-Bold="True" CausesValidation="False" BackColor="#FF8080">EDIT FORECAST</asp:LinkButton>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Model no" Display="Dynamic" ControlToValidate="cmbModelNo" EnableClientScript="False"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid month " Display="Dynamic" ControlToValidate="cmbMonth" EnableClientScript="False"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Forecast Qty." Display="Dynamic" ControlToValidate="txtQty" EnableClientScript="False"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Forecast Year." Display="Dynamic" ControlToValidate="txtYear" EnableClientScript="False"></asp:RequiredFieldValidator>
                                <asp:CustomValidator id="ValidateYear" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Forecast Year." Display="Dynamic" OnServerValidate="ValForecastYear"></asp:CustomValidator>
                                <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Forecast Qty." Display="Dynamic" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <table cellspacing="0" cellpadding="0" width="70%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server">Month / Year</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbMonth" runat="server" Width="125px" CssClass="OutputText" OnSelectedIndexChanged="cmbMonth_SelectedIndexChanged" autopostback="true">
                                                                    <asp:ListItem Value="1">January</asp:ListItem>
                                                                    <asp:ListItem Value="2">February</asp:ListItem>
                                                                    <asp:ListItem Value="3">March</asp:ListItem>
                                                                    <asp:ListItem Value="4">April</asp:ListItem>
                                                                    <asp:ListItem Value="5">May</asp:ListItem>
                                                                    <asp:ListItem Value="6">June</asp:ListItem>
                                                                    <asp:ListItem Value="7">July</asp:ListItem>
                                                                    <asp:ListItem Value="8">August</asp:ListItem>
                                                                    <asp:ListItem Value="9">September</asp:ListItem>
                                                                    <asp:ListItem Value="10">October</asp:ListItem>
                                                                    <asp:ListItem Value="11">November</asp:ListItem>
                                                                    <asp:ListItem Value="12">December</asp:ListItem>
                                                                </asp:DropDownList>
                                                                &nbsp; /&nbsp; 
                                                                <asp:TextBox id="txtYear" runat="server" Width="82px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbModelNo" runat="server" Width="100%" CssClass="OutputText" OnSelectedIndexChanged="cmbModelNo_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server">Ref. No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblRefNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server">Customer Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustname" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server">Currency</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCurrCode" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server">Forecast Qty</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtQty" runat="server" Width="125px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server">Unit Price</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtUP" runat="server" Width="125px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 19px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="153px" Text="Update Forecast Qty"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="124px" CausesValidation="False" Text="Back"></asp:Button>
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
    </form>
</body>
</html>
