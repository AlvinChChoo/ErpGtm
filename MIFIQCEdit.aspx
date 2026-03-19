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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MIFNo as string
            Dim rsMIFD as SqlDataReader
            Dim rsMIFM as SqlDataReader
            DIM rsPartMaster as SqlDataReader
    
            rsMIFD = ReqCOM.ExeDataReader("Select * from MIF_D where Seq_No = " & request.params("ID") & ";")
            do while rsMIFD.read
                MIFNo = rsMIFD("MIF_No").tostring
                lblPartNo.text = rsMIFD("Part_No").tostring
                lblMIFQty.text = rsMIFD("IN_QTY").tostring
                lblPONo.text = rsMIFD("PO_NO").tostring
                txtAcceptQty.text = rsMIFD("ACCEPT_QTY").tostring
                txtRejectQty.text = rsMIFD("REJ_QTY").tostring
                txtRem.text = rsMIFD("Rem").tostring
            loop
    
            rsPartMaster = ReqCOM.ExeDataReader("Select * from part_Master where part_no = '" & trim(lblPartNo.text) & "';")
            do while rsPartMaster.read
                lblPartDesc.text = rsPartMaster("Part_Desc").tostring
                lblPartSpec.text = rsPartMaster("Part_Spec").tostring
                lblMfgPartNo.text = rsPartMaster("M_Part_No").tostring
            Loop
    
            RsMIFM = ReqCOM.exeDataReader("Select * from MIF_M where MIF_NO = '" & trim(MIFNO) & "';")
            do while rsMIFM.read
                lblMIFDate.text = format(cdate(rsMIFM("MIF_DATE")),"dd/MMM/yy")
                lblMIFNo.text = rsMIFM("MIF_NO")
                lblSupplier.text = rsMIFM("VEN_CODE")
                lblInvNo.text = rsMIFM("INV_NO")
                lblDoNo.text = rsMIFM("DO_NO")
            Loop
    
            RsMIFM.close()
            rsPartMaster.close()
            rsMIFD.close()
    
            if ReqCOM.FuncCheckDuplicate("SELECT App2_By FROM mif_m WHERE mif_no = '" & TRIM(lblMIFNo.text) & "' and App2_By is not null","App2_By") = true then
                cmdUpdate.visible = false
            End if
        end if
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update MIF_D set Part_Type = '" & trim(cmbPartType.selecteditem.value) & "',IQC_REM = '" & trim(txtRem.text) & "',Accept_qty = " & cint(txtAcceptQty.text) & ", Rej_Qty = " & cint(txtRejectQty.text) & ",IQC_CHECK_BY = '" & trim(request.cookies("U_ID").value) & "',IQC_CHECK_DATE = '" & now & "' where Seq_No = " & request.params("ID") & ";")
            response.redirect("MIFIQCDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from MIF_M where mif_no = '" & trim(lblMIFNo.text) & "';","Seq_No"))
        End if
    End Sub
    
    Sub ValTotalQty(sender As Object, e As ServerValidateEventArgs)
        if txtAcceptQty.text = "" then exit sub
        if txtRejectQty.text = "" then exit sub
        if isnumeric(txtAcceptQty.text) = False then exit sub
        if isnumeric(txtRejectQty.text) = false then exit sub
        if cint(txtAcceptQty.text) + cint(txtRejectQty.text) <> cint(lblMIFQty.text) then e.isvalid = false
    End Sub
    
    Sub ValRem(sender As Object, e As ServerValidateEventArgs)
        if txtRejectQty.text = "" then exit sub
        if isnumeric(txtRejectQty.text) = false then exit sub
        if cint(txtRejectQty.text) > 0 then
            if trim(txtRem.text) = "" then e.isvalid = false
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        response.redirect("MIFIQCDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from MIF_M where MIF_NO = '" & trim(lblMIFNo.text) & "';","Seq_No"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">MATERIAL INCOMING
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid accept qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtAcceptQty" EnableClientScript="False" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid reject qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtRejectQty" EnableClientScript="False" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="left">
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid accept qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtAcceptQty" EnableClientScript="False" CssClass="ErrorText" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                </div>
                                                <div align="left">
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid reject qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtRejectQty" EnableClientScript="False" CssClass="ErrorText" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                </div>
                                                <div align="left">
                                                    <asp:CustomValidator id="CheckTotalQty" runat="server" Width="100%" ErrorMessage="Accept and Reject Qty must equal to MIF Qty." ForeColor=" " Display="Dynamic" EnableClientScript="False" CssClass="ErrorText" OnServerValidate="ValTotalQty"></asp:CustomValidator>
                                                </div>
                                                <div align="left">
                                                    <asp:CustomValidator id="CustomValRem" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid reject remarks." ForeColor=" " Display="Dynamic" EnableClientScript="False" CssClass="ErrorText" OnServerValidate="ValRem"></asp:CustomValidator>
                                                </div>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="142px" cssclass="LabelNormal">MIF Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFDate" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" width="142px" cssclass="LabelNormal">MIF No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" width="142px" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSupplier" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" width="142px" cssclass="LabelNormal">Invoice
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblInvNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="142px" cssclass="LabelNormal">D/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDONo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="142px" cssclass="LabelNormal">P/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPONo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="142px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="142px" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartDesc" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="142px" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartSpec" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" width="142px" cssclass="LabelNormal">MFG Part
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMfgPartNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" width="142px" cssclass="LabelNormal">MIF Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFQty" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" width="142px" cssclass="LabelNormal">Part Type</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbPartType" runat="server" Width="185px" CssClass="OutputText">
                                                                        <asp:ListItem Value="GENERAL">General</asp:ListItem>
                                                                        <asp:ListItem Value="PACKING">Packing</asp:ListItem>
                                                                        <asp:ListItem Value="PLASTIC">Plastic</asp:ListItem>
                                                                        <asp:ListItem Value="ELECTRONIC">Electronic</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" width="142px" cssclass="LabelNormal">Accept
                                                                    Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtAcceptQty" runat="server" Width="185px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" width="142px" cssclass="LabelNormal">Reject
                                                                    Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRejectQty" runat="server" Width="185px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label15" runat="server" width="142px" cssclass="LabelNormal">Reject
                                                                    remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" Height="45px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update MIF item"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="104px" Text="Back" CausesValidation="False"></asp:Button>
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
        </p>
    </form>
</body>
</html>
