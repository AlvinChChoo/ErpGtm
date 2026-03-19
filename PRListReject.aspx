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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ApprovalNo as integer

            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR_Approval where Seq_No = " & Request.params("ID") & ";")
            Do while RsApproval.read
                lblApprovalNo.text = RsApproval("Approval_No").tostring
                'lblSubmissionDate.text = format(RsApproval("Approval_Date"),"MM/dd/yy")
                'if isdbnull(RsApproval("Approved_Date")) = false then lblDateApproved.text = format(cdate(RsApproval("Approval_Date")),"MM/dd/yy")
            Loop

            'if lblDateApproved.text <> "" then cmdApproved.enabled = false else cmdApproved.enabled = true

            Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.Approval_No = " & lblApprovalNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.Seq_No asc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
            dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
            dtgPartWithSource.DataBind()
            Label13.text = dtgPartWithSource.items.count & " parts have been selected for PR Reject."
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
            PRDate.text = format(cdate(PRDate.text),"MM/dd/yy")
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

    Sub Back_Click(sender As Object, e As EventArgs)
        response.redirect("PRApprovalDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdApproved_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTm = new ERP_GTM.ERP_GTM
            'Dim StrSql as string =

            ReqCOM.ExecuteNonQuery("Update PR_Approval set Approve_Date = '" & Now & "',APPROVE_BY = '" & trim(request.cookies("U_ID").value) & "',pr_status = 'REJECTED' where Approval_No = " & lblApprovalNo.text & ";")
            'StrSql =
            ReqCOM.ExecuteNonQuery("Update TPR_D set Approval_No = null where Approval_No = '" & trim(lblApprovalNo.text) & "';")
            Response.cookies("AlertMessage").value = "Selected PR Approval List have been rejected."
            Response.redirect("AlertMessage.aspx?ReturnURL=PRApprovalList.aspx")
           ' Response.redirect("PRApprovalConfirmation.aspx")
        End if
    End Sub

    Sub ValLoginAc(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOm.FuncCheckDuplicate("Select U_ID from User_Profile where U_ID = '" & trim(txtUserID.text) & "' and Pwd = '" & trim(txtPwd.text) & "';","U_ID") = true then
            e.isvalid = true
        else
            e.isvalid = false
        end if
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
            <table style="HEIGHT: 184px" height="184" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <div align="center"><asp:Label id="Label13" runat="server" cssclass="Instruction" width="100%"></asp:Label>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" EnableClientScript="False" ControlToValidate="txtUserID" ErrorMessage="You don't seem to have supplied a valid User ID." Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                            </div>
                            <div align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Width="100%" EnableClientScript="False" ControlToValidate="txtPwd" ErrorMessage="You don't seem to have supplied a valid Password." Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                            </div>
                            <div align="center">
                                <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" EnableClientScript="False" ErrorMessage="Unvalid user authentication." Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValLoginAc"></asp:CustomValidator>
                            </div>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small">
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
                                                    <table style="HEIGHT: 28px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="134px">User ID</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUserID" runat="server" Width="158px" CssClass="OutputText"></asp:TextBox>
                                                                    <asp:Label id="lblApprovalNo" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="134px">Password</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPwd" runat="server" Width="158px" CssClass="OutputText" TextMode="Password"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label5" runat="server" cssclass="Instruction">Are you sure to reject
                                                    this PR ?</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdApproved" onclick="cmdApproved_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp;
                                                                        <asp:Button id="Back" onclick="Back_Click" runat="server" Width="53px" Text="No" CausesValidation="False"></asp:Button>
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
