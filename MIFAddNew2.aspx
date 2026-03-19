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
            Dim RsMIF as SQLDataReader = ReqCOM.exeDataReader("Select * from MIF_M_Temp where Seq_No = " & Request.params("ID") & ";")
    
            Do while rsMIF.read
    
                lblMIFDate.text = rsMIF("MIF_DATE").tostring
                lblInvNo.text = rsMIF("INV_NO").tostring
                lblSupplier.text = rsMIF("VEN_CODE").tostring
                txtRem.text = rsMIF("REM").tostring
                lblDONo.text = rsMIF("DO_NO").tostring
                lblCustomFormNo.text = rsMIF("CUSTOM_FORM_NO").tostring
            Loop
            LoadDataWithSource()
            ShowMifDet()
        end if
    End Sub
    
    Sub LoadDataWithSource()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim MIFNo as string = ReqCOM.GetFieldVal("Select MIF_NO from MIF_M where Seq_No = " & request.params("ID") & ";","MIF_NO")
        Dim StrSql as string = "Select MIF.PO_NO,MIF.PART_NO,MIF.IN_QTY,PM.PART_DESC from MIF_D MIF,PART_MASTER PM where MIF.MIF_NO = '" & MIFNo & "' AND MIF.PART_NO = PM.PART_NO;"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MIF_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(3).Text = format(cdate(e.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = cint(E.Item.Cells(4).Text)
            'Dim InQty As Label = CType(e.Item.FindControl("InQty"), Label)
            'InQty.text = cint(InQty.text)
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        LoadDataWithSource()
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
    
    Sub DropDownList1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowMifDet()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select MIF.DEl_Date,MIF.PO_NO,MIF.PART_NO,MIF.IN_QTY,MIF.BAL_QTY,MIF.SEQ_NO,PM.Part_Desc from MIF_D_TEMP MIF, Part_Master PM where MIF.U_ID = '" & trim(Request.cookies("U_ID").value) & "' and PM.Part_No = MIf.Part_No order by MIF.Seq_No asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MIF_D_TEMP")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_D_TEMP").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub cmdProceed_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim MIFNo as string = ReqCOM.GetDocumentNo("MIF_No")
    
        try
            StrSql = "Insert into MIF_M(MIF_NO,VEN_CODE,MIF_DATE,CUSTOM_FORM,GPB_NO,INV_NO,LOCATION,REM,CUSTOM_FORM_NO,DO_NO,IQC_APP_BY,IQC_APP_DATE,REC_STORE_APP_BY,REC_STORE_APP_DATE) "
            StrSql = StrSql + "Select '" & trim(MIFNo) & "',VEN_CODE,MIF_DATE,CUSTOM_FORM,GPB_NO,INV_NO,LOCATION,REM,CUSTOM_FORM_NO,DO_NO,IQC_APP_BY,IQC_APP_DATE,REC_STORE_APP_BY,REC_STORE_APP_DATE from MIF_M_TEMP where U_ID = '" & trim(request.cookies("U_ID").value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Insert into MIF_D(MIF_NO,PO_NO,PART_NO,IN_QTY,Del_Date,date_receive) select '" & trim(MIFNo) & "',PO_NO,PART_NO,IN_QTY,Del_Date,date_receive from MIF_D_TEMP where U_ID = '" & trim(request.cookies("U_ID").value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update Part_Master set Part_Master.IQC_BAL = Part_Master.IQC_BAL + MIF_D_TEMP.IN_QTY, Part_Master.OPEN_PO = Part_Master.OPEN_PO - MIF_D_TEMP.IN_QTY FROM MIF_D_TEMP, PART_MASTER WHERE MIF_D_TEMP.U_ID = '" & TRIM(Request.cookies("U_ID").value) & "' and MIF_D_TEMP.Part_NO = Part_Master.Part_No"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update PO_D set PO_D.In_Qty = PO_D.In_Qty + MIF_D_TEMP.IN_QTY from MIF_D_TEMP,PO_D where MIF_D_TEMP.U_ID = '" & trim(request.cookies("U_ID").value) & "' and po_d.po_no = mif_D_temp.po_no and po_d.part_no = mif_D_temp.part_no and po_d.del_date = mif_D_temp.del_date"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Insert into IQC_Movement(PART_NO,REF,QTY_IN,QTY_OUT,TRANS_TYPE,TRANS_DATE) "
            StrSql = StrSql + "Select PART_NO,'" & trim(MIFNo) & "',IN_QTY,0,'IQC','" & now & "' from MIF_D_TEMP where U_ID = '" & trim(Request.cookies("U_ID").value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Delete from MIF_D_TEMP where U_ID = '" & trim(Request.cookies("U_ID").value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Delete from MIF_M_TEMP where U_ID = '" & trim(Request.cookies("U_ID").value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            ReqCOM.executeNonQuery("Update Main set MIF_NO = MIF_NO + 1")
    
            response.redirect("MIFAddNew3.aspx?ID=" & Request.params("ID"))
        Catch err as exception
            response.write(Err.tostring)
        End try
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("MIFAddNew1.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQUery("Delete from MIF_D_TEMP where U_ID = '" & trim(Request.cookies("U_ID").value) & "';")
        Response.redirect("MIF.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">MATERIAL INCOMING
                                FORM (MIF)</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="HEIGHT: 77px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="142px">MIF Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFDate" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="142px">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSupplier" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="142px">Invoice
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblInvNo" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="142px">D/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDONo" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="142px">Custom
                                                                    Form No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCustomFormNo" runat="server" cssclass="OutputText" width="402px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="142px">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="402px" Height="78px" TextMode="MultiLine" ReadOnly="True"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" ShowFooter="True" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PO_NO" HeaderText="P/O No."></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_dESC" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Del_Date" HeaderText="ETA Date">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="IN_QTY" HeaderText="In Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" cssclass="Instruction">Are you sure to save
                                                    these items ?</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <p align="center">
                                                                            <asp:Button id="cmdProceed" onclick="cmdProceed_Click" runat="server" Width="95px" Text="Yes"></asp:Button>
                                                                            &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                            <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="95px" Text="No"></asp:Button>
                                                                            &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="95px" Text="Back"></asp:Button>
                                                                            &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        </p>
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
