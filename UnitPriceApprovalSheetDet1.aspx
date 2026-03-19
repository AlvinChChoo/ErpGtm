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
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
    
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                txtRem.text = RsUPASM("REM").tostring
    
                if isdbnull(RsUPASM("CREATE_BY")) = false then lblCreateBy.text = RsUPASM("CREATE_BY").tostring & " (" & format(CDATE(RsUPASM("CREATE_DATE")),"MM/dd/yy") & ")" else lblCreateBy.text = "-"
                if isdbnull(RsUPASM("SUBMIT_BY")) = false then lblSubmitBy.text = RsUPASM("SUBMIT_BY").tostring & " (" & format(cdate(RsUPASM("SUBMIT_DATE")),"MM/dd/yy") & ")" else lblSubmitBy.text = "-"
    
    
                if trim(RsUPASM("UPAS_STATUS").tostring) = "REJECTED" then
                    if ISDBNULL(RsUPASM("NEW_UPAS_NO")) = true then lnkNewRevision.visible = true else lnkNewRevision.visible = false
                else
                    lnkNewRevision.visible = false
                End if
    
                if isdbnull(RsUPASM("PURC_BY")) = false then
                    if RsUPASM("PURC_Status").tostring = "REJECTED" THEN lblPurcBy.cssclass = "ErrorText"
                    lblPurcBy.text = RsUPASM("PURC_BY").tostring & " (" & format(cdate(RsUPASM("PURC_Date")),"MM/dd/yy") & ") " & RsUPASM("PURC_REM").tostring
                else
                    lblPurcBy.text = "-"
                end if
    
                if isdbnull(RsUPASM("Acc_BY")) = false then
                    if RsUPASM("ACC_Status").tostring = "REJECTED" THEN lblAccBy.cssclass = "ErrorText"
                    lblAccBy.text = RsUPASM("ACC_BY").tostring & " (" & format(cdate(RsUPASM("ACC_Date")),"MM/dd/yy") & ") " & RsUPASM("ACC_REM").tostring
                else
                    lblAccBy.text = "-"
                end if
    
                if isdbnull(RsUPASM("MGT_BY")) = false then
                    if RsUPASM("MGT_Status").tostring = "REJECTED" THEN lblMgtBy.cssclass = "ErrorText"
                    lblMgtBy.text = RsUPASM("MGT_BY").tostring & " (" & format(cdate(RsUPASM("MGT_Date")),"MM/dd/yy") & ") " & RsUPASM("MGT_REM").tostring
                else
                    lblMgtBy.text = "-"
                end if
    
                if trim(RsUPASM("UPAS_Status").tostring) = "REJECTED" THEN
                    if RsUPASM("PURC_Status").tostring = "REJECTED" then lblStatus.text = "Rejected by Purchasing."
                    if RsUPASM("ACC_Status").tostring = "REJECTED" then lblStatus.text = "Rejected by Accounts."
                    if RsUPASM("MGT_Status").tostring = "REJECTED" then lblStatus.text = "Rejected by Management."
                else
                    lblStatus.text = RsUPASM("UPAS_status").tostring
                end if
    
                if isdbnull(RsUPASM("SUBMIT_BY")) = false then
                    lnkadd.visible = false
                    lnkremove.visible = false
                    lnkedit.visible = false
                    cmdSubmit.visible = false
                    cmdUpdatelist.visible = false
                else
                    lnkadd.visible = true
                    lnkremove.visible = true
                    lnkedit.visible = true
                    cmdSubmit.visible = true
                    cmdUpdatelist.visible = true
                end if
            loop
            RsUPASM.Close
            LoadData
        end if
    End Sub
    
    sub LoadData
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet("Select * from UPAS_D where UPAS_NO = '" & trim(lblUPASNo.text) & "';","UPAS_D")
        DataGrid1.DataSource=resExePagedDataSet.Tables("UPAS_D").DefaultView
        DataGrid1.DataBind()
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdateList_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To DataGrid1.Items.Count - 1
            Dim SeqNo As Label = CType(DataGrid1.Items(i).FindControl("SeqNo"), Label)
            Dim remove As CheckBox = CType(DataGrid1.Items(i).FindControl("Remove"), CheckBox)
            If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from UPAS_D where Seq_No = '" & trim(SeqNo.text) & "';")
        Next
        response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub lnkAdd_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetItemAddNew.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub lnkEdit_Click(sender As Object, e As EventArgs)
        Response.redirect("UnitPriceApprovalSheetItemEdit.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub lnkRemove_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetItemRemove.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheet.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Response.redirect("UnitPriceApprovalSheetSubmit.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim Remove As Checkbox = CType(e.Item.FindControl("Remove"), Checkbox)
            if trim(lblSubmitBy.text) <> "-" then Remove.enabled = false
        End if
    End Sub
    
    Sub lnkNewRevision_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetNewRevision.aspx?ID=" & request.params("ID"))
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label5" runat="server" cssclass="FormDesc" width="100%">UNIT PRICE
                                APPROVAL SHEET DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 89px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" width="384px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="128px">Remarks</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtRem" runat="server" Height="50px" Width="382px" MaxLength="30" Columns="30" Font-Size="X-Small" Font-Names="Verdana" CssClass="OutputText"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="128px">Status</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStatus" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px">Prepared
                                                                    by</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="128px">Submit
                                                                    by</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="108px">Purc /
                                                                    PCMC</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPurcBy" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="128px">Accounts</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblAccBy" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="128px">Management</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMgtBy" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 15px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:LinkButton id="lnkAdd" onclick="lnkAdd_Click" runat="server" Width="100%">Click here to add
new source.</asp:LinkButton>
                                                                        <asp:LinkButton id="lnkRemove" onclick="lnkRemove_Click" runat="server" Width="100%">Click here to remove
existing source.</asp:LinkButton>
                                                                        <asp:LinkButton id="lnkEdit" onclick="lnkEdit_Click" runat="server" Width="100%">Click here to edit
existing source.</asp:LinkButton>
                                                                    </p>
                                                                    <p align="center">
                                                                        <asp:DataGrid id="DataGrid1" runat="server" width="100%" Font-Size="XX-Small" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowPaging="false" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="false" AutoGenerateColumns="False" Font-Name="Verdana" OnItemDataBound="FormatRow">
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="ACT" HeaderText="Action"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="VEN_CODE" HeaderText="Supplier(C)"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="A_VEN_CODE" HeaderText="Supplier(N)"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UP" HeaderText="U/P(C)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="A_UP" HeaderText="U/P(N)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="DIFF_AMT" HeaderText="Diff(amt)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="DIFF_PCTG" HeaderText="Diff(%)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="LEAD_TIME" HeaderText="L/T(C)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="A_LEAD_TIME" HeaderText="L/T(N)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="STD_PACK" HeaderText="SPQ(C)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="A_STD_PACK" HeaderText="SPQ(N)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="MIN_ORDER_QTY" HeaderText="MOQ(C)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="A_MIN_ORDER_QTY" HeaderText="MOQ(N)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Remove">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Remove" runat="server" />
                                                                                        </center>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <asp:LinkButton id="lnkNewRevision" onclick="lnkNewRevision_Click" runat="server" Width="">Click here to generate new revision of approval sheet.</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="139px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdateList" onclick="cmdUpdateList_Click" runat="server" Width="158px" Text="Update List"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="134px" Text="Back"></asp:Button>
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
