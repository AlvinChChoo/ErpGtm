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
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        StrSql = "Select distinct(PS.part_no) as [Part_No], PS.ven_code,v.ven_name,pm.part_desc,pm.m_part_no,ps.vmi,PS.item_class,ps.buffer_qty,ps.buffer_wks,ps.liability_qty,ps.liability_wks from Part_source PS,Part_master PM,Vendor V where V.Ven_Code + V.Ven_Name like '%" & trim(txtVen.text) & "%' and ps.ven_code = v.ven_code and ps.part_no = pm.part_no and Pm.part_no + pm.part_desc like '%" & trim(txtPartNo.text) & "%' group by PS.ven_code,PS.part_no,v.ven_name,pm.part_desc,pm.m_part_no,ps.vmi,PS.item_class,ps.buffer_qty,ps.buffer_wks,ps.liability_qty,ps.liability_wks"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"mod_reg_d")
        Dim DV as New DataView(resExePagedDataSet.Tables("mod_reg_d"))
        dtgVMI.DataSource=DV
        dtgVMI.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub ItemCommandModule(sender as Object,e as DataGridCommandEventArgs)
        Dim lblSeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ucase(e.commandArgument) = "EDIT" then Response.redirect("ModuleDet.aspx?ID=" & clng(lblSeqNo.text))
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQUery("Delete from Mod_Reg_D where seq_no = " & clng(lblSeqNo.text) & ";") : response.redirect("Module.aspx")
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim lblVMI As Label
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then lblVMI = CType(e.Item.FindControl("lblVMI"), Label)
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        procLoadGridData
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim VMI As CheckBox
        Dim PartNo,VenCode As Label
        Dim StrSql,ISVMI as string
        Dim ItemClass,BufferQty,BufferWks,LiabilityWks,LiabilityQty As TextBox
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
    
        For i = 0 To dtgVMI.Items.Count - 1
            VMI = CType(dtgVMI.Items(i).FindControl("VMI"), CheckBox)
            PartNo = CType(dtgVMI.Items(i).FindControl("PartNo"), Label)
            VenCode = CType(dtgVMI.Items(i).FindControl("VenCode"), Label)
    
            ItemClass = CType(dtgVMI.Items(i).FindControl("ItemClass"), Textbox)
            BufferQty = CType(dtgVMI.Items(i).FindControl("BufferQty"), Textbox)
            BufferWks = CType(dtgVMI.Items(i).FindControl("BufferWks"), Textbox)
            LiabilityWks = CType(dtgVMI.Items(i).FindControl("LiabilityWks"), Textbox)
            LiabilityQty = CType(dtgVMI.Items(i).FindControl("LiabilityQty"), Textbox)
    
            ISVMI = "Y"
            if trim(BufferQty.text) = "" and trim(BufferWks.text) = "" and trim(LiabilityQty.text) = "" and trim(LiabilityWks.text) = "" and trim(ItemClass.text) = "" then ISVMI = "N"
    
            StrSql = "Update Part_source set "
            StrSql = StrSql & "Item_Class = '" & trim(ItemClass.text) & "',"
            if trim(BufferQty.text) = "" then StrSql = StrSql & "Buffer_Qty = null,"
            if trim(BufferQty.text) <> "" then StrSql = StrSql & "Buffer_Qty = " & BufferQty.text & ","
            if trim(BufferWks.text) = "" then StrSql = StrSql & "Buffer_Wks = null,"
            if trim(BufferWks.text) <> "" then StrSql = StrSql & "Buffer_Wks = " & BufferWks.text & ","
            if trim(LiabilityQty.text) = "" then StrSql = StrSql & "Liability_Qty = null,"
            if trim(LiabilityQty.text) <> "" then StrSql = StrSql & "Liability_Qty = " & LiabilityQty.text & ","
            if trim(LiabilityWks.text) = "" then StrSql = StrSql & "Liability_Wks = null,"
            if trim(LiabilityWks.text) <> "" then StrSql = StrSql & "Liability_Wks = " & LiabilityWks.text & ","
            StrSql = StrSql & "VMI='" & trim(ISVMI) & "' "
            StrSql = StrSql & "where Part_no = '" & trim(PartNo.text) & "' and ven_code = '" & trim(VenCode.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
        Next i
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">VMI
                                Maintenance</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="30%" bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="OutputText">Supplier Code / Name</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtVen" runat="server" Width="315px" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="OutputText">Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtPartNo" runat="server" Width="315px" CssClass="OutputText"></asp:TextBox>
                                                                                        &nbsp;&nbsp;&nbsp; 
                                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="84px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgVMI" runat="server" width="100%" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" BorderColor="Black" GridLines="None" cellpadding="4" AutoGenerateColumns="False" OnItemCommand="ItemCommandModule" BorderStyle="None">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText= "Supplier Code/Name">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblVMI" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "VMI") %>' /> <asp:Label id="VenCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Code") %>' /> - <asp:Label id="VenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Part No / Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> - <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "MPN">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Item Class">
                                                                                    <ItemTemplate>
                                                                                        <asp:Textbox id="ItemClass" runat="server" width="50px" CssClass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Item_Class") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Buffer(Qty)">
                                                                                    <ItemTemplate>
                                                                                        <asp:Textbox id="BufferQty" runat="server" width="50px" CssClass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Buffer_Qty") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Buffer(Wks)">
                                                                                    <ItemTemplate>
                                                                                        <asp:Textbox id="BufferWks" runat="server" width="50px" CssClass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Buffer_Wks") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Liability(Qty)">
                                                                                    <ItemTemplate>
                                                                                        <asp:Textbox id="LiabilityQty" runat="server" width="50px" CssClass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Liability_Qty") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Liability(Wks)">
                                                                                    <ItemTemplate>
                                                                                        <asp:Textbox id="LiabilityWks" runat="server" width="50px" CssClass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Liability_Wks") %>' />
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
                                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Text="Update VMI List"></asp:Button>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <p align="center">
                                                                                            </p>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <p align="right">
                                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" CssClass="OutputText" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>