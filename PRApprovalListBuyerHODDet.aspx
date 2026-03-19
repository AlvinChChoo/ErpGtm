<%@ Page Language="VB" Debug="TRUE" %>
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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ApprovalNo as integer
    
            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR_Approval where Seq_No = " & Request.params("ID") & ";")
            Do while RsApproval.read
                lblApprovalNo.text = RsApproval("Approval_No").tostring
                lblSubmissionDate.text = format(RsApproval("Approval_Date"),"MM/dd/yy")
    
                lblStatus.text = trim(ucase(RsApproval("Purc_Stat").tostring))
                'if trim(RsApproval("Purc_Stat")) = "PENDINS SUBMISSION" then
                if trim(lblStatus.text) = "PENDING SUBMISSION" then
                    cmdSubmit.visible = true
                    cmdReject.visible = true
                    'lblDateApproved.text = format(cdate(RsApproval("Approval_Date")),"MM/dd/yy")
                    'lblApprovedBy.text = trim(RsApproval("Approved_By"))
                    'cmdApprove.visible = false
                    'cmdReject.visible = false
                Else
                    cmdSubmit.visible = false
                    cmdReject.visible = false
                    'cmdApprove.visible = true
                    'cmdReject.visible = true
                end if
            Loop
            Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.Approval_No = " & lblApprovalNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.Seq_No asc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
            dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
            dtgPartWithSource.DataBind()
        end if
    End Sub
    
    Property SortField() As String
        Get
            Dim o As Object = ViewState("SortField")
            If o Is Nothing Then
                Return [String].Empty
            End If
            Return CStr(o)
        End Get
        Set(ByVal Value As String)
            If Value = SortField Then
                SortAscending = Not SortAscending
            End If
            ViewState("SortField") = Value
        End Set
    End Property
    
    Property SortAscending() As Boolean
        Get
            Dim o As Object = ViewState("SortAscending")
    
            If o Is Nothing Then
                Return True
            End If
            Return CBool(o)
        End Get
        Set(ByVal Value As Boolean)
            ViewState("SortAscending") = Value
        End Set
    End Property
    
    Sub LoadDataWithSource()
    end sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqDate As Label = CType(e.Item.FindControl("lblReqDate"), Label)
            ReqDate.text = format(cdate(ReqDate.text),"MM/dd/yy")
            Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
            'PRDate.text = format(cdate(PRDate.text),"MM/dd/yy")
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithoutSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdApproval_Click(sender As Object, e As EventArgs)
        response.redirect("PRApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        LoadDataWithSource()
    End Sub
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        Response.redirect("PRListApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        Response.redirect("PRListReject.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApprovalList.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.executenonQuery("Update PR_Approval set Purc_Stat = 'PENDING APPROVAL' where approval_no = '" & trim(lblApprovalNo.text) & "';")
        Response.redirect("PRApprovalListBuyerHOD.aspx")
    End Sub
    
    Sub cmdReject_Click_1(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.executenonQuery("Update PR_Approval set Purc_Stat = 'BUYER HOD REJECTED' where approval_no = '" & trim(lblApprovalNo.text) & "';")
        ReqCOM.executenonQuery("Update tpr_D set approval_no = null where approval_No = '" & trim(lblApprovalNo.text) & "';")
        Response.redirect("PRApprovalListBuyerHOD.aspx")
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApprovalListBuyerHOD.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 184px" height="184" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">PR APPROVAL
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 23px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Approval No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApprovalNo" runat="server" width="84px" cssclass="OutputText"></asp:Label></td>
                                                            <td>
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Submission Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmissionDate" runat="server" width="106px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Date Approved</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDateApproved" runat="server" width="106px" cssclass="OutputText"></asp:Label></td>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Approved By</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApprovedBy" runat="server" width="106px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Status</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:Label id="lblStatus" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="BUYER_CODE" SortExpression="PM.Buyer_Code" HeaderText="BUYER"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="REQ DATE">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblReqDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PR Date">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblPRDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PR QTY">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblPRQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_QTY") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="BUY QTY">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblBuyQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QTY_TO_BUY") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="VAR">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblVar" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "VARIANCE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ven_name" SortExpression="Ven.Ven_Code" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit for PR Approval" Width="169px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click_1" runat="server" Text="Cancel List" Width="147px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Text="Back" Width="111px"></asp:Button>
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
    <!-- Insert content here -->
</body>
</html>
