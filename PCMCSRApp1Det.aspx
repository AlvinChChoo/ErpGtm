<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
                if page.isPostBack = false then
                    loadGridData
                    ProcLoadGridData
                    ProcLoadAtt
                    gridcontrol1.visible = true
    
                End if
            End Sub
    
            Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
            End Sub
    
            Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
                if lblapp1by.text <> "" then showAlert("S/R already submitted.\nNo editing of supplier is allowed.")
                if lblapp1by.text = "" then response.redirect("PCMCSRSplitPurchase.aspx?ID=" & SeqNo.text)
            End sub
    
            Sub OurPager(sender as object,e as datagridpagechangedeventargs)
            end sub
    
            Sub loadGridData()
                Dim strSql as string = "SELECT * FROM SR_M where SEQ_NO = " & request.params("ID") & ";"
                Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
                Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
                    do while ResExeDataReader.read
                        lblSRNo.text = ResExeDataReader("SR_NO")
                        lblRemarks.text = ResExeDataReader("Remarks").tostring
                        if isdbnull(ResExeDataReader("Submit_By")) = false then lblSubmitby.text = ucase(ResExeDataReader("Submit_By"))
                        if isdbnull(ResExeDataReader("Submit_Date")) = false then lblSubmitDate.text = format(cdate(ResExeDataReader("Submit_Date")),"dd/MMM/yy")
    
                        if isdbnull(ResExeDataReader("App1_By")) = false then lblApp1By.text = ucase(ResExeDataReader("App1_By"))
                        if isdbnull(ResExeDataReader("App1_Date")) = false then lblApp1Date.text = format(cdate(ResExeDataReader("App1_Date")),"dd/MMM/yy")
                        If isdbnull(ResExeDataReader("app1_Rem")) = true then lblApp1Rem.text = "-"
                        If isdbnull(ResExeDataReader("app1_Rem")) = false then lblApp1Rem.text = ResExeDataReader("App1_Rem").tostring
    
                        if isdbnull(ResExeDataReader("App2_By")) = false then lblApp2By.text = ucase(ResExeDataReader("App2_By"))
                        if isdbnull(ResExeDataReader("App2_Date")) = false then lblApp2Date.text = format(cdate(ResExeDataReader("App2_Date")),"dd/MMM/yy")
                        If isdbnull(ResExeDataReader("app2_Rem")) = true then lblApp2Rem.text = "-"
                        If isdbnull(ResExeDataReader("app2_Rem")) = false then lblApp2Rem.text = ResExeDataReader("App2_Rem").tostring
    
                        if isdbnull(ResExeDataReader("App3_By")) = false then lblApp3By.text = ucase(ResExeDataReader("App3_By"))
                        if isdbnull(ResExeDataReader("App3_Date")) = false then lblApp3Date.text = format(cdate(ResExeDataReader("App3_Date")),"dd/MMM/yy")
                        If isdbnull(ResExeDataReader("app3_Rem")) = true then lblApp3Rem.text = "-"
                        If isdbnull(ResExeDataReader("app3_Rem")) = false then lblApp3Rem.text = ResExeDataReader("App3_Rem").tostring
    
                        if isdbnull(ResExeDataReader("App1_By")) = false then
                            label1.visible = false
                            txtrem.visible =false
                            rbapprove.visible =false
                            rbReject.visible = false
                            cmdApprove.visible = false
                        else
                            if ResExeDataReader("SR_STATUS") = "REJECTED" then
                                label1.visible = false
                                txtrem.visible =false
                                rbapprove.visible =false
                                rbReject.visible = false
                                cmdApprove.visible = false
                            else
                                label1.visible = true
                                txtrem.visible =true
                                rbapprove.visible =true
                                rbReject.visible = true
                                cmdApprove.visible = true
                            end if
                        end if
                    loop
            end sub
    
            Sub ProcLoadGridData()
                Dim StrSql as string = "SELECT pr.rem,PR.Calculated_qty,PR.Ven_Code,pr.net_eta,PM.Part_Desc,PM.Buyer_Code,PR.VARIANCE,PR.ETA_Date,PR.QTY_TO_BUY,PR.Req_Qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM SR_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.SR_No = '" & trim(lblSRNo.text) & "' order by PR.ETA_Date asc"
                Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
                Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_D")
                GridControl1.DataSource=resExePagedDataSet.Tables("SR_D").DefaultView
                GridControl1.DataBind()
            end sub
    
            Sub Menu1_Load(sender As Object, e As EventArgs)
            End Sub
    
            Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
            End Sub
    
            Sub cmdMain_Click(sender As Object, e As EventArgs)
                response.redirect("Main.aspx")
            End Sub
    
            Sub Button2_Click(sender As Object, e As EventArgs)
            End Sub
    
            Sub cmdAddNew_Click(sender As Object, e As EventArgs)
                response.redirect("CustomerAddNew.aspx")
            End Sub
    
            Sub UserControl2_Load(sender As Object, e As EventArgs)
            End Sub
    
            Sub cmdBack_Click(sender As Object, e As EventArgs)
                Response.redirect("PCMCSRApp1.aspx")
            End Sub
    
            Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"dd/MM/yy")
                E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"dd/MM/yy")
                E.Item.Cells(8).Text = cint(E.Item.Cells(8).Text)
                E.Item.Cells(9).Text = format(cdec(E.Item.Cells(9).Text),"##,##0.000")
                E.Item.Cells(12).Text = format(E.Item.Cells(9).Text * E.Item.Cells(8).Text,"##,##0.00")
    
                Dim PRQty as Label = CType(e.Item.FindControl("PRQty"), Label)
                Dim MaxQty as Label = CType(e.Item.FindControl("MaxQty"), Label)
                Dim BuyerApproval as Label = CType(e.Item.FindControl("BuyerApproval"), Label)
                Dim QtyToBuy as TextBox = CType(e.Item.FindControl("QtyToBuy"), TextBox)
                E.Item.Cells(11).Text = format(E.Item.Cells(9).Text * QtyToBuy.Text,"##,##0.00")
                MaxQty.text = format(clng(MaxQty.text),"##,##0")
                e.item.cssclass = ""
                if trim(lblApp1Date.text) <> "" then QtyToBuy.enabled = false
            End if
        End Sub
    
        Sub cmdApprove_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MReceiver,MSender,cc,StrSql as string
            if rbApprove.checked = true then
                ReqCOM.ExecuteNonQuery("Update SR_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',App1_Rem = '" & trim(txtRem.text) & "',App1_Status='Y' where SR_No = '" & trim(lblSRNo.text) & "';")
                ReqCOM.ExecuteNonQuery("Update SR_d set SR_D.MIN_ORDER_QTY = Part_Source.MIN_ORDER_QTY,SR_D.std_pack_qty = Part_Source.std_pack_qty FROM PART_SOURCE,SR_D WHERE SR_d.SR_NO = '" & TRIM(lblSRNo.text) & "' AND SR_D.VEN_CODE = PART_SOURCE.VEN_CODE AND sr_d.part_no=part_source.part_no")
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID  = '" & trim(lblSubmitBy.text) & "';","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"Y")
                ShowAlert ("SR sumbitted for further approval.")
            elseif rbReject.checked = true then
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select Submit_By from sr_m where sr_no = '" & trim(lblSRNo.text) & "')","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"N")
                ReqCOM.ExecuteNonQuery("Update SR_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',App1_Rem = '" & trim(txtRem.text) & "',App1_Status='N',sr_status = 'REJECTED' where SR_No = '" & trim(lblSRNo.text) & "';")
                ShowAlert ("Selected SR has been rejected.")
            end if
            redirectPage("PCMCSRApp1Det.aspx?ID=" & Request.params("ID"))
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
    
        Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
        End Sub
    
        Sub GenerateMail(Sender as string, Receiver as string,CC as string,DOcNo as string,SRStatus as string)
            Dim objEmail as New MailMessage()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrMsg as string
            Dim TotalQty as decimal
            Dim TotalAmt as Decimal
            Dim POTotal as Decimal
            Dim ObjAttachment as MailAttachment
    
            if SRStatus = "Y" then
                StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
                StrMsg = StrMsg + "There is a New Special Request (from PCMC) pending for your approval." & vblf & vblf & vblf
                StrMsg = StrMsg + "The special request reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
                StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PCMCSRApp2Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SR_M where SR_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
                StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
                StrMsg = StrMsg + "Regards," & vblf & vblf
                StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
                objEmail.Subject  = "Special Request Pending Approval : " & DOcNo
            Elseif SRStatus = "N" then
                StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
                StrMsg = StrMsg + "There is a Special Request rejected by " & request.cookies("U_ID").value & vblf & vblf & vblf
                StrMsg = StrMsg + "Special Request Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
                StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
                StrMsg = StrMsg + "Regards," & vblf & vblf
                StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
                objEmail.Subject  = "Special Request Rejected : " & DOcNo
            end if
            objEmail.To       = trim(Receiver)
            objEmail.From     = trim(Sender)
            objEmail.CC       = trim(CC)
            objEmail.Body     = StrMsg
            objEmail.Priority = MailPriority.High
            SmtpMail.SmtpServer  = "192.168.42.111"
            SmtpMail.Send(objEmail)
        End sub
    
        Sub ProcLoadAtt()
             Dim StrSql as string = "Select * from SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "';"
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_ATTACHMENT")
             dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SR_ATTACHMENT").DefaultView
             dtgUPASAttachment.DataBind()
         end sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid  = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim QtyToBuy as textbox
            Dim ReqQty,MaxQty,lblSeqNo as label
            Dim strSql as string
            Dim i as integer
    
            For i = 0 To gridcontrol1.Items.Count - 1
                QtyToBuy = CType(gridcontrol1.Items(i).FindControl("QtyToBuy"), textbox)
                ReqQty = CType(gridcontrol1.Items(i).FindControl("ReqQty"), Label)
                MaxQty = CType(gridcontrol1.Items(i).FindControl("MaxQty"), Label)
                lblSeqNo = CType(gridcontrol1.Items(i).FindControl("lblSeqNo"), Label)
                ReqCOM.ExecuteNonQuery("Update SR_D set Qty_To_Buy = " & QtyToBuy.text & " where Seq_No = " & lblSeqNo.text & ";")
                ReqCOM.ExecuteNonQuery("uPDATE SR_D SET Variance = Qty_To_Buy - Req_Qty where Seq_No = " & lblSeqNo.text & ";")
            next i
            ProcLoadGridData
        End if
    End Sub
    
    Sub ValQtyToBuy_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim QtyToBuy as textbox
        Dim ReqQty,MaxQty,lblSeqNo as label
        Dim i as integer
    
        For i = 0 To gridcontrol1.Items.Count - 1
            QtyToBuy = CType(gridcontrol1.Items(i).FindControl("QtyToBuy"), textbox)
            ReqQty = CType(gridcontrol1.Items(i).FindControl("ReqQty"), Label)
            MaxQty = CType(gridcontrol1.Items(i).FindControl("MaxQty"), Label)
            if (clng(QtyToBuy.text) > clng(MaxQty.text)) or (clng(QtyToBuy.text) < clng(ReqQty.text)) then
                ValQtyToBuy.errormessage = "Input error line " & i + 1
                e.isvalid = false
                exit sub
            end if
        next i
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
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SPECIAL REQUEST
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="ValQtyToBuy" runat="server" Width="100%" CssClass="ErrorText" OnServerValidate="ValQtyToBuy_ServerValidate" ForeColor=" " Display="Dynamic" ErrorMessage="Invalid Loose Quantity specified."></asp:CustomValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">SR No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSRNo" runat="server" cssclass="OutputText" width="315px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Submitted By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblRemarks" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">App1 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">App2 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">App3 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 77px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top">
                                                                    <p>
                                                                        <table style="HEIGHT: 11px" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt">
                                                                                                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                                <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                                <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                                                <Columns>
                                                                                                    <asp:TemplateColumn visible="false">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                                                                    <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadPCMCSRAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                                </Columns>
                                                                                            </asp:DataGrid>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="gridcontrol1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" OnPageIndexChanged="OurPager" OnEditCommand="SplitVendor" PagerStyle-HorizontalAligh="Right" OnSortCommand="SortGrid" AllowPaging="True" Font-Names="Verdana" Font-Name="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_Desc" SortExpression="PM.Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ETA_DATE" HeaderText="ETA" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="NET_ETA" HeaderText="TPR DATE" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="TPR QTY">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReqQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="QTY TO BUY(a)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox id="QtyToBuy" css="css" class="outputtext" runat="server" align="right" Columns="8" MaxLength="6" Text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' width="48px" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="SUGGESTED QTY">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MaxQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CALCULATED_QTY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR(Qty)(b)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UP" HeaderText="U/P(c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Ven_Code" HeaderText="Supplier"></asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Amt(a*c)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Var(Amt)(b*c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:EditCommandColumn ButtonType="PushButton" UpdateText="" CancelText="" EditText="Split"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn Visible="False" HeaderText="Select">
                                                                                    <HeaderTemplate>
                                                                                        <input id="chkAllItems" type="checkBox" onclick="CheckAllDataGridCheckBoxs('Remove',document.forms[0].chkAllItems.checked)" />
                                                                                    </HeaderTemplate>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Remove" runat="server" checked="true" />
                                                                                        </center>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remarks">
                                                                                    <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Left"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox id="Rem" TextMode="MultiLine" css="css" class="outputtext" runat="server" align="right" Columns="30" MaxLength="100" Text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' />
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
                                                                                    <td width="10%" bgcolor="yellow">
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp; <asp:Label id="Label11" runat="server" cssclass="OutputText" width="100%">Purchase
                                                                                        Qty. exceeded requested qty.</asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                                    <td width="55%">
                                                                                        <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" Height="56px"></asp:TextBox>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <asp:RadioButton id="rbApprove" runat="server" CssClass="OutputText" Text="Approve" GroupName="Status"></asp:RadioButton>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <asp:RadioButton id="rbReject" runat="server" CssClass="OutputText" Text="Reject" GroupName="Status"></asp:RadioButton>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
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
                                                <p>
                                                    <table style="HEIGHT: 30px" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Width="154px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="156px" Text="Update"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="156px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>