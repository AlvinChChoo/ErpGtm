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
                lblEntryBy.text = trim(Request.cookies("U_ID").value)
                lblEntryDate.text = format(cdate(now),"dd/MM/yy")
            End if
        End Sub
    
        Sub Button1_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            if ReqCOM.FuncCheckDuplicate("Select JO_No from Job_Order_D where JO_NO + PD_LEVEL = '" & trim(txtRefNo.text) & "';","JO_No") = true then
                GetJobOrderDet
            Else
                txtRefNo.text = ""
                txtAcc.text = ""
                txtRej.text = ""
                lblJONo.text = ""
                lblLevel.text = ""
                lblLotNo.text = ""
                lblModelNo.text = ""
                lblModelDesc.text = ""
                lblTotalIn.text = ""
                lblOnHoldQty.text = ""
                lblTotalOut.text = ""
                lblBalance.text = ""
                ShowAlert("You don't seem to have supplied a valid Ref. No.")
            End if
        End Sub
    
        Sub GetJobOrderDet()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim cnn As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnn.Open()
                Dim myCommand As SqlCommand = New SqlCommand("Select top 1 JD.JO_NO,JD.PD_LEVEL,JM.LOT_NO from Job_Order_D JD, JOB_ORDER_M JM where JD.JO_NO = JM.JO_NO AND JD.JO_NO + JD.PD_LEVEL = '" & trim(txtRefNo.text) & "';", cnn )
                Dim rs As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
                do while rs.read
                    lblJONo.text = rs("JO_NO")
                    lblLevel.text = rs("Pd_Level")
                    lblLotNo.text = rs("Lot_No")
                    lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_m where lot_No = '" & trim(lblLotNo.text) & "';","Model_No")
                    lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
                loop
                myCommand.dispose()
                rs.close()
                cnn.Close()
                cnn.Dispose()
    
                lblTotalIn.text = ReqCOm.GetFieldVal("Select In_Qty from Job_Order_D where jo_no + pd_level = '" & trim(txtRefNo.text) & "';","IN_Qty")
                lblTotalOut.text = ReqCOm.GetFieldVal("Select Out_Qty from Job_Order_D where jo_no + pd_level = '" & trim(txtRefNo.text) & "';","Out_Qty")
                lblOnHoldQty.text = ReqCOm.GetFieldVal("Select On_Hold_Qty from Job_Order_D where jo_no + pd_level = '" & trim(txtRefNo.text) & "';","On_Hold_Qty")
    
                if lblTotalIn.text = "<NULL>" then lblTotalIn.text = "0"
                if lblTotalOut.text = "<NULL>" then lblTotalOut.text = "0"
    
                lblBalance.text = clng(lblTotalIn.text) - (clng(lblOnHoldQty.text) + clng(lblTotalOut.text))
        End sub
    
         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
         Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
         Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
         with obj
             .items.clear
             .DataSource = ResExeDataReader
             .DataValueField = FValue
             .DataTextField = FText
             .DataBind()
         end with
         ResExeDataReader.close()
    End Sub
    
    Sub ShowAlert(Msg as string)
         Dim strScript as string
         strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
         If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Insert into Job_Order_Trail(jo_no,pd_level,prod_qty,create_by,create_date,trans_type,Acc_Qty,Rej_Qty) Select '" & trim(lblJONo.text) & "','" & trim(lblLevel.text) & "',-" & clng(txtAcc.text) + clng(txtRej.text) & ",'" & trim(request.cookies("U_ID").value) & "','" & cdate(now) & "','O'," & clng(txtAcc.text) & "," & clng(txtRej.text) & ";")
            ReqCOM.ExecuteNONQuery("Update Job_Order_D set Out_Qty = Out_Qty + " & clng(txtAcc.text) + clng(txtRej.text) & " where JO_No = '" & trim(lblJONo.text) & "' and pd_level = '" & trim(lblLevel.text) & "';")
    
            If ReqCOM.FuncCheckDuplicate("Select JO_NO from Job_Order_D where (Out_Qty + On_Hold_Qty) = In_Qty and JO_No = '" & trim(lblJONo.text) & "' and pd_level = '" & trim(lblLevel.text) & "';","JO_NO")
                ReqCOM.ExecuteNonQuery("Update Job_Order_D set jo_status = 'PENDING MRF' where JO_No = '" & trim(lblJONo.text) & "' and pd_level = '" & trim(lblLevel.text) & "';")
            end if
    
            ShowAlert ("Production Details updated")
            redirectPage("JobOrderEnd.aspx")
        end if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
        GetJobOrderStartEnd
    End Sub
    
    Sub GetJobOrderStartEnd()
    End sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        if clng(txtAcc.text) + clng(txtRej.text) > clng(lblBalance.text) then e.isvalid = false
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
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
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">PRODUCTION
                            OUTPUT TRACKING</asp:Label>
                            <asp:CompareValidator id="CompareValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don seem to have supplied a valid Accept Quantity." ForeColor=" " Display="Dynamic" ControlToValidate="txtAcc" Operator="GreaterThanEqual" Type="Integer" ValueToCompare="0"></asp:CompareValidator>
                            <asp:CompareValidator id="CompareValidator2" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don seem to have supplied a valid Reject Quantity." ForeColor=" " Display="Dynamic" ControlToValidate="txtRej" Operator="GreaterThanEqual" Type="Integer" ValueToCompare="0"></asp:CompareValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Accept Qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtAcc"></asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Reject Qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtRej"></asp:RequiredFieldValidator>
                            <asp:CustomValidator id="ValDateInput" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="" ForeColor=" " Display="Dynamic" OnServerValidate="ValDateInput_ServerValidate" EnableClientScript="False">Output Qty. not matched.</asp:CustomValidator>
                        </p>
                        <p align="center">
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="25%" bgcolor="silver">
                                                            <asp:Label id="Label2" runat="server" width="134px" cssclass="LabelNormal">Ref. No</asp:Label></td>
                                                        <td width="75%">
                                                            <asp:TextBox id="txtRefNo" onkeydown="KeyDownHandler(Button1)" runat="server" Width="299px" CssClass="OutputText"></asp:TextBox>
                                                            &nbsp;<asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="64px" CssClass="OutputText" Text="GO" CausesValidation="False"></asp:Button>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label8" runat="server" width="134px" cssclass="LabelNormal">Accept</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtAcc" runat="server" Width="227px" CssClass="OutputText"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label3" runat="server" width="134px" cssclass="LabelNormal">Scrap</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtRej" runat="server" Width="227px" CssClass="OutputText"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label4" runat="server" width="134px" cssclass="LabelNormal">Job Order
                                                            #</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblJONo" runat="server" width="134px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label7" runat="server" width="134px" cssclass="LabelNormal">Section</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLevel" runat="server" width="134px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label5" runat="server" width="134px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLotNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label30" runat="server" width="100%" cssclass="LabelNormal">Model No
                                                            / Description</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label9" runat="server" width="134px" cssclass="LabelNormal">Input Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblTotalIn" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label12" runat="server" width="134px" cssclass="LabelNormal">On Hold
                                                            Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOnHoldQty" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label10" runat="server" width="134px" cssclass="LabelNormal">Output
                                                            Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblTotalOut" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label11" runat="server" width="134px" cssclass="LabelNormal">WIP Outstanding</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblBalance" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label6" runat="server" width="134px" cssclass="LabelNormal">Entry By
                                                            / Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblEntryBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblEntryDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p align="left">
                                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="104px" Text="Update"></asp:Button>
                                                                <asp:TextBox id="txtJOSize" runat="server" Width="45px" Visible="False"></asp:TextBox>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="104px" Text="Cancel" CausesValidation="False"></asp:Button>
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
