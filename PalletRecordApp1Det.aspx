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
                lblQty1x.text = drGetFieldVal("Qty1x")
                lblQty1y.text = drGetFieldVal("Qty1y")
                lblQty2x.text = drGetFieldVal("Qty2x")
                lblQty2y.text = drGetFieldVal("Qty2y")
                lblQty3x.text = drGetFieldVal("Qty3x")
                lblQty3y.text = drGetFieldVal("Qty3y")
                lblQty4x.text = drGetFieldVal("Qty4x")
                lblQty4y.text = drGetFieldVal("Qty4y")
                lblTotalPcs.text = drGetFieldVal("Total_PCS")
                lblLotNo.text = ReqCOM.GetFieldVal("Select Lot_No from Job_Order_M where jo_no = '" & trim(lblJONo.text) & "'","Lot_No")
                lblPONo.text = ReqCOM.GetFieldVal("Select PO_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "'","PO_No")
                lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "'","Model_No")
                lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "'","Model_Desc")
    
                lbllineNo.text = trim(drGetFieldVal("Line_No").tostring)
                lblCartonNo.text = trim(drGetFieldVal("Carton_No").tostring)
                lblPPRRem.text = trim(drGetFieldVal("Rem").tostring)
                lblDestination.text = trim(drGetFieldVal("Destination").tostring)
                lblPalNo.text = trim(drGetFieldVal("Pal_No").tostring)
    
    
                lblCreateBy.text = drGetFieldVal("Create_By").tostring
                if isdbnull(drGetFieldVal("Create_Date")) = false then lblCreateDate.text = format(cdate(drGetFieldVal("Create_Date")),"dd/MM/yy")
    
                lblSubmitBy.text = drGetFieldVal("Submit_By").tostring
                if isdbnull(drGetFieldVal("Submit_Date")) = false then lblSubmitDate.text = format(cdate(drGetFieldVal("Submit_Date")),"dd/MM/yy")
    
                lblApp1By.text = drGetFieldVal("App1_By").tostring
                if isdbnull(drGetFieldVal("App1_Date")) = false then lblApp1Date.text = format(cdate(drGetFieldVal("App1_Date")),"dd/MM/yy")
    
                lblApp2By.text = drGetFieldVal("App2_By").tostring
                if isdbnull(drGetFieldVal("App2_Date")) = false then lblApp2Date.text = format(cdate(drGetFieldVal("App2_Date")),"dd/MM/yy")
            loop
            myCommand.dispose()
            drGetFieldVal.close()
            myConnection.Close()
            myConnection.Dispose()
    
            if trim(lblApp1By.text) <> "" then
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
                cmdSubmit.enabled = false
            end if
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PalletRecordApp1.aspx")
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            if rbApprove.checked = true then
                ReqCOM.ExecuteNonQUery("Update Pallet_Record_M set App1_By = '" & trim(Request.cookies("U_ID").value) & "',App1_Date = '" & cdate(now) & "', App1_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App1_Status = 'Y',Pallet_Status = 'PENDING APPROVAL' where Seq_No = " & Request.params("ID") & ";")
                ShowAlert("Selected Pallet Record has been approved.")
                redirectPage("PalletRecordApp1Det.aspx?ID=" & Request.params("ID"))
            elseif rbReject.checked = true then
                ReqCOM.ExecuteNonQUery("Update Pallet_Record_M set App1_By = '" & trim(Request.cookies("U_ID").value) & "',App1_Date = '" & cdate(now) & "', App1_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App1_Status = 'N',Pallet_Status = 'REJECTED' where Seq_No = " & Request.params("ID") & ";")
                ShowAlert("Selected Pallet Record has been rejected.")
                redirectPage("PalletRecordApp1Det.aspx?ID=" & Request.params("ID"))
            End if
        end if
    End Sub

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
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">PALLET RECORD
                            DETAILS</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="76%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="25%" bgcolor="silver">
                                                            <div align="left"><asp:Label id="Label9" runat="server" cssclass="LabelNormal">PPR
                                                                No</asp:Label>
                                                            </div>
                                                        </td>
                                                        <td width="75%">
                                                            <asp:Label id="lblPPRNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <div align="left"><asp:Label id="Label3" runat="server" cssclass="LabelNormal">Job
                                                                Order No</asp:Label>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <asp:Label id="lblJONo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Line No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLineNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Carton No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCartonNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" bgcolor="silver">
                                                            <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblPPRRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Destination</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDestination" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Pallet No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblPalNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" bgcolor="silver">
                                                            <div align="left"><asp:Label id="Label15" runat="server" cssclass="LabelNormal">Quantity</asp:Label>
                                                            </div>
                                                        </td>
                                                        <td valign="top">
                                                            <table style="HEIGHT: 71px" width="40%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td width="45%">
                                                                            <div align="right"><asp:Label id="lblQty1X" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td width="10%">
                                                                            <div align="center"><asp:Label id="Label24" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td width="45%">
                                                                            <asp:Label id="lblQty1y" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div align="right"><asp:Label id="lblQty2x" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <div align="center"><asp:Label id="Label25" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label id="lblQty2y" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div align="right"><asp:Label id="lblQty3x" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <div align="center"><asp:Label id="Label26" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label id="lblQty3y" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <div align="right"><asp:Label id="lblQty4x" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <div align="center"><asp:Label id="Label27" runat="server" width="100%" cssclass="OutputText">X</asp:Label>
                                                                            </div>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label id="lblQty4y" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
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
                                                            <asp:Label id="lblTotalPcs" runat="server" width="228px" cssclass="OutputText"></asp:Label></td>
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
                                            <p>
                                                <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td valign="top" width="25%">
                                                                <asp:Label id="lblRem" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                            <td width="55%">
                                                                <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Height="56px" Width="100%"></asp:TextBox>
                                                            </td>
                                                            <td width="20%">
                                                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:RadioButton id="rbApprove" runat="server" CssClass="OutputText" GroupName="Status" Text="Approve"></asp:RadioButton>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:RadioButton id="rbReject" runat="server" CssClass="OutputText" GroupName="Status" Text="Reject"></asp:RadioButton>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <div align="left">
                                                <asp:Image id="Image1" runat="server" Width="100%" ImageUrl="Bar.gif"></asp:Image>
                                            </div>
                                            <div align="left">
                                                <p>
                                                    <table style="HEIGHT: 11px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" CssClass="OutputText" Width="113px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="118px" Text="Back"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
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
