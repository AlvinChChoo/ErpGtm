<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            LoadPODet()
            LoadSplitPODet()
        End if
    End Sub
    
    Sub LoadPODet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select PO.REM,PO.Modify_By, PO.Modify_Date,PO.Del_Date_Con ,PO.Del_Date_Con,PO.SEQ_NO,PM.M_PART_NO, PM.PART_DESC , left(PM.PART_SPEC,25) + '...' as [Part_Spec], PO.PO_NO,PO.PART_NO,PO.DEL_DATE,PO.ORDER_QTY,PO.UP from PO_D PO,PART_MASTER PM where PO.Seq_No = " & request.params("ID") & " AND PO.PART_NO = PM.PART_NO order by po.part_no, PO.DEL_DATE asc"
    
    
    
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"PO_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("PO_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub LoadSplitPODet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select PO.REM,PO.Modify_By, PO.Modify_Date,PO.Del_Date_Con ,PO.Del_Date_Con,PO.SEQ_NO,PM.M_PART_NO, PM.PART_DESC + '  -  ' + PM.PART_SPEC as [PART_DESC], PO.PO_NO,PO.PART_NO,PO.DEL_DATE,PO.ORDER_QTY,PO.UP from PO_D_Split PO,PART_MASTER PM where PO.Ref_No = " & request.params("ID") & " AND PO.PART_NO = PM.PART_NO order by po.part_no, PO.DEL_DATE asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"PO_D")
        dtgSplitPO.DataSource=resExePagedDataSet.Tables("PO_D").DefaultView
        dtgSplitPO.DataBind()
    end sub
    
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        LoadPODet()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ETA As Label = CType(e.Item.FindControl("ETA"), Label)
            Dim OrderQty As Label = CType(e.Item.FindControl("OrderQty"), Label)
            Dim Amount As Label = CType(e.Item.FindControl("Amount"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            Dim ETACon As CheckBox = CType(e.Item.FindControl("ETACon"), CheckBox)
            ETA.text = format(cdate(ETA.text),"dd/MMM/yy")
            Amount.text = format(cdec(OrderQty.text) * cdec(UP.text),"##,##0.00")
        End if
    End Sub
    
    Protected Sub FormatRow1(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ETA As textbox = CType(e.Item.FindControl("ETA"), textbox)
            Dim OrderQty As textbox = CType(e.Item.FindControl("OrderQty"), textbox)
            Dim Amount As Label = CType(e.Item.FindControl("Amount"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            Dim ETACon As CheckBox = CType(e.Item.FindControl("ETACon"), CheckBox)
            ETA.text = format(cdate(ETA.text),"dd/MM/yy")
            Amount.text = format(cdec(OrderQty.text) * cdec(UP.text),"##,##0.00")
        End if
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
    
    Sub cmdSplit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOm.ExecuteNonQuery("Insert into PO_D_Split(PO_NO,PART_NO,DEL_DATE,SCH_DATE,ORDER_QTY,FOC_QTY,UP,IN_QTY,BAL_TO_SHIP,PREV_DEL_DATE,DEL_DATE_CON,MODIFY_BY,MODIFY_DATE,REM,ref_no,create_by,create_date) select PO_NO,PART_NO,DEL_DATE,SCH_DATE,ORDER_QTY,FOC_QTY,UP,IN_QTY,BAL_TO_SHIP,PREV_DEL_DATE,DEL_DATE_CON,MODIFY_BY,MODIFY_DATE,REM," & request.params("ID") & ",'" & trim(request.cookies("U_ID").value) & "','" & now & "' from PO_D where SEQ_No = " & Request.params("ID") & ";")
        response.redirect("SplitPO.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim Remove As CheckBox
        Dim SeqNo as Label
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To dtgSplitPO.Items.Count - 1
            SeqNo = CType(dtgSplitPO.Items(i).FindControl("SeqNo"), label)
            Remove = CType(dtgSplitPO.Items(i).FindControl("Remove"), CheckBox)
            if Remove.checked = true then ReqCOM.ExecuteNonQuery("Delete from PO_D_Split where seq_no = " & SeqNo.text & ";")
        Next
        Response.redirect("PopupSplitPO.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub CustomValidator1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer
        Dim ActualOrderQty as long
        Dim OrderQty,ETA as Textbox
        Dim TotalOrderQty as long
        TotalOrderQty = 0
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim CMonth,CDay,CYear as integer
                Dim CDt as string
        ActualOrderQty = ReqCom.GetFieldVal("Select Order_Qty from PO_D where seq_no = " & request.params("ID") & ";","Order_Qty")
    
        For i = 0 to dtgSplitPO.Items.Count - 1
            OrderQty = CType(dtgSplitPO.Items(i).findControl("OrderQty"), Textbox)
            ETA = CType(dtgSplitPO.Items(i).findControl("ETA"), Textbox)
    
            TotalOrderQty = clng(TotalOrderQty) + clng(OrderQty.text)
    
            if isnumeric(OrderQty.text) = false then
                CustomValidator1.errormessage = "Invalid Order Qty on item # " & i + 1
                e.isvalid = false
                exit sub
            end if
    
            CDt = ETA.text
            Cmonth = CDt.substring(3,2)
            CDay  = CDt.substring(0,2)
            CYear = CDt.substring(6,2)
            Cdt = CMonth & "/" & Cday & "/" & CYear
            IF isDate(Cdt) = false then
                CustomValidator1.errormessage = "Invalid Date input on item # " & i + 1
                e.isvalid = false
                exit sub
            end if
    
        NEXT
    
        if clng(ActualOrderQty) <> clng(TotalOrderQty) then
            CustomValidator1.errormessage = "Split P/O qty not match."
            e.isvalid = false
            exit sub
        end if
    End Sub
    
    Sub cmddUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim OrderQty,ETA as Textbox
        Dim SeqNo as label
        Dim CMonth,CDay,CYear,i as integer
        Dim PONo as string
        Dim CDt as string
        PONo = ReqCOM.GetFieldVal("Select PO_NO from PO_D where seq_no = " & request.params("ID") & ";","PO_NO")
        for i  = 0 to dtgSplitPO.Items.Count - 1
            SeqNo = CType(dtgSplitPO.Items(i).findControl("SeqNo"), label)
            OrderQty = CType(dtgSplitPO.Items(i).findControl("OrderQty"), textbox)
            ETA = CType(dtgSplitPO.Items(i).findControl("ETA"), textbox)
            CDt = ETA.text
            Cmonth = CDt.substring(3,2)
            CDay  = CDt.substring(0,2)
            CYear = CDt.substring(6,2)
            Cdt = CMonth & "/" & Cday & "/" & CYear
            ReqCOM.executeNonQuery("Update PO_D_Split set Order_Qty = " & OrderQty.text & ",Del_Date = '" & cdate(CDT) & "' where seq_no = " & seqNo.text & ";")
        next
    
        ReqCOM.ExecuteNonQuery("Insert into PO_D(PO_NO,PART_NO,DEL_DATE,SCH_DATE,ORDER_QTY,FOC_QTY,UP,IN_QTY,BAL_TO_SHIP,PREV_DEL_DATE,DEL_DATE_CON,MODIFY_BY,MODIFY_DATE,REM) select PO_NO,PART_NO,DEL_DATE,SCH_DATE,ORDER_QTY,FOC_QTY,UP,IN_QTY,BAL_TO_SHIP,PREV_DEL_DATE,DEL_DATE_CON,MODIFY_BY,MODIFY_DATE,REM from po_d_split where Ref_No = " & request.params("ID") & ";")
        ReqCOm.ExecuteNonQuery("Delete from PO_D where seq_no = " & request.params("ID") & ";")
        ReqCOm.ExecuteNonQuery("Delete from PO_D_SPLIT where ref_no = " & request.params("ID") & ";")
        ReqCOM.ExecuteNonQuery("Delete from PO_D_Split where Ref_No = " & request.params("ID") & ";")
        Response.redirect("PurchaseOrderDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PO_M where PO_No = '" & trim(PONo) & "';","Seq_No"))
    End Sub
    
    Sub cmdClose_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim PONo as string
        PONo = ReqCOM.GetFieldVal("Select PO_NO from PO_D where seq_no = " & request.params("ID") & ";","PO_NO")
        ReqCOM.ExecuteNonQuery("Delete from PO_D_Split where Ref_No = " & request.params("ID") & ";")
        Response.redirect("PurchaseOrderDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PO_M where PO_No = '" & trim(PONo) & "';","Seq_No"))
    End Sub

</script>
<html xmlns:footer= "xmlns:footer">
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                                <asp:CustomValidator id="CustomValidator1" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="CustomValidator"></asp:CustomValidator>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Actual Purchase Order Item Details</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <asp:DataGrid id="dtgPartWithSource" runat="server" width="96%" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn Visible="False" DataField="Seq_No"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Part No/Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> - <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Specification">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="M_PART_NO" HeaderText="MPN"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="ETA">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ETA" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Del_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Order Qty">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="OrderQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="U/P">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Amount">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Amount" runat="server" text='' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn Visible="False" DataField="Del_Date_Con"></asp:BoundColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Splited Purchase Order Item Details</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <asp:DataGrid id="dtgSplitPO" runat="server" width="96%" OnItemDataBound="FormatRow1" AllowSorting="True" OnSortCommand="SortGrid" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn Visible="False" DataField="Seq_No"></asp:BoundColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Part No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Part_DESC" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="M_PART_NO" HeaderText="MFG. PART NO"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="ETA">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:textbox id="ETA" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Del_Date") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Order Qty">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:textbox id="OrderQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="U/P">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Amount">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Amount" runat="server" text='' /> 
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
                                                                                <asp:BoundColumn Visible="False" DataField="Del_Date_Con"></asp:BoundColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p>
                                                        <table style="HEIGHT: 14px" width="100%">
                                                            <tbody>
                                                                <tr>
                                                                    <td width="25%">
                                                                        <div align="center">
                                                                            <asp:Button id="Button1" onclick="cmdSplit_Click" runat="server" Width="177px" CausesValidation="False" Text="Split P/O Item"></asp:Button>
                                                                        </div>
                                                                    </td>
                                                                    <td width="25%">
                                                                        <div align="center">
                                                                            <asp:Button id="Button2" onclick="cmdRemove_Click" runat="server" Width="177px" CausesValidation="False" Text="Remove selected item"></asp:Button>
                                                                        </div>
                                                                    </td>
                                                                    <td width="25%">
                                                                        <p align="center">
                                                                            <asp:Button id="Button3" onclick="cmddUpdate_Click" runat="server" Width="177px" Text="Update"></asp:Button>
                                                                        </p>
                                                                    </td>
                                                                    <td width="25%">
                                                                        <div align="center">
                                                                            <asp:Button id="Button4" onclick="cmdClose_Click" runat="server" Width="177px" CausesValidation="False" Text="Cancel"></asp:Button>
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
                            </div>
                            <footer:footer id="footer" runat="server"></footer:footer>
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
