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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim strsql as string = "Select top 1 * from Pallet_Record_M where seq_no = " & request.params("ID") & ";"
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
                lblJONo.text = drGetFieldVal("JO_No")
                lblPPRNo.text = drGetFieldVal("PPR_No")
                txtQty1x.text = drGetFieldVal("Qty1x")
                txtQty1y.text = drGetFieldVal("Qty1y")
                txtQty2x.text = drGetFieldVal("Qty2x")
                txtQty2y.text = drGetFieldVal("Qty2y")
                txtQty3x.text = drGetFieldVal("Qty3x")
                txtQty3y.text = drGetFieldVal("Qty3y")
                txtQty4x.text = drGetFieldVal("Qty4x")
                txtQty4y.text = drGetFieldVal("Qty4y")
    
                txtlineNo.text = trim(drGetFieldVal("Line_No").tostring)
                txtCartonNo.text = trim(drGetFieldVal("Carton_No").tostring)
                txtRem.text = trim(drGetFieldVal("Rem").tostring)
                txtDestination.text = trim(drGetFieldVal("Destination").tostring)
                txtPalNo.text = trim(drGetFieldVal("Pal_No").tostring)
    
    
                lblTotalPcs.text = drGetFieldVal("Total_PCS")
                lblLotNo.text = ReqCOM.GetFieldVal("Select Lot_No from Job_Order_M where jo_no = '" & trim(lblJONo.text) & "'","Lot_No")
                lblPONo.text = ReqCOM.GetFieldVal("Select PO_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "'","PO_No")
                lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "'","Model_No")
                lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "'","Model_Desc")
    
                lblCreateBy.text = drGetFieldVal("Create_By").tostring
                if isdbnull(drGetFieldVal("Create_Date")) = false then lblCreateDate.text = format(cdate(drGetFieldVal("Create_Date")),"dd/MM/yy")
    
                lblSubmitBy.text = drGetFieldVal("Submit_By").tostring
                if isdbnull(drGetFieldVal("Submit_Date")) = false then lblSubmitDate.text = format(cdate(drGetFieldVal("Submit_Date")),"dd/MM/yy")
    
                lblApp1By.text = drGetFieldVal("App1_By").tostring
                if isdbnull(drGetFieldVal("App1_Date")) = false then lblApp1Date.text = format(cdate(drGetFieldVal("App1_Date")),"dd/MM/yy")
    
                lblApp2By.text = drGetFieldVal("App2_By").tostring
                if isdbnull(drGetFieldVal("App2_Date")) = false then lblApp2Date.text = format(cdate(drGetFieldVal("App2_Date")),"dd/MM/yy")
    
                if trim(lblSubmitBy.text) <> "" then
                    cmdSubmit.enabled =false
                    cmdUpdate.enabled =false
                    txtQty1x.enabled =false
                    txtQty1y.enabled =false
                    txtQty2x.enabled =false
                    txtQty2y.enabled =false
                    txtQty3x.enabled =false
                    txtQty3y.enabled =false
                    txtQty4x.enabled =false
                    txtQty4y.enabled =false
                    cmdCalculate.enabled =false
                    cmdPrint.enabled = true
                elseif trim(lblSubmitBy.text) = "" then
                    cmdSubmit.enabled =true
                    cmdUpdate.enabled =true
                    txtQty1x.enabled =true
                    txtQty1y.enabled =true
                    txtQty2x.enabled =true
                    txtQty2y.enabled =true
                    txtQty3x.enabled =true
                    txtQty3y.enabled =true
                    txtQty4x.enabled =true
                    txtQty4y.enabled =true
                    cmdCalculate.enabled =true
                    cmdPrint.enabled = false
    
                end if
            loop
            myCommand.dispose()
            drGetFieldVal.close()
            myConnection.Close()
            myConnection.Dispose()
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PalletRecord.aspx")
    End Sub
    
    Sub cmdCalculate_Click(sender As Object, e As EventArgs)
        CalTotalPcs
    End Sub
    
    Sub CalTotalPcs()
        Dim TotalPcs as long = 0
        if trim(txtQty1X.text) <> "0" and trim(txtQty1Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty1X.text) * clng(txtQty1Y.text)
        if trim(txtQty2X.text) <> "0" and trim(txtQty2Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty2X.text) * clng(txtQty2Y.text)
        if trim(txtQty3X.text) <> "0" and trim(txtQty3Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty3X.text) * clng(txtQty3Y.text)
        if trim(txtQty4X.text) <> "0" and trim(txtQty4Y.text) <> "0" then TotalPcs = TotalPcs + clng(txtQty4X.text) * clng(txtQty4Y.text)
        lblTotalPcs.text = clng(TotalPcs)
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            UpdatePalletRecord
            ShowAlert("Pallet Record Updated.")
            redirectPage("PalletRecordDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            UpdatePalletRecord
            ReqCOM.ExecuteNonQuery("Update Pallet_Record_M set Submit_By = '" & trim(request.cookies("U_ID").value) & "', Submit_Date = '" & cdate(now) & "' where seq_no = " & request.params("ID") & ";")
            ShowAlert("Pallet Record Submitted.")
            redirectPage("PalletRecordDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub UpdatePalletRecord()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            CalTotalPcs
            ReqCOM.ExecuteNonQuery("Update Pallet_Record_M set QTY1X = " & clng(txtQty1X.text) & ",QTY1Y = " & clng(txtQty1Y.text) & ",QTY2X = " & clng(txtQty2X.text) & ",QTY2Y = " & clng(txtQty2y.text) & ",QTY3X = " & clng(txtQty3X.text) & ",QTY3Y = " & clng(txtQty3y.text) & ",QTY4X = " & clng(txtQty4X.text) & ",QTY4Y = " & clng(txtQty4y.text) & ",Total_PCS = " & clng(lblTotalPCS.text) & ",LINE_NO = '" & trim(txtLineNo.text) & "',CARTON_NO = '" & trim(txtCartonNo.text) & "',REM = '" & trim(txtRem.text) & "',DESTINATION = '" & trim(txtDestination.text) & "',PAL_NO = '" & trim(txtPalNo.text) & "' where seq_no = " & request.params("ID") & "")
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdPrint_Click(sender As Object, e As EventArgs)
        ShowReport ("PopupReportViewer.aspx?RptName=PalletRecord&ID=" & Request.params("ID"))
        redirectPage("PalletRecordDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">PALLET RECORD
                            DETAILS</asp:Label>
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
                                                                <div align="left"><asp:Label id="Label9" runat="server" cssclass="LabelNormal">PPR
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td width="75%">
                                                                <asp:Label id="lblPPRNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label3" runat="server" cssclass="LabelNormal">Job
                                                                    Order No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblJONo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Line No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtLineNo" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Carton No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtCartonNo" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" bgcolor="silver">
                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" TextMode="MultiLine" Height="62px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Destination</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtDestination" runat="server" CssClass="OutputText" Width="233px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Pallet No</asp:Label></td>
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
                                                                                <asp:TextBox id="txtQty1x" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                            <td width="10%">
                                                                                <div align="center"><asp:Label id="Label24" runat="server" cssclass="OutputText" width="100%">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td width="45%">
                                                                                <asp:TextBox id="txtQty1y" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty2x" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <div align="center"><asp:Label id="Label25" runat="server" cssclass="OutputText" width="100%">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty2y" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty3x" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <div align="center"><asp:Label id="Label26" runat="server" cssclass="OutputText" width="100%">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty3y" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty4x" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <div align="center"><asp:Label id="Label27" runat="server" cssclass="OutputText" width="100%">X</asp:Label>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <asp:TextBox id="txtQty4y" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
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
                                                                <asp:Label id="lblTotalPcs" runat="server" cssclass="OutputText" width="228px"></asp:Label>
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
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label5" runat="server" cssclass="LabelNormal">P/O
                                                                    No</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblPONo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label12" runat="server" cssclass="LabelNormal">Model
                                                                    No / Description</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label2" runat="server" cssclass="LabelNormal">Create
                                                                    By/Date</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label6" runat="server" cssclass="LabelNormal">Production</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label7" runat="server" cssclass="LabelNormal">FQA</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <div align="left"><asp:Label id="Label8" runat="server" cssclass="LabelNormal">FGS</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
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
                                            <p>
                                                <table style="HEIGHT: 11px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%">
                                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="90%" Text="Update"></asp:Button>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="center">
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="90%" Text="Submit"></asp:Button>
                                                                </div>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="center">
                                                                    <asp:Button id="cmdPrint" onclick="cmdPrint_Click" runat="server" Width="90%" Text="Print Pallet Record"></asp:Button>
                                                                </div>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="right">
                                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="90%" Text="Back"></asp:Button>
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
    </form>
</body>
</html>
