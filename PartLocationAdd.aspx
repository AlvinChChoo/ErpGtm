<%@ Page Language="VB" %>
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
        if page.isPostBack = false then
            Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master order by Part_No asc","Part_No","Desc",cmbpartNo)
            Dissql("select Loc_Code from LOC order by Loc_Code","LOC_CODE","LOC_CODE",cmbLOCCode)
        end if
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            ReqCOM.ExecuteNonQuery("Insert into Part_Loc(Loc,Part_No) select '" & cmbLOCCode.selecteditem.value & "','" & trim(cmbPartNo.selecteditem.value) & "';")
            Response.redirect ("PartLocationCon.aspx")
        end if
    End Sub
    
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
    
    Sub ValDuplicateRec(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Part_no from Part_LOC where Part_no = '" & trim(cmbPartNo.selecteditem.value) & "' and LOC = '" & trim(cmbLocCode.selecteditem.value) & "';","Part_No") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("PartLocation.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
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
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">PART
                                LOCATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="60%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValDuplicateRec" ControlToValidate="cmbPartNo" Display="Dynamic" Width="100%">
                                    'Part Location' already exist.
                                </asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label7" runat="server" cssclass="OutputText">Part
                                                                        No</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label8" runat="server" cssclass="OutputText">Location
                                                                        Code</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbLocCode" runat="server" CssClass="OutputText" Width="50%"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label2" runat="server" width="100%" cssclass="Instruction">Are you
                                                    sure you want to add the above Part Location ?</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="53px" Text="No" CausesValidation="False"></asp:Button>
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
