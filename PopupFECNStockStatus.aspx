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
            Dim SRQty1,SRQty2 as string
    
    
            if trim(Request.params("MainPartB4")) <> "-" then
                Dim rs1 as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 Part_Spec,Part_Desc,Part_No,Bal_Qty,Open_PO,IQC_Bal,MDO_Bal,WIP, Bal_Qty+Open_PO+IQC_Bal+MDO_Bal+WIP as [NetBal] from Part_Master where Part_no = '" & Request.params("MainPartB4") & "';")
                Do while rs1.read
                    lblSpec1.text = rs1("Part_Spec")
                    lblDesc1.text = rs1("Part_Desc")
                    lblPartNo1.text = rs1("Part_No")
                    lblStore1.text = format(rs1("Bal_Qty"),"##,##0")
    
                    lblPR1.text = ReqCOM.GetFieldVal("select sum(Qty_To_Buy) as [QtyToBuy] from pr1_d where part_no = '" & trim(lblPartNo1.text) & "';","QtyToBuy")
                    if lblPR1.text = "<NULL>" then lblPR1.text = "0"
    
                    SRQty1 = ReqCom.getFieldVal("select sum(calculated_qty) as [CalculatedQty] from sr_d where part_no = '" & trim(lblPartNo1.text) & "'","CalculatedQty")
                    if SRQty1 = "<NULL>" then SRQty1 = "0"
    
                    SRQty2 = ReqCom.getFieldVal("select sum(calculated_qty) as [CalculatedQty] from buyer_sr_d where part_no = '" & trim(lblPartNo1.text) & "'","CalculatedQty")
                    if SRQty2 = "<NULL>" then SRQty2 = "0"
    
                    lblSR1.text = clng(SRQty1) + clng(SRQty2)
    
                    lblOpenPO1.text = format(rs1("open_po"),"##,##0")
                    lblIQC1.text = format(rs1("iqc_bal"),"##,##0")
                    lblMDO1.text = format(rs1("mdo_Bal"),"##,##0")
                    lblWIP1.text = format(rs1("WIP"),"##,##0")
                    lblTotal1.text = format(rs1("NetBal"),"##,##0")
                loop
                rs1.close()
            Elseif trim(Request.params("MainPartB4")) = "-" then
                lblSpec1.text = "N/A"
                lblDesc1.text = "N/A"
                lblPartNo1.text = "N/A"
                lblStore1.text = "N/A"
                lblOpenPO1.text = "N/A"
                lblIQC1.text = "N/A"
                lblMDO1.text = "N/A"
                lblWIP1.text = "N/A"
                lblTotal1.text = "N/A"
            end if
    
            if trim(Request.params("MainPart")) <> "-" then
                Dim rs2 as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 Part_Spec,Part_Desc,Part_No,Bal_Qty,Open_PO,IQC_Bal,MDO_Bal,WIP, Bal_Qty+Open_PO+IQC_Bal+MDO_Bal+WIP as [NetBal] from Part_Master where Part_no = '" & Request.params("MainPart") & "';")
                Do while rs2.read
                    lblSpec2.text = rs2("Part_Spec")
                    lblDesc2.text = rs2("Part_Desc")
                    lblPartNo2.text = rs2("Part_No")
                    lblStore2.text = format(rs2("Bal_Qty"),"##,##0")
                    lblOpenPO2.text = format(rs2("open_po"),"##,##0")
                    lblIQC2.text = format(rs2("iqc_bal"),"##,##0")
                    lblMDO2.text = format(rs2("mdo_Bal"),"##,##0")
                    lblWIP2.text = format(rs2("WIP"),"##,##0")
    
                    SRQty1 = ReqCom.getFieldVal("select sum(calculated_qty) as [CalculatedQty] from sr_d where part_no = '" & trim(lblPartNo2.text) & "'","CalculatedQty")
                    if SRQty1 = "<NULL>" then SRQty1 = "0"
    
                    SRQty2 = ReqCom.getFieldVal("select sum(calculated_qty) as [CalculatedQty] from buyer_sr_d where part_no = '" & trim(lblPartNo2.text) & "'","CalculatedQty")
                    if SRQty2 = "<NULL>" then SRQty2 = "0"
    
                    lblSR2.text = clng(SRQty1) + clng(SRQty2)
    
                    lblPR2.text = ReqCOM.GetFieldVal("select sum(Qty_To_Buy) as [QtyToBuy] from pr1_d where part_no = '" & trim(lblPartNo2.text) & "';","QtyToBuy")
                    if lblPR2.text = "<NULL>" then lblPR2.text = "0"
    
                    lblTotal2.text = format(rs2("NetBal"),"##,##0")
                loop
                rs2.close()
            Elseif trim(Request.params("MainPart")) = "-" then
                lblSpec2.text = "N/A"
                lblDesc2.text = "N/A"
                lblPartNo2.text = "N/A"
                lblStore2.text = "N/A"
                lblOpenPO2.text = "N/A"
                lblIQC2.text = "N/A"
                lblMDO2.text = "N/A"
                lblWIP2.text = "N/A"
                lblTotal2.text = "N/A"
            end if
        end if
    End Sub
    
    Sub lnkWUL1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ProcessWhereUseList(lblPartNo1.text,lblPartNo1.text)
        ShowReport("PopupReportViewer.aspx?RptName=WhereUseList&PartNoFrom=" & trim(lblPartNo1.text) & "&PartNoTo=" & trim(lblPartNo1.text))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub lnkWUL2_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ProcessWhereUseList(lblPartNo2.text,lblPartNo2.text)
        ShowReport("PopupReportViewer.aspx?RptName=WhereUseList&PartNoFrom=" & trim(lblPartNo2.text) & "&PartNoTo=" & trim(lblPartNo2.text))
    End Sub
    
    Sub lnkSupplyDemand1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ProcessSupplyDemandRpt(lblPartNo1.text,lblPartNo1.text)
        ShowReport("PopupReportViewer.aspx?RptName=SupplyVSDemandSummary&PartNoFrom=" & trim(lblPartNo1.text) & "&PartNoTo=" & trim(lblPartNo1.text))
    End Sub
    
    Sub lnkSupplyDemand2_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ProcessSupplyDemandRpt(lblPartNo2.text,lblPartNo2.text)
        ShowReport("PopupReportViewer.aspx?RptName=SupplyVSDemandSummary&PartNoFrom=" & trim(lblPartNo2.text) & "&PartNoTo=" & trim(lblPartNo2.text))
    End Sub
    
    Sub lnkAltPart1_Click(sender As Object, e As EventArgs)
        Dim SeqNo as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        SeqNo = ReqCOM.GetFieldVal("Select Seq_No from BOM_D where part_no = '" & trim(lblPartNo1.text) & "' and Model_No = '" & trim(request.params("ModelNo")) & "';","Seq_No")
    
        if trim(SeqNo) <> "<NULL>" then
            ShowReport("PopupAlternatePart.aspx?ID=" & clng(SeqNo))
        Else
            ShowAlert("No alternate part available for this part no")
        end if
    End Sub
    
    Sub lnkAltPart2_Click(sender As Object, e As EventArgs)
        Dim SeqNo as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        SeqNo = ReqCOM.GetFieldVal("Select Seq_No from BOM_D where part_no = '" & trim(lblPartNo2.text) & "' and Model_No = '" & trim(request.params("ModelNo")) & "';","Seq_No")
    
        if trim(SeqNo) <> "<NULL>" then
            ShowReport("PopupAlternatePart.aspx?ID=" & clng(SeqNo))
        Else
            ShowAlert("No alternate part available for this part no")
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
          Dim strScript as string
          strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
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
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                            </p>
                            <p>
                                <table style="HEIGHT: 71px" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center"><asp:Label id="Label10" runat="server" cssclass="FormDesc" width="100%">Part
                                                                        Details (Current)</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton id="lnkAltPart1" onclick="lnkAltPart1_Click" runat="server" Width="100%" CssClass="ErrorText">View Alternate Part</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton id="lnkWUL1" onclick="lnkWUL1_Click" runat="server" Width="100%" CssClass="ErrorText">View Where Use List</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton id="lnkSupplyDemand1" onclick="lnkSupplyDemand1_Click" runat="server" Width="100%" CssClass="ErrorText">View Supply VS Demand</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="128px">Part No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblPartNo1" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="128px">Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDesc1" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="128px">Specification</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSpec1" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px">Store</asp:Label></td>
                                                                <td width="25%">
                                                                    <div align="right"><asp:Label id="lblStore1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Open P/O</asp:Label></td>
                                                                <td width="25%">
                                                                    <div align="right"><asp:Label id="lblOpenPO1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">IQC</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblIQC1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">MDO</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblMDO1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">WIP</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblWIP1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">S/R</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblSR1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">P/R</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblPR1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Total</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblTotal1" runat="server" cssclass="OutputText" width="100%"></asp:Label>
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
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <div align="center"><asp:Label id="Label12" runat="server" cssclass="FormDesc" width="100%">Part
                                                                            Details (New)</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton id="lnkAltPart2" onclick="lnkAltPart2_Click" runat="server" Width="100%" CssClass="ErrorText">View Alternate Part</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton id="lnkWUL2" onclick="lnkWUL2_Click" runat="server" Width="100%" CssClass="ErrorText">View Where Use List</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:LinkButton id="lnkSupplyDemand2" onclick="lnkSupplyDemand2_Click" runat="server" Width="100%" CssClass="ErrorText">View Supply VS Demand</asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="128px">Part No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblPartNo2" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label23" runat="server" cssclass="LabelNormal" width="128px">Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDesc2" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label26" runat="server" cssclass="LabelNormal" width="128px">Specification</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSpec2" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="128px">Store</asp:Label></td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <div align="right"><asp:Label id="lblStore2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="128px">Open P/O</asp:Label></td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <div align="right"><asp:Label id="lblOpenPO2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label18" runat="server" cssclass="LabelNormal">IQC</asp:Label></td>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right"><asp:Label id="lblIQC2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal">MDO</asp:Label></td>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right"><asp:Label id="lblMDO2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label24" runat="server" cssclass="LabelNormal">WIP</asp:Label></td>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right"><asp:Label id="lblWIP2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label27" runat="server" cssclass="LabelNormal">S/R</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblSR2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label31" runat="server" cssclass="LabelNormal">P/R</asp:Label></td>
                                                                <td>
                                                                    <div align="right"><asp:Label id="lblPR2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label35" runat="server" cssclass="LabelNormal">Total</asp:Label></td>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right"><asp:Label id="lblTotal2" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:Label id="Label15" runat="server" forecolor="Red">* Total does not include S/R
                                                    and P/R quantity</asp:Label>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
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