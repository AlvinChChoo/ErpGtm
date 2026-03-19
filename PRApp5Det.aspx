<%@ Page Language="VB" %>
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
            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR1_M where Seq_No = " & Request.params("ID") & ";")
            Do while RsApproval.read
                lblPRNo.text = RsApproval("PR_NO").tostring
                lblSubmitBy.text = RsApproval("Submit_By")
                lblSubmitDate.text = format(RsApproval("Submit_Date"),"dd/MMM/yy")
                if isdbnull(rsApproval("App1_Date")) = false then lblApp1By.text = rsApproval("App1_By"):lblApp1Date.text = format(cdate(rsApproval("App1_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App2_Date")) = false then lblApp2By.text = rsApproval("App2_By"):lblApp2Date.text = format(cdate(rsApproval("App2_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App3_Date")) = false then lblApp3By.text = rsApproval("App3_By"):lblApp3Date.text = format(cdate(rsApproval("App3_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App4_Date")) = false then lblApp4By.text = rsApproval("App4_By"):lblApp4Date.text = format(cdate(rsApproval("App4_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App5_Date")) = false then lblApp5By.text = rsApproval("App5_By"):lblApp5Date.text = format(cdate(rsApproval("App5_Date")),"dd/MMM/yy")
                lblApp1Rem.text = rsApproval("App1_Rem").tostring
                lblApp2Rem.text = rsApproval("App2_Rem").tostring
                lblApp3Rem.text = rsApproval("App3_Rem").tostring
                if isdbnull(RsApproval("App5_By")) = false then cmdPO.enabled = false
                if isdbnull(RsApproval("App5_By")) = true then cmdPO.enabled = true
            Loop
    
            LoadPRDet
        end if
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
         If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
             Dim ReqDate As Label = CType(e.Item.FindControl("lblReqDate"), Label)
             ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
             Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
             PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
             Dim lblVar As Label = CType(e.Item.FindControl("lblVar"), Label)
             Dim BuyQty As Label = CType(e.Item.FindControl("lblBuyQty"), Label)
             Dim POGenerated As Label = CType(e.Item.FindControl("POGenerated"), Label)
             Dim Sel As CheckBox = CType(e.Item.FindControl("Sel"), CheckBox)
             e.item.cells(6).text = format(cdec(e.item.cells(6).text),"##,##0.00000")
             e.item.cells(7).text = format(BuyQty.text * e.item.cells(6).text,"##,##0.00")
             TotalAmt = TotalAmt + cdec(e.item.cells(7).text)
            if trim(POGenerated.text) = "Y" then Sel.checked = true:Sel.enabled = false
         End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApp5.aspx")
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
    
    Sub UpdateSelPOs()
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Sel As CheckBox
        Dim SeqNo As Label
        ReqCOM.ExecuteNonQuery("Update PR1_D set Ind = 'N' where pr_no = '" & trim(lblPRNo.text) & "';")
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Sel = CType(dtgPartWithSource.Items(i).FindControl("Sel"), CheckBox)
            SeqNo = CType(dtgPartWithSource.Items(i).FindControl("SeqNo"), Label)
    
            if (Sel.checked = true and Sel.enabled = true) then
                ReqCom.ExecuteNonQuery("Update PR1_D set Ind = 'Y' where Seq_no = " & clng(SeqNo.text) & ";")
            end if
        Next i
    End sub
    
    Sub cmdPO_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rs as SQLDataReader
        Dim PONoFrom,PONoTo as string
        Dim MRPNo as string = ReqCOM.GetFieldVal("Select top 1 MRP_NO from MRP_M order by MRP_NO desc","MRP_No")
    
        UpdateSelPOs
        PONoFrom = "T" & ReqCOM.GetDocumentNo("PO_NO")
        rs = ReqCOM.ExeDataReader("Select Distinct(Ven_Code) as [VenCode] from PR1_D where PR_No = '" & trim(lblPRNo.text) & "' and ind = 'Y'")
    
        do while rs.read
            PONoTo = "T" & ReqCOM.GetDocumentNo("PO_NO")
            ReqCOM.ExecuteNonQuery("Insert into PO_M(VEN_CODE,PO_NO,PO_DATE,MRP_NO,PR_NO,CREATE_BY,CREATE_DATE) select '" & trim(rs("VenCode")) & "','" & trim(PONoTo) & "','" & now & "','" & trim(MRPNo) & "','" & TRIM(lblPRNo.text) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "'")
            ReqCOm.ExecuteNonQuery("Insert into PO_D(PO_NO,PART_NO,DEL_DATE,SCH_DATE,ORDER_QTY,FOC_QTY,UP,IN_QTY,BAL_TO_SHIP,Req_Qty) select '" & trim(PONoTo) & "',PART_NO,PR_Date,Req_Date,Qty_To_Buy,0,UP,0,Qty_To_Buy,PR_Qty from PR1_D where ind = 'Y' and PR_NO = '" & trim(lblPRNo.text) & "' and ven_Code = '" & trim(rs("VenCode")) & "';")
            ReqCOM.ExecuteNonQuery("Update PO_M set po_m.CURR_CODE=vendor.CURR_CODE,po_m.SHIP_TERM=vendor.SHIP_TERM,po_m.PAY_TERM=vendor.PAY_TERM from PO_M,Vendor where po_m.po_no = '" & trim(poNoTo) & "' and po_m.ven_code = vendor.ven_code")
            ReqCOM.ExecuteNonQuery("Update main set PO_No = PO_NO + 1")
        loop
    
        ReqCOM.ExecuteNonQuery("Update PR1_D set PO_Generated = 'Y' where pr_no = '" & trim(lblPRNo.text) & "' and ind = 'Y';")
    
        if ReqCOM.funcCheckDuplicate("Select part_no from pr1_d where pr_no = '" & trim(lblPRNo.text) & "' and po_generated = 'N'","Part_No") = TRUE
    
        Else
            ReqCOM.ExecuteNonQuery("Update PR1_M set App5_By = '" & trim(request.cookies("U_ID").value) & "',App5_Date = '" & now & "',PR_Status = 'COMPLETED' where PR_NO = '" & trim(lblPRNo.text) & "';")
        end if
        ShowAlert("P/O explosion completed.\nPO No from " & ponoFrom & " to " & ponoto)
        RedirectPage("PRApp5Det.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowWUL(sender as Object,e as DataGridCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
        ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
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
    
    Sub LoadPRDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "SELECT pr.po_generated,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,left(ven.ven_NAME,16) + '...' as [ven_NAME] FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.Part_No,pr.req_date asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartWithSource.DataBind()
        lblTotal.text = "Total Amount  :  " & format(CDEC(TotalAmt),"##,##0.00")
    End sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgPartWithSource.CurrentPageIndex = e.NewPageIndex
        LoadPRDet()
    end sub
    
    Sub cmdExtra_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=PRExtraPurc&ID=" & trim(lblPRNo.text))
        RedirectPage("PRApp5Det.aspx?ID=" & Request.params("ID"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%" align="center" border="1">
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
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Buyer By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp1Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">PCMC By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp2Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Buyer HOD By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp3Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Mgt. By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;-&nbsp;<asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">P/O Genetated By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp5By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp5Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 4px" cellspacing="0" cellpadding="0" width="98%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label3" runat="server" width="100%" cssclass="SectionHeader">PR DETAILS</asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnPageIndexChanged="OurPager" OnEditCommand="ShowWUL" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" BorderColor="Gray" AllowPaging="True" PageSize="20">
                                                                                                <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                                                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                                <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                                <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                                                <Columns>
                                                                                                    <asp:EditCommandColumn ButtonType="LinkButton" visible= "false" UpdateText="" CancelText="" EditText="WUL"></asp:EditCommandColumn>
                                                                                                    <asp:TemplateColumn HeaderText="PART NO">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
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
                                                                                                    <asp:TemplateColumn HeaderText="Shortage">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="lblPRQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_QTY") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn HeaderText="PR Qty.">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="lblBuyQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QTY_TO_BUY") %>' /> 
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
                                                                                                    <asp:TemplateColumn HeaderText="SUPPLIER">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="VenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ven_name") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn HeaderText="MOQ">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="MOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn HeaderText="SPQ">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="SPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn HeaderText="P/O ?">
                                                                                                        <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <center>
                                                                                                                <asp:CheckBox id="Sel" runat="server" />
                                                                                                            </center>
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn Visible="False">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn Visible="False">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="POGenerated" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PO_Generated") %>' /> 
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
                                                                    </p>
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
                                                                <td>
                                                                </td>
                                                                <td width="33%">
                                                                    <asp:Button id="cmdPO" onclick="cmdPO_Click" runat="server" Width="154px" Text="Explode to P/O"></asp:Button>
                                                                </td>
                                                                <td width="34%">
                                                                    <asp:Button id="cmdExtra" onclick="cmdExtra_Click" runat="server" Text="Parts Extra Purchase"></asp:Button>
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
