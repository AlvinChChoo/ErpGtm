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
            cmdAddNew.attributes.add("onClick","javascript:if(confirm('This will create a new SSER document.\nAre you sure to continue ?')==false) return false;")
            if page.ispostback = false then
            if request.cookies("U_ID") is nothing then
                response.redirect("AccessDenied.aspx")
            else
                ProcLoadGridData()
            end if
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim Reqcom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SSERNo as string = ReqCOM.GetDocumentNo("SSER")
        ReqCOM.ExeCuteNonQuery("Insert into SSER_M(SSER_No,SSER_DATE,Submit_By) SELECT '" & TRIM(SSERNo) & "','" & NOW & "','" & request.cookies("U_ID").value & "';")
        reqcom.executeNonQuery("Update main set sser = sser + 1")
        response.redirect("SSERDet.aspx?ID=" & ReqCOM.GetFieldVal("select seq_no from sser_m where sser_no = '" & trim(SSERNo) & "';","Seq_No"))
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        if cmbSearch.selecteditem.value = "REF_NO" then
            StrSql = "Select * from VENDOR_INFO where REF_NO like '%" & trim(txtSearch.text) & "%' order by seq_no desc"
        elseif cmbSearch.selecteditem.value = "COMPANY_NAME" then
            StrSql = "Select * from VENDOR_INFO where COMPANY_NAME like '%" & trim(txtSearch.text) & "%' order by seq_no desc"
        end if
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"sser_m")
            GridControl1.DataSource=resExePagedDataSet.Tables("sser_m").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub ShowData(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SSERNo As Label = CType(e.Item.FindControl("SSERNo"), Label)
    
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SSER_M where SSER_NO = '" & trim(SSERNo.text) & "';","Seq_No")
        Response.redirect("SSERDet.aspx?ID=" & SeqNo)
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
    
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim MEEngDate As Label = CType(e.Item.FindControl("MEEngDate"), Label)
            Dim MEHODDate As Label = CType(e.Item.FindControl("MEHODDate"), Label)
            Dim QAEngDate As Label = CType(e.Item.FindControl("QAEngDate"), Label)
            Dim QAHODDate As Label = CType(e.Item.FindControl("QAHODDate"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            Dim REGENERATE As Label = CType(e.Item.FindControl("REGENERATE"), Label)
    
            e.item.cells(2).text = format(cdate(e.item.cells(2).text),"dd/MMM/yy")
            if trim(SubmitDate.text) <> "" then e.item.cells(3).text = e.item.cells(3).text & " - " & format(cdate(SubmitDate.text),"dd/MMM/yy")
            if trim(MEEngDate.text) <> "" then e.item.cells(4).text = e.item.cells(4).text & " - " & format(cdate(MEEngDate.text),"dd/MMM/yy")
            if trim(MEHODDate.text) <> "" then e.item.cells(5).text = e.item.cells(5).text & " - " & format(cdate(MEHODDate.text),"dd/MMM/yy")
            if trim(QAEngDate.text) <> "" then e.item.cells(6).text = e.item.cells(6).text & " - " & format(cdate(QAEngDate.text),"dd/MMM/yy")
            if trim(QAHODDate.text) <> "" then e.item.cells(7).text = e.item.cells(7).text & " - " & format(cdate(QAHODDate.text),"dd/MMM/yy")
    
    
            if (trim(SubmitDate.text) = "") or (trim(Status.text) = "REJECTED" AND TRIM(REGENERATE.text) = "N") then
                e.Item.CssClass = "PartSource"
                if trim(Urgent.text) = "Y" then e.item.cssclass = "Urgent"
            end if
        End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        ProcLoadGridData()
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
                            <div align="center"><asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SUPPLIER
                                INFORMATION LIST</asp:Label>
                            </div>
                            <div align="center">
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" Width="164px" Height="19px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:DropDownList id="cmbSearch" runat="server" Width="238px" Height="19px" CssClass="OutputText">
                                                        <asp:ListItem Value="REF_NO">REF NO</asp:ListItem>
                                                        <asp:ListItem Value="COMPANY_NAME">COMPANY NAME</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Width="72px" CssClass="OutputText" Text="GO"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnEditCommand="ShowData" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="REF #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="RefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REF_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="company_name" HeaderText="COMPANY NAME" DataFormatString="{0:d}"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Submit_By" HeaderText="Iss/Submit"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="APP1_BY" HeaderText="HOD Approval"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="APP2_BY" HeaderText="Accounts"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="APP3_BY" HeaderText="Final Approval"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP1_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP2_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP3_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label4" runat="server" cssclass="OutputText" width="100%">Urgent
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label5" runat="server" cssclass="OutputText" width="100%">Normal
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="white">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" cssclass="OutputText" width="100%">Completed
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="177px" Text="Add New SSER"></asp:Button>
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
