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
        if page.ispostback = false then ShowDet:ProcLoadGridData
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowDet()
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim StrSql as string = "Select pr.part_no,pr.pr_no,pr.pr_qty,pm.part_desc,pm.part_spec from PR1_D pr,part_master pm where pr.Seq_No = " & clng(request.params("ID")) & " and pm.part_no = pr.part_no"
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            lblPartNoB4.text = drGetFieldVal("Part_No")
            lblPRNo.text = drGetFieldVal("PR_No")
            lblPRQtyB4.text = drGetFieldVal("PR_QTY")
            lblPartDescB4.text = drGetFieldVal("Part_Desc")
            lblPartSpecB4.text = drGetFieldVal("Part_Spec")
        loop
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbPartNo.items.clear
        Dissql ("Select Part_No,Part_No as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' and part_no in (select part_no from part_source) order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex = 0 then
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    
            lblVenCode.text = ReqCOM.GetFieldVal("Select top 1 Ven_Code from part_source where ven_seq = 1 and part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Ven_Code")
            txtSearchPart.text = "-- Search --"
            lblVenName.text = ReqCOM.GetFieldVal("Select Ven_Name from Vendor where ven_Code = '" & trim(lblVenCode.text) & "';","Ven_Name")
            lblMOQ.text = format(clng(ReqCOM.GetFieldVal("Select top 1 min_order_qty from part_source where ven_code = '" & trim(lblVenCode.text) & "' and part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Min_Order_Qty")),"##,##0")
            lblSPQ.text = format(clng(ReqCOM.GetFieldVal("Select top 1 std_pack_qty from part_source where ven_code = '" & trim(lblVenCode.text) & "' and part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Std_Pack_Qty")),"##,##0")
    
            lblLeadTime.text = ReqCOM.GetFieldVal("Select top 1 Lead_Time from part_source where ven_code = '" & trim(lblVenCode.text) & "' and part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Lead_Time")
            lblUP.text = ReqCOM.GetFieldVal("Select top 1 UP from part_source where ven_code = '" & trim(lblVenCode.text) & "' and part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","UP")
            lblOrderQty.text = ReqCOM.CalQtyToBuy(clng(lblPRQtyB4.text),clng(lblSPQ.text),clng(lblMoq.text))
        Else
            txtSearchPart.text = "-- Search --"
            lblMOQ.text = ""
            lblSPQ.text = ""
            lblVenCode.text = ""
            lblVenName.text = ""
            lblPartSpec.text = ""
            lblPartDesc.text = ""
            lblOrderQty.text = ""
    
            ShowAlert("Invalid Part No.")
        end if
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
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQUery("Update PR1_D set Part_No = '" & trim(cmbPartNo.selecteditem.value) & "',Qty_To_Buy = " & clng(lblOrderQty.text) & ",PR_Qty = " & clng(lblPRQtyB4.text) & ",Ven_Code = '" & trim(lblVenCode.text) & "',Calculated_Qty = " & clng(lblOrderQty.text) & ",MOQ = " & clng(lblMOQ.text) & ",SPQ = " & clng(lblSPQ.text) & ",UP = " & cdec(lblUP.text) & ",Lead_Time = " & clng(lblLeadTime.text) & " where seq_no in (" & trim(lblSelItem.text) & ")")
            ReqCOM.ExecuteNonQuery("Update PR1_D set Variance = Calculated_Qty - PR_Qty,PR_Date = BOM_Date - Lead_Time where seq_no in (" & trim(lblSelItem.text) & ")")
            ShowAlert("New part No updated.")
        end if
    End Sub
    
    
    
    Sub cmdClose_Click(sender As Object, e As EventArgs)
        CloseIE()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqDate As Label = CType(e.Item.FindControl("ReqDate"), Label)
            Dim PRDate As Label = CType(e.Item.FindControl("PRDate"), Label)
    
            ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("Select * from PR1_D where PR_No = '" & trim(lblPRNo.text) & "' and Part_No = '" & trim(lblPartNoB4.text) & "';","FECN_M")
        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))
    
        dtgPartWithSource.DataSource=DV
        dtgPartWithSource.DataBind()
    end sub
    
    Sub ValSelPartItem_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer
        Dim Sel As CheckBox
        Dim SeqNo As label
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        lblSelItem.text = "0"
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Sel = CType(dtgPartWithSource.Items(i).FindControl("Sel"), CheckBox)
            SeqNo = CType(dtgPartWithSource.Items(i).FindControl("SeqNo"), label)
    
            if Sel.checked = true then
                lblSelItem.text = trim(lblSelItem.text) & "," & trim(SeqNo.text)
            end if
        Next i
        if trim(lblSelItem.text) = "0" then e.isvalid = false else e.isvalid = true
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
                        <p>
                        </p>
                        <p>
                        </p>
                        <p align="center">
                            <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">P/R Amend Part
                            No</asp:Label>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                        </p>
                        <p align="center">
                            <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don seem to have supplied a valid Part No." ForeColor=" " ControlToValidate="cmbPartNo" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:CustomValidator id="ValSelPartItem" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have select a valid P/R Item." ForeColor=" " Display="Dynamic" OnServerValidate="ValSelPartItem_ServerValidate" EnableClientScript="False"></asp:CustomValidator>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" width="100%" cssclass="LabelNormal">P/R No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblPRNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="100%" cssclass="LabelNormal">Part No/Description
                                                                (Before)</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartNoB4" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblPartDescB4" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" width="100%" cssclass="LabelNormal">Specification</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartSpecB4" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="100%" cssclass="LabelNormal">Part No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                &nbsp; 
                                                                <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="255px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                &nbsp; 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" width="100%" cssclass="LabelNormal">Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartDesc" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" width="100%" cssclass="LabelNormal">Specification</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartSpec" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AutoGenerateColumns="False" cellpadding="4" BorderColor="Black" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Req. Date">
                                                            <ItemTemplate>
                                                                <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="ReqDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="P/R Date">
                                                            <ItemTemplate>
                                                                <asp:Label id="PRDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Date") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="P/R Qty">
                                                            <ItemTemplate>
                                                                <asp:Label id="PRQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Qty") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Order Qty">
                                                            <ItemTemplate>
                                                                <asp:Label id="QtyToBuy" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn >
                                                            <ItemTemplate>
                                                                <asp:Checkbox id="Sel" runat="server" />
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                </asp:DataGrid>
                                            </p>
                                            <p>
                                                <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="left">
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Width="111px" Text="Update"></asp:Button>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <p>
                                                                        <asp:Button id="cmdClose" onclick="cmdClose_Click" runat="server" CssClass="OutputText" Width="111px" Text="Close" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <asp:Label id="lblPRQtyB4" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblSPQ" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblMOQ" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblUP" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblLeadTime" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblOrderQty" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblVenCode" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblVenName" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblSelItem" runat="server" cssclass="OutputText" visible="False"></asp:Label>
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
