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
                end if
            End Sub
    
            Sub cmbAdd_Click(sender As Object, e As EventArgs)
                If Page.isvalid = true then
                    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                    Dim strsql as string
                    Dim CurrUP as decimal
    
                    strsql = "insert into SO_MODELS_M(Lot_No,SO_Date,Cust_Code,Create_by,Create_date,pay_term,CONSIGNEE,NOTIFY_PARTY) Select '" & trim(txtLotNo.text) & "','" & now & "','" & trim(cmbCustCode.selecteditem.value) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "',pay_term,CONSIGNEE,NOTIFY_PARTY FROM CUST WHERE CUST_CODE = '" & trim(cmbCustCode.selecteditem.value) & "';"
                    reqCOM.ExecuteNonQuery(strsql)
                    response.redirect("SalesOrderModelDet.aspx?ID=" & ReqCom.GetFieldVal("Select Seq_No from SO_MODELS_M where Lot_No = '" & trim(txtLotNo.text) & "';","Seq_No"))
                  End if
            End Sub
    
            Sub cmdCancel_Click(sender As Object, e As EventArgs)
                response.redirect("SalesOrderModel.aspx")
            End Sub
    
            Sub ValDuplicateLotNo(sender As Object, e As ServerValidateEventArgs)
                Dim ReqCOM as ERP_Gtm.Erp_Gtm = new ERP_Gtm.Erp_Gtm
                If ReqCOM.FuncCheckDuplicate("Select Lot_No from SO_MODELS_M where LOT_NO = '" & trim(txtLotNo.text) & "';","Lot_No") = true then
                    e.isvalid = false
                Else
                    e.isvalid = true
                End if
            End Sub
    
        Sub cmdSearch_Click(sender As Object, e As EventArgs)
            Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust where cust_code + cust_name like '%" & trim(txtSearch.text) & "%' order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
    
            if cmbCustCode.selectedindex = 0 then
                txtSearch.text = "--Search--"
                GetNextControl(cmbCustCode)
            else
                txtSearch.text = "--Search--"
                ShowAlert("Customer code / name not found. Please select another.")
            end if
        End Sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
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
    
    Sub txtSearch_TextChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmbCustCode_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
    
            Script.Append("<script language=javascript>")
            Script.Append("document.getElementById('")
            Script.Append(ClientID)
            Script.Append("').focus();")
            Script.Append("</script" & ">")
            RegisterStartupScript("setFocus", Script.ToString())
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 48px" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label37" runat="server" width="100%" cssclass="FormDesc">NEW SALES
                                ORDER REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="86%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="DuplicateLotNo" runat="server" CssClass="ErrorText" ErrorMessage="Lot No already exist." Display="Dynamic" ForeColor=" " EnableClientScript="False" Width="100%" OnServerValidate="ValDuplicateLotNo"></asp:CustomValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Customer Code." Display="Dynamic" ForeColor=" " Width="100%" ControlToValidate="cmbCustCode"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Lot No" Display="Dynamic" ForeColor=" " Width="100%" ControlToValidate="txtLotNo"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="35%" bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="149px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLotNo" onkeydown="GetFocusWhenEnter(txtSearch)" runat="server" CssClass="OutputText" Width="431px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="149" bgcolor="silver" runat="server" cssclass="LabelNormal">
                                                                    <asp:Label id="Label1" runat="server" width="149px" cssclass="LabelNormal">Customer
                                                                    code</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmsSearch)" onclick="GetFocus(txtSearch)" runat="server" CssClass="OutputText" Width="78px" OnTextChanged="txtSearch_TextChanged">--Search--</asp:TextBox>
                                                                    <asp:Button id="cmsSearch" onclick="cmdSearch_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                    <asp:DropDownList id="cmbCustCode" runat="server" CssClass="OutputText" Width="304px" OnSelectedIndexChanged="cmbCustCode_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmbAdd" onclick="cmbAdd_Click" runat="server" Width="174px" Text="Save as new Sales Order"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" Text="Cancel" CausesValidation="False"></asp:Button>
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
                            <p>
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
