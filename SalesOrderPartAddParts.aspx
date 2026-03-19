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
        if page.ispostback = false then
            if request.cookies("U_ID") is nothing then response.redirect("AccessDenied.aspx")
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim strSql as string = "Select * from SO_Part_M where SEQ_NO = " & cint(request.params("ID")) & ";"
            Dim Result as SQLDataReader = ReqCOM.ExeDataReader(strSql)
    
            do while Result.read
                lblLotNo.text = Result("Lot_No")
                lblCustCode.text = Result("Cust_Code")
                lblPONo.text = Result("PO_No")
                lblPODate.text = format(cdate(Result("PO_Date")),"dd/MM/yy")
                lblCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(lblCustCode.text) & "';","Cust_Name")
            loop
            ProcLoadGridData
            if GridControl1.items.count > 0 then lblTotal.text = "Total  :  " & format(cdec(ReqCOM.GetFieldVal("Select Sum(Invoice_Total) as [SubTotal] from SO_Part_D where lot_no = '" & trim(lblLotNo.text) & "';","SubTotal")),"##,##0.00")
    
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim strSql as string = "Select * from SO_Part_D where LOT_No = '" & trim(lblLOTNo.text) & "'"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_PART_D")
        GridControl1.DataSource=resExePagedDataSet.Tables("SO_PART_D").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub Dissql(ByVal strSql As String,FValue as string,FText as string,Obj as Object)
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
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Dim StrSql as string
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim PartDesc as string
    
        if ReqCOM.FuncCheckDuplicate("Select top 1 Part_No from Part_master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_No") = true then
            PartDesc = ReqCOM.GetFieldVal("select top 1 Part_Desc from part_master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_Desc")
        else
            PartDesc = "-"
        end if
    
        StrSql = "Insert into SO_Part_D "
        StrSql = StrSql + "(Lot_No,Part_No,Part_Desc,Part_Spec,Part_Qty,Invoice_UP,Invoice_Total) "
        StrSql = StrSql + "Select '" & trim(lblLotNo.text) & "',"
        StrSql = StrSql + "'" & trim(cmbPartNo.selectedItem.value) & "',"
    
        if trim(cmbPartNo.selecteditem.value) = trim(cmbPartNo.selecteditem.text) then StrSql = StrSql + "'" & txtSpec.text & "',"
        if trim(cmbPartNo.selecteditem.value) <> trim(cmbPartNo.selecteditem.text) then StrSql = StrSql + "'" & lblSpec.text & "',"
    
        StrSql = StrSql + "'" & trim(PartDesc) & "',"
        StrSql = StrSql + "" & txtQty.text & ","
        StrSql = StrSql + "" & txtUP.text & "," & txtUP.text & " * " & cint(txtQty.text) & ";"
        ReqCOM.ExecuteNonQuery(StrSql)
        ProcLoadGridData()
        txtQty.text = ""
        txtUP.text = ""
        response.redirect("SalesOrderPartAddParts.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim i As Integer
    
        For i = 0 To gridcontrol1.Items.Count - 1
            Dim Qty As TextBox = CType(gridcontrol1.Items(i).FindControl("Qty"), TextBox)
            Dim UP as decimal
            Dim txtUnitPrice As TextBox = CType(gridcontrol1.Items(i).FindControl("UP"), TextBox)
            Dim SeqNo As Label = Ctype(gridcontrol1.Items(i).FindControl("lblSeqNo"), Label)
            Dim quantity as Integer
    
            Try
                quantity = CInt(Qty.Text)
                UP = txtUnitPrice.text
    
                    ReqCOM.ExecuteNonQuery("Update SO_Part_D set Part_Qty = " & Quantity & ",Invoice_UP = " & UP & " where Seq_No = " & SeqNo.text & ";")
                    ReqCOM.ExecuteNonQuery("Update SO_Part_D set Invoice_Total = Invoice_UP * Part_Qty where Seq_No = " & SeqNo.text & ";")
    
            Catch Err as exception
                response.write(err.tostring)
    
            End Try
        Next
        response.redirect("SalesOrderPartAddParts.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        ShowPartDet()
    End Sub
    
    Sub ShowPartDet()
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        lblSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_Spec")
        'lblUnit.text = ReqCOM.GetFieldVal("Select UOM from Part_Master where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","UOM")
        txtUP.text = ReqCOM.GetFieldVal("Select UP from Part_Master where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","UP")
    End Sub
    
    Sub ValDuplicatePartNo(sender As Object, e As ServerValidateEventArgs)
        'Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        'Dim StrSQL as string = "Select * from SO_Part_D where LOT_NO = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(cmbPartNo.selecteditem.Value) & "';"
    
        'If ReQCOM.FuncCheckDuplicate(StrSql,"Part_No") = true then
        '    e.isvalid= false
        'else
        '    e.isvalid = true
        'end if
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim Qty,UP As textbox
    
    
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Qty = CType(e.Item.FindControl("Qty"), textbox)
            UP = CType(e.Item.FindControl("UP"), textbox)
            Qty.text = cint(Qty.text)
            UP.text = format(cdec(UP.text),"##,##0.00")
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPartDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbPartNo.items.clear
        if ReqCOM.FuncCheckDuplicate("Select top 1 part_no from Part_Master where part_no = '" & trim(txtSearchPart.text) & "';","Part_No") = true then
            Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no + Part_Desc like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
            ShowPartDet()
            txtSpec.visible = false
            lblSpec.visible = true
            txtSearchPart.text = "-- Search --"
        else
            Dim oList As ListItemCollection = cmbPartNo.Items
            oList.Add(New ListItem(txtSearchPart.text))
    
            lblSpec.text = ""
            txtSpec.visible = true
            lblSpec.visible = false
            'lblUnit.text =  ""
            txtUP.text =  ""
            txtSearchPart.text = "-- Search --"
        end if
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim lblSeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQUery("Delete from SO_Part_D where seq_no = " & clng(lblSeqNo.text) & ";") : response.redirect("SalesOrderPartAddParts.aspx?ID=" & clng(request.params("ID")))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label37" runat="server" cssclass="FormDesc" width="100%">SALES ORDER
                                DETAILS (PARTS)</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:CustomValidator id="DuplicatePartNo" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" OnServerValidate="ValDuplicatePartNo" ForeColor=" " Display="Dynamic" ErrorMessage="Part No already exist."></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:comparevalidator id="ValQtyFormat" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid quantity." ControlToValidate="txtQty" Type="Integer" Operator="DataTypeCheck"></asp:comparevalidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="ValQty" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid quantity." ControlToValidate="txtQty"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid quantity." ControlToValidate="txtQty" Type="Integer" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:comparevalidator id="CompareValidator2" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid unit price. " ControlToValidate="txtUP" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid unit price. " ControlToValidate="txtUP"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Part No." ControlToValidate="cmbPartNo"></asp:RequiredFieldValidator>
                                                </div>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="20%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                <td width="40%">
                                                                    <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="178px"></asp:Label></td>
                                                                <td width="15%" bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">P/O No</asp:Label></td>
                                                                <td width="25%">
                                                                    <asp:Label id="lblPONo" runat="server" cssclass="OutputText" width="178px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Cust Details</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>-<asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">P/O Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPODate" runat="server" cssclass="OutputText" width="178px"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="96px">Part No</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="15%">
                                                                                    <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="96%" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                                </td>
                                                                                <td width="10%">
                                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Width="96%" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                                </td>
                                                                                <td width="75%">
                                                                                    <asp:DropDownList id="cmbPartNo" runat="server" Width="100%" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="96px">Specification</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblSpec" runat="server" cssclass="OutputText"></asp:Label>
                                                                        <asp:TextBox id="txtSpec" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" width="96" bgcolor="silver" text="Quantity"></asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtQty" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" width="96" bgcolor="silver" text="Unit Price"></asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUP" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="4">
                                                                    <p align="center">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="167px" Text="Add part to sales order"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" CellPadding="2" AutoGenerateColumns="False" GridLines="Vertical" BorderColor="Linen" OnItemDataBound="FormatRow" OnItemCommand="ItemCommand">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_No" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Spec" HeaderText="Specification"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="UP" CssClass="OutputText" runat="server" align="right" Text='<%# DataBinder.Eval(Container.DataItem, "Invoice_UP") %>' width="50px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Qty" CssClass="OutputText" runat="server" align="right" Text='<%# DataBinder.Eval(Container.DataItem, "Part_Qty") %>' width="50px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="INVOICE_Total" HeaderText="TOTAL" DataFormatString="{0:F}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Remove">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                                    </asp:DataGrid>
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblTotal" runat="server" width="267px" backcolor="LightGray" font-names="Verdana"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="162px" Text="Update sales order item" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="151px" Text="Back" CausesValidation="False"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
