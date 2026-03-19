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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update FECN_M set REGENERATE = 'N' where REGENERATE is null")
            ProcLoadGridData()
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
    
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim StartDate,EndDate as date
    
        ReqCOM.ExecuteNonQuery("Update FECN_M set Sort_Seq = 2")
        ReqCOM.ExecuteNonQuery("Update FECN_M set Sort_Seq = 1 where FECN_Status = 'PENDING SUBMISSION'")
        ReqCOM.ExecuteNonQuery("Update FECN_M set Sort_Seq = 1 where FECN_Status = 'REJECTED' and regenerate is null")
    
        ReqCom.ExecuteNonQuery("update part_master set launch = 'N';")
        ReqCom.ExecuteNonQuery("update part_master set launch = 'Y' where std_cost_rd = 0 and part_no in (select MAIN_PART_B4 from fecn_d where fecn_no in (select fecn_no from fecn_m where fecn_status = 'PENDING APPROVAL')) ;")
        ReqCom.ExecuteNonQuery("update part_master set launch = 'Y' where std_cost_rd = 0 and part_no in (select MAIN_PART from fecn_d where fecn_no in (select fecn_no from fecn_m where fecn_status = 'PENDING APPROVAL')) ;")
    
        if trim(cmbSearch.selecteditem.value) = "FECN_No" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "ECN_No" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "CUST_ECN_NO" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "MODEL_NO" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "PART_NO" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where main_part_b4 like '%" & trim(txtSearch.text) & "%' or main_part like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where main_part_b4 like '%" & trim(txtSearch.text) & "%' or main_part like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "LOT_NO" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where lot_no like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where lot_no like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "APP6_Date" then
            if ReqCOM.IsDate(trim(txtSearch.text)) = true then
                StartDate = ReqCOM.FormatDate(txtSearch.text) & " 00:00:00.000"
                EndDate = ReqCOM.FormatDate(txtSearch.text) & " 23:59:59.000"
    
                if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where App6_Date >= '" & StartDate & "' and App6_Date <= '" & EndDate & "') ORDER BY Sort_Seq,FEcn_No DESC"
                if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where App6_Date >= '" & StartDate & "' and App6_Date <= '" & EndDate & "') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
            else
                StrSql = "SELECT * FROM FECN_M where fecn_no in (Select Fecn_No from fecn_d where App6_Date = '12/31/2999') ORDER BY Sort_Seq,FEcn_No DESC"
            end if
        end if
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"FECN_M")
        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))
    
        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("FECNAddNew.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim App3By As Label = CType(e.Item.FindControl("App3By"), Label)
            Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
            Dim App4By As Label = CType(e.Item.FindControl("App4By"), Label)
            Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
            Dim App5By As Label = CType(e.Item.FindControl("App5By"), Label)
            Dim App5Date As Label = CType(e.Item.FindControl("App5Date"), Label)
            Dim App6By As Label = CType(e.Item.FindControl("App6By"), Label)
            Dim App6Date As Label = CType(e.Item.FindControl("App6Date"), Label)
            Dim PreparedBy As Label = CType(e.Item.FindControl("PreparedBy"), Label)
            Dim PreparedDate As Label = CType(e.Item.FindControl("PreparedDate"), Label)
    
            Dim ModelNo As Label = CType(e.Item.FindControl("ModelNo"), Label)
            Dim FECNNo As Label = CType(e.Item.FindControl("FECNNo"), Label)
            Dim Rev as decimal
            Dim SubmitBy As Label = CType(e.Item.FindControl("SubmitBy"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            Dim NewFECNNo As Label = CType(e.Item.FindControl("NewFECNNo"), Label)
            Dim Regenerate As Label = CType(e.Item.FindControl("Regenerate"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
    
            if Trim(SubmitDate.text) <> "" then SubmitBy.text = SubmitBy.text & "-" & format(cdate(SubmitDate.text),"dd/MM/yy")
            if Trim(App1Date.text) <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
            if Trim(App2Date.text) <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
            if Trim(App3Date.text) <> "" then App3By.text = App3By.text & "-" & format(cdate(App3Date.text),"dd/MM/yy")
            if Trim(App4Date.text) <> "" then App4By.text = App4By.text & "-" & format(cdate(App4Date.text),"dd/MM/yy")
            if Trim(App5Date.text) <> "" then App5By.text = App5By.text & "-" & format(cdate(App5Date.text),"dd/MM/yy")
            if Trim(App6Date.text) <> "" then App6By.text = App6By.text & "-" & format(cdate(App6Date.text),"dd/MM/yy")
            if Trim(PreparedDate.text) <> "" then PreparedBy.text = PreparedBy.text & "-" & format(cdate(PreparedDate.text),"dd/MM/yy")
    
            if trim(Status.text) = "PENDING SUBMISSION" then e.Item.CssClass = "PartSource"
            if trim(ucase(Status.text)) = "REJECTED" and trim(regenerate.text) = "" then e.Item.CssClass = "PartSource"
    
            if trim(Status.text) = "PENDING SUBMISSION" and trim(Urgent.text) = "Y" then e.Item.CssClass = "Urgent"
            if trim(ucase(Status.text)) = "REJECTED" and trim(regenerate.text) = "" and trim(Urgent.text) = "Y" then e.Item.CssClass = "Urgent"
    
            if trim(ModelNo.text) <> "COMMON" then
                Rev = ReqCOM.GetFieldVal("select top 1 Revision as [Revision] from BOM_M where model_no = '" & trim(ModelNo.text) & "' order by revision desc","Revision")
                if ReqCOm.FuncCheckDuplicate("Select Part_No from Part_Master where std_cost_rd = 0 and part_no in (Select Part_No from BOM_D where Model_No = '" & trim(ModelNo.text) & "' and revision = " & Rev & ")","Part_No") = true then
                    if trim(Status.text) <> "REJECTED" then e.Item.CssClass = "WithoutStdCost"
                end if
    
                if ReqCOm.FuncCheckDuplicate("Select Part_No from Part_Master where std_cost_rd = 0 and part_no in (Select Main_Part_B4 from FECN_D where FECN_No = '" & trim(FECNNo.text) & "')","Part_No") = true then
                    if trim(Status.text) <> "REJECTED" then e.Item.CssClass = "WithoutStdCost"
                end if
    
                if ReqCOm.FuncCheckDuplicate("Select Part_No from Part_Master where std_cost_rd = 0 and part_no in (Select Main_Part from FECN_D where FECN_No = '" & trim(FECNNo.text) & "')","Part_No") = true then
                    if trim(Status.text) <> "REJECTED" then e.Item.CssClass = "WithoutStdCost"
                end if
            End if
        End if
    End Sub
    
    
    
    
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        gridControl1.currentpageindex = 0
        ProcLoadGridData
    End Sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ModelNo as string
        Dim Revision as decimal
    
        Try
            ModelNo = ReqCOM.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & clng(SeqNo.text) & ";","Model_No")
            if trim(ModelNo) = "COMMON" and trim(ucase(e.commandArgument)) = "COST" then exit sub
            Revision = ReqCOM.GetFieldVal("Select top 1 Revision as [Revision] from BOM_M where model_no = '" & trim(ModelNo) & "' order by revision desc;","Revision")
        Catch
        Finally
            if trim(ucase(e.commandArgument)) = "COST" then
                ShowReport("PopupReportViewer.aspx?RptName=FECNPartWithoutStdCost&ModelNo=" & trim(ModelNo) & "&Revision=" & cdec(Revision))
            Elseif trim(ucase(e.commandArgument)) = "VIEW" then
                Response.redirect("FECNDet.aspx?ID=" & clng(SeqNo.text))
            end if
        end try
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <script>
<!--

//2-level combo box script- by javascriptkit.com
//Visit JavaScript Kit (http://javascriptkit.com) for script
//Credit must stay intact for use

//STEP 1 of 2: DEFINE the main category links below
//EXTEND array as needed following the laid out structure
//BE sure to preserve the first line, as it's used to display main title

var category=new Array()
category[0]=new Option("SELECT A CATEGORY ", "") //THIS LINE RESERVED TO CONTAIN COMBO TITLE
category[1]=new Option("DevAsp Home", "combo1")
category[2]=new Option("Mail Groups", "combo2")
category[3]=new Option("Entertainment", "combo3")

//STEP 2 of 2: DEFINE the sub category links below
//EXTEND array as needed following the laid out structure
//BE sure to preserve the LAST line, as it's used to display submain title

var combo1=new Array()
combo1[0]=new Option("DevAsp Home","http://DevAsp.net")
combo1[1]=new Option("DevAsp Articles","http://www.devasp.net/net/articles/")
combo1[2]=new Option("DevAsp Classic","http://www.DevAsp.com")
combo1[3]=new Option("google","http://www.google.com.pk")
combo1[4]=new Option("Orkut","http://www.orkut.com")
combo1[5]=new Option("BACK TO CATEGORIES","")   //THIS LINE RESERVED TO CONTAIN COMBO SUBTITLE

var combo2=new Array()
combo2[0]=new Option("Yahoo","http://www.yahoo.com")
combo2[1]=new Option("MSN","http://www.msnc.com")
combo2[2]=new Option("Gmail","http://www.gmail.com")
combo2[3]=new Option("ABC News","http://www.abcnews.com")
combo2[4]=new Option("BACK TO CATEGORIES","")   //THIS LINE RESERVED TO CONTAIN COMBO SUBTITLE

var combo3=new Array()
combo3[0]=new Option("Hollywood.com","http://www.hollywood.com")
combo3[1]=new Option("MTV","http://www.mtv.com")
combo3[2]=new Option("ETOnline","http://etonline.com")
combo3[3]=new Option("BACK TO CATEGORIES","")   //THIS LINE RESERVED TO CONTAIN COMBO SUBTITLE

var curlevel=1
var cacheobj=document.dynamiccombo.stage2

function populate(x){
for (m=cacheobj.options.length-1;m>0;m--)
cacheobj.options[m]=null
selectedarray=eval(x)
for (i=0;i<selectedarray.length;i++)
cacheobj.options[i]=new Option(selectedarray[i].text,selectedarray[i].value)
cacheobj.options[0].selected=true

}

function displaysub(){
if (curlevel==1){
populate(cacheobj.options[cacheobj.selectedIndex].value)
curlevel=2
}
else
gothere()
}


function gothere(){
if (curlevel==2){
if (cacheobj.selectedIndex==cacheobj.options.length-1){
curlevel=1
populate(category)
}
else
location=cacheobj.options[cacheobj.selectedIndex].value
}
}

//SHOW categories by default
populate(category)

//-->
</script>
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">FECN
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 7px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>
                                                    <asp:TextBox id="txtSearch" runat="server" Width="112px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText">
                                                        <asp:ListItem Value="FECN_No">FECN NO</asp:ListItem>
                                                        <asp:ListItem Value="ECN_No">ECN NO</asp:ListItem>
                                                        <asp:ListItem Value="MODEL_NO">MODEL NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="LOT_NO">LOT NO</asp:ListItem>
                                                        <asp:ListItem Value="CUST_ECN_NO">CUST. ECN NO</asp:ListItem>
                                                        <asp:ListItem Value="APP6_Date">APPROVAL DATE (dd/mm/yy)</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>&nbsp;<asp:DropDownList id="cmbFECNStatus" runat="server" Width="172px" CssClass="OutputText">
                                                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label5" runat="server" cssclass="OutputText">FECN</asp:Label>&nbsp; 
                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Width="90px" CssClass="OutputText" Text="GO"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 27px" width="94%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" BorderColor="Gray" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnItemCommand="ShowDet">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <PagerStyle mode="NumericPages" nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle cssclass="GridHeaderSmall" bordercolor="White"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton id="View" CausesValidation="False" CommandArgument='VIEW' runat="server" Font-Size="X-Small" >View</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton id="Cost" CausesValidation="False" CommandArgument='COST' runat="server" Font-Size="X-Small" >Std Cost.</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="FECN No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="FECNNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Model No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="ECN_NO" HeaderText="ECN No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="PREPARED">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PreparedBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prepared_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="SUBMIT">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_BY") %>' /> <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Elec. Eng.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mech. Eng.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="R&amp;D HOD">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PCMC App.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="A/C App.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mgt. App.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App6By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App6_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App6Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App6_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PreparedDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prepared_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="New Ref.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewFECNNo" width="" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_FECN_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Regenerate" width="" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Regenerate") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" cssclass="OutputText" width="100%">Urgent
                                                                    FECN Pending Submission</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label7" runat="server" cssclass="OutputText" width="100%">Normal
                                                                    FECN Pending Submission</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="173px" Text="Register new FECN"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <p align="center">
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" Text="Back"></asp:Button>
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
        <!-- Insert content here -->
        <asp:DropDownList id="DropDownList1" runat="server" onchange="displaysub()">
            <asp:ListItem Value="#">This is a place Holder text</asp:ListItem>
            <asp:ListItem Value="#">This is a place Holder text</asp:ListItem>
            <asp:ListItem Value="#">This is a place Holder text</asp:ListItem>
            <asp:ListItem Value="#">This is a place Holder text</asp:ListItem>
        </asp:DropDownList>
    </form>
</body>
</html>
