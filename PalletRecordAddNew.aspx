<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
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
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("PalletRecord.aspx")
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_GTM.Erp_GTM = new Erp_GTM.Erp_GTM
        lblLotNo.text = ReqCOM.GetFieldVal("Select Lot_No from Job_Order_M where jo_no = '" & trim(txtJONo.text) & "'","Lot_No")
        lblPONo.text = ReqCOM.GetFieldVal("Select PO_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "'","PO_No")
        lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "'","Model_No")
        lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "'","Model_Desc")
    End Sub
    
    Sub cmdCalculate_Click(sender As Object, e As EventArgs)
        CalTotalPcs()
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            CalTotalPcs
            Dim ReqCOM AS erp_gtm.erp_gtm = NEW erp_gtm.erp_gtm
            Dim PalletNo as string = ReqCOM.GetDocumentNo("Pallet_No")
            ReqCOM.ExecuteNonQuery("Insert into Pallet_record_m(PPR_No,CREATE_BY,CREATE_DATE,JO_NO,QTY1X,QTY1Y,QTY2X,QTY2Y,QTY3X,QTY3Y,QTY4X,QTY4Y,Total_Pcs,LINE_NO,CARTON_NO,REM,DESTINATION,PAL_NO) select '" & trim(PalletNo) & "','" & trim(request.cookies("U_ID").value) & "','" & cdate(now) & "','" & trim(txtJONo.text) & "'," & clng(txtQty1X.text) & "," & clng(txtQty1y.text) & "," & clng(txtQty2X.text) & "," & clng(txtQty2y.text) & "," & clng(txtQty3X.text) & "," & clng(txtQty3y.text) & "," & clng(txtQty4X.text) & "," & clng(txtQty4y.text) & "," & clng(lblTotalPcs.text) & ",'" & trim(txtLineNo.text) & "','" & trim(txtCartonNo.text) & "','" & trim(txtRem.text) & "','" & trim(txtDestination.text) & "','" & trim(txtPalNo.text) & "'")
            ReqCOM.ExecuteNonQuery("Update Main set Pallet_no = Pallet_No + 1")
            ShowAlert("Pallet Record Updated.")
            redirectPage("PalletRecordDet.aspx?ID=" & ReqCOM.GEtFieldVal("Select Seq_No from Pallet_Record_M where PPR_No = '" & trim(PalletNo) & "'","Seq_No"))
        End if
    End Sub
    
    Sub CalTotalPcs()
        Dim TotalPcs as long = 0
        if trim(txtQty1X.text) <> "0" and trim(txtQty1Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty1X.text) * clng(txtQty1Y.text)
        if trim(txtQty2X.text) <> "0" and trim(txtQty2Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty2X.text) * clng(txtQty2Y.text)
        if trim(txtQty3X.text) <> "0" and trim(txtQty3Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty3X.text) * clng(txtQty3Y.text)
        if trim(txtQty4X.text) <> "0" and trim(txtQty4Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty4X.text) * clng(txtQty4Y.text)
        lblTotalPcs.text = clng(TotalPcs)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">NEW PALLET
                            RECORD REGISTRATION</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="76%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="left">
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label3" runat="server" cssclass="LabelNormal">Job
                                                                    Order No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox id="txtJONo" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                                &nbsp; 
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Width="57px" Text="GO"></asp:Button>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Line No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtLineNo" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Carton No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtCartonNo" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" Height="62px" TextMode="MultiLine"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Destination</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtDestination" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Pallet No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPalNo" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label15" runat="server" cssclass="LabelNormal">Quantity</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td valign="top">
                                                                <table style="HEIGHT: 71px" width="80%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td width="45%">
                                                                                <asp:TextBox id="txtQty1X" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                            <td width="10%">
                                                                                <div align="center"><asp:Label id="Label24" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td width="45%">
                                                                                <asp:TextBox id="txtQty1y" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty2x" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <div align="center"><asp:Label id="Label25" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty2y" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty3x" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <div align="center"><asp:Label id="Label26" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty3y" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty4x" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <div align="center"><asp:Label id="Label27" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty4y" runat="server" CssClass="OutputText" Width="100%">0</asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label28" runat="server" cssclass="LabelNormal">Total
                                                                    Pcs</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblTotalPcs" runat="server" width="50%" cssclass="OutputText"></asp:Label>
                                                                <asp:LinkButton id="cmdCalculate" onclick="cmdCalculate_Click" runat="server" CssClass="OutputText">Calculate</asp:LinkButton>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label4" runat="server" cssclass="LabelNormal">Lot
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label5" runat="server" cssclass="LabelNormal">P/O
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblPONo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label12" runat="server" cssclass="LabelNormal">Model
                                                                    No / Description</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div align="left">
                                            </div>
                                            <div align="left">
                                            </div>
                                            <div align="left">
                                                <asp:Image id="Image1" runat="server" Width="100%" ImageUrl="Bar.gif"></asp:Image>
                                            </div>
                                            <div align="left">
                                            </div>
                                            <div align="left">
                                            </div>
                                            <div align="left">
                                            </div>
                                            <div align="left">
                                                <table style="HEIGHT: 16px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="91px" Text="Update"></asp:Button>
                                                            </td>
                                                            <td>
                                                                <p align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="85px" Text="Cancel"></asp:Button>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
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
    </form>
</body>
</html>
