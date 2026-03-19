<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        cmdUpdate.attributes.add("onClick","javascript:if(confirm('Are you sure you want to save then changes made ?')==false) return false;")
    
        if page.isPostBack = false then
            if dtgPartWithSource.items.count = 0 then
                dtgPartWithSource.visible = false
                cmdBack.visible = false
                cmdUpdate.visible = false
            else
                dtgPartWithSource.visible = true
                cmdBack.visible = true
                cmdUpdate.visible = true
            End if
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
    
    Sub LoadPOMain()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsPO as SQLDataReader = ReqCOM.ExeDataReader("Select * from PO_M where PO_NO = '" & trim(cmbPONo.selecteditem.value) & "';")
    
        Do while rsPO.read
            lblPODate.text = format(rsPO("PO_DATE"),"MM/dd/yy")
            lblSupplierID.text = rsPO("VEN_CODE").tostring
            'lblSupplierName.text = rsPO("VEN_Name").tostring
            lblSupplierName.text = ReqCOM.GetFieldVal("Select Ven_Name from Vendor where Ven_Code = '" & trim(lblSupplierID.text) & "';","Ven_Name")
        loop
    End sub
    
    Sub LoadPODet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update PO_D set Sch_Date = Del_Date where Sch_Date is null and po_no = '" & trim(cmbPONo.selecteditem.value) & "';")
        Dim StrSql as string = "Select PO.Sch_Date,PO.SEQ_NO,PM.M_PART_NO, PM.PART_DESC,PM.PART_SPEC, PO.PO_NO,PO.PART_NO,PO.DEL_DATE,PO.ORDER_QTY,PO.UP from PO_D PO,PART_MASTER PM where PO.PO_NO = '" & trim(cmbPONo.selecteditem.value) & "' AND PO.PART_NO = PM.PART_NO"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"PO_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("PO_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        LoadPODet()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(4).Text = format(cdate(e.Item.Cells(4).Text),"MM/dd/yy")
            Dim SchDate As Textbox = CType(e.Item.FindControl("SchDate"), Textbox)
            if trim(SchDate.text) <> "" then SchDate.text = cdate(SchDate.text)
        End if
    End Sub
    
    Sub cmbPONo_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadPOMain()
        LoadPODet()
    
        if dtgPartWithSource.items.count = 0 then
    
            dtgPartWithSource.visible = false
            cmdBack.visible = false
            cmdUpdate.visible = false
        else
    
            dtgPartWithSource.visible = true
            cmdBack.visible = true
            cmdUpdate.visible = true
        End if
    
    
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ValETADATE(sender As Object, e As ServerValidateEventArgs)
        Dim i As Integer
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Dim SchDate As Textbox = CType(dtgPartWithSource.Items(i).FindControl("SchDate"), Textbox)
            dtgPartWithSource.Items(i).CssClass = ""
            if SchDate.text <> "" then
                if isdate(SchDate.text) = false then e.isvalid = false:dtgPartWithSource.Items(i).CssClass = "PartSource"
            End if
        Next
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i As Integer
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Dim SchDate As TextBox = CType(dtgPartWithSource.Items(i).FindControl("SchDate"), TextBox)
            Dim SeqNo As Label = CType(dtgPartWithSource.Items(i).FindControl("SeqNo"), Label)
    
            if SchDate.text <> "" then
                ReqCOM.executeNonQuery("Update PO_D set Sch_Date = '" & cdate(SchDate.text) & "' where Seq_No = " & SeqNo.text & ";")
            End if
    
        Next
        'LoadPODet
        Response.redirect("PODateConfirmation.aspx")
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        cmbPONo.items.clear
        Dissql("Select PO_NO from po_m where po_no like '%" & trim(txtSearch.text) & "%' order by po_no desc","po_no","po_no",cmbPONo)
        txtSearch.text = "-- Search --"
    
        if cmbPONo.selectedindex = 0 then
            LoadPOMain()
            LoadPODet()
        end if
    
        if dtgPartWithSource.items.count = 0 then
    
            dtgPartWithSource.visible = false
            cmdBack.visible = false
            cmdUpdate.visible = false
        else
    
            dtgPartWithSource.visible = true
            cmdBack.visible = true
            cmdUpdate.visible = true
        End if
    End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0">
    <%@ import Namespace="System" %>
    <%@ import Namespace="System.configuration" %>
    <%@ import Namespace="System.data.sqlclient" %>
    <%@ import Namespace="System.Collections" %>
    <%@ import Namespace="System.Text" %>
    <%@ import Namespace="System.Web.UI.WebControls" %>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">Purchase Order
                                Details.</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="80%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="137px" cssclass="LabelNormal">P/O No</asp:Label></td>
                                                                <td width="75%" colspan="5">
                                                                    <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearch)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbPONo" runat="server" Width="316px" CssClass="OutputText" OnSelectedIndexChanged="cmbPONo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" width="137px" cssclass="LabelNormal">P/O Date</asp:Label></td>
                                                                <td colspan="5">
                                                                    <asp:Label id="lblPODate" runat="server" width="137px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="137px" cssclass="LabelNormal">Supplier
                                                                    Name</asp:Label></td>
                                                                <td colspan="5">
                                                                    <asp:Label id="lblSupplierID" runat="server" width="" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    &nbsp;<asp:Label id="lblSupplierName" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="" visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_DESC" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_SPEC" HeaderText="SPECIFICATION"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Del_Date" HeaderText="ETA"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Order Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="OrderQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Sch.Date">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="SchDate" runat="server" align="right" Columns="10" MaxLength="10" Text='<%# DataBinder.Eval(Container.DataItem, "Sch_Date") %>' width="70px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="126px" Text="Save Changes"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="126px" CausesValidation="False" Text="Cancel"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
