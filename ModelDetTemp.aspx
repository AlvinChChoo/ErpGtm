<%@ Page Language="VB" Debug="TRUE" %>
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
            Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            Dissql ("Select Prod_Type_Code,Prod_Type_Code + '|' + Prod_Type_Desc as [Desc] from Prod_Type order by Prod_Type_Code asc","Prod_Type_Code","Desc",cmbProdType)
            ProcLoadModelDetail
            procLoadGridData ("Select * from Model_Feature_List where Model_Code = '" & lblModelCode.text & "';","Model_Feature_List",dtgModelFeature)
            procLoadGridData ("Select * from Model_Color where Model_Code = '" & lblModelCode.text & "';","Model_Color",dtgModelColor)
            procLoadGridData ("Select * from Model_Pic where Model_Code = '" & lblModelCode.text & "';","Model_Pic",MyList)
        end if
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
    
    Sub ProcLoadGridData(StrSql as string,TableName as string,ObjectName as object)
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,TableName)
        ObjectName.DataSource=resExePagedDataSet.Tables(TableName).DefaultView
        ObjectName.DataBind()
    end sub
    
    
    Sub ProcLoadModelDetail
        Dim StrSql as string
        StrSQL = "Select * from Model_Master where Seq_No = " & request.params("ID") & ";"
    
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
        Dim CustCode,ProdType as string
        do while ResExeDataReader.read
            lblModelCode.text=ResExeDataReader("Model_Code").tostring
            CustCode = ResExeDataReader("Cust_Code").tostring
            txtBrandName.text=ResExeDataReader("Brand_name").tostring
            ProdType = ResExeDataReader("Prod_Type_Code").tostring
            txtModelGrp.text=ResExeDataReader("Model_Grp").tostring
            txtPartListNo.text=ResExeDataReader("PartList_No").tostring
            txtRevNo.text=ResExeDataReader("Revision_No").tostring
            lblModelDesc.text=ResExeDataReader("Model_Desc").tostring
    
            lblCreateBy.text=ResExeDataReader("Create_By").tostring
            if isdbnull(ResExeDataReader("Create_Date")) = false then lblCreateDate.text=format(ResExeDataReader("Create_Date"),"MM/dd/yy")
            lblModifyBy.text=ResExeDataReader("Modify_By").tostring
            if isdbnull(ResExeDataReader("Modify_Date")) = false then lblModifyDate.text=format(ResExeDataReader("Modify_Date"),"MM/dd/yy")
    
         loop
        CustCode = ReqExeDataReader.GetFieldVal("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust where Cust_Code = '" & CustCode & "';","Desc").tostring
        If Not (cmbCustCode.Items.FindByText(CustCode.tostring)) Is Nothing Then cmbCustCode.Items.FindByText(CustCode.tostring).Selected = True
    
        Dissql ("Select Prod_Type_Code,Prod_Type_Code + '|' + Prod_Type_Desc as [Desc] from Prod_Type order by Prod_Type_Code asc","Prod_Type_Code","Desc",cmbProdType)
    
        ProdType = ReqExeDataReader.GetFieldVal("Select Prod_Type_Code,Prod_Type_Code + '|' + Prod_Type_Desc as [Desc] from Prod_Type where Prod_Type_Code = '" & ProdType & "';","Desc").tostring
        If Not (cmbProdType.Items.FindByText(ProdType.tostring)) Is Nothing Then cmbProdType.Items.FindByText(ProdType.tostring).Selected = True
    end sub
    
    Sub cmdFeatureList_Click(sender As Object, e As EventArgs)
        response.redirect("ModelFeatureList.aspx?ID=" + request.params("ID"))
    End Sub
    
    Sub cmdModelColor_Click(sender As Object, e As EventArgs)
        response.redirect("ModelColor.aspx?ID=" + request.params("ID"))
    End Sub
    
    Sub cmdPic_Click(sender As Object, e As EventArgs)
        response.redirect("ModelPic.aspx?ID=" + request.params("ID"))
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim strSql as string
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
        StrSql = "Update Model_Master "
        StrSql = StrSql + "set Model_Code='" & trim(lblModelCode.text) & "', "
        StrSql = StrSql + "Cust_Code='" & trim(cmbCustCode.selectedItem.Value) & "',"
        StrSql = StrSql + "Brand_name='" & trim(txtBrandName.text) & "',"
        StrSql = StrSql + "Prod_Type_Code='" & trim(cmbProdType.selectedItem.value) & "',"
        StrSql = StrSql + "Model_Grp='" & trim(txtModelGrp.text) & "',"
        StrSql = StrSql + "PartList_No='" & trim(txtPartListNo.text) & "',"
        StrSql = StrSql + "Model_Desc='" & trim(lblmodelDesc.text) & "',"
        StrSql = StrSql + "Modify_By='" & trim(Request.cookies("U_ID").value) & "',"
        StrSql = StrSql + "Modify_Date='" & now & "',"
        StrSql = StrSql + "Revision_No=" & trim(txtRevNo.text) & " "
        StrSql = StrSql + "where Seq_No = " & request.params("ID") & ""
        'response.write (StrSql)
        ReqCOM.ExecuteNonQuery(StrSQL)
        Response.redirect("ModelDet.aspx?ID=" & Request.params("ID"))
    
    End Sub
    
    Sub cmdList_Click(sender As Object, e As EventArgs)
        response.redirect("Model.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Model.aspx")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
    
        end sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">MODEL
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="HEIGHT: 27px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 87px" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label2" runat="server" width="128px" cssclass="LabelNormal">Model Code</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <p>
                                                                                            <asp:Label id="lblModelCode" runat="server" width="470px" cssclass="OutputText"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label3" runat="server" width="131px" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <p>
                                                                                            <asp:Label id="lblModelDesc" runat="server" width="470px" cssclass="OutputText"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label4" runat="server" width="54px" cssclass="LabelNormal">Customer</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DropDownList id="cmbCustCode" runat="server" Width="470px" CssClass="OutputText"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label5" runat="server" width="130px" cssclass="LabelNormal">Revision
                                                                                        No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtRevNo" runat="server" Width="470px" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label6" runat="server" width="105px" cssclass="LabelNormal">Partlist
                                                                                        No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtPartListNo" runat="server" Width="470px" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label7" runat="server" width="121px" cssclass="LabelNormal">Brand Name</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtBrandName" runat="server" Width="470px" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label8" runat="server" width="122px" cssclass="LabelNormal">Model Group</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtModelGrp" runat="server" Width="470px" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label9" runat="server" width="99px" cssclass="LabelNormal">Product
                                                                                        Type</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DropDownList id="cmbProdtype" runat="server" Width="470px" CssClass="OutputText"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label10" runat="server" width="106px" cssclass="LabelNormal">Created
                                                                                        By/Date</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblCreateBy" runat="server" width="177px" cssclass="OutputText"></asp:Label><asp:Label id="lblCreateDate" runat="server" width="177px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label11" runat="server" width="131px" cssclass="LabelNormal">Revised
                                                                                        By/Date</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblModifyBy" runat="server" width="177px" cssclass="OutputText"></asp:Label><asp:Label id="lblModifyDate" runat="server" width="177px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="161px" Text="Update Model Details"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p class="Instruction" align="center">
                                                                        FEATURE LIST 
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:DataGrid id="dtgModelFeature" runat="server" width="100%" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="False" AutoGenerateColumns="False" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="Feature" HeaderText="Feature(s)"></asp:BoundColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdFeatureList" onclick="cmdFeatureList_Click" runat="server" Width="128px" Text="Add / Edit" CausesValidation="False"></asp:Button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p class="Instruction" align="center">
                                                                        MODEL COLOR 
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:DataGrid id="dtgModelColor" runat="server" width="100%" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="Color_Desc" HeaderText="Model Colors"></asp:BoundColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdModelColor" onclick="cmdModelColor_Click" runat="server" Width="128px" Text="Add / Edit" CausesValidation="False"></asp:Button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 3px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p class="Instruction" align="center">
                                                                        MODEL PICTURE 
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:DataList id="MyList" runat="server" Width="610px" BorderWidth="0px" RepeatColumns="3" OnItemCommand="ShowSelection">
                                                                            <ItemTemplate>
                                                                                <table width="100%" border="1">
                                                                                    <tr>
                                                                                        <td width="100%" valign="top" align="middle">
                                                                                            <a href="javascript:ShowPic('<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>')"><img style="WIDTH: 100px; HEIGHT: 100px" height="21" src='<%# Container.DataItem( "Pic_Path" )%>' width="24" align="absBottom" border="0" /></a> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="100%" valign="top" align="middle">
                                                                                            <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Pic_Desc") %>' /> 
                                                                                            <br />
                                                                                        </td>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </ItemTemplate>
                                                                        </asp:DataList>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdPic" onclick="cmdPic_Click" runat="server" Width="128px" Text="Add / Edit" CausesValidation="False"></asp:Button>
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
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
                            <p align="center">
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
