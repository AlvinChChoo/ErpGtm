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
            cmdExplode.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the explosion.\nAre you sure you want to explode this Shipping Notice to Sales Invoice ?')==false) return false;")
            loaddata()
            ProcLoadGridData()
        end if
    End Sub

    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

    Sub loaddata()
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand("Select sn.mode_of_del,sn.mode_of_freight,sn.rem,sn.shipment_date,SN.SN_No,SN.Cust_Code,SN.SI_No,Cust.cust_name from Ship_Notice_m SN,Cust where SN.Seq_No = " & request.params("ID") & ";", myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

        do while drGetFieldVal.read
            lblSNNo.text = drGetFieldVal("SN_No")
            lblCustCode.text = drGetFieldVal("Cust_Code")
            lblCustName.text = drGetFieldVal("Cust_Name")
            lblShipDate.text = format(cdate(drGetFieldVal("Shipment_Date")),"dd/MM/yy")
            txtRem.text = drGetFieldVal("Rem")

            if isdbnull(drGetFieldVal("SI_No")) = true then cmdExplode.enabled = true:cmdUpdate.enabled = true
        loop

        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
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


    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID

            Script.Append("<script language=javascript>")
            Script.Append("document.getElementById('")
            Script.Append(ClientID)
            Script.Append("').focus();")
            Script.Append("</script" & ">")
            RegisterStartupScript("setFocus", Script.ToString())
    End Sub

    Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        'Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SO_MODELS_M where LOT_NO = '" & trim(LotNo.text) & "';","Seq_No")
        'Response.redirect("SalesOrderModelDet.aspx?ID=" & SeqNo)
        'Response.redirect("ShippingNoticeDet.aspx?ID=" & SeqNo.text)
    End sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub

    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        StrSql = "Select * from Ship_Notice_D where SN_No = '" & trim(lblSNNo.text) & "';"
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"ship_notice_m")
            GridControl1.DataSource=resExePagedDataSet.Tables("ship_notice_m").DefaultView
            GridControl1.DataBind()
        End if
    end sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)

    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Sub lnkAddItem_Click(sender As Object, e As EventArgs)
        ShowReport("ShippingNoticeItemAdd.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("ShippingNotice.aspx")
    End Sub

    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        Response.redirect("ShippingNoticeDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Remove As CheckBox
        Dim LoadingPriority,PalletNo,Rems,CartonNo As Textbox
        Dim SeqNo As Label

        For i = 0 To GridControl1.Items.Count - 1
            Remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            PalletNo = CType(GridControl1.Items(i).FindControl("PalletNo"), Textbox)
            CartonNo = CType(GridControl1.Items(i).FindControl("CartonNo"), Textbox)
            LoadingPriority = CType(GridControl1.Items(i).FindControl("LoadingPriority"), Textbox)
            Rems = CType(GridControl1.Items(i).FindControl("Rem"), Textbox)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)

            if Remove.checked = true then ReqCOM.ExecuteNonQuery("Delete from Ship_Notice_D where seq_No = " & SeqNo.text & ";")
            ReqCOM.ExecuteNonQuery("Update Ship_Notice_D Set Pallet_No = '" & trim(PalletNo.text) & "',Carton_No = '" & trim(CartonNo.text) & "',Loading_Priority = '" & trim(LoadingPriority.text) & "',Rem = '" & replace(trim(Rems.text),"'","`") & "' where Seq_No = " & SeqNo.text & ";")
        Next i
        ShowAlert ("Selected item has been removed.")
        redirectPage("ShippingNoticeDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdExplode_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SINo as string

        SINo = ReqCOM.GetDocumentNo("SI_No")
        ReqCOM.ExecuteNonQuery("Insert into Sales_Invoice_M(SI_No,Cust_Code,Cust_Name,SI_Date) Select '" & trim(SINo) & "',Cust_Code,Cust_Name,'" & cdate(now) & "' from Ship_Notice_M where SN_No = '" & trim(lblSNNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update Sales_Invoice_M set Sales_Invoice_M.Cust_Name = cust.Cust_Name,Sales_Invoice_M.Ship_Add1 = cust.ship_add1,Sales_Invoice_M.ship_add2 = cust.ship_add2,Sales_Invoice_M.ship_add3 = cust.ship_add3 from Cust,Sales_Invoice_M where Sales_Invoice_M.SI_No = '" & trim(SINo) & "' and sales_invoice_m.cust_code = cust.cust_code")
        ReqCOM.ExecuteNonQuery("Insert into Sales_Invoice_D(SI_No,MODEL_NO,MODEL_DESC,SHIP_QTY,LOT_NO) select '" & trim(SINo) & "',MODEL_NO,MODEL_DESC,SHIP_QTY,LOT_NO from Ship_Notice_D where SN_No= '" & trim(lblSNNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update Sales_Invoice_D set Sales_Invoice_D.UP = Model_Master.UP from Sales_Invoice_D,Model_Master where Sales_Invoice_D.SI_No = '" & trim(SINo) & "' and Sales_Invoice_D.Model_No = Model_Master.Model_Code")
        ReqCOM.ExecuteNonQuery("Update Ship_Notice_M set SI_No = '" & trim(SINo) & "' where SN_No = '" & trim(lblSNNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update Main set SI_No = SI_No + 1")
        ShowAlert("Explosion Completed. \n Sales Invoice no : " & trim(SINo))
        redirectPage("ShippingNoticeDet.aspx?ID=" & Request.params("ID"))
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
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">SALES ORDER
                            DETAILS - BY MODEL</asp:Label>
                        </p>
                        <p align="center">
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="70%" align="center" border="1">
                                <tbody>
                                    <tr>
                                        <td width="30%" bgcolor="silver">
                                            <asp:Label id="Label8" runat="server" width="116px" cssclass="LabelNormal" height="0px">Shipping
                                            Notice No</asp:Label></td>
                                        <td width="70%">
                                            <asp:Label id="lblSNNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label3" runat="server" width="116px" cssclass="LabelNormal" height="0px">Customer</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCustname" runat="server" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label2" runat="server" width="116px" cssclass="LabelNormal">Shipping
                                            Date</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblShipDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" bgcolor="silver">
                                            <asp:Label id="Label5" runat="server" width="116px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtRem" onkeydown="GetFocusWhenEnterWithoutSelect(cmbShipCo)" runat="server" CssClass="OutputText" Width="100%" TextMode="MultiLine" Height="64px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label6" runat="server" width="116px" cssclass="LabelNormal">Mode Of
                                            Delivery</asp:Label></td>
                                        <td>
                                            <asp:DropDownList id="cmbModeOfDel" runat="server" CssClass="OutputText" Width="260px">
                                                <asp:ListItem Value="TRUCK">TRUCK</asp:ListItem>
                                                <asp:ListItem Value="AIR FREIGHT">AIR FREIGHT</asp:ListItem>
                                                <asp:ListItem Value="CONTAINER 40FT">CONTAINER 40FT</asp:ListItem>
                                                <asp:ListItem Value="CONTAINER 20FT">CONTAINER 20FT</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label7" runat="server" width="116px" cssclass="LabelNormal">Mode Of
                                            Freight</asp:Label></td>
                                        <td>
                                            <asp:DropDownList id="cmbModeOfFreight" runat="server" CssClass="OutputText" Width="260px">
                                                <asp:ListItem Value="PREPAID">PREPAID</asp:ListItem>
                                                <asp:ListItem Value="COLLECT">COLLECT</asp:ListItem>
                                                <asp:ListItem Value="OTHERS">OTHERS</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p align="left">
                            <table style="HEIGHT: 12px" width="90%" align="center">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p align="left">
                                                <asp:LinkButton id="lnkAddItem" onclick="lnkAddItem_Click" runat="server" CssClass="OutputText" Width="100%">Click here to add item to Shipping Notice</asp:LinkButton>
                                                <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnEditCommand="ShowSO" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <Columns>
                                                        <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                        <asp:TemplateColumn HeaderText="Lot #">
                                                            <ItemTemplate>
                                                                <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="J/O No">
                                                            <ItemTemplate>
                                                                <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_No") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Model Desc.">
                                                            <ItemTemplate>
                                                                <asp:Label id="ModelDesc" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_Desc") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Ship. Qty">
                                                            <ItemTemplate>
                                                                <asp:Label id="ShipQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ship_Qty") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Pallet No">
                                                            <ItemTemplate>
                                                                <asp:textbox id="PalletNo" Width="50px" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Pallet_No") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Carton No">
                                                            <ItemTemplate>
                                                                <asp:textbox id="CartonNo" Width="50px" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Carton_No") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Load. prio.">
                                                            <ItemTemplate>
                                                                <asp:Textbox id="LoadingPriority" Width="50px" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Loading_Priority") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Remarks">
                                                            <ItemTemplate>
                                                                <asp:Textbox id="Rem" TextMode="MultiLine" CssClass="OutputText" Width="300px" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Remove" >
                                                            <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                            <ItemStyle horizontalalign="Center"></ItemStyle>
                                                            <ItemTemplate>
                                                                <center>
                                                                    <asp:CheckBox id="Remove" runat="server" />
                                                                </center>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn Visible= "false">
                                                            <ItemTemplate>
                                                                <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </p>
                                            <p align="center">
                                                <table style="HEIGHT: 7px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%">
                                                                <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="165px" Text="Refresh Shipping Notice"></asp:Button>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="center">
                                                                    <asp:Button id="cmdExplode" onclick="cmdExplode_Click" runat="server" Text="Explode to Invoice" Enabled="False"></asp:Button>
                                                                </div>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="center">
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="167px" Text="Update item details" Enabled="False"></asp:Button>
                                                                </div>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="right">
                                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="130px" Text="Back"></asp:Button>
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
