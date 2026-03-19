<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=9.1.5000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
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
             end if
         End Sub



         Sub cmdList_Click(sender As Object, e As EventArgs)
             response.redirect("Model.aspx")
         End Sub

         Sub cmdBack_Click(sender As Object, e As EventArgs)
             response.redirect("BOMQuote.aspx")
         End Sub

         Sub ShowSelection(s as object,e as DataListCommandEventArgs)
         end sub

         Sub LinkButton1_Click(sender As Object, e As EventArgs)
             response.redirect("ModelFeatureList.aspx?ID=" + request.params("ID"))
         End Sub

         Sub lnlAddPic_Click(sender As Object, e As EventArgs)
             response.redirect("ModelPic.aspx?ID=" + request.params("ID"))
         End Sub

         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub

         Sub cmdSave_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim RefNo as string = ReqCOM.GetDocumentNo("BOM_QUOTE_NO")

                if ReqCOm.FuncCheckDuplicate("Select BOM_Quote_Rev from BOM_Quote_M where Cust_Code = '" & trim(cmbSearchCustCode.selecteditem.value) & "' and Model_No = '" & trim(cmbModelNo.selecteditem.value) & "';","BOM_Quote_Rev") = true then
                    lblBomQuoteRev.text = clng(ReqCOM.GetFieldVal("Select max(BOM_Quote_Rev) as [BOM_Quote_Rev] from BOM_Quote_M where Cust_Code = '" & trim(cmbSearchCustCode.selecteditem.value) & "' and Model_No = '" & trim(cmbModelNo.selecteditem.value) & "';","BOM_Quote_Rev")) + 1
                else
                    lblBomQuoteRev.text = "1"
                end if

                ReqCOm.ExecuteNonQuery("Insert into BOM_QUOTE_M(BOM_Quote_No,Cust_Code,Cust_Name,model_no,model_Desc,BOM_Quote_Rev,Curr_Code) select '" & trim(RefNo) & "','" & trim(cmbSearchCustCode.selecteditem.value) & "','" & trim(replace(txtCustName.text,"'","`")) & "','" & trim(cmbModelNo.selecteditem.value) & "','" & trim(txtModelDesc.text) & "'," & clng(lblBomQuoteRev.text) & ",'" & trim(cmbCurrCode.selecteditem.value) & "';")
                ReqCom.executeNonQuery("insert into bom_quote_curr(BOM_QUOTE_NO,CURR_CODE,CURR_DESC,UNIT_CONV,RATE,US_DLR) select '" & trim(RefNo) & "',CURR_CODE,CURR_DESC,UNIT_CONV,RATE,US_DLR from curr where curr_code <> '-'")

                ReqCOM.ExecuteNonQUery("Update Main set BOM_QUOTE_No = BOM_Quote_No + 1")
                Response.redirect("BOMQuoteDet.aspx?ID=" & ReqCOm.GetFieldVal("Select Seq_No from BOM_Quote_M where BOM_QUOTE_NO = '" & trim(RefNo) & "';","Seq_No"))
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

         Sub cmdGo_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim cnnGetFieldVal As SqlConnection
            Dim StrSql as string
            Dim myCommand As SqlCommand
            Dim drGetFieldVal As SqlDataReader

            if trim(ucase(txtSearch.text)) = "TEMPM" then
                cmbModelNo.items.clear
                Dim oList As ListItemCollection = cmbModelNo.Items
                oList.Add(New ListItem(ReqCOM.GetTempModelNo))
                txtModelDesc.text = ""
                txtSearchCustCode.text = ""
                txtCustName.text = ""
                cmbSearchCustCode.items.clear
                Dissql("Select Curr_Code,Curr_Desc from Curr","Curr_Code","Curr_Desc",cmbCurrCode)
                txtModelDesc.enabled = true
            else
                Dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where model_code in (select model_no from bom_m where model_no like '%" & trim(txtSearch.text) & "%') order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelNo)

                if cmbModelNo.selectedindex = 0 then
                    cnnGetFieldVal = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
                    StrSql = "Select mm.bom_quote_rev + 1 as [bom_quote_rev],mm.model_code,mm.model_desc,mm.cust_code,cust.cust_name,Cust.Curr_Code from Model_Master MM,Cust where mm.cust_code = cust.cust_code and mm.model_code = '" & trim(cmbModelNo.selecteditem.value) & "';"
                    cnnGetFieldVal.Open()
                    myCommand = New SqlCommand(StrSql, cnnGetFieldVal )
                    drGetFieldVal = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
                    txtModelDesc.enabled = false
                    do while drGetFieldVal.read
                        Dissql("Select Cust_Code from Cust where Cust_Code = '" & trim(drGetFieldVal("Cust_Code")) & "';","Cust_Code","Cust_Code",cmbSearchCustCode)
                        Dissql("Select Curr_Code,Curr_Desc from Curr where Curr_Code = '" & trim(drGetFieldVal("Curr_Code")) & "';","Curr_Code","Curr_Desc",cmbCurrCode)
                        txtCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Cust_code = '" & trim(drGetFieldVal("Cust_Code")) & "';","Cust_Name")
                        txtModelDesc.text = drGetFieldVal("Model_Desc")
                        lblBOMQuoteRev.text = drGetFieldVal("bom_quote_rev")
                    loop
                    myCommand.dispose()
                    drGetFieldVal.close()
                    cnnGetFieldVal.Close()
                    cnnGetFieldVal.Dispose()
                Else
                    txtModelDesc.text = ""
                    lblBOMQuoteRev.text = "0"
                    txtSearch.text = "--Search--"
                    cmbModelNo.items.clear
                    ShowAlert("Invalid Model No.")
                End if
            end if
         End Sub

    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

    Sub cmdSearchCustCode_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

        if trim(ucase(txtSearchCustCode.text)) = "TEMPC" then
            cmbSearchCustCode.items.clear
            Dim oList As ListItemCollection = cmbSearchCustCode.Items
            oList.Add(New ListItem(ReqCOM.GetTempCustNo))
        elseif trim(ucase(txtSearchCustCode.text)) <> "TEMPC" then
            Dissql ("Select Cust_Code from Cust where Cust_Code+Cust_Name like '%" & trim(txtSearchCustCode.text) & "%';","Cust_Code","Cust_Code",cmbSearchCustCode)

            if cmbSearchCustCode.selectedindex <> -1 then
                txtCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(cmbSearchCustCode.selecteditem.value) & "';","Cust_Name")
                txtSearchCustCode.text = "--Search--"
            Elseif cmbSearchCustCode.selectedindex = -1 then
                txtSearch.text = "--Search--"
                cmbSearchCustCode.items.clear
                ShowAlert("You don't seem to have supplied a valid Customer No.\n\n Select 'TempC' for temporary Model Customer No.")
            end if
        end if
    End Sub

    Sub cmbModelNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if cmbModelNo.selectedindex <> -1 then txtModelDesc.text = ReqCOM.GetFieldVal("select Model_Desc from Model_Master where model_code = '" & trim(cmbModelNo.selecteditem.value) & "';","Model_Desc")
    End Sub

    Sub cmbSearchCustCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if cmbSearchCustCode.selectedindex <> -1 then txtCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(cmbSearchCustCode.selecteditem.value) & "';","Cust_Name")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">BOM
                                QUOTATION DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Model # (TempM for temp.
                                                                    model)</asp:Label></td>
                                                                <td width="70%" colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearch)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                        <asp:DropDownList id="cmbModelNo" runat="server" CssClass="OutputText" Width="296px" autopostback="true" OnSelectedIndexChanged="cmbModelNo_SelectedIndexChanged"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="100%">Model Description</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:TextBox id="txtModelDesc" runat="server" CssClass="OutputText" Width="406px"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">Customer
                                                                    # (TempC for temp. cust)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearchCustCode" onkeydown="KeyDownHandler(cmdSearchCustCode)" onclick="GetFocus(txtSearchCustCode)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdSearchCustCode" onclick="cmdSearchCustCode_Click" runat="server" CssClass="OutputText" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                    <asp:DropDownList id="cmbSearchCustCode" runat="server" CssClass="OutputText" Width="296px" autopostback="true" OnSelectedIndexChanged="cmbSearchCustCode_SelectedIndexChanged"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Customer
                                                                    Name</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtCustName" runat="server" CssClass="OutputText" Width="406px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Currency</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbCurrCode" runat="server" CssClass="OutputText" Width="125px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">Revision</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBOMQuoteRev" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <p>
                                                                        <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="101px" Text="Save"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back"></asp:Button>
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
        <p>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
