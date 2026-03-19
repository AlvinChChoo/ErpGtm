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
            Dim QtyDel as decimal
            Dim CurrDate as date = format(now,"dd/MMM/yyyy")
    
            lblJOASNo.text = ReqCom.getFieldVal("Select JOAS_No from joas_m where Seq_No = " & request.params("ID") & ";","JOAS_No")
            dissql ("Select JO_No + '---' + pd_level as [desc], seq_no from job_order_d where release = 'N' and start_date is not null and end_date is not null ORDER BY SEQ_NO ASC;","seq_no","desc",cmbJobOrder)
            ShowItem()
    
            If cmbJobOrder.selectedindex = 0 then
                lblStartDate.text = format(cdate(ReqCOM.GetFieldVal("Select Start_Date from job_order_d where Seq_No = " & cmbJobOrder.selecteditem.value & ";","Start_Date")),"dd/MM/yy")
                lblEndDate.text = format(cdate(ReqCOM.GetFieldVal("Select End_Date from job_order_d where Seq_No = " & cmbJobOrder.selecteditem.value & ";","End_Date")),"dd/MM/yy")
            end if
    
        end if
    End Sub
    
    Sub ShowItem()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        'Dim StrSql as string = "Select MIF.IN_QTY,MIF.Del_Date,MIF.Seq_No,MIF.po_no, PM.Part_No,PM.Part_Desc from mif_D MIF, Part_Master PM where MIF.Part_No = PM.Part_No AND MIF_NO = '" & TRIM(lblMIFNo.text) & "' order by mif.seq_no asc"
        Dim StrSql as string = "Select JD.PROD_LEVEL,JD.JO_NO,JD.SEQ_NO,JO.START_DATE,JO.END_DATE from JOAS_D JD,JOB_ORDER_D JO where JD.JOAs_No = '" & TRIM(lblJOASNo.text) & "' AND JD.JO_NO = JO.JO_NO AND JD.PROD_LEVEL = JO.PD_LEVEL order by JD.seq_no asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"JOAS_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("JOAS_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    '        E.Item.Cells(4).Text = format(cdate(e.Item.Cells(4).Text),"MM/dd/yy")
            Dim StartDate As Label = CType(e.Item.FindControl("StartDate"), Label)
            Dim EndDate As Label = CType(e.Item.FindControl("EndDate"), Label)
    
            StartDate.text = format(cdate(StartDate.text),"dd/MM/yy")
            EndDate.text = format(cdate(EndDate.text),"dd/MM/yy")
    
    '        InQty.text = cint(InQty.text)
        End if
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    '    LoadPartDel
    End Sub
    
    Sub LoadPartDel()
    
    End sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Insert into JOAS_D(JOAS_NO,JO_NO,PROD_LEVEL) select '" & trim(lblJOASNo.text) & "',JO_NO,pd_level from Job_Order_D where seq_no = " & cmbJobOrder.selecteditem.value & ";")
    
    
        response.redirect("PopupJobOrderItem.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i As Integer
        Dim strSql as string
        Dim InputError as string = "N"
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Dim remove As CheckBox = CType(dtgPartWithSource.Items(i).FindControl("Remove"), CheckBox)
            Dim lblSeqNo As Label = CType(dtgPartWithSource.Items(i).FindControl("lblSeqNo"), Label)
    
            If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from JOAS_D where SEQ_NO = " & lblSeqNo.text & ";")
        Next
    
    
        redirectPage("PopupJobOrderItem.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmbJobOrder_SelectedIndexChanged(sender As Object, e As EventArgs)
        DIM rEQcom AS erp_gtm.erp_gtm = NEW erp_gtm.erp_gtm
    
        lblStartDate.text = format(cdate(ReqCOM.GetFieldVal("Select Start_Date from job_order_d where Seq_No = " & cmbJobOrder.selecteditem.value & ";","Start_Date")),"dd/MM/yy")
        lblEndDate.text = format(cdate(ReqCOM.GetFieldVal("Select End_Date from job_order_d where Seq_No = " & cmbJobOrder.selecteditem.value & ";","End_Date")),"dd/MM/yy")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">JOB ORDER ITEM</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="118px" cssclass="LabelNormal">JOAS No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblJOASNo" runat="server" width="118px" cssclass="LabelNormal"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="100%" cssclass="LabelNormal">Job Order
                                                                    No/Production</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:DropDownList id="cmbJobOrder" runat="server" autopostback="true" OnSelectedIndexChanged="cmbJobOrder_SelectedIndexChanged" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="138px" cssclass="LabelNormal">Start Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStartDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="138px" cssclass="LabelNormal">End Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblEndDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="174px" Text="Add to list"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" Width="100%" OnItemDataBound="FormatRow" AllowSorting="True" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="JO #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Prod">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ProdLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Level") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Start Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="StartDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Start_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="End Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="EndDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "End_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remove">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="Remove" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="148px" Text="Remove Selected Item" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="95px" Text="Exit" CausesValidation="False"></asp:Button>
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
