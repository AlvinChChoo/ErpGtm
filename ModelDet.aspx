<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            Dissql ("Select Prod_Type_Code,Prod_Type_Code + '|' + Prod_Type_Desc as [Desc] from Prod_Type order by Prod_Type_Code asc","Prod_Type_Code","Desc",cmbProdType)
            ProcLoadModelDetail
            procLoadGridData ("Select * from Model_Feature_List where Model_Code = '" & lblModelCode.text & "';","Model_Feature_List",dtgModelFeature)
            procLoadGridData ("Select * from Model_Pic where Model_Code = '" & lblModelCode.text & "';","Model_Pic",MyList)
            if dtgModelFeature.items.count = 0 then lblFeature.visible = true: dtgModelFeature.visible = false else lblFeature.visible = false: dtgModelFeature.visible = true
            if MyList.items.count = 0 then lblModelPic.visible = true: MyList.visible = false else lblModelPic.visible = false: MyList.visible = true
    
            if ReqCOM.FuncCheckDuplicate("Select Top 1 Lot_No from SO_Models_M where Model_No = '" & trim(lblModelCode.text) & "';","Lot_NO") = true then
                cmdREmove.enabled = false
            else
                cmdREmove.enabled = true
            end if
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
            txtModelDesc.text=ResExeDataReader("Model_Desc").tostring
            lblCreateBy.text=ResExeDataReader("Create_By").tostring
            if isdbnull(ResExeDataReader("Create_Date")) = false then lblCreateDate.text=format(ResExeDataReader("Create_Date"),"MM/dd/yy")
            lblModifyBy.text=ResExeDataReader("Modify_By").tostring
            if isdbnull(ResExeDataReader("Modify_Date")) = false then lblModifyDate.text=format(ResExeDataReader("Modify_Date"),"MM/dd/yy")
            txtCustPartNo.text=ResExeDataReader("Cust_Part_No").tostring
        loop
        CustCode = ReqExeDataReader.GetFieldVal("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust where Cust_Code = '" & CustCode & "';","Desc").tostring
        If Not (cmbCustCode.Items.FindByText(CustCode.tostring)) Is Nothing Then cmbCustCode.Items.FindByText(CustCode.tostring).Selected = True
        Dissql ("Select Prod_Type_Code,Prod_Type_Code + '|' + Prod_Type_Desc as [Desc] from Prod_Type order by Prod_Type_Code asc","Prod_Type_Code","Desc",cmbProdType)
        ProdType = ReqExeDataReader.GetFieldVal("Select Prod_Type_Code,Prod_Type_Code + '|' + Prod_Type_Desc as [Desc] from Prod_Type where Prod_Type_Code = '" & ProdType & "';","Desc").tostring
        If Not (cmbProdType.Items.FindByText(ProdType.tostring)) Is Nothing Then cmbProdType.Items.FindByText(ProdType.tostring).Selected = True
    end sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim strSql as string
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
            StrSql = "Update Model_Master "
            StrSql = StrSql + "set Model_Code='" & trim(lblModelCode.text) & "', "
            StrSql = StrSql + "Cust_Part_No='" & trim(txtCustPartNo.text) & "', "
            StrSql = StrSql + "Cust_Code='" & trim(cmbCustCode.selectedItem.Value) & "',"
            StrSql = StrSql + "Brand_name='" & trim(txtBrandName.text) & "',"
            StrSql = StrSql + "Prod_Type_Code='" & trim(cmbProdType.selectedItem.value) & "',"
            StrSql = StrSql + "Model_Grp='" & trim(txtModelGrp.text) & "',"
            StrSql = StrSql + "PartList_No='" & trim(txtPartListNo.text) & "',"
            StrSql = StrSql + "Model_Desc='" & trim(txtmodelDesc.text) & "',"
            StrSql = StrSql + "Modify_By='" & trim(Request.cookies("U_ID").value) & "',"
            StrSql = StrSql + "Modify_Date='" & now & "' "
            StrSql = StrSql + "where Seq_No = " & request.params("ID") & ""
            ReqCOM.ExecuteNonQuery(StrSQL)
            Response.redirect("ModelDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Model.aspx")
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
    
    Sub cmdREmove_Click(sender As Object, e As EventArgs)
        Dim REqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCom.ExecuteNonQuery("Delete from Model_Master where model_code = '" & trim(lblModelCode.text) & "';")
        response.redirect("Model.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <erp:HEADER id="UserControl1" runat="server"></erp:HEADER>
                            </div>
                            <div align="center">
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" ControlToValidate="cmbCustCode" ErrorMessage="You don't seem to have supplied a valid Customer Code." Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator8" runat="server" ControlToValidate="cmbProdtype" ErrorMessage="You don't seem to have supplied a valid Product Type" Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator9" runat="server" ControlToValidate="txtBrandName" ErrorMessage="You don't seem to have supplied a valid Brand Name" Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" ControlToValidate="txtModelDesc" ErrorMessage="You don't seem to have supplied a valid Model Description" Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator11" runat="server" ControlToValidate="txtModelGrp" ErrorMessage="You don't seem to have supplied a valid Model Group" Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator12" runat="server" ControlToValidate="txtPartListNo" ErrorMessage="You don't seem to have supplied a valid Part List No" Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                </div>
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Model Details</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <br />
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="98%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px">Model Code</asp:Label></td>
                                                                                    <td width="75%" colspan="3">
                                                                                        <p>
                                                                                            <asp:Label id="lblModelCode" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="131px">Description</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <p>
                                                                                            <asp:TextBox id="txtModelDesc" runat="server" CssClass="Input_Box" Width="513px"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="54px">Customer</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DropDownList id="cmbCustCode" runat="server" CssClass="Input_Box" Width="345px"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Customer Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtCustPartNo" runat="server" CssClass="Input_Box" Width="345px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="105px">Partlist
                                                                                        No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtPartListNo" runat="server" CssClass="Input_Box" Width="345px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="121px">Brand Name</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtBrandName" runat="server" CssClass="Input_Box" Width="345px"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="122px">Model Group</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtModelGrp" runat="server" CssClass="Input_Box" Width="345px"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="99px">Product
                                                                                        Type</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DropDownList id="cmbProdtype" runat="server" CssClass="Input_Box" Width="345px"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="106px">Created
                                                                                        By/Date</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="131px">Revised
                                                                                        By/Date</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblModifyBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;-&nbsp;<asp:Label id="lblModifyDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Model Feature List</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="lblFeature" runat="server" cssclass="ErrorText" width="98%">No
                                                                        feature available for this product.</asp:Label> 
                                                                        <p>
                                                                            <br />
                                                                            <asp:DataGrid id="dtgModelFeature" runat="server" width="98%" ShowHeader="False" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" AutoGenerateColumns="False" ShowFooter="False" cellpadding="4" GridLines="None" BorderColor="White" PageSize="20">
                                                                                <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                <Columns>
                                                                                    <asp:BoundColumn DataField="Feature" HeaderText="Feature(s)"></asp:BoundColumn>
                                                                                </Columns>
                                                                            </asp:DataGrid>
                                                                        </p>
                                                                        <p>
                                                                            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="98%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server">Click here</asp:LinkButton>
                                                                                            &nbsp; <asp:Label id="Label12" runat="server" cssclass="LabelNormal">to add new /
                                                                                            remove product feature.</asp:Label></td>
                                                                                        <td>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Model&nbsp;Picture</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">&nbsp; 
                                                                        <div align="left"><asp:Label id="lblModelPic" runat="server" cssclass="ErrorText" width="100%">No
                                                                            image available for this product.</asp:Label>
                                                                        </div>
                                                                        <div align="center">
                                                                            <asp:DataList id="MyList" runat="server" Width="610px" OnItemCommand="ShowSelection" RepeatColumns="3" BorderWidth="0px">
                                                                                <ItemTemplate>
                                                                                    <table width="100%" border="0">
                                                                                        <tr>
                                                                                            <td width="100%" valign="top" align="middle"></td>
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
                                                                        <div align="center">
                                                                            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:LinkButton id="lnlAddPic" onclick="lnlAddPic_Click" runat="server">Click here</asp:LinkButton>
                                                                                            &nbsp; <asp:Label id="Label14" runat="server" cssclass="LabelNormal">to add new new
                                                                                            / remove product image.</asp:Label></td>
                                                                                        <td>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p>
                                                        <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <p>
                                                                            <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="161px" Text="Update Model Details"></asp:Button>
                                                                        </p>
                                                                    </td>
                                                                    <td>
                                                                        <div align="center">
                                                                            <asp:Button id="cmdREmove" onclick="cmdREmove_Click" runat="server" Width="136px" Text="Remove this model"></asp:Button>
                                                                        </div>
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
                            </div>
                            <footer:footer id="footer" runat="server"></footer:footer>
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
