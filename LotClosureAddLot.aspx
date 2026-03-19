<%@ Page Language="VB" Debug="true" %>
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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblLotClosureNo.text = ReqCOM.GetFIeldVal("Select Lot_Closure_no from Lot_Closure_m where Seq_no = " & clng(Request.params("ID")) & ";","Lot_Closure_no")
        end if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdNext_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            lblModelNo1.text = "" : lblLotSize1.text = "" : lblStatus1.text = ""
            lblModelNo2.text = "" : lblLotSize2.text = "" : lblStatus2.text = ""
            lblModelNo3.text = "" : lblLotSize3.text = "" : lblStatus3.text = ""
            lblModelNo4.text = "" : lblLotSize4.text = "" : lblStatus4.text = ""
            lblModelNo5.text = "" : lblLotSize5.text = "" : lblStatus5.text = ""
            lblModelNo6.text = "" : lblLotSize6.text = "" : lblStatus6.text = ""
            lblModelNo7.text = "" : lblLotSize7.text = "" : lblStatus7.text = ""
            lblModelNo8.text = "" : lblLotSize8.text = "" : lblStatus8.text = ""
            lblModelNo9.text = "" : lblLotSize9.text = "" : lblStatus9.text = ""
            lblModelNo10.text = "" : lblLotSize10.text = "" : lblStatus10.text = ""
    
            if trim(txtLotNo1.text) <> "" then GetLotDetail("1")
            if trim(txtLotNo2.text) <> "" then GetLotDetail("2")
            if trim(txtLotNo3.text) <> "" then GetLotDetail("3")
            if trim(txtLotNo4.text) <> "" then GetLotDetail("4")
            if trim(txtLotNo5.text) <> "" then GetLotDetail("5")
            if trim(txtLotNo6.text) <> "" then GetLotDetail("6")
            if trim(txtLotNo7.text) <> "" then GetLotDetail("7")
            if trim(txtLotNo8.text) <> "" then GetLotDetail("8")
            if trim(txtLotNo9.text) <> "" then GetLotDetail("9")
            if trim(txtLotNo10.text) <> "" then GetLotDetail("10")
    
            txtLotNo1.enabled = false
            txtLotNo2.enabled = false
            txtLotNo3.enabled = false
            txtLotNo4.enabled = false
            txtLotNo5.enabled = false
            txtLotNo6.enabled = false
            txtLotNo7.enabled = false
            txtLotNo8.enabled = false
            txtLotNo9.enabled = false
            txtLotNo10.enabled = false
    
            cmdnext.visible = false
            cmdback.visible = false
            cmdAdd.visible = true
            cmdcancel.visible = true
        End if
    End Sub
    
    Sub GetLotDetail(Ctrl as String)
        Dim StrSql as string
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
    
        If trim(Ctrl) = "1" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo1.text) & "';"
        If trim(Ctrl) = "2" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo2.text) & "';"
        If trim(Ctrl) = "3" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo3.text) & "';"
        If trim(Ctrl) = "4" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo4.text) & "';"
        If trim(Ctrl) = "5" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo5.text) & "';"
        If trim(Ctrl) = "6" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo6.text) & "';"
        If trim(Ctrl) = "7" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo7.text) & "';"
        If trim(Ctrl) = "8" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo8.text) & "';"
        If trim(Ctrl) = "9" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo9.text) & "';"
        If trim(Ctrl) = "10" then Strsql = "Select top 1 Model_No,Order_Qty,so_Status from SO_Models_m where lot_no = '" & trim(txtLotNo10.text) & "';"
    
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            If trim(Ctrl) = "1" then lblModelNo1.text = trim(drGetFieldVal("Model_No")) : lblLotSize1.text = trim(drGetFieldVal("Order_Qty")) : lblStatus1.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "2" then lblModelNo2.text = trim(drGetFieldVal("Model_No")) : lblLotSize2.text = trim(drGetFieldVal("Order_Qty")) : lblStatus2.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "3" then lblModelNo3.text = trim(drGetFieldVal("Model_No")) : lblLotSize3.text = trim(drGetFieldVal("Order_Qty")) : lblStatus3.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "4" then lblModelNo4.text = trim(drGetFieldVal("Model_No")) : lblLotSize4.text = trim(drGetFieldVal("Order_Qty")) : lblStatus4.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "5" then lblModelNo5.text = trim(drGetFieldVal("Model_No")) : lblLotSize5.text = trim(drGetFieldVal("Order_Qty")) : lblStatus5.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "6" then lblModelNo6.text = trim(drGetFieldVal("Model_No")) : lblLotSize6.text = trim(drGetFieldVal("Order_Qty")) : lblStatus6.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "7" then lblModelNo7.text = trim(drGetFieldVal("Model_No")) : lblLotSize7.text = trim(drGetFieldVal("Order_Qty")) : lblStatus7.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "8" then lblModelNo8.text = trim(drGetFieldVal("Model_No")) : lblLotSize8.text = trim(drGetFieldVal("Order_Qty")) : lblStatus8.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "9" then lblModelNo9.text = trim(drGetFieldVal("Model_No")) : lblLotSize9.text = trim(drGetFieldVal("Order_Qty")) : lblStatus9.text = trim(drGetFieldVal("so_Status"))
            If trim(Ctrl) = "10" then lblModelNo10.text = trim(drGetFieldVal("Model_No")) : lblLotSize10.text = trim(drGetFieldVal("Order_Qty")) : lblStatus10.text = trim(drGetFieldVal("so_Status"))
        loop
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
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
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        cmdnext.visible = true
        cmdback.visible = true
        cmdAdd.visible = false
        cmdcancel.visible = false
    
        txtLotNo1.enabled = true
        txtLotNo2.enabled = true
        txtLotNo3.enabled = true
        txtLotNo4.enabled = true
        txtLotNo5.enabled = true
        txtLotNo6.enabled = true
        txtLotNo7.enabled = true
        txtLotNo8.enabled = true
        txtLotNo9.enabled = true
        txtLotNo10.enabled = true
    End Sub
    
    Sub ValLotNo_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        e.isvalid = true
        if trim(txtLotNo1.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo1.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 1."
        end if
    
        if trim(txtLotNo2.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo2.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 2."
        end if
    
        if trim(txtLotNo3.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo3.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 3."
        end if
    
        if trim(txtLotNo4.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo4.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 4."
        end if
    
        if trim(txtLotNo5.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo5.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 5."
        end if
    
        if trim(txtLotNo6.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo6.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 6."
        end if
    
        if trim(txtLotNo7.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo7.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 7."
        end if
    
        if trim(txtLotNo8.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo8.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 8."
        end if
    
        if trim(txtLotNo9.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo9.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 9."
        end if
    
        if trim(txtLotNo10.text) <> "" then
            if ReqCOM.FuncCheckDuplicate("select top 1 Lot_No from so_models_m where lot_no = '" & trim(txtlotNo10.text) & "'","Lot_No") = false then e.isvalid = false : ValLotNo.errormessage = "Invalid Lot No for item 10."
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("LotClosureDet.aspx?ID=" & trim(request.params("ID")))
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim LotsToUpdate as string
    
        LotsToUpdate = "'0'"
        if trim(txtLotNo1.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo1.text) & "'"
        if trim(txtLotNo2.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo2.text) & "'"
        if trim(txtLotNo3.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo3.text) & "'"
        if trim(txtLotNo4.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo4.text) & "'"
        if trim(txtLotNo5.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo5.text) & "'"
        if trim(txtLotNo6.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo6.text) & "'"
        if trim(txtLotNo7.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo7.text) & "'"
        if trim(txtLotNo8.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo8.text) & "'"
        if trim(txtLotNo9.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo9.text) & "'"
        if trim(txtLotNo10.text) <> "" then LotsToUpdate = LotsToUpdate & ",'" & trim(txtLotNo10.text) & "'"
        ReqCOM.ExecuteNonQuery("Insert into Lot_Closure_d(Lot_No,Lot_Closure_No) select lot_no, '" & lblLotClosureNo.text & "' from SO_Models_M where lot_no in (" & TRIM(LotsToUpdate) & ")")
        'ShowAlert("Selected Lots has been CLOSED.")
        redirectPage("LotClosureAddLot.aspx?ID=" & Request.params("ID"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">BOM
                                Usage Report</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValLotNo" runat="server" CssClass="ErrorText" Width="100%" OnServerValidate="ValLotNo_ServerValidate" EnableClientScript="False" ErrorMessage="" Display="Dynamic" ForeColor=" "></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <asp:Label id="lblLotClosureNo" runat="server"></asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; HEIGHT: 286px; BORDER-RIGHT-COLOR: black" width="50%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="91" bgcolor="silver">
                                                <asp:Label id="Label1" runat="server" text="Lot #"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label3" runat="server" text="Model #"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label4" runat="server" text="Lot Size"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label6" runat="server" text="Lot Status"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo1" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo1" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize1" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus1" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo2" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo2" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize2" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus2" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo3" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo3" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize3" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus3" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo4" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo4" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize4" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus4" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo5" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo5" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize5" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus5" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo6" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo6" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize6" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus6" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo7" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo7" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize7" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus7" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo8" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo8" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize8" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus8" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo9" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo9" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize9" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus9" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtLotNo10" runat="server" CssClass="OutputText" Width="91px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Label id="lblModelNo10" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotSize10" runat="server" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStatus10" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <asp:Button id="cmdNext" onclick="cmdNext_Click" runat="server" Width="76px" Text="Next"></asp:Button>
                                <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="76px" Text="Back"></asp:Button>
                            </p>
                            <p align="center">
                                <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="76px" Text="Update" Visible="False"></asp:Button>
                                <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="76px" Text="Cancel" Visible="False"></asp:Button>
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
