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

    Public TotalAmt as decimal
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ApprovalNo as integer
            TotalAmt = 0

            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR1_M where Seq_No = " & request.params("ID") & ";")
            Do while RsApproval.read
                lblPRNo.text = RsApproval("PR_NO").tostring
                lblSubmitBy.text = RsApproval("Submit_By")
                lblSubmitDate.text = format(RsApproval("Submit_Date"),"dd/MMM/yy")

                if isdbnull(rsApproval("App1_Date")) = false then lblApp1By.text = rsApproval("App1_By"):lblApp1Date.text = format(cdate(rsApproval("App1_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App2_Date")) = false then lblApp2By.text = rsApproval("App2_By"):lblApp2Date.text = format(cdate(rsApproval("App2_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App3_Date")) = false then lblApp3By.text = rsApproval("App3_By"):lblApp3Date.text = format(cdate(rsApproval("App3_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App4_Date")) = false then lblApp4By.text = rsApproval("App4_By"):lblApp4Date.text = format(cdate(rsApproval("App4_Date")),"dd/MMM/yy")
                lblApp1Rem.text = rsApproval("App1_Rem").tostring
                lblApp2Rem.text = rsApproval("App2_Rem").tostring
                lblApp3Rem.text = rsApproval("App3_Rem").tostring
                if trim(lblApp1By.text) <> "" then cmdSubmit.visible = false
            Loop

            LoadDataWithSource()

            Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.Seq_No asc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
            dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
            dtgPartWithSource.DataBind()
            lblTotal.text = "Total Amount  :  " & cdec(format(TotalAmt,"##,##0.00"))
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
            ReqDate.text = format(cdate(ReqDate.text),"dd/MMM/yy")
            Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
            PRDate.text = format(cdate(PRDate.text),"dd/MMM/yy")

            Dim BuyQty As Label = CType(e.Item.FindControl("lblBuyQty"), Label)


            e.item.cells(6).text = format(cdec(e.item.cells(6).text),"##,##0.00000")
            e.item.cells(7).text = format(BuyQty.text * e.item.cells(6).text,"##,##0.00")
            TotalAmt = TotalAmt + cdec(e.item.cells(7).text)
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

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApp1.aspx")
    End Sub

    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update PR1_M set App1_By = '"& trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "' where PR_NO = '" & trim(lblPRNo.text) & "';")
        ShowAlert ("Selected PR has been submitted.")
        redirectPage("PRApp1Det.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub

</script>
<html>
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
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">PR APPROVAL
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">PR No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPRNo" runat="server" cssclass="OutputText" width="84px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Submit By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblSubmitRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Approval 1 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Approval 2 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Approval 3 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">P/O Genetated By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
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
                                                            <asp:BoundColumn HeaderText="Amount">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ven_name" SortExpression="Ven.Ven_Code" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                    <table style="HEIGHT: 10px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblTotal" runat="server" cssclass="Instruction" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <div align="left">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="119px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="148px" Text="Back"></asp:Button>
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
