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
            Dim RsMIF as SQLDataReader = ReqCOM.exeDataReader("Select * from MIF_M where Seq_No = " & Request.params("ID") & ";")
            Dim QtyDel as decimal
            Dim CurrDate as date = format(now,"MM/dd/yyyy")
    
            Do while rsMIF.read
                lblMIFDate.text = rsMIF("MIF_DATE").tostring
                lblInvNo.text = rsMIF("INV_NO").tostring
                lblSupplier.text = rsMIF("VEN_CODE").tostring
                txtRem.text = rsMIF("REM").tostring
                lblDONo.text = rsMIF("DO_NO").tostring
                lblCustomFormNo.text = rsMIF("CUSTOM_FORM_NO").tostring
                lblMIFNo.text = rsMIF("MIF_NO").tostring
            Loop
    
            Dissql("Select PO_NO from PO_M where Ven_Code = '" &trim(lblSupplier.text) & "';","PO_NO","PO_NO",cmbPONo)
    
            if cmbpono.selectedindex = 0 then
                Dissql("Select Part_No + '   |   ' + CONVERT(char(12), Del_Date, 1)  as [Part_No],Seq_No from PO_D where PO_NO = '" & trim(cmbPONo.selectedItem.Text) & "' and Sch_Date = '" & cdate(CurrDate) & "';","Seq_No","Part_No",cmbPartNo)
            End if
    
            if cmbPartNo.selectedindex = 0 then
                DisplayPartQty()
            End if
    
            ShowMifDet()
        end if
    End Sub
    
    Sub ShowMifDet()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        'Dim StrSql as string = "Select MIF.IN_QTY,MIF.Del_Date,MIF.Seq_No,MIF.po_no,MIF.bal_qty, PM.Part_No,PM.Part_Desc from mif_D MIF, Part_Master PM where MIF.Part_No = PM.Part_No order by mif.seq_no asc"
        Dim StrSql as string = "Select MIF.IN_QTY,MIF.Del_Date,MIF.Seq_No,MIF.po_no, PM.Part_No,PM.Part_Desc from mif_D MIF, Part_Master PM where MIF.Part_No = PM.Part_No AND MIF_NO = '" & TRIM(lblMIFNo.text) & "' order by mif.seq_no asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MIF_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(4).Text = format(cdate(e.Item.Cells(4).Text),"MM/dd/yy")
            Dim InQty As Label = CType(e.Item.FindControl("InQty"), Label)
            InQty.text = cint(InQty.text)
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
    
    Sub cmbPONo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim CurrDate as date = format(now,"MM/dd/yyyy")
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update PO_D set SCH_Date = Del_Date where po_no = '" & trim(cmbPONo.selectedItem.value) & "' and Sch_Date is null")
        Dissql("Select Part_No + '   |   ' + CONVERT(char(12), SCH_Date, 3)  as [Part_No],Seq_No from PO_D where PO_NO = '" & trim(cmbPONo.selectedItem.Text) & "' and Sch_Date = '" & cdate(CurrDate) & "';","Seq_No","Part_No",cmbPartNo)
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim QtyDel as decimal
    
        DisplayPartQty()
    
    End Sub
    
    Sub DisplayPartQty()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblOrderQty.text = ReqCOM.GetFieldVal("Select Order_Qty from PO_D where Seq_No = " & cmbPartNo.selectedItem.value & ";","Order_Qty")
        lblQtyDel.text = ReqCOM.GetFieldVal("Select In_Qty from PO_D where Seq_no = " & cint(cmbPartNo.selecteditem.value) & ";","IN_QTY")
        lblBalQty.text = cint(lblOrderQty.text) - cint(lblQtyDel.text)
    End sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Part_No")
            Dim ETADate as datetime = ReqCOM.GetFieldVal("Select Del_Date from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Del_Date")
            Try
                StrSql = "Insert into MIF_D(MIF_NO,PO_NO,PART_NO,IN_QTY,Del_Date,Date_Receive) "
                StrSql = StrSql + "Select '" & trim(lblMIFNo.text) & "','" & trim(cmbPONo.selectedItem.text) & "','" & trim(PartNo) & "'," & cint(txtInQty.text) & ",'" & cdate(ETADate) & "','" & now & "';"
                ReqCOM.ExecuteNonQuery(StrSql)
            Catch Err as exception
                response.write(err.tostring())
            End try
            response.redirect("MIFAddNew1.aspx?ID=" & request.params("ID"))
        End if
    End Sub
    
    Sub ValSources(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.FuncCheckDuplicate("Select Part_No from mif_d where MIF_NO = '" & trim(lblMIFNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.text) & "' and PO_NO = '" & trim(cmbPONo.selecteditem.text) & "';","Part_No") = true then
            e.isvalid = false
        End if
    End Sub
    
    Sub ValInQty(sender As Object, e As ServerValidateEventArgs)
        if txtInQty.text = "" then exit sub
        if isnumeric(txtInQty.text) = false then exit sub
        if cint(txtInQty.text) > cint(lblBalQty.text) then e.isvalid = false
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i As Integer
        Dim strSql as string
        Dim InputError as string = "N"
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Dim remove As CheckBox = CType(dtgPartWithSource.Items(i).FindControl("Remove"), CheckBox)
            Dim SeqNo As Label = CType(dtgPartWithSource.Items(i).FindControl("lblSeqNo"), Label)
            Dim BalQty As Label = CType(dtgPartWithSource.Items(i).FindControl("BalQty"), Label)
            Dim InQty As TextBox = CType(dtgPartWithSource.Items(i).FindControl("Quantity"), Textbox)
    
            If remove.Checked = true Then
                Try
                    ReqCOM.ExecuteNonQuery("Delete from MIF_D where SEQ_NO = " & SeqNo.text & ";")
                Catch err as exception
                End Try
            end if
        Next
        Response.redirect("MIFAddNew1.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdProceed_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        'Dim MIFNo as string = ReqCOM.GetDocumentNo("MIF_No")
    
        try
            StrSql = "Update Part_Master set Part_Master.IQC_BAL = Part_Master.IQC_BAL + MIF_D.IN_QTY, Part_Master.OPEN_PO = Part_Master.OPEN_PO - MIF_D.IN_QTY FROM MIF_D, PART_MASTER WHERE MIF_D.MIF_NO = '" & Trim(lblMIFNo.text) & "' and MIF_D.Part_NO = Part_Master.Part_No"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update PO_D set PO_D.In_Qty = PO_D.In_Qty + MIF_D.IN_QTY from MIF_D,PO_D where MIF_D.MIF_NO = '" & trim(lblMIFNo.text) & "' and po_d.po_no = mif_D.po_no and po_d.part_no = mif_D.part_no and po_d.del_date = mif_D.del_date"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Insert into IQC_Movement(PART_NO,REF,QTY_IN,QTY_OUT,TRANS_TYPE,TRANS_DATE) "
            StrSql = StrSql + "Select PART_NO,'" & trim(lblMIFNo.text) & "',IN_QTY,0,'IQC','" & now & "' from MIF_D where mif_no = '" & trim(lblMIFNo.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            response.redirect("MIFAddNew3.aspx?ID=" & Request.params("ID"))
        Catch err as exception
            response.write(Err.tostring)
        End try
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'ReqCOM.ExecuteNonQUery("Delete from MIF_D_Temp where U_ID = '" & trim(Request.cookies("U_ID").value) & "';")
        'Response.redirect("MIF.aspx")
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Dim CurrDate as date = format(now,"MM/dd/yyyy")
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update PO_D set SCH_Date = Del_Date where po_no = '" & trim(cmbPONo.selectedItem.value) & "' and Sch_Date is null")
        Dissql("Select Part_No + '   |   ' + CONVERT(char(12), Del_Date, 1)  as [Part_No],Seq_No from PO_D where PO_NO = '" & trim(cmbPONo.selectedItem.Text) & "' and Sch_Date = '" & cdate(CurrDate) & "';","Seq_No","Part_No",cmbPartNo)
    
        if cmbPartNo.selectedindex = 0 then DisplayPartQty()
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">MATERIAL INCOMING
                                FORM (MIF) ITEM</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="left">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" OnServerValidate="ValSources" EnableClientScript="False" ErrorMessage="Item already exist in MIF."></asp:CustomValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="ValOrderQty" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid In Quantity." ControlToValidate="txtInQty"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:comparevalidator id="ValOrderQtyFormat" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid In Quantity." ControlToValidate="txtInQty" Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                </p>
                                                <p align="left">
                                                    <asp:CustomValidator id="CustomValidator2" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" OnServerValidate="ValInQty" EnableClientScript="False" ErrorMessage="In quantity cannot be greater than balance quantity."></asp:CustomValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid P/O No." ControlToValidate="cmbPONo"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Part No." ControlToValidate="cmbPartNo"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 77px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label7" runat="server" width="142px" cssclass="LabelNormal">MIF No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" width="142px" cssclass="LabelNormal">MIF Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFDate" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" width="142px" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSupplier" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" width="142px" cssclass="LabelNormal">Invoice
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblInvNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label15" runat="server" width="142px" cssclass="LabelNormal">D/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDONo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label16" runat="server" width="142px" cssclass="LabelNormal">Custom
                                                                    Form No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCustomFormNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label10" runat="server" width="142px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" Width="402px" CssClass="OutputText" ReadOnly="True" TextMode="MultiLine" Height="78px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 77px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label1" runat="server" width="118px" cssclass="LabelNormal">P/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbPONo" runat="server" Width="435px" CssClass="OutputText" autopostback="True" OnSelectedIndexChanged="cmbPONo_SelectedIndexChanged"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" width="138px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbPartNo" runat="server" Width="435px" CssClass="OutputText" autopostback="true" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged"></asp:DropDownList>
                                                                    &nbsp; 
                                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" CausesValidation="False" Text="Refresh"></asp:Button>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" width="94px" cssclass="LabelNormal">Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtInQty" runat="server" Width="221px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" width="124px" cssclass="LabelNormal">Order Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblOrderQty" runat="server" width="435px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label11" runat="server" width="130px" cssclass="LabelNormal">Qty. Delivered</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblQtyDel" runat="server" width="435px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label12" runat="server" width="82px" cssclass="LabelNormal">Bal. Qty.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBalQty" runat="server" width="435px" cssclass="OutputText"></asp:Label></td>
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
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" Width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PO_NO" HeaderText="P/O No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_dESC" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Del_Date" HeaderText="ETA Date">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Incoming Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="InQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "In_Qty") %>' /> 
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
                                                                    <asp:Button id="cmdProceed" onclick="cmdProceed_Click" runat="server" Width="95px" CausesValidation="False" Text="Proceed"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="148px" CausesValidation="False" Text="Update List"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="95px" CausesValidation="False" Text="Cancel"></asp:Button>
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