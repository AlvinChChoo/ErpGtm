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
        if page.isPostBack = false then
            LoadAltPart
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim StrSql as string
            Dim i as integer
            Dim PartNo As Label
            Dim Remove as checkbox
    
            StrSql = "Delete from FECN_ALT_VAR where U_ID = '" & trim(request.cookies("U_ID").value) & "'"
    
            For i = 0 To dtgAltAfter.Items.Count - 1
                Remove = CType(dtgAltAfter.Items(i).FindControl("Remove"), Checkbox)
                if Remove.checked = false then
                    PartNo = CType(dtgAltAfter.Items(i).FindControl("PartNo"), Label)
                    StrSql = StrSql & ";Insert into FECN_ALT_Var(U_ID,Part_No) select '" & trim(request.cookies("U_ID").value) & "','" & trim(PartNo.text) & "' "
                End if
            next i
    
            if trim(StrSql) <> "" then ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("PopupFECNAddAlt.aspx")
        end if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from Part_Master where part_no = '" & trim(txtSearchPart.text) & "';","Part_No")
    
        if ReqCOM.funcCheckDuplicate("select Part_No from FECN_ALT_VAR where part_no = '" & trim(txtSearchPart.text) & "';","Part_No") = true then
            ShowAlert("Alternate Part already exist.")
            Exit sub
        end if
    
        if trim(PartNo) <> "<NULL>" then
            ReqCOM.ExecuteNonQuery("Insert into FECN_ALT_VAR(Part_No,U_ID) Select '" & trim(PartNo) & "','" & trim(request.cookies("U_ID").value) & "';")
            Response.redirect("PopupFECNAddAlt.aspx")
        elseif trim(PartNo) = "<NULL>" then
            ShowAlert("Invalid Part No.")
        End if
    
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub LoadAltPart()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "Select Part_No, Part_Desc, Part_Spec from Part_master where part_no in (Select Part_No from fecn_alt_var where u_id = '" & trim(request.cookies("U_ID").value) & "') order by seq_no desc"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        dtgAltAfter.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        dtgAltAfter.DataBind()
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <div align="center"><asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">ALTERNATE
                                                        PART</asp:Label>
                                                    </div>
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="20%" bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                                    <td width="80%">
                                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="178px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Width="40px" CausesValidation="False" Text="GO" Height="20px"></asp:Button>
                                                                                        &nbsp; 
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgAltAfter" runat="server" width="100%" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Part No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Specification">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remove">
                                                                                    <ItemTemplate>
                                                                                        <asp:checkbox id="Remove" runat="server" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <p>
                                                    <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="Save" onclick="Save_Click" runat="server" Width="170px" Text="Remove Selected Parts"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="153px" CausesValidation="False" Text="Close"></asp:Button>
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
