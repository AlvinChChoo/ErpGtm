<%@ Page Language="VB" Debug="true" %>
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
             if page.ispostback = false then loaddata()
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
    
         Sub LoadData()
             Dim strSql as string = "Select * from BOM_QUOTE_M where SEQ_NO = " & request.params("ID") & ";"
             Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
             Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
             Dim OriCurrCode as string
    
             do while ResExeDataReader.read
                   Dissql ("Select CURR_CODE, CURR_DESC as [DESC] from BOM_QUOTE_CURR where BOM_QUOTE_NO = '" & trim(ResExeDataReader("BOM_QUOTE_NO").tostring) & "' ORDER BY CURR_CODE asc","CURR_CODE","DESC",cmbOriCurr)
    
                   lblQuoteNo.text = trim(ResExeDataReader("BOM_QUOTE_NO").tostring)
                   txtOriUP.text = trim(ResExeDataReader("FOB_ORI_AMT").tostring)
                   txtRMAmt.text = trim(ResExeDataReader("FOB_RM_AMT").tostring)
                   txtTargetRMAmt.text = trim(ResExeDataReader("TARGET_COST").tostring)
    
                   OriCurrCode = ReqExeDataReader.GetFieldVal("Select CURR_CODE AS [DESC] from BOM_QUOTE_CURR where BOM_QUOTE_NO = '" & trim(ResExeDataReader("BOM_QUOTE_NO").tostring) & "' AND CURR_CODE = '" & trim(ResExeDataReader("FOB_ORI_CURR").tostring) & "';","DESC").tostring
                   If Not (cmbOriCurr.Items.FindByValue(OriCurrCode.tostring)) Is Nothing Then cmbOriCurr.Items.FindByValue(trim(OriCurrCode.tostring)).Selected = True
    
                   if isdbnull(ResExeDataReader("FOB_ORI_AMT")) = false then txtOriUP.text = format(cdec(ResExeDataReader("FOB_ORI_AMT")),"##,##0.00000")
                   if isdbnull(ResExeDataReader("FOB_RM_AMT")) = false then txtRMAmt.text = format(cdec(ResExeDataReader("FOB_RM_AMT")),"##,##0.00000")
                   if isdbnull(ResExeDataReader("TARGET_COST")) = false then txtTargetRMAmt.text = format(cdec(ResExeDataReader("TARGET_COST")),"##,##0.00000")
                   if isdbnull(ResExeDataReader("FOB_RM_AMT")) = false and isdbnull(ResExeDataReader("TARGET_COST")) = false then
                        if trim(txtTargetRMAmt.text) <> "0.00000" and trim(txtRMAmt.text) <> "0.00000" then txtBomOverSales.text = format(((cdec(txtTargetRMAmt.text) /  cdec(txtRMAmt.text)) * 100),"##,##0.00") & " %"
                   end if
    
                    if isdbnull(ResExeDataReader("FOB_UPD_DATE")) = false then
                        txtFOBUpdBy.text= trim(ResExeDataReader("FOB_UPD_BY").tostring)
                        txtFOBUpdDate.text= format(cdate(ResExeDataReader("FOB_UPD_DATE")),"dd/MM/yyyy")
                        txtFOBRem.text = trim(ResExeDataReader("FOB_REM").tostring)
                    else
                        txtFOBRem.text = ""
                    end if
             loop
          End sub
    
          Sub cmbUpdate_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                 Dim strsql as string
                 Dim ReqCOM as erp_gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
                 CalculateLocalRate
    
                 strsql = "Update BOM_QUOTE_M set "
                 strsql = strsql + "FOB_ORI_CURR = '" & trim(cmbOriCurr.selectedItem.value) & "',"
                 strsql = strsql + "FOB_UPD_BY = '" & trim(request.cookies("U_ID").value) & "',"
                 strsql = strsql + "FOB_UPD_DATE = '" & now & "',"
                 strsql = strsql + "FOB_REM = '" & txtFOBRem.text & "',"
                 strsql = strsql + "FOB_ORI_AMT = " & txtOriUP.text & ","
                 strsql = strsql + "FOB_RM_AMT = " & txtRMAmt.text & " "
    
                 strsql = strsql + "where BOM_QUOTE_NO = '" & trim(lblQuoteNo.text) & "'"
                 Dim ReqExecutenonQuery as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm
                 reqExecuteNonQuery.ExecuteNonQuery(strsql)
    
                 LoadData
                 ShowAlert("Selling Price Quoted details saved successfully.")
                 redirectPage()
             end if
         End Sub
    
    Sub cmdCalculate_Click(sender As Object, e As EventArgs)
        if cmbOriCurr.selecteditem.value = "" then exit sub
        if txtOriUP.text = "" then exit sub
        CalculateLocalRate
    end sub
    
    Sub CalculateLocalRate
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Rate as decimal = ReqCOm.GetFieldVal("Select Rate from bom_quote_curr where curr_code = '" & trim(cmbOriCurr.selecteditem.value) & "' and bom_quote_no = '" & trim(lblQuoteNo.text) & "';","Rate")
        Dim UnitConv as decimal = ReqCOm.GetFieldVal("Select unit_conv from bom_quote_curr where curr_code = '" & trim(cmbOriCurr.selecteditem.value) & "' and bom_quote_no = '" & trim(lblQuoteNo.text) & "';","unit_conv")
    
        txtRMAmt.text = format(cdec((cdec(txtOriUP.text) * Rate) / UnitConv),"##,##0.00000")
        txtBomOverSales.text = format(((cdec(txtTargetRMAmt.text) /  cdec(txtRMAmt.text)) * 100),"##,##0.00") & " %"
    End Sub
    
    
         Sub redirectPage
             Dim strScript as string
             Dim ReturnURL as string
             ReturnURL= "PopupBOMQuoteSellingPriceDet.aspx?ID=" & Request.params("ID")
             strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
             If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
         End sub
    
         Sub ShowAlert(Msg as string)
             Dim strScript as string
             strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
             If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
         End sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             response.redirect("BomQuoteSellingPrice.aspx")
         End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" cssclass="FormDesc">Enter
                                Selling Price Quoted</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="cmbOriCurr" ErrorMessage="You don't seem to have supplied a valid Currency" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtOriUP" ErrorMessage="CompareValidator" Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0.00000">You don't seem to have supplied a valid Original Selling Price Amount</asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtRMAmt" ErrorMessage="CompareValidator" Width="100%" CssClass="ErrorText" Type="Double" Operator="GreaterThan" ValueToCompare="0.00000">You don't seem to have supplied a valid Local Currency Amount</asp:CompareValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="74px" cssclass="LabelNormal">Quotation
                                                                No</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left"><asp:Label id="lblQuoteNo" runat="server" width="393px" cssclass="OutputText" align="left"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" width="74px" cssclass="LabelNormal">Currency </asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:DropDownList id="cmbOriCurr" runat="server" Width="256px" CssClass="OutputText"></asp:DropDownList>
                                                                    &nbsp;<asp:Button id="cmdCalculate" onclick="cmdCalculate_Click" runat="server" CssClass="OutputText" Text="Calculate" CausesValidation="False"></asp:Button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label10" runat="server" width="74px" cssclass="LabelNormal">Selling
                                                                    Price (In Original Currency)</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtOriUP" runat="server" Width="280px" CssClass="OutputText"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label14" runat="server" width="74px" cssclass="LabelNormal">Updated
                                                                    By / Date</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtFOBUpdBy" runat="server" Width="280px" CssClass="OutputText" Enabled="False"></asp:TextBox>
                                                                    <asp:TextBox id="txtFOBUpdDate" runat="server" Width="280px" CssClass="OutputText" Enabled="False"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label15" runat="server" width="74px" cssclass="LabelNormal">Remark </asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtFOBRem" runat="server" Width="500px" CssClass="OutputText"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label11" runat="server" width="74px" cssclass="LabelNormal" visible="False">Selling
                                                                    Price (RM)</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtRMAmt" runat="server" Width="280px" CssClass="OutputText" Enabled="False" Visible="False"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label12" runat="server" width="74px" cssclass="LabelNormal" visible="False">Target
                                                                    Cost (RM)</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtTargetRMAmt" runat="server" Width="280px" CssClass="OutputText" Enabled="False" Visible="False"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label13" runat="server" width="74px" cssclass="LabelNormal" visible="False">BOM
                                                                    / Sales %</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtBomOverSales" runat="server" Width="280px" CssClass="OutputText" Enabled="False" Visible="False"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Save"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="174px" Text="Back" CausesValidation="False"></asp:Button>
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
