<%@ Page Language="VB" Debug="true" %>
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
            if page.ispostback = false then lblEffectiveDate.text = format(now,"MM/dd/yy")
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
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub cmdList_Click(sender As Object, e As EventArgs)
             response.redirect("SalesOrderModel.aspx")
         End Sub
    
         Sub cmbAdd_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub lnkList_Click(sender As Object, e As EventArgs)
             response.redirect("BOMProduction.aspx")
         End Sub
    
         Sub cmdProceed_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                 try
                    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                    Dim StrSql as string
                    Dim ModelFromRev,ModelToRev,NewRevNo as decimal
                    ModelFromRev = ReqCOM.GetFieldVal("Select top 1 Revision from BOM_M where Model_No = '" & trim(cmbModelFrom.selecteditem.value) & "' order by Revision desc","Revision")
    
                    If ReqCOM.FuncCheckDuplicate("select Model_No from BOM_M where Model_No = '"& trim(cmbModelNo.selectedItem.value) & "';","model_No") =  true then
                        ModelToRev = cdec(ReqCOM.GetFieldVal("Select Revision from BOM_M where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "';","Revision"))
                        NewRevNo = cdec(ModelToRev) + 0.1
                        ReqCOM.executeNonQuery("Insert into BOM_M(MODEL_NO,REVISION,EFFECTIVE_DATE,FECN_NO) Select '" & trim(cmbModelNo.selectedItem.value) & "'," & cdec(NewRevNo) & ",'" & now & "','" & trim(txtFECNNo.text) & "';")
    
                        StrSql = "Insert into BOM_D(MODEL_NO,PART_NO,P_LEVEL,ECN_DATE,P_LOCATION,ECN_NO,P_COLOR,PACKING,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) "
                        StrSql = StrSql & "Select '" & trim(cmbModelNo.selectedItem.value) & "',PART_NO,P_LEVEL,ECN_DATE,P_LOCATION,ECN_NO,P_COLOR,PACKING,LOT_FACTOR1,LOT_FACTOR2,P_USAGE," & cdec(ModelToRev) + 0.1 & " from bom_d where Model_No = '" & trim(cmbModelFrom.selectedItem.value) & "' and Revision = " & cdec(ModelFromRev) & ";"
                        ReqCOM.executeNonQuery(StrSql)
    
    
                        StrSql = "Insert into BOM_ALT(MODEL_NO,MAIN_PART,PART_NO,REVISION) "
                        StrSql = StrSql & "Select MODEL_NO,MAIN_PART,PART_NO," & cdec(NewRevNo) & " from BOM_ALT where Model_Code = '" & trim(cmbModelFrom.selecteditem.value) & "' and revision = " & cdec(ModelToRev) & ";"
    
    
                    else
                        ModelToRev = 1
                        ReqCOM.executeNonQuery("Insert into BOM_M(MODEL_NO,REVISION,EFFECTIVE_DATE,FECN_NO) Select '" & trim(cmbModelNo.selectedItem.value) & "'," & cdec(ModelToRev) & ",'" & now & "','" & trim(txtFECNNo.text) & "';")
    
                        StrSql = "Insert into BOM_D(MODEL_NO,PART_NO,P_LEVEL,ECN_DATE,P_LOCATION,ECN_NO,P_COLOR,PACKING,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) "
                        StrSql = StrSql & "Select '" & trim(cmbModelNo.selectedItem.value) & "',PART_NO,P_LEVEL,ECN_DATE,P_LOCATION,ECN_NO,P_COLOR,PACKING,LOT_FACTOR1,LOT_FACTOR2,P_USAGE," & cdec(ModelToRev) & " from bom_d where Model_No = '" & trim(cmbModelFrom.selectedItem.value) & "' and Revision = " & cdec(ModelFromRev) & ";"
                        ReqCOM.executeNonQuery(StrSql)
    
                        StrSql = "Insert into BOM_ALT(MODEL_NO,MAIN_PART,PART_NO,REVISION) "
                        StrSql = StrSql & "Select MODEL_NO,MAIN_PART,PART_NO," & cdec(NewRevNo) & " from BOM_ALT where Model_Code = '" & trim(cmbModelFrom.selecteditem.value) & "' and revision = " & cdec(ModelToRev) & ";"
                    end if
    
    
                    Dim SeqNo as integer = ReqCOM.GetFieldVal("Select top 1 Seq_No from BOM_M where Model_No = '" & trim(cmbModelNo.selectedItem.value) & "' order by revision desc","Seq_No")
    
                    Response.redirect("BOMMainList.aspx?ID=" & SeqNo )
    
                 Catch err As Exception
                     Response.write(err.tostring)
                 end try
             end if
         End Sub
    
         Sub cmdCancel_Click(sender As Object, e As EventArgs)
             Response.redirect("BOM.aspx")
         End Sub
    
         Sub cmdGo_Click(sender As Object, e As EventArgs)
             cmbModelFrom.items.clear
             dissql ("Select MM.MODEL_CODE,MM.Model_Code + '|' + MM.Model_Desc as [Desc] from Model_Master MM where MM.model_code in (select distinct(Model_No) from bom_m where Model_No like '%" & trim(txtmodelFrom.text) & "%') order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelFrom)
             txtModelFrom.text = "-- Search --"
         End Sub
    
         Sub cmdGo1_Click(sender As Object, e As EventArgs)
             cmbModelNo.items.clear
             Dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where model_code like '%" & trim(txtModelTo.text) & "%';","MODEL_CODE","Desc",cmbModelNo)
             txtModelTo.text = "-- Search --"
         End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" forecolor="" width="100%" cssclass="FormDesc">BOM
                                LIST (Main Part)</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtFECNNo" Display="Dynamic" ErrorMessage="You don;t seem to have supplied a valid FECN No." EnableClientScript="False" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="cmbModelFrom" Display="Dynamic" ErrorMessage="You don;t seem to have supplied a valid Model From." EnableClientScript="False" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="cmbModelNo" Display="Dynamic" ErrorMessage="You don;t seem to have supplied a valid Model To." EnableClientScript="False" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 119px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label7" runat="server" width="" cssclass="LabelNormal">Import Model
                                                                    From</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtModelFrom" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                    &nbsp;<asp:DropDownList id="cmbModelFrom" runat="server" CssClass="OutputText" Width="318px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" width="114px" cssclass="LabelNormal">Import
                                                                    Model to</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:TextBox id="txtModelTo" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                        <asp:Button id="Button1" onclick="cmdGo1_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                        &nbsp;<asp:DropDownList id="cmbModelNo" runat="server" CssClass="OutputText" Width="318px"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label11" runat="server" width="114px" cssclass="LabelNormal">FECN No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtFECNNo" runat="server" CssClass="OutputText" Width="180px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" width="" cssclass="LabelNormal">Effective Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblEffectiveDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <p align="left">
                                                                            <asp:Button id="cmdProceed" onclick="cmdProceed_Click" runat="server" Width="151px" Text="Proceed"></asp:Button>
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="151px" CausesValidation="False" Text="Cancel"></asp:Button>
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
        <p>
        </p>
    </form>
</body>
</html>
