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
    
            if trim(Request.params("MainPartB4")) <> "-" then
                Dim rs1 as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 Part_Spec,Part_Desc,Part_No,Bal_Qty,Open_PO,IQC_Bal,MDO_Bal,WIP, Bal_Qty+Open_PO+IQC_Bal+MDO_Bal+WIP as [NetBal] from Part_Master where Part_no = '" & Request.params("MainPartB4") & "';")
                Do while rs1.read
                    lblSpec1.text = rs1("Part_Spec")
                    lblDesc1.text = rs1("Part_Desc")
                    lblPartNo1.text = rs1("Part_No")
                loop
                rs1.close()
            Elseif trim(Request.params("MainPartB4")) = "-" then
                lblSpec1.text = "N/A"
                lblDesc1.text = "N/A"
                lblPartNo1.text = "N/A"
            end if
    
            if trim(Request.params("MainPart")) <> "-" then
                Dim rs2 as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 Part_Spec,Part_Desc,Part_No,Bal_Qty,Open_PO,IQC_Bal,MDO_Bal,WIP, Bal_Qty+Open_PO+IQC_Bal+MDO_Bal+WIP as [NetBal] from Part_Master where Part_no = '" & Request.params("MainPart") & "';")
                Do while rs2.read
                    lblSpec2.text = rs2("Part_Spec")
                    lblDesc2.text = rs2("Part_Desc")
                    lblPartNo2.text = rs2("Part_No")
                loop
                rs2.close()
            Elseif trim(Request.params("MainPart")) = "-" then
                lblSpec2.text = "N/A"
                lblDesc2.text = "N/A"
                lblPartNo2.text = "N/A"
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
    
    Sub lnkAltPart1_Click(sender As Object, e As EventArgs)
        Dim SeqNo as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        SeqNo = ReqCOM.GetFieldVal("Select Seq_No from BOM_D where part_no = '" & trim(request.params("MainPartB4")) & "' and Model_No = '" & trim(request.params("ModelNo")) & "';","Seq_No")
    
        if trim(SeqNo) <> "<NULL>" then
            ShowReport("PopupAlternatePart.aspx?ID=" & clng(SeqNo))
        Else
            ShowAlert("No alternate part available for this part no")
        end if
    End Sub
    
    Sub lnkAltPart2_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo as string
    
        SeqNo = ReqCOM.GetFieldVal("Select Seq_No from BOM_D where part_no = '" & trim(request.params("MainPart")) & "' and Model_No = '" & trim(request.params("ModelNo")) & "';","Seq_No")
    
        if trim(SeqNo) <> "<NULL>" then
            ShowReport("PopupAlternatePart.aspx?ID=" & clng(SeqNo))
        else
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
            <table cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                            </p>
                            <p>
                                <table style="HEIGHT: 71px" width="100%" align="center">
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