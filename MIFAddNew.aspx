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
        if page.isPostBack = false then
            lblMIFDate.text = format(now,"dd/MMM/yy")
            Dissql ("Select Exp_Code,Exp_Code + '-' + Exp_Desc as [Exp_Desc] from Custom_Exp order by Exp_Desc asc","Exp_Code","Exp_Desc",cmbStationImp)
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("MIF.aspx")
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim ReqCOM as ERP_Gtm.ERP_Gtm = new ERP_Gtm.ERP_Gtm
            Dim MIFNo as string = ReqCOM.GetDocumentNo("MIF_No")
    
    
            if trim(txtInvNo.text) = "" then txtInvNo.text = "-"
            if trim(txtDONo.text) = "" then txtDONo.text = "-"
            if trim(txtCustomFormNo.text) = "" then txtCustomFormNo.text = "-"
            if trim(txtGPBNo.text) = "" then txtGPBNo.text = "-"
    
            Dim StrSql as string = "Insert into MIF_M(MIF_No,VEN_CODE,MIF_DATE,INV_NO,REM,do_no,Custom_form_no,CUSTOM_EXP,GPB_NO,CREATE_BY) "
            StrSql = StrSql + "Select '" & trim(ucase(MIFNo)) & "','" & trim(ucase(cmbSupplier.selectedItem.value)) & "',"
            StrSql = StrSql + "'" & Now & "','" & trim(ucase(txtInvNo.text)) & "',"
            StrSql = StrSql + "'" & trim(txtRem.text) & "','" & trim(ucase(txtDONo.text)) & "','" & trim(ucase(txtCustomFormNo.text)) & "','" & TRIM(ucase(cmbStationImp.selecteditem.value)) & "','" & TRIM(ucase(txtGPBNo.text)) & "','" & trim(ucase(request.cookies("U_ID").value)) & "';"
            ReqCOM.executeNonQuery(StrSql)
            ReqCOM.executeNonQuery("Update Main set MIF_NO = MIF_NO + 1")
            cmbSupplier.items.clear
            Response.redirect("MIFDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_no from MIF_M where MIF_NO = '" & trim(MIFNo) & "';","Seq_No"))
        End if
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
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbSupplier.items.clear
        Dissql ("Select ven_code,Ven_name as [Desc] from vendor where ven_code+ven_name like '%" & TRIM(txtSearch.text) & "%' order by ven_name asc","Ven_Code","Desc",cmbSupplier)
        txtSearch.text = "-- Search --"
    
        if cmbsupplier.selectedindex = -1 then
            ShowAlert ("Invalid supplier name or supplier code selected.")
            GetNextControl(txtSearch)
        Else
            GetNextControl(txtStatImp)
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
        Script.Append("<script language=javascript>")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').focus();")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').select();")
        Script.Append("</script" & ">")
        RegisterStartupScript("setFocus", Script.ToString())
    End Sub
    
    Sub cmdStatImp_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbStationImp.items.clear
        Dissql ("Select Exp_Code,Exp_Code + '-' + Exp_Desc as [Exp_Desc] from Custom_Exp where exp_code like '%" & trim(txtStatImp.text) & "%' order by Exp_Desc asc","Exp_Code","Exp_Desc",cmbStationImp)
        txtStatImp.text = "-- Search --"
    
        if cmbStationImp.selectedindex = -1 then
            ShowAlert ("Invalid Station Imp selected.")
            GetNextControl(txtStatImp)
        Else
            GetNextControl(txtGPBNo)
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">MATERIAL INCOMING
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="cmbSupplier" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Supplier Name." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">MIF Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearch)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                    &nbsp;&nbsp; 
                                                                    <asp:DropDownList id="cmbSupplier" runat="server" CssClass="OutputText" Width="330px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Station Imp</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtStatImp" onkeydown="KeyDownHandler(cmdStatImp)" onclick="GetFocus(txtStatImp)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdStatImp" onclick="cmdStatImp_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                    &nbsp;&nbsp; 
                                                                    <asp:DropDownList id="cmbStationImp" runat="server" CssClass="OutputText" Width="330px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">GPB No.</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtGPBNo" onkeydown="GetFocusWhenEnter(txtInvNo)" runat="server" CssClass="OutputText" Width="221px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Invoice No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtInvNo" onkeydown="GetFocusWhenEnter(txtDONo)" runat="server" CssClass="OutputText" Width="221px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">D/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDONo" onkeydown="GetFocusWhenEnter(txtCustomFormNo)" runat="server" CssClass="OutputText" Width="221px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Custom Form No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtCustomFormNo" onkeydown="GetFocusWhenEnter(txtRem)" runat="server" CssClass="OutputText" Width="221px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" onkeydown="KeyDownHandler(cmdSave)" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" CssClass="OutputText" Width="119px" Text="Save as new MIF"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" CssClass="OutputText" Width="119px" Text="Cancel" CausesValidation="False"></asp:Button>
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
                            <p align="center">
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
