<%@ Page Language="VB" %>
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
        if page.isPostBack = false then procLoadGridData ()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT PART_MASTER.PART_DESC,PART_MASTER.PART_SPEC,PART_MASTER.mfg,PART_MASTER.m_part_no,PART_MASTER.cust_part_no,PART_MASTER.seq_no,PART_MASTER.part_no,PART_MASTER.supply_type,PART_MASTER.ref_model,PART_MASTER.launch,(Select count(Distinct(Part_Source.ven_code)) from Part_Source where Part_Source.part_no = part_master.part_no) as [NoOfSource] FROM PART_MASTER WHERE " & trim(cmbSearchField.selecteditem.value) & " like '%" & cstr(txtSearch.Text) & "%'  ORDER BY part_master.part_no asc","PART_MASTER")
        GridControl1.DataSource=resExePagedDataSet.Tables("PART_MASTER").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        chkWithoutStdCost.checked = false
        ProcLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PartNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
            Dim Launch As checkbox = CType(e.Item.FindControl("Launch"), checkbox)
            Dim LaunchInd As label = CType(e.Item.FindControl("LaunchInd"), label)
            Dim SupplyType As label = CType(e.Item.FindControl("SupplyType"), label)
    
            if chkWithoutStdCost.checked = true then
                Launch.enabled = true
                if trim(LaunchInd.text) = "Y" then Launch.checked = 1
            elseif chkWithoutStdCost.checked = false then
                Launch.enabled = false
            End if
    
            if trim(SupplyType.text) = "MAKE" then e.item.cells(7).text = "Make"
            if trim(e.item.cells(7).text) = "0" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from Part_Master where Part_No = '" & trim(SeqNo.text) & "';")
                end if
            Catch
               ' MyError.Text = "There has been a problem with one or more of your inputs."
            End Try
        Next
        procLoadGridData ()
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub chkWithoutStdCost_CheckedChanged(sender As Object, e As EventArgs)
        if chkWithoutStdCost.checked = true then
            Dim strSql as string = "SELECT * FROM PART_MASTER WHERE Std_Cost_rd = 0"
            Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"PART_MASTER")
            GridControl1.DataSource=resExePagedDataSet.Tables("PART_MASTER").DefaultView
            GridControl1.DataBind()
        Elseif chkWithoutStdCost.checked = false then
            ProcLoadGridData()
        end if
    End Sub
    
    Sub Button5_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Launch As CheckBox
    
        if trim(Button5.text) = "Check All" then
            For i = 0 To GridControl1.Items.Count - 1
                Launch = CType(GridControl1.Items(i).FindControl("Launch"), CheckBox)
                Launch.checked = true
                Button5.text = "Clear All"
            next i
        Elseif trim(Button5.text) = "Clear All" then
            For i = 0 To GridControl1.Items.Count - 1
                Launch = CType(GridControl1.Items(i).FindControl("Launch"), CheckBox)
                Launch.checked = false
                Button5.text = "Check All"
            next i
        end if
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Launch As CheckBox
        Dim lblSeqNo As Label
    
        For i = 0 To GridControl1.Items.Count - 1
            Launch = CType(GridControl1.Items(i).FindControl("Launch"), CheckBox)
            lblSeqNo = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
    
            if Launch.checked = true then
                ReqCOM.ExecutenonQuery("Update Part_Master set Launch = 'Y',date_launch = '" & now & "' where Part_No = '" & lblSeqNo.text & "';")
            elseif Launch.checked = false then
                ReqCOM.ExecutenonQuery("Update Part_Master set Launch = 'N',date_launch = null where Part_No = '" & lblSeqNo.text & "';")
            end if
        next i
    
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
            <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">PART
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 16px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;<asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="176px"></asp:TextBox>
                                                                        &nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                        <asp:DropDownList id="cmbSearchField" runat="server" CssClass="OutputText">
                                                                            <asp:ListItem Value="Part_No">PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="Part_Desc">DESCRIPTION</asp:ListItem>
                                                                            <asp:ListItem Value="Part_Spec">SPECIFICATION</asp:ListItem>
                                                                            <asp:ListItem Value="MFG">MANUFACTURER</asp:ListItem>
                                                                            <asp:ListItem Value="M_PART_NO">MFG. PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="Cust_Part_No">CUST. PART NO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" CausesValidation="False" Text="Quick Search"></asp:Button>
                                                                        &nbsp; 
                                                                        <asp:CheckBox id="chkWithoutStdCost" runat="server" CssClass="OutputText" Text="Parts without std. cost" autopostback="true" OnCheckedChanged="chkWithoutStdCost_CheckedChanged"></asp:CheckBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="Button2" onclick="cmdAdd_Click" runat="server" CssClass="OutputText" Width="146px" Text="Register a new part"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="Button3" onclick="cmdRemove_Click" runat="server" CssClass="OutputText" Width="146px" Text="Remove selected part" Visible="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="Button4" onclick="cmdCancel_Click" runat="server" CssClass="OutputText" Width="146px" Text="Back"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="PartDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                <asp:TemplateColumn HeaderText="PART NO">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> <asp:Label id="SupplyType" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Supply_Type") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="PART_DESC" SortExpression="PART_DESC" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_SPEC" SortExpression="PART_SPEC" HeaderText="SPECIFICATION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="mfg" SortExpression="MFG" HeaderText="Manufacturer"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="m_part_no" HeaderText="Mfg. Part No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="cust_part_no" HeaderText="Cust. Part No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="NoOfSource" HeaderText="SRC"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Launch">
                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Launch" runat="server" />
                                                                                        </center>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Ref_Model" SortExpression="Ref_Model" HeaderText="Ref Model"></asp:BoundColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LaunchInd" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Launch") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        &nbsp; 
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="10%" bgcolor="yellow">
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp;&nbsp; <asp:Label id="Label8" runat="server" cssclass="OutputText">Part(s) without
                                                                                        source(s)</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="right">
                                                                                            <asp:Button id="Button5" onclick="Button5_Click" runat="server" Width="114px" Text="Check All"></asp:Button>
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
                                                    <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" CssClass="OutputText" Width="146px" Text="Register a new part"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" CssClass="OutputText" Width="183px" Text="Remove selected part" Visible="False"></asp:Button>
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Width="146px" Text="Update"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" CssClass="OutputText" Width="146px" Text="Back"></asp:Button>
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
