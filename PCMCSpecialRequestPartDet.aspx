<%@ Page Language="VB" %>
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
        if request.cookies("U_ID") is nothing then response.redirect("Login.aspx")
        Dim ReqCOm as Erp_Gtm.Erp_Gtm = New Erp_Gtm.ERp_Gtm
        lblSRNo.text = ReqCOm.GetFieldVal("select SR_NO from special_req_d where seq_no = " & request.params("ID") & ";","SR_No")
        if page.ispostback = false then LoadData
    End Sub
    
    sub LoadData
        Dim strSql as string = "SELECT * FROM Special_req_D WHERE SEQ_NO = " & request.params("ID")  & ";"
         Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
         Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
         Dim CurrPartNo as string
         do while ResExeDataReader.read
            lblSRNo.text = ResExeDataReader("SR_NO").toString
            lblPartNo.text = trim(ResExeDataReader("Part_NO").toString)
            txtQty.text= format(ResExeDataReader("QTY_REQ"),"##,##0.00")
         loop
    end sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = trim(FValue)
                .DataTextField = trim(FText)
                .DataBind()
            end with
            ResExeDataReader.close()
        End Sub
    
    Sub Menu1_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub Button2_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("CustomerAddNew.aspx")
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim StrSql as string
            StrSQL = "Update Special_req_d set Qty_Req = " & txtQty.text & " where Seq_No = " & request.params("ID") & ";"
            ReqCOM.executeNonQuery(StrSql)
            Response.redirect("SpecialRequestDet.aspx?ID=" + reqCOM.GetFieldVal("Select Seq_No from Special_Req_M where SR_No = '" & trim(lblSRNo.text) & "';","Seq_No"))
        end if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" forecolor="" backcolor=" " width="100%" cssclass="FormDesc">Special
                                Request Details. </asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="ValQty" runat="server" Width="537px" ForeColor=" " Display="Dynamic" ControlToValidate="txtQty" ErrorMessage="You don't seem to have supplied a valid request qty. " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:comparevalidator id="ValQtyFormat" runat="server" Width="543px" ForeColor=" " Display="Dynamic" ControlToValidate="txtQty" ErrorMessage="You don't seem to have supplied a valid  request qty." CssClass="ErrorText" Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                </p>
                                                <p>
                                                    <asp:comparevalidator id="CompareValidator1" runat="server" Width="543px" ForeColor=" " Display="Dynamic" ControlToValidate="txtQty" ErrorMessage="You don't seem to have supplied a valid  request qty." CssClass="ErrorText" Operator="GreaterThan" Type="Currency" ValueToCompare="0"></asp:comparevalidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 41px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label1" runat="server" width="125px" cssclass="LabelNormal">SR No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSRNo" runat="server" width="321px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" width="125px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartNo" runat="server" width="321px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" width="125px" cssclass="LabelNormal">Request
                                                                    Qty.</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtQty" runat="server" Width="321px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="157px" Text="Update"></asp:Button>
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
