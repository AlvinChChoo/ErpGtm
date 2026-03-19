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

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            loaddata()
            LoadSNItem()
        End if
    End Sub
    
    Sub LoadData
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblSNNo.text = ReqCOm.GetFieldVal("Select SN_No from Ship_notice_M where Seq_No = " & request.params("ID") & ";","SN_No")
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
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
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdAddItem_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            StrSql = "Insert into Ship_Notice_D(SN_NO,JO_NO,PALLET_NO,CARTON_NO,LOADING_PRIORITY,REM,Model_No,Model_Desc,Ship_Qty,Lot_No) select '" & trim(lblSNNo.text) & "','" & trim(cmbJONo.selecteditem.value) & "','" & trim(txtPalletNo.text) & "','" & trim(txtCartonNo.text) & "','" & trim(txtLoadingPriority.text) & "','" & trim(txtRem.text) & "','" & trim(lblModelNo.text) & "','" & trim(lblModelDesc.text) & "'," & clng(lblProdQty.text) & ",'" & trim(lblLotNo.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("ShippingNoticeItemAdd.aspx?ID=" & clng(Request.params("ID")))
        End if
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbJONo.items.clear
        Dissql ("Select * from job_Order_M where jo_No like '" & trim(txtJONo.text) & "';","JO_No","JO_No",cmbJONo)
    
        if cmbJONo.selectedindex <> -1 then
            lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where Lot_No in (Select Lot_No from Job_Order_M where jo_no = '" & trim(cmbJONo.selecteditem.value) & "')","Model_No")
            lblModelDesc.text = ReqCOM.GetFIeldVal("Select Model_Desc from Model_Master where model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
            lblProdQty.text = ReqCOM.GetFieldVal("Select Prod_Qty from Job_Order_M where jo_No = '" & trim(cmbJoNo.selecteditem.value) & "';","Prod_Qty")
            lblLotNo.text = ReqCOM.GetFieldVal("Select lot_No from Job_Order_M where jo_No = '" & trim(cmbJoNo.selecteditem.value) & "';","Lot_No")
            txtJONo.text = "-- Search --"
        elseif cmbJONo.selectedindex = -1 then
            txtJONo.text = "-- Search --"
            ShowAlert("Invalid Job Order No selected.")
        end if
    End Sub
    
    Sub LoadSNItem()
        'Dim strSql as string = "select sn.rem, sn.sn_no,SN.jo_no,SN.carton_no,SN.Loading_Priority,SN.Pallet_No,SN.Seq_No,JO.Prod_Qty,mm.model_code,mm.model_desc from ship_notice_d SN,Job_Order_M JO,so_models_m so,model_master mm where so.lot_no = jo.lot_no and mm.model_code = so.model_no and sn.jo_no = jo.jo_no and SN.sn_No = '" & trim(lblSNNo.text) & "';"
        Dim strSql as string = "Select * from Ship_Notice_D where sn_No = '" & trim(lblSNNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"ship_notice_d")
        GridControl1.DataSource=resExePagedDataSet.Tables("ship_notice_d").DefaultView
        GridControl1.DataBind()
    End sub
    
    Sub cmdExit_Click(sender As Object, e As EventArgs)
        CloseIE()
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Remove As CheckBox
        Dim StrSql as string = ""
        Dim SeqNo as label
    
        For i = 0 To GridControl1.Items.Count - 1
            Remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            if Remove.checked = true then
                if trim(StrSql) = "" then StrSql = "Delete from Shipping_Notice_D where seq_no = " & clng(SeqNo.text) & ""
                if trim(StrSql) <> "" then StrSql = StrSql & ";Delete from Shipping_Notice_D where seq_no = " & clng(SeqNo.text) & ""
            end if
        Next i
        if trim(StrSql) <> "" then ReqCOM.ExecuteNonQuery(StrSql)
        Response.redirect("ShippingNoticeItemAdd.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmbJONo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select Model_No from SO_Models_M where Lot_No in (Select Lot_No from Job_Order_M where jo_no = '" & trim(cmbJONo.selecteditem.value) & "')"
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            'lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where Lot_No in (Select Lot_No from Job_Order_M where jo_no = '" & trim(cmbJONo.selecteditem.value) & "')","Model_No")
    
            lblModelNo.text = drGetFieldVal("Model_No")
            lblModelDesc.text = drGetFieldVal("Model_Desc")
            lblProdQty.text = ReqCOM.GetFieldVal("Select Prod_Qty from Job_Order_M where jo_No = '" & trim(cmbJoNo.selecteditem.value) & "';","Prod_Qty")
            lblLotNo.text = ReqCOM.GetFieldVal("Select lot_No from Job_Order_M where jo_No = '" & trim(cmbJoNo.selecteditem.value) & "';","Lot_No")
        loop
    
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">SHIPPING NOTICE
                            DETAILS</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="84%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p align="center">
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Display="Dynamic" ControlToValidate="cmbJONo" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Job Order No" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Display="Dynamic" ControlToValidate="txtPalletNo" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid pallet no" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Display="Dynamic" ControlToValidate="txtCartonNo" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid carton no" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="134px" cssclass="LabelNormal">Shipping
                                                                Notice No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblSNNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label3" runat="server" width="134px" cssclass="LabelNormal">Job Order
                                                                No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:TextBox id="txtJONo" onkeydown="KeyDownHandler(cmdGO)" onclick="GetFocus(txtJONo)" runat="server" Width="99px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="48px" CssClass="OutputText" CausesValidation="False" Text="GO"></asp:Button>
                                                                &nbsp;<asp:DropDownList id="cmbJONo" runat="server" Width="266px" CssClass="OutputText" OnSelectedIndexChanged="cmbJONo_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label8" runat="server" width="134px" cssclass="LabelNormal">Model No
                                                                / Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label9" runat="server" width="134px" cssclass="LabelNormal">Ship. Qty</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblProdQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label10" runat="server" width="134px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label4" runat="server" width="134px" cssclass="LabelNormal">Pallet
                                                                #</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPalletNo" runat="server" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label5" runat="server" width="134px" cssclass="LabelNormal">Carton
                                                                #</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtCartonNo" runat="server" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label6" runat="server" width="134px" cssclass="LabelNormal">Loading
                                                                Priority</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtLoadingPriority" runat="server" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" colspan="2">
                                                                <asp:Label id="Label7" runat="server" width="134px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" TextMode="MultiLine" Height="55px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                                <p align="center">
                                                                    <asp:Button id="cmdAddItem" onclick="cmdAddItem_Click" runat="server" Width="182px" CssClass="OutputText" Text="Add Item to Shipping Notice"></asp:Button>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowSorting="False" AutoGenerateColumns="False" ShowFooter="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn Visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Lot #">
                                                            <ItemTemplate>
                                                                <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="J/O #">
                                                            <ItemTemplate>
                                                                <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Model Desc.">
                                                            <ItemTemplate>
                                                                <asp:Label id="ModelDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_Desc") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Ship Qty.">
                                                            <ItemTemplate>
                                                                <asp:Label id="ShipQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ship_Qty") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Pallet #">
                                                            <ItemTemplate>
                                                                <asp:Label id="PalletNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Pallet_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Carton #">
                                                            <ItemTemplate>
                                                                <asp:Label id="CartonNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Carton_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Loading Prio.">
                                                            <ItemTemplate>
                                                                <asp:Label id="LoadingPriority" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Loading_Priority") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Remarks">
                                                            <ItemTemplate>
                                                                <asp:textbox id="Rem" CssClass="ListOutput" runat="server" width= "200px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>'></asp:textbox>
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
                                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="161px" CausesValidation="False" Text="Remove Selected Item"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <p align="center">
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdExit" onclick="cmdExit_Click" runat="server" Width="140px" CausesValidation="False" Text="Exit"></asp:Button>
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
    </form>
</body>
</html>