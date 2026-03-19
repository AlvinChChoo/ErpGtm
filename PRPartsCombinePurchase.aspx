<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="PRDet" TagName="PRDet" Src="_PRDet_.ascx" %>
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

            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 pr.ven_code,pr.pr_no,pr.part_no,pr.moq,pr.spq,pm.part_desc,pm.part_spec from PR1_D PR,part_master PM where pr.part_no = pm.part_no and pr.seq_no = " & request.params("ID") & ";")
            Do while RsApproval.read
                lblPRNo.text = RsApproval("PR_NO").tostring
                lblPartNo.text = RsApproval("Part_NO").tostring
                lblMOQ.text = RsApproval("MOQ")
                lblSPQ.text = RsApproval("SPQ")
                lblPartDesc.text = RsApproval("Part_Desc")
                lblPartSpec.text = RsApproval("Part_Spec")

                lblVenCode.text = RsApproval("Ven_Code")
                lblVenName.text = ReqCOM.GetFieldVal("Select Top 1 Ven_Name from Vendor where Ven_Code = '" & trim(lblVenCOde.text) & "';","ven_Name")
            Loop
            ProcLoadGridData
        end if
    End Sub

    Sub ProcLoadGridData()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim StartDate,EndDate as date

        StrSql = "Select * from pr1_d where pr_no = '" & trim(lblPRNo.text) & "' and part_no = '" & trim(lblPartNo.text) & "' order by req_date asc"

        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"FECN_M")
        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))

        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqDate As Label = CType(e.Item.FindControl("ReqDate"), Label)
            Dim PRDate As Label = CType(e.Item.FindControl("PRDate"), Label)
            ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
        End if
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

    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim chkCombine as checkbox
        Dim PRQty,SeqNo as label
        Dim ItemToRemove as string
        Dim TotalPRQty,i,FirstSeqNo as long
        TotalPRQty = 0
        FirstSeqNo = 0
        ItemToRemove = 0

        For i = 0 To GridControl1.Items.Count - 1
            chkCombine = CType(GridControl1.Items(i).FindControl("chkCombine"), Checkbox)
            PRQty = CType(GridControl1.Items(i).FindControl("PRQty"), Label)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)

            if chkCombine.checked = true then
                TotalPRQty = TotalPRQty + clng(PRQty.text)

                if FirstSeqNo = 0 then
                    FirstSeqNo = clng(SeqNo.text)
                Elseif FirstSeqNo <> 0 then
                    ItemToRemove = ItemToRemove & "," & trim(SeqNo.text)
                end if

            End If
        next i

        'if trim(ItemToRemove) <> "" then response.write("Delete from PR1_D where seq_no in (" & trim(ItemToRemove) & ")")
        'if FirstSeqNo <> "0" then response.write("Update PR1_D set PR_Qty = " & clng(TotalPRQty) & " where Seq_No = " & clng(FirstSeqNo) & ";")

        if trim(ItemToRemove) <> "" then ReqCOM.ExecuteNonQuery("Delete from PR1_D where seq_no in (" & trim(ItemToRemove) & ")")
        if FirstSeqNo <> "0" then ReqCOM.ExecuteNonQuery("Update PR1_D set PR_Qty = " & clng(TotalPRQty) & " where Seq_No = " & clng(FirstSeqNo) & ";")

        ReqCOM.ExecuteNonQuery ("Update PR1_D set Qty_To_Buy = SPQ * ceiling(PR_Qty / SPQ) where seq_no = " & clng(FirstSeqNo) & ";")
        ProcLoadGridData
    End Sub

    Sub UpdateLowestUPDet()
        Dim StrSql as string = "Select Distinct(Part_No) as [PartNo] from PR1_D where PR_No = '" & trim(lblPRNo.text) & "';"
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim RefSeq as string
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

        StrSql = ""
        do while drGetFieldVal.read
            RefSeq = ReqCom.GetFieldVal("Select Top 1 Seq_No from Part_Source where Part_No = '" & trim(drGetFieldVal("PartNo")) & "' order by UP asc","Seq_No")
            if trim(RefSeq) <> "<NULL>" then
                if trim(StrSql) = "" then
                    StrSql = "Update PR1_D set Ref_Seq = " & clng(RefSeq) & " where part_no = '" & trim(drGetFieldVal("PartNo")) & "' and PR_No = '" & trim(lblPRNo.text) & "'"
                elseif trim(StrSql) <> "" then
                    StrSql = StrSql + ";Update PR1_D set Ref_Seq = " & clng(RefSeq) & " where part_no = '" & trim(drGetFieldVal("PartNo")) & "' and PR_No = '" & trim(lblPRNo.text) & "'"
                end if
            End if
        loop

        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()

        if Trim(StrSql) <> "" then ReqCOM.ExecuteNonQUery(StrSql)
        ReqCOM.ExecuteNonQUery("Update PR1_D set pr1_d.ref_ven_Name = VENDOR.ven_Name,pr1_d.ref_up = part_Source.up from PR1_D,Part_Source,VENDOR where VENDOR.ven_code = part_source.ven_code and pr1_d.ref_seq = part_Source.Seq_No and pr1_D.pr_no = '" & trim(lblPRNo.text) & "'")
    End Sub

    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        if trim(e.commandargument) = "ViewWUL" then
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
            redirectPage("PRDet.aspx?ID=" & Request.params("ID"))
        elseif trim(e.commandargument) = "EditPart" then
            Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
            Response.redirect("PREditPart.aspx?ID=" & clng(SeqNo.text))
        end if
    End sub

    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        page.RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Sub cmdClose_Click(sender As Object, e As EventArgs)
        CloseIE()
    End Sub

    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 184px" height="184" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">PR APPROVAL
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="70%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">PR No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPRNo" runat="server" width="84px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">PR No/Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblVenCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">MOQ/SPQ</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMOQ" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblSPQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="98%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow" OnItemCommand="ShowDet" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Req. Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReqDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>' /> <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="P/R Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PRDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Date") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="P/R Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PRQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Qty") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Order Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="QtyToBuy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="U/P">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Amt">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Amt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") * DataBinder.Eval(Container.DataItem, "qTY_tO_bUY")  %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Combine">
                                                                                    <ItemTemplate>
                                                                                        <asp:checkbox id="chkCombine" runat="server" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </div>
                                                                    <div align="center">
                                                                        <p>
                                                                            <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td width="33%">
                                                                                            <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" CssClass="OutputText" Width="104px"></asp:Button>
                                                                                        </td>
                                                                                        <td width="33%">
                                                                                            <div align="right">
                                                                                                <asp:Button id="cmdClose" onclick="cmdClose_Click" runat="server" Text="Close" CssClass="OutputText" Width="104px"></asp:Button>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </p>
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
