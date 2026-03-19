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
        'cmdUpdate.attributes.add("onClick","javascript:if(confirm('Are you sure to update Buyer Code ?')==false) return false;")
        if page.ispostback = false then
            LoadData()
        end if
    End Sub
    
    Sub LoadData()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim oList As ListItemCollection
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select Purchasing_HOD from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select Purchasing_HOD from main)","U_ID","U_ID",cmb1)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select ME_HOD from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select ME_HOD from main)","U_ID","U_ID",cmb2)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select RD_HOD from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select RD_HOD from main)","U_ID","U_ID",cmb3)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select PCMC_HOD from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select PCMC_HOD from main)","U_ID","U_ID",cmb4)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select QA_HOD from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select QA_HOD from main)","U_ID","U_ID",cmb5)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select PD1_HOD from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select PD1_HOD from main)","U_ID","U_ID",cmb6)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select pd2_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select pd2_hod from main)","U_ID","U_ID",cmb7)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select pd3_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select pd3_hod from main)","U_ID","U_ID",cmb8)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select fg_store_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select fg_store_hod from main)","U_ID","U_ID",cmb10)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select elect_store_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select elect_store_hod from main)","U_ID","U_ID",cmb11)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select mech_store_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select mech_store_hod from main)","U_ID","U_ID",cmb12)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select it_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select it_hod from main)","U_ID","U_ID",cmb13)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select ac_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select ac_hod from main)","U_ID","U_ID",cmb14)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select costing_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select costing_hod from main)","U_ID","U_ID",cmb15)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select doc_con_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select doc_con_hod from main)","U_ID","U_ID",cmb16)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select iqc_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select iqc_hod from main)","U_ID","U_ID",cmb17)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select hr_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select hr_hod from main)","U_ID","U_ID",cmb18)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select mgt_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select mgt_hod from main)","U_ID","U_ID",cmb19)
        end if
    
        if ReqCOm.FuncCheckDuplicate("Select top 1 U_ID from User_Profile where U_ID in (Select fg_store_hod from main)","U_ID") = true then
            Dissql("Select top 1 U_ID from User_Profile where U_ID in (Select fg_store_hod from main)","U_ID","U_ID",cmb10)
        end if
    End sub
    
    SUb Dissql(ByVal strSql As String,FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FText
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    
        Dim oList As ListItemCollection = obj.Items
        oList.Add(New ListItem(""))
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            Strsql = "Update Main set "
            if cmb1.selectedindex <> -1 then StrSql = StrSql & "Purchasing_HOD = '" & trim(cmb1.selecteditem.value) & "',"
            if cmb2.selectedindex <> -1 then StrSql = StrSql & "ME_HOD = '" & trim(cmb2.selecteditem.value) & "',"
            if cmb3.selectedindex <> -1 then StrSql = StrSql & "RD_HOD = '" & trim(cmb3.selecteditem.value) & "',"
            if cmb4.selectedindex <> -1 then StrSql = StrSql & "PCMC_HOD = '" & trim(cmb4.selecteditem.value) & "',"
            if cmb5.selectedindex <> -1 then StrSql = StrSql & "QA_HOD = '" & trim(cmb5.selecteditem.value) & "',"
            if cmb6.selectedindex <> -1 then StrSql = StrSql & "PD1_HOD = '" & trim(cmb6.selecteditem.value) & "',"
            if cmb7.selectedindex <> -1 then StrSql = StrSql & "pd2_hod = '" & trim(cmb7.selecteditem.value) & "',"
            if cmb8.selectedindex <> -1 then StrSql = StrSql & "pd3_hod = '" & trim(cmb8.selecteditem.value) & "',"
            if cmb10.selectedindex <> -1 then StrSql = StrSql & "fg_store_hod = '" & trim(cmb10.selecteditem.value) & "',"
            if cmb11.selectedindex <> -1 then StrSql = StrSql & "elect_store_hod = '" & trim(cmb11.selecteditem.value) & "',"
            if cmb12.selectedindex <> -1 then StrSql = StrSql & "mech_store_hod = '" & trim(cmb12.selecteditem.value) & "',"
            if cmb13.selectedindex <> -1 then StrSql = StrSql & "it_hod = '" & trim(cmb13.selecteditem.value) & "',"
            if cmb14.selectedindex <> -1 then StrSql = StrSql & "ac_hod = '" & trim(cmb14.selecteditem.value) & "',"
            if cmb15.selectedindex <> -1 then StrSql = StrSql & "costing_hod = '" & trim(cmb15.selecteditem.value) & "',"
            if cmb16.selectedindex <> -1 then StrSql = StrSql & "doc_con_hod = '" & trim(cmb16.selecteditem.value) & "',"
            if cmb17.selectedindex <> -1 then StrSql = StrSql & "iqc_hod = '" & trim(cmb17.selecteditem.value) & "',"
            if cmb18.selectedindex <> -1 then StrSql = StrSql & "hr_hod = '" & trim(cmb18.selecteditem.value) & "',"
            if cmb19.selectedindex <> -1 then StrSql = StrSql & "mgt_hod = '" & trim(cmb19.selecteditem.value) & "'"
    
            ReqCOm.ExecutenonQuery(StrSql)
            Response.cookies("AlertMessage").value = "HOD Setting Updated."
            Response.redirect("AlertMessage.aspx?ReturnURL=HODSetting.aspx")
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
            .DataValueField = trim(FValue)
            .DataTextField = trim(FText)
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmd1_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt1.text) & "%';","U_ID","U_ID",cmb1)
        txt1.text = "-- Search --"
    End Sub
    
    
    Sub cmd2_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt2.text) & "%';","U_ID","U_ID",cmb2)
        txt2.text = "-- Search --"
    End Sub
    
    Sub cmd3_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt3.text) & "%';","U_ID","U_ID",cmb3)
        txt3.text = "-- Search --"
    End Sub
    
    Sub cmd4_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt4.text) & "%';","U_ID","U_ID",cmb4)
        txt4.text = "-- Search --"
    End Sub
    
    Sub cmd5_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt5.text) & "%';","U_ID","U_ID",cmb5)
        txt5.text = "-- Search --"
    End Sub
    
    Sub cmd6_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt6.text) & "%';","U_ID","U_ID",cmb6)
        txt6.text = "-- Search --"
    End Sub
    
    Sub cmd7_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt7.text) & "%';","U_ID","U_ID",cmb7)
        txt7.text = "-- Search --"
    End Sub
    
    Sub cmd8_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt8.text) & "%';","U_ID","U_ID",cmb8)
        txt8.text = "-- Search --"
    End Sub
    
    Sub cmd10_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt10.text) & "%';","U_ID","U_ID",cmb10)
        txt10.text = "-- Search --"
    End Sub
    
    Sub cmd11_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt11.text) & "%';","U_ID","U_ID",cmb11)
        txt11.text = "-- Search --"
    End Sub
    
    Sub cmd12_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt12.text) & "%';","U_ID","U_ID",cmb12)
        txt12.text = "-- Search --"
    End Sub
    
    Sub cmd13_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt13.text) & "%';","U_ID","U_ID",cmb13)
        txt13.text = "-- Search --"
    End Sub
    
    Sub cmd14_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt14.text) & "%';","U_ID","U_ID",cmb14)
        txt14.text = "-- Search --"
    End Sub
    
    Sub cmd15_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt15.text) & "%';","U_ID","U_ID",cmb15)
        txt15.text = "-- Search --"
    End Sub
    
    Sub cmd16_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt16.text) & "%';","U_ID","U_ID",cmb16)
        txt16.text = "-- Search --"
    End Sub
    
    Sub cmd17_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt17.text) & "%';","U_ID","U_ID",cmb17)
        txt17.text = "-- Search --"
    End Sub
    
    Sub cmd18_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt18.text) & "%';","U_ID","U_ID",cmb18)
        txt18.text = "-- Search --"
    End Sub
    
    Sub cmd19_Click(sender As Object, e As EventArgs)
        Dissql("Select U_ID from User_Profile where U_ID + U_name like '%" & trim(txt19.text) & "%';","U_ID","U_ID",cmb19)
        txt19.text = "-- Search --"
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">DEPARTMENT
                                HOD SETTING</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Purchasing HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb1"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid ME HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb2"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid R &amp; D HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb3"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid PCMC HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb4"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid QA HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb5"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid PD I HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb6"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid PD II HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb7"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator8" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid PD III HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb8"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid FG Store HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb10"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator11" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Electrical Store HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb11"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator12" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Mechanical Store HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb12"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator13" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid ITD HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb13"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator14" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Accounts HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb14"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator15" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Costing HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb15"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator16" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Doc. Con. HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb16"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator17" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid IQC HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb17"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator18" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid HR HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb18"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator19" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Mgt HOD" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="cmb19"></asp:RequiredFieldValidator>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="70%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 218px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="OutputText" width="126px">Puchasing</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt1" onkeydown="KeyDownHandler(cmd1)" onclick="GetFocus(txt1)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd1" onclick="cmd1_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb1" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label17" runat="server" cssclass="OutputText" width="126px">ME</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt2" onkeydown="KeyDownHandler(cmd2)" onclick="GetFocus(txt2)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd2" onclick="cmd2_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb2" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label18" runat="server" cssclass="OutputText" width="126px">R & D</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt3" onkeydown="KeyDownHandler(cmd3)" onclick="GetFocus(txt3)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd3" onclick="cmd3_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb3" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label19" runat="server" cssclass="OutputText" width="126px">PCMC</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt4" onkeydown="KeyDownHandler(cmd4)" onclick="GetFocus(txt4)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd4" onclick="cmd4_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb4" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label20" runat="server" cssclass="OutputText" width="126px">QA</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt5" onkeydown="KeyDownHandler(cmd5)" onclick="GetFocus(txt5)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd5" onclick="cmd5_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb5" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="OutputText" width="126px">PD I</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt6" onkeydown="KeyDownHandler(cmd6)" onclick="GetFocus(txt6)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd6" onclick="cmd6_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb6" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="OutputText" width="126px">PD II</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt7" onkeydown="KeyDownHandler(cmd7)" onclick="GetFocus(txt7)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd7" onclick="cmd7_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb7" onclick="cmd7_Click" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="OutputText" width="126px">PD III</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt8" onkeydown="KeyDownHandler(cmd8)" onclick="GetFocus(txt8)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd8" onclick="cmd8_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb8" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="OutputText" width="126px">FG Store</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt10" onkeydown="KeyDownHandler(cmd10)" onclick="GetFocus(txt10)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd10" onclick="cmd10_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb10" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="OutputText" width="126px">Electrical
                                                                    Store</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt11" onkeydown="KeyDownHandler(cmd11)" onclick="GetFocus(txt11)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd11" onclick="cmd11_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb11" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="OutputText" width="126px">Mechanical
                                                                    Store</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt12" onkeydown="KeyDownHandler(cmd12)" onclick="GetFocus(txt12)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd12" onclick="cmd12_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb12" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="OutputText" width="126px">ITD</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt13" onkeydown="KeyDownHandler(cmd13)" onclick="GetFocus(txt13)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd13" onclick="cmd13_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb13" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="OutputText" width="126px">Accounts</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt14" onkeydown="KeyDownHandler(cmd14)" onclick="GetFocus(txt14)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd14" onclick="cmd14_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb14" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" cssclass="OutputText" width="126px">Costing</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt15" onkeydown="KeyDownHandler(cmd15)" onclick="GetFocus(txt15)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd15" onclick="cmd15_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb15" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="OutputText" width="126px">Doc. Con.</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt16" onkeydown="KeyDownHandler(cmd16)" onclick="GetFocus(txt16)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd16" onclick="cmd16_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb16" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="OutputText" width="126px">IQC</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt17" onkeydown="KeyDownHandler(cmd17)" onclick="GetFocus(txt17)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd17" onclick="cmd17_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb17" onclick="cmd17_Click" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label15" runat="server" cssclass="OutputText" width="126px">HR</asp:Label></td>
                                                                <td colspan="3">
                                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="40%">
                                                                                    <asp:TextBox id="txt18" onkeydown="KeyDownHandler(cmd18)" onclick="GetFocus(txt18)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                    <asp:Button id="cmd18" onclick="cmd18_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                </td>
                                                                                <td width="60%">
                                                                                    <asp:DropDownList id="cmb18" onclick="cmd18_Click" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" cssclass="OutputText" width="126px">Management</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="right">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="40%">
                                                                                        <asp:TextBox id="txt19" onkeydown="KeyDownHandler(cmd19)" onclick="GetFocus(txt19)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmd19" onclick="cmd19_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="60%">
                                                                                        <asp:DropDownList id="cmb19" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </tbody>
                                                </table>
                                                <p>
                                                </p>
                                                <table style="HEIGHT: 18px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="101px" Text="Update"></asp:Button>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="101px" Text="Back"></asp:Button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
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
