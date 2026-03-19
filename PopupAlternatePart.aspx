<%@ Page Language="VB" %>
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
            Dim StrSql as string
    
            StrSql = "Select Model_No from BOM_D where Seq_No = " & Request.params("ID") & ";"
            lblModelNo.text = ReqCOM.GetFieldVal(StrSql,"Model_No")
    
            StrSql = "Select Revision from BOM_D where Seq_No = " & Request.params("ID") & ";"
            lblRevNo.text = ReqCOM.GetFieldVal(StrSql,"Revision")
    
            StrSql = "Select Part_No from BOM_D where Seq_No = " & Request.params("ID") & ";"
            lblPartNo.text = ReqCOM.GetFieldVal(StrSql,"Part_No")
    
            StrSql = "Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';"
            lblDescription.text = ReqCOM.GetFieldVal(StrSql,"Model_Desc")
    
            StrSql = "Select Part_Spec from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';"
            lblSpec.text = ReqCOM.GetFieldVal(StrSql,"Part_Spec")
    
            ProcLoadGridData
    
            Dim RevNo as decimal = ReqCOM.GetFieldVal("Select top 1 revision from bom_m where model_no = '" & lblModelNo.text & "' order by revision desc","Revision")
    
    
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT BA.SEQ_No as [Seq_No],PM.Part_Spec as [Spec], PM.Part_No as [Part_No],PM.Part_Desc as [Desc] FROM PART_MASTER PM, BOM_Alt BA where BA.Revision = " & cdec(lblRevNo.text) & " and BA.Model_No = '" & trim(lblModelNo.text) & "' and BA.Main_Part = '" & trim(lblPartNo.text) & "' and PM.Part_No = BA.Part_No order by BA.Part_No asc"
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub lnkList_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.erp_Gtm
        Response.Redirect("BOMMainList.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from bom_m where Model_No = '" & trim(lblModelNo.text) & "';","Seq_No"))
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
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
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">ALTERNATE
                                PART LIST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px">Model No</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDescription" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="128px">Revision</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblRevNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="128px">Main Part
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="128px">Part Specification</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:Label id="lblSpec" runat="server" cssclass="OutputText" width="100%"></asp:Label><a href="javascript:OpenCalendar('txtSODate', true)"></a></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False">
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
                                                            <asp:BoundColumn DataField="Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Desc" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Spec" HeaderText="SPECIFICATION"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right">
                                                                        </div>
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
