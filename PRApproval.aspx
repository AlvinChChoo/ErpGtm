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

    Public RecordCount as integer
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            RecordCount = 0
            If SortField = "" then SortField = "MRP_No"
            Dim reqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            LoadDataWithSource()
            Label2.text = RecordCount & " parts have being selected for PR Approval."
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
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code + '|' + ven.Ven_Name as [Ven_Name] FROM tpr_d PR, vendor ven WHERE pr.ven_code = ven.ven_code and pr.Buyer_Approval = 'Y' and PR.Approval_No is null and PR.PR_APP_SUBMITTED = 'N' order by pr.part_no,pr.pr_date asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        Dim DV as New DataView(resExePagedDataSet.Tables("pr1"))
        Dim SortSeq as String
    
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        DV.Sort = SortField + " " + SortSeq
        dtgPartWithSource.DataSource=DV
        dtgPartWithSource.DataBind()
    end sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            RecordCount = RecordCount + 1
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            E.Item.Cells(2).Text = format(cdate(E.Item.Cells(2).Text),"MM/dd/yy")
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = cint(E.Item.Cells(4).Text)
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(6).Text = cint(E.Item.Cells(6).Text)
            E.Item.Cells(7).Text = format(cdec(E.Item.Cells(7).Text),"##,##0.0000")
    
            e.item.cells(8).text = format(e.item.cells(5).text * e.item.cells(7).text,"##,##0.0000")
        End if
    End Sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
        response.redirect("SplitPurchase.aspx?ID=" & e.Item.cells(0).text)
    End sub
    
    Sub dtgPartWithoutSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRHODPendingPRSubmission.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub cmdConfirm_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GtM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim PRApprovalNo as integer = ReqCOM.GetDocumentNo("PR_APPROVAL_NO")
            Dim MyTrans as SQLTransaction
            Dim myConnection As SqlConnection
            Dim myCommand As New sqlCommand
    
            myConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            myTrans=myConnection.BeginTransaction()
            myCommand.Connection = myConnection
    
            Dim StrSql as string
            Dim i as integer
            Try
                For i = 0 to dtgPartWithSource.Items.Count - 1
                    Dim SeqNo as Label = CType(dtgPartWithSource.Items(i).findControl("Seq_No"), Label)
    
    
                    StrSql = "Insert into PR1_D(MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,BUYER_APPROVAL,BUYER_PROCESS,PR_APP_SUBMITTED,APPROVAL_NO,APPROVED) "
                    StrSql = StrSql & "Select MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,BUYER_APPROVAL,BUYER_PROCESS,PR_APP_SUBMITTED," & CINT(PRApprovalNo) & ",APPROVED from TPR_D where seq_no = " & cint(SeqNo.text) & ""
                    myCommand.CommandType = CommandType.Text
                    myCommand.CommandText = StrSQL
                    myCommand.Transaction=myTrans
                    myCommand.ExecuteNonQuery()
    
                    StrSql = "Update TPR_D set Approval_No = " & cint(PRApprovalNo) & " where seq_no = " & cint(SeqNo.text) & ";"
                    myCommand.CommandType = CommandType.Text
                    myCommand.CommandText = StrSQL
                    myCommand.Transaction=myTrans
                    myCommand.ExecuteNonQuery()
    
                next
                StrSql = "Update Main set PR_APPROVAL_NO = PR_APPROVAL_NO + 1"
                myCommand.CommandText = StrSQL
                myCommand.ExecuteNonQuery()
    
    
                StrSql = "Insert into PR_Approval(Approval_no,Submit_date,Submit_by,PR_STATUS) "
                StrSql = StrSql + "Select " & PRApprovalNo & ",'" & now & "','" & trim(ucase(request.cookies("U_ID").value)) & "','PENDING APPROVAL';"
    
                myCommand.CommandText = StrSQL
                myCommand.ExecuteNonQuery()
                myTrans.Commit()
                response.cookies("AlertMessage").value = "Parts have been sent for approval"
                response.redirect("AlertMessage.aspx?ReturnURL=TempPRHODPendingPRSubmission.aspx")
            Catch err As Exception
                myTrans.Rollback()
                response.write(err.tostring())
            Finally
                myCommand.Dispose()
                myConnection.Close()
                myConnection.Dispose()
            End Try
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
            <table style="HEIGHT: 251px" height="251" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="Instruction" width="100%"></asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" PageSize="1" OnEditCommand="SplitVendor" OnItemDataBound="FormatRow" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="" visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Seq_No" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="REQ_DATE" HeaderText="REQ DATE" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PR_DATE" HeaderText="PR DATE" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PR_QTY" HeaderText="PR QTY" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="QTY_TO_BUY" HeaderText="BUY QTY" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="Amount">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ven_name" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" cssclass="Instruction">Are you sure to submit
                                                    the selected parts for PR approval ?</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 15px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdConfirm" onclick="cmdConfirm_Click" runat="server" CausesValidation="False" Text="Yes" Width="53px"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" CausesValidation="False" Text="No" Width="53px"></asp:Button>
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
</body>
</html>
