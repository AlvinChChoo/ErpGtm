<%@ Page Language="VB" Debug="True" %>
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
                 Dim ReqCOm as Erp_Gtm.Erp_Gtm = New Erp_Gtm.ERp_Gtm
                 Dim rsSR as SQLDataReader = ReqCOM.ExeDataReader("Select * from SR_M where seq_no = " & request.params("ID") & ";")
    
                 do while rsSR.read
                    lblCreateBy.text = rsSR("Create_By").tostring
                    lblCreateDate.text = format(cdate(rsSR("Create_Date")),"dd/MMM/yy")
                    lblSRNo.text = rsSR("SR_NO").tostring
                    lblRemarks.text = rsSR("Remarks").tostring
    
    
    
    
                 Loop
                 rsSR.close()
                 LoadSRItem()
             end if
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
    
                 Dim oList As ListItemCollection = obj.Items
    
         End Sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub Button2_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdAddNew_Click(sender As Object, e As EventArgs)
             response.redirect("CustomerAddNew.aspx")
         End Sub
    
         Sub UserControl2_Load(sender As Object, e As EventArgs)
         End Sub
    
    
    
         Sub ValDuplicatePartNo(sender As Object, e As ServerValidateEventArgs)
             Dim ReqCOM as ERp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
             if ReqCOM.GetFieldVal("Select Part_No from SR_D where SR_NO = '" & trim(lblSRNo.text) & "' and Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_No") = "" then
                 e.isvalid = true
             else
                 e.isvalid = false
             end if
         End Sub
    
         Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim rsSR as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
    
             Do while rsSR.read
                 lblPartDesc.text = rsSR("Part_Desc").tostring
                 lblPartSpec.text = rsSR("Part_Spec").tostring
             Loop
             rsSR.close()
         End Sub
    
         Sub LoadSRItem()
             Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
             Dim StrSql as string = "Select sr.eta_date,sr.spare_qty,sr.req_qty+sr.spare_qty as [TotalQty],SR.Lot_No,SR.Seq_No,PM.PART_DESC,PM.PART_SPEC,SR.REQ_QTY,SR.PART_NO from SR_D SR, PART_MASTER PM where SR.SR_NO = '" & trim(lblSRNo.text) & "' AND SR.PART_NO = PM.PART_NO"
             Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
             dtgSRItem.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
             dtgSRItem.DataBind()
         end sub
    
         Sub cmdAddItem_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim StrSql as string
                StrSql = "Insert into SR_D(SR_NO,Part_No,Lot_No,SO_QTY,P_Usage,Cal_Qty,Req_Qty,Spare_Qty,ETA_Date) "
                StrSql = StrSql & "Select '" & trim(lblSRNo.text) & "','" & trim(cmbPartNo.selectedItem.value) & "','" & trim(cmbLotNo.selecteditem.value) & "'," & cdec(lblOrderQty.text) & "," & lblUsage.text & "," & lblTotalQty.text & "," & txtreqQty.text & "," & cdec(txtSpareQty.text) & ",'" & cdate(txtReqDate.text) & "';"
    
    
                ReqCOM.ExecuteNonQuery(StrSql)
                response.redirect("SpecialRequestAddNew1.aspx?ID=" & Request.params("ID"))
             End if
         End Sub
    
    
    
         Sub dtgSRItem_SelectedIndexChanged(sender As Object, e As EventArgs)
    
         End Sub
    
         Sub txtQty_TextChanged(sender As Object, e As EventArgs)
    
         End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
    
    
        if cmblotno.selectedindex = -1 then exit sub
    
    
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ModelNo as string = ReqCOM.GetfieldVal("Select Model_No from SO_Model_M where Lot_No = '" & trim(cmbLotNo.selecteditem.value) & "';","Model_No")
        cmbPartNo.items.clear
        'ClearDet
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' and part_no in (Select Part_no from BOM_D where Model_No = '" & trim(ModelNo) & "') order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex = 0 then
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    
            lblUsage.text = Reqcom.GetFieldVal("Select P_Usage from BOM_D where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and Model_No in (Select model_No from so_model_m where lot_no = '" & trim(cmbLotNo.selecteditem.value) & "')","P_Usage")
            lblTotalQty.text = cdec(lblUsage.text) * cdec(lblOrderQty.text)
    
        end if
        txtSearchPart.text = "-- Search --"
    End Sub
    
    Sub cmdLotNo_Click(sender As Object, e As EventArgs)
        Dim LotNo as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbLotNo.items.clear
        'ClearDet
        Dissql ("Select Lot_No from SO_Model_M where Lot_no like '%" & cstr(txtLotNo.Text) & "%' order by Lot_No asc","Lot_No","Lot_No",cmbLotNo)
    
        if cmbLotNo.selectedindex = 0 then
    
            lblOrderQty.text = Reqcom.GetFieldVal("Select Order_Qty from SO_Model_M where Lot_No = '" & trim(cmbLotNo.selecteditem.value) & "';","Order_Qty")
            'lblTotalQty.text = cdec(lblUsage.text) * cdec(lblOrderQty.text)
    
        end if
        txtlOTnO.text = "-- Search --"
    End Sub
    
    Sub cmbLotNo_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("SpecialRequestDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To dtgSRItem.Items.Count - 1
            Dim SeqNo As Label = CType(dtgSRItem.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgSRItem.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from SR_D where Seq_no = " & trim(SeqNo.text) & ";")
                end if
            Catch
               ' MyError.Text = "There has been a problem with one or more of your inputs."
            End Try
        Next
        Response.redirect("SpecialRequestAddNew1.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ETADate As Label = CType(e.Item.FindControl("ETADate"), Label)
            Dim SpareQty As Label = CType(e.Item.FindControl("SpareQty"), Label)
            Dim ReqQty As Label = CType(e.Item.FindControl("ReqQty"), Label)
            Dim TotalQty As Label = CType(e.Item.FindControl("TotalQty"), Label)
    
            ETADate.text = format(cdate(ETADate.text),"dd/MMM/yy")
            SpareQty.text = format(cdec(SpareQty.text),"##,##0")
            ReqQty.text = format(cdec(ReqQty.text),"##,##0")
            TotalQty.text = format(cdec(TotalQty.text),"##,##0")
        End if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW SPECIAL
                                REQUEST REGISTRATION</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Lot No" ForeColor=" " ControlToValidate="cmbLotNo" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No" ForeColor=" " ControlToValidate="cmbPartNo" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Delivery Date" ForeColor=" " ControlToValidate="txtReqDate" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Qty To Order." ForeColor=" " ControlToValidate="txtReqQty" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="ValPODate" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Delivery Date." ForeColor=" " ControlToValidate="txtReqDate" Display="Dynamic" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:comparevalidator id="ValOrderQtyFormat" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Qty To Order" ForeColor=" " ControlToValidate="txtReqQty" Display="Dynamic" EnableClientScript="False" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">S/R No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSRNo" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Requested By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateBy" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Date Requested</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateDate" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRemarks" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 10px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Label id="Label12" runat="server" width="100%" cssclass="Instruction">To add
                                                                        item to S/R for, pleas select Part No and Request Qty and click "ADD TO S/R FORM"</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtlotno" onkeydown="KeyDownHandler(cmdLotNo)" onclick="GetFocus(txtlotno)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdLotNo" onclick="cmdLotNo_Click" runat="server" CssClass="OutputText" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                                        <asp:DropDownList id="cmbLotNo" runat="server" CssClass="OutputText" Width="361px" OnSelectedIndexChanged="cmbLotNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                                        <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="361px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label18" runat="server" cssclass="LabelNormal">Delivery Date</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtReqDate" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label17" runat="server" cssclass="LabelNormal">Qty. To Order</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtReqQty" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Spare Qty.</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSpareQty" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartDesc" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartSpec" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label15" runat="server" cssclass="LabelNormal">Usage</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblUsage" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Order Qty</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblOrderQty" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Total Qty.</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblTotalQty" runat="server" width="324px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdAddItem" onclick="cmdAddItem_Click" runat="server" Text="Add To S/R Form"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:DataGrid id="dtgSRItem" runat="server" width="100%" Height="9px" OnSelectedIndexChanged="dtgSRItem_SelectedIndexChanged" Font-Name="Verdana" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow">
                                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <Columns>
                                                                            <asp:TemplateColumn visible="false" HeaderText="">
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="PART_DESC" HeaderText="Description"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Lot_No" HeaderText="Lot No"></asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="ETA Date" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="ETADate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ETA_DAte") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Spare Qty" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="SpareQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Spare_Qty") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Req Qty" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="ReqQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REQ_QTY") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Total Qty" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="TotalQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TotalQty") %>' /> 
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
                                                                    </asp:DataGrid>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="168px" Text="Remove Selected Item" CausesValidation="False"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="128px" Text="Back" CausesValidation="False"></asp:Button>
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
        <p>
        </p>
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
