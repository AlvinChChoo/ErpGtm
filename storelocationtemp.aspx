<%@ Page Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            if request.cookies("U_ID") is nothing then
                response.redirect("AccessDenied.aspx")
            else
                lblUser.text = "Current User : " + request.cookies("U_ID").value
                Dim OurCommand as sqlcommand
                Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                procLoadGridData ("SELECT * FROM LOC ORDER BY LOC_CODE ASC")
                lblMaxRec.text = cint(ReqGetFieldVal.GetFieldVal("Select Grid_Max_Rec from Main","Grid_Max_Rec"))
            end if
        else
            if request.cookies("U_ID") is nothing then
                response.redirect("AccessDenied.aspx")
            else
                lblUser.text = "Current User : " + request.cookies("U_ID").value
                Dim OurCommand as sqlcommand
                Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                lblMaxRec.text = cint(ReqGetFieldVal.GetFieldVal("Select Grid_Max_Rec from Main","Grid_Max_Rec"))
            end if
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData("SELECT * FROM LOC WHERE LOC_CODE like '%" & cstr(txtSearch.Text) & "%'  ORDER BY LOC_CODE ASC")
    end sub
    
    Sub ProcLoadGridData(StrSql as string)
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"LOC")
        GridControl1.DataSource=resExePagedDataSet.Tables("LOC").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        if isnumeric(txtNoOfRec.text) = false then  txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text = "" then txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text > cint(lblMaxRec.text) then  txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text < 1 then  txtNoOfRec.text = lblMaxRec.text
        gridcontrol1.PageSize= txtNoOfRec.text
        ProcLoadGridData("SELECT * FROM LOC WHERE LOC_CODE like '%" & cstr(txtSearch.Text) & "%'  ORDER BY LOC_CODE ASC")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub cmdUpdate_Click_1(sender As Object, e As EventArgs)
        Dim StrSql as string
        Dim i as integer
        Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        For i = 0 To gridcontrol1.Items.Count - 1
            Dim SeqNo As Label = Ctype(gridcontrol1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(gridcontrol1.Items(i).FindControl("chkRemove"), CheckBox)
                Try
                    If remove.Checked = True Then
                        StrSql = "Delete from LOC where Seq_No = '" & cint(SeqNo.text) & "'"
                        ReqExecuteNoNQuery.ExecuteNonQuery(strsql)
                    end if
                Catch
                   'MyError.Text = "There has been a problem with one or more of your inputs."
    
                End Try
        Next
        procLoadGridData ("SELECT * FROM LOC ORDER BY LOC_CODE asc")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        'response.redirect("PaymentTermAddNew.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form runat="server">
        <p>
        </p>
        <p>
            <asp:Label id="lblUser" runat="server" width="564px">Label</asp:Label>
        </p>
        <fieldset>
            <table style="WIDTH: 734px; HEIGHT: 36px">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                Keyword 
                            </p>
                        </td>
                        <td>
                            <asp:TextBox id="txtSearch" runat="server" Width="315px"></asp:TextBox>
                        </td>
                        <td>
                            No of Records</td>
                        <td>
                            <asp:TextBox id="txtNoOfRec" runat="server" Width="63px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="58px" CausesValidation="False" Text="GO"></asp:Button>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <p>
                                Keyword search&nbsp; :&nbsp;"Description" 
                            </p>
                        </td>
                        <td colspan="3">
                            Maximum <asp:Label id="lblMaxRec" runat="server"></asp:Label>&nbsp;records to display</td>
                    </tr>
                </tbody>
            </table>
        </fieldset>
        <fieldset>
            <p>
            </p>
            <p>
                <asp:DataGrid id="GridControl1" runat="server" width="100%" Height="216px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" ShowFooter="True" AutoGenerateColumns="False">
                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                    <ItemStyle cssclass="GridItem"></ItemStyle>
                    <Columns>
                        <asp:TemplateColumn HeaderText="ID">
                            <ItemTemplate>
                                <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                            </ItemTemplate>
                        </asp:TemplateColumn>
                        <asp:HyperLinkColumn DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="StoreLocationDet.aspx?ID={0}" DataTextField="loc_code" HeaderText="DESCRIPTION"></asp:HyperLinkColumn>
                        <asp:TemplateColumn HeaderText="Remove">
                            <ItemTemplate>
                                <center>
                                    <asp:CheckBox id="chkRemove" runat="server" />
                                </center>
                            </ItemTemplate>
                        </asp:TemplateColumn>
                    </Columns>
                </asp:DataGrid>
            </p>
        </fieldset>
        <p>
            <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="173px" Text="New Supplier"></asp:Button>
            &nbsp;&nbsp;&nbsp;&nbsp; 
            <asp:Button id="cmdMain" onclick="cmdMain_Click" runat="server" Width="149px" Text="Main"></asp:Button>
            &nbsp; 
            <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click_1" runat="server" Width="138px" CausesValidation="False" Text="Update Changes" autopostback="true"></asp:Button>
        </p>
    </form>
</body>
</html>
