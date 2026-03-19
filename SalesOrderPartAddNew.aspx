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
            Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            lblSODate.text = format(Now,"MM/dd/yy")
        End if
    End Sub
    
    Sub Dissql(ByVal strSql As String,FValue as string,FText as string,Obj as Object)
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
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub cmdList_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPart.aspx")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if Page.isvalid = true then
            Dim reqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim DMth,DYr,DDay,strsql,DateInput as string
    
            DateInput = txtPODate.text
            DDay = DateInput.substring(0,2)
            DMth = DateInput.substring(3,2)
            DYr = DateInput.substring(6,2)
            txtPODate.text = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
    
            DateInput = txtDelDate.text
            DDay = DateInput.substring(0,2)
            DMth = DateInput.substring(3,2)
            DYr = DateInput.substring(6,2)
            txtDelDate.text = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
    
            StrSql = "Insert into SO_Part_M(Lot_No,SO_Date,Cust_Code,PO_No,PO_Date,create_by,create_date,req_date) "
            StrSQL = StrSQL + "Select '" & trim(txtLotNo.text) & "',"
            StrSQL = StrSQL + "'" & now & "',"
            StrSQL = StrSQL + "'" & trim(cmbCustCode.selectedItem.value) & "',"
            StrSQL = StrSQL + "'" & trim(txtPONo.text) & "',"
            StrSQL = StrSQL + "'" & trim(txtPODate.text) & "',"
    
            StrSQL = StrSQL + "'" & trim(request.cookies("U_ID").value) & "',"
            StrSQL = StrSQL + "'" & now & "',"
    
            StrSQL = StrSQL + "'" & trim(txtDelDate.text) & "'"
    
            'response.write(StrSql)
            ReqCOM.ExecuteNonQuery(StrSql)
            response.redirect("SalesOrderPartDet.aspx?ID=" + ReqCOM.getFieldVal("Select * from SO_Part_M where Lot_No = '" & trim(txtLotNo.text) & "';","Seq_No"))
        End if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPart.aspx")
    End Sub
    
    Sub ValDuplicateLotNo(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If ReqCOM.FuncCheckDuplicate("Select Lot_No from SO_Part_M where Lot_No = '" & trim(txtLotNo.text) & "';","Lot_No") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
             cmbCustCode.items.clear
             Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust where cust_code + Cust_Name like '%" & trim(txtSearch.text) & "%' order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
             txtSearch.text = "--Search--"
    End Sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim DateInput as string
        Dim DMth,DYr,DDay as string
    
        DateInput = txtPODate.text
        if trim(DateInput.length) = 8 then
            DDay = DateInput.substring(0,2)
            DMth = DateInput.substring(3,2)
            DYr = DateInput.substring(6,2)
            DateInput = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
            if isdate(DateInput) = false then
                e.isvalid = false
                ValDateInput.ErrorMessage = "You don't seem to have supplied a valid P/O Date"
            end if
        else
            e.isvalid = false
            ValDateInput.ErrorMessage = "You don't seem to have supplied a valid P/O Date"
        end if
    
        DateInput = txtDelDate.text
        if trim(DateInput.length) = 8 then
            DDay = DateInput.substring(0,2)
            DMth = DateInput.substring(3,2)
            DYr = DateInput.substring(6,2)
            DateInput = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
            if isdate(DateInput) = false then
                e.isvalid = false
                ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Customer Req. Date"
            end if
        else
            e.isvalid = false
            ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Customer Req. Date"
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
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label7" runat="server" cssclass="fORMdESC" width="100%">SALES ORDER
                                DETAILS - BY PARTS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="86%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="valLotNo" runat="server" Width="100%" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtLotNo" ErrorMessage="You don't seem to have supplied a valid Lot No." ForeColor=" "></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="valPODate" runat="server" Width="100%" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtPODate" ErrorMessage="You don't seem to have supplied a valid P/O Date." ForeColor=" "></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtDelDate" ErrorMessage="You don't seem to have supplied a valid Req. Del. Date." ForeColor=" "></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" CssClass="ErrorText" Display="Dynamic" ControlToValidate="cmbCustCode" ErrorMessage="You don't seem to have supplied a valid Customer Code." ForeColor=" "></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="DuplicateLotNo" runat="server" Width="100%" CssClass="ErrorText" Display="Dynamic" ErrorMessage="Lot No already exist." ForeColor=" " EnableClientScript="False" OnServerValidate="ValDuplicateLotNo"></asp:CustomValidator>
                                                    <asp:CustomValidator id="ValDateInput" runat="server" Width="100%" CssClass="ErrorText" Display="Dynamic" ErrorMessage="" ForeColor=" " EnableClientScript="False" OnServerValidate="ValDateInput_ServerValidate"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Issued Date</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="279px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Cust. Code</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmsSearch)" onclick="GetFocus(txtSearch)" runat="server" Width="78px" CssClass="OutputText">--Search--</asp:TextBox>
                                                                <asp:Button id="cmsSearch" onclick="cmdSearch_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                &nbsp; 
                                                                <asp:DropDownList id="cmbCustCode" runat="server" Width="308px" CssClass="OutputText"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtLotNo" runat="server" Width="217px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">Req. Del.
                                                                Date (dd/mm/yy)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtDelDate" runat="server" Width="217px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">P / O No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPONo" runat="server" Width="217px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">P / O Date (dd/mm/yy)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPODate" runat="server" Width="217px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Confirm Order"></asp:Button>
                                                                    </p>
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
