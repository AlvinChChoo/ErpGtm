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
            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR1_M where Seq_No = " & Request.params("ID") & ";")
            Do while RsApproval.read
                lblPRNo.text = RsApproval("PR_NO").tostring
                if isdbnull(rsApproval("Submit_By")) = false then lblSubmitBy.text = RsApproval("Submit_By")
                if isdbnull(rsApproval("Submit_Date")) = false then lblSubmitDate.text = format(RsApproval("Submit_Date"),"dd/MMM/yy")
                if isdbnull(rsApproval("App1_Date")) = false then lblApp1By.text = rsApproval("App1_By"):lblApp1Date.text = format(cdate(rsApproval("App1_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App2_Date")) = false then lblApp2By.text = rsApproval("App2_By"):lblApp2Date.text = format(cdate(rsApproval("App2_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App3_Date")) = false then lblApp3By.text = rsApproval("App3_By"):lblApp3Date.text = format(cdate(rsApproval("App3_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App4_Date")) = false then lblApp4By.text = rsApproval("App4_By"):lblApp4Date.text = format(cdate(rsApproval("App4_Date")),"dd/MMM/yy")
                lblApp1Rem.text = rsApproval("App1_Rem").tostring
                lblApp2Rem.text = rsApproval("App2_Rem").tostring
                lblApp3Rem.text = rsApproval("App3_Rem").tostring
            Loop
            LoadPRDet()

            if trim(lblSubmitBy.text) <> "" then cmdSubmit.enabled = false
        end if
    End Sub

        Sub LoadPRDet()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string = "SELECT pr.item_buyer_rem,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.part_no,pr.REQ_DATE asc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
            dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
            dtgPartWithSource.DataBind()
            lblTotal.text = "Total Amount  :  " & format(cdec(TotalAmt),"##,##0.00")
        End sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim lblVar As Label = CType(e.Item.FindControl("lblVar"), Label)
            Dim BuyQty As Label = CType(e.Item.FindControl("lblBuyQty"), Label)
            Dim EditPart As LinkButton = CType(e.Item.FindControl("EditPart"), LinkButton)
            Dim PartDet As Textbox = CType(e.Item.FindControl("PartDet"), Textbox)
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            Dim PartDesc As Label = CType(e.Item.FindControl("PartDesc"), Label)
            Dim ReqDate As Label = CType(e.Item.FindControl("lblReqDate"), Label)
            Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
            Dim PRQty As Label = CType(e.Item.FindControl("lblPRQty"), Label)
            Dim QtyDet As Textbox = CType(e.Item.FindControl("QtyDet"), Textbox)
            Dim VenDet As Textbox = CType(e.Item.FindControl("VenDet"), Textbox)
            Dim lblBuyQty As label = CType(e.Item.FindControl("lblBuyQty"), label)
            Dim MOQ As label = CType(e.Item.FindControl("MOQ"), label)
            Dim SPQ As label = CType(e.Item.FindControl("SPQ"), label)
            Dim VenCode As Label = CType(e.Item.FindControl("VenName"), Label)
            Dim UP As label = CType(e.Item.FindControl("lblUP"), label)
            Dim Amt As label = CType(e.Item.FindControl("lblAmt"), label)

            Amt.text = format(BuyQty.text * UP.text,"##,##0.00")
            ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")

            'ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            'Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
            'PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")


            'e.item.cells(6).text = format(cdec(e.item.cells(6).text),"##,##0.00000")
            'e.item.cells(7).text = format(BuyQty.text * e.item.cells(6).text,"##,##0.00")

            PartDet.text = "Part # : " & trim(PartNo.text) & vblf & "Desc.  : " & trim(PartDesc.text) & vblf & "Req. Date : " & trim(ReqDate.text) & vblf & "P/R Date  : " & trim(PRDate.text)

            'QtyDet.text = "PR Qty     : " & PRQty.text & vblf & "Order Qty : " & lblBuyQty.text & vblf & "Unit Price  : " & UP.text & vblf & "Amount    : " & Amt.text
            QtyDet.text = "PR Qty     : " & PRQty.text & vblf & "Order Qty : " & lblBuyQty.text & vblf & "Unit Price  : " & UP.text & vblf & "Amount    : " & Amt.text

            VenDet.text = trim(VenCOde.text) & vblf & vblf & "MOQ : " & moq.text & vblf & "SPQ : " & spq.text
            'VenDet.text = trim(VenCOde.text)

            TotalAmt = TotalAmt + Amt.text
            if trim(lblSubmitBy.text) <> "" then EditPart.enabled = false
        End if
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PR.aspx")
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
        UpdateLowestUPDet()
        ReqCOM.ExecuteNonQUery("Update PR1_M set Submit_by = '" & trim(request.cookies("U_ID").value) & "',Submit_Date = '" & now & "' where pr_no = '" & trim(lblPRNo.text) & "';")
        ShowAlert("PR submited for buyer processing.")
        redirectPage("PRDet.aspx?ID=" & Request.params("ID"))
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
                if trim(StrSql) = "" then StrSql = "Update PR1_D set Ref_Seq = " & clng(RefSeq) & " where part_no = '" & trim(drGetFieldVal("PartNo")) & "' and PR_No = '" & trim(lblPRNo.text) & "'"
                if trim(StrSql) <> "" then StrSql = StrSql + ";Update PR1_D set Ref_Seq = " & clng(RefSeq) & " where part_no = '" & trim(drGetFieldVal("PartNo")) & "' and PR_No = '" & trim(lblPRNo.text) & "'"
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

    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgPartWithSource.CurrentPageIndex = e.NewPageIndex
        LoadPRDet()
    end sub

    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
        Dim PRNo as string = ReqCOM.GetDocumentNo("PR_No")
        UpdateSelectedItem()
        ReqCOM.ExecuteNonQuery("Insert into pr_deleted_item(MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,BUYER_APPROVAL,BUYER_PROCESS,PR_APP_SUBMITTED,APPROVAL_NO,APPROVED,BUYER_IND,CALCULATED_QTY,REM,MOQ,SPQ,PO_GENERATED,IND,ITEM_REM) select MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,BUYER_APPROVAL,BUYER_PROCESS,PR_APP_SUBMITTED,APPROVAL_NO,APPROVED,BUYER_IND,CALCULATED_QTY,REM,MOQ,SPQ,PO_GENERATED,IND,ITEM_REM from pr1_d where pr_no = '" & trim(lblPRNo.text) & "' and sel = 'Y'")
        ReqCOM.ExecuteNonQuery("Delete from pr1_d where pr_no = '" & trim(lblPRNo.text) & "' and sel = 'Y'")
        ShowAlert("Selected parts has been removed.")
        redirectPage("PRDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub UpdateSelectedItem()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i as integer
        Dim StrSql as string
        Dim Reject As CheckBox
        Dim SeqNo As Label
        Dim ItemRem As Textbox

        For i = 0 To dtgPartWithSource.Items.Count - 1
            Reject = CType(dtgPartWithSource.Items(i).FindControl("Reject"), CheckBox)
            SeqNo = CType(dtgPartWithSource.Items(i).FindControl("SeqNo"), Label)
            ItemRem = CType(dtgPartWithSource.Items(i).FindControl("ItemRem"), textbox)

            if Reject.checked = true then
                if trim(strsql) = "" then
                    StrSql = "Update PR1_D set Sel = 'Y',Item_Rem = '" & replace(trim(ItemRem.text),"'","`") & "' where Seq_No = " & clng(SeqNo.text) & ""
                elseif trim(strsql) <> "" then
                    StrSql = StrSql + ";Update PR1_D set Sel = 'Y',Item_Rem = '" & replace(trim(ItemRem.text),"'","`") & "' where Seq_No = " & clng(SeqNo.text) & ""
                end if
            end if
        Next i
        if trim(StrSql) <> "" then ReqCOM.ExecuteNonQuery(StrSql)
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
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Submit By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblSubmitRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Approval 1 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp1Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Approval 2 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp2Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Approval 3 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp3Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
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
                                                <p align="center">
                                                    <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="98%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="SectionHeader">PR
                                                                        DETAILS</asp:Label>
                                                                    </div>
                                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="98%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnItemCommand="ShowDet" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PageSize="30" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnPageIndexChanged="OurPager">
                                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                                            <Columns>
                                                                                                <asp:TemplateColumn >
                                                                                                    <HeaderStyle horizontalalign="left"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="left"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:LinkButton id="ViewWUL" CommandArgument='ViewWUL' runat="server" Font-Size="X-Small" >WUL</asp:LinkButton>
                                                                                                        <asp:LinkButton id="EditPart" CommandArgument='EditPart' runat="server" Font-Size="X-Small" >Edit Part</asp:LinkButton>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn HeaderText="Part Det.">
                                                                                                    <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="left"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:textbox id="PartDet" CssClass="ListOutput" runat="server" width= "180px" height= "80px" ReadOnly="True" TextMode="MultiLine" ></asp:textbox>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn HeaderText="Qty/UP">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:textbox id="QtyDet" CssClass="ListOutput" runat="server" width= "150px" height= "80px" ReadOnly="True" TextMode="MultiLine" ></asp:textbox>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn HeaderText="Supplier/MOQ/SPQ">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:textbox id="VenDet" CssClass="ListOutput" runat="server" width= "150px" height= "80px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "ven_name") %>'></asp:textbox>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn Visible="false">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn Visible="false">
                                                                                                    <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Left"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="PartDesc" cssclass="ListOutput" runat="server" width= "150px" readonly="True" textmode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>'></asp:Label>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn Visible="false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblReqDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible="false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblPRQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_QTY") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible="false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblBuyQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QTY_TO_BUY") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible= "false">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible= "false">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblAmt" runat="server" visible= "false" />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible= "false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="VenName" cssclass="ListOutput" runat="server" width= "150px" readonly="True" textmode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "ven_name") %>'></asp:Label>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible= "false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="MOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible= "false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="SPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn visible= "false">
                                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="lblPRDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_DATE") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn HeaderText="MC / Buyer Remarks">
                                                                                                    <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Left"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <asp:textbox id="ItemRem" CssClass="ListOutput" runat="server" width= "190px" height= "40px" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "Item_Rem") %>'></asp:textbox>
                                                                                                        <asp:textbox id="ItemBuyerRem" CssClass="ListOutput" runat="server" width= "190px" height= "40px" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "Item_Buyer_Rem") %>'></asp:textbox>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn Visible="False">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_NO") %>' />
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:TemplateColumn HeaderText="R">
                                                                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                                    <ItemTemplate>
                                                                                                        <center>
                                                                                                            <asp:CheckBox id="Reject" runat="server" />
                                                                                                        </center>
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                            </Columns>
                                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                                        </asp:DataGrid>
                                                                                    </p>
                                                                                    <p>
                                                                                        <table style="HEIGHT: 9px" width="100%">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <div align="right"><asp:Label id="lblTotal" runat="server" width="100%" cssclass="Instruction"></asp:Label>
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
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="104px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center" width="34%">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="180px" Text="REMOVE Selected Item" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="103px" Text="Back"></asp:Button>
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
