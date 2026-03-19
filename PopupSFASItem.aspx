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
            lblSFASNo.text = ReqCOm.GetFieldVal("select sfas_no from sfas_m where seq_no = " & request.params("ID") & ";","SFAS_No")
            ShowMifDet()
            txtYear.text = year(now)
        end if
    End Sub
    
    Sub ShowMifDet()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "select sf.seq_no,mm.cust_code,MM.MODEL_DESC,SF.MODEL_NO,sf.forecast_date,SF.FORECAST_QTY,SF.UP,Cust.Curr_Code,sf.amt from SFAS_D SF, MODEL_MASTER MM,cust where sfas_no = '" & trim(lblSFASNo.text) & "' AND MM.model_code = SF.MODEL_NO AND MM.CUST_CODE = CUST.CUST_CODE"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MIF_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ForecastDate As Label = CType(e.Item.FindControl("ForecastDate"), Label)
            Dim lblSeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
            Dim SOQty As Label = CType(e.Item.FindControl("SOQty"), Label)
            Dim ForecastDateTemp As Label = CType(e.Item.FindControl("ForecastDateTemp"), Label)
            Dim ModelNo As Label = CType(e.Item.FindControl("ModelNo"), Label)
            Dim Variance As Label = CType(e.Item.FindControl("Variance"), Label)
            Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
    
            select case month(cdate(ForecastDate.text))
                case 1 : ForecastDate.text = "Jan, " & year(cdate(ForecastDate.text))
                case 2 : ForecastDate.text = "Feb, " & year(cdate(ForecastDate.text))
                case 3 : ForecastDate.text = "Mar, " & year(cdate(ForecastDate.text))
                case 4 : ForecastDate.text = "Apr, " & year(cdate(ForecastDate.text))
                case 5 : ForecastDate.text = "May, " & year(cdate(ForecastDate.text))
                case 6 : ForecastDate.text = "June, " & year(cdate(ForecastDate.text))
                case 7 : ForecastDate.text = "July, " & year(cdate(ForecastDate.text))
                case 8 : ForecastDate.text = "Aug, " & year(cdate(ForecastDate.text))
                case 9 : ForecastDate.text = "Sep, " & year(cdate(ForecastDate.text))
                case 10 : ForecastDate.text = "Oct, " & year(cdate(ForecastDate.text))
                case 11 : ForecastDate.text = "Nov, " & year(cdate(ForecastDate.text))
                case 12 : ForecastDate.text = "Dec, " & year(cdate(ForecastDate.text))
            end select
    
            up.text = format(cdec(up.text),"##,##0.00000")
            Amt.text = format(cdec(Amt.text),"##,##0.00")
    
    
    
    
            'response.write(ReqCOM.GetFieldVal("Select sum(Order_Qty) as [TotalOrderQty] from SO_Model_M where Model_No = '" & trim(ModelNo.text) & "' and month(Prod_Date) = " & month(cdate(ForecastDateTemp.text)) & " and year(Prod_Date) = " & year(cdate(ForecastDateTemp.text)) & ";","TotalOrderQty"))
    
            if ReqCom.funcCheckDuplicate("Select Order_Qty from SO_Models_M where Model_No = '" & trim(ModelNo.text) & "' and month(Req_Date) = " & month(cdate(ForecastDateTemp.text)) & " and year(Req_Date) = " & year(cdate(ForecastDateTemp.text)) & ";","Order_Qty") = true then
                SOQty.text = ReqCOM.GetFieldVal("Select sum(Order_Qty) as [TotalOrderQty] from SO_ModelS_M where Model_No = '" & trim(ModelNo.text) & "' and month(Req_Date) = " & month(cdate(ForecastDateTemp.text)) & " and year(Req_Date) = " & year(cdate(ForecastDateTemp.text)) & ";","TotalOrderQty")
            else
                SOQty.text = "0"
            end if
    
            'if trim(SOQty.text) = "" then SOQty.text = "temp"
    
    
            'if trim(SOQty.text) = "" then SOQty.text = "temp"
            'response.write("(" & soQty.text & ")")
    
            Variance.text = format(cdec((SOQty.text * UP.text) - Amt.text),"##,##0.00")
    
    
        End if
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
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Dim ForecastDate as date = cint(cmbMonth.selecteditem.value) & "/1/" & cint(txtYear.text)
            Dim Amt as decimal = cdec(txtQty.text) * cdec(txtUP.text)
            StrSql = "Insert into SFAS_D(SFAS_NO,MODEL_NO,FORECAST_QTY,FORECAST_DATE,UP,AMT,Forecast_Type,Rem) "
            StrSql = StrSql & " Select '" & trim(lblSFASNo.text) & "','" & trim(cmbSearchModel.selecteditem.value) & "'," & txtQty.text & ",'" & cdate(ForecastDate) & "'," & txtup.text & "," & cdec(Amt) & ",'" & trim(cmbForecastType.selecteditem.value) & "','" & trim(Replace(txtRem.text,"'","`")) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("PopupSFASItem.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i As Integer
        Dim strSql as string
    
        Dim remove As CheckBox
        Dim SeqNo As Label
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
            remove = CType(dtgPartWithSource.Items(i).FindControl("Remove"), CheckBox)
            SeqNo = CType(dtgPartWithSource.Items(i).FindControl("lblSeqNo"), Label)
    
            If remove.Checked = true Then
                Try
                    ReqCOM.ExecuteNonQuery("Delete from SFAS_D where SEQ_NO = " & SeqNo.text & ";")
                Catch err as exception
                End Try
            end if
        Next
        Response.redirect("PopupSFASItem.aspx?ID=" & Request.params("ID"))
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
    
    Sub cmdSearchModel_Click(sender As Object, e As EventArgs)
        cmbSearchModel.items.clear
        Dissql ("Select Model_Code,Model_Code + '|' + Model_Code as [DESC] from Model_Master where Model_Code + Model_Desc like '%" & cstr(txtSearchModel.Text) & "%' order by Model_Code asc","Model_Code","Desc",cmbSearchModel)
        ShowModelDet
    End Sub
    
    Sub ShowModelDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if cmbSearchModel.selectedindex <> -1 then
            lblCustCode.text = ReqCOM.GetFieldVal("Select Cust_Code from Model_Master where Model_Code = '" & trim(cmbSearchModel.selecteditem.value) & "';","Cust_Code")
            lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(cmbSearchModel.selecteditem.value) & "';","Model_Desc")
            lblCurrCode.text = ReqCOM.GetFieldVal("Select Curr_Code from Cust where cust_code = '" & trim(lblCustCode.text) & "'","Curr_Code")
            lblCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where cust_code = '" & trim(lblCustCode.text) & "'","Cust_Name")
            txtSearchModel.text = "-- Search --"
            'ShowOtherSupplier
            'GetNextControl(txtSearchVendor)
        else if cmbSearchModel.selectedindex = -1 then
            'ShowOtherSupplier
            txtSearchModel.text = "-- Search --"
            ShowAlert("Invalid Model No selected. Pls try again.")
        end if
    End Sub
    
    Sub cmdexit_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SALES FORECAST
                                APPROVAL SHEET ITEM</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="cmbSearchModel" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Model." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="cmbMonth" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast month" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtYear" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast year." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="txtQty" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast qty." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtUP" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast forecast U/P." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtQty" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast Quantity" CssClass="ErrorText" Width="100%" Type="Integer" ValueToCompare="0" Operator="GreaterThan"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator2" runat="server" ControlToValidate="txtUP" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast U/P" CssClass="ErrorText" Width="100%" Type="Double" ValueToCompare="0" Operator="GreaterThan"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator3" runat="server" ControlToValidate="txtQty" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast Quantity" CssClass="ErrorText" Width="100%" Type="Integer" ValueToCompare="0" Operator="DataTypeCheck"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator4" runat="server" ControlToValidate="txtUP" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid forecast U/P" CssClass="ErrorText" Width="100%" Type="Double" ValueToCompare="0" Operator="DataTypeCheck"></asp:CompareValidator>
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
                                                                    <asp:Label id="lblSFASNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Model No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:TextBox id="txtSearchModel" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchModel)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdSearchModel" onclick="cmdSearchModel_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                    <asp:DropDownList id="cmbSearchModel" runat="server" CssClass="OutputText" Width="302px" autopostback="True"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Forcast Month/Year</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbMonth" runat="server" CssClass="OutputText" Width="140px">
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
                                                                    <asp:TextBox id="txtYear" runat="server" CssClass="OutputText" Width="82px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Forecast Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtQty" runat="server" CssClass="OutputText" Width="221px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">U/P</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUP" runat="server" CssClass="OutputText" Width="221px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Forecast Type</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbForecastType" runat="server" CssClass="OutputText" Width="233px">
                                                                        <asp:ListItem Value="SF">SALES FORECAST</asp:ListItem>
                                                                        <asp:ListItem Value="CF">CUSTOMER FORECAST</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="513px" Height="72px" TextMode="MultiLine"></asp:TextBox>
                                                                </td>
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
                                                                    <asp:Label id="lblCurrCode" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Model Description</asp:Label></td>
                                                                <td width="100%">
                                                                    <asp:Label id="lblModelDesc" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="174px" Text="Add to list"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" Width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Cust #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CustCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Code") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Model #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast Month">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastDateTemp" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Currency">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CurrCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Curr_Code") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Amt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Amt") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="S/O Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SOQty" runat="server" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Variance">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Variance" runat="server" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remove">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="Remove" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="158px" CausesValidation="False" Text="Remove selected item"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdexit" onclick="cmdexit_Click" runat="server" Width="102px" CausesValidation="False" Text="Exit"></asp:Button>
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
