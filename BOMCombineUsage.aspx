<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdShowReport_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Truncate table BOM_COMBINE_USAGE")
    
        if trim(txtModelNo1.text) <> "" then UpdateBOMTable(txtModelNo1.text,txtOrderQty1.text)
        if trim(txtModelNo2.text) <> "" then UpdateBOMTable(txtModelNo2.text,txtOrderQty2.text)
        if trim(txtModelNo3.text) <> "" then UpdateBOMTable(txtModelNo3.text,txtOrderQty3.text)
        if trim(txtModelNo4.text) <> "" then UpdateBOMTable(txtModelNo4.text,txtOrderQty4.text)
        if trim(txtModelNo5.text) <> "" then UpdateBOMTable(txtModelNo5.text,txtOrderQty5.text)
        if trim(txtModelNo6.text) <> "" then UpdateBOMTable(txtModelNo6.text,txtOrderQty6.text)
        if trim(txtModelNo7.text) <> "" then UpdateBOMTable(txtModelNo7.text,txtOrderQty7.text)
        if trim(txtModelNo8.text) <> "" then UpdateBOMTable(txtModelNo8.text,txtOrderQty8.text)
        if trim(txtModelNo9.text) <> "" then UpdateBOMTable(txtModelNo9.text,txtOrderQty9.text)
        if trim(txtModelNo10.text) <> "" then UpdateBOMTable(txtModelNo10.text,txtOrderQty10.text)
    
        if trim(txtModelNo11.text) <> "" then UpdateBOMTable(txtModelNo11.text,txtOrderQty11.text)
        if trim(txtModelNo12.text) <> "" then UpdateBOMTable(txtModelNo12.text,txtOrderQty12.text)
        if trim(txtModelNo13.text) <> "" then UpdateBOMTable(txtModelNo13.text,txtOrderQty13.text)
        if trim(txtModelNo14.text) <> "" then UpdateBOMTable(txtModelNo14.text,txtOrderQty14.text)
        if trim(txtModelNo15.text) <> "" then UpdateBOMTable(txtModelNo15.text,txtOrderQty15.text)
        if trim(txtModelNo16.text) <> "" then UpdateBOMTable(txtModelNo16.text,txtOrderQty16.text)
        if trim(txtModelNo17.text) <> "" then UpdateBOMTable(txtModelNo17.text,txtOrderQty17.text)
        if trim(txtModelNo18.text) <> "" then UpdateBOMTable(txtModelNo18.text,txtOrderQty18.text)
        if trim(txtModelNo19.text) <> "" then UpdateBOMTable(txtModelNo19.text,txtOrderQty19.text)
    
        if trim(txtModelNo20.text) <> "" then UpdateBOMTable(txtModelNo20.text,txtOrderQty20.text)
        if trim(txtModelNo21.text) <> "" then UpdateBOMTable(txtModelNo21.text,txtOrderQty21.text)
        if trim(txtModelNo22.text) <> "" then UpdateBOMTable(txtModelNo22.text,txtOrderQty22.text)
        if trim(txtModelNo23.text) <> "" then UpdateBOMTable(txtModelNo23.text,txtOrderQty23.text)
        if trim(txtModelNo24.text) <> "" then UpdateBOMTable(txtModelNo24.text,txtOrderQty24.text)
        if trim(txtModelNo25.text) <> "" then UpdateBOMTable(txtModelNo25.text,txtOrderQty25.text)
    
        ShowReport("PopupReportviewer.aspx?RptName=BOMCOMBINEUSAGE")
    
        ReqCOM.ExecuteNonQuery("Update BOM_COMBINE_USAGE set Total_Usage = P_Usage * Order_Qty")
        ReqCOM.ExecuteNonQuery("Update BOM_COMBINE_USAGE SET BOM_COMBINE_USAGE.OPEN_PO = pART_MASTER.OPEN_PO,BOM_COMBINE_USAGE.Bal_Qty = pART_MASTER.Bal_Qty, BOM_COMBINE_USAGE.PART_SPEC = pART_MASTER.PARt_spec,BOM_COMBINE_USAGE.PART_DESC=pART_MASTER.PART_DESC FROM BOM_COMBINE_USAGE,pART_MASTER where BOM_COMBINE_USAGE.part_no = pART_MASTER.part_no")
    End Sub
    
    Sub UpdateBOMTable(ModelNo as string,OrderQty as long)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Insert into BOM_COMBINE_USAGE(Model_No,Part_No,Order_Qty,P_USAGE) select '" & trim(ModelNo) & "',Part_No," & clng(OrderQty) & ",p_usage from BOM_D where model_no = '" & trim(ModelNo) & "' and revision in (select max(revision) from bom_m where model_no = '" & trim(ModelNo) & "')")
    ENd sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<html>
<head>
    <link href="ibuyspy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Model Vs BOM Usage
                                                                </td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 303px; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; HEIGHT: 691px; BORDER-RIGHT-COLOR: black" border="1">
                                                                            <tbody>
                                                                                <tr valign="center">
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" text="Model No"></asp:Label></td>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" text="Order Qty."></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo1" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty1" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo2" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty2" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo3" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty3" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo4" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty4" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo5" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty5" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo6" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty6" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo7" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty7" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo8" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty8" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo9" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty9" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo10" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty10" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo11" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty11" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo12" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty12" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo13" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty13" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo14" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty14" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo15" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty15" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo16" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty16" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo17" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty17" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo18" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty18" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo19" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty19" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo20" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty20" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo21" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty21" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo22" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty22" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo23" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty23" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo24" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty24" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtModelNo25" runat="server" CssClass="input_box"></asp:TextBox>
                                                                                    </td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOrderQty25" runat="server" CssClass="input_box" Width="90px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </p>
                                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="303" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="50%">
                                                                                    <p align="left">
                                                                                        <asp:Button id="cmdShowReport" onclick="cmdShowReport_Click" runat="server" CssClass="submit_button" Text="Show Report"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                                <td width="50%">
                                                                                    <p align="right">
                                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" CssClass="submit_button" Width="117px" Text="Back"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </p>
                                <p>
                                </p>
                                <p>
                                </p>
                                <p>
                                    <footer:footer id="footer" runat="server"></footer:footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
