<%@ Page Language="VB" %>
<%@ Register TagPrefix="erp" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if ispostback = false then LoadPartSource()
    End Sub
    
    Sub LoadPartSource()
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim strSql as string = "Select * from Part_Source where Seq_No = " & request.params("ID") & ";"
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblPartNo.text = ResExeDataReader("PART_NO").toString
            lblSupplierCode.text = ResExeDataReader("VEN_CODE").toString
            txtUP.text = ResExeDataReader("UP").tostring
            txtLeadTime.text = ResExeDataReader("LEAD_TIME").toString
            txtStdPacking.text = cint(ResExeDataReader("STD_PACK_QTY"))
            txtMOQ.text = cint(ResExeDataReader("MIN_ORDER_QTY"))
            txtAppNo.text = ResExeDataReader("UP_APP_NO")
            'lblModifyBy.text = ResExeDataReader("Modify_By").tostring
            'lblModifyDate.text = format(cdate(ResExeDataReader("Modify_Date")),"MM/dd/yy")
        loop
    
        lblSupplierName.text = ReqCOM.GetFieldVal("Select Ven_Name from Vendor where Ven_Code ='" & trim(lblSupplierCode.text) & "';","Ven_Name")
        lblDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No ='" & trim(lblPartNo.text) & "';","Part_Desc")
        lblSpec.text = ReqCOM.GetFieldVal("Select part_Spec from Part_Master where Part_No ='" & trim(lblPartNo.text) & "';","part_Spec")
    
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as Erp_Gtm.Erp_Gtm = new ERp_Gtm.ERp_Gtm
    
        response.redirect("PartSourceDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';","Seq_No") )
    
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Try
                ReqCOM.executeNonQuery("Update Part_Source set UP = " & txtUP.text & ",Lead_Time = " & cint(txtLeadTime.text) & ", Std_Pack_Qty = " & cint(txtStdPacking.text) & ", Min_Order_Qty= " & cint(txtMOQ.text) & ",UP_APP_NO = '" & trim(txtAppNo.text) & "',Modify_Date = '" & now & "',Modify_By = '" & request.cookies("U_ID").value & "' where Seq_No = " & request.params("ID") & ";")
                response.redirect("PartSourceDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';","Seq_No") )
            Catch Err as exception
                response.write(err.tostring)
            End try
        End if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">PART SOURCE
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Unit Price." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtUP"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid lead time." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtLeadTime"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Std. packing" ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtStdPacking"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Min Order Qty." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtMOQ"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="left">
                                                    <asp:comparevalidator id="CompareValidator1" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid unit price." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtUP" Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                </p>
                                                <p align="left">
                                                    <asp:comparevalidator id="CompareValidator2" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid lead time." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtLeadTime" Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                </p>
                                                <p align="left">
                                                    <asp:comparevalidator id="CompareValidator3" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid std. packing." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtStdPacking" Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                </p>
                                                <p align="left">
                                                    <asp:comparevalidator id="CompareValidator4" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid min order qty." ForeColor=" " EnableClientScript="False" Display="Dynamic" CssClass="ErrorText" ControlToValidate="txtMOQ" Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 40px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="107px">Part No</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblPartNo" runat="server" cssclass="OutputText" width="393px"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="107px">Description</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblDesc" runat="server" cssclass="OutputText" width="393px"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="107px">Specification</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblSpec" runat="server" cssclass="OutputText" width="393px"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="107px">Supplier
                                                                    Code</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                                                </td>
                                                                <td colspan="3">
                                                                    <div align="left"><asp:Label id="lblSupplierCode" runat="server" cssclass="OutputText" width="318px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="107px">Supplier
                                                                    Name</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left"><asp:Label id="lblSupplierName" runat="server" cssclass="OutputText" width="318px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="107px">Unit Price</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtUP" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="152px">Lead Time
                                                                    (Weeks)</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtLeadTime" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="107px">Std. Packing</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtStdPacking" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="107px">Min Order
                                                                    Qty.</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtMOQ" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="107px">Approval
                                                                    No.</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtAppNo" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="left">
                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="157px" Text="Update Part Source"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="157px" Text="Back"></asp:Button>
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
