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
                Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                Dim rs1 as SQLDataReader = ReqCOM.ExeDataReader("Select MRF.LOT_NO,MRF.MRF_NO,SO.ORDER_QTY,SO.MODEL_NO from MRF_M MRF, SO_MODEL_M SO where MRF.Seq_No = " & request.params("ID") & " AND MRF.LOT_NO = SO.LOT_NO")
    
                do while rs1.read
                    lblMRFNo.text = rs1("MRF_No").tostring
                    lblLotNo.text = rs1("Lot_No").tostring
                    lblModelNo.text = rs1("Model_No").tostring
                    lblLotSize.text = rs1("Order_Qty").tostring
                loop
                rs1.close
                ProcLoadGridData
            end if
        End Sub
    
        Sub ProcLoadGridData()
            Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim StrSql as string = "Select mrf.seq_no,mrf.rem,MRF.PART_NO,MRF.QTY_RETURN,MRF.P_LEVEL,PM.PART_DESC,PM.PART_SPEC from MRF_D mrf, PART_MASTER PM where MRF.mrf_no = '" & trim(lblMRFNo.text) & "' AND MRF.PART_NO = PM.PART_NO"
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
            GridControl1.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
            GridControl1.DataBind()
        end sub
    
        Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
        End Sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
             If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
             End if
        End Sub
    
        Sub cmdGo_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
            cmbPartNo.items.clear
            Dissql ("Select Part_No,Part_No as [Desc] from Part_Master where part_no in (Select Part_No from Issuing_Trail where Part_No like '%" & trim(txtSearchPart.text) & "%' and lot_no = '" & trim(lblLotNo.text) & "') order by Part_No asc","Part_No","Desc",cmbPartNo)
    
            if cmbPartNo.selectedindex = 0 then
                Dissql ("Select Distinct(P_Level) as PLevel from Issuing_Trail where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","PLevel","PLevel",cmbLevel)
                lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
                lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
                lblQtyIssued.text = ReqCOM.GetFieldVal("Select sum(Req_Qty) as [TotalIssued] from Issuing_Trail where Lot_No = '" & trim(lblLotNo.text) & "' and part_No = '" & trim(cmbPartNo.selecteditem.value) & "' and P_Level = '" & trim(cmbLevel.selecteditem.value) & "';","TotalIssued")
                txtSearchPart.text = "-- Search --"
            Else
                txtSearchPart.text = "-- Search --"
                cmbLevel.items.clear
                txtReturnQty.text = ""
                lblPartSpec.text = ""
                lblPartDesc.text = ""
                lblQtyIssued.text = ""
                lblQtyIssued.text = ""
                ShowAlert("Invalid Part No.")
            end if
        End Sub
    
        Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
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
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmdAdd_Click(sender As Object, e As EventArgs)
            If page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                ReqCom.ExecuteNonQuery("Insert into MRF_D(MRF_NO,Part_No,Qty_Return,P_Level,Rem,Return_Type) select '" & trim(lblMRFNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "'," & cdec(txtReturnQty.text) & ",'" & trim(cmbLevel.selecteditem.value) & "','" & trim(replace(txtRemarks.text,"'","`")) & "','" & trim(cmbReturnType.selecteditem.value) & "';")
                Response.redirect("PopupMRFItem.aspx?ID=" & Request.params("ID"))
            end if
        End Sub
    
        Sub ValInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
            if clng(txtReturnQty.text) <= 0 then e.isvalid = false : ValInput.errormessage = "You don't seem to have supplied a valid Qty. Return"
            if clng(txtReturnQty.text) > clng(lblQtyIssued.text) then e.isvalid = false: ValInput.errormessage = "Qty. return not tally"
        End Sub
    
        Sub cmdRemove_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
            Dim i As Integer
            Dim remove As CheckBox
            Dim SeqNo As Label
    
            For i = 0 To GridControl1.Items.Count - 1
                remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
                SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
                if remove.checked = true then
                    ReqCOM.ExecuteNonQuery("Delete from MRF_D where Seq_No = " & SeqNo.text & ";")
                end if
            next
            ProcLoadGridData
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
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">MRF
                                ITEM</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Qty. return" ForeColor=" " Display="Dynamic" ControlToValidate="txtReturnQty"></asp:RequiredFieldValidator>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValInput" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" OnServerValidate="ValInput_ServerValidate" EnableClientScript="False"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid remarks" ForeColor=" " Display="Dynamic" ControlToValidate="txtRemarks"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="128px" cssclass="LabelNormal">MRF No</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:Label id="lblMRFNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="128px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" width="128px" cssclass="LabelNormal">Lot Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotSize" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                    <asp:DropDownList id="cmbPartNo" runat="server" Width="355px" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" width="128px" cssclass="LabelNormal">Level</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbLevel" runat="server" Width="166px" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" width="128px" cssclass="LabelNormal">Qty Return</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtReturnQty" runat="server" Width="166px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="128px" cssclass="LabelNormal">Type</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbReturnType" runat="server" Width="166px" CssClass="OutputText">
                                                                        <asp:ListItem Value="INCOMING">Incoming</asp:ListItem>
                                                                        <asp:ListItem Value="PRODUCTION">Production</asp:ListItem>
                                                                        <asp:ListItem Value="OTHERS">Others</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" width="128px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRemarks" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" width="128px" cssclass="LabelNormal">Qty Issued</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblQtyIssued" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" width="128px" cssclass="LabelNormal">Part Desc.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartDesc" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" width="128px" cssclass="LabelNormal">Part Spec.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartSpec" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="129px" Text="Add To List"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Qty Return">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReturn" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Return") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Level">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Level") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remarks">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Rem" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' /> 
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
                                                <p align="right">
                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="188px" Text="Remove selected item" CausesValidation="False"></asp:Button>
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
