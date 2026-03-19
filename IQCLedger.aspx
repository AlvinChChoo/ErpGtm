<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GenerateRptData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub GenerateRptData()
        Dim CurrBal,InQty,OutQty as decimal
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsGenerateRptData as SQLDataReader
        Dim rsGenerateRptData1 as SQLDataReader
    
        rsGenerateRptData = ReqCOM.ExeDataReader("Select distinct(Part_no) from iqc_movement where part_no >= '" & trim(txtPartFrom.text) & "' and part_no <= '" & trim(txtPartTo.text) & "' order by part_no asc;")
        ReqCOM.ExecuteNonQuery("Truncate Table IQC_Movement_Rpt")
        Do while rsGenerateRptData.read
            if ReqCOM.FuncCheckduplicate("Select sum(qty_in) as InQty from IQC_MOVEMENT where part_no = '" & trim(rsGenerateRptData!Part_No) & "' and Trans_Date < '" & cdate(txtDateFrom.text) & "';","InQty") = false then
                InQty = 0
            else
                InQty = ReqCOm.GetFieldVal("Select sum(qty_in) as InQty from IQC_MOVEMENT where part_no = '" & trim(rsGenerateRptData!Part_No) & "' and Trans_Date < '" & cdate(txtDateFrom.text) & "';","InQty")
            end if
    
            if ReqCOM.FuncCheckduplicate("Select sum(qty_out) as OutQty from IQC_MOVEMENT where part_no = '" & trim(rsGenerateRptData!Part_No) & "' and Trans_Date < '" & cdate(txtDateFrom.text) & "';","OutQty") = false then
                OutQty = 0
            else
                OutQty = ReqCOm.GetFieldVal("Select sum(Qty_out) as OutQty from IQC_MOVEMENT where part_no = '" & trim(rsGenerateRptData!Part_No) & "' and Trans_Date < '" & cdate(txtDateFrom.text) & "';","OutQty")
            end if
    
            CurrBal = cdec(InQty) - cdec(OutQty)
    
            ReqCOm.ExecuteNonQuery("Insert into IQC_Movement_Rpt(PART_NO,Trans_Type,qty_in,Qty_Out,IN_OUT) Select '" & trim(rsGenerateRptData!Part_No) & "','B/BF'," & cdec(CurrBal) & ",0," & cdec(currBal) & ";")
            ReqCom.ExecuteNonQuery("iNSERT INTO iqc_movement_rpt(PART_NO,REF,QTY_IN,QTY_OUT,UP,TRANS_TYPE,IN_OUT,TRANS_DATE) SELECT PART_NO,REF,QTY_IN,QTY_OUT,UP,TRANS_TYPE,IN_OUT,TRANS_DATE FROM IQC_MOVEMENT WHERE part_no = '" & trim(rsGenerateRptData!Part_No) & "' and (TRANS_DATE >= '" & CDATE(txtDateFrom.text) & "' AND TRANS_DATE < = '" & CDATE(txtDateto.text) & "') order by trans_date asc")
    
            rsGenerateRptData1 = ReqCOM.ExeDataReader("Select * from IQC_MOVEMENT_RPT where part_no = '" & trim(rsGenerateRptData!Part_No) & "' order by seq_no asc")
            Do while rsGenerateRptData1.read
                if trim(rsGenerateRptData1!Trans_Type) = "B/BF" then
                    CurrBal = cdec(rsGenerateRptData1!In_Out)
                else
                    if rsGenerateRptData1!Qty_In > 0 then CurrBal = CurrBal + cdec(rsGenerateRptData1!Qty_In)
                    if rsGenerateRptData1!Qty_Out > 0 then CurrBal = CurrBal - cdec(rsGenerateRptData1!Qty_Out)
                end if
                reqcom.executeNonQuery("Update IQC_Movement_Rpt set IN_OUT = " & cdec(CurrBal) & " where seq_No = " & cint(rsGenerateRptData1!Seq_No) & ";")
            loop
        loop
        response.redirect("IQCLedgerRpt.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <font color="red"><strong>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </strong></font></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" forecolor="" backcolor="" width="100%" cssclass="FormDesc">IQC
                                LEDGER REPORT</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="86%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 12px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <table style="HEIGHT: 38px" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="LotNo" runat="server" width="106px" cssclass="OutputText">Part From</asp:Label>
                                                                                            <asp:TextBox id="txtPartFrom" runat="server" Width="180px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:Label id="Label7" runat="server" width="23px" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:TextBox id="txtPartTo" runat="server" Width="180px" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label8" runat="server" width="106px" cssclass="OutputText">Date From</asp:Label>
                                                                                            <asp:TextBox id="txtDateFrom" runat="server" Width="180px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:Label id="Label3" runat="server" width="23px" cssclass="OutputText">To</asp:Label>
                                                                                            <asp:TextBox id="txtDateTo" runat="server" Width="180px" CssClass="OutputText"></asp:TextBox>
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
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="107px" Text="View Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="108px" Text="Back"></asp:Button>
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
            </font>
        </p>
    </form>
</body>
</html>
