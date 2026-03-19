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
        if page.ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim rs1 as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 Part_Spec,Part_Desc,Part_No,M_Part_No from Part_Master where Part_no = '" & Request.params("ID") & "';")
            Do while rs1.read
                lblSpec.text = rs1("Part_Spec")
                lblDesc.text = rs1("Part_Desc")
                lblPartNo.text = rs1("Part_No")
                lblMPN.text = rs1("M_Part_No")
            loop
            rs1.close()
            ProcLoadGridData
        end if
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim UPADate As Label = CType(e.Item.FindControl("UPADate"), Label)
            Dim OriUP As Label = CType(e.Item.FindControl("OriUP"), Label)
    
            e.Item.Cells(3).Text = cint(e.Item.Cells(3).Text)
            e.Item.Cells(4).Text = cint(e.Item.Cells(4).Text)
            e.Item.Cells(5).Text = format(cdec(e.Item.Cells(5).Text),"####0")
            e.Item.Cells(6).Text = format(cdec(e.Item.Cells(6).Text),"####0.00000")
    
            if trim(OriUP.text) = "" then
                OriUP.text = ""
            elseif trim(OriUP.text) <> 0 then
                OriUP.text = format(cdec(OriUP.text),"##,##0.00000")
            Elseif trim(OriUP.text) = 0 then
                OriUP.text = ""
            end if
        End if
    End Sub
    
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select ps.ori_ven_name,ps.ori_up,ps.ori_curr_code,V.Curr_Code,PS.VEN_SEQ, PS.CANCEL_LT,PS.RESCHEDULE_LT,PS.UP_APP_NO, PS.MODIFY_DATE, PS.Lead_Time,PS.SEQ_NO,PS.UP,PS.Modify_By,PS.Std_Pack_Qty,PS.Min_Order_Qty,V.Ven_name as [Vendor],ps.part_no from Part_Source PS,Vendor v where PS.Part_No = '" & trim(lblPartNo.text) & "' and PS.Ven_Code = V.Ven_Code ORDER BY PS.VEN_SEQ ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_source")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_source").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub lnkWUL1_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=WHEREUSELIST&PartNoFrom=" & trim(lblPartNo.text) & "&PartNoTo=" & trim(lblPartNo.text))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub lnkPartAllocation_Click(sender As Object, e As EventArgs)
        Response.redirect("PopupReportViewer.aspx?RptName=MRPAllocation&PartFrom=" & trim(lblPartNo.text) & "&PartTo=?&By=Part")
    End Sub
    
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
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table cellspacing="0" cellpadding="0" width="98%" align="center" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p>
                                <table style="HEIGHT: 71px" width="100%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <p align="center">
                                                    <asp:Label id="Label3" runat="server" cssclass="SectionHeader" width="100%">PART DETAILS</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td colspan="2">
                                                                                        <asp:LinkButton id="lnkPartAllocation" onclick="lnkPartAllocation_Click" runat="server" Width="100%" CssClass="OutputText">View Part Allocation</asp:LinkButton>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="2">
                                                                                        <asp:LinkButton id="lnkWUL1" onclick="lnkWUL1_Click" runat="server" Width="100%" CssClass="OutputText">View Where Use List</asp:LinkButton>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label20" runat="server" cssclass="LabelNormal">Part No/Description/MPN</asp:Label></td>
                                                                                    <td width="75%">
                                                                                        <asp:Label id="lblPartNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblDesc" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblMPN" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblSpec" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                                    <asp:Label id="Label2" runat="server" cssclass="SectionHeader" width="100%">PART SOURCE</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" Font-Name="Verdana" Font-Names="Verdana" Font-Size="XX-Small" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="Ven_Seq"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Vendor" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Curr_Code" HeaderText="Curr."></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Lead_Time" HeaderText="L/T">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Std_Pack_Qty" HeaderText="SPQ">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Min_Order_Qty" HeaderText="MOQ">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UP_APP_NO" HeaderText="APP. NO">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Cancel_LT" HeaderText="CANC.">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Reschedule_LT" HeaderText="RE-SCH">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ori_Ven_Name" HeaderText="Ori. Supp.">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Ori_Curr_Code" HeaderText="Ori. Curr Code">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Ori. UP">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="OriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ori_UP") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
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
                            <p>
                                <table style="HEIGHT: 13px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <div align="right">
                                                    <asp:Button id="cmdClose" onclick="cmdClose_Click" runat="server" Width="97px" Text="Close"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%">
                            <p>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
        </p>
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
