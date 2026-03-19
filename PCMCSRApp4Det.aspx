<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="PCMCSRDet" TagName="PCMCSRDet" Src="_PCMCSRDet_.ascx" %>
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
                loadGridData
                ProcLoadAtt
            End if
        End Sub
    
        Sub loadGridData()
            Dim strSql as string = "SELECT * FROM SR_M where SEQ_NO = " & request.params("ID") & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
            do while ResExeDataReader.read
                lblSRNo.text = ResExeDataReader("SR_NO")
                lblRemarks.text = ResExeDataReader("Remarks").tostring
                if isdbnull(ResExeDataReader("Submit_By")) = false then lblSubmitby.text = ucase(ResExeDataReader("Submit_By"))
                if isdbnull(ResExeDataReader("Submit_Date")) = false then lblSubmitDate.text = format(cdate(ResExeDataReader("Submit_Date")),"dd/MM/yy")
    
                if isdbnull(ResExeDataReader("App1_By")) = false then lblApp1By.text = ucase(ResExeDataReader("App1_By"))
                if isdbnull(ResExeDataReader("App1_Date")) = false then lblApp1Date.text = format(cdate(ResExeDataReader("App1_Date")),"dd/MM/yy")
                If isdbnull(ResExeDataReader("app1_Rem")) = true then lblApp1Rem.text = "-"
                If isdbnull(ResExeDataReader("app1_Rem")) = false then lblApp1Rem.text = ResExeDataReader("App1_Rem").tostring
    
                if isdbnull(ResExeDataReader("App2_By")) = false then lblApp2By.text = ucase(ResExeDataReader("App2_By"))
                if isdbnull(ResExeDataReader("App2_Date")) = false then lblApp2Date.text = format(cdate(ResExeDataReader("App2_Date")),"dd/MM/yy")
                If isdbnull(ResExeDataReader("app2_Rem")) = true then lblApp2Rem.text = "-"
                If isdbnull(ResExeDataReader("app2_Rem")) = false then lblApp2Rem.text = ResExeDataReader("App2_Rem").tostring
    
                if isdbnull(ResExeDataReader("App3_By")) = false then lblApp3By.text = ucase(ResExeDataReader("App3_By"))
                if isdbnull(ResExeDataReader("App3_Date")) = false then lblApp3Date.text = format(cdate(ResExeDataReader("App3_Date")),"dd/MM/yy")
                If isdbnull(ResExeDataReader("app3_Rem")) = true then lblApp3Rem.text = "-"
                If isdbnull(ResExeDataReader("app3_Rem")) = false then lblApp3Rem.text = ResExeDataReader("App3_Rem").tostring
    
                if isdbnull(ResExeDataReader("App4_By")) = false then lblApp4By.text = ucase(ResExeDataReader("App4_By"))
                if isdbnull(ResExeDataReader("App4_Date")) = false then lblApp4Date.text = format(cdate(ResExeDataReader("App4_Date")),"dd/M/yy")
    
                if isdbnull(ResExeDataReader("App4_By")) = false then
                    cmdPO.visible = false
                else
                    if trim(ResExeDataReader("SR_Status")) <> "REJECTED" then cmdPO.visible = true
                end if
            loop
        end sub
    
        Sub cmdBack_Click(sender As Object, e As EventArgs)
            Response.redirect("PCMCSRApp4.aspx")
        End Sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim ETADate As Label = CType(e.Item.FindControl("ETADate"), Label)
                Dim SpareQty As Label = CType(e.Item.FindControl("SpareQty"), Label)
                Dim ReqQty As Label = CType(e.Item.FindControl("ReqQty"), Label)
                Dim TotalQty As Label = CType(e.Item.FindControl("TotalQty"), Label)
                Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
                Dim QtyToBuy As Label = CType(e.Item.FindControl("QtyToBuy"), Label)
                Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
                Dim SPQ As Label = CType(e.Item.FindControl("SPQ"), Label)
                Dim MOQ As Label = CType(e.Item.FindControl("MOQ"), Label)
    
                MOQ.text = format(cdec(MOQ.text),"##,##0")
                SPQ.text = format(cdec(SPQ.text),"##,##0")
                ETADate.text = format(cdate(ETADate.text),"dd/MM/yy")
                SpareQty.text = "0"
                ReqQty.text = format(cdec(ReqQty.text),"##,##0")
                TotalQty.text = format(cdec(ReqQty.text),"##,##0")
                Amt.text = format(UP.text * QtyToBuy.text,"##,##0.00")
                if cdec(TotalQty.text) <> 0 then e.Item.CssClass = "PartSource"
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
    
    Sub cmdPO_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rs as SQLDataReader
        Dim PONoFrom,PONoTo as string
        PONoFrom = ReqCOM.GetDocumentNo("PO_NO")
        rs = ReqCOM.ExeDataReader("Select Distinct(Ven_Code) as [VenCode] from SR_D where SR_No = '" & trim(lblSRNo.text) & "';")
    
        do while rs.read
            PONoTo = ReqCOM.GetDocumentNo("PO_NO")
            ReqCOM.ExecuteNonQuery("Insert into PO_M(VEN_CODE,PO_NO,PO_DATE,CREATE_BY,CREATE_DATE) select '" & trim(rs("VenCode")) & "','" & trim(PONoTo) & "','" & now & "','" & trim(request.cookies("U_ID").value) & "','" & now & "'")
            ReqCOm.ExecuteNonQuery("Insert into PO_D(PO_NO,PART_NO,DEL_DATE,prev_del_date,SCH_DATE,ORDER_QTY,FOC_QTY,UP,IN_QTY,BAL_TO_SHIP) select '" & trim(PONoTo) & "',PART_NO,eta_date,ETA_DATE,net_eta,Qty_To_Buy,0,UP,0,Qty_To_Buy from SR_D where SR_NO = '" & trim(lblSRNo.text) & "' and ven_Code = '" & trim(rs("VenCode")) & "';")
            ReqCOM.ExecuteNonQuery("Update PO_M set po_m.CURR_CODE=vendor.CURR_CODE,po_m.SHIP_TERM=vendor.SHIP_TERM,po_m.PAY_TERM=vendor.PAY_TERM from PO_M,Vendor where po_m.po_no = '" & trim(poNoTo) & "' and po_m.ven_code = vendor.ven_code")
            ReqCOM.ExecuteNonQuery("Update main set PO_No = PO_NO + 1")
        loop
        ReqCOM.ExecuteNonQuery("Update SR_M set App4_By = '" & trim(request.cookies("U_ID").value) & "',App4_Date = '" & now & "',SR_Status = 'COMPLETED' where SR_NO = '" & trim(lblSRNo.text) & "';")
        ShowAlert("P/O explosion completed.\nPO No from " & ponoFrom & " to " & ponoto)
        RedirectPage("PCMCSRApp4Det.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ProcLoadAtt()
        Dim StrSql as string = "Select * from SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SR_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
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
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SPECIAL REQUEST
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 77px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top">
                                                                    <p>
                                                                    </p>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label10" runat="server" cssclass="LabelNormal">SR No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblSRNo" runat="server" cssclass="OutputText" width="315px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Submit</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="lblRemarks" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Buyer</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp1By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal">PCMC</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp2By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Purc. HOD</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp3By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal">P/O Generation</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblApp4By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
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
                                                    <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
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
                                                <p>
                                                    <PCMCSRDet:PCMCSRDet id="UserControl11" runat="server"></PCMCSRDet:PCMCSRDet>
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
                                                <asp:Button id="cmdPO" onclick="cmdPO_Click" runat="server" Width="154px" Visible="False" Text="Explode to P/O"></asp:Button>
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
    </form>
</body>
</html>
