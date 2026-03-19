<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        cmdAddNew.attributes.add("onClick","javascript:if(confirm('This will create a new approval sheet document.\nAre you sure to continue ?')==false) return false;")
        if page.isPostBack = false then procLoadGridData ()
    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub

    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string

        if cmbSearch.selecteditem.value = "UPA_NO" then
            StrSql = "SELECT * FROM JOAS_M WHERE JOAS_NO LIKE '%" & txtSearch.Text & "%' ORDER BY JOAS_NO desc"
        elseif cmbSearch.selecteditem.value = "PART_NO" then
            StrSql = "SELECT * FROM JOAS_M WHERE JOAS_NO in (Select JOAS_NO from UPAS_D where Part_No like '%" & trim(txtSearch.text) & "%') ORDER BY JOAS_NO desc"
        elseif cmbSearch.selecteditem.value = "SUBMIT_BY" then
            StrSql = "SELECT * FROM JOAS_M WHERE SUBMIT_BY LIKE '%" & TRIM(txtSearch.text) & "%' ORDER BY JOAS_NO desc"
        elseif cmbSearch.selecteditem.value = "VEN_CODE" then
            StrSql = "SELECT * FROM JOAS_M WHERE JOAS_NO in (SELECT JOAS_NO FROM UPAS_D WHERE VEN_CODE IN(Select VEN_CODE from VENDOR where VEN_CODE + VEN_NAME like '%" & trim(txtSearch.text) & "%')) ORDER BY JOAS_NO desc"
        end if

        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"CUST")

        GridControl1.DataSource=resExePagedDataSet.Tables("CUST").DefaultView
        GridControl1.DataBind()
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as erp_GTM.erp_GTM  = new erp_GTM.erp_GTM
        Dim JOASNo as string = ReqCOM.GetDocumentNo("JOAS_NO")

        ReqCOM.ExecuteNonQuery("Insert into JOAS_M(JOAS_NO,JOAS_DATE,JOAS_STATUS) select '"& trim(JOASNo) & "','" & cdate(now) & "','PENDING SUBMISSION'")
        ReqCOM.ExecuteNonQuery("Update Main set JOAS_No = JOAS_No + 1")

        response.redirect("JOASDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from JOAS_M where JOAS_No = '" & trim(JoasNo) & "';","Seq_No"))
    End Sub

    Sub Button3_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'Dim Submit As Label = CType(e.Item.FindControl("Submit"), Label)
            'Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            'Dim PurcDate As Label = CType(e.Item.FindControl("PurcDate"), Label)
            'Dim AC1Date As Label = CType(e.Item.FindControl("AC1Date"), Label)
            'Dim AC2Date As Label = CType(e.Item.FindControl("AC2Date"), Label)
            'Dim MgtDate As Label = CType(e.Item.FindControl("MgtDate"), Label)
            'Dim EntryDate As Label = CType(e.Item.FindControl("EntryDate"), Label)
            'Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            'Dim regenerate As Label = CType(e.Item.FindControl("regenerate"), Label)
            'Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)

            'if trim(PurcDate.text) <> "" then PurcDate.text = format(cdate(PurcDate.text),"dd/MMM/yy")
            'if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MMM/yy")
            'if trim(AC1Date.text) <> "" then AC1Date.text = format(cdate(AC1Date.text),"dd/MMM/yy")
            'if trim(AC2Date.text) <> "" then AC2Date.text = format(cdate(AC2Date.text),"dd/MMM/yy")
            'if trim(MgtDate.text) <> "" then MgtDate.text = format(cdate(MgtDate.text),"dd/MMM/yy")
            'if trim(Submit.text) = "" then e.Item.CssClass = "PartSource"

            'if trim(ucase(Status.text)) = "REJECTED" or SubmitDate.text = "" then
            '    if trim(regenerate.text) = "N" then
            '        e.Item.CssClass = "PartSource"
            '        if trim(Urgent.text) = "Y" then e.item.cssclass = "Urgent"
            '    End if
            'End if
        End if
    End Sub

    Sub cmbSearch_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">JOB ORDER APPROVAL
                                LIST</asp:Label>
                                <table style="HEIGHT: 12px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;
                                                    <asp:TextBox id="txtSearch" runat="server" Width="177px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;
                                                    <asp:DropDownList id="cmbSearch" runat="server" Width="143px" CssClass="OutputText" OnSelectedIndexChanged="cmbSearch_SelectedIndexChanged">
                                                        <asp:ListItem Value="UPA_NO">UPA No</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="SUBMIT_BY">BUYER</asp:ListItem>
                                                        <asp:ListItem Value="VEN_CODE">SUPPLIER</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;<asp:Button id="Button3" onclick="Button3_Click" runat="server" Width="117px" CssClass="OutputText" Text="GO"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="94%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="10" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="JOASDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="JOAS_NO" HeaderText="JOAS #"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Submit">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="177px" Text="Add New Approval Sheet"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back"></asp:Button>
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
