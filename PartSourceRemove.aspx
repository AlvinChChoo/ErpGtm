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
            if page.isPostBack = false then
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            LoadData
            procLoadGridData ()
            end if
        End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select PS.UP_APP_NO, PS.MODIFY_DATE, PS.Lead_Time,PS.SEQ_NO,PS.UP,PS.Modify_By,PS.Std_Pack_Qty,PS.Min_Order_Qty,V.Ven_name,ps.part_no from Part_Source PS,Vendor v where PS.Part_No = '" & trim(lblPartNo.text) & "' and PS.Del_Ind = 'Y' and PS.Ven_Code = V.Ven_Code"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_source")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_source").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM Part_Master WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
        Dim PartType,TariffCode,ObsolutePart,UOM as string
        do while ResExeDataReader.read
            lblPartNo.text = ResExeDataReader("Part_No").tostring
            lblDescription.text= ResExeDataReader("Part_Desc").tostring
        loop
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartSourceAddNew.aspx?ID=" + request.params("ID").tostring)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.Item.Cells(3).Text = cint(e.Item.Cells(3).Text)
            e.Item.Cells(4).Text = cint(e.Item.Cells(4).Text)
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PartSourceDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            Try
                ReqCOM.ExecuteNonQuery("Delete from Part_Source where Seq_No = " & SeqNo.text & ";")
            Catch
    '           ' MyError.Text = "There has been a problem with one or more of your inputs."
            End Try
        Next
        Response.redirect("PartSourceDet.aspx?ID=" & Request.params("ID"))
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
            <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">PART
                                SOURCE(S) REMOVAL</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="lblShortageMsg" runat="server" width="100%" cssclass="Instruction">Please
                                re-confirm the selected part source(s) that you want to remove.</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 194px" cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 52px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label3" runat="server" width="112px" cssclass="LabelNormal">Part No</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblPartNo" runat="server" width="393px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label5" runat="server" width="112px" cssclass="LabelNormal">Description</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblDescription" runat="server" width="393px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" Font-Name="Verdana" Font-Names="Verdana" Font-Size="XX-Small" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="ID">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Ven_Name" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Lead_Time" HeaderText="L/T(Wks)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Std_Pack_Qty" HeaderText="STD PACK">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Min_Order_Qty" HeaderText="MOQ">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP_APP_NO" HeaderText="APP. NO">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="left">
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="192px" Text="Remove Selected Source(s)"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="164px" Text="Back"></asp:Button>
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
