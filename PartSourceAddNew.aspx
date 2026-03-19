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
    
    Sub LoadPartSource()
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim strSql as string = "Select * from Part_Master where Seq_No = " & request.params("ID") & ";"
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblPartNo.text = ResExeDataReader("PART_NO").toString
            lblDesc.text = ResExeDataReader("PART_Desc").toString
            lblSpec.text = ResExeDataReader("PART_Spec").toString
        loop
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as Erp_Gtm.Erp_Gtm = new ERp_Gtm.ERp_Gtm
    
        response.redirect("PartSourceDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';","Seq_No") )
    
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Try
                StrSql = "Insert into Part_Source(PART_NO,VEN_CODE,LEAD_TIME,UP_APP_NO,STD_PACK_QTY,MIN_ORDER_QTY,UP,CREATE_BY,CREATE_DATE) "
                StrSql = StrSql + "Select '" & trim(lblPartNo.text) & "','" & trim(cmbVenCode.selectedItem.value) & "'," & cint(txtLeadTime.text) & ",'" & trim(txtAppNo.text) & "'," & cint(txtStdPacking.text) & "," & cint(txtMOQ.text) & "," & txtUP.text & ",'" & request.cookies("U_ID").value & "','" & now & "';"
                ReqCOM.executeNonQuery(StrSql)
                response.redirect("PartSource.aspx?ID=" & Request.params("ID"))
    
            Catch Err as exception
                response.write(err.tostring)
            End try
        End if
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        cmbVenCode.items.clear
        dissql ("Select Ven_Code,Ven_Code + '|' + Ven_Name as [Desc]  from Vendor where ven_Code like '%" & trim(txtSearch.text) & "%' order by Ven_Code asc","Ven_Code","Desc",cmbVenCode)
        txtSearch.text = "-- Search --"
    End Sub
    
    Sub cmbVenCode_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">REGISTER NEW
                                PART SOURCE</asp:Label>
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
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid supplier." ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmbVenCode"></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 40px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" width="107px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblPartNo" runat="server" width="393px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" width="107px" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblDesc" runat="server" width="393px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" width="107px" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblSpec" runat="server" width="393px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" width="107px" cssclass="LabelNormal">Supplier</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                </td>
                                                                <td colspan="3">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtSearch" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                        &nbsp;&nbsp; 
                                                                        <asp:DropDownList id="cmbVenCode" runat="server" Width="292px" CssClass="OutputText" OnSelectedIndexChanged="cmbVenCode_SelectedIndexChanged"></asp:DropDownList>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" width="107px" cssclass="LabelNormal">Unit Price</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtUP" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" width="152px" cssclass="LabelNormal">Lead Time
                                                                    (Weeks)</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtLeadTime" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label10" runat="server" width="107px" cssclass="LabelNormal">Std. Packing</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtStdPacking" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label11" runat="server" width="107px" cssclass="LabelNormal">Min Order
                                                                    Qty.</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtMOQ" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" width="107px" cssclass="LabelNormal">Approval
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
