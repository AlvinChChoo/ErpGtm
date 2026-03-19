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
                loaddata()
            end if
        End Sub
    
        Sub LoadData()
            Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnnGetFieldVal.Open()
            Dim StrSql as string = "Select top 1 * from Model_Master where Seq_No = " & request.params("ID") & ";"
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
                lblModelNo.text = drGetFieldVal("Model_Code").tostring
                if isdbnull(drGetFieldVal("Qty_Ctn")) = false then txtQtyCtn.text = drGetFieldVal("Qty_Ctn")
                if isdbnull(drGetFieldVal("G_Weight")) = false then txtGWeight.text = format(drGetFieldVal("G_Weight"),"##0.00")
                if isdbnull(drGetFieldVal("N_Weight")) = false then txtNWeight.text = format(drGetFieldVal("N_Weight"),"##0.00")
    
                if isdbnull(drGetFieldVal("DIM_X")) = false then txtDimX.text = drGetFieldVal("DIM_X")
                if isdbnull(drGetFieldVal("DIM_Y")) = false then txtDimY.text = drGetFieldVal("DIM_Y")
                if isdbnull(drGetFieldVal("DIM_Z")) = false then txtDimZ.text = drGetFieldVal("DIM_Z")
                if isdbnull(drGetFieldVal("CBM")) = false then txtCBM.text = format(drGetFieldVal("CBM"),"####0.00000")
            loop
    
    
            myCommand.dispose()
            drGetFieldVal.close()
            cnnGetFieldVal.Close()
            cnnGetFieldVal.Dispose()
    
        End sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmbUpdate_Click(sender As Object, e As EventArgs)
    
        End Sub
    
        Sub SaveDetails()
            if page.isvalid = true then
    
            End if
        End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdApp_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderPCMCApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderPCMCReject.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderModel.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid =true then
    
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("MasterPackingSpec.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSQL as string
    
            StrSql = "Update Model_Master set Qty_Ctn = " & txtQtyCtn.text & ",G_Weight = " & txtGWeight.text & ",N_Weight = " & txtNWeight.text & ",Dim_X = " & txtDIMX.text & ",Dim_Y = " & txtDimY.text & ",Dim_Z = " & txtDimZ.text & ",CBM = " & txtCBM.text & " where seq_no = " & request.params("ID") & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            ShowAlert("Packing specification updated.")
            redirectPage("MasterPackingSpecDet.aspx?ID=" & Request.params("ID"))
        End if
    End Sub

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
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">MASTER PACKING
                            SPECIFICATION DETAILS</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="60%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p align="center">
                                                <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtQtyCtn" ErrorMessage="Invalid Qty/Cnt" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator2" runat="server" ControlToValidate="txtGWeight" ErrorMessage="Invalid G. Weight" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator3" runat="server" ControlToValidate="txtNWeight" ErrorMessage="CompareValidator" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0">Invalid N. Weight</asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator4" runat="server" ControlToValidate="txtDimX" ErrorMessage="Invalid Dimension - X" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThanEqual" ValueToCompare="0"></asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator5" runat="server" ControlToValidate="txtDimY" ErrorMessage="Invalid Dimension - Y" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator6" runat="server" ControlToValidate="txtDimZ" ErrorMessage="Invalid Dimension - Z" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator7" runat="server" ControlToValidate="txtCBM" ErrorMessage="Invalid CBM" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Model No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Qty/CTN</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtQtyCtn" runat="server" Width="196px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="100%">G. Weight(KG)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtGWeight" runat="server" Width="196px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="100%">N. Weight(KG)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtNWeight" runat="server" Width="196px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Dimension</asp:Label></td>
                                                            <td>
                                                                <p align="left">
                                                                    <asp:TextBox id="txtDimX" runat="server" Width="52px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label9" runat="server" cssclass="OutputText">X</asp:Label>&nbsp;<asp:TextBox id="txtDimY" runat="server" Width="52px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label10" runat="server" cssclass="OutputText">X</asp:Label>&nbsp;<asp:TextBox id="txtDimZ" runat="server" Width="52px" CssClass="OutputText"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">CBM</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtCBM" runat="server" Width="196px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="HEIGHT: 11px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="109px" Text="Update"></asp:Button>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="96px" Text="Back" CausesValidation="False"></asp:Button>
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
